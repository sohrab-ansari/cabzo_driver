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

class EnterOtpScreen extends StatefulWidget {
  dynamic typecheck;
  EnterOtpScreen({super.key, required this.typecheck});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final Controllers contentController = Get.put(Controllers());
  final OtpController otpController = Get.put(OtpController());
  @override
  void initState() {
    // TODO: implement initState
    contentController.maxheightReach.value = false;
    super.initState();
    otpController.startTimer();
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
                    text: "+91 8238658110",
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * .07,
                vertical: w * .05,
              ),
              child: Column(
                children: [
                  //? otp boxes-------------------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * .01),
                    child: CustomOtpBox(),
                  ),
                  SizedBox(height: w * .02),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CustomText(
                  //       text: "Haven't got the confirmation code yet?",
                  //       textFontSize: w * .035,
                  //       textColor: ColorsList.subtitleTextColor,
                  //       textFontWeight: FontWeight.w400,
                  //     ),
                  //     SizedBox(width: w * .01),
                  //     CustomText(
                  //       text: "00:59",
                  //       textFontSize: w * .035,
                  //       textColor: ColorsList.subtitleTextColor,
                  //       textFontWeight: FontWeight.w400,
                  //     ),
                  //   ],
                  // ),
                  //? Timer ya Resend text
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
                          textColor: ColorsList.mainAppColor, // clickable color
                          textFontWeight: FontWeight.w600,
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
            Spacer(),
            // AppButtons.solid(
            //   context: context,
            //   text: "Driver Registration",
            //   onClicked: () {
            //     CustomNavigator.push(
            //       context,
            //       const DriverRegistration(),
            //       transition: TransitionType.rotation,
            //     );
            //   },
            //   isFullWidth: true,
            //   backgroundColor: ColorsList.mainButtonColor,
            //   textColor: ColorsList.mainButtonTextColor,
            //   fontSize: w * .04,
            //   height: w * .140,
            //   radius: 12.0,
            // ),
            SizedBox(height: w * .05),
            AppButtons.solid(
              context: context,
              text: "Verify",
              onClicked: () {
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
              },
              isFullWidth: true,
              backgroundColor: ColorsList.mainButtonColor,
              textColor: AppColors.black,
              fontSize: w * .045,
              height: w * .140,
              radius: 12.0,
              //  textColor:  AppColors.black,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: w * .1),
          ],
        ),
      ),
    );
  }
}
