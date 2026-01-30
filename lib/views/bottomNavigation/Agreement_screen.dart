// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path_provider/path_provider.dart';
// // import 'dart:convert';

// // class AgreementScreen extends StatefulWidget {
// //   const AgreementScreen({Key? key}) : super(key: key);

// //   @override
// //   State<AgreementScreen> createState() => _AgreementScreenState();
// // }

// // class _AgreementScreenState extends State<AgreementScreen> {
// //   File? _agreementFile;
// //   bool _checked = false;
// //   bool _isLoading = false;
// //   bool _uploading = false;
  
// //   final ImagePicker _picker = ImagePicker();
  
// //   bool get _isDisabled => _agreementFile == null || !_checked || _isLoading || _uploading;

// //   Future<void> _pickImage() async {
// //     try {
// //       final XFile? image = await _picker.pickImage(
// //         source: ImageSource.gallery,
// //         maxWidth: 1200,
// //         maxHeight: 1200,
// //         imageQuality: 90,
// //       );
      
// //       if (image != null) {
// //         setState(() {
// //           _agreementFile = File(image.path);
// //         });
// //       }
// //     } catch (e) {
// //       print('Error picking image: $e');
// //       _showErrorDialog('Error', 'Failed to pick image. Please try again.');
// //     }
// //   }

// //   Future<void> _pickDocument() async {
// //     try {
// //       final XFile? file = await _picker.pickImage(
// //         source: ImageSource.gallery,
// //       );
      
// //       if (file != null) {
// //         setState(() {
// //           _agreementFile = File(file.path);
// //         });
// //       }
// //     } catch (e) {
// //       print('Error picking document: $e');
// //       _showErrorDialog('Error', 'Failed to pick document. Please try again.');
// //     }
// //   }

// //   Future<void> _showSourceDialog() async {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Select Source'),
// //         content: const Text('Choose how you want to get the agreement'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               _pickImage();
// //             },
// //             child: const Text('Gallery'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               // For PDF/document picker, you might need file_picker package
// //               _pickDocument();
// //             },
// //             child: const Text('Files'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _handleSubmit() async {
// //     if (_agreementFile == null) {
// //       _showErrorDialog('Error', 'Please upload the driver agreement');
// //       return;
// //     }

// //     if (!_checked) {
// //       _showErrorDialog('Error', 'Please agree to the Driver Agreement');
// //       return;
// //     }

// //     setState(() {
// //       _uploading = true;
// //     });

// //     try {
// //       print('📤 Submitting agreement as panImage field...');
      
// //       // Create multipart request
// //       var request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse('http://api.corezap.framekarts.com/api/v1/driver/updateDriver'), // Replace with your actual endpoint
// //       );
      
// //       // Add headers
// //       request.headers['Content-Type'] = 'multipart/form-data';
// //       // Add authorization if needed
// //       // request.headers['Authorization'] = 'Bearer YOUR_TOKEN_HERE';
      
// //       // Add file
// //       request.files.add(
// //         await http.MultipartFile.fromPath(
// //           'panImage', // Using panImage field as per your API
// //           _agreementFile!.path,
// //           filename: 'agreement_${DateTime.now().millisecondsSinceEpoch}.jpg',
// //           contentType: MediaType('image', 'jpeg'),
// //         ),
// //       );
      
// //       // Add other fields if needed
// //       // request.fields['driverId'] = 'YOUR_DRIVER_ID';
      
// //       print('Sending request...');
      
// //       // Send request
// //       var streamedResponse = await request.send();
// //       var response = await http.Response.fromStream(streamedResponse);
      
// //       print('Response status: ${response.statusCode}');
// //       print('Response body: ${response.body}');
      
// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
        
// //         if (responseData['success'] == true) {
// //           print('✅ Agreement submitted successfully: ${responseData['message']}');
// //           _showSuccessDialog();
// //         } else {
// //           throw Exception(responseData['message'] ?? 'Submission failed');
// //         }
// //       } else {
// //         throw Exception('Server error: ${response.statusCode}');
// //       }
// //     } catch (error) {
// //       print('❌ Agreement submission error: $error');
      
// //       String errorMessage = 'Failed to submit agreement. Please try again.';
// //       if (error.toString().contains('SocketException') || error.toString().contains('Connection')) {
// //         errorMessage = 'Network error. Please check your internet connection.';
// //       }
      
// //       _showErrorDialog('Error', errorMessage);
// //     } finally {
// //       setState(() {
// //         _uploading = false;
// //       });
// //     }
// //   }

// //   void _showErrorDialog(String title, String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text(title),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('OK'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showSuccessDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Success'),
// //         content: const Text('Driver agreement submitted successfully!'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context); // Close dialog
// //               Navigator.pop(context); // Go back to previous screen
// //             },
// //             child: const Text('OK'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _viewAgreementPdf() async {
// //     // In a real app, you would:
// //     // 1. Download the PDF from the API endpoint
// //     // 2. Open it using a PDF viewer
    
// //     _showErrorDialog(
// //       'Info', 
// //       'The agreement has been sent to your registered email. '
// //       'Please check your email and download the agreement.'
// //     );
    
// //     // Example of opening a URL:
// //     // const url = 'http://api.corezap.framekarts.com/api/v1/company/agreement';
// //     // if (await canLaunch(url)) {
// //     //   await launch(url);
// //     // }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // Header
// //             _buildHeader(),
            
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 physics: const BouncingScrollPhysics(),
// //                 child: Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Info Text
// //                       _buildInfoText(),
                      
// //                       const SizedBox(height: 20),
                      
// //                       // View Agreement Button
// //                       _buildViewAgreementButton(),
                      
// //                       const SizedBox(height: 20),
                      
// //                       // Upload Box
// //                       _buildUploadBox(),
                      
// //                       const SizedBox(height: 24),
                      
// //                       // Checkbox
// //                       _buildCheckbox(),
                      
// //                       const SizedBox(height: 40),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
            
// //             // Submit Button
// //             _buildSubmitButton(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeader() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 4,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           IconButton(
// //             icon: const Icon(
// //               Icons.arrow_back_ios_new_rounded,
// //               size: 20,
// //             ),
// //             onPressed: () => Navigator.pop(context),
// //             color: const Color(0xFF333333),
// //           ),
// //           const SizedBox(width: 8),
// //           const Text(
// //             'Driver Agreement',
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.w600,
// //               color: Color(0xFF333333),
// //               fontFamily: 'Poppins',
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildInfoText() {
// //     return Container(
// //       margin: const EdgeInsets.only(top: 20),
// //       child: const Text(
// //         'Please review and upload the driver agreement to activate your account.',
// //         style: TextStyle(
// //           fontSize: 14,
// //           color: Color(0xFF666666),
// //           height: 1.5,
// //           fontFamily: 'Poppins',
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildViewAgreementButton() {
// //     return GestureDetector(
// //       onTap: _viewAgreementPdf,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFE8F4FF),
// //           borderRadius: BorderRadius.circular(8),
// //           border: Border.all(
// //             color: const Color(0xFF4A90E2),
// //             width: 1,
// //           ),
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(
// //               Icons.description,
// //               color: const Color(0xFF4A90E2),
// //               size: 24,
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'View Agreement',
// //                     style: TextStyle(
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.w600,
// //                       color: const Color(0xFF333333),
// //                       fontFamily: 'Poppins',
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     'Download and review the agreement document',
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: const Color(0xFF666666),
// //                       fontFamily: 'Poppins',
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Icon(
// //               Icons.chevron_right,
// //               color: const Color(0xFF4A90E2),
// //               size: 24,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildUploadBox() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'Upload Signed Agreement',
// //           style: TextStyle(
// //             fontSize: 16,
// //             fontWeight: FontWeight.w600,
// //             color: const Color(0xFF333333),
// //             fontFamily: 'Poppins',
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           'Upload a scanned copy or photo of your signed agreement',
// //           style: TextStyle(
// //             fontSize: 13,
// //             color: const Color(0xFF666666),
// //             fontFamily: 'Poppins',
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         GestureDetector(
// //           onTap: _showSourceDialog,
// //           child: Container(
// //             height: 192,
// //             width: double.infinity,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(
// //                 color: _agreementFile != null 
// //                     ? const Color(0xFF4CAF50) 
// //                     : const Color(0xFFDDDDDD),
// //                 width: _agreementFile != null ? 2 : 1.5,
// //               ),
// //               color: _agreementFile != null 
// //                   ? const Color(0xFFF0F9F0) 
// //                   : const Color(0xFFFAFAFA),
// //               boxShadow: _agreementFile != null
// //                   ? [
// //                       BoxShadow(
// //                         color: const Color(0xFF4CAF50).withOpacity(0.1),
// //                         blurRadius: 8,
// //                         offset: const Offset(0, 2),
// //                       ),
// //                     ]
// //                   : [],
// //             ),
// //             child: _agreementFile != null
// //                 ? Stack(
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(12),
// //                         child: Image.file(
// //                           _agreementFile!,
// //                           width: double.infinity,
// //                           height: double.infinity,
// //                           fit: BoxFit.cover,
// //                           errorBuilder: (context, error, stackTrace) {
// //                             return Center(
// //                               child: Column(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 children: [
// //                                   Icon(
// //                                     Icons.description,
// //                                     size: 48,
// //                                     color: const Color(0xFF4A90E2),
// //                                   ),
// //                                   const SizedBox(height: 12),
// //                                   Text(
// //                                     'Document Selected',
// //                                     style: TextStyle(
// //                                       fontSize: 16,
// //                                       fontWeight: FontWeight.w600,
// //                                       color: const Color(0xFF333333),
// //                                       fontFamily: 'Poppins',
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(
// //                                     _agreementFile!.path.split('/').last,
// //                                     style: TextStyle(
// //                                       fontSize: 12,
// //                                       color: const Color(0xFF666666),
// //                                       fontFamily: 'Poppins',
// //                                     ),
// //                                     textAlign: TextAlign.center,
// //                                   ),
// //                                 ],
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                       Positioned(
// //                         top: 12,
// //                         right: 12,
// //                         child: Container(
// //                           padding: const EdgeInsets.all(6),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(20),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.black.withOpacity(0.1),
// //                                 blurRadius: 4,
// //                                 offset: const Offset(0, 2),
// //                               ),
// //                             ],
// //                           ),
// //                           child: Icon(
// //                             Icons.edit,
// //                             size: 18,
// //                             color: const Color(0xFF333333),
// //                           ),
// //                         ),
// //                       ),
// //                       Positioned(
// //                         bottom: 12,
// //                         left: 12,
// //                         right: 12,
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 12,
// //                             vertical: 6,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.9),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Text(
// //                             'Tap to change document',
// //                             textAlign: TextAlign.center,
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.w500,
// //                               color: const Color(0xFF333333),
// //                               fontFamily: 'Poppins',
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   )
// //                 : Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(
// //                         Icons.cloud_upload_outlined,
// //                         size: 48,
// //                         color: const Color(0xFF999999),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Text(
// //                         'Upload Agreement',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w600,
// //                           color: const Color(0xFF333333),
// //                           fontFamily: 'Poppins',
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 32),
// //                         child: Text(
// //                           'The agreement has been sent to your registered email. Kindly download it and upload here.',
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(
// //                             fontSize: 13,
// //                             color: const Color(0xFF666666),
// //                             height: 1.4,
// //                             fontFamily: 'Poppins',
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 20,
// //                           vertical: 8,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xFF4A90E2),
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                         child: Text(
// //                           'Choose File',
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w500,
// //                             color: Colors.white,
// //                             fontFamily: 'Poppins',
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           'Supported formats: JPG, PNG, PDF (Max 5MB)',
// //           style: TextStyle(
// //             fontSize: 12,
// //             color: const Color(0xFF999999),
// //             fontFamily: 'Poppins',
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildCheckbox() {
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           _checked = !_checked;
// //         });
// //       },
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           AnimatedContainer(
// //             duration: const Duration(milliseconds: 200),
// //             width: 20,
// //             height: 20,
// //             margin: const EdgeInsets.only(top: 2, right: 12),
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(4),
// //               border: Border.all(
// //                 color: _checked 
// //                     ? const Color(0xFF4A90E2) 
// //                     : const Color(0xFFCCCCCC),
// //                 width: _checked ? 0 : 1.5,
// //               ),
// //               color: _checked 
// //                   ? const Color(0xFF4A90E2) 
// //                   : Colors.transparent,
// //               boxShadow: _checked
// //                   ? [
// //                       BoxShadow(
// //                         color: const Color(0xFF4A90E2).withOpacity(0.3),
// //                         blurRadius: 4,
// //                         offset: const Offset(0, 2),
// //                       ),
// //                     ]
// //                   : [],
// //             ),
// //             child: _checked
// //                 ? const Icon(
// //                     Icons.check,
// //                     size: 14,
// //                     color: Colors.white,
// //                   )
// //                 : null,
// //           ),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'I have read and agree to the Driver Agreement.',
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w500,
// //                     color: const Color(0xFF333333),
// //                     height: 1.4,
// //                     fontFamily: 'Poppins',
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 GestureDetector(
// //                   onTap: _viewAgreementPdf,
// //                   child: Text(
// //                     'Read agreement terms',
// //                     style: TextStyle(
// //                       fontSize: 13,
// //                       color: const Color(0xFF4A90E2),
// //                       fontFamily: 'Poppins',
// //                       decoration: TextDecoration.underline,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSubmitButton() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         border: Border(
// //           top: BorderSide(
// //             color: Colors.grey[200]!,
// //             width: 1,
// //           ),
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 8,
// //             offset: const Offset(0, -2),
// //           ),
// //         ],
// //       ),
// //       child: SizedBox(
// //         width: double.infinity,
// //         height: 52,
// //         child: ElevatedButton(
// //           onPressed: _isDisabled ? null : _handleSubmit,
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: _isDisabled 
// //                 ? const Color(0xFFDDDDDD) 
// //                 : const Color(0xFF4A90E2),
// //             foregroundColor: _isDisabled 
// //                 ? const Color(0xFF999999) 
// //                 : Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             elevation: 0,
// //             shadowColor: Colors.transparent,
// //             padding: EdgeInsets.zero,
// //           ),
// //           child: _uploading
// //               ? Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     SizedBox(
// //                       width: 20,
// //                       height: 20,
// //                       child: CircularProgressIndicator(
// //                         strokeWidth: 2,
// //                         color: _isDisabled 
// //                             ? const Color(0xFF999999) 
// //                             : Colors.white,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Text(
// //                       'Uploading...',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         fontFamily: 'Poppins',
// //                       ),
// //                     ),
// //                   ],
// //                 )
// //               : Text(
// //                   _isLoading ? 'Submitting...' : 'Submit Agreement',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w600,
// //                     fontFamily: 'Poppins',
// //                   ),
// //                 ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AgreementScreen extends StatefulWidget {
//   const AgreementScreen({Key? key}) : super(key: key);

//   @override
//   State<AgreementScreen> createState() => _AgreementScreenState();
// }

// class _AgreementScreenState extends State<AgreementScreen> {
//   File? _agreementFile;
//   bool _checked = false;
//   bool _isLoading = false;
//   bool _uploading = false;
  
//   final ImagePicker _picker = ImagePicker();
  
//   bool get _isDisabled => _agreementFile == null || !_checked || _isLoading || _uploading;

//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1200,
//         maxHeight: 1200,
//         imageQuality: 90,
//       );
      
//       if (image != null) {
//         setState(() {
//           _agreementFile = File(image.path);
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//       _showErrorDialog('Error', 'Failed to pick image. Please try again.');
//     }
//   }

//   Future<void> _handleSubmit() async {
//     if (_agreementFile == null) {
//       _showErrorDialog('Error', 'Please upload the driver agreement');
//       return;
//     }

//     if (!_checked) {
//       _showErrorDialog('Error', 'Please agree to the Driver Agreement');
//       return;
//     }

//     setState(() {
//       _uploading = true;
//     });

//     try {
//       print('📤 Submitting agreement as panImage field...');
      
//       // Get file extension and type
//       String fileName = _agreementFile!.path.split('/').last;
//       String fileExtension = fileName.split('.').last.toLowerCase();
//       String contentType = 'image/jpeg'; // Default
      
//       if (fileExtension == 'png') {
//         contentType = 'image/png';
//       } else if (fileExtension == 'pdf') {
//         contentType = 'application/pdf';
//       }
      
//       // Create multipart request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://api.corezap.framekarts.com/api/v1/driver/updateDriver'),
//       );
      
//       // Add headers
//       request.headers['Accept'] = 'application/json';
//       // Add authorization if needed
//       // String token = 'YOUR_TOKEN_HERE';
//       // request.headers['Authorization'] = 'Bearer $token';
      
//       // Add file
//       request.files.add(
//         http.MultipartFile(
//           'panImage',
//           _agreementFile!.readAsBytes().asStream(),
//           _agreementFile!.lengthSync(),
//           filename: 'agreement_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
//           contentType: MediaType.parse(contentType),
//         ),
//       );
      
//       // Add driver ID if needed
//       // request.fields['driverId'] = 'YOUR_DRIVER_ID';
      
//       print('Sending request with file: $fileName');
//       print('Content-Type: $contentType');
      
//       // Send request
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
      
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
      
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
        
//         if (responseData['success'] == true) {
//           print('✅ Agreement submitted successfully: ${responseData['message']}');
//           _showSuccessDialog();
//         } else {
//           throw Exception(responseData['message'] ?? 'Submission failed');
//         }
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('❌ Agreement submission error: $error');
      
//       String errorMessage = 'Failed to submit agreement. Please try again.';
//       if (error.toString().contains('SocketException') || error.toString().contains('Connection')) {
//         errorMessage = 'Network error. Please check your internet connection.';
//       } else if (error.toString().contains('Timeout')) {
//         errorMessage = 'Request timeout. Please try again.';
//       }
      
//       _showErrorDialog('Error', errorMessage);
//     } finally {
//       setState(() {
//         _uploading = false;
//       });
//     }
//   }

//   // Alternative simpler method using MultipartFile.fromPath
//   Future<void> _handleSubmitSimple() async {
//     if (_agreementFile == null) {
//       _showErrorDialog('Error', 'Please upload the driver agreement');
//       return;
//     }

//     if (!_checked) {
//       _showErrorDialog('Error', 'Please agree to the Driver Agreement');
//       return;
//     }

//     setState(() {
//       _uploading = true;
//     });

//     try {
//       print('📤 Submitting agreement...');
      
//       // Get file extension
//       String fileName = _agreementFile!.path.split('/').last;
//       String fileExtension = fileName.split('.').last.toLowerCase();
      
//       // Create multipart request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://api.corezap.framekarts.com/api/v1/driver/updateDriver'),
//       );
      
//       // Add headers
//       request.headers['Accept'] = 'application/json';
      
//       // Add file using the simpler fromPath method
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'panImage',
//           _agreementFile!.path,
//           filename: 'agreement_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
//         ),
//       );
      
//       // You can add other fields if needed
//       // request.fields['driverId'] = '12345';
//       // request.fields['type'] = 'agreement';
      
//       print('Uploading file: ${_agreementFile!.path}');
      
//       // Send request
//       var response = await http.Response.fromStream(await request.send());
      
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
      
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
        
//         if (responseData['success'] == true) {
//           print('✅ Agreement submitted successfully');
//           _showSuccessDialog();
//         } else {
//           throw Exception(responseData['message'] ?? 'Submission failed');
//         }
//       } else if (response.statusCode == 401) {
//         throw Exception('Authentication failed. Please login again.');
//       } else if (response.statusCode == 413) {
//         throw Exception('File too large. Please reduce file size.');
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('❌ Agreement submission error: $error');
      
//       String errorMessage = error.toString();
//       if (error is http.ClientException) {
//         errorMessage = 'Network error. Please check your connection.';
//       }
      
//       _showErrorDialog('Error', errorMessage);
//     } finally {
//       setState(() {
//         _uploading = false;
//       });
//     }
//   }

//   void _showErrorDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Success'),
//         content: const Text('Driver agreement submitted successfully!'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pop(context); // Go back to previous screen
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Add this helper method to parse content type
//   static MediaType _parseMediaType(String contentType) {
//     final parts = contentType.split('/');
//     if (parts.length == 2) {
//       return MediaType(parts[0], parts[1]);
//     }
//     return MediaType('application', 'octet-stream');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             _buildHeader(),
            
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     children: [
//                       // Info Text
//                       _buildInfoText(),
                      
//                       const SizedBox(height: 20),
                      
//                       // Upload Box
//                       _buildUploadBox(),
                      
//                       const SizedBox(height: 24),
                      
//                       // Checkbox
//                       _buildCheckbox(),
                      
//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
            
//             // Submit Button
//             _buildSubmitButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//           const SizedBox(width: 8),
//           const Text(
//             'Driver Agreement',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoText() {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       child: const Text(
//         'Please review and upload the driver agreement to activate your account.',
//         style: TextStyle(
//           fontSize: 14,
//           color: Colors.grey,
//           height: 1.5,
//         ),
//       ),
//     );
//   }

//   Widget _buildUploadBox() {
//     return GestureDetector(
//       onTap: _pickImage,
//       child: Container(
//         height: 192,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _agreementFile != null ? Colors.blue : Colors.grey,
//           ),
//           color: _agreementFile != null ? Colors.blue.shade50 : Colors.grey.shade50,
//         ),
//         child: _agreementFile != null
//             ? Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.file(
//                       _agreementFile!,
//                       width: double.infinity,
//                       height: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Icon(
//                         Icons.edit,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.cloud_upload_outlined,
//                     size: 48,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'Upload Driver Agreement',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'The agreement has been sent to your registered email. Kindly download it and upload here.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildCheckbox() {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _checked = !_checked;
//         });
//       },
//       child: Row(
//         children: [
//           Container(
//             width: 20,
//             height: 20,
//             margin: const EdgeInsets.only(right: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               border: Border.all(
//                 color: _checked ? Colors.blue : Colors.grey,
//               ),
//               color: _checked ? Colors.blue : Colors.transparent,
//             ),
//             child: _checked
//                 ? const Icon(
//                     Icons.check,
//                     size: 14,
//                     color: Colors.white,
//                   )
//                 : null,
//           ),
//           const Expanded(
//             child: Text(
//               'I have read and agree to the Driver Agreement.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black87,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: double.infinity,
//         height: 48,
//         child: ElevatedButton(
//           onPressed: _isDisabled ? null : _handleSubmitSimple, // Use the simpler method
//           style: ElevatedButton.styleFrom(
//             backgroundColor: _isDisabled ? Colors.grey : Colors.blue,
//             foregroundColor: _isDisabled ? Colors.grey[500] : Colors.white,
//           ),
//           child: _uploading
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : Text(
//                   _isLoading ? 'Submitting...' : 'Submit',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

// // Helper class for MediaType
// class MediaType {
//   final String type;
//   final String subtype;

//   MediaType(this.type, this.subtype);

//   @override
//   String toString() => '$type/$subtype';
// }


import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // Or your state management solution
import 'package:dio/dio.dart'; // For API calls

// Assuming you have these imports based on your project structure
// import 'package:your_app/theme/theme_provider.dart';
// import 'package:your_app/widgets/header.dart';
// import 'package:your_app/widgets/image_picker_box.dart';
// import 'package:your_app/widgets/app_button.dart';
// import 'package:your_app/api/auth_api.dart';
// import 'package:your_app/state/auth_state.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  File? _agreementFile;
  bool _isChecked = false;
  bool _isLoading = false;
  
  final ImagePicker _picker = ImagePicker();

  bool get _isDisabled => _agreementFile == null || !_isChecked || _isLoading;

  @override
  Widget build(BuildContext context) {
    // Get theme from provider (adjust based on your theme implementation)
    final theme = Theme.of(context);
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final colors = themeProvider.colors;
    
    // Get auth state (adjust based on your state management)
    // final driverId = context.read<AuthCubit>().state.user?.id;
    // or using Provider:
    // final authState = context.watch<AuthState>();
    // final driverId = authState.user?.id;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Header(
              title: 'Driver Agreement',
              showBack: true,
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Text
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Please review and upload the driver agreement to activate your account.',
                        style: TextStyle(
                          fontSize: 14,
                          // fontFamily: 'PoppinsRegular', // Add your font family
                          color: theme.hintColor, // Adjust based on your theme
                          height: 1.4,
                        ),
                      ),
                    ),
                    
                    // Image Picker Box
                    ImagePickerBox(
                      height: 192,
                      image: _agreementFile,
                      onImagePicked: (File? image) {
                        setState(() {
                          _agreementFile = image;
                        });
                      },
                      instruction: 'The agreement has been sent to your registered email. Kindly download it and upload here.',
                    ),
                    
                    // Checkbox
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _isChecked 
                                    ? theme.primaryColor 
                                    : theme.dividerColor,
                                ),
                                color: _isChecked 
                                  ? theme.primaryColor 
                                  : Colors.transparent,
                              ),
                              child: _isChecked
                                  ? Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isChecked = !_isChecked;
                                });
                              },
                              child: Text(
                                'I have read and agree to the Driver Agreement.',
                                style: TextStyle(
                                  fontSize: 13,
                                  // fontFamily: 'Regular', // Add your font family
                                  color: theme.textTheme.bodyMedium?.color,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Submit Button
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: AppButton(
                text: _isLoading ? 'Submitting...' : 'Submit',
                onPressed: _isDisabled ? null : _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_agreementFile == null) {
      _showAlert('Error', 'Please upload the driver agreement');
      return;
    }

    if (!_isChecked) {
      _showAlert('Error', 'Please agree to the Driver Agreement');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create FormData for multipart upload
      final formData = FormData.fromMap({
        'panImage': await MultipartFile.fromFile(
          _agreementFile!.path,
          filename: 'agreement_${DateTime.now().millisecondsSinceEpoch}.jpg',
          // contentType: MediaType('image', 'jpeg'),
        ),
      });

      print('📤 Submitting agreement as panImage field...');

      // Call your API (adjust based on your API setup)
      // Example using Dio:
      // final response = await Dio().post(
      //   '${ApiConstants.baseUrl}/driver/update',
      //   data: formData,
      //   options: Options(
      //     headers: {
      //       'Authorization': 'Bearer $token',
      //       'Content-Type': 'multipart/form-data',
      //     },
      //   ),
      // );
      
      // Or using your existing API service:
      // final response = await AuthApi().updateDriver(formData);

      // Simulate API call - replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      
      print('✅ Agreement submitted successfully');

      _showSuccessAlert();
      
    } catch (error) {
      print('❌ Agreement submission error: $error');
      
      String errorMessage = 'Failed to submit agreement. Please try again.';
      
      // Handle different error formats
      if (error is DioException) {
        errorMessage = error.response?.data?['message'] ?? error.message ?? errorMessage;
      } else if (error is Map<String, dynamic>) {
        errorMessage = error['message'] ?? errorMessage;
      } else if (error is String) {
        errorMessage = error;
      }
      
      _showAlert('Error', errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Driver agreement submitted successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Custom Header Widget
class Header extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackPressed;

  const Header({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // fontFamily: 'YourFontFamily',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Image Picker Box Widget
class ImagePickerBox extends StatelessWidget {
  final double height;
  final File? image;
  final Function(File?)? onImagePicked;
  final String instruction;

  const ImagePickerBox({
    super.key,
    required this.height,
    this.image,
    this.onImagePicked,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1.5,
          ),
          color: Theme.of(context).cardColor,
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      instruction,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null && onImagePicked != null) {
      onImagePicked!(File(pickedFile.path));
    }
  }
}

// Custom App Button Widget
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled 
              ? Theme.of(context).disabledColor 
              : Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: disabled 
                ? Colors.grey[700] 
                : Colors.white,
          ),
        ),
      ),
    );
  }
}