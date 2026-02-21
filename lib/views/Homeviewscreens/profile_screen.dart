import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:nzcu_driver/views/popups/pop_ups.dart';
import 'package:nzcu_driver/views/profile_screens/documents.dart';
import 'package:nzcu_driver/views/profile_screens/edit_profile.dart';

import 'package:nzcu_driver/views/profile_screens/help_related/help_screen.dart';
import 'package:nzcu_driver/views/profile_screens/notification.dart';
import 'package:nzcu_driver/views/profile_screens/notification_screen.dart';
import 'package:nzcu_driver/views/profile_screens/payment_screen.dart';
import 'package:nzcu_driver/views/profile_screens/privacy_policy.dart';
import 'package:nzcu_driver/views/profile_screens/rating.dart';
import 'package:nzcu_driver/views/profile_screens/terms_condition.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // "assets/icons/mingcute_document-2-fill.png",
    "assets/icons/Gift.png",
  ];

  final List<Widget> firstScreens = [
    PaymentScreen(),
    Review(),
    // Documents(),
    NotificationScreen(),
  ];

  final List<String> firstTitleList = [
    "Payment",
    "Rating",
    // "Documents",
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

  String? driverName;

  String? driverphone;

  dynamic profileimage;

  initState() {
    super.initState();

    sharedpreferences();
  }

  Future<void> sharedpreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      driverName = prefs.getString("driver_name");

      driverphone = prefs.getString("driver_mobile");

      profileimage = prefs.getString("driver_image");
    });
    print("Driver__Name from SharedPreferences: $driverName");
    print("Driver__Phone from SharedPreferences: $driverphone");
    print("Driver__Image from SharedPreferences: $profileimage");
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        // centerTitle: false,
        leading: const SizedBox(),
        title: Transform.translate(
          offset: Offset(w * -0.15, 0),
          child:
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
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: w * .02),
        children: [
          SizedBox(height: w * .02),
          _profileCard(w, profileimage),
          SizedBox(height: w * .02),
          _menuCard(w, firstImagePathList, firstTitleList, firstScreens),
          SizedBox(height: w * .02),
          _menuCard(w, secondImagePathList, secondTitleList, secondScreens),
          SizedBox(height: w * .02),
          _logoutButton(w),
          SizedBox(height: w * .03),
        ],
      ),
    );
  }

  /// PROFILE CARD
  Widget _profileCard(double w, String? profileimage) {
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
                  backgroundImage: profileimage != null
                      ? NetworkImage(ApiPath.imagebaseUrl + profileimage)
                      : null,
                  child: profileimage == null
                      ? Icon(Icons.person, size: w * .08)
                      : null,
                ),
                SizedBox(width: w * .03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CustomText(
                    //   text: "Juanita Valencia",
                    //   textFontSize: w * .05,
                    //   textFontWeight: FontWeight.w500,
                    // ),
                    CustomText(
                      text: "${driverName ?? ''}",
                      textFontSize: w * .05,
                      textFontWeight: FontWeight.w500,
                    ),

                    // CustomText
                    //   text: "+91 123456789",
                    //   textFontSize: w * .04,
                    //   textFontWeight: FontWeight.w400,
                    // ),
                    CustomText(
                      text: "+91 ${driverphone ?? ''}",
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

  Widget _logoutButton(double w) {
    return GestureDetector(
      onTap: () {
        logout(context);
      },
      child: 
      
      Card(
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

  /// LOGOUT
  ///
  ///
  //   Widget _logoutButton(double w) {
  //   return GestureDetector(
  //     onTap: () async {
  //       // 1️⃣ Get SharedPreferences instance
  //       final prefs = await SharedPreferences.getInstance();

  //       // 2️⃣ Remove auth token (logout)
  //       await prefs.remove("auth_token");

  //       // If you want full clear instead, use:
  //       // await prefs.clear();

  //       // 3️⃣ Navigate to Login screen (remove all previous routes)
  //       CustomNavigator.removeUntil(
  //         context,
  //         const LoginScreen(),
  //         transition: TransitionType.fade,
  //       );
  //     },
  //     child: Card(
  //       elevation: 1,
  //       child: Padding(
  //         padding: EdgeInsets.all(w * .04),
  //         child: Row(
  //           children: [
  //             CustomImages.images(
  //               "assets/icons/Sign_Out.png",
  //               w * .06,
  //               w * .06,
  //             ),
  //             SizedBox(width: w * .03),
  //             CustomText(
  //               text: "Logout",
  //               textFontSize: w * .04,
  //               textFontWeight: FontWeight.w500,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  //   Widget _logoutButton(double w) {
  //   return GestureDetector(
  //     onTap: () async {

  //       // 1️⃣ Get SharedPreferences instance
  //       final prefs = await SharedPreferences.getInstance();

  //         final String? token = prefs.getString("auth_token");

  //       // 2️⃣ Clear all stored data
  //       await prefs.clear();
  //       // OR remove specific keys:
  //       // await prefs.remove("user_id");
  //       // await prefs.remove("auth_token");

  //       // 3️⃣ Navigate to Login screen (remove all previous routes)
  //       CustomNavigator.removeUntil(
  //         context,
  //         const LoginScreen(),
  //         transition: TransitionType.fade,
  //       );
  //     },
  //     child: Card(
  //       elevation: 1,
  //       child: Padding(
  //         padding: EdgeInsets.all(w * .04),
  //         child: Row(
  //           children: [
  //             CustomImages.images(
  //               "assets/icons/Sign_Out.png",
  //               w * .06,
  //               w * .06,
  //             ),
  //             SizedBox(width: w * .03),
  //             CustomText(
  //               text: "Logout",
  //               textFontSize: w * .04,
  //               textFontWeight: FontWeight.w500,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _logoutButton(double w) {
  //   return GestureDetector(
  //     onTap: () => {

  // CustomNavigator.removeUntil(
  //       context,
  //       const LoginScreen(),
  //       transition: TransitionType.fade,
  //     ),

  //     },
  //     child: Card(
  //       elevation: 1,
  //       child: Padding(
  //         padding: EdgeInsets.all(w * .04),
  //         child: Row(
  //           children: [
  //             CustomImages.images(
  //               "assets/icons/Sign_Out.png",
  //               w * .06,
  //               w * .06,
  //             ),
  //             SizedBox(width: w * .03),
  //             CustomText(
  //               text: "Logout",
  //               textFontSize: w * .04,
  //               textFontWeight: FontWeight.w500,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
                  onClicked: () async {
                    Navigator.pop(context); // Close dialog first

                    // 1️⃣ Get SharedPreferences instance
                    final prefs = await SharedPreferences.getInstance();

                    // 2️⃣ Remove auth token
                    await prefs.remove("auth_token");

                    // 3️⃣ Navigate to Login screen
                    CustomNavigator.removeUntil(
                      context,
                      const LoginScreen(),
                      transition: TransitionType.fade,
                    );
                    // CustomNavigator.push(
                    //   context,
                    //   LoginScreen(),
                    //   // transition: TransitionType.slideLeft,
                    // );
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
}
