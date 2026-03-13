import 'package:nzcu_driver/modals/home_modals/ride_history_response.dart';
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
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imagePath = "";

  /// First section - Changed to List<IconData>
  final List<IconData> firstIconsList = [
    Icons.payment,
    Icons.star_rate,
    Icons.notifications,
  ];

  final List<Widget> firstScreens = [
    const PaymentScreen(),
    Review(), // Make sure this is the correct widget name
    const NotificationScreen(),
  ];

  final List<String> firstTitleList = ["Payment", "Rating", "Notifications"];

  /// Second section - Changed to List<IconData>
  final List<IconData> secondIconsList = [
    Icons.help,
    Icons.description,
    Icons.privacy_tip,
  ];

  final List<Widget> secondScreens = [
    const HelpScreen(),
    const TermsCondition(),
    const PrivacyPolicy(),
  ];

  final List<String> secondTitleList = [
    "Help & Support",
    "Terms & Conditions",
    "Privacy Policy",
  ];

  String? driverName;
  String? driverphone;
  dynamic profileimage;

  @override
  void initState() {
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
    AppLogger.d("Driver__Name from SharedPreferences: $driverName");
    AppLogger.d("Driver__Phone from SharedPreferences: $driverphone");
    AppLogger.d("Driver__Image from SharedPreferences: $profileimage");
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
          _menuCard(w, firstIconsList, firstTitleList, firstScreens),
          SizedBox(height: w * .02),
          _menuCard(w, secondIconsList, secondTitleList, secondScreens),
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
                    CustomText(
                      text: "${driverName ?? ''}",
                      textFontSize: w * .05,
                      textFontWeight: FontWeight.w500,
                    ),
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
          const Divider(),
          GestureDetector(
            onTap: () => CustomNavigator.push(
              context,
              const EditProfile(),
              transition: TransitionType.slideLeft,
            ),
            child: customMenuItemsButton(Icons.edit, "Edit Profile"),
          ),
          SizedBox(height: w * .02),
        ],
      ),
    );
  }

  /// MENU CARD - Updated to use List<IconData>
  Widget _menuCard(
    double w,
    List<IconData> icons,
    List<String> titles,
    List<Widget> screens,
  ) {
    // Ensure all lists have the same length
    assert(icons.length == titles.length && titles.length == screens.length);

    return Column(
      children: List.generate(icons.length, (index) {
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
              child: customMenuItemsButton(icons[index], titles[index]),
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
      child: Card(
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(w * .04),
          child: Row(
            children: [
              Icon(
                Icons.logout,
                size: w * .06,
                color: ColorsList.mainButtonColor,
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

  /// COMMON MENU ITEM - Updated to use IconData
  Widget customMenuItemsButton(IconData icon, String title) {
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
            Icon(icon, size: w * .06, color: ColorsList.mainButtonColor),
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

  /// LOGOUT DIALOG
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
                text: "Are you sure you want to logout?",
                textColor: ColorsList.subtitleTextColor,
                textFontSize: w * .045,
                textFontWeight: FontWeight.w400,
              ),
              SizedBox(height: w * .05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * .04),
                child: AppButtons.solid(
                  context: context,
                  text: "Logout",
                  onClicked: () async {
                    Navigator.pop(context); // Close dialog first

                    // Get SharedPreferences instance
                    final prefs = await SharedPreferences.getInstance();

                    // Clear all stored data
                    await prefs.clear();

                    // Navigate to Login screen
                    CustomNavigator.removeUntil(
                      context,
                      const LoginScreen(),
                      transition: TransitionType.fade,
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
                padding: EdgeInsets.symmetric(horizontal: w * .04),
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
