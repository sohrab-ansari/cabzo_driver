// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:nzcu_driver/views/profile_screens/faqs_details_screen.dart';
// import 'package:flutter/material.dart';

// class FAQs extends StatefulWidget {
//   const FAQs({super.key});

//   @override
//   State<FAQs> createState() => _FAQsState();
// }

// class _FAQsState extends State<FAQs> {
//   // List screenList = [
//   //   ProfilePaymentScreen(),
//   //   SafetyScreen(),
//   //   ReferEarnScreen(),
//   //   ProfilePaymentScreen(),
//   //   SafetyScreen(),
//   //   ReferEarnScreen(),
//   // ];
//   //? help-screens

//   List titleList = [
//     "How do I update my profile details?",
//     "What happens if I cancel a ride?",
//     "When will I receive online payments?",
//     "What if the user doesn’t pay?",
//     "The user is not at pickup point, what should I do?",
//     "How do I accept or reject a ride?",
//     "Why was my Aadhaar/ID rejected?",
//   ];
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
//               text: "FAQs",
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
//             children: List.generate(titleList.length, (index) {
//               return Column(
//                 children: [
//                   index == 0 ? SizedBox(height: w * .02) : SizedBox.shrink(),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FaqsDetailsScreen(),
//                         ),
//                       );
//                     },
//                     // onTap: () {
//                     //   index == 1
//                     //       ? CustomNavigation.push(context, RideBillingScreen())
//                     //       : null;
//                     // },
//                     child: customMenuItemsButton(
//                       titleList[index],

//                       //? navigate screen=======================
//                     ),
//                   ),
//                   index < titleList.length - 1
//                       ? Divider(
//                           indent: w * .04,
//                           color: ColorsList.textfieldBorderColorSe,
//                         )
//                       : SizedBox.shrink(),
//                   index == titleList.length - 1
//                       ? SizedBox(height: w * .02)
//                       : SizedBox.shrink(),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }

//   //? method--
//   Widget customMenuItemsButton(
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
//             //Title
//             SizedBox(
//               width: w * .75,
//               // color: Colors.amber,
//               child: CustomText(
//                 text: title,
//                 textColor: ColorsList.titleTextColor,
//                 textFontSize: w * .046,
//                 textFontWeight: FontWeight.w400,
//               ),
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

// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:nzcu_driver/views/profile_screens/faqs_details_screen.dart';
// import 'package:flutter/material.dart';

// class FAQs extends StatefulWidget {
//   const FAQs({super.key});

//   @override
//   State<FAQs> createState() => _FAQsState();
// }

// class _FAQsState extends State<FAQs> {
//   // List screenList = [
//   //   ProfilePaymentScreen(),
//   //   SafetyScreen(),
//   //   ReferEarnScreen(),
//   //   ProfilePaymentScreen(),
//   //   SafetyScreen(),
//   //   ReferEarnScreen(),
//   // ];
//   //? help-screens

//   List titleList = [
//     "How do I update my profile details?",
//     "What happens if I cancel a ride?",
//     "When will I receive online payments?",
//     "What if the user doesn’t pay?",
//     "The user is not at pickup point, what should I do?",
//     "How do I accept or reject a ride?",
//     "Why was my Aadhaar/ID rejected?",
//   ];
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
//               text: "FAQs",
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
//             children: List.generate(titleList.length, (index) {
//               return Column(
//                 children: [
//                   index == 0 ? SizedBox(height: w * .02) : SizedBox.shrink(),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FaqsDetailsScreen(),
//                         ),
//                       );
//                     },
//                     // onTap: () {
//                     //   index == 1
//                     //       ? CustomNavigation.push(context, RideBillingScreen())
//                     //       : null;
//                     // },
//                     child: customMenuItemsButton(
//                       titleList[index],

//                       //? navigate screen=======================
//                     ),
//                   ),
//                   index < titleList.length - 1
//                       ? Divider(
//                           indent: w * .04,
//                           color: ColorsList.textfieldBorderColorSe,
//                         )
//                       : SizedBox.shrink(),
//                   index == titleList.length - 1
//                       ? SizedBox(height: w * .02)
//                       : SizedBox.shrink(),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }

//   //? method--
//   Widget customMenuItemsButton(
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
//             //Title
//             SizedBox(
//               width: w * .75,
//               // color: Colors.amber,
//               child: CustomText(
//                 text: title,
//                 textColor: ColorsList.titleTextColor,
//                 textFontSize: w * .046,
//                 textFontWeight: FontWeight.w400,
//               ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/profile_controllers/faqs_get_by_categories_controller.dart';
import 'package:nzcu_driver/modals/profile_modals/get_by_category_response.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/profile_screens/faqs_details_screen.dart';

class FAQs extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const FAQs({super.key, this.categoryId, this.categoryName});

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  final FaqsGetByCategoriesController faqsController = Get.put(
    FaqsGetByCategoriesController(),
  );

  @override
  void initState() {
    super.initState();

    print("myy_category_id : ${widget.categoryId}");

    print("myy_category_name : ${widget.categoryName}");
    // Fetch FAQs when screen opens
    if (widget.categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        faqsController.getFaqsByCategory(
          categoryId: widget.categoryId!,
          categoryName: widget.categoryName ?? 'FAQs',
        );
      });
    }
  }

  @override
  void dispose() {
    // Optional: Clear data when leaving screen
    // faqsController.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: w * .03,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                CustomNavigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: w * .07,
                color: ColorsList.iconColor,
              ),
            ),
            SizedBox(width: w * .02),
            Flexible(
              child: CustomText(
                text: widget.categoryName ?? "FAQs",
                textColor: ColorsList.titleTextColor,
                textFontSize: w * .052,
                textFontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .025),
        child: Obx(() {
          // Show loading indicator
          if (faqsController.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: ColorsList.buttonBlueColor),
                  SizedBox(height: w * .04),
                  CustomText(
                    text: "Loading FAQs...",
                    textColor: ColorsList.subtitleTextColor,
                    textFontSize: w * .04,
                  ),
                ],
              ),
            );
          }

          // Show error message
          if (faqsController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(w * .04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: w * .15, color: Colors.red),
                    SizedBox(height: w * .04),
                    CustomText(
                      text: "Failed to load FAQs",
                      textColor: Colors.red,
                      textFontSize: w * .045,
                      textFontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: w * .02),
                    CustomText(
                      text: faqsController.errorMessage.value,
                      textalign: TextAlign.center,
                      textColor: ColorsList.subtitleTextColor,
                      textFontSize: w * .035,
                    ),
                    SizedBox(height: w * .06),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.categoryId != null) {
                          faqsController.getFaqsByCategory(
                            categoryId: widget.categoryId!,
                            categoryName: widget.categoryName ?? 'FAQs',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsList.buttonBlueColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: w * .08,
                          vertical: w * .03,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Retry",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Get questions from response
          final questions =
              faqsController.faqsByCategoryResponse.value?.questions ?? [];

          // Show empty state
          if (questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    size: w * .2,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: w * .04),
                  CustomText(
                    text: "No FAQs available",
                    textColor: ColorsList.subtitleTextColor,
                    textFontSize: w * .045,
                    textFontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: w * .02),
                  CustomText(
                    text: "Check back later for updates",
                    textColor: Colors.grey,
                    textFontSize: w * .035,
                  ),
                ],
              ),
            );
          }

          // Display FAQs list
          return Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with count
                Padding(
                  padding: EdgeInsets.all(w * .04),
                  child: Row(
                    children: [
                      CustomText(
                        text: "${questions.length} Questions",
                        textColor: ColorsList.buttonBlueColor,
                        textFontSize: w * .04,
                        textFontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: ColorsList.textfieldBorderColorSe),

                // Questions list
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    indent: w * .04,
                    color: ColorsList.textfieldBorderColorSe,
                  ),
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return _buildQuestionItem(context, w, question);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Question item widget
  Widget _buildQuestionItem(
    BuildContext context,
    double w,
    GetByCategoryQuestion question,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to details screen with question and answer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaqsDetailsScreen(
              question: question.question ?? '',
              answer: question.answer ?? 'No answer available',
              categoryName: widget.categoryName,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .03),
        child: Row(
          children: [
            // Question mark icon
            Container(
              width: w * .08,
              height: w * .08,
              decoration: BoxDecoration(
                color: ColorsList.buttonBlueColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.help_outline,
                color: ColorsList.buttonBlueColor,
                size: w * .04,
              ),
            ),
            SizedBox(width: w * .03),

            // Question text
            Expanded(
              child: CustomText(
                text: question.question ?? 'No question',
                textColor: ColorsList.titleTextColor,
                textFontSize: w * .04,
                textFontWeight: FontWeight.w500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: ColorsList.subtitleTextColor,
              size: w * 0.035,
            ),
          ],
        ),
      ),
    );
  }
}
