

// // controllers/signup_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nzcu_driver/apis/auth.api.dart';
// import 'package:nzcu_driver/utilities/Custom_Snackbar.dart';
// import 'package:nzcu_driver/utilities/navigator.dart';
// import 'package:nzcu_driver/views/auth/enter_otp_screen.dart';

// class SignupController extends GetxController {
//   late final AuthApi authApi;
//   final RxString phoneNumber = ''.obs;
//   final RxBool isLoading = false.obs;
//   final RxBool termsAgreed = false.obs;
  
//   // Store form data for multi-step signup
//   final RxMap<String, dynamic> signupData = <String, dynamic>{}.obs;
//   final RxInt currentStep = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
    
//     // Get the AuthApi instance that was already initialized in SignupScreen
//     authApi = Get.find<AuthApi>();
//   }

//   // Send OTP and navigate to OTP screen
//   Future<void> sendOtpAndNavigate(
//     BuildContext context, 
//     String mobile,
//     bool isResend
//   ) async {
//     // Validate phone number first
//     final validationError = validatePhoneNumber(mobile);
//     if (validationError != null) {
//       CustomSnackbar.showCustomSnackbar(
//         context: context,
//         title: "Validation Error",
//         subtitle: validationError,
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     // Check terms agreement
//     if (!termsAgreed.value && !isResend) {
//       CustomSnackbar.showCustomSnackbar(
//         context: context,
//         title: "Error",
//         subtitle: "Please agree to Terms & Conditions",
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     isLoading.value = true;
    
//     try {
//       // Call the API
//       var result = await authApi.sendOtpApi(mobile);
      
//       if (result['success'] == true) {
//         // Store phone number
//         phoneNumber.value = mobile;
//         signupData['phone'] = mobile;
        
//         // Show success message
//         CustomSnackbar.showCustomSnackbar(
//           context: context,
//           title: "Success",
//           subtitle: result['message'] ?? "OTP sent successfully",
//           backgroundColor: Colors.green,
//         );
        
//         // Start OTP timer
//         authApi.startOtpTimer();
        
//         // Navigate to OTP screen after a small delay for better UX
//         await Future.delayed(const Duration(milliseconds: 500));
        
//         CustomNavigator.push(
//           context,
//           EnterOtpScreen(
//             typecheck: "new",
//             phoneNumber: mobile,
//             receivedOtp: authApi.receivedOtp.value,
//           ),
//           transition: TransitionType.fade,
//         );
//       } else {

//          CustomNavigator.push(
//           context,
//           EnterOtpScreen(
//             typecheck: "new",
//             phoneNumber: mobile,
//             receivedOtp: authApi.receivedOtp.value,
//           ),
//           transition: TransitionType.fade,
//         );
//         // Show error message
//         CustomSnackbar.showCustomSnackbar(
//           context: context,
//           title: "Error",
//           subtitle: result['message'] ?? "Failed to send OTP",
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {

//        CustomNavigator.push(
//           context,
//           EnterOtpScreen(
//             typecheck: "new",
//             phoneNumber: mobile,
//             receivedOtp: authApi.receivedOtp.value,
//           ),
//           transition: TransitionType.fade,
//         );
//       // Handle any unexpected errors
//       CustomSnackbar.showCustomSnackbar(
//         context: context,
//         title: "Error",
//         subtitle: "Something went wrong. Please try again.",
//         backgroundColor: Colors.red,
//       );



//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Validate phone number
//   String? validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter phone number';
//     }
//     if (value.length != 10) {
//       return 'Please enter valid 10-digit number';
//     }
//     if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//       return 'Only numbers are allowed';
//     }
//     return null;
//   }

//   // Toggle terms agreement
//   void toggleTermsAgreement(bool value) {
//     termsAgreed.value = value;
//   }

//   // Clear all data
//   void clearData() {
//     phoneNumber.value = '';
//     termsAgreed.value = false;
//     signupData.clear();
//     currentStep.value = 0;
//   }

//   // Update signup data (for multi-step forms)
//   void updateSignupData(String key, dynamic value) {
//     signupData[key] = value;
//   }

//   // Navigate to next step
//   void goToNextStep() {
//     currentStep.value++;
//   }

//   // Navigate to previous step
//   void goToPreviousStep() {
//     if (currentStep.value > 0) {
//       currentStep.value--;
//     }
//   }

//   // Get current step progress
//   double getProgress() {
//     return (currentStep.value + 1) / 3; // Assuming 3 steps
//   }
// }