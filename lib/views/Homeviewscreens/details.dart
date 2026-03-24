import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';

import 'package:flutter/material.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';

class Details {
  //? about rider============================
  Widget riderDetails(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: w * .02),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: w * .03),
            SizedBox(
              width: w * .35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Amaan Shaikh",
                    textColor: ColorsList.titleTextColor,
                    textFontSize: w * .04,
                    textFontWeight: FontWeight.w400,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                        size: w * .04,
                      ),
                      CustomText(
                        text: "4.5",
                        textColor: ColorsList.subtitleTextColor,
                        textFontSize: w * .03,
                        textFontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: w * .05),
            SizedBox(
              width: w * .28,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .005,
                  vertical: w * .005,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: w * .02),
                        CustomText(
                          text: "12/09/2025",
                          textColor: ColorsList.subtitleTextColor,
                          textFontSize: w * .03,
                          textFontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: w * .02),
                        CustomText(
                          text: "Round Trip",
                          textColor: ColorsList.subtitleTextColor,
                          textFontSize: w * .035,
                          textFontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //? details about locations and also cost.....
  Widget rideLocations(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        //? pickUp location history
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImages.images("assets/icons/greenDot.png", w * .04, w * .04),
            SizedBox(width: w * .04),
            Expanded(
              child: CustomText(
                text: "C95F+J2M, Manikonda Jagir, Hyderabad, Telangana 500089",
                textColor: ColorsList.titleTextColor,
                textFontSize: w * .03,
                textFontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: w * .03),
        //? drop location history
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImages.images("assets/icons/redDot.png", w * .04, w * .04),
            SizedBox(width: w * .04),
            Expanded(
              child: CustomText(
                text: "C95F+J2M, Manikonda Jagir, Hyderabad, Telangana 500089",
                textColor: ColorsList.titleTextColor,
                textFontSize: w * .03,
                textFontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //? ride history=> cost---distance ---time
  Widget rideCostDetails(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomImages.images("assets/icons/clockIcon.png", w * .045, w * .045),
        SizedBox(width: w * .02),
        CustomText(
          text: "05:03 Pm",
          textColor: ColorsList.titleTextColor,
          textFontSize: w * .035,
          textFontWeight: FontWeight.w400,
        ),
        SizedBox(width: w * .02),
        CircleAvatar(radius: 2, backgroundColor: ColorsList.subtitleTextColor),
        CustomText(
          text: " 12/09/2025",
          textColor: ColorsList.titleTextColor,
          textFontSize: w * .035,
          textFontWeight: FontWeight.w400,
        ),
        Spacer(),
        SizedBox(width: w * .02),
        CustomText(
          text: "₹250",
          textColor: AppColors.green,
          textFontSize: w * .035,
          textFontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget invoice(BuildContext context, dynamic orderData) {
    double w = MediaQuery.of(context).size.width;

    // Extract values safely
    final double totalFare = (orderData?['totalFare'] as num?)?.toDouble() ?? 0;
    final double pendingDue =
        (orderData?['pendingDue'] as num?)?.toDouble() ?? 0;
    final Map<String, dynamic>? waitingDetails =
        orderData?['waitingChargeDetails'] is Map<String, dynamic>
        ? orderData['waitingChargeDetails']
        : null;
    final double waitingCharge =
        (waitingDetails?['totalCharge'] as num?)?.toDouble() ?? 0;
    final int waitingMinutes =
        (waitingDetails?['chargeableMinutes'] as num?)?.toInt() ?? 0;

    // Grand Total = totalFare + pendingDue - promoCodeDiscount
    final double grandTotal = totalFare + pendingDue;

    // Build breakup lines: [name, amount, isNegative, subtitle]
    List<Map<String, dynamic>> breakupLines = [];

    // 1. Ride Fare (the base totalFare from backend)
    breakupLines.add({
      'name': 'Ride Fare',
      'amount': totalFare,
      'isNegative': false,
      'subtitle': null,
    });

    // 2. Waiting Charges (informational - already included in totalFare)
    if (waitingCharge > 0) {
      breakupLines.add({
        'name': 'Waiting Charges',
        'amount': waitingCharge,
        'isNegative': false,
        'subtitle': '($waitingMinutes min, included in Ride Fare)',
      });
    }

    // 3. Pending Due
    if (pendingDue > 0) {
      breakupLines.add({
        'name': 'Pending Due',
        'amount': pendingDue,
        'isNegative': false,
        'subtitle': null,
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: Column(
        children: [
          SizedBox(height: w * .04),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * .04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Fare Breakup",
                  textColor: ColorsList.titleTextColor,
                  textFontSize: w * .04,
                  textFontWeight: FontWeight.w600,
                ),
                SizedBox(),
              ],
            ),
          ),

          SizedBox(height: w * .02),

          // Breakup lines
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * .04),
            child: Column(
              children: breakupLines.map((line) {
                final String name = line['name'];
                final double amount = line['amount'];
                final bool isNegative = line['isNegative'];
                final String? subtitle = line['subtitle'];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: w * .008),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomText(
                              text: name,
                              textColor: ColorsList.titleTextColor,
                              textFontSize: w * .036,
                              textFontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isNegative)
                                CustomText(
                                  text: "- ",
                                  textColor: Colors.green.shade700,
                                  textFontSize: w * .036,
                                  textFontWeight: FontWeight.w500,
                                ),
                              Icon(
                                Icons.currency_rupee,
                                size: w * .034,
                                color: isNegative
                                    ? Colors.green.shade700
                                    : ColorsList.titleTextColor,
                              ),
                              CustomText(
                                text: amount.toStringAsFixed(
                                  amount == amount.roundToDouble() ? 0 : 2,
                                ),
                                textColor: isNegative
                                    ? Colors.green.shade700
                                    : ColorsList.titleTextColor,
                                textFontSize: w * .036,
                                textFontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: EdgeInsets.only(top: w * .005),
                          child: CustomText(
                            text: subtitle,
                            textColor: ColorsList.subtitleTextColor,
                            textFontSize: w * .028,
                            textFontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * .03),
            child: Divider(thickness: 1),
          ),

          // Grand Total
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * .04,
              vertical: w * .015,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Total Payable",
                  textColor: ColorsList.titleTextColor,
                  textFontSize: w * .042,
                  textFontWeight: FontWeight.w600,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: w * .042,
                      color: ColorsList.titleTextColor,
                    ),
                    CustomText(
                      text: grandTotal.toStringAsFixed(
                        grandTotal == grandTotal.roundToDouble() ? 0 : 2,
                      ),
                      textColor: ColorsList.titleTextColor,
                      textFontSize: w * .042,
                      textFontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: w * .02),
        ],
      ),
    );
  }
}
