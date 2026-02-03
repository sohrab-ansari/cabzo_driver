import 'package:nzcu_driver/utilities/app_buttons.dart';
import 'package:nzcu_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';
import 'package:nzcu_driver/utilities/custom_images.dart';
import 'package:nzcu_driver/utilities/custom_text.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';

class PopUps {
  void cancelRidePopup(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: w * .03),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            // yahan scroll allow kar diya
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: w * .1),
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: w * .2,
                //     vertical: w * .05,
                //   ),
                //   child: Image.asset(
                //     "assets/icons/cancelPopup1.png",
                //     width: w * .2,
                //     height: w * .2,
                //   ),
                // ),
                Image.asset(
                  "assets/images/cancelride.png",
                  width: w * .2,
                  height: w * .2,
                ),
                SizedBox(height: w * .02),
                CustomText(
                  text: "Cancel Pickup",
                  textColor: ColorsList.titleTextColor,
                  textFontSize: w * .04,
                  textFontWeight: FontWeight.w400,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * .05),
                  child: CustomText(
                    text: "Are you sure you want to cancel the pickup",
                    textColor: ColorsList.subtitleTextColor,
                    textFontSize: w * .034,
                    textFontWeight: FontWeight.w400,
                    textalign: TextAlign.center, // avoid text overflow
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w * .06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButtons.outlined(
                        context: context,
                        text: "No",

                        onClicked: () {
                          CustomNavigator.pop(context);
                        },
                        width: w * .42,
                        radius: 30,
                        backgroundColor: AppColors.white,
                        borderColor: AppColors.primaryRed,
                        textColor: AppColors.primaryRed,
                      ),
                      SizedBox(width: w * .03),
                      AppButtons.outlined(
                        context: context,
                        text: "Yes, Cancel",

                        onClicked: () {
                          CustomNavigator.push(
                            context,
                            BottomnavmainScreen(),
                            transition: TransitionType.slideLeft,
                          );
                        },
                        width: w * .42,
                        radius: 30,
                        backgroundColor: AppColors.primaryRed,
                        textColor: AppColors.white,

                        fontSize: w * .045,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: w * .05),
              ],
            ),
          ),
        );
      },
    );
  }

  // logout
  void logout(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: w * .03),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: w * .1),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .2,
                  vertical: w * .05,
                ),
                child: CustomImages.images(
                  "assets/images/logout_image.png",
                  w * .45,
                  w * .45,
                ),
              ),
              CustomText(
                text: "Logout",
                textColor: ColorsList.titleTextColor,
                textFontSize: w * .07,
                textFontWeight: FontWeight.w500,
              ),
              CustomText(
                text: "Are you sure you want to logout? ",
                textColor: ColorsList.subtitleTextColor,
                textFontSize: w * .045,
                textFontWeight: FontWeight.w400,
              ),
              SizedBox(height: w * .05),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .04,
                  //     //  vertical: w * .05,
                ),
                child: AppButtons.solid(
                  context: context,
                  text: "Logout",
                  onClicked: () {
                    CustomNavigator.push(
                      context,
                      LoginScreen(),
                      // transition: TransitionType.slideLeft,
                    );
                  },
                  isFullWidth: true,
                  backgroundColor: ColorsList.mainButtonColor,
                  textColor: ColorsList.mainButtonTextColor,
                  fontSize: w * .045,
                  height: w * .140,
                  radius: 12.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .04,
                  // vertical: w * .02,
                ),
                child: AppButtons.solid(
                  context: context,
                  text: "Cancel",
                  onClicked: () {
                    CustomNavigator.pop(context);
                  },
                  isFullWidth: true,
                  backgroundColor: AppColors.white,
                  textColor: AppColors.mediumGray,
                  fontSize: w * .045,
                  height: w * .140,
                  radius: 12.0,
                ),
              ),
              SizedBox(height: w * .05),
            ],
          ),
        );
      },
    );
  }

  // coupan add successfully
  void coupanAdd(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: w * .03),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            // yahan scroll allow kar diya
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: w * .1),
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: w * .2,
                //     vertical: w * .05,
                //   ),
                //   child: Image.asset(
                //     "assets/icons/cancelPopup1.png",
                //     width: w * .2,
                //     height: w * .2,
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: w * .04),
                  child: Image.asset(
                    "assets/images/coopancode.png",
                    width: w,
                    height: w * .6,
                  ),
                ),
                SizedBox(height: w * .02),
                AppFonts.textPoppins(
                  context,
                  "Coupon Applied Successfully",
                  w * 0.046,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * .07),
                  child: AppFonts.textPoppins(
                    context,
                    "Your 50% discount has been added. Pay only ₹50 for ₹100 recharge.",
                    w * 0.037,
                    FontWeight.w400,
                    AppColors.mediumGray,
                    TextAlign.center,
                    TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),

                SizedBox(height: w * .1),
              ],
            ),
          ),
        );
      },
    );
  }
}
