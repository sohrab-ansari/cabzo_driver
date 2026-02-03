// // // import 'package:nzcu_driver/controllers/profile_controllers/add_money_wallet_controller.dart';
// // // import 'package:nzcu_driver/controllers/promo_code_controller/get_promo_code_controller.dart';
// // // import 'package:nzcu_driver/utilities/app_buttons.dart';
// // // import 'package:nzcu_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
// // // import 'package:nzcu_driver/utilities/colors.dart';
// // // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // // import 'package:nzcu_driver/utilities/custom_cupon_card.dart';
// // // import 'package:nzcu_driver/utilities/custom_font.dart';
// // // import 'package:nzcu_driver/utilities/custom_images.dart';
// // // import 'package:nzcu_driver/utilities/custom_text.dart';
// // // import 'package:nzcu_driver/utilities/navigator.dart';
// // // import 'package:nzcu_driver/views/popups/pop_ups.dart';
// // // import 'package:nzcu_driver/views/profile_related.dart/payment_related/money_transfer_screen.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// // // import 'package:get/get_core/src/get_main.dart';
// // // import 'package:get/get_instance/src/extension_instance.dart';

// // // class AddMoney extends StatefulWidget {
// // //   const AddMoney({super.key});

// // //   @override
// // //   State<AddMoney> createState() => _AddMoneyState();
// // // }

// // // class _AddMoneyState extends State<AddMoney> {
// // //   final TextEditingController _amountController = TextEditingController();


  

// // // final AddMoneyWalletController addMoneyWalletController = Get.put(AddMoneyWalletController());



// // // final GetPromoCodeController getPromoCodeController = Get.put(GetPromoCodeController());



// // // initState() {
// // //     super.initState();


// // //      getPromoCodeController.getPromoCode();
// // //   }
// // //   @override
// // //   void dispose() {
// // //     _amountController.dispose();
// // //     super.dispose();
// // //   }

// // //   /* ----------------------------- AMOUNT CHIP ----------------------------- */
// // //   Widget _amountChip(String text, int value) {
// // //     return InkWell(
// // //       borderRadius: BorderRadius.circular(20),
// // //       onTap: () {
// // //         _amountController.text = value.toString();
// // //       },
// // //       child: Container(
// // //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// // //         decoration: BoxDecoration(
// // //           color: const Color(0xFFF7F7F7),
// // //           border: Border.all(color: Colors.black),
// // //           borderRadius: BorderRadius.circular(20),
// // //         ),
// // //         child: Text(
// // //           text,
// // //           style: const TextStyle(
// // //             fontSize: 12,
// // //             fontWeight: FontWeight.w600,
// // //             color: AppColors.black,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   /* ----------------------------- APP BAR ----------------------------- */
// // //   PreferredSizeWidget _buildAppBar(double w) {
// // //     return AppBar(
// // //       backgroundColor: ColorsList.scaffoldColor,
// // //       automaticallyImplyLeading: false,
// // //       elevation: 0,
// // //       scrolledUnderElevation: 0,
// // //       titleSpacing: w * .03,
// // //       title: Row(
// // //         children: [
// // //           GestureDetector(
// // //             onTap: () => CustomNavigator.pop(context),
// // //             child: Icon(
// // //               Icons.arrow_back,
// // //               size: w * .07,
// // //               color: ColorsList.iconColor,
// // //             ),
// // //           ),
// // //           SizedBox(width: w * .035),
// // //           CustomText(
// // //             text: "Add Money",
// // //             textColor: ColorsList.titleTextColor,
// // //             textFontSize: w * .05,
// // //             textFontWeight: FontWeight.w500,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   /* ----------------------------- BODY ----------------------------- */
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final double w = MediaQuery.of(context).size.width;

// // //     return Scaffold(
// // //       backgroundColor: ColorsList.scaffoldColor,
// // //       resizeToAvoidBottomInset: true,
// // //       appBar: _buildAppBar(w),
// // //       body: SingleChildScrollView(
// // //         padding: EdgeInsets.only(
// // //           bottom: MediaQuery.of(context).viewInsets.bottom + w * .08,
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             SizedBox(height: w * .04),

// // //             /* ----------------------------- INFO TEXT ----------------------------- */
// // //             SizedBox(
// // //               width: w * .9,
// // //               child: Container(
// // //                 margin: EdgeInsets.only(left: w * .05),
// // //                 child: AppFonts.textPoppins(
// // //                   context,
// // //                   "Maintain minimum balance to continue accepting rides.",
// // //                   w * 0.037,
// // //                   FontWeight.w400,
// // //                   AppColors.black,
// // //                   TextAlign.left,
// // //                   TextOverflow.visible,
// // //                   maxLines: 2,
// // //                 ),
// // //               ),
// // //             ),

// // //             SizedBox(height: w * .05),

// // //             /* ----------------------------- AMOUNT FIELD ----------------------------- */
// // //             SizedBox(
// // //               width: w * .8,
// // //               child: Container(
// // //                 margin: EdgeInsets.only(left: w * .05),
// // //                 child: AppFonts.textPoppins(
// // //                   context,
// // //                   "Add Money to wallet",
// // //                   w * 0.037,
// // //                   FontWeight.w500,
// // //                   AppColors.black,
// // //                   TextAlign.left,
// // //                   TextOverflow.visible,
// // //                   maxLines: 2,
// // //                 ),
// // //               ),
// // //             ),

// // //             SizedBox(height: w * .02),
// // //             SizedBox(
// // //               height: w * .14,
// // //               child: Padding(
// // //                 padding: EdgeInsets.symmetric(horizontal: w * .05),
// // //                 child: TextFormField(
// // //                   controller: _amountController,
// // //                   keyboardType: TextInputType.number,
// // //                   style: const TextStyle(color: AppColors.black),
// // //                   decoration: InputDecoration(
// // //                     hintText: "Enter ",
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                     ),
// // //                     enabledBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                       borderSide: const BorderSide(color: Colors.grey),
// // //                     ),
// // //                     focusedBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                       borderSide: const BorderSide(color: AppColors.black),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),

// // //             SizedBox(height: w * .03),

// // //             /* ----------------------------- QUICK AMOUNTS ----------------------------- */
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 _amountChip("+100", 100),
// // //                 const SizedBox(width: 12),
// // //                 _amountChip("+500", 500),
// // //                 const SizedBox(width: 12),
// // //                 _amountChip("+1000", 1000),
// // //               ],
// // //             ),

// // //             SizedBox(height: w * .06),

// // //             /* ----------------------------- COUPON TITLE ----------------------------- */
// // //             Padding(
// // //               padding: EdgeInsets.symmetric(horizontal: w * .03),
// // //               child: Container(
// // //                 margin: EdgeInsets.only(left: w * .03),
// // //                 child: Align(
// // //                   alignment: Alignment.centerLeft,
// // //                   child: AppFonts.textPoppins(
// // //                     context,
// // //                     "Coupon",
// // //                     w * 0.045,
// // //                     FontWeight.w600,
// // //                     const Color(0xFF414141),
// // //                     TextAlign.start,
// // //                     TextOverflow.visible,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),

// // //             SizedBox(height: w * .03),

// // //             /* ----------------------------- COUPON CARD ----------------------------- */
// // //             InkWell(
// // //               onTap: () => PopUps().coupanAdd(context),
// // //               child: Padding(
// // //                 padding: EdgeInsets.symmetric(horizontal: w * .029),
// // //                 child: Container(
// // //                   margin: EdgeInsets.only(left: w * .03),
// // //                   child: NotchedCard(
// // //                     width: w,
// // //                     height: w * .3,
// // //                     child: Row(
// // //                       children: [
// // //                         SizedBox(width: w * .06),
// // //                         CustomImages.images(
// // //                           "assets/images/logo2.png",
// // //                           w * .15,
// // //                           w * .15,
// // //                         ),
// // //                         SizedBox(width: w * .01),
// // //                         Padding(
// // //                           padding: EdgeInsets.symmetric(vertical: w * .045),
// // //                           child: VerticalDottedDivider(
// // //                             width: w * .01,
// // //                             height: w * .4,
// // //                             strokeWidth: 1,
// // //                             color: AppColors.mediumGray,
// // //                           ),
// // //                         ),
// // //                         Expanded(
// // //                           child: Padding(
// // //                             padding: EdgeInsets.only(left: w * .02),
// // //                             child: Column(
// // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // //                               mainAxisAlignment: MainAxisAlignment.center,
// // //                               children: [
// // //                                 AppFonts.textPoppins(
// // //                                   context,
// // //                                   "50% off up to ₹100",
// // //                                   w * 0.04,
// // //                                   FontWeight.w600,
// // //                                   AppColors.black,
// // //                                   TextAlign.start,
// // //                                   TextOverflow.ellipsis,
// // //                                 ),
// // //                                 const SizedBox(height: 4),
// // //                                 AppFonts.textPoppins(
// // //                                   context,
// // //                                   "Add ₹100 to your wallet, pay only ₹50 with this coupon.",
// // //                                   w * 0.025,
// // //                                   FontWeight.w500,
// // //                                   AppColors.mediumGray,
// // //                                   TextAlign.start,
// // //                                   TextOverflow.ellipsis,
// // //                                   maxLines: 2,
// // //                                 ),
// // //                                 const SizedBox(height: 4),
// // //                                 AppFonts.textPoppins(
// // //                                   context,
// // //                                   "Works only on ₹100 and above",
// // //                                   w * 0.025,
// // //                                   FontWeight.w500,
// // //                                   AppColors.primaryRed,
// // //                                   TextAlign.start,
// // //                                   TextOverflow.ellipsis,
// // //                                 ),
// // //                                 const SizedBox(height: 4),
// // //                                 AppFonts.textPoppins(
// // //                                   context,
// // //                                   "Valid until 03 October 2025",
// // //                                   w * 0.02,
// // //                                   FontWeight.w500,
// // //                                   AppColors.mediumGray,
// // //                                   TextAlign.start,
// // //                                   TextOverflow.ellipsis,
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),

// // //             SizedBox(height: w * .69),

// // //             /* ----------------------------- ADD MONEY BUTTON ----------------------------- */
// // //             Padding(
// // //               padding: EdgeInsets.symmetric(horizontal: w * .06),
// // //               child: AppButtons.solid(
// // //                 context: context,
// // //                 text: "Pay(50)",
// // //                 onClicked: () {

// // //                   addMoneyWalletController.add_wallet_method(amount:_amountController.text );
// // //                 },
// // //                 isFullWidth: true,
// // //                 backgroundColor: const Color(0xFFE0E4E7),
// // //                 textColor: AppColors.mediumGray,
// // //                 fontSize: w * .045,
// // //                 height: w * .14,
// // //                 radius: 12.0,
// // //               ),
// // //             ),

// // //             SizedBox(height: w * .03),

// // //             /* ----------------------------- TRANSFER BUTTON ----------------------------- */
// // //             // Padding(
// // //             //   padding: EdgeInsets.symmetric(horizontal: w * .06),
// // //             //   child: AppButtons.solid(
// // //             //     context: context,
// // //             //     text: "Money Transfer Screen",
// // //             //     onClicked: () {
// // //             //       CustomNavigator.push(
// // //             //         context,
// // //             //         const MoneyTransferScreen(),
// // //             //         transition: TransitionType.fade,
// // //             //       );
// // //             //     },
// // //             //     isFullWidth: true,
// // //             //     backgroundColor: AppColors.primaryRed,
// // //             //     textColor: AppColors.white,
// // //             //     fontSize: w * .045,
// // //             //     height: w * .14,
// // //             //     radius: 12.0,
// // //             //   ),
// // //             // ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }


// // import 'package:nzcu_driver/controllers/profile_controllers/add_money_wallet_controller.dart';
// // import 'package:nzcu_driver/controllers/promo_code_controller/get_promo_code_controller.dart';
// // import 'package:nzcu_driver/utilities/app_buttons.dart';
// // import 'package:nzcu_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
// // import 'package:nzcu_driver/utilities/colors.dart';
// // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // import 'package:nzcu_driver/utilities/custom_cupon_card.dart';
// // import 'package:nzcu_driver/utilities/custom_font.dart';
// // import 'package:nzcu_driver/utilities/custom_images.dart';
// // import 'package:nzcu_driver/utilities/custom_text.dart';
// // import 'package:nzcu_driver/utilities/navigator.dart';
// // import 'package:nzcu_driver/views/popups/pop_ups.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// // import 'package:get/get.dart';
// // import 'package:intl/intl.dart';

// // import '../../../modals/get_promo_code_data.dart';

// // class AddMoney extends StatefulWidget {
// //   const AddMoney({super.key});

// //   @override
// //   State<AddMoney> createState() => _AddMoneyState();
// // }

// // class _AddMoneyState extends State<AddMoney> {
// //   final TextEditingController _amountController = TextEditingController();
// //   final AddMoneyWalletController addMoneyWalletController = Get.put(AddMoneyWalletController());
// //   final GetPromoCodeController getPromoCodeController = Get.put(GetPromoCodeController());
  
// //   // Add a variable to store selected promo code
// //   Datum? _selectedPromoCode;

// //   @override
// //   void initState() {
// //     super.initState();
// //     getPromoCodeController.getPromoCode();
// //   }

// //   @override
// //   void dispose() {
// //     _amountController.dispose();
// //     super.dispose();
// //   }

// //   /* ---------------------- PROMO CODE SELECTION METHOD --------------------- */
// //   void _selectPromoCode(Datum promoCode) {
// //     setState(() {
// //       _selectedPromoCode = promoCode;
// //     });
// //     // Update the payment amount based on promo code
// //     _updatePaymentAmount();
// //   }

// //   /* ---------------------- UPDATE PAYMENT AMOUNT --------------------- */
// //   void _updatePaymentAmount() {
// //     if (_selectedPromoCode != null && _amountController.text.isNotEmpty) {
// //       final amount = double.tryParse(_amountController.text) ?? 0;
// //       if (amount >= (_selectedPromoCode!.minAmount ?? 0)) {
// //         // Calculate discount
// //         final discount = _calculateDiscount(amount);
// //         final finalAmount = amount - discount;
        
// //         print("Selected Promo: ${_selectedPromoCode!.code}");
// //         print("Original: $amount, Discount: $discount, Final: $finalAmount");
// //       }
// //     }
// //   }

// //   /* ---------------------- CALCULATE DISCOUNT --------------------- */
// //   double _calculateDiscount(double amount) {
// //     if (_selectedPromoCode == null) return 0;
    
// //     if (_selectedPromoCode!.flatDiscountAmount != null) {
// //       // Flat discount
// //       return _selectedPromoCode!.flatDiscountAmount.toDouble();
// //     } else if (_selectedPromoCode!.discountInPercentage != null) {
// //       // Percentage discount
// //       final discount = amount * (_selectedPromoCode!.discountInPercentage! / 100);
// //       // Apply max discount cap if exists
// //       if (_selectedPromoCode!.maxDiscountAmount != null) {
// //         return discount > _selectedPromoCode!.maxDiscountAmount! 
// //             ? _selectedPromoCode!.maxDiscountAmount!.toDouble() 
// //             : discount;
// //       }
// //       return discount;
// //     }
// //     return 0;
// //   }

// //   /* ---------------------- FORMAT DATE --------------------- */
// //   String _formatDate(DateTime? date) {
// //     if (date == null) return '';
// //     return DateFormat('dd MMM yyyy').format(date);
// //   }

// //   /* ---------------------- GET PAY BUTTON TEXT --------------------- */
// //   String _getPayButtonText() {
// //     if (_amountController.text.isEmpty) return "Pay";
    
// //     final amount = double.tryParse(_amountController.text) ?? 0;
    
// //     if (_selectedPromoCode != null && amount >= (_selectedPromoCode!.minAmount ?? 0)) {
// //       final discount = _calculateDiscount(amount);
// //       final finalAmount = amount - discount;
// //       return "Pay ₹${finalAmount.toStringAsFixed(2)}";
// //     }
    
// //     return "Pay ₹${amount.toStringAsFixed(2)}";
// //   }

// //   /* ---------------------- BUILD PROMO CODE CARD --------------------- */
// //   Widget _buildPromoCodeCard(Datum promoCode, double w) {
// //     final isSelected = _selectedPromoCode?.id == promoCode.id;
    
// //     // Determine discount text
// //     String discountText = '';
// //     if (promoCode.discountInPercentage != null) {
// //       discountText = '${promoCode.discountInPercentage}% off';
// //       if (promoCode.maxDiscountAmount != null) {
// //         discountText += ' up to ₹${promoCode.maxDiscountAmount}';
// //       }
// //     } else if (promoCode.flatDiscountAmount != null) {
// //       discountText = '₹${promoCode.flatDiscountAmount} off';
// //     }

// //     return InkWell(
// //       onTap: () => _selectPromoCode(promoCode),
// //       child: Container(
// //         margin: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .02),
// //         decoration: BoxDecoration(
// //           color: isSelected ? ColorsList.primaryRed.withOpacity(0.1) : Colors.white,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(
// //             color: isSelected ? ColorsList.primaryRed : Colors.grey[300]!,
// //             width: isSelected ? 2 : 1,
// //           ),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.1),
// //               blurRadius: 4,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.all(w * .04),
// //           child: Row(
// //             children: [
// //               // Promo Code Icon/Image
// //               Container(
// //                 width: w * .12,
// //                 height: w * .12,
// //                 decoration: BoxDecoration(
// //                   color: ColorsList.primaryRed.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Icon(
// //                   Icons.local_offer_outlined,
// //                   color: ColorsList.primaryRed,
// //                   size: w * .06,
// //                 ),
// //               ),
// //               SizedBox(width: w * .04),
              
// //               // Promo Code Details
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Code and Discount Badge
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         AppFonts.textPoppins(
// //                           context,
// //                           promoCode.code ?? 'PROMO',
// //                           w * 0.04,
// //                           FontWeight.w600,
// //                           AppColors.black,
// //                           TextAlign.start,
// //                           TextOverflow.ellipsis,
// //                         ),
// //                         if (discountText.isNotEmpty)
// //                           Container(
// //                             padding: EdgeInsets.symmetric(
// //                               horizontal: w * .03,
// //                               vertical: w * .01,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: ColorsList.primaryRed.withOpacity(0.1),
// //                               borderRadius: BorderRadius.circular(4),
// //                             ),
// //                             child: AppFonts.textPoppins(
// //                               context,
// //                               discountText,
// //                               w * 0.03,
// //                               FontWeight.w600,
// //                               ColorsList.primaryRed,
// //                               TextAlign.center,
// //                               TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                       ],
// //                     ),
                    
// //                     SizedBox(height: w * .01),
                    
// //                     // Description
// //                     if (promoCode.description != null && promoCode.description!.isNotEmpty)
// //                       AppFonts.textPoppins(
// //                         context,
// //                         promoCode.description!,
// //                         w * 0.032,
// //                         FontWeight.w400,
// //                         AppColors.mediumGray,
// //                         TextAlign.start,
// //                         TextOverflow.ellipsis,
// //                         maxLines: 2,
// //                       ),
                    
// //                     SizedBox(height: w * .01),
                    
// //                     // Minimum amount requirement
// //                     if (promoCode.minAmount != null)
// //                       AppFonts.textPoppins(
// //                         context,
// //                         'Min. order: ₹${promoCode.minAmount}',
// //                         w * 0.03,
// //                         FontWeight.w500,
// //                         ColorsList.primaryRed,
// //                         TextAlign.start,
// //                         TextOverflow.ellipsis,
// //                       ),
                    
// //                     SizedBox(height: w * .01),
                    
// //                     // Validity
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.calendar_today,
// //                           size: w * .035,
// //                           color: AppColors.mediumGray,
// //                         ),
// //                         SizedBox(width: w * .01),
// //                         AppFonts.textPoppins(
// //                           context,
// //                           'Valid until ${_formatDate(promoCode.expiryDate)}',
// //                           w * 0.03,
// //                           FontWeight.w500,
// //                           AppColors.mediumGray,
// //                           TextAlign.start,
// //                           TextOverflow.ellipsis,
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
              
// //               // Selection Indicator
// //               if (isSelected)
// //                 Icon(
// //                   Icons.check_circle,
// //                   color: ColorsList.primaryRed,
// //                   size: w * .06,
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   /* ---------------------- BUILD PROMO CODE LIST --------------------- */
// //   Widget _buildPromoCodeList(double w) {
// //     return Obx(() {
// //       final promoData = getPromoCodeController.cashResponse.value;
      
// //       if (getPromoCodeController.isLoading.value) {
// //         return Center(
// //           child: Padding(
// //             padding: EdgeInsets.symmetric(vertical: w * .05),
// //             child: CircularProgressIndicator(
// //               color: ColorsList.,
// //             ),
// //           ),
// //         );
// //       }
      
// //       if (getPromoCodeController.errorMessage.value.isNotEmpty) {
// //         return Center(
// //           child: Padding(
// //             padding: EdgeInsets.all(w * .05),
// //             child: Column(
// //               children: [
// //                 Icon(
// //                   Icons.error_outline,
// //                   color: Colors.red,
// //                   size: w * .1,
// //                 ),
// //                 SizedBox(height: w * .03),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   'Failed to load promo codes',
// //                   w * 0.04,
// //                   FontWeight.w500,
// //                   Colors.red,
// //                   TextAlign.center,
// //                   TextOverflow.ellipsis,
// //                 ),
// //                 SizedBox(height: w * .02),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   getPromoCodeController.errorMessage.value,
// //                   w * 0.032,
// //                   FontWeight.w400,
// //                   AppColors.mediumGray,
// //                   TextAlign.center,
// //                   TextOverflow.ellipsis,
// //                   maxLines: 2,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       }
      
// //       if (promoData == null || promoData.data == null || promoData.data!.isEmpty) {
// //         return Center(
// //           child: Padding(
// //             padding: EdgeInsets.symmetric(vertical: w * .05),
// //             child: Column(
// //               children: [
// //                 Icon(
// //                   Icons.local_offer_outlined,
// //                   color: AppColors.mediumGray,
// //                   size: w * .1,
// //                 ),
// //                 SizedBox(height: w * .03),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   'No promo codes available',
// //                   w * 0.04,
// //                   FontWeight.w500,
// //                   AppColors.mediumGray,
// //                   TextAlign.center,
// //                   TextOverflow.ellipsis,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       }
      
// //       // Build list of promo codes
// //       return Column(
// //         children: [
// //           // Available Promo Codes Title
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: w * .05, vertical: w * .02),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 AppFonts.textPoppins(
// //                   context,
// //                   'Available Promo Codes',
// //                   w * 0.04,
// //                   FontWeight.w600,
// //                   AppColors.black,
// //                   TextAlign.start,
// //                   TextOverflow.ellipsis,
// //                 ),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   '${promoData.data!.length} available',
// //                   w * 0.032,
// //                   FontWeight.w500,
// //                   AppColors.mediumGray,
// //                   TextAlign.start,
// //                   TextOverflow.ellipsis,
// //                 ),
// //               ],
// //             ),
// //           ),
          
// //           // Promo Code Cards
// //           ...promoData.data!.map((promoCode) => _buildPromoCodeCard(promoCode, w)).toList(),
// //         ],
// //       );
// //     });
// //   }

// //   /* ----------------------------- AMOUNT CHIP ----------------------------- */
// //   Widget _amountChip(String text, int value) {
// //     return InkWell(
// //       borderRadius: BorderRadius.circular(20),
// //       onTap: () {
// //         _amountController.text = value.toString();
// //         setState(() {}); // Rebuild to update pay button
// //         _updatePaymentAmount();
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFF7F7F7),
// //           border: Border.all(color: Colors.black),
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         child: Text(
// //           text,
// //           style: const TextStyle(
// //             fontSize: 12,
// //             fontWeight: FontWeight.w600,
// //             color: AppColors.black,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   /* ----------------------------- APP BAR ----------------------------- */
// //   PreferredSizeWidget _buildAppBar(double w) {
// //     return AppBar(
// //       backgroundColor: ColorsList.scaffoldColor,
// //       automaticallyImplyLeading: false,
// //       elevation: 0,
// //       scrolledUnderElevation: 0,
// //       titleSpacing: w * .03,
// //       title: Row(
// //         children: [
// //           GestureDetector(
// //             onTap: () => CustomNavigator.pop(context),
// //             child: Icon(
// //               Icons.arrow_back,
// //               size: w * .07,
// //               color: ColorsList.iconColor,
// //             ),
// //           ),
// //           SizedBox(width: w * .035),
// //           CustomText(
// //             text: "Add Money",
// //             textColor: ColorsList.titleTextColor,
// //             textFontSize: w * .05,
// //             textFontWeight: FontWeight.w500,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   /* ----------------------------- BODY ----------------------------- */
// //   @override
// //   Widget build(BuildContext context) {
// //     final double w = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       backgroundColor: ColorsList.scaffoldColor,
// //       resizeToAvoidBottomInset: true,
// //       appBar: _buildAppBar(w),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.only(
// //           bottom: MediaQuery.of(context).viewInsets.bottom + w * .08,
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             SizedBox(height: w * .04),

// //             /* ----------------------------- INFO TEXT ----------------------------- */
// //             SizedBox(
// //               width: w * .9,
// //               child: Container(
// //                 margin: EdgeInsets.only(left: w * .05),
// //                 child: AppFonts.textPoppins(
// //                   context,
// //                   "Maintain minimum balance to continue accepting rides.",
// //                   w * 0.037,
// //                   FontWeight.w400,
// //                   AppColors.black,
// //                   TextAlign.left,
// //                   TextOverflow.visible,
// //                   maxLines: 2,
// //                 ),
// //               ),
// //             ),

// //             SizedBox(height: w * .05),

// //             /* ----------------------------- AMOUNT FIELD ----------------------------- */
// //             SizedBox(
// //               width: w * .8,
// //               child: Container(
// //                 margin: EdgeInsets.only(left: w * .05),
// //                 child: AppFonts.textPoppins(
// //                   context,
// //                   "Add Money to wallet",
// //                   w * 0.037,
// //                   FontWeight.w500,
// //                   AppColors.black,
// //                   TextAlign.left,
// //                   TextOverflow.visible,
// //                   maxLines: 2,
// //                 ),
// //               ),
// //             ),

// //             SizedBox(height: w * .02),
// //             SizedBox(
// //               height: w * .14,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: w * .05),
// //                 child: TextFormField(
// //                   controller: _amountController,
// //                   keyboardType: TextInputType.number,
// //                   onChanged: (value) {
// //                     setState(() {}); // Rebuild to update pay button
// //                     _updatePaymentAmount();
// //                   },
// //                   style: const TextStyle(color: AppColors.black),
// //                   decoration: InputDecoration(
// //                     hintText: "Enter amount",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     enabledBorder: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                       borderSide: const BorderSide(color: Colors.grey),
// //                     ),
// //                     focusedBorder: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                       borderSide: const BorderSide(color: AppColors.black),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             SizedBox(height: w * .03),

// //             /* ----------------------------- QUICK AMOUNTS ----------------------------- */
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 _amountChip("+100", 100),
// //                 const SizedBox(width: 12),
// //                 _amountChip("+500", 500),
// //                 const SizedBox(width: 12),
// //                 _amountChip("+1000", 1000),
// //               ],
// //             ),

// //             SizedBox(height: w * .06),

// //             /* ----------------------------- PROMO CODE SECTION ----------------------------- */
// //             Container(
// //               width: double.infinity,
// //               padding: EdgeInsets.symmetric(vertical: w * .02),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   /* ----------------------------- COUPON TITLE ----------------------------- */
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: w * .05),
// //                     child: AppFonts.textPoppins(
// //                       context,
// //                       "Apply Promo Code",
// //                       w * 0.045,
// //                       FontWeight.w600,
// //                       const Color(0xFF414141),
// //                       TextAlign.start,
// //                       TextOverflow.visible,
// //                     ),
// //                   ),
                  
// //                   SizedBox(height: w * .02),
                  
// //                   /* ----------------------------- PROMO CODE LIST ----------------------------- */
// //                   _buildPromoCodeList(w),
// //                 ],
// //               ),
// //             ),

// //             SizedBox(height: w * .05),

// //             /* ----------------------------- ADD MONEY BUTTON ----------------------------- */
// //             Padding(
// //               padding: EdgeInsets.symmetric(horizontal: w * .06),
// //               child: AppButtons.solid(
// //                 context: context,
// //                 text: _getPayButtonText(),
// //                 onClicked: () {
// //                   if (_amountController.text.isEmpty) {
// //                     Get.snackbar(
// //                       'Error',
// //                       'Please enter an amount',
// //                       snackPosition: SnackPosition.BOTTOM,
// //                       backgroundColor: Colors.red,
// //                       colorText: Colors.white,
// //                     );
// //                     return;
// //                   }
                  
// //                   final amount = double.tryParse(_amountController.text) ?? 0;
                  
// //                   // Check if selected promo code meets minimum amount requirement
// //                   if (_selectedPromoCode != null && amount < (_selectedPromoCode!.minAmount ?? 0)) {
// //                     Get.snackbar(
// //                       'Error',
// //                       'Minimum amount for this promo is ₹${_selectedPromoCode!.minAmount}',
// //                       snackPosition: SnackPosition.BOTTOM,
// //                       backgroundColor: Colors.red,
// //                       colorText: Colors.white,
// //                     );
// //                     return;
// //                   }
                  
// //                   // Pass promo code ID if selected
// //                   final promoCodeId = _selectedPromoCode?.id;
                  
// //                   addMoneyWalletController.add_wallet_method(
// //                     amount: _amountController.text,
// //                     promoCodeId: promoCodeId,
// //                   );
// //                 },
// //                 isFullWidth: true,
// //                 backgroundColor: _amountController.text.isNotEmpty 
// //                     ? ColorsList.primaryRed 
// //                     : const Color(0xFFE0E4E7),
// //                 textColor: _amountController.text.isNotEmpty 
// //                     ? AppColors.white 
// //                     : AppColors.mediumGray,
// //                 fontSize: w * .045,
// //                 height: w * .14,
// //                 radius: 12.0,
// //               ),
// //             ),

// //             SizedBox(height: w * .03),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:nzcu_driver/controllers/profile_controllers/add_money_wallet_controller.dart';
// import 'package:nzcu_driver/controllers/promo_code_controller/get_promo_code_controller.dart';
// import 'package:nzcu_driver/modals/get_promo_code_data.dart';
// import 'package:nzcu_driver/utilities/app_buttons.dart';
// import 'package:nzcu_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/custom_cupon_card.dart';
// import 'package:nzcu_driver/utilities/custom_font.dart';
// import 'package:nzcu_driver/utilities/custom_images.dart';
// import 'package:nzcu_driver/utilities/custom_text.dart';
// import 'package:nzcu_driver/utilities/navigator.dart';
// import 'package:nzcu_driver/views/popups/pop_ups.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class AddMoney extends StatefulWidget {
//   const AddMoney({super.key});

//   @override
//   State<AddMoney> createState() => _AddMoneyState();
// }

// class _AddMoneyState extends State<AddMoney> {
//   final TextEditingController _amountController = TextEditingController();
//   final AddMoneyWalletController addMoneyWalletController = Get.put(AddMoneyWalletController());
//   final GetPromoCodeController getPromoCodeController = Get.put(GetPromoCodeController());
  
//   // Add a variable to store selected promo code
//   Datum? _selectedPromoCode;

//   @override
//   void initState() {
//     super.initState();
//     getPromoCodeController.getPromoCode();
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }

//   /* ---------------------- PROMO CODE SELECTION METHOD --------------------- */
//   void _selectPromoCode(Datum promoCode) {
//     setState(() {
//       _selectedPromoCode = promoCode;
//     });
//     // Update the payment amount based on promo code
//     _updatePaymentAmount();
//   }

//   /* ---------------------- UPDATE PAYMENT AMOUNT --------------------- */
//   void _updatePaymentAmount() {
//     if (_selectedPromoCode != null && _amountController.text.isNotEmpty) {
//       final amount = double.tryParse(_amountController.text) ?? 0;
//       if (amount >= (_selectedPromoCode!.minAmount ?? 0)) {
//         // Calculate discount
//         final discount = _calculateDiscount(amount);
//         final finalAmount = amount - discount;
        
//         print("Selected Promo: ${_selectedPromoCode!.code}");
//         print("Original: $amount, Discount: $discount, Final: $finalAmount");
//       }
//     }
//   }

//   /* ---------------------- CALCULATE DISCOUNT --------------------- */
//   double _calculateDiscount(double amount) {
//     if (_selectedPromoCode == null) return 0;
    
//     if (_selectedPromoCode!.flatDiscountAmount != null) {
//       // Flat discount
//       return _selectedPromoCode!.flatDiscountAmount.toDouble();
//     } else if (_selectedPromoCode!.discountInPercentage != null) {
//       // Percentage discount
//       final discount = amount * (_selectedPromoCode!.discountInPercentage! / 100);
//       // Apply max discount cap if exists
//       if (_selectedPromoCode!.maxDiscountAmount != null) {
//         return discount > _selectedPromoCode!.maxDiscountAmount! 
//             ? _selectedPromoCode!.maxDiscountAmount!.toDouble() 
//             : discount;
//       }
//       return discount;
//     }
//     return 0;
//   }

//   /* ---------------------- FORMAT DATE --------------------- */
//   String _formatDate(DateTime? date) {
//     if (date == null) return '';
//     return DateFormat('dd MMM yyyy').format(date);
//   }

//   /* ---------------------- GET PAY BUTTON TEXT --------------------- */
//   String _getPayButtonText() {
//     if (_amountController.text.isEmpty) return "Pay";
    
//     final amount = double.tryParse(_amountController.text) ?? 0;
    
//     if (_selectedPromoCode != null && amount >= (_selectedPromoCode!.minAmount ?? 0)) {
//       final discount = _calculateDiscount(amount);
//       final finalAmount = amount - discount;
//       return "Pay ₹${finalAmount.toStringAsFixed(2)}";
//     }
    
//     return "Pay ₹${amount.toStringAsFixed(2)}";
//   }

//   /* ---------------------- BUILD PROMO CODE CARD --------------------- */
//   Widget _buildPromoCodeCard(Datum promoCode, double w) {
//     final isSelected = _selectedPromoCode?.id == promoCode.id;
    
//     // Determine discount text
//     String discountText = '';
//     if (promoCode.discountInPercentage != null) {
//       discountText = '${promoCode.discountInPercentage}% off';
//       if (promoCode.maxDiscountAmount != null) {
//         discountText += ' up to ₹${promoCode.maxDiscountAmount}';
//       }
//     } else if (promoCode.flatDiscountAmount != null) {
//       discountText = '₹${promoCode.flatDiscountAmount} off';
//     }

//     return InkWell(
//       onTap: () => _selectPromoCode(promoCode),
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .02),
//         decoration: BoxDecoration(
//           color: isSelected ? ColorsList.mainAppColor.withOpacity(0.1) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? ColorsList.mainAppColor : Colors.grey[300]!,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(w * .04),
//           child: Row(
//             children: [
//               // Promo Code Icon/Image
//               Container(
//                 width: w * .12,
//                 height: w * .12,
//                 decoration: BoxDecoration(
//                   color: ColorsList.mainAppColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.local_offer_outlined,
//                   color: ColorsList.mainAppColor,
//                   size: w * .06,
//                 ),
//               ),
//               SizedBox(width: w * .04),
              
//               // Promo Code Details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Code and Discount Badge
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         AppFonts.textPoppins(
//                           context,
//                           promoCode.code ?? 'PROMO',
//                           w * 0.04,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.start,
//                           TextOverflow.ellipsis,
//                         ),
//                         if (discountText.isNotEmpty)
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: w * .03,
//                               vertical: w * .01,
//                             ),
//                             decoration: BoxDecoration(
//                               color: ColorsList.mainAppColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: AppFonts.textPoppins(
//                               context,
//                               discountText,
//                               w * 0.03,
//                               FontWeight.w600,
//                               ColorsList.mainAppColor,
//                               TextAlign.center,
//                               TextOverflow.ellipsis,
//                             ),
//                           ),
//                       ],
//                     ),
                    
//                     SizedBox(height: w * .01),
                    
//                     // Description
//                     if (promoCode.description != null && promoCode.description!.isNotEmpty)
//                       AppFonts.textPoppins(
//                         context,
//                         promoCode.description!,
//                         w * 0.032,
//                         FontWeight.w400,
//                         AppColors.mediumGray,
//                         TextAlign.start,
//                         TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
                    
//                     SizedBox(height: w * .01),
                    
//                     // Minimum amount requirement
//                     if (promoCode.minAmount != null)
//                       AppFonts.textPoppins(
//                         context,
//                         'Min. order: ₹${promoCode.minAmount}',
//                         w * 0.03,
//                         FontWeight.w500,
//                         ColorsList.mainAppColor,
//                         TextAlign.start,
//                         TextOverflow.ellipsis,
//                       ),
                    
//                     SizedBox(height: w * .01),
                    
//                     // Validity
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_today,
//                           size: w * .035,
//                           color: AppColors.mediumGray,
//                         ),
//                         SizedBox(width: w * .01),
//                         AppFonts.textPoppins(
//                           context,
//                           'Valid until ${_formatDate(promoCode.expiryDate)}',
//                           w * 0.03,
//                           FontWeight.w500,
//                           AppColors.mediumGray,
//                           TextAlign.start,
//                           TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Selection Indicator
//               if (isSelected)
//                 Icon(
//                   Icons.check_circle,
//                   color: ColorsList.mainAppColor,
//                   size: w * .06,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /* ---------------------- BUILD PROMO CODE LIST --------------------- */
//   Widget _buildPromoCodeList(double w) {
//     return Obx(() {
//       final promoData = getPromoCodeController.cashResponse.value;
      
//       if (getPromoCodeController.isLoading.value) {
//         return Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: w * .05),
//             child: CircularProgressIndicator(
//               color: ColorsList.mainAppColor,
//             ),
//           ),
//         );
//       }
      
//       if (getPromoCodeController.errorMessage.value.isNotEmpty) {
//         return Center(
//           child: Padding(
//             padding: EdgeInsets.all(w * .05),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: w * .1,
//                 ),
//                 SizedBox(height: w * .03),
//                 AppFonts.textPoppins(
//                   context,
//                   'Failed to load promo codes',
//                   w * 0.04,
//                   FontWeight.w500,
//                   Colors.red,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: w * .02),
//                 AppFonts.textPoppins(
//                   context,
//                   getPromoCodeController.errorMessage.value,
//                   w * 0.032,
//                   FontWeight.w400,
//                   AppColors.mediumGray,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                   maxLines: 2,
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
      
//       if (promoData == null || promoData.data == null || promoData.data!.isEmpty) {
//         return Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: w * .05),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.local_offer_outlined,
//                   color: AppColors.mediumGray,
//                   size: w * .1,
//                 ),
//                 SizedBox(height: w * .03),
//                 AppFonts.textPoppins(
//                   context,
//                   'No promo codes available',
//                   w * 0.04,
//                   FontWeight.w500,
//                   AppColors.mediumGray,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
      
//       // Build list of promo codes
//       return Column(
//         children: [
//           // Available Promo Codes Title
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: w * .05, vertical: w * .02),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 AppFonts.textPoppins(
//                   context,
//                   'Available Promo Codes',
//                   w * 0.04,
//                   FontWeight.w600,
//                   AppColors.black,
//                   TextAlign.start,
//                   TextOverflow.ellipsis,
//                 ),
//                 AppFonts.textPoppins(
//                   context,
//                   '${promoData.data!.length} available',
//                   w * 0.032,
//                   FontWeight.w500,
//                   AppColors.mediumGray,
//                   TextAlign.start,
//                   TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
          
//           // Promo Code Cards
//           ...promoData.data!.map((promoCode) => _buildPromoCodeCard(promoCode, w)).toList(),
//         ],
//       );
//     });
//   }

//   /* ----------------------------- AMOUNT CHIP ----------------------------- */
//   Widget _amountChip(String text, int value) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: () {
//         _amountController.text = value.toString();
//         setState(() {}); // Rebuild to update pay button
//         _updatePaymentAmount();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF7F7F7),
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: AppColors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   /* ----------------------------- APP BAR ----------------------------- */
//   PreferredSizeWidget _buildAppBar(double w) {
//     return AppBar(
//       backgroundColor: ColorsList.scaffoldColor,
//       automaticallyImplyLeading: false,
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       titleSpacing: w * .03,
//       title: Row(
//         children: [
//           GestureDetector(
//             onTap: () => CustomNavigator.pop(context),
//             child: Icon(
//               Icons.arrow_back,
//               size: w * .07,
//               color: ColorsList.iconColor,
//             ),
//           ),
//           SizedBox(width: w * .035),
//           CustomText(
//             text: "Add Money",
//             textColor: ColorsList.titleTextColor,
//             textFontSize: w * .05,
//             textFontWeight: FontWeight.w500,
//           ),
//         ],
//       ),
//     );
//   }

//   /* ----------------------------- BODY ----------------------------- */
//   @override
//   Widget build(BuildContext context) {
//     final double w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: ColorsList.scaffoldColor,
//       resizeToAvoidBottomInset: true,
//       appBar: _buildAppBar(w),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + w * .08,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: w * .04),

//             /* ----------------------------- INFO TEXT ----------------------------- */
//             SizedBox(
//               width: w * .9,
//               child: Container(
//                 margin: EdgeInsets.only(left: w * .05),
//                 child: AppFonts.textPoppins(
//                   context,
//                   "Maintain minimum balance to continue accepting rides.",
//                   w * 0.037,
//                   FontWeight.w400,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.visible,
//                   maxLines: 2,
//                 ),
//               ),
//             ),

//             SizedBox(height: w * .05),

//             /* ----------------------------- AMOUNT FIELD ----------------------------- */
//             SizedBox(
//               width: w * .8,
//               child: Container(
//                 margin: EdgeInsets.only(left: w * .05),
//                 child: AppFonts.textPoppins(
//                   context,
//                   "Add Money to wallet",
//                   w * 0.037,
//                   FontWeight.w500,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.visible,
//                   maxLines: 2,
//                 ),
//               ),
//             ),

//             SizedBox(height: w * .02),
//             SizedBox(
//               height: w * .14,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: w * .05),
//                 child: TextFormField(
//                   controller: _amountController,
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     setState(() {}); // Rebuild to update pay button
//                     _updatePaymentAmount();
//                   },
//                   style: const TextStyle(color: AppColors.black),
//                   decoration: InputDecoration(
//                     hintText: "Enter amount",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Colors.grey),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: AppColors.black),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: w * .03),

//             /* ----------------------------- QUICK AMOUNTS ----------------------------- */
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _amountChip("+100", 100),
//                 const SizedBox(width: 12),
//                 _amountChip("+500", 500),
//                 const SizedBox(width: 12),
//                 _amountChip("+1000", 1000),
//               ],
//             ),

//             SizedBox(height: w * .06),

//             /* ----------------------------- PROMO CODE SECTION ----------------------------- */
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: w * .02),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /* ----------------------------- COUPON TITLE ----------------------------- */
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: w * .05),
//                     child: AppFonts.textPoppins(
//                       context,
//                       "Apply Promo Code",
//                       w * 0.045,
//                       FontWeight.w600,
//                       const Color(0xFF414141),
//                       TextAlign.start,
//                       TextOverflow.visible,
//                     ),
//                   ),
                  
//                   SizedBox(height: w * .02),
                  
//                   /* ----------------------------- PROMO CODE LIST ----------------------------- */
//                   _buildPromoCodeList(w),
//                 ],
//               ),
//             ),

//             SizedBox(height: w * .05),

//             /* ----------------------------- ADD MONEY BUTTON ----------------------------- */
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: w * .06),
//               child: AppButtons.solid(
//                 context: context,
//                 text: _getPayButtonText(),
//                 onClicked: () {
//                   if (_amountController.text.isEmpty) {
//                     Get.snackbar(
//                       'Error',
//                       'Please enter an amount',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }
                  
//                   final amount = double.tryParse(_amountController.text) ?? 0;
                  
//                   // Check if selected promo code meets minimum amount requirement
//                   if (_selectedPromoCode != null && amount < (_selectedPromoCode!.minAmount ?? 0)) {
//                     Get.snackbar(
//                       'Error',
//                       'Minimum amount for this promo is ₹${_selectedPromoCode!.minAmount}',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }
                  
//                   // Pass promo code ID if selected
//                   final promoCodeId = _selectedPromoCode?.id;
                  
//                   addMoneyWalletController.add_wallet_method(
//                     amount: _amountController.text,
//                     // promoCodeId: promoCodeId,
//                   );
//                 },
//                 isFullWidth: true,
//                 backgroundColor: _amountController.text.isNotEmpty 
//                     ? ColorsList.mainAppColor // Using your teal color
//                     : const Color(0xFFE0E4E7),
//                 textColor: _amountController.text.isNotEmpty 
//                     ? AppColors.white 
//                     : AppColors.mediumGray,
//                 fontSize: w * .045,
//                 height: w * .14,
//                 radius: 12.0,
//               ),
//             ),

//             SizedBox(height: w * .03),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:nzcu_driver/controllers/profile_controllers/add_money_wallet_controller.dart';
import 'package:nzcu_driver/controllers/promo_code_controller/get_promo_code_controller.dart';
import 'package:nzcu_driver/modals/get_promo_code_data.dart';
import 'package:nzcu_driver/utilities/app_buttons.dart';
import 'package:nzcu_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/custom_cupon_card.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';
import 'package:nzcu_driver/utilities/custom_images.dart';
import 'package:nzcu_driver/utilities/custom_text.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/popups/pop_ups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({super.key});

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final TextEditingController _amountController = TextEditingController();
  final AddMoneyWalletController addMoneyWalletController = Get.put(AddMoneyWalletController());
  final GetPromoCodeController getPromoCodeController = Get.put(GetPromoCodeController());
  
  // Add a variable to store selected promo code
  Datum? _selectedPromoCode;

  @override
  void initState() {
    super.initState();
    getPromoCodeController.getPromoCode();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /* ---------------------- PROMO CODE SELECTION METHOD --------------------- */
  void _selectPromoCode(Datum promoCode) {
    setState(() {
      _selectedPromoCode = promoCode;
    });
    // Update the payment amount based on promo code
    _updatePaymentAmount();
  }

  /* ---------------------- UPDATE PAYMENT AMOUNT --------------------- */
  void _updatePaymentAmount() {
    if (_selectedPromoCode != null && _amountController.text.isNotEmpty) {
      final amount = double.tryParse(_amountController.text) ?? 0;
      if (amount >= (_selectedPromoCode!.minAmount ?? 0)) {
        // Calculate discount
        final discount = _calculateDiscount(amount);
        final finalAmount = amount - discount;
        
        print("Selected Promo: ${_selectedPromoCode!.code}");
        print("Original: $amount, Discount: $discount, Final: $finalAmount");
      }
    }
  }

  /* ---------------------- CALCULATE DISCOUNT --------------------- */
  double _calculateDiscount(double amount) {
    if (_selectedPromoCode == null) return 0;
    
    if (_selectedPromoCode!.flatDiscountAmount != null) {
      // Flat discount
      return _selectedPromoCode!.flatDiscountAmount.toDouble();
    } else if (_selectedPromoCode!.discountInPercentage != null) {
      // Percentage discount
      final discount = amount * (_selectedPromoCode!.discountInPercentage! / 100);
      // Apply max discount cap if exists
      if (_selectedPromoCode!.maxDiscountAmount != null) {
        return discount > _selectedPromoCode!.maxDiscountAmount! 
            ? _selectedPromoCode!.maxDiscountAmount!.toDouble() 
            : discount;
      }
      return discount;
    }
    return 0;
  }

  /* ---------------------- FORMAT DATE --------------------- */
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  /* ---------------------- GET PAY BUTTON TEXT --------------------- */
  String _getPayButtonText() {
    if (_amountController.text.isEmpty) return "Pay";
    
    final amount = double.tryParse(_amountController.text) ?? 0;
    
    if (_selectedPromoCode != null && amount >= (_selectedPromoCode!.minAmount ?? 0)) {
      final discount = _calculateDiscount(amount);
      final finalAmount = amount - discount;
      return "Pay ₹${finalAmount.toStringAsFixed(2)}";
    }
    
    return "Pay ₹${amount.toStringAsFixed(2)}";
  }

  /* ---------------------- BUILD PROMO CODE CARD --------------------- */
  Widget _buildPromoCodeCard(Datum promoCode, double w) {
    final isSelected = _selectedPromoCode?.id == promoCode.id;
    
    // Determine discount text
    String discountText = '';
    if (promoCode.discountInPercentage != null) {
      discountText = '${promoCode.discountInPercentage}% off';
      if (promoCode.maxDiscountAmount != null) {
        discountText += ' up to ₹${promoCode.maxDiscountAmount}';
      }
    } else if (promoCode.flatDiscountAmount != null) {
      discountText = '₹${promoCode.flatDiscountAmount} off';
    }

    return InkWell(
      onTap: () => _selectPromoCode(promoCode),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .02),
        decoration: BoxDecoration(
          color: isSelected ? ColorsList.mainAppColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorsList.mainAppColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(w * .04),
          child: Row(
            children: [
              // Promo Code Icon/Image
              Container(
                width: w * .12,
                height: w * .12,
                decoration: BoxDecoration(
                  color: ColorsList.mainAppColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_offer_outlined,
                  color: ColorsList.mainAppColor,
                  size: w * .06,
                ),
              ),
              SizedBox(width: w * .04),
              
              // Promo Code Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code and Discount Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppFonts.textPoppins(
                          context,
                          promoCode.code ?? 'PROMO',
                          w * 0.04,
                          FontWeight.w600,
                          AppColors.black,
                          TextAlign.start,
                          TextOverflow.ellipsis,
                        ),
                        if (discountText.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * .03,
                              vertical: w * .01,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsList.mainAppColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AppFonts.textPoppins(
                              context,
                              discountText,
                              w * 0.03,
                              FontWeight.w600,
                              ColorsList.mainAppColor,
                              TextAlign.center,
                              TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    
                    SizedBox(height: w * .01),
                    
                    // Description
                    if (promoCode.description != null && promoCode.description!.isNotEmpty)
                      AppFonts.textPoppins(
                        context,
                        promoCode.description!,
                        w * 0.032,
                        FontWeight.w400,
                        AppColors.mediumGray,
                        TextAlign.start,
                        TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    
                    SizedBox(height: w * .01),
                    
                    // Minimum amount requirement
                    if (promoCode.minAmount != null)
                      AppFonts.textPoppins(
                        context,
                        'Min. order: ₹${promoCode.minAmount}',
                        w * 0.03,
                        FontWeight.w500,
                        ColorsList.mainAppColor,
                        TextAlign.start,
                        TextOverflow.ellipsis,
                      ),
                    
                    SizedBox(height: w * .01),
                    
                    // Validity
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: w * .035,
                          color: AppColors.mediumGray,
                        ),
                        SizedBox(width: w * .01),
                        AppFonts.textPoppins(
                          context,
                          'Valid until ${_formatDate(promoCode.expiryDate)}',
                          w * 0.03,
                          FontWeight.w500,
                          AppColors.mediumGray,
                          TextAlign.start,
                          TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: ColorsList.mainAppColor,
                  size: w * .06,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /* ---------------------- BUILD PROMO CODE LIST --------------------- */
  Widget _buildPromoCodeList(double w) {
    return Obx(() {
      final promoData = getPromoCodeController.cashResponse.value;
      
      if (getPromoCodeController.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: w * .05),
            child: CircularProgressIndicator(
              color: ColorsList.mainAppColor,
            ),
          ),
        );
      }
      
      if (getPromoCodeController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(w * .05),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: w * .1,
                ),
                SizedBox(height: w * .03),
                AppFonts.textPoppins(
                  context,
                  'Failed to load promo codes',
                  w * 0.04,
                  FontWeight.w500,
                  Colors.red,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                ),
                SizedBox(height: w * .02),
                AppFonts.textPoppins(
                  context,
                  getPromoCodeController.errorMessage.value,
                  w * 0.032,
                  FontWeight.w400,
                  AppColors.mediumGray,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      }
      
      if (promoData == null || promoData.data == null || promoData.data!.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: w * .05),
            child: Column(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  color: AppColors.mediumGray,
                  size: w * .1,
                ),
                SizedBox(height: w * .03),
                AppFonts.textPoppins(
                  context,
                  'No promo codes available',
                  w * 0.04,
                  FontWeight.w500,
                  AppColors.mediumGray,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }
      
      // Build list of promo codes
      return Column(
        children: [
          // Available Promo Codes Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * .05, vertical: w * .02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppFonts.textPoppins(
                  context,
                  'Available Promo Codes',
                  w * 0.04,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.start,
                  TextOverflow.ellipsis,
                ),
                AppFonts.textPoppins(
                  context,
                  '${promoData.data!.length} available',
                  w * 0.032,
                  FontWeight.w500,
                  AppColors.mediumGray,
                  TextAlign.start,
                  TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Promo Code Cards
          ...promoData.data!.map((promoCode) => _buildPromoCodeCard(promoCode, w)).toList(),
        ],
      );
    });
  }

  /* ----------------------------- AMOUNT CHIP ----------------------------- */
  Widget _amountChip(String text, int value) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _amountController.text = value.toString();
        setState(() {}); // Rebuild to update pay button
        _updatePaymentAmount();
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
                  onChanged: (value) {
                    setState(() {}); // Rebuild to update pay button
                    _updatePaymentAmount();
                  },
                  style: const TextStyle(color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: "Enter amount",
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

            /* ----------------------------- PROMO CODE SECTION ----------------------------- */
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: w * .02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* ----------------------------- COUPON TITLE ----------------------------- */
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * .05),
                    child: AppFonts.textPoppins(
                      context,
                      "Apply Promo Code",
                      w * 0.045,
                      FontWeight.w600,
                      const Color(0xFF414141),
                      TextAlign.start,
                      TextOverflow.visible,
                    ),
                  ),
                  
                  SizedBox(height: w * .02),
                  
                  /* ----------------------------- PROMO CODE LIST ----------------------------- */
                  _buildPromoCodeList(w),
                ],
              ),
            ),

            SizedBox(height: w * .05),

            /* ----------------------------- ADD MONEY BUTTON ----------------------------- */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * .06),
              child: AppButtons.solid(
                context: context,
                text: _getPayButtonText(),
                onClicked: () {
                  if (_amountController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter an amount',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  
                  final amount = double.tryParse(_amountController.text) ?? 0;
                  
                  // Check if selected promo code meets minimum amount requirement
                  if (_selectedPromoCode != null && amount < (_selectedPromoCode!.minAmount ?? 0)) {
                    Get.snackbar(
                      'Error',
                      'Minimum amount for this promo is ₹${_selectedPromoCode!.minAmount}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  
                  // Pass promo code ID if selected
                  final promoCodeId = _selectedPromoCode?.id;
                  
                  addMoneyWalletController.add_wallet_method(
                    amount: _amountController.text,
                    promoCodeId: promoCodeId,
                  );
                },
                isFullWidth: true,
                backgroundColor: _amountController.text.isNotEmpty 
                    ? ColorsList.mainAppColor // Using your teal color
                    : const Color(0xFFE0E4E7),
                textColor: _amountController.text.isNotEmpty 
                    ? AppColors.white 
                    : AppColors.mediumGray,
                fontSize: w * .045,
                height: w * .14,
                radius: 12.0,
              ),
            ),

            SizedBox(height: w * .03),
          ],
        ),
      ),
    );
  }
}