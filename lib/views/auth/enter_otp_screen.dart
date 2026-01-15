

import 'package:corezap_driver/controller/login.controller.dart'; // Make sure this is the correct path
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/views/profile_related.dart/documents_related/driver_registration.dart';
import 'package:corezap_driver/views/profile_related.dart/documents_related/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/otp_controller.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';

class EnterOtpScreen extends StatefulWidget {
  final dynamic typecheck;
  final dynamic phoneNumber;
  final dynamic receivedOtp;

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
  final LoginController loginController = Get.put(
    LoginController(),
  ); // Add Get.put here

  bool isLoading = false;
  String errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

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
        if (otpControllers[i].text.length == 1 &&
            i < otpControllers.length - 1) {
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
      });
    }
  }

  String getOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOtp() async {
    final String otp = getOtp();

    // Validate OTP
    if (otp.length != 4) {
      setState(() {
        errorMessage = 'Please enter a valid 4-digit OTP';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Use the LoginController's verifyOtp method
      await loginController.verifyOtp(
        otp: otp,
        phoneNumber: widget.phoneNumber.toString(),
      );

      // Wait a bit for the controller to update
      await Future.delayed(Duration(milliseconds: 100));
      
      print("hellowwww>>>> ${loginController.isProfileCompleted22.value}");
      // Check if OTP was verified successfully
      if (loginController.isProfileCompleted22.value) {
        // Navigate based on type
        navigateBasedOnType();
      } else {
        setState(() {
          errorMessage = loginController.otpError.value;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again.';
      });
      Get.snackbar(
        'Error',
        'Verification failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateBasedOnType() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loginController.isProfileCompleted.value == true) {
        CustomNavigator.push(
          context,
          const BottomnavmainScreen(),
          transition: TransitionType.fade,
        );
      } else {
        CustomNavigator.push(
          context,
          DriverRegistration(),
          transition: TransitionType.slideLeft,
        );
      }
    });
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
              padding: EdgeInsets.symmetric(
                horizontal: w * .07,
                vertical: w * .05,
              ),
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
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNodes[index + 1]);
                              }
                              if (value.isEmpty && index > 0) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNodes[index - 1]);
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
                              text:
                                  "00:${otpController.secondsRemaining.value.toString().padLeft(2, '0')}",
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
                onClicked: verifyOtp, // Call the verifyOtp method
                isFullWidth: true,
                backgroundColor: isLoading
                    ? Colors.grey
                    : ColorsList.mainButtonColor,
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