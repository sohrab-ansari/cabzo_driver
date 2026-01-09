import 'package:corezap_driver/controller/login.controller.dart';
import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/form_field.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/auth/enter_otp_screen.dart';
import 'package:corezap_driver/views/auth/signup_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/documents_related/driver_registration.dart';
import 'package:corezap_driver/views/profile_related.dart/terms_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DriverFormController driverFormController = Get.put(DriverFormController());
  TextEditingController phone = TextEditingController();
  //initialized login controller
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.05),
            //Login screen Image
            Image.asset("assets/images/image7.png", fit: BoxFit.fill)
                .animate()
                .fade(duration: 800.ms, curve: Curves.easeInOut)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),

            //column
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //space 1
                  SizedBox(height: w * 0.04),
                  //text
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

                  //text 2
                  SizedBox(height: w * 0.02),
                  AppFonts.textPoppins(
                        context,
                        "Let’s get stared! Enter your phone number to create your Indrive account.",
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

                  //space 2
                  SizedBox(height: w * 0.04),

                  //text 3
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

                  //space 3
                  SizedBox(height: w * 0.02),

                  //text field
                  AppFormFields.custTextFormOther(
                        context: context,
                        hintText: "Enter here",
                        controller: phone,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
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

            //row with checkbox and text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * .010),
              child:
                  Row(
                        children: [
                          //checkBox
                          Obx(
                            () => Checkbox(
                              value: loginController.isChecked.value,
                              activeColor: const Color(0xFF7C7C8D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                loginController.isChecked.value = value!;
                              },
                            ),
                          ),

                          //text
                          AppFonts.textPoppins(
                            context,
                            "I agree to Indrive ",
                            w * 0.032,
                            FontWeight.w500,
                            AppColors.black.withOpacity(0.7),
                            TextAlign.left,
                            TextOverflow.visible,
                            maxLines: 2,
                          ),

                          //text
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
                      )
                      .animate()
                      .fade(duration: 1300.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
            ),

            //space
            SizedBox(height: w * 0.07),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Column(
                children: [
                  //row with already have an account
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //text
                          AppFonts.textPoppins(
                            context,
                            "Already have an account?",
                            w * 0.036,
                            FontWeight.w400,
                            AppColors.black,
                            TextAlign.left,
                            TextOverflow.visible,
                          ),

                          InkWell(
                            onTap: () {
                              CustomNavigator.push(
                                context,
                                SignupScreen(),
                                transition: TransitionType.slideLeft,
                              );
                            },
                            child: AppFonts.textPoppins(
                              context,
                              " Sign Up",
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

            //space
            SizedBox(height: w * 0.00),

            //space
            SizedBox(height: w * 0.04),

            //space
            SizedBox(height: w * 0.09),

            //login button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child:
                  AppButtons.solid(
                        context: context,
                        text: "Login",
                        onClicked: () {
                          //login function
                          CustomNavigator.push(
                            context,
                            EnterOtpScreen(typecheck: ""),
                            transition: TransitionType.fade,
                          );
                        },
                        isFullWidth: true,
                        fontSize: w * 0.045,
                        height: w * 0.140,
                        radius: 12.0,
                        isLoading: false,
                        textColor: AppColors.black,
                        fontWeight: FontWeight.w500,
                      )
                      .animate()
                      .fade(duration: 1600.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
            ),
            SizedBox(height: w * .1),
          ],
        ),
      ),
    );
  }

  //common widger
  Widget commonWidget(
    String icon,
    String text,
    BuildContext context,
    //on click
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
