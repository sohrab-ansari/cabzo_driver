// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/custom_images.dart';
// import 'package:nzcu_driver/utilities/custom_text.dart';
// import 'package:nzcu_driver/utilities/navigator.dart';
// import 'package:nzcu_driver/views/profile_related.dart/help_related/F_a_qs.dart';
// import 'package:flutter/material.dart';

// class HelpScreen extends StatefulWidget {
//   const HelpScreen({super.key});

//   @override
//   State<HelpScreen> createState() => _HelpScreenState();
// }

// class _HelpScreenState extends State<HelpScreen> {
//   List imagesPathList = [
//     "assets/icons/faq.png",
//     "assets/icons/chatSupport.png",
//     "assets/icons/callSupport.png",
//     "assets/icons/emailSupport.png",
//   ];
//   // List screenList = [
//   //   ProfilePaymentScreen(),
//   //   SafetyScreen(),
//   //   ReferEarnScreen(),
//   //   ProfilePaymentScreen(),
//   //   SafetyScreen(),
//   //   ReferEarnScreen(),
//   // ];
//   //? help-screens

//   List titleList = ["FAQs", "Chat with Support", "Call Support", "Email Us"];

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: ColorsList.scaffoldColor,
//       appBar: AppBar(
//         backgroundColor: ColorsList.scaffoldColor,
//         automaticallyImplyLeading: false,
//         titleSpacing: w * .03,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 CustomNavigator.pop(context);
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 size: w * .07,
//                 color: ColorsList.iconColor,
//               ),
//             ),
//             SizedBox(width: w * .02),
//             CustomText(
//               text: "Help",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * .025),
//         child: Card(
//           elevation: 1,
//           color: ColorsList.scaffoldColor,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [

//               Text("Comman Topics"),

//                Row(
//                  children: [
//                    Column(
//                      children: [
//                       Image.asset("assets/images/drive_image.png"),
//                        Text("Ride Issues"),
//                      ],
//                    ),

//                     Column(
//                      children: [
//                       Image.asset("assets/images/earnimage.png"),
//                         Text("Earning Issues")
//                      ],
//                    ),
//                  ],
//                ),
//                            Row(
//                  children: [
//                    Column(
//                      children: [
//                       Image.asset("assets/images/steering-wheel.png"),
//                        Text("Account Issues"),
//                      ],
//                    ),

//                     Column(
//                      children: [
//                       Image.asset("assets/images/steering-wheel2.png"),
//                          Text("Safety Issues")
//                      ],
//                    ),
//                  ],
//                ),

//  Image.asset("assets/images/image5.png"),
//                Text("Need help? We’re just a message away!"),
//                ElevatedButton(
//   onPressed: () {
//     // your action here
//   },
//   style: ElevatedButton.styleFrom(
//     backgroundColor: const Color(0xFF0088FF),
//     minimumSize: const Size(80, 50), // width, height
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//   ),
//   child: const Text(
//     "Contact Live Support",
//     style: TextStyle(
//       color: Colors.white,
//       fontSize: 14,
//     ),
//   ),
// )

//               //  ElevatedButton(onPressed: (){

//               //  }, child: Text("Contact Live Support"))
//             ]

//             // List.generate(4, (index) {
//             //   return Column(
//             //     children: [
//             //       index == 0 ? SizedBox(height: w * .02) : SizedBox.shrink(),
//             //       GestureDetector(
//             //         onTap: () {
//             //           index == 0
//             //               ? CustomNavigator.push(
//             //                   context,
//             //                   FAQs(),
//             //                   transition: TransitionType.slideLeft,
//             //                 )
//             //               : null;
//             //         },
//             //         child: customMenuItemsButton(
//             //           imagesPathList[index],
//             //           titleList[index],

//             //           //? navigate screen=======================
//             //         ),
//             //       ),
//             //       index < 3
//             //           ? Divider(
//             //               indent: w * .13,
//             //               color: ColorsList.textfieldBorderColorSe,
//             //             )
//             //           : SizedBox.shrink(),
//             //       index == 3 ? SizedBox(height: w * .02) : SizedBox.shrink(),
//             //     ],
//             //   );
//             // }),

//           ),
//         ),
//       ),
//     );
//   }

//   //? method--
//   Widget customMenuItemsButton(
//     String imagePath,
//     String title,
//     //  Widget navigateScreen,
//   ) {
//     double w = MediaQuery.of(context).size.width;
//     return Container(
//       color: ColorsList.scaffoldColor,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .02),
//         child: Row(
//           children: [
//             //  Image on left
//             CustomImages.images(imagePath, w * .07, w * .07),

//             SizedBox(width: w * 0.02),

//             //Title
//             CustomText(
//               text: title,
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .045,
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

import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/profile_screens/help_related/F_a_qs.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Map<String, String>> commonTopics = [
    {"icon": "assets/images/drive_image.png", "title": "Ride Issues"},
    {"icon": "assets/images/earnimage.png", "title": "Earning Issues"},
    {"icon": "assets/images/steering-wheel.png", "title": "Account Issues"},
    {"icon": "assets/images/steering-wheel2.png", "title": "Safety Issues"},
  ];

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: _buildAppBar(w),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .04),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(w * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Common Topics Title
                CustomText(
                  text: "Common Topics",
                  textColor: ColorsList.titleTextColor,
                  textFontSize: w * .045,
                  textFontWeight: FontWeight.w600,
                ),

                SizedBox(height: w * .04),

                /// Common Topics Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: commonTopics.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: w * .04,
                    mainAxisSpacing: w * .04,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return _commonTopicItem(
                      icon: commonTopics[index]['icon']!,
                      title: commonTopics[index]['title']!,
                    );
                  },
                ),

                SizedBox(height: w * .06),

                /// Illustration
                Center(
                  child: Image.asset(
                    "assets/images/image5.png",
                    width: w * .55,
                  ),
                ),

                SizedBox(height: w * .04),

                /// Support Text
                Center(
                  child: CustomText(
                    text: "Need help? We’re just a message away!",
                    textalign: TextAlign.center,
                    textColor: ColorsList.subtitleTextColor,
                    textFontSize: w * .04,
                    textFontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: w * .05),

                /// Contact Support Button
                Center(
                  child: SizedBox(
                    width: w * .6,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to Live Support
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Contact Live Support",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// -------------------- AppBar --------------------
  AppBar _buildAppBar(double w) {
    return AppBar(
      backgroundColor: ColorsList.scaffoldColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: w * .03,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => CustomNavigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              size: w * .07,
              color: ColorsList.iconColor,
            ),
          ),
          SizedBox(width: w * .02),
          CustomText(
            text: "Help",
            textColor: ColorsList.titleTextColor,
            textFontSize: w * .05,
            textFontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  /// -------------------- Common Topic Item --------------------
  Widget _commonTopicItem({required String icon, required String title}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        CustomNavigator.push(
          context,
          FAQs(),
          transition: TransitionType.slideLeft,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsList.textfieldBorderColorSe),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 40, height: 40),
            const SizedBox(height: 8),
            CustomText(
              text: title,
              textalign: TextAlign.center,
              textColor: ColorsList.titleTextColor,
              textFontSize: 13,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
