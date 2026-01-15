

import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/auth/login_screen.dart';
import 'package:corezap_driver/views/popups/pop_ups.dart';
import 'package:corezap_driver/views/profile_related.dart/documents.dart';
import 'package:corezap_driver/views/profile_related.dart/edit_profile.dart';

import 'package:corezap_driver/views/profile_related.dart/help_related/help_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/notification.dart';
import 'package:corezap_driver/views/profile_related.dart/notification_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/privacy_policy.dart';
import 'package:corezap_driver/views/profile_related.dart/rating.dart';
import 'package:corezap_driver/views/profile_related.dart/terms_condition.dart';


import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imagePath = "";

  /// First section
  final List<String> firstImagePathList = [
    "assets/icons/material-symbols_payments-outline-sharp.png",
    "assets/icons/ic_round-star.png",
    "assets/icons/mingcute_document-2-fill.png",
    "assets/icons/Gift.png",
  ];

  final List<Widget> firstScreens = [
    PaymentScreen(),
    Review(),
    Documents(),
    NotificationScreen(),
  ];

  final List<String> firstTitleList = [
    "Payment",
    "Rating",
    "Documents",
    "Notifications",
  ];

  /// Second section
  final List<String> secondImagePathList = [
    "assets/icons/Question_Circle.png",
    "assets/icons/material-symbols_policy.png",
    "assets/icons/material-symbols_policy.png",
  ];

  final List<Widget> secondScreens = [
    HelpScreen(),
    TermsCondition(),
    PrivacyPolicy(),
  ];

  final List<String> secondTitleList = [
    "Help & Support",
    "Terms & Conditions",
    "Privacy Policy",
  ];

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const SizedBox(),
        title:
            AppFonts.textRubik(
                  context,
                  "Profile",
                  w * 0.055,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 1,
                )
                .animate()
                .fade(duration: 800.ms)
                .scale(begin: const Offset(0.95, 0.95)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: w * .02),
        children: [
          SizedBox(height: w * .02),
          _profileCard(w),
          SizedBox(height: w * .02),
          _menuCard(w, firstImagePathList, firstTitleList, firstScreens),
          SizedBox(height: w * .02),
          _menuCard(w, secondImagePathList, secondTitleList, secondScreens),
          SizedBox(height: w * .02),
          _logoutButton(w),
          SizedBox(height: w * .3),
        ],
      ),
    );
  }

  /// PROFILE CARD
  Widget _profileCard(double w) {
    return Card(
      elevation: 1,
      color: ColorsList.scaffoldColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(w * .04),
            child: Row(
              children: [
                CircleAvatar(
                  radius: w * .07,
                  backgroundColor: Colors.grey.shade300,
                  child: imagePath.isEmpty
                      ? Icon(Icons.person, size: w * .08)
                      : null,
                ),
                SizedBox(width: w * .03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Juanita Valencia",
                      textFontSize: w * .05,
                      textFontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      text: "+91 123456789",
                      textFontSize: w * .04,
                      textFontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: () => CustomNavigator.push(
              context,
              EditProfile(),
              transition: TransitionType.slideLeft,
            ),
            child: customMenuItemsButton(
              "assets/icons/editProfile.png",
              "Edit",
            ),
          ),
          SizedBox(height: w * .02),
        ],
      ),
    );
  }

  /// MENU CARD
  Widget _menuCard(
    double w,
    List<String> images,
    List<String> titles,
    List<Widget> screens,
  ) {
    return Column(
      children: List.generate(images.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: w * .02),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => CustomNavigator.push(
                context,
                screens[index],
                transition: TransitionType.slideLeft,
              ),
              child: customMenuItemsButton(images[index], titles[index]),
            ),
          ),
        );
      }),
    );
  }

  /// LOGOUT
  Widget _logoutButton(double w) {
    return GestureDetector(
      onTap: () => {


  CustomNavigator.removeUntil(
        context,
        const LoginScreen(),
        transition: TransitionType.fade,
      ),

      },
      child: Card(
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(w * .04),
          child: Row(
            children: [
              CustomImages.images(
                "assets/icons/Sign_Out.png",
                w * .06,
                w * .06,
              ),
              SizedBox(width: w * .03),
              CustomText(
                text: "Logout",
                textFontSize: w * .04,
                textFontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// COMMON MENU ITEM
  Widget customMenuItemsButton(String imagePath, String title) {
    final double w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(w * .04),
        child: Row(
          children: [
            CustomImages.images(imagePath, w * .06, w * .06),
            SizedBox(width: w * .03),
            Expanded(
              child: CustomText(
                text: title,
                textFontSize: w * .04,
                textFontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: w * .04),
          ],
        ),
      ),
    );
  }
}
