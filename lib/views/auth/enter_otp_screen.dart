import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:nzcu_driver/views/profile_screens/documents_related/driver_registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/home_controllers/controllers.dart';
import 'package:nzcu_driver/controllers/auth_controllers/otp_controller.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/services/apiservices/auth_api_service.dart';
import 'package:nzcu_driver/modals/auth_modals/Otp_verify_res.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // final LoginController loginController = Get.put(LoginController());

  final LoginController loginController = Get.find<LoginController>();

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

  Future<void> verifyOtp2() async {
    final String otp = getOtp();

    // Validate OTP
    if (otp.length != 4) {
      if (mounted) {
        setState(() {
          errorMessage = 'Please enter a valid 4-digit OTP';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
    }

    try {
      // Call AuthApiService directly
      final OtpverifyRes res = await AuthApiService.verifyOtp(
        otp: otp,
        phoneNumber: widget.phoneNumber.toString(),
      );

      // Check success
      if (res.success != true) {
        if (mounted) {
          setState(() {
            errorMessage = res.message ?? 'Invalid OTP. Please try again.';

            // CustomNavigator.removeUntil(
            //   context!,
            //   LoginScreen(),
            //   transition: TransitionType.fade,
            // );
            isLoading = false;
          });
        }

        return;
      }

      print("✅ OTP Verified Successfully");

      // Update LoginController state for consistency
      loginController.isOtpVerified.value = true;

      if (res.driver == null) {
        print("❌ Driver data is null in response");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      // Extract driver status
      final String imageStatus = res.driver?.imageVerificationStatus ?? "draft";
      final String profileStatus =
          res.driver?.profileVerificationStatus ?? "draft";
      final String vehicleStatus =
          res.driver?.vehicleVerificationStatus ?? "draft";
      final String completeVerified = res.driver?.isCompleteVerified ?? "draft";

      // Helper to check if completely verified
      bool isProfileCompleted = false;
      if (res.driver?.isProfileCompleted is bool) {
        isProfileCompleted = res.driver?.isProfileCompleted as bool;
      } else if (res.driver?.isProfileCompleted is String) {
        isProfileCompleted =
            res.driver?.isProfileCompleted.toString().toLowerCase() == 'true';
      }

      print("🔍 Status Check:");
      print("  - Image: $imageStatus");
      print("  - Profile: $profileStatus");
      print("  - Vehicle: $vehicleStatus");
      print("  - Complete Verified: $completeVerified");
      print("  - Profile Completed: $isProfileCompleted");

      print(">>>>>> imageStatus: $imageStatus");
      print(">>>>> profileStatus: $profileStatus");
      print(">>>>>> vehicleStatus: $vehicleStatus");
      print(">>>>>> completeVerified: $completeVerified");

      // CASE 6: All Verified -> Home
      if (imageStatus == "verified" &&
          profileStatus == "verified" &&
          vehicleStatus == "verified" &&
          completeVerified == "verified" &&
          isProfileCompleted) {
        print("🚀 All Verified - Navigating to Home");
        CustomNavigator.removeUntil(
          context,
          BottomnavmainScreen(),
          transition: TransitionType.fade,
        );
        return;
      }

      // CASE 1: Profile Completed & Verified (Alternative check)
      if (isProfileCompleted && completeVerified == "verified") {
        print("🚀 Profile Complete & Verified - Navigating to Home");
        CustomNavigator.push(
          context,
          BottomnavmainScreen(),
          transition: TransitionType.fade,
        );
        return;
      }

      // Find DriverFormController to set steps
      final DriverFormController driverFormController = Get.put(
        DriverFormController(),
      );

      // CASE 2: All Draft -> Registration (Step 0)
      if (imageStatus == "draft" &&
          profileStatus == "draft" &&
          vehicleStatus == "draft") {
        print("📝 All Draft - Navigating to Registration");
        driverFormController.activeStep.value = 0; // Ensure start
        CustomNavigator.removeUntil(
          context,
          DriverRegistration(mobileNumber: widget.phoneNumber),
          transition: TransitionType.slideLeft,
        );
        return;
      }

      // // CASE 5: All Pending -> Wait (Toast)
      // if (imageStatus == "pending" &&
      //     profileStatus == "pending" &&
      //     vehicleStatus == "pending" &&
      //     completeVerified == "pending") {
      //   print("⏳ All Pending - Showing toast");
      //   Fluttertoast.showToast(
      //     msg: "Please wait, admin will approve your account.",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.TOP,
      //     backgroundColor: Colors.black87,
      //     textColor: Colors.white,
      //   );
      //   if (mounted) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //   }
      //   return;
      // }
      print(">>>>>> imageStatus: $imageStatus");
      print(">>>>> profileStatus: $profileStatus");
      print(">>>>>> vehicleStatus: $vehicleStatus");
      print(">>>>>> completeVerified: $completeVerified");
      // CASE 5: All Pending -> Wait (Toast)
      if (imageStatus == "pending" &&
          profileStatus == "pending" &&
          vehicleStatus == "pending" &&
          completeVerified == "pending") {
        print("⏳ All Pending - Showing toast");

        // ✅ Save in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("account_status", "pending");
        // You can change to "approve" if needed

        Fluttertoast.showToast(
          msg: "Please wait, admin will approve your account.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
        );

        Get.offAll(LoginScreen());
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        return;
      }

      // CASE 4: Profile Pending -> Step 3
      if (profileStatus == "pending") {
        print("� Profile Pending - Setting step 3");
        driverFormController.activeStep.value = 2;
        CustomNavigator.push(
          context,
          DriverRegistration(mobileNumber: widget.phoneNumber),
          transition: TransitionType.slideLeft,
        );
        return;
      }

      // CASE 3: Vehicle Pending -> Step 2
      if (vehicleStatus == "pending") {
        print("� Vehicle Pending - Setting step 2");
        driverFormController.activeStep.value = 1;
        CustomNavigator.push(
          context,
          DriverRegistration(mobileNumber: widget.phoneNumber),
          transition: TransitionType.slideLeft,
        );
        return;
      }

      // Image Pending -> Toast (Lower priority than Vehicle/Profile pending steps)
      if (imageStatus == "pending") {
        print("🖼️ Image Pending - Showing toast");
        Fluttertoast.showToast(
          msg: "Please wait, admin will approve your account.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
        );
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      // Fallback
      print("⚠️ No specific case matched - defaulting to Registration");
      CustomNavigator.push(
        context,
        DriverRegistration(mobileNumber: widget.phoneNumber),
        transition: TransitionType.slideLeft,
      );
    } catch (e) {
      print("errorrr>>>>>2222 ");
      print("❌ Error in verifyOtp2: $e");
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred. Please try again.';
        });
      }
      Get.snackbar(
        'Error',
        'Verification failed: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                    // if (errorMessage.isNotEmpty)
                    //   Padding(
                    //     padding: EdgeInsets.only(bottom: w * .02),
                    //     child: Text(
                    //       errorMessage,
                    //       style: TextStyle(
                    //         color: Colors.red,
                    //         fontSize: w * 0.035,
                    //       ),
                    //     ),
                    //   ),

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
                          onTap: () {
                            otpController.resendCode(
                              phoneNumber: widget.phoneNumber,
                            );
                          },

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
                onClicked: () {
                  verifyOtp2();
                },

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
