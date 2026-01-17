// // import 'package:corezap_driver/controller/profilecontoller/get_bank_accounts_controller.dart';
// // import 'package:corezap_driver/utilities/app_buttons.dart';
// // import 'package:corezap_driver/utilities/colors.dart';
// // import 'package:corezap_driver/utilities/colors/colors_list.dart';
// // import 'package:corezap_driver/utilities/custom_font.dart';
// // import 'package:corezap_driver/utilities/custom_images.dart';
// // import 'package:corezap_driver/utilities/custom_text.dart';
// // import 'package:corezap_driver/utilities/navigator.dart';
// // import 'package:corezap_driver/utilities/text_fields.dart';
// // import 'package:corezap_driver/views/profile_related.dart/payment_related/add_bank.dart';
// // import 'package:corezap_driver/views/profile_related.dart/payment_related/add_upi.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:get/get_instance/src/extension_instance.dart';

// // class MoneyTransferScreen extends StatefulWidget {
// //   const MoneyTransferScreen({super.key});

// //   @override
// //   State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
// // }

// // class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  // final GetBankAccountsController getBankAccountsController = Get.put(
  //   GetBankAccountsController(),
  // );

// //   @override
// //   void initState() {
// //     getBankAccountsController.bankdetails_mdethod();
// //     // TODO: implement initState
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;
// //     return Scaffold(
// //       backgroundColor: ColorsList.scaffoldColor,
// //       resizeToAvoidBottomInset: true,
// //       appBar: AppBar(
// //         backgroundColor: ColorsList.scaffoldColor,
// //         automaticallyImplyLeading: false,
// //         scrolledUnderElevation: 0,
// //         elevation: 0,
// //         titleSpacing: w * .03,
// //         title: Row(
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 CustomNavigator.pop(context);
// //               },
// //               child: Icon(
// //                 Icons.arrow_back,
// //                 size: w * .07,
// //                 color: ColorsList.iconColor,
// //               ),
// //             ),
// //             SizedBox(width: w * .035),
// //             CustomText(
// //               text: "Money Transfer",
// //               textColor: ColorsList.titleTextColor,
// //               textFontSize: w * .05,
// //               textFontWeight: FontWeight.w500,
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: ListView.builder(
// //         itemCount: 1,
// //         itemBuilder: (context, index) => Padding(
// //           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Container(
// //                     width: w,
// //                     height: w * 0.40,
// //                     decoration: BoxDecoration(
// //                       color: AppColors.white,
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.grey.withOpacity(0.2),
// //                           spreadRadius: 2,
// //                           blurRadius: 3,
// //                           // changes position of shadow
// //                         ),
// //                       ],
// //                       borderRadius: BorderRadius.circular(w * 0.03),
// //                     ),
// //                     child: Padding(
// //                       padding: EdgeInsets.only(left: w * 0.04),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Icon(
// //                                 Icons.currency_rupee,
// //                                 color: AppColors.green,
// //                                 size: w * .063,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "100.0",
// //                                 w * 0.08,
// //                                 FontWeight.bold,
// //                                 AppColors.green,
// //                                 TextAlign.center,
// //                                 TextOverflow.visible,
// //                               ),
// //                             ],
// //                           ),
// //                           SizedBox(height: 8),
// //                           // Padding(
// //                           //   padding: EdgeInsets.symmetric(horizontal: w * .03),
// //                           //   child: BalanceTextField(
// //                           //     border: false,
// //                           //     textColor: AppColors.green,
// //                           //     fontWeight: FontWeight.w600,
// //                           //   ),
// //                           // ),
// //                           AppFonts.textPoppins(
// //                             context,
// //                             "Total amount to be transferred",
// //                             w * 0.03,
// //                             FontWeight.w500,
// //                             AppColors.black,
// //                             TextAlign.center,
// //                             TextOverflow.ellipsis,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //                   .animate()
// //                   .fade(duration: 820.ms, curve: Curves.easeInOut)
// //                   .scale(
// //                     begin: const Offset(0.95, 0.95),
// //                     end: const Offset(1, 1),
// //                   ),
// //               Padding(
// //                 padding: EdgeInsets.only(top: w * .03, bottom: w * .1),
// //                 child: AppFonts.textPoppins(
// //                   context,
// //                   "A service fee of 10% is deducted from each completed ride to cover platform charges.",
// //                   w * 0.032,
// //                   FontWeight.w500,
// //                   AppColors.mediumGray,
// //                   TextAlign.left,
// //                   TextOverflow.ellipsis,
// //                   maxLines: 2,
// //                 ),
// //               ),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Deposit to",
// //                 w * 0.043,
// //                 FontWeight.w600,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),


// //               Padding(
// //                 padding: EdgeInsets.symmetric(vertical: w * .04),
// //                 child: Container(
// //                   width: w,
// //                   // height: w * 0.36,
// //                   decoration: BoxDecoration(
// //                     color: AppColors.white,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.grey.withOpacity(0.2),
// //                         spreadRadius: 2,
// //                         blurRadius: 3,
// //                         // changes position of shadow
// //                       ),
// //                     ],
// //                     borderRadius: BorderRadius.circular(w * 0.03),
// //                   ),
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(vertical: w * .04),
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: w * .04,
// //                             // vertical: w * .04,
// //                           ),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.start,
// //                             crossAxisAlignment: CrossAxisAlignment.center,
// //                             children: [
// //                               CustomImages.images(
// //                                 "assets/icons/addBank1.png",
// //                                 w * .05,
// //                                 w * .05,
// //                               ),
// //                               SizedBox(width: w * .02),
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "Bank Details",
// //                                 w * 0.04,
// //                                 FontWeight.w400,
// //                                 AppColors.black,
// //                                 TextAlign.left,
// //                                 TextOverflow.ellipsis,
// //                               ),
// //                               Spacer(),
// //                               InkWell(
// //                                 splashColor: AppColors.mediumGray,
// //                                 onTap: () {
// //                                   CustomNavigator.push(
// //                                     context,
// //                                     AddBank(),
// //                                     transition: TransitionType.slideLeft,
// //                                   );
// //                                 },
// //                                 child: AppFonts.textPoppins(
// //                                   context,
// //                                   "ADD NEW",
// //                                   w * 0.035,
// //                                   FontWeight.w500,
// //                                   ColorsList.linksTextColor,
// //                                   TextAlign.left,
// //                                   TextOverflow.ellipsis,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         SizedBox(height: w * .02),
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: w * .07),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "Ayaan Malviya",
// //                                 w * 0.032,
// //                                 FontWeight.w500,
// //                                 AppColors.black,
// //                                 TextAlign.left,
// //                                 TextOverflow.ellipsis,
// //                               ),
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "IFSC: PUNBXXXXXXX",
// //                                 w * 0.032,
// //                                 FontWeight.w500,
// //                                 AppColors.black,
// //                                 TextAlign.left,
// //                                 TextOverflow.ellipsis,
// //                               ),
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "0990 0000 7641",
// //                                 w * 0.032,
// //                                 FontWeight.w500,
// //                                 AppColors.black,
// //                                 TextAlign.left,
// //                                 TextOverflow.ellipsis,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
              
              
// //               // upi details
// //               Container(
// //                 width: w,
// //                 //  height: w * 0.36,
// //                 decoration: BoxDecoration(
// //                   color: AppColors.white,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.2),
// //                       spreadRadius: 2,
// //                       blurRadius: 3,
// //                       // changes position of shadow
// //                     ),
// //                   ],
// //                   borderRadius: BorderRadius.circular(w * 0.03),
// //                 ),
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(vertical: w * .04),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Padding(
// //                         padding: EdgeInsets.symmetric(
// //                           horizontal: w * .04,
// //                           //  vertical: w * .04,
// //                         ),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.start,
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           children: [
// //                             CustomImages.images(
// //                               "assets/icons/addUpi1.png",
// //                               w * .05,
// //                               w * .05,
// //                             ),
// //                             SizedBox(width: w * .02),
// //                             AppFonts.textPoppins(
// //                               context,
// //                               "UPI Details",
// //                               w * 0.04,
// //                               FontWeight.w400,
// //                               AppColors.black,
// //                               TextAlign.left,
// //                               TextOverflow.ellipsis,
// //                             ),
// //                             Spacer(),
// //                             InkWell(
// //                               onTap: () {
// //                                 CustomNavigator.push(
// //                                   context,
// //                                   AddUpi(),
// //                                   transition: TransitionType.slideLeft,
// //                                 );
// //                               },
// //                               child: AppFonts.textPoppins(
// //                                 context,
// //                                 "ADD NEW",
// //                                 w * 0.035,
// //                                 FontWeight.w500,
// //                                 ColorsList.linksTextColor,
// //                                 TextAlign.left,
// //                                 TextOverflow.ellipsis,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(height: w * .02),
// //                       Padding(
// //                         padding: EdgeInsets.symmetric(horizontal: w * .07),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             AppFonts.textPoppins(
// //                               context,
// //                               "Ayaan Malviya",
// //                               w * 0.032,
// //                               FontWeight.w500,
// //                               AppColors.black,
// //                               TextAlign.left,
// //                               TextOverflow.ellipsis,
// //                             ),
// //                             AppFonts.textPoppins(
// //                               context,
// //                               "872000416@paytm",
// //                               w * 0.032,
// //                               FontWeight.w500,
// //                               AppColors.black,
// //                               TextAlign.left,
// //                               TextOverflow.ellipsis,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: w * .3),
// //               AppButtons.solid(
// //                 context: context,
// //                 text: "Transfer",
// //                 onClicked: () {
// //                   // CustomNavigator.push(
// //                   //   context,
// //                   //   MoneyTransferScreen(),
// //                   //   transition: TransitionType.fade,
// //                   // );
// //                 },
// //                 isFullWidth: true,
// //                 backgroundColor: AppColors.primaryRed,
// //                 textColor: AppColors.white,
// //                 fontSize: w * .045,
// //                 height: w * .140,
// //                 radius: 12.0,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:corezap_driver/controller/profilecontoller/get_bank_accounts_controller.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/add_bank.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/add_upi.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';

// class MoneyTransferScreen extends StatefulWidget {
//   const MoneyTransferScreen({super.key});

//   @override
//   State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
// }

// class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
//   // final GetBankAccountsController getBankAccountsController = Get.find<GetBankAccountsController>();


//   final GetBankAccountsController getBankAccountsController = Get.put(GetBankAccountsController());
//   @override
//   void initState() {
//     super.initState();
//     // Fetch bank details on init
//     getBankAccountsController.bankdetails_mdethod();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: ColorsList.scaffoldColor,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: ColorsList.scaffoldColor,
//         automaticallyImplyLeading: false,
//         scrolledUnderElevation: 0,
//         elevation: 0,
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
//             SizedBox(width: w * .035),
//             CustomText(
//               text: "Money Transfer",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() {
//         if (getBankAccountsController.isLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: AppColors.primaryRed,
//             ),
//           );
//         }

//         if (getBankAccountsController.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: w * 0.15,
//                 ),
//                 SizedBox(height: w * 0.03),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * 0.05),
//                   child: AppFonts.textPoppins(
//                     context,
//                     getBankAccountsController.errorMessage.value,
//                     w * 0.04,
//                     FontWeight.w500,
//                     AppColors.black,
//                     TextAlign.center,
//                     TextOverflow.visible,
//                   ),
//                 ),
//                 SizedBox(height: w * 0.05),
//                 AppButtons.solid(
//                   context: context,
//                   text: "Retry",
//                   onClicked: () {
//                     getBankAccountsController.bankdetails_mdethod();
//                   },
//                   backgroundColor: AppColors.primaryRed,
//                   textColor: AppColors.white,
//                   fontSize: w * .04,
//                   height: w * .12,
//                   radius: 12.0,
//                   width: w * 0.4,
//                 ),
//               ],
//             ),
//           );
//         }

//         final bankAccounts = getBankAccountsController.driveridresponse.value?.data;
//         final hasBankAccounts = bankAccounts != null && bankAccounts.isNotEmpty;

//         return ListView(
//           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
//           children: [
//             // Total Amount Card
//             Container(
//               width: w,
//               height: w * 0.40,
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 3,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(w * 0.03),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(left: w * 0.04),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.currency_rupee,
//                           color: AppColors.green,
//                           size: w * .063,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         AppFonts.textPoppins(
//                           context,
//                           "100.0",
//                           w * 0.08,
//                           FontWeight.bold,
//                           AppColors.green,
//                           TextAlign.center,
//                           TextOverflow.visible,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     AppFonts.textPoppins(
//                       context,
//                       "Total amount to be transferred",
//                       w * 0.03,
//                       FontWeight.w500,
//                       AppColors.black,
//                       TextAlign.center,
//                       TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ).animate()
//                 .fade(duration: 820.ms, curve: Curves.easeInOut)
//                 .scale(
//                   begin: const Offset(0.95, 0.95),
//                   end: const Offset(1, 1),
//                 ),

//             Padding(
//               padding: EdgeInsets.only(top: w * .03, bottom: w * .1),
//               child: AppFonts.textPoppins(
//                 context,
//                 "A service fee of 10% is deducted from each completed ride to cover platform charges.",
//                 w * 0.032,
//                 FontWeight.w500,
//                 AppColors.mediumGray,
//                 TextAlign.left,
//                 TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//             ),

//             AppFonts.textPoppins(
//               context,
//               "Deposit to",
//               w * 0.043,
//               FontWeight.w600,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),

//             SizedBox(height: w * .02),

//             // Bank Details Section
//             Container(
//               width: w,
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 3,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(w * 0.03),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: w * .04),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header with Add New button
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * .04),
//                       child: Row(
//                         children: [
//                           CustomImages.images(
//                             "assets/icons/addBank1.png",
//                             w * .05,
//                             w * .05,
//                           ),
//                           SizedBox(width: w * .02),
//                           AppFonts.textPoppins(
//                             context,
//                             "Bank Details",
//                             w * 0.04,
//                             FontWeight.w400,
//                             AppColors.black,
//                             TextAlign.left,
//                             TextOverflow.ellipsis,
//                           ),
//                           Spacer(),
//                           InkWell(
//                             splashColor: AppColors.mediumGray,
//                             onTap: () {
//                               CustomNavigator.push(
//                                 context,
//                                 AddBank(),
//                                 transition: TransitionType.slideLeft,
//                               );
//                             },
//                             child: AppFonts.textPoppins(
//                               context,
//                               "ADD NEW",
//                               w * 0.035,
//                               FontWeight.w500,
//                               ColorsList.linksTextColor,
//                               TextAlign.left,
//                               TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: w * .02),

//                     // Bank Accounts List
//                     if (!hasBankAccounts)
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: w * .07,
//                           vertical: w * .02,
//                         ),
//                         child: AppFonts.textPoppins(
//                           context,
//                           "No bank accounts added yet. Add your first bank account.",
//                           w * 0.032,
//                           FontWeight.w400,
//                           AppColors.mediumGray,
//                           TextAlign.left,
//                           TextOverflow.ellipsis,
//                         ),
//                       )
//                     else
//                       ListView.separated(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: bankAccounts!.length,
//                         separatorBuilder: (context, index) => Divider(
//                           color: AppColors.lightGray,
//                           height: w * 0.04,
//                           indent: w * 0.07,
//                           endIndent: w * 0.04,
//                         ),
//                         itemBuilder: (context, index) {
//                           final account = bankAccounts[index];
//                           return Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: w * .07,
//                               vertical: w * .01,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Account Holder Name
//                                 AppFonts.textPoppins(
//                                   context,
//                                   account.accountHolderName ?? "N/A",
//                                   w * 0.032,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * 0.005),
//                                 // Bank Name
//                                 AppFonts.textPoppins(
//                                   context,
//                                   account.bankName ?? "N/A",
//                                   w * 0.030,
//                                   FontWeight.w400,
//                                   AppColors.darkGray,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * 0.005),
//                                 // IFSC Code
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "IFSC: ${account.ifscCode ?? "N/A"}",
//                                   w * 0.030,
//                                   FontWeight.w400,
//                                   AppColors.darkGray,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * 0.005),
//                                 // Account Number (masked for security)
//                                 AppFonts.textPoppins(
//                                   context,
//                                   _maskAccountNumber(account.accountNumber),
//                                   w * 0.030,
//                                   FontWeight.w400,
//                                   AppColors.darkGray,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: w * .04),

//             // UPI Details Section (optional - you can add similar logic for UPI)
//             Container(
//               width: w,
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 3,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(w * 0.03),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: w * .04),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * .04),
//                       child: Row(
//                         children: [
//                           CustomImages.images(
//                             "assets/icons/addUpi1.png",
//                             w * .05,
//                             w * .05,
//                           ),
//                           SizedBox(width: w * .02),
//                           AppFonts.textPoppins(
//                             context,
//                             "UPI Details",
//                             w * 0.04,
//                             FontWeight.w400,
//                             AppColors.black,
//                             TextAlign.left,
//                             TextOverflow.ellipsis,
//                           ),
//                           Spacer(),
//                           InkWell(
//                             onTap: () {
//                               CustomNavigator.push(
//                                 context,
//                                 AddUpi(),
//                                 transition: TransitionType.slideLeft,
//                               );
//                             },
//                             child: AppFonts.textPoppins(
//                               context,
//                               "ADD NEW",
//                               w * 0.035,
//                               FontWeight.w500,
//                               ColorsList.linksTextColor,
//                               TextAlign.left,
//                               TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: w * .02),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * .07),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppFonts.textPoppins(
//                             context,
//                             "No UPI details added",
//                             w * 0.032,
//                             FontWeight.w400,
//                             AppColors.mediumGray,
//                             TextAlign.left,
//                             TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: w * 0.005),
//                           AppFonts.textPoppins(
//                             context,
//                             "Add your UPI ID for quick transfers",
//                             w * 0.030,
//                             FontWeight.w400,
//                             AppColors.mediumGray,
//                             TextAlign.left,
//                             TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: w * .1),

//             // Transfer Button
//             AppButtons.solid(
//               context: context,
//               text: "Transfer",
//               onClicked: () {
//                 if (!hasBankAccounts) {
//                   Get.snackbar(
//                     'No Bank Account',
//                     'Please add a bank account first',
//                     snackPosition: SnackPosition.BOTTOM,
//                     backgroundColor: Colors.red,
//                     colorText: Colors.white,
//                   );
//                   return;
//                 }
//                 // Add your transfer logic here
//                 // You might want to add a selection mechanism first
//               },
//               isFullWidth: true,
//               backgroundColor: AppColors.primaryRed,
//               textColor: AppColors.white,
//               fontSize: w * .045,
//               height: w * .140,
//               radius: 12.0,
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   String _maskAccountNumber(String? accountNumber) {
//     if (accountNumber == null || accountNumber.isEmpty) return "N/A";
    
//     if (accountNumber.length <= 4) {
//       return accountNumber;
//     }
    
//     final maskedPart = '*' * (accountNumber.length - 4);
//     final lastFour = accountNumber.substring(accountNumber.length - 4);
//     return "$maskedPart$lastFour";
//   }
// }


import 'package:corezap_driver/controller/profilecontoller/get_bank_accounts_controller.dart';
import 'package:corezap_driver/controller/profilecontoller/payments_withdraw_controller.dart';
import 'package:corezap_driver/modals/get_bank_accounts_response.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/add_bank.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/add_upi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class MoneyTransferScreen extends StatefulWidget {
  const MoneyTransferScreen({super.key});

  @override
  State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  // final GetBankAccountsController getBankAccountsController = Get.find<GetBankAccountsController>();

    final GetBankAccountsController getBankAccountsController = Get.put(
    GetBankAccountsController(),
  );

   final PaymentsWithdrawController paymentsWithdrawController = Get.put(
    PaymentsWithdrawController(),
  );

  
  
  // Store selected bank account ID
  String? selectedBankAccountId;

  @override
  void initState() {
    super.initState();
    // Fetch bank details on init
    getBankAccountsController.bankdetails_mdethod();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
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
            SizedBox(width: w * .035),
            CustomText(
              text: "Money Transfer",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (getBankAccountsController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryRed,
            ),
          );
        }

        if (getBankAccountsController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: w * 0.15,
                ),
                SizedBox(height: w * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: AppFonts.textPoppins(
                    context,
                    getBankAccountsController.errorMessage.value,
                    w * 0.04,
                    FontWeight.w500,
                    AppColors.black,
                    TextAlign.center,
                    TextOverflow.visible,
                  ),
                ),
                SizedBox(height: w * 0.05),
                AppButtons.solid(
                  context: context,
                  text: "Retry",
                  onClicked: () {
                    getBankAccountsController.bankdetails_mdethod();
                  },
                  backgroundColor: AppColors.primaryRed,
                  textColor: AppColors.white,
                  fontSize: w * .04,
                  height: w * .12,
                  radius: 12.0,
                  width: w * 0.4,
                ),
              ],
            ),
          );
        }

        final bankAccounts = getBankAccountsController.driveridresponse.value?.data;
        final hasBankAccounts = bankAccounts != null && bankAccounts.isNotEmpty;

        // Auto-select first bank account if none is selected
        if (hasBankAccounts && selectedBankAccountId == null && bankAccounts.isNotEmpty) {
          selectedBankAccountId = bankAccounts.first.id;
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
          children: [
            // Total Amount Card
            Container(
              width: w,
              height: w * 0.40,
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
              child: Padding(
                padding: EdgeInsets.only(left: w * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_rupee,
                          color: AppColors.green,
                          size: w * .063,
                          fontWeight: FontWeight.bold,
                        ),
                        AppFonts.textPoppins(
                          context,
                          "100.0",
                          w * 0.08,
                          FontWeight.bold,
                          AppColors.green,
                          TextAlign.center,
                          TextOverflow.visible,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    AppFonts.textPoppins(
                      context,
                      "Total amount to be transferred",
                      w * 0.03,
                      FontWeight.w500,
                      AppColors.black,
                      TextAlign.center,
                      TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ).animate()
                .fade(duration: 820.ms, curve: Curves.easeInOut)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),

            Padding(
              padding: EdgeInsets.only(top: w * .03, bottom: w * .1),
              child: AppFonts.textPoppins(
                context,
                "A service fee of 10% is deducted from each completed ride to cover platform charges.",
                w * 0.032,
                FontWeight.w500,
                AppColors.mediumGray,
                TextAlign.left,
                TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),

            AppFonts.textPoppins(
              context,
              "Deposit to",
              w * 0.043,
              FontWeight.w600,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),

            SizedBox(height: w * .02),

            // Bank Details Section
            Container(
              width: w,
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: w * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Add New button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * .04),
                      child: Row(
                        children: [
                          CustomImages.images(
                            "assets/icons/addBank1.png",
                            w * .05,
                            w * .05,
                          ),
                          SizedBox(width: w * .02),
                          AppFonts.textPoppins(
                            context,
                            "Bank Details",
                            w * 0.04,
                            FontWeight.w400,
                            AppColors.black,
                            TextAlign.left,
                            TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          InkWell(
                            splashColor: AppColors.mediumGray,
                            onTap: () {
                              // CustomNavigator.push(
                              //   context,
                              //   AddBank(),
                              //   transition: TransitionType.slideLeft,
                              // ).then((value) {
                              //   // Refresh bank accounts when returning from AddBank
                              //   if (value == true) {
                              //     getBankAccountsController.bankdetails_mdethod();
                              //     selectedBankAccountId = null; // Reset selection
                              //   }
                              // });
                            },
                            child: AppFonts.textPoppins(
                              context,
                              "ADD NEW",
                              w * 0.035,
                              FontWeight.w500,
                              ColorsList.linksTextColor,
                              TextAlign.left,
                              TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: w * .02),

                    // Bank Accounts List with Selection
                    if (!hasBankAccounts)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * .07,
                          vertical: w * .02,
                        ),
                        child: AppFonts.textPoppins(
                          context,
                          "No bank accounts added yet. Add your first bank account.",
                          w * 0.032,
                          FontWeight.w400,
                          AppColors.mediumGray,
                          TextAlign.left,
                          TextOverflow.ellipsis,
                        ),
                      )
                    else
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: bankAccounts!.length,
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.lightGray,
                          height: w * 0.04,
                          indent: w * 0.07,
                          endIndent: w * 0.04,
                        ),
                        itemBuilder: (context, index) {
                          final account = bankAccounts[index];
                          final isSelected = selectedBankAccountId == account.id;
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedBankAccountId = account.id;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * .07,
                                vertical: w * .01,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Radio button for selection
                                  Container(
                                    width: w * 0.06,
                                    height: w * 0.06,
                                    margin: EdgeInsets.only(top: w * 0.01),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected 
                                            ? AppColors.primaryRed 
                                            : AppColors.mediumGray,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: w * 0.03,
                                              height: w * 0.03,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryRed,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  
                                  SizedBox(width: w * 0.03),
                                  
                                  // Bank Account Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Account Holder Name
                                        Row(
                                          children: [
                                            AppFonts.textPoppins(
                                              context,
                                              account.accountHolderName ?? "N/A",
                                              w * 0.032,
                                              FontWeight.w500,
                                              isSelected 
                                                  ? AppColors.primaryRed 
                                                  : AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            if (isSelected)
                                              SizedBox(width: w * 0.02),
                                            if (isSelected)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: w * 0.02,
                                                  vertical: w * 0.005,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryRed.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: AppFonts.textPoppins(
                                                  context,
                                                  "Selected",
                                                  w * 0.025,
                                                  FontWeight.w500,
                                                  AppColors.primaryRed,
                                                  TextAlign.center,
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: w * 0.005),
                                        // Bank Name
                                        AppFonts.textPoppins(
                                          context,
                                          account.bankName ?? "N/A",
                                          w * 0.030,
                                          FontWeight.w400,
                                          AppColors.darkGray,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * 0.005),
                                        // IFSC Code
                                        AppFonts.textPoppins(
                                          context,
                                          "IFSC: ${account.ifscCode ?? "N/A"}",
                                          w * 0.030,
                                          FontWeight.w400,
                                          AppColors.darkGray,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * 0.005),
                                        // Account Number (masked for security)
                                        AppFonts.textPoppins(
                                          context,
                                          _maskAccountNumber(account.accountNumber),
                                          w * 0.030,
                                          FontWeight.w400,
                                          AppColors.darkGray,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: w * .04),

            // UPI Details Section
            Container(
              width: w,
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: w * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * .04),
                      child: Row(
                        children: [
                          CustomImages.images(
                            "assets/icons/addUpi1.png",
                            w * .05,
                            w * .05,
                          ),
                          SizedBox(width: w * .02),
                          AppFonts.textPoppins(
                            context,
                            "UPI Details",
                            w * 0.04,
                            FontWeight.w400,
                            AppColors.black,
                            TextAlign.left,
                            TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              CustomNavigator.push(
                                context,
                                AddUpi(),
                                transition: TransitionType.slideLeft,
                              );
                            },
                            child: AppFonts.textPoppins(
                              context,
                              "ADD NEW",
                              w * 0.035,
                              FontWeight.w500,
                              ColorsList.linksTextColor,
                              TextAlign.left,
                              TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: w * .02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * .07),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppFonts.textPoppins(
                            context,
                            "No UPI details added",
                            w * 0.032,
                            FontWeight.w400,
                            AppColors.mediumGray,
                            TextAlign.left,
                            TextOverflow.ellipsis,
                          ),
                          SizedBox(height: w * 0.005),
                          AppFonts.textPoppins(
                            context,
                            "Add your UPI ID for quick transfers",
                            w * 0.030,
                            FontWeight.w400,
                            AppColors.mediumGray,
                            TextAlign.left,
                            TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: w * .1),

            // Selected Account Information (for debugging/confirmation)
            if (selectedBankAccountId != null && hasBankAccounts)
              Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(w * 0.02),
                  border: Border.all(
                    color: AppColors.primaryRed.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFonts.textPoppins(
                      context,
                      "Selected Account:",
                      w * 0.030,
                      FontWeight.w600,
                      AppColors.primaryRed,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                    SizedBox(height: w * 0.01),
                    AppFonts.textPoppins(
                      context,
                      "ID: $selectedBankAccountId",
                      w * 0.028,
                      FontWeight.w500,
                      AppColors.darkGray,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                    SizedBox(height: w * 0.005),
                    AppFonts.textPoppins(
                      context,
                      "Account: ${_getSelectedAccountDetails(bankAccounts!)}",
                      w * 0.028,
                      FontWeight.w500,
                      AppColors.darkGray,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            SizedBox(height: w * .04),

            // Transfer Button
            AppButtons.solid(
              context: context,
              text: "Transfer",
              onClicked: () {
                if (!hasBankAccounts) {
                  Get.snackbar(
                    'No Bank Account',
                    'Please add a bank account first',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (selectedBankAccountId == null) {
                  Get.snackbar(
                    'No Account Selected',
                    'Please select a bank account to transfer to',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Get the selected bank account details
                final selectedAccount = bankAccounts!.firstWhere(
                  (account) => account.id == selectedBankAccountId,
                  orElse: () => bankAccounts.first,
                );

                // Print selected details
                print("=== Selected Bank Account Details ===");

                   print("Account ID: ${selectedBankAccountId}");
                print("Account ID: $selectedBankAccountId");
                print("Account Holder: ${selectedAccount.accountHolderName}");
                print("Bank Name: ${selectedAccount.bankName}");
                print("Account Number: ${selectedAccount.accountNumber}");
                print("IFSC Code: ${selectedAccount.ifscCode}");
                print("Account Holder Name: ${selectedAccount.accountHolderName}");
                print("================================");

                // Show confirmation dialog
                _showTransferConfirmationDialog(context, w, selectedAccount);
              },
              isFullWidth: true,
              backgroundColor: AppColors.primaryRed,
              textColor: AppColors.white,
              fontSize: w * .045,
              height: w * .140,
              radius: 12.0,
            ),
          ],
        );
      }),
    );
  }

  String _maskAccountNumber(String? accountNumber) {
    if (accountNumber == null || accountNumber.isEmpty) return "N/A";
    
    if (accountNumber.length <= 4) {
      return accountNumber;
    }
    
    final maskedPart = '*' * (accountNumber.length - 4);
    final lastFour = accountNumber.substring(accountNumber.length - 4);
    return "$maskedPart$lastFour";
  }

  String _getSelectedAccountDetails(List<BankAccount> accounts) {
    if (selectedBankAccountId == null) return "None";
    
    final selectedAccount = accounts.firstWhere(
      (account) => account.id == selectedBankAccountId,
      orElse: () => accounts.first,
    );
    
    return "${selectedAccount.accountHolderName} - ${selectedAccount.bankName} (***${selectedAccount.accountNumber?.substring(selectedAccount.accountNumber!.length - 4)})";
  }

  void _showTransferConfirmationDialog(
    BuildContext context,
    double w,
    BankAccount selectedAccount,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.account_balance,
              color: AppColors.primaryRed,
            ),
            SizedBox(width: w * 0.02),
            AppFonts.textPoppins(
              context,
              "Confirm Transfer",
              w * 0.04,
              FontWeight.w600,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppFonts.textPoppins(
              context,
              "Are you sure you want to transfer ₹100.0 to:",
              w * 0.032,
              FontWeight.w500,
              AppColors.darkGray,
              TextAlign.left,
              TextOverflow.visible,
            ),
            SizedBox(height: w * 0.02),
            Container(
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: AppColors.lightGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(w * 0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppFonts.textPoppins(
                    context,
                    selectedAccount.accountHolderName ?? "N/A",
                    w * 0.034,
                    FontWeight.w600,
                    AppColors.black,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * 0.005),
                  AppFonts.textPoppins(
                    context,
                    "${selectedAccount.bankName}",
                    w * 0.030,
                    FontWeight.w500,
                    AppColors.darkGray,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * 0.005),
                  AppFonts.textPoppins(
                    context,
                    "Account: ${_maskAccountNumber(selectedAccount.accountNumber)}",
                    w * 0.030,
                    FontWeight.w500,
                    AppColors.darkGray,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * 0.005),
                  AppFonts.textPoppins(
                    context,
                    "IFSC: ${selectedAccount.ifscCode}",
                    w * 0.030,
                    FontWeight.w500,
                    AppColors.darkGray,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: w * 0.02),
            AppFonts.textPoppins(
              context,
              "Note: This action cannot be undone.",
              w * 0.028,
              FontWeight.w400,
              AppColors.mediumGray,
              TextAlign.left,
              TextOverflow.visible,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppFonts.textPoppins(
              context,
              "Cancel",
              w * 0.035,
              FontWeight.w500,
              AppColors.darkGray,
              TextAlign.center,
              TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Call your transfer API here
              _processTransfer(selectedAccount);

              print("my_data_i_selected ${selectedAccount}");

              
              // paymentsWithdrawController.withdrawal_method(BankAccountId: "" ,amount: "10" );
            },
            child: AppFonts.textPoppins(
              context,
              "Confirm Transfer",
              w * 0.035,
              FontWeight.w500,
              AppColors.white,
              TextAlign.center,
              TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _processTransfer(BankAccount selectedAccount) {
    // TODO: Implement your transfer API call here
    print("Processing transfer to: ${selectedAccount.id}");
    
    // Show loading
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryRed,
        ),
      ),
      barrierDismissible: false,
    );
    
    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      Get.back(); // Remove loading dialog
      
      // Show success message
      Get.snackbar(
        'Transfer Successful',
        '₹100.0 has been transferred to ${selectedAccount.accountHolderName}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
      // You can navigate back or show success screen
      // CustomNavigator.pop(context);
    });
  }
}