


// // // import 'package:corezap_driver/controller/stepper_controller.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:pin_code_fields/pin_code_fields.dart';

// // // class ArrivedOtpScreen extends StatefulWidget {
// // //   const ArrivedOtpScreen({super.key});

// // //   @override
// // //   State<ArrivedOtpScreen> createState() => _ArrivedOtpScreenState();
// // // }

// // // class _ArrivedOtpScreenState extends State<ArrivedOtpScreen> {
// // //   String enteredOtp = "";
// // //   final StepperController stepperController = Get.find<StepperController>();

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final w = MediaQuery.of(context).size.width;

// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       resizeToAvoidBottomInset: true,
// // //       appBar: AppBar(
// // //         title: const Text("OTP"),
// // //         centerTitle: true,
// // //         elevation: 0,
// // //         backgroundColor: Colors.white,
// // //         foregroundColor: Colors.black,
// // //       ),
// // //       body: SingleChildScrollView(
// // //         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
// // //         padding: EdgeInsets.fromLTRB(
// // //           w * 0.06,
// // //           w * 0.06,
// // //           w * 0.06,
// // //           MediaQuery.of(context).viewInsets.bottom + 20,
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.center,
// // //           children: [
// // //             const SizedBox(height: 30),

// // //             /// Profile Image
// // //             Container(
// // //               height: w * 0.35,
// // //               width: w * 0.35,
// // //               decoration: const BoxDecoration(
// // //                 shape: BoxShape.circle,
// // //                 color: Colors.white,
// // //               ),
// // //               padding: const EdgeInsets.all(20),
// // //               child: Image.asset(
// // //                 "assets/images/profile3.png",
// // //                 fit: BoxFit.contain,
// // //               ),
// // //             ),

// // //             const SizedBox(height: 24),

// // //             /// Customer Name
// // //             const Text(
// // //               "Muskan",
// // //               style: TextStyle(
// // //                 fontSize: 22,
// // //                 fontWeight: FontWeight.w600,
// // //               ),
// // //             ),

// // //             const SizedBox(height: 8),

// // //             /// Instruction
// // //             const Text(
// // //               "Enter the 4-digit code to begin the trip",
// // //               textAlign: TextAlign.center,
// // //               style: TextStyle(
// // //                 fontSize: 14,
// // //                 color: Colors.grey,
// // //               ),
// // //             ),

// // //             const SizedBox(height: 30),

// // //             /// OTP FIELD
// // //             PinCodeTextField(
// // //               appContext: context,
// // //               length: 4,
// // //               keyboardType: TextInputType.number,
// // //               autoFocus: true,
// // //               animationType: AnimationType.fade,
// // //               textStyle: const TextStyle(
// // //                 fontSize: 22,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //               pinTheme: PinTheme(
// // //                 shape: PinCodeFieldShape.box,
// // //                 borderRadius: BorderRadius.circular(12),
// // //                 fieldHeight: 55,
// // //                 fieldWidth: 55,
// // //                 activeColor: const Color(0xFF26E3DD),
// // //                 selectedColor: const Color(0xFF26E3DD),
// // //                 inactiveColor: Colors.grey.shade300,
// // //                 activeFillColor: Colors.white,
// // //                 selectedFillColor: Colors.white,
// // //                 inactiveFillColor: Colors.white,
// // //               ),
// // //               animationDuration: const Duration(milliseconds: 200),
// // //               enableActiveFill: true,
// // //               onChanged: (value) => enteredOtp = value,
// // //               onCompleted: (value) => enteredOtp = value,
// // //             ),

// // //             const SizedBox(height: 60),

// // //             /// VERIFY BUTTON
// // //             SizedBox(
// // //               width: double.infinity,
// // //               height: 50,
// // //               child: ElevatedButton(
// // //                 onPressed: () {
// // //                   if (enteredOtp.length != 4) {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(
// // //                         content: Text("Please enter valid OTP"),
// // //                       ),
// // //                     );
// // //                     return;
// // //                   }
                  
// // //                   // Update stepper to next step (Arrived at Pickup -> Ready to Start Trip)
// // //                   stepperController.nextStep();
                  
// // //                   // Go back to ArrivingClient screen
// // //                   Navigator.pop(context);
                  
// // //                   // Show success message
// // //                   // ScaffoldMessenger.of(context).showSnackBar(
// // //                   //   const SnackBar(
// // //                   //     content: Text("OTP Verified Successfully"),
// // //                   //     backgroundColor: Colors.green,
// // //                   //   ),
// // //                   // );
                  
// // //                   print("OTP Verified: $enteredOtp");
// // //                 },
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: const Color(0xFF26E3DD),
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                 ),
// // //                 child: const Text(
// // //                   "Verify",
// // //                   style: TextStyle(
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.w600,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),

// // //             const SizedBox(height: 12),

// // //             /// CANCEL BUTTON
// // //             SizedBox(
// // //               width: double.infinity,
// // //               height: 50,
// // //               child: TextButton(
// // //                 onPressed: () => Navigator.pop(context),
// // //                 style: TextButton.styleFrom(
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                 ),
// // //                 child: const Text(
// // //                   "Cancel",
// // //                   style: TextStyle(
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.w500,
// // //                     color: Colors.black,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),

// // //             const SizedBox(height: 30),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:corezap_driver/controller/stepper_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:pin_code_fields/pin_code_fields.dart';

// // class ArrivedOtpScreen extends StatefulWidget {
// //   const ArrivedOtpScreen({super.key});

// //   @override
// //   State<ArrivedOtpScreen> createState() => _ArrivedOtpScreenState();
// // }

// // class _ArrivedOtpScreenState extends State<ArrivedOtpScreen> {
// //   String enteredOtp = "";
// //   final StepperController stepperController = Get.find<StepperController>();
// //   final FocusNode _otpFocusNode = FocusNode();
  
// //   // Pre-cache the image to make it load faster
// //   late final Future<PrecacheImageInfo> _precachedImage;

// //   @override
// //   void initState() {
// //     super.initState();
    
// //     // Pre-cache the image
// //     _precachedImage = precacheImage(
// //       const AssetImage("assets/images/profile3.png"),
// //       context,
// //     );
    
// //     // Prevent auto-focus and keyboard opening
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       FocusScope.of(context).unfocus();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _otpFocusNode.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final w = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       resizeToAvoidBottomInset: false, // Changed from true to false to prevent keyboard resizing
// //       appBar: AppBar(
// //         title: const Text("OTP"),
// //         centerTitle: true,
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //       ),
// //       body: FutureBuilder<PrecacheImageInfo>(
// //         future: _precachedImage,
// //         builder: (context, snapshot) {
// //           return SingleChildScrollView(
// //             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
// //             padding: EdgeInsets.fromLTRB(
// //               w * 0.06,
// //               w * 0.06,
// //               w * 0.06,
// //               20, // Removed keyboard inset to prevent jumping
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 const SizedBox(height: 30),

// //                 /// Profile Image
// //                 Container(
// //                   height: w * 0.35,
// //                   width: w * 0.35,
// //                   decoration: const BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Colors.white,
// //                   ),
// //                   padding: const EdgeInsets.all(20),
// //                   child: Image.asset(
// //                     "assets/images/profile3.png",
// //                     fit: BoxFit.contain,
// //                     // Add error and loading builders for better UX
// //                     errorBuilder: (context, error, stackTrace) {
// //                       return const Icon(Icons.person, size: 60, color: Colors.grey);
// //                     },
// //                   ),
// //                 ),

// //                 const SizedBox(height: 24),

// //                 /// Customer Name
// //                 const Text(
// //                   "Muskan",
// //                   style: TextStyle(
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),

// //                 const SizedBox(height: 8),

// //                 /// Instruction
// //                 const Text(
// //                   "Enter the 4-digit code to begin the trip",
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey,
// //                   ),
// //                 ),

// //                 const SizedBox(height: 30),

// //                 /// OTP FIELD
// //                 PinCodeTextField(
// //                   appContext: context,
// //                   length: 4,
// //                   keyboardType: TextInputType.number,
// //                   autoFocus: false, // Set to false to prevent auto opening keyboard
// //                   focusNode: _otpFocusNode, // Use custom focus node
// //                   animationType: AnimationType.none, // Changed from fade to none for performance
// //                   textStyle: const TextStyle(
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                   pinTheme: PinTheme(
// //                     shape: PinCodeFieldShape.box,
// //                     borderRadius: BorderRadius.circular(12),
// //                     fieldHeight: 55,
// //                     fieldWidth: 55,
// //                     activeColor: const Color(0xFF26E3DD),
// //                     selectedColor: const Color(0xFF26E3DD),
// //                     inactiveColor: Colors.grey.shade300,
// //                     activeFillColor: Colors.white,
// //                     selectedFillColor: Colors.white,
// //                     inactiveFillColor: Colors.white,
// //                   ),
// //                   animationDuration: Duration.zero, // No animation for better performance
// //                   enableActiveFill: true,
// //                   onChanged: (value) {
// //                     enteredOtp = value;
// //                     // Auto-submit when 4 digits are entered
// //                     if (value.length == 4) {
// //                       _verifyOtp();
// //                     }
// //                   },
// //                   onCompleted: (value) {
// //                     enteredOtp = value;
// //                     _verifyOtp();
// //                   },
// //                   onTap: () {
// //                     // Only open keyboard when user taps the field
// //                     FocusScope.of(context).requestFocus(_otpFocusNode);
// //                   },
// //                 ),

// //                 const SizedBox(height: 60),

// //                 /// VERIFY BUTTON
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 50,
// //                   child: ElevatedButton(
// //                     onPressed: _verifyOtp,
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF26E3DD),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     child: const Text(
// //                       "Verify",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ),

// //                 const SizedBox(height: 12),

// //                 /// CANCEL BUTTON
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 50,
// //                   child: TextButton(
// //                     onPressed: () => Navigator.pop(context),
// //                     style: TextButton.styleFrom(
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     child: const Text(
// //                       "Cancel",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w500,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 ),

// //                 const SizedBox(height: 30),
// //               ],
// //             ),
// //           );
// //         }
// //       ),
// //     );
// //   }
  
// //   void _verifyOtp() {
// //     if (enteredOtp.length != 4) {
// //       // If OTP is incomplete, show message and focus on OTP field
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("Please enter valid OTP"),
// //         ),
// //       );
// //       FocusScope.of(context).requestFocus(_otpFocusNode);
// //       return;
// //     }
    
// //     // Update stepper to next step (Arrived at Pickup -> Ready to Start Trip)
// //     stepperController.nextStep();
    
// //     // Go back to ArrivingClient screen
// //     Navigator.pop(context);
    
// //     // Show success message
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(
// //         content: Text("OTP Verified Successfully"),
// //         backgroundColor: Colors.green,
// //       ),
// //     );
    
// //     print("OTP Verified: $enteredOtp");
// //   }
// // }

// import 'package:corezap_driver/controller/stepper_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class ArrivedOtpScreen extends StatefulWidget {
//   const ArrivedOtpScreen({super.key});

//   @override
//   State<ArrivedOtpScreen> createState() => _ArrivedOtpScreenState();
// }

// class _ArrivedOtpScreenState extends State<ArrivedOtpScreen> {
//   String enteredOtp = "";
//   final StepperController stepperController = Get.find<StepperController>();

//   @override
//   void initState() {
//     super.initState();
//     // Prevent keyboard from auto opening
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).unfocus();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("OTP"),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 30),

//             /// Profile Image
//             Container(
//               height: w * 0.35,
//               width: w * 0.35,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Image.asset(
//                 "assets/images/profile3.png",
//                 fit: BoxFit.contain,
//               ),
//             ),

//             const SizedBox(height: 24),

//             /// Customer Name
//             const Text(
//               "Muskan",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const SizedBox(height: 8),

//             /// Instruction
//             const Text(
//               "Enter the 4-digit code to begin the trip",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// OTP FIELD
//             PinCodeTextField(
//               appContext: context,
//               length: 4,
//               keyboardType: TextInputType.number,
//               autoFocus: false, // This prevents keyboard from auto opening
//               animationType: AnimationType.fade,
//               textStyle: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(12),
//                 fieldHeight: 55,
//                 fieldWidth: 55,
//                 activeColor: const Color(0xFF26E3DD),
//                 selectedColor: const Color(0xFF26E3DD),
//                 inactiveColor: Colors.grey.shade300,
//                 activeFillColor: Colors.white,
//                 selectedFillColor: Colors.white,
//                 inactiveFillColor: Colors.white,
//               ),
//               animationDuration: const Duration(milliseconds: 200),
//               enableActiveFill: true,
//               onChanged: (value) => enteredOtp = value,
//               onCompleted: (value) => enteredOtp = value,
//             ),

//             const SizedBox(height: 60),

//             /// VERIFY BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (enteredOtp.length != 4) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Please enter valid OTP"),
//                       ),
//                     );
//                     return;
//                   }
                  
//                   stepperController.nextStep();
//                   Navigator.pop(context);
//                   print("OTP Verified: $enteredOtp");
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF26E3DD),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Verify",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             /// CANCEL BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: TextButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ArrivedOtpScreen extends StatefulWidget {
  const ArrivedOtpScreen({super.key});

  @override
  State<ArrivedOtpScreen> createState() => _ArrivedOtpScreenState();
}

class _ArrivedOtpScreenState extends State<ArrivedOtpScreen> {
  String enteredOtp = "";
  final StepperController stepperController = Get.find<StepperController>();

  @override
  void initState() {
    super.initState();
    // Prevent keyboard from auto opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("OTP"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          w * 0.06,
          w * 0.06,
          w * 0.06,
          20,
        ),
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
            const Text(
              "Muskan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            /// Instruction
            const Text(
              "Enter the 4-digit code to begin the trip",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            /// OTP FIELD
            PinCodeTextField(
              appContext: context,
              length: 4,
              keyboardType: TextInputType.number,
              autoFocus: false, // This prevents keyboard from auto opening
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
              onChanged: (value) => enteredOtp = value,
              onCompleted: (value) => enteredOtp = value,
            ),

            const SizedBox(height: 60),

            /// VERIFY BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (enteredOtp.length != 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter valid OTP"),
                      ),
                    );
                    return;
                  }
                  
                  stepperController.nextStep();
                  Navigator.pop(context);
                  print("OTP Verified: $enteredOtp");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26E3DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                onPressed: () => Navigator.pop(context),
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
          ],
        ),
      ),
    );
  }
}