import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/profile_related.dart/faqs_details_screen.dart';
import 'package:flutter/material.dart';

class FAQs extends StatefulWidget {
  const FAQs({super.key});

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  // List screenList = [
  //   ProfilePaymentScreen(),
  //   SafetyScreen(),
  //   ReferEarnScreen(),
  //   ProfilePaymentScreen(),
  //   SafetyScreen(),
  //   ReferEarnScreen(),
  // ];
  //? help-screens

  List titleList = [
    "How do I update my profile details?",
    "What happens if I cancel a ride?",
    "When will I receive online payments?",
    "What if the user doesn’t pay?",
    "The user is not at pickup point, what should I do?",
    "How do I accept or reject a ride?",
    "Why was my Aadhaar/ID rejected?",
  ];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        automaticallyImplyLeading: false,
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
            CustomText(
              text: "FAQs",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .025),
        child: Card(
          elevation: 1,
          color: ColorsList.scaffoldColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(titleList.length, (index) {
              return Column(
                children: [
                  index == 0 ? SizedBox(height: w * .02) : SizedBox.shrink(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaqsDetailsScreen(),
                        ),
                      );
                    },
                    // onTap: () {
                    //   index == 1
                    //       ? CustomNavigation.push(context, RideBillingScreen())
                    //       : null;
                    // },
                    child: customMenuItemsButton(
                      titleList[index],

                      //? navigate screen=======================
                    ),
                  ),
                  index < titleList.length - 1
                      ? Divider(
                          indent: w * .04,
                          color: ColorsList.textfieldBorderColorSe,
                        )
                      : SizedBox.shrink(),
                  index == titleList.length - 1
                      ? SizedBox(height: w * .02)
                      : SizedBox.shrink(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  //? method--
  Widget customMenuItemsButton(
    String title,
    //  Widget navigateScreen,
  ) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      color: ColorsList.scaffoldColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .02),
        child: Row(
          children: [
            //Title
            SizedBox(
              width: w * .75,
              // color: Colors.amber,
              child: CustomText(
                text: title,
                textColor: ColorsList.titleTextColor,
                textFontSize: w * .046,
                textFontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorsList.subtitleTextColor,
              size: w * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
