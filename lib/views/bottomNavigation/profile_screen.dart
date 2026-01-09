// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/popups/pop_ups.dart';
// import 'package:corezap_driver/views/profile_related.dart/documents.dart';
// import 'package:corezap_driver/views/profile_related.dart/edit_profile.dart';
// import 'package:corezap_driver/views/profile_related.dart/help_related/help_screen.dart';
// import 'package:corezap_driver/views/profile_related.dart/notification.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_screen.dart';
// import 'package:corezap_driver/views/profile_related.dart/privacy_policy.dart';
// import 'package:corezap_driver/views/profile_related.dart/rating.dart';
// import 'package:corezap_driver/views/profile_related.dart/terms_condition.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String imagePath = "";
//   List firstImagePathList = [
//     "assets/icons/material-symbols_payments-outline-sharp.png",
//     "assets/icons/ic_round-star.png",
//     "assets/icons/mingcute_document-2-fill.png",
//     "assets/icons/Gift.png",
//   ];
//   List firstScreens = [PaymentScreen(), Review(), Documents(), Notifications()];
//   //? help-screens
//   List secondScreens = [HelpScreen(), TermsCondition(), PrivacyPolicy(),PrivacyPolicy()];
//   List secondImagePathList = [
//     "assets/icons/Question_Circle.png",
//     "assets/icons/Task_List_Square.png",
//     "assets/icons/material-symbols_policy.png",
//     "assets/icons/material-symbols_policy.png",
//   ];
//   List firstTitleList = ["Payment", "Rating", "Documents", "Notifications"];
//   List secondTitleList = ["Help","Faqs" "Terms & Conditions", "Privacy Policy"];

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: ColorsList.scaffoldColor,
//       // appBar: AppBar(
//       //   centerTitle: true,
//       //   automaticallyImplyLeading: false,
//       //   title: AppFonts.textPoppins(
//       //     context,
//       //     "Profile",
//       //     w * 0.05,
//       //     FontWeight.w600,
//       //     AppColors.black,
//       //     TextAlign.center,
//       //     TextOverflow.ellipsis,
//       //     maxLines: 1,
//       //   ),
//       // ),
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         scrolledUnderElevation: 0,
//         elevation: 0,
//          leadingWidth: w * 0.010,
//         // centerTitle: true,
//         leading: SizedBox(),
//         title:
//             AppFonts.textRubik(
//                   context,
//                   "Profile",
//                   w * 0.055,
//                   FontWeight.w600,
//                   AppColors.black,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                   maxLines: 1,
//                 )
//                 .animate()
//                 .fade(duration: 800.ms, curve: Curves.easeInOut)
//                 .scale(
//                   begin: const Offset(0.95, 0.95),
//                   end: const Offset(1, 1),
//                 ),
//       ),
//       body: ListView.builder(
//         itemCount: 1,
//         itemBuilder: (context, index) => Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * .02),
//           child: Column(
//             children: [
//               SizedBox(height: w * .02),
//               Card(
//                 elevation: 1,
//                 color: ColorsList.scaffoldColor,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: w * .04,
//                         vertical: w * .02,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             radius: w * .07,
//                             backgroundColor: Colors.grey.shade300,
//                             backgroundImage:
//                                 imagePath != null && imagePath.isNotEmpty
//                                 ? AssetImage(
//                                     imagePath,
//                                   ) //  NetworkImage(imageUrl)
//                                 : null,
//                             child: (imagePath == null || imagePath.isEmpty)
//                                 ? Icon(
//                                     Icons.person,
//                                     size: w * .08,
//                                     color: Colors.grey.shade700,
//                                   )
//                                 : null,
//                           ),
//                           SizedBox(width: w * .02),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CustomText(
//                                 text: "Juanita Valencia",
//                                 textColor: ColorsList.titleTextColor,
//                                 textFontSize: w * .065,
//                                 textFontWeight: FontWeight.w500,
//                               ),
//                               CustomText(
//                                 text: "+91 ${123456789}",
//                                 textColor: ColorsList.subtitleTextColor,
//                                 textFontSize: w * .04,
//                                 textFontWeight: FontWeight.w400,
//                               ),
//                               SizedBox(height: w * .01),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(color: ColorsList.textfieldBorderColorSe),
//                     GestureDetector(
//                       onTap: () {
//                         CustomNavigator.push(
//                           context,
//                           EditProfile(),
//                           transition: TransitionType.slideLeft,
//                         );
//                       },
//                       child: customMenuItemsButton(
//                         "assets/icons/editProfile.png",
//                         "Edit",
//                       ),
//                     ),
//                     SizedBox(height: w * .02),
//                   ],
//                 ),
//               ),
//               //?first list of profile menu buttons
//               SizedBox(height: w * .02),
//               Card(
//                 elevation: 1,
//                 color: ColorsList.scaffoldColor,
//                 child: Column(
//                   children: List.generate(4, (index) {
//                     return Column(
//                       children: [
//                         index == 0
//                             ? SizedBox(height: w * .02)
//                             : SizedBox.shrink(),
//                         GestureDetector(
//                           onTap: () {
//                             CustomNavigator.push(
//                               context,
//                               firstScreens[index],
//                               transition: TransitionType.slideLeft,
//                             );
//                           },
//                           child: customMenuItemsButton(
//                             firstImagePathList[index],
//                             firstTitleList[index],

//                             //? navigate screen=======================
//                           ),
//                         ),
//                         index < 3
//                             ? Divider(
//                                 indent: w * .13,
//                                 color: ColorsList.textfieldBorderColorSe,
//                               )
//                             : SizedBox.shrink(),
//                         index == 3
//                             ? SizedBox(height: w * .02)
//                             : SizedBox.shrink(),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//               SizedBox(height: w * .02),
//               //?second list of profile menu buttons
//               Card(
//                 elevation: 1,
//                 color: ColorsList.scaffoldColor,
//                 child: Column(
//                   children: List.generate(4, (index) {
//                     return Column(
//                       children: [
//                         index == 0
//                             ? SizedBox(height: w * .02)
//                             : SizedBox.shrink(),
//                         GestureDetector(
//                           onTap: () {
//                             CustomNavigator.push(
//                               context,
//                               secondScreens[index],
//                               transition: TransitionType.slideLeft,
//                             );
//                           },
//                           child: customMenuItemsButton(
//                             secondImagePathList[index],
//                             secondTitleList[index],
//                           ),
//                         ),
//                         index < 2
//                             ? Divider(
//                                 indent: w * .13,
//                                 color: ColorsList.textfieldBorderColorSe,
//                               )
//                             : SizedBox.shrink(),
//                         index == 2
//                             ? SizedBox(height: w * .02)
//                             : SizedBox.shrink(),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//               SizedBox(height: w * .02),
//               GestureDetector(
//                 onTap: () {
//                   PopUps().logout(context);
//                 },
//                 child: Card(
//                   elevation: 1,
//                   color: ColorsList.scaffoldColor,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: w * .04,
//                       vertical: w * .04,
//                     ),
//                     child: Row(
//                       children: [
//                         //  Image on left
//                         CustomImages.images(
//                           "assets/icons/Sign_Out.png",
//                           w * .06,
//                           w * .06,
//                         ),
//                         SizedBox(width: w * 0.02),

//                         //Title
//                         CustomText(
//                           text: "Logout",
//                           // textColor: ColorsList.redColor,
//                           textColor: ColorsList.titleTextColor,
//                           textFontSize: w * .04,
//                           textFontWeight: FontWeight.w500,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: w * .3),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget customMenuItemsButton(
//     String imagePath,
//     String title,
//     //  Widget navigateScreen,
//   ) {
//     double w = MediaQuery.of(context).size.width;
//     return Container(
//       color: ColorsList.scaffoldColor,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .012),
//         child: Row(
//           children: [
//             //  Image on left
//             CustomImages.images(imagePath, w * .07, w * .07),
//             SizedBox(width: w * 0.02),

//             //Title
//             CustomText(
//               text: title,
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .04,
//               textFontWeight: FontWeight.w400,
//             ),
//             Spacer(),
//             Icon(
//               Icons.arrow_forward_ios,
//               color: ColorsList.subtitleTextColor,
//               size: w * 0.04,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/popups/pop_ups.dart';
import 'package:corezap_driver/views/profile_related.dart/documents.dart';
import 'package:corezap_driver/views/profile_related.dart/edit_profile.dart';
import 'package:corezap_driver/views/profile_related.dart/faq_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/help_related/help_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/notification.dart';
import 'package:corezap_driver/views/profile_related.dart/notification_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/privacy_policy.dart';
import 'package:corezap_driver/views/profile_related.dart/rating.dart';
import 'package:corezap_driver/views/profile_related.dart/terms_condition.dart';

// import 'package:corezap_driver/views/profile_related/documents.dart';
// import 'package:corezap_driver/views/profile_related/edit_profile.dart';
// import 'package:corezap_driver/views/profile_related/help_related/help_screen.dart';
// import 'package:corezap_driver/views/profile_related/notification.dart';
// import 'package:corezap_driver/views/profile_related/payment_screen.dart';
// import 'package:corezap_driver/views/profile_related/privacy_policy.dart';
// import 'package:corezap_driver/views/profile_related/rating.dart';
// import 'package:corezap_driver/views/profile_related/terms_condition.dart';

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
    "assets/icons/Task_List_Square.png",
    "assets/icons/material-symbols_policy.png",
    "assets/icons/material-symbols_policy.png",
  ];

  final List<Widget> secondScreens = [
    HelpScreen(),
    FaqScreen(),
    // HelpScreen(), // replace with FaqScreen() if available
    TermsCondition(),
    PrivacyPolicy(),
  ];

  final List<String> secondTitleList = [
    "Help",
    "Faqs",
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
        title: AppFonts.textRubik(
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
    return Card(
      elevation: 1,
      color: ColorsList.scaffoldColor,
      child: Column(
        children: List.generate(images.length, (index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => CustomNavigator.push(
                  context,
                  screens[index],
                  transition: TransitionType.slideLeft,
                ),
                child: customMenuItemsButton(images[index], titles[index]),
              ),
              if (index != images.length - 1)
                Divider(indent: w * .13),
            ],
          );
        }),
      ),
    );
  }

  /// LOGOUT
  Widget _logoutButton(double w) {
    return GestureDetector(
      onTap: () => PopUps().logout(context),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(w * .04),
          child: Row(
            children: [
              CustomImages.images("assets/icons/Sign_Out.png", w * .06, w * .06),
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .012),
      child: Row(
        children: [
          CustomImages.images(imagePath, w * .07, w * .07),
          SizedBox(width: w * .03),
          CustomText(text: title, textFontSize: w * .04),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: w * .04),
        ],
      ),
    );
  }
}
