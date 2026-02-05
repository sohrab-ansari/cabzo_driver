import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for SystemChrome
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({Key? key}) : super(key: key);

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  String? _agreementUrl;
  bool _isLoading = true;
  String? _errorMessage;
  String? _localFilePath;
  int? _totalPages;
  int? _currentPage;
  PDFViewController? _pdfViewController;
  bool _downloading = false;
  bool _permissionGranted = false;
  SystemUiOverlayStyle? _originalStyle; // Store original status bar style

  @override
  void initState() {
    super.initState();
    // Store the current system UI overlay style
    _originalStyle = SystemChrome.latestStyle;
    // Set dark status bar icons for this screen
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _fetchCompanyData();
  }

  @override
  void dispose() {
    // Restore original system UI overlay style when leaving
    if (_originalStyle != null) {
      SystemChrome.setSystemUIOverlayStyle(_originalStyle!);
    }
    super.dispose();
  }

  Future<void> _fetchCompanyData() async {
    print('📄 Fetching company data...');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      const String apiUrl =
          'http://api.corezap.framekarts.com/api/v1/company/getCompany';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final agreementPath = data['data']['agreement'] ?? '';

          if (agreementPath.isNotEmpty) {
            const storageBaseUrl =
                'https://sgp1.digitaloceanspaces.com/satyakabir-bucket/';
            final fullUrl = storageBaseUrl + agreementPath;

            print('📄 Agreement URL: $fullUrl');

            setState(() {
              _agreementUrl = fullUrl;
            });

            // Download the PDF file
            await _downloadPdfForViewing();
          } else {
            setState(() {
              _errorMessage = 'No agreement available';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Failed to fetch agreement';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'HTTP Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPdfForViewing() async {
    if (_agreementUrl == null) return;

    try {
      print('📄 Downloading PDF for viewing...');

      final response = await http.get(Uri.parse(_agreementUrl!));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/agreement_temp.pdf');

        await file.writeAsBytes(bytes);

        print('📄 PDF saved to: ${file.path}');

        setState(() {
          _localFilePath = file.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to download PDF';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Download Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        // Show dialog to open app settings
        _showPermissionDialog();
        return false;
      }

      status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need storage permission for app directories
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permission is required to download files. Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPdfToDevice() async {
    if (_agreementUrl == null) return;

    // Request permission
    bool hasPermission = await _requestStoragePermission();
    // if (!hasPermission) {
    //   _showToast('Storage permission required');
    //   return;
    // }

    try {
      setState(() {
        _downloading = true;
      });

      print('📄 Downloading PDF to device...');

      final response = await http.get(Uri.parse(_agreementUrl!));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        Directory? downloadDir;

        if (Platform.isAndroid) {
          // Try multiple locations
          try {
            downloadDir = Directory('/storage/emulated/0/Download');
            if (!await downloadDir.exists()) {
              downloadDir = await getExternalStorageDirectory();
            }
          } catch (e) {
            downloadDir = await getApplicationDocumentsDirectory();
          }
        } else {
          downloadDir = await getApplicationDocumentsDirectory();
        }

        if (downloadDir != null && await downloadDir.exists()) {
          final uri = Uri.parse(_agreementUrl!);
          final filename = uri.pathSegments.last;
          final filePath = '${downloadDir.path}/$filename';
          final file = File(filePath);

          await file.writeAsBytes(bytes);

          print('📄 PDF saved to: $filePath');

          _showToast('PDF downloaded successfully!');

          // Try to open the file
          try {
            final result = await OpenFile.open(filePath);
            print('Open file result: ${result.type} - ${result.message}');
          } catch (e) {
            print('Error opening file: $e');
          }
        }
      }
    } catch (e) {
      _showToast('Download failed: ${e.toString()}');
    } finally {
      setState(() {
        _downloading = false;
      });
    }
  }

  Future<void> _openPdfInExternalViewer() async {
    if (_agreementUrl == null) return;

    try {
      final result = await OpenFile.open(_agreementUrl!);
      print('Open PDF result: ${result.type} - ${result.message}');
    } catch (e) {
      _showToast('Could not open PDF: $e');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Driver Agreement',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      // Ensure dark status bar icons
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_agreementUrl != null && !_isLoading && _errorMessage == null)
          _downloading
              ? Container(
                  padding: const EdgeInsets.all(12.0),
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 2.0,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.download, color: Colors.blue),
                  tooltip: 'Download PDF',
                  onPressed: _downloadPdfToDevice,
                ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Loading agreement...',
            style: TextStyle(color: Colors.black87),
          ),
          if (_downloading) ...[
            const SizedBox(height: 20),
            const Text('Downloading PDF...'),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              _errorMessage ?? 'Error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchCompanyData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    if (_localFilePath == null) return _buildErrorScreen();

    return Column(
      children: [
        // Optional: Page indicator (commented out as in your original)
        /*
        if (_currentPage != null && _totalPages != null)
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage! > 1
                      ? () {
                          _pdfViewController?.setPage(_currentPage! - 1);
                        }
                      : null,
                  color: _currentPage! > 1 ? Colors.blue : Colors.grey,
                ),
                Text(
                  'Page $_currentPage of $_totalPages',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage! < _totalPages!
                      ? () {
                          _pdfViewController?.setPage(_currentPage! + 1);
                        }
                      : null,
                  color: _currentPage! < _totalPages! ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ),
        */

        // PDF Viewer
        Expanded(
          child: PDFView(
            filePath: _localFilePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            onRender: (pages) {
              setState(() {
                _totalPages = pages;
              });
            },
            onError: (error) {
              print('PDF Error: $error');
              setState(() {
                _errorMessage = 'Failed to load PDF';
              });
            },
            onPageError: (page, error) {
              print('Page $page Error: $error');
            },
            onViewCreated: (PDFViewController controller) {
              _pdfViewController = controller;
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page;
                _totalPages = total;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: _isLoading
          ? _buildLoadingScreen()
          : _errorMessage != null
          ? _buildErrorScreen()
          : _buildPdfViewer(),
    );
  }
}
