// // import 'package:nzcu_driver/controllers/profile_controllers/get_bank_accounts_controller.dart';
// // import 'package:nzcu_driver/controllers/profile_controllers/payments_withdraw_controller.dart';
// // import 'package:nzcu_driver/modals/profile_modals/get_bank_accounts_response.dart';
// // import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// // import 'package:nzcu_driver/utilities/colors/colors.dart';
// // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// // import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// // import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// // import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// // import 'package:nzcu_driver/views/profile_screens/payment_related/add_bank.dart';
// // import 'package:nzcu_driver/views/profile_screens/payment_related/add_upi.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:get/get.dart';

// // class MoneyTransferScreen extends StatefulWidget {
// //   const MoneyTransferScreen({super.key});

// //   @override
// //   State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
// // }

// // class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
// //   final GetBankAccountsController getBankAccountsController = Get.put(
// //     GetBankAccountsController(),
// //   );

// //   final PaymentsWithdrawController paymentsWithdrawController = Get.put(
// //     PaymentsWithdrawController(),
// //   );

// //   // Store selected bank account or UPI ID
// //   String? selectedAccountId;
// //   String? selectedAccountType; // "BANK" or "UPI"

// //   // Amount controller
// //   final TextEditingController amountController = TextEditingController();
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       getBankAccountsController.bankdetails_mdethod();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     amountController.dispose();
// //     super.dispose();
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
// //       body: Obx(() {
// //         if (getBankAccountsController.isLoading.value) {
// //           return Center(
// //             child: CircularProgressIndicator(color: AppColors.primaryRed),
// //           );
// //         }

// //         if (getBankAccountsController.errorMessage.value.isNotEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 SizedBox(height: w * 0.03),
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: w * 0.05),
// //                   child: AppFonts.textPoppins(
// //                     context,
// //                     getBankAccountsController.errorMessage.value,
// //                     w * 0.04,
// //                     FontWeight.w500,
// //                     AppColors.black,
// //                     TextAlign.center,
// //                     TextOverflow.visible,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }

// //         final bankAccounts =
// //             getBankAccountsController.driveridresponse.value?.data ?? [];
// //         final hasBankAccounts = bankAccounts.isNotEmpty;

// //         return Form(
// //           key: _formKey,
// //           child: ListView(
// //             padding: EdgeInsets.symmetric(
// //               horizontal: w * .03,
// //               vertical: w * .04,
// //             ),
// //             children: [
// //               // Amount Input Field
// //               Container(
// //                     width: w,
// //                     padding: EdgeInsets.all(w * 0.04),
// //                     decoration: BoxDecoration(
// //                       color: AppColors.white,
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.grey.withOpacity(0.2),
// //                           spreadRadius: 2,
// //                           blurRadius: 3,
// //                         ),
// //                       ],
// //                       borderRadius: BorderRadius.circular(w * 0.03),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         AppFonts.textPoppins(
// //                           context,
// //                           "Enter Amount",
// //                           w * 0.04,
// //                           FontWeight.w600,
// //                           AppColors.black,
// //                           TextAlign.left,
// //                           TextOverflow.ellipsis,
// //                         ),
// //                         SizedBox(height: w * 0.02),
// //                         TextFormField(
// //                           controller: amountController,
// //                           keyboardType: TextInputType.number,
// //                           decoration: InputDecoration(
// //                             prefixIcon: Icon(
// //                               Icons.currency_rupee,
// //                               color: AppColors.primaryRed,
// //                               size: w * 0.05,
// //                             ),
// //                             hintText: "0.00",
// //                             hintStyle: TextStyle(
// //                               fontSize: w * 0.04,
// //                               color: AppColors.mediumGray,
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(w * 0.02),
// //                               borderSide: BorderSide(
// //                                 color: AppColors.lightGray,
// //                               ),
// //                             ),
// //                             enabledBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(w * 0.02),
// //                               borderSide: BorderSide(
// //                                 color: AppColors.lightGray,
// //                               ),
// //                             ),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(w * 0.02),
// //                               borderSide: BorderSide(
// //                                 color: AppColors.primaryRed,
// //                                 width: 2,
// //                               ),
// //                             ),
// //                           ),
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please enter an amount';
// //                             }
// //                             if (double.tryParse(value) == null) {
// //                               return 'Please enter a valid amount';
// //                             }
// //                             if (double.parse(value) <= 0) {
// //                               return 'Amount must be greater than 0';
// //                             }
// //                             return null;
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   )
// //                   .animate()
// //                   .fade(duration: 820.ms, curve: Curves.easeInOut)
// //                   .scale(
// //                     begin: const Offset(0.95, 0.95),
// //                     end: const Offset(1, 1),
// //                   ),

// //               SizedBox(height: w * 0.03),

// //               Padding(
// //                 padding: EdgeInsets.only(bottom: w * .02),
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
// //                 "Select Payment Method",
// //                 w * 0.043,
// //                 FontWeight.w600,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),

// //               SizedBox(height: w * .02),

// //               // Bank Details Section
// //               Container(
// //                 width: w,
// //                 decoration: BoxDecoration(
// //                   color: AppColors.white,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.2),
// //                       spreadRadius: 2,
// //                       blurRadius: 3,
// //                     ),
// //                   ],
// //                   borderRadius: BorderRadius.circular(w * 0.03),
// //                 ),
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(vertical: w * .04),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Header with Add New button
// //                       Padding(
// //                         padding: EdgeInsets.symmetric(horizontal: w * .04),
// //                         child: Row(
// //                           children: [
// //                             CustomImages.images(
// //                               "assets/icons/addBank1.png",
// //                               w * .05,
// //                               w * .05,
// //                             ),
// //                             SizedBox(width: w * .02),
// //                             AppFonts.textPoppins(
// //                               context,
// //                               "Bank Details",
// //                               w * 0.04,
// //                               FontWeight.w400,
// //                               AppColors.black,
// //                               TextAlign.left,
// //                               TextOverflow.ellipsis,
// //                             ),
// //                             Spacer(),
// //                             InkWell(
// //                               splashColor: AppColors.mediumGray,
// //                               onTap: () {
// //                                 Get.to(() => AddBank());
// //                                 // Uncomment when AddBank screen is ready
// //                                 // CustomNavigator.push(
// //                                 //   context,
// //                                 //   AddBank(),
// //                                 //   transition: TransitionType.slideLeft,
// //                                 // ).then((value) {
// //                                 //   if (value == true) {
// //                                 //     getBankAccountsController.bankdetails_mdethod();
// //                                 //     setState(() {
// //                                 //       selectedAccountId = null;
// //                                 //       selectedAccountType = null;
// //                                 //     });
// //                                 //   }
// //                                 // });
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

// //                       // Bank Accounts List with Selection
// //                       if (bankAccounts.where((a) => a.type == "BANK").isEmpty)
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: w * .07,
// //                             vertical: w * .02,
// //                           ),
// //                           child: AppFonts.textPoppins(
// //                             context,
// //                             "No bank accounts added yet.",
// //                             w * 0.032,
// //                             FontWeight.w400,
// //                             AppColors.mediumGray,
// //                             TextAlign.left,
// //                             TextOverflow.ellipsis,
// //                           ),
// //                         )
// //                       else
// //                         ListView.separated(
// //                           physics: NeverScrollableScrollPhysics(),
// //                           shrinkWrap: true,
// //                           itemCount: bankAccounts
// //                               .where((a) => a.type == "BANK")
// //                               .length,
// //                           separatorBuilder: (context, index) => Divider(
// //                             color: AppColors.lightGray,
// //                             height: w * 0.04,
// //                             indent: w * 0.07,
// //                             endIndent: w * 0.04,
// //                           ),
// //                           itemBuilder: (context, index) {
// //                             final bankAccountsList = bankAccounts
// //                                 .where((a) => a.type == "BANK")
// //                                 .toList();
// //                             final account = bankAccountsList[index];
// //                             final isSelected =
// //                                 selectedAccountId == account.id &&
// //                                 selectedAccountType == "BANK";

// //                             return GestureDetector(
// //                               onTap: () {
// //                                 setState(() {
// //                                   if (isSelected) {
// //                                     // Deselect if already selected
// //                                     selectedAccountId = null;
// //                                     selectedAccountType = null;
// //                                   } else {
// //                                     // Select this bank account and deselect any UPI
// //                                     selectedAccountId = account.id;
// //                                     selectedAccountType = "BANK";
// //                                   }
// //                                 });
// //                               },
// //                               child: Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: w * .07,
// //                                   vertical: w * .01,
// //                                 ),
// //                                 child: Row(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     // Radio button for selection
// //                                     Container(
// //                                       width: w * 0.06,
// //                                       height: w * 0.06,
// //                                       margin: EdgeInsets.only(top: w * 0.01),
// //                                       decoration: BoxDecoration(
// //                                         shape: BoxShape.circle,
// //                                         border: Border.all(
// //                                           color: isSelected
// //                                               ? AppColors.primaryRed
// //                                               : AppColors.mediumGray,
// //                                           width: 2,
// //                                         ),
// //                                       ),
// //                                       child: isSelected
// //                                           ? Center(
// //                                               child: Container(
// //                                                 width: w * 0.03,
// //                                                 height: w * 0.03,
// //                                                 decoration: BoxDecoration(
// //                                                   shape: BoxShape.circle,
// //                                                   color: AppColors.primaryRed,
// //                                                 ),
// //                                               ),
// //                                             )
// //                                           : null,
// //                                     ),

// //                                     SizedBox(width: w * 0.03),

// //                                     // Bank Account Details
// //                                     Expanded(
// //                                       child: Column(
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.start,
// //                                         children: [
// //                                           // Account Holder Name
// //                                           Row(
// //                                             children: [
// //                                               AppFonts.textPoppins(
// //                                                 context,
// //                                                 account.accountHolderName ??
// //                                                     "N/A",
// //                                                 w * 0.032,
// //                                                 FontWeight.w500,
// //                                                 isSelected
// //                                                     ? AppColors.primaryRed
// //                                                     : AppColors.black,
// //                                                 TextAlign.left,
// //                                                 TextOverflow.ellipsis,
// //                                               ),
// //                                               if (isSelected)
// //                                                 SizedBox(width: w * 0.02),
// //                                               if (isSelected)
// //                                                 Container(
// //                                                   padding: EdgeInsets.symmetric(
// //                                                     horizontal: w * 0.02,
// //                                                     vertical: w * 0.005,
// //                                                   ),
// //                                                   decoration: BoxDecoration(
// //                                                     color: AppColors.primaryRed
// //                                                         .withOpacity(0.1),
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                           4,
// //                                                         ),
// //                                                   ),
// //                                                   child: AppFonts.textPoppins(
// //                                                     context,
// //                                                     "Selected",
// //                                                     w * 0.025,
// //                                                     FontWeight.w500,
// //                                                     AppColors.primaryRed,
// //                                                     TextAlign.center,
// //                                                     TextOverflow.ellipsis,
// //                                                   ),
// //                                                 ),
// //                                             ],
// //                                           ),
// //                                           SizedBox(height: w * 0.005),
// //                                           // Bank Name
// //                                           AppFonts.textPoppins(
// //                                             context,
// //                                             account.bankName ?? "N/A",
// //                                             w * 0.030,
// //                                             FontWeight.w400,
// //                                             AppColors.darkGray,
// //                                             TextAlign.left,
// //                                             TextOverflow.ellipsis,
// //                                           ),
// //                                           SizedBox(height: w * 0.005),
// //                                           // IFSC Code
// //                                           AppFonts.textPoppins(
// //                                             context,
// //                                             "IFSC: ${account.ifscCode ?? "N/A"}",
// //                                             w * 0.030,
// //                                             FontWeight.w400,
// //                                             AppColors.darkGray,
// //                                             TextAlign.left,
// //                                             TextOverflow.ellipsis,
// //                                           ),
// //                                           SizedBox(height: w * 0.005),
// //                                           // Account Number (masked for security)
// //                                           AppFonts.textPoppins(
// //                                             context,
// //                                             _maskAccountNumber(
// //                                               account.accountNumber,
// //                                             ),
// //                                             w * 0.030,
// //                                             FontWeight.w400,
// //                                             AppColors.darkGray,
// //                                             TextAlign.left,
// //                                             TextOverflow.ellipsis,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               SizedBox(height: w * .04),

// //               // UPI Details Section
// //               Container(
// //                 width: w,
// //                 decoration: BoxDecoration(
// //                   color: AppColors.white,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.2),
// //                       spreadRadius: 2,
// //                       blurRadius: 3,
// //                     ),
// //                   ],
// //                   borderRadius: BorderRadius.circular(w * 0.03),
// //                 ),
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(vertical: w * .04),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,

// //                     children: [
// //                       Padding(
// //                         padding: EdgeInsets.symmetric(horizontal: w * .04),
// //                         child: Row(
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
// //                                 Get.to(AddUpi());
// //                                 // CustomNavigator.push(
// //                                 //   context,
// //                                 //   AddUpi(),
// //                                 //   transition: TransitionType.slideLeft,
// //                                 // ).then((value) {
// //                                 //   if (value == true) {
// //                                 //     getBankAccountsController.bankdetails_mdethod();
// //                                 //     setState(() {
// //                                 //       selectedAccountId = null;
// //                                 //       selectedAccountType = null;
// //                                 //     });
// //                                 //   }
// //                                 // });
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
// //                       if (bankAccounts.where((a) => a.type == "UPI").isEmpty)
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: w * .07),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "No UPI details added",
// //                                 w * 0.032,
// //                                 FontWeight.w400,
// //                                 AppColors.mediumGray,
// //                                 TextAlign.left,
// //                                 TextOverflow.ellipsis,
// //                               ),
// //                               SizedBox(height: w * 0.005),
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "Add your UPI ID for quick transfers",
// //                                 w * 0.030,
// //                                 FontWeight.w400,
// //                                 AppColors.mediumGray,
// //                                 TextAlign.left,
// //                                 TextOverflow.ellipsis,
// //                               ),
// //                             ],
// //                           ),
// //                         )
// //                       else
// //                         ListView.separated(
// //                           physics: NeverScrollableScrollPhysics(),
// //                           shrinkWrap: true,
// //                           itemCount: bankAccounts
// //                               .where((a) => a.type == "UPI")
// //                               .length,
// //                           separatorBuilder: (context, index) => Divider(
// //                             color: AppColors.lightGray,
// //                             height: w * 0.04,
// //                             indent: w * 0.07,
// //                             endIndent: w * 0.04,
// //                           ),
// //                           itemBuilder: (context, index) {
// //                             final upiAccounts = bankAccounts
// //                                 .where((a) => a.type == "UPI")
// //                                 .toList();
// //                             final account = upiAccounts[index];
// //                             final isSelected =
// //                                 selectedAccountId == account.id &&
// //                                 selectedAccountType == "UPI";

// //                             return GestureDetector(
// //                               onTap: () {
// //                                 setState(() {
// //                                   if (isSelected) {
// //                                     // Deselect if already selected
// //                                     selectedAccountId = null;
// //                                     selectedAccountType = null;
// //                                   } else {
// //                                     // Select this UPI and deselect any bank account
// //                                     selectedAccountId = account.id;
// //                                     selectedAccountType = "UPI";
// //                                   }
// //                                 });
// //                               },
// //                               child: Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: w * .07,
// //                                   vertical: w * .01,
// //                                 ),
// //                                 child: Row(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Transform.translate(
// //                                       offset: Offset(
// //                                         0,
// //                                         MediaQuery.of(context).size.height *
// //                                             0.01,
// //                                       ),
// //                                       child: Container(
// //                                         width: w * 0.06,
// //                                         height: w * 0.06,
// //                                         margin: EdgeInsets.only(top: w * 0.01),
// //                                         decoration: BoxDecoration(
// //                                           shape: BoxShape.circle,
// //                                           border: Border.all(
// //                                             color: isSelected
// //                                                 ? AppColors.primaryRed
// //                                                 : AppColors.mediumGray,
// //                                             width: 2,
// //                                           ),
// //                                         ),
// //                                         child: isSelected
// //                                             ? Center(
// //                                                 child: Container(
// //                                                   width: w * 0.03,
// //                                                   height: w * 0.03,
// //                                                   decoration: BoxDecoration(
// //                                                     shape: BoxShape.circle,
// //                                                     color: AppColors.primaryRed,
// //                                                   ),
// //                                                 ),
// //                                               )
// //                                             : null,
// //                                       ),
// //                                     ),
// //                                     SizedBox(width: w * 0.03),
// //                                     Expanded(
// //                                       child: Column(
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.start,
// //                                         children: [
// //                                           Row(
// //                                             children: [
// //                                               AppFonts.textPoppins(
// //                                                 context,
// //                                                 account.accountHolderName ??
// //                                                     "N/A",
// //                                                 w * 0.032,
// //                                                 FontWeight.w500,
// //                                                 isSelected
// //                                                     ? AppColors.primaryRed
// //                                                     : AppColors.black,
// //                                                 TextAlign.left,
// //                                                 TextOverflow.ellipsis,
// //                                               ),
// //                                               if (isSelected)
// //                                                 Container(
// //                                                   margin: EdgeInsets.only(
// //                                                     left: w * 0.00,
// //                                                   ),
// //                                                   padding: EdgeInsets.symmetric(
// //                                                     horizontal: w * 0.02,
// //                                                     vertical: w * 0.005,
// //                                                   ),
// //                                                   decoration: BoxDecoration(
// //                                                     color: AppColors.primaryRed
// //                                                         .withOpacity(0.1),
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                           4,
// //                                                         ),
// //                                                   ),
// //                                                   child: AppFonts.textPoppins(
// //                                                     context,
// //                                                     "Selected",
// //                                                     w * 0.025,
// //                                                     FontWeight.w500,
// //                                                     AppColors.primaryRed,
// //                                                     TextAlign.center,
// //                                                     TextOverflow.ellipsis,
// //                                                   ),
// //                                                 ),
// //                                             ],
// //                                           ),
// //                                           SizedBox(height: w * 0.005),
// //                                           AppFonts.textPoppins(
// //                                             context,
// //                                             account.upiId ?? "N/A",
// //                                             w * 0.030,
// //                                             FontWeight.w400,
// //                                             AppColors.darkGray,
// //                                             TextAlign.left,
// //                                             TextOverflow.ellipsis,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               SizedBox(height: w * .1),

// //               // Transfer Button
// //               AppButtons.solid(
// //                 context: context,
// //                 text: "Transfer",
// //                 onClicked: () {
// //                   // Validate form
// //                   if (!_formKey.currentState!.validate()) {
// //                     return;
// //                   }

// //                   if (!hasBankAccounts) {
// //                     Get.snackbar(
// //                       'No Payment Method',
// //                       'Please add a bank account or UPI ID first',
// //                       snackPosition: SnackPosition.BOTTOM,
// //                       backgroundColor: Colors.red,
// //                       colorText: Colors.white,
// //                     );
// //                     return;
// //                   }

// //                   if (selectedAccountId == null ||
// //                       selectedAccountType == null) {
// //                     Get.snackbar(
// //                       'No Payment Method Selected',
// //                       'Please select a bank account or UPI ID to transfer to',
// //                       snackPosition: SnackPosition.BOTTOM,
// //                       backgroundColor: Colors.red,
// //                       colorText: Colors.white,
// //                     );
// //                     return;
// //                   }

// //                   // Get the selected account details
// //                   final selectedAccount = bankAccounts.firstWhere(
// //                     (account) => account.id == selectedAccountId,
// //                   );

// //                   // Show confirmation dialog
// //                   _showTransferConfirmationDialog(
// //                     context,
// //                     w,
// //                     selectedAccount,
// //                     amountController.text,
// //                   );
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
// //         );
// //       }),
// //     );
// //   }

// //   String _maskAccountNumber(String? accountNumber) {
// //     if (accountNumber == null || accountNumber.isEmpty) return "N/A";
// //     if (accountNumber.length <= 4) return accountNumber;

// //     final maskedPart = '*' * (accountNumber.length - 4);
// //     final lastFour = accountNumber.substring(accountNumber.length - 4);
// //     return "$maskedPart$lastFour";
// //   }

// //   void _showTransferConfirmationDialog(
// //     BuildContext context,
// //     double w,
// //     BankAccount selectedAccount,
// //     String amount,
// //   ) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Row(
// //           children: [
// //             Icon(
// //               selectedAccount.type == "UPI"
// //                   ? Icons.payment
// //                   : Icons.account_balance,
// //               color: AppColors.primaryRed,
// //             ),
// //             SizedBox(width: w * 0.02),
// //             AppFonts.textPoppins(
// //               context,
// //               "Confirm Transfer",
// //               w * 0.04,
// //               FontWeight.w600,
// //               AppColors.black,
// //               TextAlign.left,
// //               TextOverflow.ellipsis,
// //             ),
// //           ],
// //         ),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             AppFonts.textPoppins(
// //               context,
// //               "Are you sure you want to transfer ₹$amount to:",
// //               w * 0.032,
// //               FontWeight.w500,
// //               AppColors.darkGray,
// //               TextAlign.left,
// //               TextOverflow.visible,
// //             ),
// //             SizedBox(height: w * 0.02),
// //             Container(
// //               padding: EdgeInsets.all(w * 0.03),
// //               decoration: BoxDecoration(
// //                 color: AppColors.lightGray.withOpacity(0.3),
// //                 borderRadius: BorderRadius.circular(w * 0.02),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   AppFonts.textPoppins(
// //                     context,
// //                     selectedAccount.accountHolderName ?? "N/A",
// //                     w * 0.034,
// //                     FontWeight.w600,
// //                     AppColors.black,
// //                     TextAlign.left,
// //                     TextOverflow.ellipsis,
// //                   ),
// //                   SizedBox(height: w * 0.005),
// //                   if (selectedAccount.type == "UPI") ...[
// //                     AppFonts.textPoppins(
// //                       context,
// //                       "UPI ID: ${selectedAccount.upiId}",
// //                       w * 0.030,
// //                       FontWeight.w500,
// //                       AppColors.darkGray,
// //                       TextAlign.left,
// //                       TextOverflow.ellipsis,
// //                     ),
// //                   ] else ...[
// //                     AppFonts.textPoppins(
// //                       context,
// //                       selectedAccount.bankName ?? "N/A",
// //                       w * 0.030,
// //                       FontWeight.w500,
// //                       AppColors.darkGray,
// //                       TextAlign.left,
// //                       TextOverflow.ellipsis,
// //                     ),
// //                     SizedBox(height: w * 0.005),
// //                     AppFonts.textPoppins(
// //                       context,
// //                       "Account: ${_maskAccountNumber(selectedAccount.accountNumber)}",
// //                       w * 0.030,
// //                       FontWeight.w500,
// //                       AppColors.darkGray,
// //                       TextAlign.left,
// //                       TextOverflow.ellipsis,
// //                     ),
// //                     SizedBox(height: w * 0.005),
// //                     AppFonts.textPoppins(
// //                       context,
// //                       "IFSC: ${selectedAccount.ifscCode}",
// //                       w * 0.030,
// //                       FontWeight.w500,
// //                       AppColors.darkGray,
// //                       TextAlign.left,
// //                       TextOverflow.ellipsis,
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: w * 0.02),
// //             AppFonts.textPoppins(
// //               context,
// //               "Note: This action cannot be undone.",
// //               w * 0.028,
// //               FontWeight.w400,
// //               AppColors.mediumGray,
// //               TextAlign.left,
// //               TextOverflow.visible,
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: AppFonts.textPoppins(
// //               context,
// //               "Cancel",
// //               w * 0.035,
// //               FontWeight.w500,
// //               AppColors.darkGray,
// //               TextAlign.center,
// //               TextOverflow.ellipsis,
// //             ),
// //           ),
// //           ElevatedButton(
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primaryRed,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //             onPressed: () {
// //               Navigator.pop(context);

// //               print("=== Transfer Details ===");
// //               print("Selected Account ID: ${selectedAccount.id}");
// //               print("Account Type: ${selectedAccount.type}");
// //               print("Amount: $amount");
// //               print("Account Holder: ${selectedAccount.accountHolderName}");
// //               if (selectedAccount.type == "UPI") {
// //                 print("UPI ID: ${selectedAccount.upiId}");
// //               } else {
// //                 print("Bank Name: ${selectedAccount.bankName}");
// //                 print("Account Number: ${selectedAccount.accountNumber}");
// //                 print("IFSC Code: ${selectedAccount.ifscCode}");
// //               }
// //               print("========================");

// //               paymentsWithdrawController.withdrawal_method(
// //                 BankAccountId: selectedAccount.id,
// //                 amount: amount,
// //               );
// //             },
// //             child: AppFonts.textPoppins(
// //               context,
// //               "Confirm Transfer",
// //               w * 0.035,
// //               FontWeight.w500,
// //               AppColors.white,
// //               TextAlign.center,
// //               TextOverflow.ellipsis,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/services.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/get_bank_accounts_controller.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/payments_withdraw_controller.dart';
// import 'package:nzcu_driver/modals/profile_modals/get_bank_accounts_response.dart';
// import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/add_bank.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/add_upi.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/edit_bank_account.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/edit_upi.dart';

// class MoneyTransferScreen extends StatefulWidget {
//   const MoneyTransferScreen({super.key});

//   @override
//   State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
// }

// class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
//   final GetBankAccountsController getBankAccountsController = Get.put(
//     GetBankAccountsController(),
//   );

//   final PaymentsWithdrawController paymentsWithdrawController = Get.put(
//     PaymentsWithdrawController(),
//   );

//   // Store selected bank account or UPI ID
//   String? selectedAccountId;
//   String? selectedAccountType; // "BANK" or "UPI"

//   // Amount controller
//   final TextEditingController amountController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getBankAccountsController.bankdetails_mdethod();
//     });
//   }

//   @override
//   void dispose() {
//     amountController.dispose();
//     super.dispose();
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
//             child: CircularProgressIndicator(color: AppColors.primaryRed),
//           );
//         }

//         if (getBankAccountsController.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
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
//               ],
//             ),
//           );
//         }

//         final bankAccounts =
//             getBankAccountsController.driveridresponse.value?.data ?? [];
//         final hasBankAccounts = bankAccounts.isNotEmpty;

//         return Form(
//           key: _formKey,
//           child: ListView(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * .03,
//               vertical: w * .04,
//             ),
//             children: [
//               // Amount Input Field
//               Container(
//                     width: w,
//                     padding: EdgeInsets.all(w * 0.04),
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           spreadRadius: 2,
//                           blurRadius: 3,
//                         ),
//                       ],
//                       borderRadius: BorderRadius.circular(w * 0.03),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppFonts.textPoppins(
//                           context,
//                           "Enter Amount",
//                           w * 0.04,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.left,
//                           TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: w * 0.02),
//                         TextFormField(
//                           controller: amountController,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: [
//                             FilteringTextInputFormatter
//                                 .digitsOnly, // ✅ Only numbers allowed
//                           ],
//                           decoration: InputDecoration(
//                             prefixIcon: Icon(
//                               Icons.currency_rupee,
//                               color: AppColors.primaryRed,
//                               size: w * 0.05,
//                             ),
//                             hintText: "0",
//                             hintStyle: TextStyle(
//                               fontSize: w * 0.04,
//                               color: AppColors.mediumGray,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(w * 0.02),
//                               borderSide: BorderSide(
//                                 color: AppColors.lightGray,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(w * 0.02),
//                               borderSide: BorderSide(
//                                 color: AppColors.lightGray,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(w * 0.02),
//                               borderSide: BorderSide(
//                                 color: AppColors.primaryRed,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter an amount';
//                             }
//                             if (double.tryParse(value) == null) {
//                               return 'Please enter a valid amount';
//                             }
//                             if (double.parse(value) <= 0) {
//                               return 'Amount must be greater than 0';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   )
//                   .animate()
//                   .fade(duration: 820.ms, curve: Curves.easeInOut)
//                   .scale(
//                     begin: const Offset(0.95, 0.95),
//                     end: const Offset(1, 1),
//                   ),

//               SizedBox(height: w * 0.03),

//               Padding(
//                 padding: EdgeInsets.only(bottom: w * .02),
//                 child: AppFonts.textPoppins(
//                   context,
//                   "A service fee of 10% is deducted from each completed ride to cover platform charges.",
//                   w * 0.032,
//                   FontWeight.w500,
//                   AppColors.mediumGray,
//                   TextAlign.left,
//                   TextOverflow.ellipsis,
//                   maxLines: 2,
//                 ),
//               ),

//               AppFonts.textPoppins(
//                 context,
//                 "Select Payment Method",
//                 w * 0.043,
//                 FontWeight.w600,
//                 AppColors.black,
//                 TextAlign.left,
//                 TextOverflow.ellipsis,
//               ),

//               SizedBox(height: w * .02),

//               // Bank Details Section
//               Container(
//                 width: w,
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 3,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(w * 0.03),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: w * .04),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header with Add New button
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: w * .04),
//                         child: Row(
//                           children: [
//                             CustomImages.images(
//                               "assets/icons/addBank1.png",
//                               w * .05,
//                               w * .05,
//                             ),
//                             SizedBox(width: w * .02),
//                             AppFonts.textPoppins(
//                               context,
//                               "Bank Details",
//                               w * 0.04,
//                               FontWeight.w400,
//                               AppColors.black,
//                               TextAlign.left,
//                               TextOverflow.ellipsis,
//                             ),
//                             Spacer(),
//                             InkWell(
//                               splashColor: AppColors.mediumGray,
//                               onTap: () {
//                                 Get.to(() => AddBank());
//                                 // Uncomment when AddBank screen is ready
//                                 // CustomNavigator.push(
//                                 //   context,
//                                 //   AddBank(),
//                                 //   transition: TransitionType.slideLeft,
//                                 // ).then((value) {
//                                 //   if (value == true) {
//                                 //     getBankAccountsController.bankdetails_mdethod();
//                                 //     setState(() {
//                                 //       selectedAccountId = null;
//                                 //       selectedAccountType = null;
//                                 //     });
//                                 //   }
//                                 // });
//                               },
//                               child: AppFonts.textPoppins(
//                                 context,
//                                 "ADD NEW",
//                                 w * 0.035,
//                                 FontWeight.w500,
//                                 ColorsList.linksTextColor,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: w * .02),

//                       // Bank Accounts List with Selection
//                       if (bankAccounts.where((a) => a.type == "BANK").isEmpty)
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: w * .07,
//                             vertical: w * .02,
//                           ),
//                           child: AppFonts.textPoppins(
//                             context,
//                             "No bank accounts added yet.",
//                             w * 0.032,
//                             FontWeight.w400,
//                             AppColors.mediumGray,
//                             TextAlign.left,
//                             TextOverflow.ellipsis,
//                           ),
//                         )
//                       else
//                         ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: bankAccounts
//                               .where((a) => a.type == "BANK")
//                               .length,
//                           separatorBuilder: (context, index) => Divider(
//                             color: AppColors.lightGray,
//                             height: w * 0.04,
//                             indent: w * 0.07,
//                             endIndent: w * 0.04,
//                           ),
//                           itemBuilder: (context, index) {
//                             final bankAccountsList = bankAccounts
//                                 .where((a) => a.type == "BANK")
//                                 .toList();
//                             final account = bankAccountsList[index];

//                             final isSelected =
//                                 selectedAccountId == account.id &&
//                                 selectedAccountType == "BANK";

//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   if (isSelected) {
//                                     // Deselect if already selected
//                                     selectedAccountId = null;
//                                     selectedAccountType = null;
//                                   } else {
//                                     // Select this bank account and deselect any UPI
//                                     selectedAccountId = account.id;
//                                     selectedAccountType = "BANK";
//                                   }
//                                 });
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: w * .04,
//                                   vertical: w * .01,
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // Radio button for selection
//                                     Container(
//                                       width: w * 0.06,
//                                       height: w * 0.06,
//                                       margin: EdgeInsets.only(top: w * 0.01),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: isSelected
//                                               ? AppColors.primaryRed
//                                               : AppColors.mediumGray,
//                                           width: 2,
//                                         ),
//                                       ),
//                                       child: isSelected
//                                           ? Center(
//                                               child: Container(
//                                                 width: w * 0.03,
//                                                 height: w * 0.03,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: AppColors.primaryRed,
//                                                 ),
//                                               ),
//                                             )
//                                           : null,
//                                     ),

//                                     SizedBox(width: w * 0.02),

//                                     // Bank Account Details
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // Account Holder Name
//                                           Row(
//                                             children: [
//                                               AppFonts.textPoppins(
//                                                 context,
//                                                 account.accountHolderName ??
//                                                     "N/A",
//                                                 w * 0.032,
//                                                 FontWeight.w500,
//                                                 isSelected
//                                                     ? AppColors.primaryRed
//                                                     : AppColors.black,
//                                                 TextAlign.left,
//                                                 TextOverflow.ellipsis,
//                                               ),
//                                               if (isSelected)
//                                                 SizedBox(width: w * 0.02),
//                                               if (isSelected)
//                                                 Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: w * 0.02,
//                                                     vertical: w * 0.005,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     color: AppColors.primaryRed
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           4,
//                                                         ),
//                                                   ),
//                                                   child: AppFonts.textPoppins(
//                                                     context,
//                                                     "Selected",
//                                                     w * 0.025,
//                                                     FontWeight.w500,
//                                                     AppColors.primaryRed,
//                                                     TextAlign.center,
//                                                     TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                             ],
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           // Bank Name
//                                           AppFonts.textPoppins(
//                                             context,
//                                             account.bankName ?? "N/A",
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           // IFSC Code
//                                           AppFonts.textPoppins(
//                                             context,
//                                             "IFSC: ${account.ifscCode ?? "N/A"}",
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           // Account Number (masked for security)
//                                           AppFonts.textPoppins(
//                                             context,
//                                             _maskAccountNumber(
//                                               account.accountNumber,
//                                             ),
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ),

//                                     // Edit and Delete Icons
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             // _showEditBankDialog(context, w, account);

//                                             Get.to(
//                                               () => EditBank(
//                                                 account: account,
//                                                 account_id: account.id,
//                                               ),
//                                             )?.then((value) {
//                                               if (value == true) {
//                                                 getBankAccountsController
//                                                     .bankdetails_mdethod();
//                                               }
//                                             });
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(w * 0.02),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.primaryRed
//                                                   .withOpacity(0.1),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               Icons.edit,
//                                               size: w * 0.04,
//                                               color: AppColors.primaryRed,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: w * 0.02),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               SizedBox(height: w * .04),

//               // UPI Details Section
//               Container(
//                 width: w,
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 3,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(w * 0.03),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: w * .04),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: w * .04),
//                         child: Row(
//                           children: [
//                             CustomImages.images(
//                               "assets/icons/addUpi1.png",
//                               w * .05,
//                               w * .05,
//                             ),
//                             SizedBox(width: w * .02),
//                             AppFonts.textPoppins(
//                               context,
//                               "UPI Details",
//                               w * 0.04,
//                               FontWeight.w400,
//                               AppColors.black,
//                               TextAlign.left,
//                               TextOverflow.ellipsis,
//                             ),
//                             Spacer(),
//                             InkWell(
//                               onTap: () {
//                                 Get.to(AddUpi());
//                                 // CustomNavigator.push(
//                                 //   context,
//                                 //   AddUpi(),
//                                 //   transition: TransitionType.slideLeft,
//                                 // ).then((value) {
//                                 //   if (value == true) {
//                                 //     getBankAccountsController.bankdetails_mdethod();
//                                 //     setState(() {
//                                 //       selectedAccountId = null;
//                                 //       selectedAccountType = null;
//                                 //     });
//                                 //   }
//                                 // });
//                               },
//                               child: AppFonts.textPoppins(
//                                 context,
//                                 "ADD NEW",
//                                 w * 0.035,
//                                 FontWeight.w500,
//                                 ColorsList.linksTextColor,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: w * .02),
//                       if (bankAccounts.where((a) => a.type == "UPI").isEmpty)
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: w * .07),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppFonts.textPoppins(
//                                 context,
//                                 "No UPI details added",
//                                 w * 0.032,
//                                 FontWeight.w400,
//                                 AppColors.mediumGray,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: w * 0.005),
//                               AppFonts.textPoppins(
//                                 context,
//                                 "Add your UPI ID for quick transfers",
//                                 w * 0.030,
//                                 FontWeight.w400,
//                                 AppColors.mediumGray,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         )
//                       else
//                         ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: bankAccounts
//                               .where((a) => a.type == "UPI")
//                               .length,
//                           separatorBuilder: (context, index) => Divider(
//                             color: AppColors.lightGray,
//                             height: w * 0.04,
//                             indent: w * 0.07,
//                             endIndent: w * 0.04,
//                           ),
//                           itemBuilder: (context, index) {
//                             final upiAccounts = bankAccounts
//                                 .where((a) => a.type == "UPI")
//                                 .toList();
//                             final account = upiAccounts[index];
//                             final isSelected =
//                                 selectedAccountId == account.id &&
//                                 selectedAccountType == "UPI";

//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   if (isSelected) {
//                                     // Deselect if already selected
//                                     selectedAccountId = null;
//                                     selectedAccountType = null;
//                                   } else {
//                                     // Select this UPI and deselect any bank account
//                                     selectedAccountId = account.id;
//                                     selectedAccountType = "UPI";
//                                   }
//                                 });
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: w * .04,
//                                   vertical: w * .01,
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Transform.translate(
//                                       offset: Offset(
//                                         0,
//                                         MediaQuery.of(context).size.height *
//                                             0.01,
//                                       ),
//                                       child: Container(
//                                         width: w * 0.06,
//                                         height: w * 0.06,
//                                         margin: EdgeInsets.only(top: w * 0.01),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                             color: isSelected
//                                                 ? AppColors.primaryRed
//                                                 : AppColors.mediumGray,
//                                             width: 2,
//                                           ),
//                                         ),
//                                         child: isSelected
//                                             ? Center(
//                                                 child: Container(
//                                                   width: w * 0.03,
//                                                   height: w * 0.03,
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: AppColors.primaryRed,
//                                                   ),
//                                                 ),
//                                               )
//                                             : null,
//                                       ),
//                                     ),
//                                     SizedBox(width: w * 0.02),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               AppFonts.textPoppins(
//                                                 context,
//                                                 account.accountHolderName ??
//                                                     "N/A",
//                                                 w * 0.032,
//                                                 FontWeight.w500,
//                                                 isSelected
//                                                     ? AppColors.primaryRed
//                                                     : AppColors.black,
//                                                 TextAlign.left,
//                                                 TextOverflow.ellipsis,
//                                               ),
//                                               if (isSelected)
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                     left: w * 0.00,
//                                                   ),
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: w * 0.02,
//                                                     vertical: w * 0.005,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     color: AppColors.primaryRed
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           4,
//                                                         ),
//                                                   ),
//                                                   child: AppFonts.textPoppins(
//                                                     context,
//                                                     "Selected",
//                                                     w * 0.025,
//                                                     FontWeight.w500,
//                                                     AppColors.primaryRed,
//                                                     TextAlign.center,
//                                                     TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                             ],
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           AppFonts.textPoppins(
//                                             context,
//                                             account.upiId ?? "N/A",
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ),

//                                     // Edit and Delete Icons for UPI
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             // _showEditUpiDialog(context, w, account);

//                                             Get.to(
//                                               () => EditUpi(
//                                                 account: account,
//                                                 account_id: account.id,
//                                               ),
//                                             )?.then((value) {
//                                               if (value == true) {
//                                                 getBankAccountsController
//                                                     .bankdetails_mdethod();
//                                               }
//                                             });
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(w * 0.02),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.primaryRed
//                                                   .withOpacity(0.1),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               Icons.edit,
//                                               size: w * 0.04,
//                                               color: AppColors.primaryRed,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: w * 0.02),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               SizedBox(height: w * .1),

//               // Transfer Button
//               AppButtons.solid(
//                 context: context,
//                 text: "Transfer",
//                 onClicked: () {
//                   // Validate form
//                   if (!_formKey.currentState!.validate()) {
//                     return;
//                   }

//                   if (!hasBankAccounts) {
//                     Get.snackbar(
//                       'No Payment Method',
//                       'Please add a bank account or UPI ID first',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }

//                   if (selectedAccountId == null ||
//                       selectedAccountType == null) {
//                     Get.snackbar(
//                       'No Payment Method Selected',
//                       'Please select a bank account or UPI ID to transfer to',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }

//                   // Get the selected account details
//                   final selectedAccount = bankAccounts.firstWhere(
//                     (account) => account.id == selectedAccountId,
//                   );

//                   // Show confirmation dialog
//                   _showTransferConfirmationDialog(
//                     context,
//                     w,
//                     selectedAccount,
//                     amountController.text,
//                   );
//                 },
//                 isFullWidth: true,
//                 backgroundColor: AppColors.primaryRed,
//                 textColor: AppColors.white,
//                 fontSize: w * .045,
//                 height: w * .140,
//                 radius: 12.0,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   String _maskAccountNumber(String? accountNumber) {
//     if (accountNumber == null || accountNumber.isEmpty) return "N/A";
//     if (accountNumber.length <= 4) return accountNumber;

//     final maskedPart = '*' * (accountNumber.length - 4);
//     final lastFour = accountNumber.substring(accountNumber.length - 4);
//     return "$maskedPart$lastFour";
//   }

//   void _showTransferConfirmationDialog(
//     BuildContext context,
//     double w,
//     BankAccount selectedAccount,
//     String amount,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               selectedAccount.type == "UPI"
//                   ? Icons.payment
//                   : Icons.account_balance,
//               color: AppColors.primaryRed,
//             ),
//             SizedBox(width: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "Confirm Transfer",
//               w * 0.04,
//               FontWeight.w600,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppFonts.textPoppins(
//               context,
//               "Are you sure you want to transfer ₹$amount to:",
//               w * 0.032,
//               FontWeight.w500,
//               AppColors.darkGray,
//               TextAlign.left,
//               TextOverflow.visible,
//             ),
//             SizedBox(height: w * 0.02),
//             Container(
//               padding: EdgeInsets.all(w * 0.03),
//               decoration: BoxDecoration(
//                 color: AppColors.lightGray.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(w * 0.02),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppFonts.textPoppins(
//                     context,
//                     selectedAccount.accountHolderName ?? "N/A",
//                     w * 0.034,
//                     FontWeight.w600,
//                     AppColors.black,
//                     TextAlign.left,
//                     TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: w * 0.005),
//                   if (selectedAccount.type == "UPI") ...[
//                     AppFonts.textPoppins(
//                       context,
//                       "UPI ID: ${selectedAccount.upiId}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                   ] else ...[
//                     AppFonts.textPoppins(
//                       context,
//                       selectedAccount.bankName ?? "N/A",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: w * 0.005),
//                     AppFonts.textPoppins(
//                       context,
//                       "Account: ${_maskAccountNumber(selectedAccount.accountNumber)}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: w * 0.005),
//                     AppFonts.textPoppins(
//                       context,
//                       "IFSC: ${selectedAccount.ifscCode}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             SizedBox(height: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "Note: This action cannot be undone.",
//               w * 0.028,
//               FontWeight.w400,
//               AppColors.mediumGray,
//               TextAlign.left,
//               TextOverflow.visible,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: AppFonts.textPoppins(
//               context,
//               "Cancel",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.darkGray,
//               TextAlign.center,
//               TextOverflow.ellipsis,
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryRed,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pop(context);

//               print("=== Transfer Details ===");
//               print("Selected Account ID: ${selectedAccount.id}");
//               print("Account Type: ${selectedAccount.type}");
//               print("Amount: $amount");
//               print("Account Holder: ${selectedAccount.accountHolderName}");
//               if (selectedAccount.type == "UPI") {
//                 print("UPI ID: ${selectedAccount.upiId}");
//               } else {
//                 print("Bank Name: ${selectedAccount.bankName}");
//                 print("Account Number: ${selectedAccount.accountNumber}");
//                 print("IFSC Code: ${selectedAccount.ifscCode}");
//               }
//               print("========================");

//               paymentsWithdrawController.withdrawal_method(
//                 BankAccountId: selectedAccount.id,
//                 amount: amount,
//               );
//             },
//             child: AppFonts.textPoppins(
//               context,
//               "Confirm Transfer",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.white,
//               TextAlign.center,
//               TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmationDialog(
//     BuildContext context,
//     double w,
//     BankAccount account,
//     String type,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.warning, color: Colors.red, size: w * 0.06),
//             SizedBox(width: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "Delete $type",
//               w * 0.04,
//               FontWeight.w600,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppFonts.textPoppins(
//               context,
//               "Are you sure you want to delete this ${type.toLowerCase()}?",
//               w * 0.032,
//               FontWeight.w500,
//               AppColors.darkGray,
//               TextAlign.left,
//               TextOverflow.visible,
//             ),
//             SizedBox(height: w * 0.02),
//             Container(
//               padding: EdgeInsets.all(w * 0.03),
//               decoration: BoxDecoration(
//                 color: AppColors.lightGray.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(w * 0.02),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppFonts.textPoppins(
//                     context,
//                     account.accountHolderName ?? "N/A",
//                     w * 0.034,
//                     FontWeight.w600,
//                     AppColors.black,
//                     TextAlign.left,
//                     TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: w * 0.005),
//                   if (type == "UPI") ...[
//                     AppFonts.textPoppins(
//                       context,
//                       "UPI ID: ${account.upiId}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                   ] else ...[
//                     AppFonts.textPoppins(
//                       context,
//                       account.bankName ?? "N/A",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: w * 0.005),
//                     AppFonts.textPoppins(
//                       context,
//                       "Account: ${_maskAccountNumber(account.accountNumber)}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             SizedBox(height: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "This action cannot be undone.",
//               w * 0.028,
//               FontWeight.w400,
//               AppColors.mediumGray,
//               TextAlign.left,
//               TextOverflow.visible,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: AppFonts.textPoppins(
//               context,
//               "Cancel",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.darkGray,
//               TextAlign.center,
//               TextOverflow.ellipsis,
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pop(context);

//               // Call your delete API here
//               print("=== Delete $type ===");
//               print("Account ID: ${account.id}");
//               print("Account Holder: ${account.accountHolderName}");
//               print("Type: $type");

//               // Show success message
//               Get.snackbar(
//                 'Success',
//                 '$type deleted successfully',
//                 snackPosition: SnackPosition.BOTTOM,
//                 backgroundColor: Colors.green,
//                 colorText: Colors.white,
//               );

//               // Refresh the list
//               getBankAccountsController.bankdetails_mdethod();

//               // Clear selection if deleted account was selected
//               if (selectedAccountId == account.id) {
//                 setState(() {
//                   selectedAccountId = null;
//                   selectedAccountType = null;
//                 });
//               }
//             },
//             child: AppFonts.textPoppins(
//               context,
//               "Delete",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.white,
//               TextAlign.center,
//               TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditBankDialog(
//     BuildContext context,
//     double w,
//     BankAccount account,
//   ) {
//     // Navigate to AddBank screen with account data for editing
//     // Get.to(() => EditBank(account: account))?.then((value) {
//     //   if (value == true) {
//     //     getBankAccountsController.bankdetails_mdethod();
//     //   }
//     // });
//   }

//   void _showEditUpiDialog(BuildContext context, double w, BankAccount account) {
//     // Navigate to AddUpi screen with account data for editing
//     // Get.to(() => AddUpi(account: account))?.then((value) {
//     //   if (value == true) {
//     //     getBankAccountsController.bankdetails_mdethod();
//     //   }
//     // });
//   }
// }

// import 'package:flutter/services.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/get_bank_accounts_controller.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/payments_withdraw_controller.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/update_bank_and_upi_controller.dart';
// import 'package:nzcu_driver/modals/profile_modals/get_bank_accounts_response.dart';
// import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/add_bank.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/add_upi.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/edit_bank_account.dart';
// import 'package:nzcu_driver/views/profile_screens/payment_related/edit_upi.dart';

// class MoneyTransferScreen extends StatefulWidget {
//   const MoneyTransferScreen({super.key});

//   @override
//   State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
// }

// class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
//   final GetBankAccountsController getBankAccountsController = Get.put(
//     GetBankAccountsController(),
//   );

//   final PaymentsWithdrawController paymentsWithdrawController = Get.put(
//     PaymentsWithdrawController(),
//   );

//   // Store selected bank account or UPI ID
//   String? selectedAccountId;
//   String? selectedAccountType; // "BankAccount" or "UPI"

//   // Amount controller
//   final TextEditingController amountController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  late final UpdateBankAndUpiController updateBankAndUpiController;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getBankAccountsController.bankdetails_mdethod();
//     });

//      updateBankAndUpiController = Get.put(UpdateBankAndUpiController());
//   }

//   @override
//   void dispose() {
//     amountController.dispose();
//     super.dispose();
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
//             child: CircularProgressIndicator(color: AppColors.primaryRed),
//           );
//         }

//         if (getBankAccountsController.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
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
//               ],
//             ),
//           );
//         }

//         final bankAccounts =
//             getBankAccountsController.driveridresponse.value?.data ?? [];
//         final hasBankAccounts = bankAccounts.isNotEmpty;

//         return Form(
//           key: _formKey,
//           child: ListView(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * .03,
//               vertical: w * .04,
//             ),
//             children: [
//               // Amount Input Field
//               Container(
//                     width: w,
//                     padding: EdgeInsets.all(w * 0.04),
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           spreadRadius: 2,
//                           blurRadius: 3,
//                         ),
//                       ],
//                       borderRadius: BorderRadius.circular(w * 0.03),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppFonts.textPoppins(
//                           context,
//                           "Enter Amount",
//                           w * 0.04,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.left,
//                           TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: w * 0.02),
//                         TextFormField(
//                           controller: amountController,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                           decoration: InputDecoration(
//                             prefixIcon: Icon(
//                               Icons.currency_rupee,
//                               color: AppColors.primaryRed,
//                               size: w * 0.05,
//                             ),
//                             hintText: "0",
//                             hintStyle: TextStyle(
//                               fontSize: w * 0.04,
//                               color: AppColors.mediumGray,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(w * 0.02),
//                               borderSide: BorderSide(
//                                 color: AppColors.lightGray,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(w * 0.02),
//                               borderSide: BorderSide(
//                                 color: AppColors.lightGray,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(w * 0.02),
//                               borderSide: BorderSide(
//                                 color: AppColors.primaryRed,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter an amount';
//                             }
//                             if (double.tryParse(value) == null) {
//                               return 'Please enter a valid amount';
//                             }
//                             if (double.parse(value) <= 0) {
//                               return 'Amount must be greater than 0';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   )
//                   .animate()
//                   .fade(duration: 820.ms, curve: Curves.easeInOut)
//                   .scale(
//                     begin: const Offset(0.95, 0.95),
//                     end: const Offset(1, 1),
//                   ),

//               SizedBox(height: w * 0.03),

//               Padding(
//                 padding: EdgeInsets.only(bottom: w * .02),
//                 child: AppFonts.textPoppins(
//                   context,
//                   "A service fee of 10% is deducted from each completed ride to cover platform charges.",
//                   w * 0.032,
//                   FontWeight.w500,
//                   AppColors.mediumGray,
//                   TextAlign.left,
//                   TextOverflow.ellipsis,
//                   maxLines: 2,
//                 ),
//               ),

//               AppFonts.textPoppins(
//                 context,
//                 "Select Payment Method",
//                 w * 0.043,
//                 FontWeight.w600,
//                 AppColors.black,
//                 TextAlign.left,
//                 TextOverflow.ellipsis,
//               ),

//               SizedBox(height: w * .02),

//               // Bank Details Section
//               Container(
//                 width: w,
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 3,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(w * 0.03),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: w * .04),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header with Add New button
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: w * .04),
//                         child: Row(
//                           children: [
//                             CustomImages.images(
//                               "assets/icons/addBank1.png",
//                               w * .05,
//                               w * .05,
//                             ),
//                             SizedBox(width: w * .02),
//                             AppFonts.textPoppins(
//                               context,
//                               "Bank Details",
//                               w * 0.04,
//                               FontWeight.w400,
//                               AppColors.black,
//                               TextAlign.left,
//                               TextOverflow.ellipsis,
//                             ),
//                             Spacer(),
//                             InkWell(
//                               splashColor: AppColors.mediumGray,
//                               onTap: () {
//                                 Get.to(() => AddBank())?.then((value) {
//                                   if (value == true) {
//                                     getBankAccountsController
//                                         .bankdetails_mdethod();
//                                     setState(() {
//                                       selectedAccountId = null;
//                                       selectedAccountType = null;
//                                     });
//                                   }
//                                 });
//                               },
//                               child: AppFonts.textPoppins(
//                                 context,
//                                 "ADD NEW",
//                                 w * 0.035,
//                                 FontWeight.w500,
//                                 ColorsList.linksTextColor,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: w * .02),

//                       // Bank Accounts List with Selection
//                       if (bankAccounts
//                           .where((a) => a.type == "BankAccount")
//                           .isEmpty)
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: w * .07,
//                             vertical: w * .02,
//                           ),
//                           child: AppFonts.textPoppins(
//                             context,
//                             "No bank accounts added yet.",
//                             w * 0.032,
//                             FontWeight.w400,
//                             AppColors.mediumGray,
//                             TextAlign.left,
//                             TextOverflow.ellipsis,
//                           ),
//                         )
//                       else
//                         ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: bankAccounts
//                               .where((a) => a.type == "BankAccount")
//                               .length,
//                           separatorBuilder: (context, index) => Divider(
//                             color: AppColors.lightGray,
//                             height: w * 0.04,
//                             indent: w * 0.07,
//                             endIndent: w * 0.04,
//                           ),
//                           itemBuilder: (context, index) {
//                             final bankAccountsList = bankAccounts
//                                 .where((a) => a.type == "BankAccount")
//                                 .toList();
//                             final account = bankAccountsList[index];

//                             final isSelected =
//                                 selectedAccountId == account.id &&
//                                 selectedAccountType == "BankAccount";

//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   if (isSelected) {
//                                     // Deselect if already selected
//                                     selectedAccountId = null;
//                                     selectedAccountType = null;
//                                   } else {
//                                     // Select this bank account and deselect any UPI
//                                     selectedAccountId = account.id;
//                                     selectedAccountType = "BankAccount";
//                                   }
//                                 });
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: w * .04,
//                                   vertical: w * .01,
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // Radio button for selection
//                                     Container(
//                                       width: w * 0.06,
//                                       height: w * 0.06,
//                                       margin: EdgeInsets.only(top: w * 0.01),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: isSelected
//                                               ? AppColors.primaryRed
//                                               : AppColors.mediumGray,
//                                           width: 2,
//                                         ),
//                                       ),
//                                       child: isSelected
//                                           ? Center(
//                                               child: Container(
//                                                 width: w * 0.03,
//                                                 height: w * 0.03,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: AppColors.primaryRed,
//                                                 ),
//                                               ),
//                                             )
//                                           : null,
//                                     ),

//                                     SizedBox(width: w * 0.02),

//                                     // Bank Account Details
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // Account Holder Name
//                                           Row(
//                                             children: [
//                                               AppFonts.textPoppins(
//                                                 context,
//                                                 account.accountHolderName ??
//                                                     "N/A",
//                                                 w * 0.032,
//                                                 FontWeight.w500,
//                                                 isSelected
//                                                     ? AppColors.primaryRed
//                                                     : AppColors.black,
//                                                 TextAlign.left,
//                                                 TextOverflow.ellipsis,
//                                               ),
//                                               if (isSelected)
//                                                 SizedBox(width: w * 0.02),
//                                               if (isSelected)
//                                                 Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: w * 0.02,
//                                                     vertical: w * 0.005,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     color: AppColors.primaryRed
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           4,
//                                                         ),
//                                                   ),
//                                                   child: AppFonts.textPoppins(
//                                                     context,
//                                                     "Selected",
//                                                     w * 0.025,
//                                                     FontWeight.w500,
//                                                     AppColors.primaryRed,
//                                                     TextAlign.center,
//                                                     TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                             ],
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           // Bank Name
//                                           AppFonts.textPoppins(
//                                             context,
//                                             account.bankName ?? "N/A",
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           // IFSC Code
//                                           AppFonts.textPoppins(
//                                             context,
//                                             "IFSC: ${account.ifscCode ?? "N/A"}",
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           // Account Number (masked for security)
//                                           AppFonts.textPoppins(
//                                             context,
//                                             _maskAccountNumber(
//                                               account.accountNumber,
//                                             ),
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ),

//                                     // Edit Icon
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             Get.to(
//                                               () => EditBank(
//                                                 account: account,
//                                                 account_id: account.id,
//                                               ),
//                                             )?.then((value) {
//                                               if (value == true) {
//                                                 getBankAccountsController
//                                                     .bankdetails_mdethod();
//                                               }
//                                             });
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(w * 0.02),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.primaryRed
//                                                   .withOpacity(0.1),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               Icons.edit,
//                                               size: w * 0.04,
//                                               color: AppColors.primaryRed,
//                                             ),
//                                           ),
//                                         ),

//                                         SizedBox(width: 5),
//                                         InkWell(
//                                           onTap: () {
//                                             Get.to(
//                                               () => EditBank(
//                                                 account: account,
//                                                 account_id: account.id,
//                                               ),
//                                             )?.then((value) {
//                                               if (value == true) {
//                                                 getBankAccountsController
//                                                     .bankdetails_mdethod();
//                                               }
//                                             });
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(w * 0.02),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.primaryRed
//                                                   .withOpacity(0.1),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               Icons.delete,
//                                               size: w * 0.04,
//                                               color: Colors.red,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               SizedBox(height: w * .04),

//               // UPI Details Section
//               Container(
//                 width: w,
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 3,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(w * 0.03),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: w * .04),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: w * .04),
//                         child: Row(
//                           children: [
//                             CustomImages.images(
//                               "assets/icons/addUpi1.png",
//                               w * .05,
//                               w * .05,
//                             ),
//                             SizedBox(width: w * .02),
//                             AppFonts.textPoppins(
//                               context,
//                               "UPI Details",
//                               w * 0.04,
//                               FontWeight.w400,
//                               AppColors.black,
//                               TextAlign.left,
//                               TextOverflow.ellipsis,
//                             ),
//                             Spacer(),
//                             InkWell(
//                               onTap: () {
//                                 Get.to(() => AddUpi())?.then((value) {
//                                   if (value == true) {
//                                     getBankAccountsController
//                                         .bankdetails_mdethod();
//                                     setState(() {
//                                       selectedAccountId = null;
//                                       selectedAccountType = null;
//                                     });
//                                   }
//                                 });
//                               },
//                               child: AppFonts.textPoppins(
//                                 context,
//                                 "ADD NEW",
//                                 w * 0.035,
//                                 FontWeight.w500,
//                                 ColorsList.linksTextColor,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: w * .02),
//                       if (bankAccounts.where((a) => a.type == "UPI").isEmpty)
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: w * .07),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppFonts.textPoppins(
//                                 context,
//                                 "No UPI details added",
//                                 w * 0.032,
//                                 FontWeight.w400,
//                                 AppColors.mediumGray,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: w * 0.005),
//                               AppFonts.textPoppins(
//                                 context,
//                                 "Add your UPI ID for quick transfers",
//                                 w * 0.030,
//                                 FontWeight.w400,
//                                 AppColors.mediumGray,
//                                 TextAlign.left,
//                                 TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         )
//                       else
//                         ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: bankAccounts
//                               .where((a) => a.type == "UPI")
//                               .length,
//                           separatorBuilder: (context, index) => Divider(
//                             color: AppColors.lightGray,
//                             height: w * 0.04,
//                             indent: w * 0.07,
//                             endIndent: w * 0.04,
//                           ),
//                           itemBuilder: (context, index) {
//                             final upiAccounts = bankAccounts
//                                 .where((a) => a.type == "UPI")
//                                 .toList();
//                             final account = upiAccounts[index];
//                             final isSelected =
//                                 selectedAccountId == account.id &&
//                                 selectedAccountType == "UPI";

//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   if (isSelected) {
//                                     // Deselect if already selected
//                                     selectedAccountId = null;
//                                     selectedAccountType = null;
//                                   } else {
//                                     // Select this UPI and deselect any bank account
//                                     selectedAccountId = account.id;
//                                     selectedAccountType = "UPI";
//                                   }
//                                 });
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: w * .04,
//                                   vertical: w * .01,
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Transform.translate(
//                                       offset: Offset(
//                                         0,
//                                         MediaQuery.of(context).size.height *
//                                             0.01,
//                                       ),
//                                       child: Container(
//                                         width: w * 0.06,
//                                         height: w * 0.06,
//                                         margin: EdgeInsets.only(top: w * 0.01),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                             color: isSelected
//                                                 ? AppColors.primaryRed
//                                                 : AppColors.mediumGray,
//                                             width: 2,
//                                           ),
//                                         ),
//                                         child: isSelected
//                                             ? Center(
//                                                 child: Container(
//                                                   width: w * 0.03,
//                                                   height: w * 0.03,
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: AppColors.primaryRed,
//                                                   ),
//                                                 ),
//                                               )
//                                             : null,
//                                       ),
//                                     ),
//                                     SizedBox(width: w * 0.02),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               AppFonts.textPoppins(
//                                                 context,
//                                                 account.accountHolderName ??
//                                                     "N/A",
//                                                 w * 0.032,
//                                                 FontWeight.w500,
//                                                 isSelected
//                                                     ? AppColors.primaryRed
//                                                     : AppColors.black,
//                                                 TextAlign.left,
//                                                 TextOverflow.ellipsis,
//                                               ),
//                                               if (isSelected)
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                     left: w * 0.00,
//                                                   ),
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: w * 0.02,
//                                                     vertical: w * 0.005,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     color: AppColors.primaryRed
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           4,
//                                                         ),
//                                                   ),
//                                                   child: AppFonts.textPoppins(
//                                                     context,
//                                                     "Selected",
//                                                     w * 0.025,
//                                                     FontWeight.w500,
//                                                     AppColors.primaryRed,
//                                                     TextAlign.center,
//                                                     TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                             ],
//                                           ),
//                                           SizedBox(height: w * 0.005),
//                                           AppFonts.textPoppins(
//                                             context,
//                                             account.upiId ?? "N/A",
//                                             w * 0.030,
//                                             FontWeight.w400,
//                                             AppColors.darkGray,
//                                             TextAlign.left,
//                                             TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ),

//                                     // Edit Icon for UPI
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             Get.to(
//                                               () => EditUpi(
//                                                 account: account,
//                                                 account_id: account.id,
//                                               ),
//                                             )?.then((value) {
//                                               if (value == true) {
//                                                 getBankAccountsController
//                                                     .bankdetails_mdethod();
//                                               }
//                                             });
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(w * 0.02),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.primaryRed
//                                                   .withOpacity(0.1),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               Icons.edit,
//                                               size: w * 0.04,
//                                               color: AppColors.primaryRed,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: 5),
//                                         InkWell(
//                                           onTap: () {
//                                             Get.to(
//                                               () => EditUpi(
//                                                 account: account,
//                                                 account_id: account.id,
//                                               ),
//                                             )?.then((value) {
//                                               if (value == true) {
//                                                 getBankAccountsController
//                                                     .bankdetails_mdethod();
//                                               }
//                                             });

//                                             _deleteUpi(account,account.id);
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(w * 0.02),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.primaryRed
//                                                   .withOpacity(0.1),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               Icons.delete,
//                                               size: w * 0.04,
//                                               color: Colors.red,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               SizedBox(height: w * .1),

//               // Transfer Button
//               AppButtons.solid(
//                 context: context,
//                 text: "Transfer",
//                 onClicked: () {
//                   // Validate form
//                   if (!_formKey.currentState!.validate()) {
//                     return;
//                   }

//                   if (!hasBankAccounts) {
//                     Get.snackbar(
//                       'No Payment Method',
//                       'Please add a bank account or UPI ID first',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }

//                   if (selectedAccountId == null ||
//                       selectedAccountType == null) {
//                     Get.snackbar(
//                       'No Payment Method Selected',
//                       'Please select a bank account or UPI ID to transfer to',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }

//                   // Get the selected account details
//                   final selectedAccount = bankAccounts.firstWhere(
//                     (account) => account.id == selectedAccountId,
//                   );

//                   // Show confirmation dialog
//                   _showTransferConfirmationDialog(
//                     context,
//                     w,
//                     selectedAccount,
//                     amountController.text,
//                   );
//                 },
//                 isFullWidth: true,
//                 backgroundColor: AppColors.primaryRed,
//                 textColor: AppColors.white,
//                 fontSize: w * .045,
//                 height: w * .140,
//                 radius: 12.0,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   String _maskAccountNumber(String? accountNumber) {
//     if (accountNumber == null || accountNumber.isEmpty) return "N/A";
//     if (accountNumber.length <= 4) return accountNumber;

//     final maskedPart = '*' * (accountNumber.length - 4);
//     final lastFour = accountNumber.substring(accountNumber.length - 4);
//     return "$maskedPart$lastFour";
//   }

//   void _showTransferConfirmationDialog(
//     BuildContext context,
//     double w,
//     BankAccount selectedAccount,
//     String amount,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               selectedAccount.type == "UPI"
//                   ? Icons.payment
//                   : Icons.account_balance,
//               color: AppColors.primaryRed,
//             ),
//             SizedBox(width: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "Confirm Transfer",
//               w * 0.04,
//               FontWeight.w600,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppFonts.textPoppins(
//               context,
//               "Are you sure you want to transfer ₹$amount to:",
//               w * 0.032,
//               FontWeight.w500,
//               AppColors.darkGray,
//               TextAlign.left,
//               TextOverflow.visible,
//             ),
//             SizedBox(height: w * 0.02),
//             Container(
//               padding: EdgeInsets.all(w * 0.03),
//               decoration: BoxDecoration(
//                 color: AppColors.lightGray.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(w * 0.02),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppFonts.textPoppins(
//                     context,
//                     selectedAccount.accountHolderName ?? "N/A",
//                     w * 0.034,
//                     FontWeight.w600,
//                     AppColors.black,
//                     TextAlign.left,
//                     TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: w * 0.005),
//                   if (selectedAccount.type == "UPI") ...[
//                     AppFonts.textPoppins(
//                       context,
//                       "UPI ID: ${selectedAccount.upiId}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                   ] else ...[
//                     AppFonts.textPoppins(
//                       context,
//                       selectedAccount.bankName ?? "N/A",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: w * 0.005),
//                     AppFonts.textPoppins(
//                       context,
//                       "Account: ${_maskAccountNumber(selectedAccount.accountNumber)}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: w * 0.005),
//                     AppFonts.textPoppins(
//                       context,
//                       "IFSC: ${selectedAccount.ifscCode}",
//                       w * 0.030,
//                       FontWeight.w500,
//                       AppColors.darkGray,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             SizedBox(height: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "Note: This action cannot be undone.",
//               w * 0.028,
//               FontWeight.w400,
//               AppColors.mediumGray,
//               TextAlign.left,
//               TextOverflow.visible,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: AppFonts.textPoppins(
//               context,
//               "Cancel",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.darkGray,
//               TextAlign.center,
//               TextOverflow.ellipsis,
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryRed,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pop(context);

//               print("=== Transfer Details ===");
//               print("Selected Account ID: ${selectedAccount.id}");
//               print("Account Type: ${selectedAccount.type}");
//               print("Amount: $amount");
//               print("Account Holder: ${selectedAccount.accountHolderName}");
//               if (selectedAccount.type == "UPI") {
//                 print("UPI ID: ${selectedAccount.upiId}");
//               } else {
//                 print("Bank Name: ${selectedAccount.bankName}");
//                 print("Account Number: ${selectedAccount.accountNumber}");
//                 print("IFSC Code: ${selectedAccount.ifscCode}");
//               }
//               print("========================");

//               paymentsWithdrawController.withdrawal_method(
//                 BankAccountId: selectedAccount.id,
//                 amount: amount,
//               );
//             },
//             child: AppFonts.textPoppins(
//               context,
//               "Confirm Transfer",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.white,
//               TextAlign.center,
//               TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//     Future<void> _deleteUpi(account,account_id) async {
//     // Show confirmation dialog
//     bool? confirmDelete = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false, // Prevent dismissing by tapping outside
//       builder: (BuildContext context) {
//         double w = MediaQuery.of(context).size.width;
//         return AlertDialog(
//           title: Text(
//             "Delete UPI ID",
//             style: TextStyle(
//               fontSize: w * 0.05,
//               fontWeight: FontWeight.w600,
//               color: Colors.red,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Are you sure you want to delete this UPI ID?",
//                 style: TextStyle(fontSize: w * 0.04),
//               ),
//               SizedBox(height: w * 0.03),
//               Container(
//                 padding: EdgeInsets.all(w * 0.03),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.red.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.payment, color: Colors.red, size: w * 0.05),
//                     SizedBox(width: w * 0.02),
//                     Expanded(
//                       child: Text(
//                         account?.upiId ?? 'N/A',
//                         style: TextStyle(
//                           fontSize: w * 0.045,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: w * 0.02),
//               Text(
//                 "This action cannot be undone.",
//                 style: TextStyle(
//                   fontSize: w * 0.035,
//                   color: Colors.grey.shade600,
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: w * 0.04,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: () => Navigator.pop(context, true),
//               child: Text(
//                 "Delete",
//                 style: TextStyle(
//                   fontSize: w * 0.04,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmDelete != true) return;

//     setState(() {
//       _isDeleting = true;
//     });

//     try {
//       print("Deleting UPI with accountid: ${account_id}");

//       await updateBankAndUpiController.delete_bank_upi_method(
//         accountid: account_id,
//       );

//       if (mounted) {
//         Get.snackbar(
//           "Success",
//           "UPI ID deleted successfully",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 2),
//         );

//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       print("Error in _deleteUpi: $e");
//       if (mounted) {
//         Get.snackbar(
//           "Error",
//           "Failed to delete UPI ID: ${e.toString()}",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isDeleting = false;
//         });
//       }
//     }
//   }

// }

import 'package:flutter/services.dart';
import 'package:nzcu_driver/controllers/profile_controllers/get_bank_accounts_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/payments_withdraw_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/update_bank_and_upi_controller.dart';
import 'package:nzcu_driver/modals/profile_modals/get_bank_accounts_response.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/profile_screens/payment_related/add_bank.dart';
import 'package:nzcu_driver/views/profile_screens/payment_related/add_upi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/views/profile_screens/payment_related/edit_bank_account.dart';
import 'package:nzcu_driver/views/profile_screens/payment_related/edit_upi.dart';

class MoneyTransferScreen extends StatefulWidget {
  const MoneyTransferScreen({super.key});

  @override
  State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  final GetBankAccountsController getBankAccountsController = Get.put(
    GetBankAccountsController(),
  );

  final PaymentsWithdrawController paymentsWithdrawController = Get.put(
    PaymentsWithdrawController(),
  );

  // Store selected bank account or UPI ID
  String? selectedAccountId;
  String? selectedAccountType; // "BankAccount" or "UPI"

  // Amount controller
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final UpdateBankAndUpiController updateBankAndUpiController;

  // Add loading state for delete operations
  bool _isDeletingBank = false;
  bool _isDeletingUpi = false;
  String? _deletingItemId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBankAccountsController.bankdetails_mdethod();
    });

    updateBankAndUpiController = Get.put(UpdateBankAndUpiController());
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
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
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        if (getBankAccountsController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
          );
        }

        final bankAccounts =
            getBankAccountsController.driveridresponse.value?.data ?? [];
        final hasBankAccounts = bankAccounts.isNotEmpty;

        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: w * .03,
              vertical: w * .04,
            ),
            children: [
              // Amount Input Field
              Container(
                    width: w,
                    padding: EdgeInsets.all(w * 0.04),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFonts.textPoppins(
                          context,
                          "Enter Amount",
                          w * 0.04,
                          FontWeight.w600,
                          AppColors.black,
                          TextAlign.left,
                          TextOverflow.ellipsis,
                        ),
                        SizedBox(height: w * 0.02),
                        TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.currency_rupee,
                              color: AppColors.primaryRed,
                              size: w * 0.05,
                            ),
                            hintText: "0",
                            hintStyle: TextStyle(
                              fontSize: w * 0.04,
                              color: AppColors.mediumGray,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.02),
                              borderSide: BorderSide(
                                color: AppColors.lightGray,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.02),
                              borderSide: BorderSide(
                                color: AppColors.lightGray,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.02),
                              borderSide: BorderSide(
                                color: AppColors.primaryRed,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid amount';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Amount must be greater than 0';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fade(duration: 820.ms, curve: Curves.easeInOut)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),

              SizedBox(height: w * 0.03),

              Padding(
                padding: EdgeInsets.only(bottom: w * .02),
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
                "Select Payment Method",
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
                                Get.to(() => AddBank())?.then((value) {
                                  if (value == true) {
                                    getBankAccountsController
                                        .bankdetails_mdethod();
                                    setState(() {
                                      selectedAccountId = null;
                                      selectedAccountType = null;
                                    });
                                  }
                                });
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
                      if (bankAccounts
                          .where((a) => a.type == "BankAccount")
                          .isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * .07,
                            vertical: w * .02,
                          ),
                          child: AppFonts.textPoppins(
                            context,
                            "No bank accounts added yet.",
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
                          itemCount: bankAccounts
                              .where((a) => a.type == "BankAccount")
                              .length,
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.lightGray,
                            height: w * 0.04,
                            indent: w * 0.07,
                            endIndent: w * 0.04,
                          ),
                          itemBuilder: (context, index) {
                            final bankAccountsList = bankAccounts
                                .where((a) => a.type == "BankAccount")
                                .toList();
                            final account = bankAccountsList[index];

                            final isSelected =
                                selectedAccountId == account.id &&
                                selectedAccountType == "BankAccount";

                            final isDeletingThis =
                                _isDeletingBank &&
                                _deletingItemId == account.id;

                            return GestureDetector(
                              onTap: () {
                                if (!isDeletingThis) {
                                  setState(() {
                                    if (isSelected) {
                                      // Deselect if already selected
                                      selectedAccountId = null;
                                      selectedAccountType = null;
                                    } else {
                                      // Select this bank account and deselect any UPI
                                      selectedAccountId = account.id;
                                      selectedAccountType = "BankAccount";
                                    }
                                  });
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * .04,
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

                                    SizedBox(width: w * 0.02),

                                    // Bank Account Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Account Holder Name
                                          Row(
                                            children: [
                                              AppFonts.textPoppins(
                                                context,
                                                account.accountHolderName ??
                                                    "N/A",
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
                                                    color: AppColors.primaryRed
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
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
                                            _maskAccountNumber(
                                              account.accountNumber,
                                            ),
                                            w * 0.030,
                                            FontWeight.w400,
                                            AppColors.darkGray,
                                            TextAlign.left,
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Edit and Delete Icons
                                    Row(
                                      children: [
                                        // Edit Button
                                        InkWell(
                                          onTap: isDeletingThis
                                              ? null
                                              : () {
                                                  Get.to(
                                                    () => EditBank(
                                                      account: account,
                                                      account_id: account.id,
                                                    ),
                                                  )?.then((value) {
                                                    if (value == true) {
                                                      getBankAccountsController
                                                          .bankdetails_mdethod();
                                                    }
                                                  });
                                                },
                                          child: Container(
                                            padding: EdgeInsets.all(w * 0.02),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryRed
                                                  .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              size: w * 0.04,
                                              color: isDeletingThis
                                                  ? AppColors.mediumGray
                                                  : AppColors.primaryRed,
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 5),

                                        // Delete Button - FIXED: Now calls delete function instead of edit screen
                                        InkWell(
                                          onTap: isDeletingThis
                                              ? null
                                              : () {
                                                  _deleteBankAccount(
                                                    account,
                                                    account.id,
                                                  );
                                                },
                                          child: Container(
                                            padding: EdgeInsets.all(w * 0.02),
                                            decoration: BoxDecoration(
                                              color: isDeletingThis
                                                  ? AppColors.lightGray
                                                  : Colors.red.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: isDeletingThis
                                                ? SizedBox(
                                                    width: w * 0.04,
                                                    height: w * 0.04,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.red,
                                                        ),
                                                  )
                                                : Icon(
                                                    Icons.delete,
                                                    size: w * 0.04,
                                                    color: Colors.red,
                                                  ),
                                          ),
                                        ),
                                      ],
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
                                Get.to(() => AddUpi())?.then((value) {
                                  if (value == true) {
                                    getBankAccountsController
                                        .bankdetails_mdethod();
                                    setState(() {
                                      selectedAccountId = null;
                                      selectedAccountType = null;
                                    });
                                  }
                                });
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
                      if (bankAccounts.where((a) => a.type == "UPI").isEmpty)
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
                        )
                      else
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: bankAccounts
                              .where((a) => a.type == "UPI")
                              .length,
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.lightGray,
                            height: w * 0.04,
                            indent: w * 0.07,
                            endIndent: w * 0.04,
                          ),
                          itemBuilder: (context, index) {
                            final upiAccounts = bankAccounts
                                .where((a) => a.type == "UPI")
                                .toList();
                            final account = upiAccounts[index];
                            final isSelected =
                                selectedAccountId == account.id &&
                                selectedAccountType == "UPI";

                            final isDeletingThis =
                                _isDeletingUpi && _deletingItemId == account.id;

                            return GestureDetector(
                              onTap: () {
                                if (!isDeletingThis) {
                                  setState(() {
                                    if (isSelected) {
                                      // Deselect if already selected
                                      selectedAccountId = null;
                                      selectedAccountType = null;
                                    } else {
                                      // Select this UPI and deselect any bank account
                                      selectedAccountId = account.id;
                                      selectedAccountType = "UPI";
                                    }
                                  });
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * .04,
                                  vertical: w * .01,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                      ),
                                      child: Container(
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
                                    ),
                                    SizedBox(width: w * 0.02),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              AppFonts.textPoppins(
                                                context,
                                                account.accountHolderName ??
                                                    "N/A",
                                                w * 0.032,
                                                FontWeight.w500,
                                                isSelected
                                                    ? AppColors.primaryRed
                                                    : AppColors.black,
                                                TextAlign.left,
                                                TextOverflow.ellipsis,
                                              ),
                                              if (isSelected)
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: w * 0.00,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.02,
                                                    vertical: w * 0.005,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primaryRed
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
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
                                          AppFonts.textPoppins(
                                            context,
                                            account.upiId ?? "N/A",
                                            w * 0.030,
                                            FontWeight.w400,
                                            AppColors.darkGray,
                                            TextAlign.left,
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Edit and Delete Icons for UPI
                                    Row(
                                      children: [
                                        // Edit Button
                                        InkWell(
                                          onTap: isDeletingThis
                                              ? null
                                              : () {
                                                  Get.to(
                                                    () => EditUpi(
                                                      account: account,
                                                      account_id: account.id,
                                                    ),
                                                  )?.then((value) {
                                                    if (value == true) {
                                                      getBankAccountsController
                                                          .bankdetails_mdethod();
                                                    }
                                                  });
                                                },
                                          child: Container(
                                            padding: EdgeInsets.all(w * 0.02),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryRed
                                                  .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              size: w * 0.04,
                                              color: isDeletingThis
                                                  ? AppColors.mediumGray
                                                  : AppColors.primaryRed,
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 5),

                                        // Delete Button - FIXED: Removed duplicate navigation
                                        InkWell(
                                          onTap: isDeletingThis
                                              ? null
                                              : () {
                                                  _deleteUpi(
                                                    account,
                                                    account.id,
                                                  );
                                                },
                                          child: Container(
                                            padding: EdgeInsets.all(w * 0.02),
                                            decoration: BoxDecoration(
                                              color: isDeletingThis
                                                  ? AppColors.lightGray
                                                  : Colors.red.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: isDeletingThis
                                                ? SizedBox(
                                                    width: w * 0.04,
                                                    height: w * 0.04,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.red,
                                                        ),
                                                  )
                                                : Icon(
                                                    Icons.delete,
                                                    size: w * 0.04,
                                                    color: Colors.red,
                                                  ),
                                          ),
                                        ),
                                      ],
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

              SizedBox(height: w * .1),

              // Transfer Button
              AppButtons.solid(
                context: context,
                text: "Transfer",
                onClicked: () {
                  // Validate form
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  if (!hasBankAccounts) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please add a bank account or UPI ID first',
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  if (selectedAccountId == null ||
                      selectedAccountType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select a bank account or UPI ID to transfer to',
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  // Get the selected account details
                  final selectedAccount = bankAccounts.firstWhere(
                    (account) => account.id == selectedAccountId,
                  );

                  // Show confirmation dialog
                  _showTransferConfirmationDialog(
                    context,
                    w,
                    selectedAccount,
                    amountController.text,
                  );
                },
                isFullWidth: true,
                backgroundColor: AppColors.primaryRed,
                textColor: AppColors.white,
                fontSize: w * .045,
                height: w * .140,
                radius: 12.0,
              ),
            ],
          ),
        );
      }),
    );
  }

  String _maskAccountNumber(String? accountNumber) {
    if (accountNumber == null || accountNumber.isEmpty) return "N/A";
    if (accountNumber.length <= 4) return accountNumber;

    final maskedPart = '*' * (accountNumber.length - 4);
    final lastFour = accountNumber.substring(accountNumber.length - 4);
    return "$maskedPart$lastFour";
  }

  void _showTransferConfirmationDialog(
    BuildContext context,
    double w,
    BankAccount selectedAccount,
    String amount,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              selectedAccount.type == "UPI"
                  ? Icons.payment
                  : Icons.account_balance,
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
              "Are you sure you want to transfer ₹$amount to:",
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
                  if (selectedAccount.type == "UPI") ...[
                    AppFonts.textPoppins(
                      context,
                      "UPI ID: ${selectedAccount.upiId}",
                      w * 0.030,
                      FontWeight.w500,
                      AppColors.darkGray,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    AppFonts.textPoppins(
                      context,
                      selectedAccount.bankName ?? "N/A",
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

              print("=== Transfer Details ===");
              print("Selected Account ID: ${selectedAccount.id}");
              print("Account Type: ${selectedAccount.type}");
              print("Amount: $amount");
              print("Account Holder: ${selectedAccount.accountHolderName}");
              if (selectedAccount.type == "UPI") {
                print("UPI ID: ${selectedAccount.upiId}");
              } else {
                print("Bank Name: ${selectedAccount.bankName}");
                print("Account Number: ${selectedAccount.accountNumber}");
                print("IFSC Code: ${selectedAccount.ifscCode}");
              }
              print("========================");

              paymentsWithdrawController.withdrawal_method(
                BankAccountId: selectedAccount.id,
                amount: amount,
              );
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

  // NEW METHOD: Delete Bank Account
  Future<void> _deleteBankAccount(account, account_id) async {
    // Show confirmation dialog
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double w = MediaQuery.of(context).size.width;
        return AlertDialog(
          title: Text(
            "Delete Bank Account",
            style: TextStyle(
              fontSize: w * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to delete this bank account?",
                style: TextStyle(fontSize: w * 0.04),
              ),
              SizedBox(height: w * 0.03),
              Container(
                padding: EdgeInsets.all(w * 0.03),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account?.accountHolderName ?? 'N/A',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: w * 0.01),
                    Text(
                      account?.bankName ?? 'N/A',
                      style: TextStyle(
                        fontSize: w * 0.035,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      _maskAccountNumber(account?.accountNumber),
                      style: TextStyle(
                        fontSize: w * 0.035,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: w * 0.02),
              Text(
                "This action cannot be undone.",
                style: TextStyle(
                  fontSize: w * 0.035,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: w * 0.04,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete != true) return;

    setState(() {
      _isDeletingBank = true;
      _deletingItemId = account_id;
    });

    try {
      print("Deleting Bank Account with accountid: ${account_id}");

      await updateBankAndUpiController.delete_bank_upi_method(
        accountid: account_id,
      );

      if (mounted) {
        // Clear selection if this was the selected account
        if (selectedAccountId == account_id) {
          setState(() {
            selectedAccountId = null;
            selectedAccountType = null;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bank account deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Refresh the list
        getBankAccountsController.bankdetails_mdethod();
      }
    } catch (e) {
      print("Error in _deleteBankAccount: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete bank account: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingBank = false;
          _deletingItemId = null;
        });
      }
    }
  }

  // FIXED METHOD: Delete UPI
  Future<void> _deleteUpi(account, account_id) async {
    // Show confirmation dialog
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double w = MediaQuery.of(context).size.width;
        return AlertDialog(
          title: Text(
            "Delete UPI ID",
            style: TextStyle(
              fontSize: w * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to delete this UPI ID?",
                style: TextStyle(fontSize: w * 0.04),
              ),
              SizedBox(height: w * 0.03),
              Container(
                padding: EdgeInsets.all(w * 0.03),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.payment, color: Colors.red, size: w * 0.05),
                    SizedBox(width: w * 0.02),
                    Expanded(
                      child: Text(
                        account?.upiId ?? 'N/A',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: w * 0.02),
              Text(
                "This action cannot be undone.",
                style: TextStyle(
                  fontSize: w * 0.035,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: w * 0.04,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete != true) return;

    setState(() {
      _isDeletingUpi = true;
      _deletingItemId = account_id;
    });

    try {
      print("Deleting UPI with accountid: ${account_id}");

      await updateBankAndUpiController.delete_bank_upi_method(
        accountid: account_id,
      );

      if (mounted) {
        // Clear selection if this was the selected account
        if (selectedAccountId == account_id) {
          setState(() {
            selectedAccountId = null;
            selectedAccountType = null;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('UPI ID deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Refresh the list
        getBankAccountsController.bankdetails_mdethod();
      }
    } catch (e) {
      print("Error in _deleteUpi: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete UPI ID: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingUpi = false;
          _deletingItemId = null;
        });
      }
    }
  }
}
