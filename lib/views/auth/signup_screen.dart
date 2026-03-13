import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/form_field.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:nzcu_driver/views/profile_screens/terms_condition.dart';
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

  // Local state for checkbox
  bool _isTermsAccepted = false;
  bool _showTermsError = false; // New state to show error

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    driverFormController = Get.find<DriverFormController>();
    loginController = Get.find<LoginController>();

    // Initialize text controller
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    // Reset terms error
    setState(() {
      _showTermsError = false;
    });

    // First validate the form fields
    if (!_formKey.currentState!.validate()) {
      CustomToast.showError('Please fix the errors in the form');
      return;
    }

    // Validate terms checkbox using local state
    if (!_isTermsAccepted) {
      // Show error in UI
      setState(() {
        _showTermsError = true;
      });

      // Also show snackbar for additional feedback
      CustomToast.showError('Please accept Terms & Conditions');
      return;
    }

    // Validate phone number format
    final phoneNumber = phoneController.text.trim();

    // If all validations pass, proceed with sending OTP
    await _sendOtpAndNavigate(phoneNumber);
  }

  Future<void> _sendOtpAndNavigate(String phoneNumber) async {
    try {
      // Call the sendOtp method from loginController
      await loginController.sendOtp(phoneNumber);

      // If OTP sent successfully, navigate to OTP screen
      if (loginController.isOtpSent.value) {
        CustomNavigator.push(
          context,
          EnterOtpScreen(
            typecheck: "new",
            phoneNumber: phoneNumber,
            receivedOtp: "",
          ),
          transition: TransitionType.fade,
        );
      }
    } catch (e) {
      // Handle any errors from the sendOtp method
      CustomToast.showError('Failed to send OTP: ${e.toString()}');
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

              // Terms and Conditions Checkbox with error
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child:
                    Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Checkbox using local state
                                Checkbox(
                                  value: _isTermsAccepted,
                                  activeColor: AppColors.primaryRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _isTermsAccepted = value;
                                        // Hide error when checkbox is checked
                                        if (value) {
                                          _showTermsError = false;
                                        }
                                      });
                                    }
                                  },
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
                            ),

                            // Show error message if terms not accepted
                            if (_showTermsError)
                              Padding(
                                padding: EdgeInsets.only(
                                  left: w * 0.02,
                                  top: w * 0.01,
                                ),
                                child: AppFonts.textPoppins(
                                  context,
                                  "Please accept Terms & Conditions",
                                  w * 0.032,
                                  FontWeight.w400,
                                  Colors.red,
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
              ),

              SizedBox(height: w * 0.05), // Reduced space
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

              // Signup Button - ALWAYS ENABLED
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child:
                    AppButtons.solid2(
                          context: context,
                          text: "Sign Up",
                          onClicked: _handleSignup,
                          isButtonEnabled: true, // Always enabled
                          isFullWidth: true,
                          fontSize: w * 0.045,
                          height: w * 0.140,
                          radius: 12.0,
                          isLoading: loginController.isLoading.value,
                          // Always use primary color since button is always enabled
                          backgroundColor: AppColors.primaryRed,
                          textColor:
                              AppColors.white, // White text for better contrast
                          fontWeight: FontWeight.w500,
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
