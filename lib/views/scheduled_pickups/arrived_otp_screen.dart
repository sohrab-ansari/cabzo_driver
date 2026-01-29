
import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';

class ArrivedOtpScreen extends StatefulWidget {
  final bool? bookridetypecheck;
  final Map<String, dynamic>? rideData;

  const ArrivedOtpScreen({super.key, this.bookridetypecheck, this.rideData});

  @override
  State<ArrivedOtpScreen> createState() => _ArrivedOtpScreenState();
}

class _ArrivedOtpScreenState extends State<ArrivedOtpScreen> {
  String enteredOtp = "";
  bool _isVerifying = false;
  bool _isDisposed = false;

  final StepperController stepperController = Get.find<StepperController>();

  final OrderUpdateController orderUpdateController =
      Get.find<OrderUpdateController>();
  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    print('🔑 OTP Screen initialized');
    print('📦 Ride data: ${widget.rideData}');

    // Prevent keyboard from auto opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    print('🗑️ OTP Screen disposed');
    _isDisposed = true;
    super.dispose();
  }

  // Helper method to show snackbar safely
  void _showSnackbar(String message, {bool isError = true}) {
    if (mounted && !_isDisposed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: Duration(seconds: isError ? 3 : 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
    }
  }

  // Verify OTP API call
  Future<Map<String, dynamic>> _verifyOtpApiCall(
    String orderId,
    String otp,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    print("========== 🔵 VERIFY OTP API ==========");
    print("📌 Order ID: $orderId");
    print("📌 OTP: $otp");

    // Change this URL to your actual endpoint
    final Uri url = Uri.parse(
      "https://api.corezap.framekarts.com/api/v1/order/verifyOtp",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderId, "rideOtp": otp}),
      );

      print("✅ Status Code: ${response.statusCode}");
      print("📦 Raw Response: ${response.body}");

      // Check if response is HTML error page
      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        print("❌ Server returned HTML error page");
        return {
          "success": false,
          "message": "Server error (${response.statusCode})",
        };
      }

      if (response.statusCode == 404) {
        return {
          "success": false,
          "message": "OTP verification endpoint not found",
        };
      }

      if (response.statusCode != 200) {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}",
        };
      }

      final decoded = jsonDecode(response.body);
      return {
        "success": decoded["success"] ?? false,
        "message":
            decoded["message"] ??
            (decoded["success"] == true
                ? "OTP verified successfully"
                : "OTP verification failed"),
        "data": decoded["data"] ?? {},
      };
    } catch (e) {
      print("❌ API Error: $e");

      String errorMessage;
      if (e.toString().contains("Failed host lookup")) {
        errorMessage = "No internet connection";
      } else if (e.toString().contains("Connection refused")) {
        errorMessage = "Cannot connect to server";
      } else if (e.toString().contains("timed out")) {
        errorMessage = "Connection timeout";
      } else {
        errorMessage = "Connection error: ${e.toString()}";
      }

      return {"success": false, "message": errorMessage};
    }
  }

  // Verify OTP method
  Future<void> _verifyOtp() async {
    if (_isDisposed || !mounted) return;

    // Validate OTP length
    if (enteredOtp.length != 4) {
      _showSnackbar("Please enter 4-digit OTP");
      return;
    }

    // Get order ID
    final orderId = widget.rideData?['orderId']?.toString();
    if (orderId == null || orderId.isEmpty) {
      _showSnackbar("Invalid order ID");
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      final result = await _verifyOtpApiCall(orderId, enteredOtp);

      if (result["success"] == true) {
        _showSnackbar(
          result["message"] ?? "OTP verified successfully",
          isError: false,
        );

        // Navigate after successful verification
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isDisposed) {
            stepperController.nextStep();
            // Navigate to next screen
            Get.off(() => ArrivingClient(rideData: widget.rideData));
          }
        });
      } else {
        _showSnackbar(result["message"] ?? "OTP verification failed");
      }
    } catch (e) {
      print("❌ Error in _verifyOtp: $e");
      if (mounted && !_isDisposed) {
        _showSnackbar("An error occurred. Please try again.");
      }
    } finally {
      if (mounted && !_isDisposed) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: w * 0.08,
        title: Text("OTP ${widget.bookridetypecheck ?? ''}"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted && !_isDisposed) {
              Navigator.of(context).pop(false);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(w * 0.06, w * 0.06, w * 0.06, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            /// Profile Image
            Container(
              height: w * 0.35,
              width: w * 0.35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                "assets/images/profile3.png",
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            /// Customer Name
            Text(
              widget.rideData?['riderName']?.toString() ?? 'Customer',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            /// Instruction
            const Text(
              "Enter the 4-digit code to begin the trip",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// OTP FIELD
            PinCodeTextField(
              appContext: context,
              length: 4,
              keyboardType: TextInputType.number,
              autoFocus: false,
              animationType: AnimationType.fade,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 55,
                fieldWidth: 55,
                activeColor: const Color(0xFF26E3DD),
                selectedColor: const Color(0xFF26E3DD),
                inactiveColor: Colors.grey.shade300,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
              ),
              animationDuration: const Duration(milliseconds: 200),
              enableActiveFill: true,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    enteredOtp = value;
                  });
                }
              },
              onCompleted: (value) {
                if (mounted) {
                  setState(() {
                    enteredOtp = value;
                  });
                  // Auto verify on complete
                  _verifyOtp();
                }
              },
            ),

            const SizedBox(height: 20),

            if (widget.bookridetypecheck == true) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: w * 0.035,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Red Dot Icon
                      Image.asset(
                        "assets/icons/redDot.png",
                        height: w * 0.05,
                        width: w * 0.05,
                      ),

                      SizedBox(width: w * 0.03),

                      /// Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Label
                            Text(
                              "Drop",
                              style: TextStyle(
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),

                            SizedBox(height: 6),

                            /// Address
                            Text(
                              widget.rideData?['dropLocation']?.toString() ??
                                  "Bus Sta Upas, Majestic, Bengaluru, Karnataka 560009",
                              style: TextStyle(
                                fontSize: w * 0.032,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            /// VERIFY BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26E3DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isVerifying
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            /// CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: _isVerifying
                    ? null
                    : () {

                      // Navigator.pop(context);

                       _handleCancelOrder();
                      },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            /// DEBUG INFO (Optional - remove in production)
            if (widget.rideData != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Debug Info:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text("Order ID: ${widget.rideData?['orderId']}"),
                    Text("Rider: ${widget.rideData?['riderName']}"),
                    Text("OTP Entered: $enteredOtp"),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }



    void _handleCancelOrder() {
    final orderId = widget.rideData?['orderId'];

    if (orderId != null && orderId.isNotEmpty) {
      orderUpdateController.updateOrder(
        context: context,
        buttonId: 'cancel_button',
        orderStatus: "Cancelled",
        orderId: orderId,
        rideData: widget.rideData,
        stepControl: "Cancelled",
        successMessage: 'Order cancelled successfully',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid order ID'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
