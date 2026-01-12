// // // // import 'package:corezap_driver/utilities/colors.dart';
// // // // import 'package:corezap_driver/views/profile_related.dart/documents_related/driver_registration.dart';
// // // // import 'package:corezap_driver/views/profile_related.dart/documents_related/preference.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:corezap_driver/controller/controllers.dart';
// // // // import 'package:corezap_driver/controller/otp_controller.dart';
// // // // import 'package:corezap_driver/utilities/colors/colors_list.dart';
// // // // import 'package:corezap_driver/utilities/custom_text.dart';
// // // // import 'package:corezap_driver/utilities/custom_otps/custom_otp_box.dart';
// // // // import 'package:corezap_driver/utilities/navigator.dart';
// // // // import 'package:corezap_driver/utilities/app_buttons.dart';
// // // // import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';

// // // // class EnterOtpScreen extends StatefulWidget {
// // // //   dynamic typecheck;

// // // //   dynamic phoneNumber;

// // // //   dynamic receivedOtp;

// // // //   EnterOtpScreen({super.key, required this.typecheck, required this.phoneNumber, required this.receivedOtp});

// // // //   @override
// // // //   State<EnterOtpScreen> createState() => _EnterOtpScreenState();
// // // // }

// // // // class _EnterOtpScreenState extends State<EnterOtpScreen> {
// // // //   final Controllers contentController = Get.put(Controllers());
// // // //   final OtpController otpController = Get.put(OtpController());
// // // //   @override
// // // //   void initState() {
// // // //     // TODO: implement initState
// // // //     contentController.maxheightReach.value = false;
// // // //     super.initState();
// // // //     otpController.startTimer();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     double w = MediaQuery.of(context).size.width;
// // // //     return Scaffold(
// // // //       backgroundColor: ColorsList.scaffoldColor,
// // // //       body: Padding(
// // // //         padding: EdgeInsets.symmetric(horizontal: w * .04),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             SizedBox(height: w * .12),
// // // //             GestureDetector(
// // // //               onTap: () {
// // // //                 Navigator.pop(context);
// // // //               },
// // // //               child: SizedBox(
// // // //                 width: w * .08,
// // // //                 height: w * .08,
// // // //                 child: Image.asset("assets/images/arrowLeft.png"),
// // // //               ),
// // // //             ),
// // // //             SizedBox(height: w * .02),
// // // //             CustomText(
// // // //               text: "Verify Phone Number",
// // // //               textFontSize: w * .06,
// // // //               textColor: ColorsList.titleTextColor,
// // // //               textFontWeight: FontWeight.w600,
// // // //             ),
// // // //             SizedBox(height: w * .02),
// // // //             RichText(
// // // //               text: TextSpan(
// // // //                 children: [
// // // //                   TextSpan(
// // // //                     text: "Please enter the 4 digit code sent to ",
// // // //                     style: TextStyle(
// // // //                       fontSize: w * .042,
// // // //                       color: ColorsList.subtitleTextColor,
// // // //                       fontWeight: FontWeight.w400,
// // // //                     ),
// // // //                   ),

// // // //                     TextSpan(
// // // //                     text: "+91 ${widget.phoneNumber}",
// // // //                     style: TextStyle(
// // // //                       fontSize: w * .042,
// // // //                       color: AppColors.black,
// // // //                       fontWeight: FontWeight.w400,
// // // //                     ),
// // // //                   ),
                
// // // //                   TextSpan(
// // // //                     text: " through SMS",
// // // //                     style: TextStyle(
// // // //                       fontSize: w * .042,
// // // //                       color: ColorsList.subtitleTextColor,
// // // //                       fontWeight: FontWeight.w400,
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),

// // // //             SizedBox(height: w * .02),
// // // //             Padding(
// // // //               padding: EdgeInsets.symmetric(
// // // //                 horizontal: w * .07,
// // // //                 vertical: w * .05,
// // // //               ),
// // // //               child: Column(
// // // //                 children: [
// // // //                   //? otp boxes-------------------------------
// // // //                   Padding(
// // // //                     padding: EdgeInsets.symmetric(horizontal: w * .01),
// // // //                     child: CustomOtpBox(),
// // // //                   ),
// // // //                   SizedBox(height: w * .02),
              
                
// // // //                   Obx(() {
// // // //                     if (otpController.secondsRemaining.value > 0) {
// // // //                       return Row(
// // // //                         mainAxisAlignment: MainAxisAlignment.center,
// // // //                         children: [
// // // //                           CustomText(
// // // //                             text: "Haven't got the confirmation code yet?",
// // // //                             textFontSize: w * .035,
// // // //                             textColor: ColorsList.subtitleTextColor,
// // // //                             textFontWeight: FontWeight.w400,
// // // //                           ),
// // // //                           SizedBox(width: w * .01),
// // // //                           CustomText(
// // // //                             text:
// // // //                                 "00:${otpController.secondsRemaining.value.toString().padLeft(2, '0')}",
// // // //                             textFontSize: w * .035,
// // // //                             textColor: ColorsList.subtitleTextColor,
// // // //                             textFontWeight: FontWeight.w400,
// // // //                           ),
// // // //                         ],
// // // //                       );
// // // //                     } else {
// // // //                       return GestureDetector(
// // // //                         onTap: otpController.resendCode,
// // // //                         child: CustomText(
// // // //                           text: "Resend OTP",
// // // //                           textFontSize: w * .035,
// // // //                           textColor: ColorsList.mainAppColor, // clickable color
// // // //                           textFontWeight: FontWeight.w600,
// // // //                         ),
// // // //                       );
// // // //                     }
// // // //                   }),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             Spacer(),
       
// // // //             SizedBox(height: w * .05),
// // // //             AppButtons.solid(
// // // //               context: context,
// // // //               text: "Verify",
// // // //               onClicked: () {
// // // //                 if (widget.typecheck == "new") {
// // // //                   CustomNavigator.push(
// // // //                     context,
// // // //                     DriverRegistration(),
// // // //                     transition: TransitionType.slideLeft,
// // // //                   );
// // // //                 } else {
// // // //                   CustomNavigator.push(
// // // //                     context,
// // // //                     const BottomnavmainScreen(),
// // // //                     transition: TransitionType.fade,
// // // //                   );
// // // //                 }
// // // //               },
// // // //               isFullWidth: true,
// // // //               backgroundColor: ColorsList.mainButtonColor,
// // // //               textColor: AppColors.black,
// // // //               fontSize: w * .045,
// // // //               height: w * .140,
// // // //               radius: 12.0,
// // // //               //  textColor:  AppColors.black,
// // // //               fontWeight: FontWeight.w500,
// // // //             ),
// // // //             SizedBox(height: w * .1),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }


// // // // views/auth/enter_otp_screen.dart
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:corezap_driver/apis/auth.api.dart';
// // // import 'package:corezap_driver/controller/otp_controller.dart';
// // // import 'package:corezap_driver/utilities/colors.dart';
// // // import 'package:corezap_driver/utilities/custom_text.dart';
// // // import 'package:corezap_driver/utilities/custom_otps/custom_otp_box.dart';
// // // import 'package:corezap_driver/utilities/navigator.dart';
// // // import 'package:corezap_driver/utilities/app_buttons.dart';
// // // import 'package:corezap_driver/utilities/Custom_Snackbar.dart';
// // // import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // // import 'package:corezap_driver/views/profile_related.dart/documents_related/driver_registration.dart';

// // // class EnterOtpScreen extends StatefulWidget {
// // //   final String typecheck;
// // //   final String phoneNumber;
// // //   final String receivedOtp;

// // //   EnterOtpScreen({
// // //     super.key, 
// // //     required this.typecheck, 
// // //     required this.phoneNumber, 
// // //     required this.receivedOtp
// // //   });

// // //   @override
// // //   State<EnterOtpScreen> createState() => _EnterOtpScreenState();
// // // }

// // // class _EnterOtpScreenState extends State<EnterOtpScreen> {
// // //   final OtpController otpController = Get.find<OtpController>();
// // //   // final AuthApi authApi = Get.find<AuthApi>();
  
// // //   // OTP input
// // //   final TextEditingController _otpController = TextEditingController();

// // //   late final AuthApi authApi;
// // //   @override
// // //   void initState() {
// // //     super.initState();
    


// // //       authApi = Get.put(AuthApi(), permanent: true);
// // //     // Auto-fill OTP if provided (for testing)
// // //     _otpController.text = widget.receivedOtp;
    
// // //     // Start OTP timer
// // //     otpController.startTimer();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double w = MediaQuery.of(context).size.width;
    
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       body: Padding(
// // //         padding: EdgeInsets.symmetric(horizontal: w * .04),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             SizedBox(height: w * .12),
// // //             // Back button
// // //             GestureDetector(
// // //               onTap: () => Get.back(),
// // //               child: SizedBox(
// // //                 width: w * .08,
// // //                 height: w * .08,
// // //                 child: Image.asset("assets/images/arrowLeft.png"),
// // //               ),
// // //             ),
            
// // //             SizedBox(height: w * .02),
// // //             // Title
// // //             CustomText(
// // //               text: "Verify Phone Number",
// // //               textFontSize: w * .06,
// // //               textColor: Colors.black,
// // //               textFontWeight: FontWeight.w600,
// // //             ),
            
// // //             SizedBox(height: w * .02),
// // //             // Description
// // //             RichText(
// // //               text: TextSpan(
// // //                 children: [
// // //                   TextSpan(
// // //                     text: "Please enter the 4 digit code sent to ",
// // //                     style: TextStyle(
// // //                       fontSize: w * .042,
// // //                       color: Colors.grey[700],
// // //                       fontWeight: FontWeight.w400,
// // //                     ),
// // //                   ),
// // //                   TextSpan(
// // //                     text: "+91 ${widget.phoneNumber}",
// // //                     style: TextStyle(
// // //                       fontSize: w * .042,
// // //                       color: AppColors.black,
// // //                       fontWeight: FontWeight.w600,
// // //                     ),
// // //                   ),
// // //                   TextSpan(
// // //                     text: " through SMS",
// // //                     style: TextStyle(
// // //                       fontSize: w * .042,
// // //                       color: Colors.grey[700],
// // //                       fontWeight: FontWeight.w400,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),

// // //             SizedBox(height: w * .04),
// // //             // OTP Input
// // //             Padding(
// // //               padding: EdgeInsets.symmetric(
// // //                 horizontal: w * .07,
// // //                 vertical: w * .05,
// // //               ),
// // //               child: Column(
// // //                 children: [
// // //                   // OTP boxes
// // //                   CustomOtpBox(
// // //                     onChanged: (value) {
// // //                       _otpController.text = value;
// // //                     },
// // //                   ),
                  
// // //                   SizedBox(height: w * .02),
// // //                   // Timer or Resend OTP
// // //                   Obx(() {
// // //                     if (otpController.secondsRemaining.value > 0) {
// // //                       return Row(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           CustomText(
// // //                             text: "Haven't got the code yet? ",
// // //                             textFontSize: w * .035,
// // //                             textColor: Colors.grey[700],
// // //                             textFontWeight: FontWeight.w400,
// // //                           ),
// // //                           CustomText(
// // //                             text: "00:${otpController.secondsRemaining.value.toString().padLeft(2, '0')}",
// // //                             textFontSize: w * .035,
// // //                             textColor: AppColors.primaryRed,
// // //                             textFontWeight: FontWeight.w600,
// // //                           ),
// // //                         ],
// // //                       );
// // //                     } else {
// // //                       return GestureDetector(
// // //                         onTap: () {
// // //                           otpController.resendCode();
// // //                           // TODO: Add resend OTP API call
// // //                         },
// // //                         child: CustomText(
// // //                           text: "Resend OTP",
// // //                           textFontSize: w * .035,
// // //                           textColor: AppColors.primaryRed,
// // //                           textFontWeight: FontWeight.w600,
// // //                         ),
// // //                       );
// // //                     }
// // //                   }),
// // //                 ],
// // //               ),
// // //             ),
            
// // //             Spacer(),
// // //             SizedBox(height: w * .05),
            
// // //             // Verify Button
// // //             Obx(() => AppButtons.solid(
// // //               context: context,
// // //               text: "Verify",
// // //               onClicked: () async {
// // //                 await _verifyOtp();
// // //               },
// // //               isFullWidth: true,
// // //               backgroundColor: AppColors.primaryRed,
// // //               textColor: Colors.white,
// // //               fontSize: w * .045,
// // //               height: w * .140,
// // //               radius: 12.0,
// // //               isLoading: authApi.verifyOtpLoader.value,
// // //               fontWeight: FontWeight.w500,
// // //             )),
            
// // //             SizedBox(height: w * .1),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // Verify OTP function
// // //   Future<void> _verifyOtp() async {
// // //     // Validate OTP
// // //     if (_otpController.text.isEmpty || _otpController.text.length != 4) {
// // //       CustomSnackbar.showCustomSnackbar(
// // //         context: context,
// // //         title: "Error",
// // //         subtitle: "Please enter a valid 4-digit OTP",
// // //         backgroundColor: Colors.red,
// // //       );
// // //       return;
// // //     }

// // //     // Get FCM token and device ID
// // //     final fcmToken = await authApi.getFcmToken();
// // //     final deviceId = await authApi.getDeviceId();

// // //     // Call verify OTP API
// // //     final otpResponse = await authApi.verifyOtpApi(
// // //       widget.phoneNumber,
// // //       _otpController.text,
// // //       fcmToken,
// // //       deviceId,
// // //     );

// // //     if (otpResponse?.success == true) {
// // //       CustomSnackbar.showCustomSnackbar(
// // //         context: context,
// // //         title: "Success",
// // //         subtitle: otpResponse?.message ?? "Account verified successfully",
// // //         backgroundColor: Colors.green,
// // //       );
      
// // //       // Get profile completion status
// // //       final isProfileCompleted = otpResponse?.driver?.isProfileCompleted ?? false;
      
// // //       // Navigate based on profile completion
// // //       await Future.delayed(const Duration(milliseconds: 800));
      
// // //       if (isProfileCompleted) {
// // //         // Profile completed - go to home
// // //         Get.offAll(() => const BottomnavmainScreen());
// // //       } else {
// // //         // Profile not completed - go to registration
// // //         // Get.off(() => DriverRegistration(
// // //         //   driverData: otpResponse?.driver,
// // //         // ));
// // //       }
// // //     } else {
// // //       CustomSnackbar.showCustomSnackbar(
// // //         context: context,
// // //         title: "Error",
// // //         subtitle: otpResponse?.message ?? "Invalid OTP. Please try again.",
// // //         backgroundColor: Colors.red,
// // //       );
// // //     }
// // //   }
// // // }


// // // views/auth/enter_otp_screen.dart
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:corezap_driver/apis/auth.api.dart';
// // import 'package:corezap_driver/controller/otp_controller.dart';
// // import 'package:corezap_driver/utilities/colors.dart';
// // import 'package:corezap_driver/utilities/custom_text.dart';
// // import 'package:corezap_driver/utilities/custom_otps/custom_otp_box.dart';
// // import 'package:corezap_driver/utilities/navigator.dart';
// // import 'package:corezap_driver/utilities/app_buttons.dart';
// // import 'package:corezap_driver/utilities/Custom_Snackbar.dart';
// // import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // import 'package:corezap_driver/views/profile_related.dart/documents_related/driver_registration.dart';

// // class EnterOtpScreen extends StatefulWidget {
// //   final String typecheck;
// //   final String phoneNumber;
// //   final String receivedOtp;

// //   EnterOtpScreen({
// //     super.key, 
// //     required this.typecheck, 
// //     required this.phoneNumber, 
// //     required this.receivedOtp
// //   });

// //   @override
// //   State<EnterOtpScreen> createState() => _EnterOtpScreenState();
// // }

// // class _EnterOtpScreenState extends State<EnterOtpScreen> {
// //   late final OtpController otpController;
// //   late final AuthApi authApi;
  
// //   // OTP input
// //   final TextEditingController _otpController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
    
// //     // Initialize controllers
// //     authApi = Get.find<AuthApi>(); // This should already be initialized in SignupScreen
// //     otpController = Get.put(OtpController()); // Initialize OtpController here
    
// //     // Auto-fill OTP if provided (for testing)
// //     _otpController.text = widget.receivedOtp;
    
// //     // Start OTP timer
// //     otpController.startTimer();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;
    
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Padding(
// //         padding: EdgeInsets.symmetric(horizontal: w * .04),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             SizedBox(height: w * .12),
// //             // Back button
// //             GestureDetector(
// //               onTap: () => Get.back(),
// //               child: SizedBox(
// //                 width: w * .08,
// //                 height: w * .08,
// //                 child: Image.asset("assets/images/arrowLeft.png"),
// //               ),
// //             ),
            
// //             SizedBox(height: w * .02),
// //             // Title
// //             CustomText(
// //               text: "Verify Phone Number",
// //               textFontSize: w * .06,
// //               textColor: Colors.black,
// //               textFontWeight: FontWeight.w600,
// //             ),
            
// //             SizedBox(height: w * .02),
// //             // Description
// //             RichText(
// //               text: TextSpan(
// //                 children: [
// //                   TextSpan(
// //                     text: "Please enter the 4 digit code sent to ",
// //                     style: TextStyle(
// //                       fontSize: w * .042,
// //                       color: Colors.grey[700],
// //                       fontWeight: FontWeight.w400,
// //                     ),
// //                   ),
// //                   TextSpan(
// //                     text: "+91 ${widget.phoneNumber}",
// //                     style: TextStyle(
// //                       fontSize: w * .042,
// //                       color: AppColors.black,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   TextSpan(
// //                     text: " through SMS",
// //                     style: TextStyle(
// //                       fontSize: w * .042,
// //                       color: Colors.grey[700],
// //                       fontWeight: FontWeight.w400,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             SizedBox(height: w * .04),
// //             // OTP Input
// //             Padding(
// //               padding: EdgeInsets.symmetric(
// //                 horizontal: w * .07,
// //                 vertical: w * .05,
// //               ),
// //               child: Column(
// //                 children: [
// //                   // OTP boxes
// //                   CustomOtpBox(
// //                     onChanged: (value) {
// //                       _otpController.text = value;
// //                     },
// //                   ),
                  
// //                   SizedBox(height: w * .02),
// //                   // Timer or Resend OTP
// //                   Obx(() {
// //                     if (otpController.secondsRemaining.value > 0) {
// //                       return Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           CustomText(
// //                             text: "Haven't got the code yet? ",
// //                             textFontSize: w * .035,
// //                             textColor: Colors.grey[700],
// //                             textFontWeight: FontWeight.w400,
// //                           ),
// //                           CustomText(
// //                             text: "00:${otpController.secondsRemaining.value.toString().padLeft(2, '0')}",
// //                             textFontSize: w * .035,
// //                             textColor: AppColors.primaryRed,
// //                             textFontWeight: FontWeight.w600,
// //                           ),
// //                         ],
// //                       );
// //                     } else {
// //                       return GestureDetector(
// //                         onTap: () {
// //                           otpController.resendCode();
// //                           // TODO: Add resend OTP API call
// //                         },
// //                         child: CustomText(
// //                           text: "Resend OTP",
// //                           textFontSize: w * .035,
// //                           textColor: AppColors.primaryRed,
// //                           textFontWeight: FontWeight.w600,
// //                         ),
// //                       );
// //                     }
// //                   }),
// //                 ],
// //               ),
// //             ),
            
// //             Spacer(),
// //             SizedBox(height: w * .05),
            
// //             // Verify Button
// //             Obx(() => AppButtons.solid(
// //               context: context,
// //               text: "Verify",
// //               onClicked: () async {
// //                 await _verifyOtp();
// //               },
// //               isFullWidth: true,
// //               backgroundColor: AppColors.primaryRed,
// //               textColor: Colors.white,
// //               fontSize: w * .045,
// //               height: w * .140,
// //               radius: 12.0,
// //               isLoading: authApi.verifyOtpLoader.value,
// //               fontWeight: FontWeight.w500,
// //             )),
            
// //             SizedBox(height: w * .1),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // Verify OTP function
// //   Future<void> _verifyOtp() async {
// //     // Validate OTP
// //     if (_otpController.text.isEmpty || _otpController.text.length != 4) {
// //       CustomSnackbar.showCustomSnackbar(
// //         context: context,
// //         title: "Error",
// //         subtitle: "Please enter a valid 4-digit OTP",
// //         backgroundColor: Colors.red,
// //       );
// //       return;
// //     }

// //     // Get FCM token and device ID
// //     final fcmToken = await authApi.getFcmToken();
// //     final deviceId = await authApi.getDeviceId();

// //     // Call verify OTP API
// //     final otpResponse = await authApi.verifyOtpApi(
// //       widget.phoneNumber,
// //       _otpController.text,
// //       fcmToken,
// //       deviceId,
// //     );

// //     if (otpResponse?.success == true) {
// //       CustomSnackbar.showCustomSnackbar(
// //         context: context,
// //         title: "Success",
// //         subtitle: otpResponse?.message ?? "Account verified successfully",
// //         backgroundColor: Colors.green,
// //       );
      
// //       // Get profile completion status
// //       final isProfileCompleted = otpResponse?.driver?.isProfileCompleted ?? false;
      
// //       // Navigate based on profile completion
// //       await Future.delayed(const Duration(milliseconds: 800));
      
// //       if (isProfileCompleted) {
// //         // Profile completed - go to home
// //         Get.offAll(() => const BottomnavmainScreen());
// //       } else {
// //         // Profile not completed - go to registration
// //         Get.off(() => DriverRegistration(
// //           // driverData: otpResponse?.driver,
// //         ));
// //       }
// //     } else {
// //       CustomSnackbar.showCustomSnackbar(
// //         context: context,
// //         title: "Error",
// //         subtitle: otpResponse?.message ?? "Invalid OTP. Please try again.",
// //         backgroundColor: Colors.red,
// //       );
// //     }
// //   }
// // }


// // views/auth/enter_otp_screen.dart
// import 'package:corezap_driver/AppPreferences/device_id_service.dart';
// import 'package:corezap_driver/AppPreferences/fcm_token_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:corezap_driver/apis/auth.api.dart';
// import 'package:corezap_driver/controller/otp_controller.dart';
// // import 'package:corezap_driver/services/device_id_service.dart';
// // import 'package:corezap_driver/services/fcm_token_service.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/custom_otps/custom_otp_box.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/Custom_Snackbar.dart';
// import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:corezap_driver/views/profile_related.dart/documents_related/driver_registration.dart';

// class EnterOtpScreen extends StatefulWidget {
//   final String typecheck;
//   final String phoneNumber;
//   final String receivedOtp;

//   EnterOtpScreen({
//     super.key, 
//     required this.typecheck, 
//     required this.phoneNumber, 
//     required this.receivedOtp
//   });

//   @override
//   State<EnterOtpScreen> createState() => _EnterOtpScreenState();
// }

// class _EnterOtpScreenState extends State<EnterOtpScreen> {
//   late final OtpController otpController;
//   late final AuthApi authApi;
//   late final DeviceIdService deviceIdService;
//   late final FcmTokenService fcmTokenService;
  
//   // OTP input
//   final TextEditingController _otpController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize controllers
//     authApi = Get.find<AuthApi>(); // Already initialized in SignupScreen
//     otpController = Get.put(OtpController()); // Initialize OtpController here
//     deviceIdService = Get.put(DeviceIdService()); // Initialize DeviceIdService
//     fcmTokenService = Get.put(FcmTokenService()); // Initialize FcmTokenService
    
//     // Auto-fill OTP if provided (for testing)
//     _otpController.text = widget.receivedOtp;
    
//     // Start OTP timer
//     otpController.startTimer();
//   }

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
    
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * .04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: w * .12),
            
//             // Back button
//             GestureDetector(
//               onTap: () => Get.back(),
//               child: SizedBox(
//                 width: w * .08,
//                 height: w * .08,
//                 child: Image.asset("assets/images/arrowLeft.png"),
//               ),
//             ),
            
//             SizedBox(height: w * .02),
            
//             // Title
//             CustomText(
//               text: "Verify Phone Number",
//               textFontSize: w * .06,
//               textColor: Colors.black,
//               textFontWeight: FontWeight.w600,
//             ),
            
//             SizedBox(height: w * .02),
            
//             // Description
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "Please enter the 4 digit code sent to ",
//                     style: TextStyle(
//                       fontSize: w * .042,
//                       color: Colors.grey[700],
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   TextSpan(
//                     text: "+91 ${widget.phoneNumber}",
//                     style: TextStyle(
//                       fontSize: w * .042,
//                       color: AppColors.black,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   TextSpan(
//                     text: " through SMS",
//                     style: TextStyle(
//                       fontSize: w * .042,
//                       color: Colors.grey[700],
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: w * .04),
            
//             // OTP Input
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: w * .07,
//                 vertical: w * .05,
//               ),
//               child: Column(
//                 children: [
//                   // OTP boxes
//                   CustomOtpBox(
//                     onChanged: (value) {
//                       _otpController.text = value;
//                     },
//                   ),
                  
//                   SizedBox(height: w * .02),
                  
//                   // Timer or Resend OTP
//                   Obx(() {
//                     if (otpController.secondsRemaining.value > 0) {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CustomText(
//                             text: "Haven't got the code yet? ",
//                             textFontSize: w * .035,
//                             textColor: Colors.grey[700],
//                             textFontWeight: FontWeight.w400,
//                           ),
//                           CustomText(
//                             text: "00:${otpController.secondsRemaining.value.toString().padLeft(2, '0')}",
//                             textFontSize: w * .035,
//                             textColor: AppColors.primaryRed,
//                             textFontWeight: FontWeight.w600,
//                           ),
//                         ],
//                       );
//                     } else {
//                       return GestureDetector(
//                         onTap: () {
//                           otpController.resendCode();
//                           // TODO: Add resend OTP API call
//                         },
//                         child: CustomText(
//                           text: "Resend OTP",
//                           textFontSize: w * .035,
//                           textColor: AppColors.primaryRed,
//                           textFontWeight: FontWeight.w600,
//                         ),
//                       );
//                     }
//                   }),
//                 ],
//               ),
//             ),
            
//             Spacer(),
//             SizedBox(height: w * .05),
            
//             // Verify Button
//             Obx(() => AppButtons.solid(
//               context: context,
//               text: "Verify",
//               onClicked: () async {
//                 await _verifyOtp();
//               },
//               isFullWidth: true,
//               backgroundColor: AppColors.primaryRed,
//               textColor: Colors.white,
//               fontSize: w * .045,
//               height: w * .140,
//               radius: 12.0,
//               isLoading: authApi.verifyOtpLoader.value,
//               fontWeight: FontWeight.w500,
//             )),
            
//             SizedBox(height: w * .1),
//           ],
//         ),
//       ),
//     );
//   }

//   // Verify OTP function
//   Future<void> _verifyOtp() async {
//     // Validate OTP
//     if (_otpController.text.isEmpty || _otpController.text.length != 4) {
//       CustomSnackbar.showCustomSnackbar(
//         context: context,
//         title: "Error",
//         subtitle: "Please enter a valid 4-digit OTP",
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     // Get device ID and FCM token
//     final deviceId = await deviceIdService.getDeviceId();
//     final fcmToken = await fcmTokenService.getOrCreateFcmToken();

//     print("Sending Device ID: $deviceId");
//     print("Sending FCM Token: $fcmToken");
//     print("Phone Number: ${widget.phoneNumber}");
//     print("OTP: ${_otpController.text}");

//     // Call verify OTP API
//     final otpResponse = await authApi.verifyOtpApi(
//       widget.phoneNumber,
//       _otpController.text,
//       fcmToken,
//       deviceId,
//     );

//     if (otpResponse?.success == true) {
//       CustomSnackbar.showCustomSnackbar(
//         context: context,
//         title: "Success",
//         subtitle: otpResponse?.message ?? "Account verified successfully",
//         backgroundColor: Colors.green,
//       );
      
//       // Get profile completion status
//       final isProfileCompleted = otpResponse?.driver?.isProfileCompleted ?? false;
      
//       // Navigate based on profile completion
//       await Future.delayed(const Duration(milliseconds: 800));
      
//       if (isProfileCompleted) {
//         // Profile completed - go to home
//         Get.offAll(() => const BottomnavmainScreen());
//       } else {
//         // Profile not completed - go to registration
//         Get.off(() => DriverRegistration(
//           // driverData: otpResponse?.driver,
//         ));
//       }
//     } else {
//       CustomSnackbar.showCustomSnackbar(
//         context: context,
//         title: "Error",
//         subtitle: otpResponse?.message ?? "Invalid OTP. Please try again.",
//         backgroundColor: Colors.red,
//       );
//     }
//   }
// }

import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/views/profile_related.dart/documents_related/driver_registration.dart';
import 'package:corezap_driver/views/profile_related.dart/documents_related/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/otp_controller.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/custom_otps/custom_otp_box.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnterOtpScreen extends StatefulWidget {
  dynamic typecheck;
  dynamic phoneNumber;
  dynamic receivedOtp;

  EnterOtpScreen({
    super.key,
    required this.typecheck,
    required this.phoneNumber,
    required this.receivedOtp,
  });

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final Controllers contentController = Get.put(Controllers());
  final OtpController otpController = Get.put(OtpController());
  bool isLoading = false;
  String errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  static String baseUrl = "https://api.corezap.framekarts.com/api/v1";
  static String verifyOtp = "$baseUrl/driver/verifyOtp";

  @override
  void initState() {
    contentController.maxheightReach.value = false;
    super.initState();
    otpController.startTimer();
    setupOtpFocusListeners();
  }

  void setupOtpFocusListeners() {
    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].addListener(() {
        if (otpControllers[i].text.length == 1 && i < otpControllers.length - 1) {
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
      });
    }
  }

  String getOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOtpApi() async {
    if (getOtp().length != 4) {
      setState(() {
        errorMessage = 'Please enter all 4 digits of OTP';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final Map<String, dynamic> requestBody = {
        "phone": widget.phoneNumber,
        "otp": getOtp(),
        "fcmToken": "test-fcm-token-123", // You can make this dynamic if needed
        "deviceId": "device-001", // You can make this dynamic if needed
      };

      final response = await http.post(
        Uri.parse(verifyOtp),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true) {
          // Save token and driver data to shared preferences or state management
          String token = responseData['token'];
          Map<String, dynamic> driverData = responseData['driver'];
          

          navigateBasedOnType();
          // Show success modal
          // showVerificationSuccessModal(
          //   context: context,
          //   token: token,
          //   driverData: driverData,
          //   onContinue: () {
          //     Navigator.of(context).pop(); // Close modal
          //     navigateBasedOnType();
          //   },
          // );
        } else {
          setState(() {
            errorMessage = responseData['message'] ?? 'Verification failed';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateBasedOnType() {
    if (widget.typecheck == "new") {
      CustomNavigator.push(
        context,
        DriverRegistration(),
        transition: TransitionType.slideLeft,
      );
    } else {
      CustomNavigator.push(
        context,
        const BottomnavmainScreen(),
        transition: TransitionType.fade,
      );
    }
  }

  void showVerificationSuccessModal({
    required BuildContext context,
    required String token,
    required Map<String, dynamic> driverData,
    required VoidCallback onContinue,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double w = MediaQuery.of(context).size.width;
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: w * 0.15,
              ),
              SizedBox(height: w * 0.03),
              CustomText(
                text: "Verified Successfully!",
                textFontSize: w * 0.05,
                textColor: ColorsList.titleTextColor,
                textFontWeight: FontWeight.w600,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: "Account verified successfully",
                  textFontSize: w * 0.04,
                  textColor: ColorsList.subtitleTextColor,
                  textFontWeight: FontWeight.w400,
                ),
                SizedBox(height: w * 0.03),
                Divider(color: Colors.grey[300]),
                SizedBox(height: w * 0.03),
                CustomText(
                  text: "Driver Details:",
                  textFontSize: w * 0.04,
                  textColor: ColorsList.titleTextColor,
                  textFontWeight: FontWeight.w600,
                ),
                SizedBox(height: w * 0.02),
                _buildDetailRow("Name", driverData['name'] ?? 'N/A'),
                _buildDetailRow("Phone", driverData['phone'] ?? 'N/A'),
                _buildDetailRow("Email", driverData['email'] ?? 'N/A'),
                _buildDetailRow("Status", driverData['imageVerificationStatus'] ?? 'N/A'),
                SizedBox(height: w * 0.03),
                Divider(color: Colors.grey[300]),
                SizedBox(height: w * 0.03),
                CustomText(
                  text: "Token generated successfully",
                  textFontSize: w * 0.035,
                  textColor: Colors.green,
                  textFontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
              child: AppButtons.solid(
                context: context,
                text: "Continue",
                onClicked: onContinue,
                isFullWidth: true,
                backgroundColor: ColorsList.mainButtonColor,
                textColor: AppColors.black,
                fontSize: w * 0.04,
                height: w * 0.12,
                radius: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: "$label:",
            textFontSize: 14,
            textColor: Colors.grey[600],
            textFontWeight: FontWeight.w500,
          ),
          CustomText(
            text: value,
            textFontSize: 14,
            textColor: ColorsList.titleTextColor,
            textFontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: w * .12),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: w * .08,
                height: w * .08,
                child: Image.asset("assets/images/arrowLeft.png"),
              ),
            ),
            SizedBox(height: w * .02),
            CustomText(
              text: "Verify Phone Number",
              textFontSize: w * .06,
              textColor: ColorsList.titleTextColor,
              textFontWeight: FontWeight.w600,
            ),
            SizedBox(height: w * .02),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Please enter the 4 digit code sent to ",
                    style: TextStyle(
                      fontSize: w * .042,
                      color: ColorsList.subtitleTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "+91 ${widget.phoneNumber}",
                    style: TextStyle(
                      fontSize: w * .042,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: " through SMS",
                    style: TextStyle(
                      fontSize: w * .042,
                      color: ColorsList.subtitleTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: w * .02),
            
            // OTP Input Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * .07, vertical: w * .05),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: w * 0.15,
                          child: TextFormField(
                            controller: otpControllers[index],
                            focusNode: focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[400]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: ColorsList.mainAppColor,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: TextStyle(
                              fontSize: w * 0.06,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                              }
                              if (value.isEmpty && index > 0) {
                                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                              }
                              setState(() {});
                            },
                          ),
                        );
                      }),
                    ),
                    
                    SizedBox(height: w * .02),
                    
                    // Error message
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: w * .02),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: w * 0.035,
                          ),
                        ),
                      ),
                    
                    // Timer/Resend OTP
                    Obx(() {
                      if (otpController.secondsRemaining.value > 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Haven't got the confirmation code yet?",
                              textFontSize: w * .035,
                              textColor: ColorsList.subtitleTextColor,
                              textFontWeight: FontWeight.w400,
                            ),
                            SizedBox(width: w * .01),
                            CustomText(
                              text: "00:${otpController.secondsRemaining.value.toString().padLeft(2, '0')}",
                              textFontSize: w * .035,
                              textColor: ColorsList.subtitleTextColor,
                              textFontWeight: FontWeight.w400,
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: otpController.resendCode,
                          child: CustomText(
                            text: "Resend OTP",
                            textFontSize: w * .035,
                            textColor: ColorsList.mainAppColor,
                            textFontWeight: FontWeight.w600,
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
            
            Spacer(),
            
            // Verify Button
            Padding(
              padding: EdgeInsets.only(bottom: w * .1),
              child: AppButtons.solid(
                context: context,
                text: isLoading ? "Verifying..." : "Verify",
                onClicked: () async{

  //  isLoading ? null : await verifyOtpApi();


  navigateBasedOnType();
  // isLoading ? null : await verifyOtpApi();

   
                },
                
               
                isFullWidth: true,
                backgroundColor: isLoading ? Colors.grey : ColorsList.mainButtonColor,
                textColor: AppColors.black,
                fontSize: w * .045,
                height: w * .140,
                radius: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}