import 'dart:convert';
import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/form_field.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/auth/enter_otp_screen.dart';
import 'package:nzcu_driver/views/auth/signup_screen.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/views/profile_screens/terms_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DriverFormController driverFormController = Get.put(DriverFormController());
  TextEditingController phoneController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginController loginController = Get.put(LoginController());

  // Validation flags
  bool isPhoneValid = false;
  bool showPhoneError = false;
  bool showTermsError = false;

  @override
  void initState() {
    super.initState();
    // Reset controller state when screen loads
    loginController.reset();

    // Add listener for phone number validation
    phoneController.addListener(() {
      final text = phoneController.text;
      // Validate phone number as user types
      if (text.isNotEmpty) {
        setState(() {
          isPhoneValid = _validatePhoneNumber(text);
          // Only show error if user has typed something and it's invalid
          showPhoneError = text.isNotEmpty && !isPhoneValid;
        });
      } else {
        setState(() {
          isPhoneValid = false;
          showPhoneError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // Phone number validation function
  bool _validatePhoneNumber(String phone) {
    // Check if it's exactly 10 digits and contains only numbers
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  // Handle OTP sending with validations
  Future<void> _handleSendOtp() async {
    // Reset error states
    setState(() {
      showPhoneError = false;
      showTermsError = false;
    });

    // Validate phone number
    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        showPhoneError = true;
      });
      CustomToast.showError('Please enter phone number');
      return;
    }

    if (!_validatePhoneNumber(phoneNumber)) {
      setState(() {
        showPhoneError = true;
      });
      CustomToast.showError('Please enter a valid 10-digit phone number');
      return;
    }

    // Validate terms checkbox
    if (!loginController.isChecked.value) {
      setState(() {
        showTermsError = true;
      });
      CustomToast.showError('Please accept Terms & Conditions');
      return;
    }

    // All validations passed, send OTP
    await loginController.sendOtp(phoneNumber);

    // If OTP sent successfully, navigate to OTP screen
    if (loginController.isOtpSent.value) {
      CustomNavigator.push(
        context,
        EnterOtpScreen(
          typecheck: "",
          phoneNumber: phoneNumber,
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

              // Column
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Space 1
                    SizedBox(height: w * 0.04),
                    // Text
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

                    // Text 2
                    SizedBox(height: w * 0.02),
                    AppFonts.textPoppins(
                          context,
                          "Let's get started! Enter your phone number to create your NZCU account.",
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

                    // Space 2
                    SizedBox(height: w * 0.04),

                    // Text 3
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

                    // Space 3
                    SizedBox(height: w * 0.02),

                    // Text field with error message
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFormFields.custTextFormOther(
                              context: context,
                              hintText: "Enter 10-digit phone number",
                              controller: phoneController,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                            )
                            .animate()
                            .fade(duration: 1200.ms, curve: Curves.easeInOut)
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1, 1),
                            ),

                        // Error message for phone number
                        if (showPhoneError)
                          Padding(
                            padding: EdgeInsets.only(top: w * 0.01),
                            child: Text(
                              'Please enter a valid 10-digit phone number',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: w * 0.03,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Row with checkbox and text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * .010),
                child:
                    Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // CheckBox
                                Obx(
                                  () => Checkbox(
                                    value: loginController.isChecked.value,
                                    activeColor: const Color(0xFF7C7C8D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (value) {
                                      loginController.isChecked.value = value!;
                                      // Hide terms error when checked
                                      if (value) {
                                        setState(() {
                                          showTermsError = false;
                                        });
                                      }
                                    },
                                  ),
                                ),

                                // Text
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

                                // Terms & Conditions text
                                InkWell(
                                  onTap: () {
                                    CustomNavigator.push(
                                      context,
                                      TermsCondition(),
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

                            // Error message for terms and conditions
                            if (showTermsError)
                              Padding(
                                padding: EdgeInsets.only(
                                  left: w * 0.05,
                                  top: w * 0.01,
                                ),
                                child: Text(
                                  'Please accept Terms & Conditions',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: w * 0.03,
                                  ),
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

              // Space
              SizedBox(height: w * 0.05),

              // Space
              // SizedBox(height: w * 0.00),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           AppFonts.textPoppins(
              //             context,
              //             "Already have an account? ",
              //             w * 0.036,
              //             FontWeight.w400,
              //             AppColors.black.withOpacity(0.7),
              //             TextAlign.left,
              //             TextOverflow.visible,
              //           ),

              //           // Sign in link
              //           InkWell(
              //             onTap: () {
              //               CustomNavigator.push(
              //                 context,
              //                 SignupScreen(),
              //                 transition: TransitionType.slideLeft,
              //               );
              //             },
              //             child: AppFonts.textPoppins(
              //               context,
              //               "Sign Up",
              //               w * 0.036,
              //               FontWeight.w400,
              //               const Color(0xFF439AFE),
              //               TextAlign.left,
              //               TextOverflow.visible,
              //             ),
              //           ),
              //         ],
              //       ).animate().fade(duration: 1300.ms, curve: Curves.easeInOut).scale(
              //             begin: const Offset(0.95, 0.95),
              //             end: const Offset(1, 1),
              //           ),
              //     ],
              //   ),
              // ),

              // Space
              SizedBox(height: w * 0.04),

              // Space
              SizedBox(height: w * 0.09),

              // Login
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child:
                    Obx(
                          () => AppButtons.solid2(
                            context: context,
                            text: "Login",
                            onClicked:
                                _handleSendOtp, // Click handler with validations
                            isButtonEnabled: true, // Button is always enabled
                            isFullWidth: true,
                            fontSize: w * 0.045,
                            height: w * 0.140,
                            radius: 12.0,
                            isLoading: loginController.isLoading.value,
                            textColor: AppColors.black,
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

              // Send OTP button - Always enabled
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              //   child: Obx(
              //     () => AppButtons.solid2(
              //       context: context,
              //       text: "Send OTP",
              //       onClicked: _handleSendOtp, // Click handler with validations
              //       isButtonEnabled: true, // Button is always enabled
              //       isFullWidth: true,
              //       fontSize: w * 0.045,
              //       height: w * 0.140,
              //       radius: 12.0,
              //       isLoading: loginController.isLoading.value,
              //       textColor: AppColors.black,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ).animate().fade(duration: 1600.ms, curve: Curves.easeInOut).scale(
              //         begin: const Offset(0.95, 0.95),
              //         end: const Offset(1, 1),
              //       ),
              // ),
              SizedBox(height: w * .1),
            ],
          ),
        ),
      ),
    );
  }

  // Common widget (if needed elsewhere)
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
