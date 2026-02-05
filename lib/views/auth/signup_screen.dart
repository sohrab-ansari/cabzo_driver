import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'package:nzcu_driver/controllers/auth_controllers/signup_controller.dart';
import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/utilities/Custom_Snackbar.dart';
import 'package:nzcu_driver/utilities/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';
import 'package:nzcu_driver/utilities/form_field.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:nzcu_driver/views/profile_related.dart/terms_condition.dart';
import 'package:nzcu_driver/views/auth/enter_otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final DriverFormController driverFormController;
  late final TextEditingController phoneController;
  late final LoginController loginController;
  // late final SignupController signupController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    driverFormController = Get.find<DriverFormController>();
    loginController = Get.find<LoginController>();
    // signupController = Get.put(SignupController());

    // Initialize text controller
    phoneController = TextEditingController();

    // Add listener to update button state when phone number changes
    phoneController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  bool get isButtonEnabled {
    return phoneController.text.length == 10 && loginController.isChecked.value;
  }

  Future<void> _handleSendOtp() async {
    // Validate terms checkbox
    if (!loginController.isChecked.value) {
      Get.snackbar(
        'Error',
        'Please accept Terms & Conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate phone number length
    if (phoneController.text.length != 10) {
      Get.snackbar(
        'Error',
        'Please enter a valid 10-digit phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Send OTP
    await loginController.sendOtp(phoneController.text.trim());

    // If OTP sent successfully, navigate to OTP screen
    if (loginController.isOtpSent.value) {
      CustomNavigator.push(
        context,
        EnterOtpScreen(
          typecheck: "new",
          phoneNumber: phoneController.text,
          receivedOtp: "",
        ),
        transition: TransitionType.fade,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.05),

              // Login screen Image
              Image.asset("assets/images/image7.png", fit: BoxFit.fill)
                  .animate()
                  .fade(duration: 800.ms, curve: Curves.easeInOut)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),

              // Column with form fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: w * 0.04),

                    // Heading
                    AppFonts.textPoppins(
                          context,
                          "Join NZCU Today",
                          w * 0.06,
                          FontWeight.w600,
                          AppColors.black,
                          TextAlign.left,
                          TextOverflow.visible,
                        )
                        .animate()
                        .fade(duration: 900.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),

                    // Subheading
                    SizedBox(height: w * 0.02),
                    AppFonts.textPoppins(
                          context,
                          "Let's get started! Enter your phone number to create your account.",
                          w * 0.038,
                          FontWeight.w400,
                          AppColors.darkGray.withOpacity(0.6),
                          TextAlign.left,
                          TextOverflow.visible,
                          maxLines: 2,
                        )
                        .animate()
                        .fade(duration: 1000.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),

                    SizedBox(height: w * 0.04),

                    // Phone Number Label
                    AppFonts.textPoppins(
                          context,
                          "Phone Number",
                          w * 0.038,
                          FontWeight.w500,
                          AppColors.black.withOpacity(0.8),
                          TextAlign.left,
                          TextOverflow.visible,
                        )
                        .animate()
                        .fade(duration: 1100.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),

                    SizedBox(height: w * 0.02),

                    // Phone Number Text Field
                    AppFormFields.custTextFormOther(
                          context: context,
                          hintText: "Enter 10-digit mobile number",
                          controller: phoneController,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        )
                        .animate()
                        .fade(duration: 1200.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),
                  ],
                ),
              ),

              // Terms and Conditions Checkbox
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child:
                    Row(
                          children: [
                            // Checkbox using LoginController
                            Obx(
                              () => Checkbox(
                                value: loginController.isChecked.value,
                                activeColor: AppColors.primaryRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    loginController.isChecked.value = value;
                                  }
                                },
                              ),
                            ),

                            // Terms text
                            AppFonts.textPoppins(
                              context,
                              "I agree to NZCU ",
                              w * 0.032,
                              FontWeight.w500,
                              AppColors.black.withOpacity(0.7),
                              TextAlign.left,
                              TextOverflow.visible,
                              maxLines: 2,
                            ),

                            // Terms link
                            InkWell(
                              onTap: () {
                                CustomNavigator.push(
                                  context,
                                  const TermsCondition(),
                                  transition: TransitionType.slideTop,
                                );
                              },
                              child: AppFonts.textPoppins(
                                context,
                                "Terms & Conditions",
                                w * 0.032,
                                FontWeight.w400,
                                const Color(0xFF439AFE),
                                TextAlign.left,
                                TextOverflow.visible,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fade(duration: 1300.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),
              ),

              SizedBox(height: w * 0.07),

              // Already have an account section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  children: [
                    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppFonts.textPoppins(
                              context,
                              "Already have an account? ",
                              w * 0.036,
                              FontWeight.w400,
                              AppColors.black.withOpacity(0.7),
                              TextAlign.left,
                              TextOverflow.visible,
                            ),

                            // Sign in link
                            InkWell(
                              onTap: () {
                                CustomNavigator.push(
                                  context,
                                  const LoginScreen(),
                                  transition: TransitionType.slideLeft,
                                );
                              },
                              child: AppFonts.textPoppins(
                                context,
                                "Sign in",
                                w * 0.036,
                                FontWeight.w400,
                                const Color(0xFF439AFE),
                                TextAlign.left,
                                TextOverflow.visible,
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fade(duration: 1300.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),
                  ],
                ),
              ),

              SizedBox(height: w * 0.04),
              SizedBox(height: w * 0.09),

              // Signup Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child:
                    Obx(
                          () => AppButtons.solid2(
                            context: context,
                            text: "Sign Up",
                            onClicked: _handleSendOtp,
                            isButtonEnabled: isButtonEnabled,
                            isFullWidth: true,
                            fontSize: w * 0.045,
                            height: w * 0.140,
                            radius: 12.0,
                            isLoading: loginController.isLoading.value,
                            textColor: isButtonEnabled
                                ? AppColors.black
                                : AppColors.darkGray.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                        .animate()
                        .fade(duration: 1600.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),
              ),
              SizedBox(height: w * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  // Handle signup button click
  Future<void> _handleSignup() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if terms are agreed
    if (!loginController.isChecked.value) {
      // CustomSnackbar.showError('Please agree to Terms & Conditions');
      return;
    }

    final phoneNumber = phoneController.text.trim();

    try {
      loginController.isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, generate a random OTP
      // In production, call your actual API
      final String otp = _generateRandomOtp();

      // Navigate to OTP screen
      CustomNavigator.push(
        context,
        EnterOtpScreen(
          typecheck: "new",
          phoneNumber: phoneNumber,
          receivedOtp: otp,
        ),
        transition: TransitionType.fade,
      );
    } catch (e) {
      // CustomSnackbar.showError('Failed to sign up: ${e.toString()}');
    } finally {
      loginController.isLoading.value = false;
    }
  }

  String _generateRandomOtp() {
    // Generate a random 6-digit OTP
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }

  // Common widget method (if you still need it)
  Widget commonWidget(
    String icon,
    String text,
    BuildContext context,
    VoidCallback onClicked,
  ) {
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onClicked,
      child: Container(
        height: w * 0.13,
        width: w * 0.45,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black.withOpacity(0.1), width: 1),
          borderRadius: BorderRadius.circular(w * 0.03),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: w * 0.05, width: w * 0.05),
            SizedBox(width: w * 0.03),
            AppFonts.textPoppins(
              context,
              text,
              w * 0.036,
              FontWeight.w600,
              AppColors.black.withOpacity(0.7),
              TextAlign.left,
              TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
