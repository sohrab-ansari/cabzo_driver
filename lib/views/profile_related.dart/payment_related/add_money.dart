import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_cupon_card.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/popups/pop_ups.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/money_transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({super.key});

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /* ----------------------------- AMOUNT CHIP ----------------------------- */
  Widget _amountChip(String text, int value) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _amountController.text = value.toString();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  /* ----------------------------- APP BAR ----------------------------- */
  PreferredSizeWidget _buildAppBar(double w) {
    return AppBar(
      backgroundColor: ColorsList.scaffoldColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
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
          SizedBox(width: w * .035),
          CustomText(
            text: "Add Money",
            textColor: ColorsList.titleTextColor,
            textFontSize: w * .05,
            textFontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  /* ----------------------------- BODY ----------------------------- */
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(w),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + w * .08,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: w * .04),

            /* ----------------------------- INFO TEXT ----------------------------- */
            SizedBox(
              width: w * .9,
              child: Container(
                margin: EdgeInsets.only(left: w * .05),
                child: AppFonts.textPoppins(
                  context,
                  "Maintain minimum balance to continue accepting rides.",
                  w * 0.037,
                  FontWeight.w400,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
            ),

            SizedBox(height: w * .05),

            /* ----------------------------- AMOUNT FIELD ----------------------------- */
            SizedBox(
              width: w * .8,
              child: Container(
                margin: EdgeInsets.only(left: w * .05),
                child: AppFonts.textPoppins(
                  context,
                  "Add Money to wallet",
                  w * 0.037,
                  FontWeight.w500,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
            ),

            SizedBox(height: w * .02),
            SizedBox(
              height: w * .14,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * .05),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: "Enter ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.black),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: w * .03),

            /* ----------------------------- QUICK AMOUNTS ----------------------------- */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _amountChip("+100", 100),
                const SizedBox(width: 12),
                _amountChip("+500", 500),
                const SizedBox(width: 12),
                _amountChip("+1000", 1000),
              ],
            ),

            SizedBox(height: w * .06),

            /* ----------------------------- COUPON TITLE ----------------------------- */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * .03),
              child: Container(
                margin: EdgeInsets.only(left: w * .03),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppFonts.textPoppins(
                    context,
                    "Coupon",
                    w * 0.045,
                    FontWeight.w600,
                    const Color(0xFF414141),
                    TextAlign.start,
                    TextOverflow.visible,
                  ),
                ),
              ),
            ),

            SizedBox(height: w * .03),

            /* ----------------------------- COUPON CARD ----------------------------- */
            InkWell(
              onTap: () => PopUps().coupanAdd(context),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * .029),
                child: Container(
                  margin: EdgeInsets.only(left: w * .03),
                  child: NotchedCard(
                    width: w,
                    height: w * .3,
                    child: Row(
                      children: [
                        SizedBox(width: w * .06),
                        CustomImages.images(
                          "assets/images/logo2.png",
                          w * .15,
                          w * .15,
                        ),
                        SizedBox(width: w * .01),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: w * .045),
                          child: VerticalDottedDivider(
                            width: w * .01,
                            height: w * .4,
                            strokeWidth: 1,
                            color: AppColors.mediumGray,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: w * .02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppFonts.textPoppins(
                                  context,
                                  "50% off up to ₹100",
                                  w * 0.04,
                                  FontWeight.w600,
                                  AppColors.black,
                                  TextAlign.start,
                                  TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                AppFonts.textPoppins(
                                  context,
                                  "Add ₹100 to your wallet, pay only ₹50 with this coupon.",
                                  w * 0.025,
                                  FontWeight.w500,
                                  AppColors.mediumGray,
                                  TextAlign.start,
                                  TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                AppFonts.textPoppins(
                                  context,
                                  "Works only on ₹100 and above",
                                  w * 0.025,
                                  FontWeight.w500,
                                  AppColors.primaryRed,
                                  TextAlign.start,
                                  TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                AppFonts.textPoppins(
                                  context,
                                  "Valid until 03 October 2025",
                                  w * 0.02,
                                  FontWeight.w500,
                                  AppColors.mediumGray,
                                  TextAlign.start,
                                  TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: w * .69),

            /* ----------------------------- ADD MONEY BUTTON ----------------------------- */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * .06),
              child: AppButtons.solid(
                context: context,
                text: "+ Add Money",
                onClicked: () {},
                isFullWidth: true,
                backgroundColor: const Color(0xFFE0E4E7),
                textColor: AppColors.mediumGray,
                fontSize: w * .045,
                height: w * .14,
                radius: 12.0,
              ),
            ),

            SizedBox(height: w * .03),

            /* ----------------------------- TRANSFER BUTTON ----------------------------- */
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: w * .06),
            //   child: AppButtons.solid(
            //     context: context,
            //     text: "Money Transfer Screen",
            //     onClicked: () {
            //       CustomNavigator.push(
            //         context,
            //         const MoneyTransferScreen(),
            //         transition: TransitionType.fade,
            //       );
            //     },
            //     isFullWidth: true,
            //     backgroundColor: AppColors.primaryRed,
            //     textColor: AppColors.white,
            //     fontSize: w * .045,
            //     height: w * .14,
            //     radius: 12.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
