// // // // // import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
// // // // // import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// // // // // import 'package:nzcu_driver/utilities/colors/colors.dart';
// // // // // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // // // // import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// // // // // import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// // // // // import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// // // // // import 'package:nzcu_driver/utilities/widgets/form_field.dart';
// // // // // import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:get/get_core/src/get_main.dart';
// // // // // import 'package:get/get_instance/src/extension_instance.dart';

// // // // // class EditUpi extends StatefulWidget {
// // // // //   dynamic account;
// // // // //  dynamic account_id;
// // // // //    EditUpi({super.key, required this.account, required this.account_id});

// // // // //   @override
// // // // //   State<EditUpi> createState() => _EditUpiState();
// // // // // }

// // // // // class _EditUpiState extends State<EditUpi> {
// // // // //   final BankAccountAddController bankAccountAddController =
// // // // //       Get.find<BankAccountAddController>();

// // // // //   TextEditingController upiIdController = TextEditingController();

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     double w = MediaQuery.of(context).size.width;
// // // // //     return Scaffold(
// // // // //       backgroundColor: ColorsList.scaffoldColor,
// // // // //       resizeToAvoidBottomInset: true,
// // // // //       appBar: AppBar(
// // // // //         backgroundColor: ColorsList.scaffoldColor,
// // // // //         automaticallyImplyLeading: false,
// // // // //         scrolledUnderElevation: 0,
// // // // //         elevation: 0,
// // // // //         titleSpacing: w * .03,
// // // // //         title: Row(
// // // // //           children: [
// // // // //             GestureDetector(
// // // // //               onTap: () {
// // // // //                 CustomNavigator.pop(context);
// // // // //               },
// // // // //               child: Icon(
// // // // //                 Icons.arrow_back,
// // // // //                 size: w * .07,
// // // // //                 color: ColorsList.iconColor,
// // // // //               ),
// // // // //             ),
// // // // //             SizedBox(width: w * .035),
// // // // //             CustomText(
// // // // //               text: "Add UPI",
// // // // //               textColor: ColorsList.titleTextColor,
// // // // //               textFontSize: w * .05,
// // // // //               textFontWeight: FontWeight.w500,
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //       body: Padding(
// // // // //         padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
// // // // //         child: SingleChildScrollView(
// // // // //           padding: EdgeInsets.only(
// // // // //             bottom: MediaQuery.of(context).viewInsets.bottom,
// // // // //           ),
// // // // //           child: Column(
// // // // //             // crossAxisAlignment: CrossAxisAlignment.center,
// // // // //             children: [
// // // // //               Image.asset(
// // // // //                 "assets/images/upi_image.png",
// // // // //                 width: 300,
// // // // //                 height: 300,
// // // // //               ),
// // // // //               AppFonts.textPoppins(
// // // // //                 context,
// // // // //                 "UPI ID",
// // // // //                 w * 0.046,
// // // // //                 FontWeight.w600,
// // // // //                 AppColors.black,
// // // // //                 TextAlign.center,
// // // // //                 TextOverflow.ellipsis,
// // // // //               ),
// // // // //               Padding(
// // // // //                 padding: EdgeInsets.only(top: w * .03, bottom: w * .02),
// // // // //                 child: AppFormFields.custTextFormOther(
// // // // //                   context: context,
// // // // //                   hintText: "Example: abcdef@phonepe",

// // // // //                   controller: upiIdController,
// // // // //                   keyboardType: TextInputType.text,
// // // // //                 ),
// // // // //               ),
// // // // //               Container(
// // // // //                 width: w,
// // // // //                 color: Color.fromRGBO(240, 247, 255, 1),
// // // // //                 child: Padding(
// // // // //                   padding: EdgeInsets.symmetric(
// // // // //                     horizontal: w * .02,
// // // // //                     vertical: w * .02,
// // // // //                   ),
// // // // //                   child: Row(
// // // // //                     mainAxisAlignment: MainAxisAlignment.start,
// // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                     children: [
// // // // //                       CustomImages.images(
// // // // //                         "assets/icons/addupiIcon1.png",
// // // // //                         w * .06,
// // // // //                         w * .06,
// // // // //                       ),

// // // // //                       Padding(
// // // // //                         padding: EdgeInsets.symmetric(horizontal: w * .015),
// // // // //                         child: SizedBox(
// // // // //                           width: w * .8,
// // // // //                           //  color: Colors.amber,
// // // // //                           child: AppFonts.textPoppins(
// // // // //                             context,
// // // // //                             "Please enter the UPI details carefully and don’t worry, it is 100% safe!",
// // // // //                             w * 0.026,
// // // // //                             FontWeight.w500,
// // // // //                             ColorsList.linksTextColor,
// // // // //                             TextAlign.start,
// // // // //                             TextOverflow.ellipsis,
// // // // //                             maxLines: 2,
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //               ),

// // // // //               // remove Spacer() to avoid unbounded height inside scroll view
// // // // //               SizedBox(height: w * .45),
// // // // //               AppButtons.solid(
// // // // //                 context: context,
// // // // //                 text: "Update",
// // // // //                 onClicked: () {
// // // // //                   bankAccountAddController.addbankaccount_method(
// // // // //                     bankName: "",
// // // // //                     accountNumber: "",
// // // // //                     accountHolderName: "",
// // // // //                     ifscCode: "",
// // // // //                     type: "UPI",
// // // // //                     upiId: upiIdController.text,
// // // // //                     context: context,
// // // // //                   );
// // // // //                 },
// // // // //                 isFullWidth: true,
// // // // //                 // backgroundColor: AppColors.lightGray,
// // // // //                 backgroundColor: Colors.cyan.shade300,
// // // // //                 textColor: AppColors.white,
// // // // //                 fontSize: w * .045,
// // // // //                 height: w * .140,
// // // // //                 radius: 12.0,
// // // // //               ),
// // // // //               SizedBox(height: w * .1),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
// // // // import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// // // // import 'package:nzcu_driver/utilities/colors/colors.dart';
// // // // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // // // import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// // // // import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// // // // import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// // // // import 'package:nzcu_driver/utilities/widgets/form_field.dart';
// // // // import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';

// // // // class EditUpi extends StatefulWidget {
// // // //   final dynamic account;
// // // //   final dynamic account_id;

// // // //   const EditUpi({super.key, required this.account, required this.account_id});

// // // //   @override
// // // //   State<EditUpi> createState() => _EditUpiState();
// // // // }

// // // // class _EditUpiState extends State<EditUpi> {
// // // //   final BankAccountAddController bankAccountAddController =
// // // //       Get.find<BankAccountAddController>();

// // // //   late TextEditingController upiIdController;
// // // //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     // Initialize controller with existing UPI ID
// // // //     upiIdController = TextEditingController(text: widget.account?.upiId ?? "");
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     upiIdController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     double w = MediaQuery.of(context).size.width;
// // // //     return Scaffold(
// // // //       backgroundColor: ColorsList.scaffoldColor,
// // // //       resizeToAvoidBottomInset: true,
// // // //       appBar: AppBar(
// // // //         backgroundColor: ColorsList.scaffoldColor,
// // // //         automaticallyImplyLeading: false,
// // // //         scrolledUnderElevation: 0,
// // // //         elevation: 0,
// // // //         titleSpacing: w * .03,
// // // //         title: Row(
// // // //           children: [
// // // //             GestureDetector(
// // // //               onTap: () {
// // // //                 CustomNavigator.pop(context);
// // // //               },
// // // //               child: Icon(
// // // //                 Icons.arrow_back,
// // // //                 size: w * .07,
// // // //                 color: ColorsList.iconColor,
// // // //               ),
// // // //             ),
// // // //             SizedBox(width: w * .035),
// // // //             CustomText(
// // // //               text: "Edit UPI",
// // // //               textColor: ColorsList.titleTextColor,
// // // //               textFontSize: w * .05,
// // // //               textFontWeight: FontWeight.w500,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //       body: Form(
// // // //         key: _formKey,
// // // //         child: Padding(
// // // //           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
// // // //           child: SingleChildScrollView(
// // // //             padding: EdgeInsets.only(
// // // //               bottom: MediaQuery.of(context).viewInsets.bottom,
// // // //             ),
// // // //             child: Column(
// // // //               children: [
// // // //                 Image.asset(
// // // //                   "assets/images/upi_image.png",
// // // //                   width: 300,
// // // //                   height: 300,
// // // //                 ),
// // // //                 AppFonts.textPoppins(
// // // //                   context,
// // // //                   "Edit UPI ID",
// // // //                   w * 0.046,
// // // //                   FontWeight.w600,
// // // //                   AppColors.black,
// // // //                   TextAlign.center,
// // // //                   TextOverflow.ellipsis,
// // // //                 ),

// // // //                 // Show current UPI ID being edited
// // // //                 Container(
// // // //                   margin: EdgeInsets.symmetric(vertical: w * 0.02),
// // // //                   padding: EdgeInsets.all(w * 0.03),
// // // //                   decoration: BoxDecoration(
// // // //                     color: AppColors.primaryRed.withOpacity(0.1),
// // // //                     borderRadius: BorderRadius.circular(w * 0.02),
// // // //                     border: Border.all(
// // // //                       color: AppColors.primaryRed.withOpacity(0.3),
// // // //                     ),
// // // //                   ),
// // // //                   child: Row(
// // // //                     children: [
// // // //                       Icon(
// // // //                         Icons.info_outline,
// // // //                         color: AppColors.primaryRed,
// // // //                         size: w * 0.05,
// // // //                       ),
// // // //                       SizedBox(width: w * 0.02),
// // // //                       Expanded(
// // // //                         child: AppFonts.textPoppins(
// // // //                           context,
// // // //                           "Editing: ${widget.account?.upiId ?? 'N/A'}",
// // // //                           w * 0.032,
// // // //                           FontWeight.w500,
// // // //                           AppColors.primaryRed,
// // // //                           TextAlign.left,
// // // //                           TextOverflow.ellipsis,
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),

// // // //                 Padding(
// // // //                   padding: EdgeInsets.only(top: w * .03, bottom: w * .02),
// // // //                   child: AppFormFields.custTextFormOther(
// // // //                     context: context,
// // // //                     hintText: "Example: abcdef@phonepe",
// // // //                     // labelText: "UPI ID",
// // // //                     controller: upiIdController,
// // // //                     keyboardType: TextInputType.text,
// // // //                     validator: (value) {
// // // //                       if (value == null || value.isEmpty) {
// // // //                         return 'Please enter UPI ID';
// // // //                       }
// // // //                       if (!value.contains('@')) {
// // // //                         return 'Please enter a valid UPI ID';
// // // //                       }
// // // //                       return null;
// // // //                     },
// // // //                   ),
// // // //                 ),

// // // //                 Container(
// // // //                   width: w,
// // // //                   color: Color.fromRGBO(240, 247, 255, 1),
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.symmetric(
// // // //                       horizontal: w * .02,
// // // //                       vertical: w * .02,
// // // //                     ),
// // // //                     child: Row(
// // // //                       mainAxisAlignment: MainAxisAlignment.start,
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         CustomImages.images(
// // // //                           "assets/icons/addupiIcon1.png",
// // // //                           w * .06,
// // // //                           w * .06,
// // // //                         ),
// // // //                         Padding(
// // // //                           padding: EdgeInsets.symmetric(horizontal: w * .015),
// // // //                           child: SizedBox(
// // // //                             width: w * .8,
// // // //                             child: AppFonts.textPoppins(
// // // //                               context,
// // // //                               "Please enter the UPI details carefully and don't worry, it is 100% safe!",
// // // //                               w * 0.026,
// // // //                               FontWeight.w500,
// // // //                               ColorsList.linksTextColor,
// // // //                               TextAlign.start,
// // // //                               TextOverflow.visible,
// // // //                               maxLines: 3,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),

// // // //                 SizedBox(height: w * .3),

// // // //                 // Update Button
// // // //                 AppButtons.solid(
// // // //                   context: context,
// // // //                   text: "Update UPI",
// // // //                   onClicked: () {
// // // //                     if (_formKey.currentState!.validate()) {
// // // //                       _showUpdateConfirmationDialog(context, w);
// // // //                     }
// // // //                   },
// // // //                   isFullWidth: true,
// // // //                   backgroundColor: AppColors.primaryRed,
// // // //                   textColor: AppColors.white,
// // // //                   fontSize: w * .045,
// // // //                   height: w * .140,
// // // //                   radius: 12.0,
// // // //                 ),

// // // //                 // Cancel Button
// // // //                 SizedBox(height: w * .02),
// // // //                 AppButtons.solid(
// // // //                   context: context,
// // // //                   text: "Cancel",
// // // //                   onClicked: () {
// // // //                     CustomNavigator.pop(context);
// // // //                   },
// // // //                   isFullWidth: true,
// // // //                   // borderColor: AppColors.mediumGray,
// // // //                   textColor: AppColors.mediumGray,
// // // //                   fontSize: w * .045,
// // // //                   height: w * .140,
// // // //                   radius: 12.0,
// // // //                 ),

// // // //                 SizedBox(height: w * .1),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _showUpdateConfirmationDialog(BuildContext context, double w) {
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) => AlertDialog(
// // // //         title: Row(
// // // //           children: [
// // // //             Icon(
// // // //               Icons.edit,
// // // //               color: AppColors.primaryRed,
// // // //               size: w * 0.06,
// // // //             ),
// // // //             SizedBox(width: w * 0.02),
// // // //             AppFonts.textPoppins(
// // // //               context,
// // // //               "Confirm Update",
// // // //               w * 0.04,
// // // //               FontWeight.w600,
// // // //               AppColors.black,
// // // //               TextAlign.left,
// // // //               TextOverflow.ellipsis,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         content: Column(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             AppFonts.textPoppins(
// // // //               context,
// // // //               "Are you sure you want to update this UPI ID?",
// // // //               w * 0.032,
// // // //               FontWeight.w500,
// // // //               AppColors.darkGray,
// // // //               TextAlign.left,
// // // //               TextOverflow.visible,
// // // //             ),
// // // //             SizedBox(height: w * 0.02),
// // // //             Container(
// // // //               padding: EdgeInsets.all(w * 0.03),
// // // //               decoration: BoxDecoration(
// // // //                 color: AppColors.lightGray.withOpacity(0.3),
// // // //                 borderRadius: BorderRadius.circular(w * 0.02),
// // // //               ),
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   AppFonts.textPoppins(
// // // //                     context,
// // // //                     "Account Holder: ${widget.account?.accountHolderName ?? 'N/A'}",
// // // //                     w * 0.03,
// // // //                     FontWeight.w500,
// // // //                     AppColors.black,
// // // //                     TextAlign.left,
// // // //                     TextOverflow.ellipsis,
// // // //                   ),
// // // //                   SizedBox(height: w * 0.01),
// // // //                   Row(
// // // //                     children: [
// // // //                       AppFonts.textPoppins(
// // // //                         context,
// // // //                         "Old UPI: ",
// // // //                         w * 0.03,
// // // //                         FontWeight.w400,
// // // //                         AppColors.darkGray,
// // // //                         TextAlign.left,
// // // //                         TextOverflow.ellipsis,
// // // //                       ),
// // // //                       AppFonts.textPoppins(
// // // //                         context,
// // // //                         widget.account?.upiId ?? 'N/A',
// // // //                         w * 0.03,
// // // //                         FontWeight.w500,
// // // //                         Colors.red,
// // // //                         TextAlign.left,
// // // //                         TextOverflow.ellipsis,
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                   SizedBox(height: w * 0.005),
// // // //                   Row(
// // // //                     children: [
// // // //                       AppFonts.textPoppins(
// // // //                         context,
// // // //                         "New UPI: ",
// // // //                         w * 0.03,
// // // //                         FontWeight.w400,
// // // //                         AppColors.darkGray,
// // // //                         TextAlign.left,
// // // //                         TextOverflow.ellipsis,
// // // //                       ),
// // // //                       AppFonts.textPoppins(
// // // //                         context,
// // // //                         upiIdController.text,
// // // //                         w * 0.03,
// // // //                         FontWeight.w500,
// // // //                         Colors.green,
// // // //                         TextAlign.left,
// // // //                         TextOverflow.ellipsis,
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             SizedBox(height: w * 0.02),
// // // //             AppFonts.textPoppins(
// // // //               context,
// // // //               "Note: This action will update your UPI ID.",
// // // //               w * 0.028,
// // // //               FontWeight.w400,
// // // //               AppColors.mediumGray,
// // // //               TextAlign.left,
// // // //               TextOverflow.visible,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.pop(context),
// // // //             child: AppFonts.textPoppins(
// // // //               context,
// // // //               "Cancel",
// // // //               w * 0.035,
// // // //               FontWeight.w500,
// // // //               AppColors.darkGray,
// // // //               TextAlign.center,
// // // //               TextOverflow.ellipsis,
// // // //             ),
// // // //           ),
// // // //           ElevatedButton(
// // // //             style: ElevatedButton.styleFrom(
// // // //               backgroundColor: AppColors.primaryRed,
// // // //               shape: RoundedRectangleBorder(
// // // //                 borderRadius: BorderRadius.circular(8),
// // // //               ),
// // // //             ),
// // // //             onPressed: () {
// // // //               Navigator.pop(context);

// // // //               // Call update API here
// // // //               print("=== Update UPI ===");
// // // //               print("Account ID: ${widget.account_id}");
// // // //               print("Old UPI ID: ${widget.account?.upiId}");
// // // //               print("New UPI ID: ${upiIdController.text}");
// // // //               print("Account Holder: ${widget.account?.accountHolderName}");

// // // //               // Show loading
// // // //               Get.dialog(
// // // //                 Center(
// // // //                   child: CircularProgressIndicator(color: AppColors.primaryRed),
// // // //                 ),
// // // //                 barrierDismissible: false,
// // // //               );

// // // //               // Simulate API call
// // // //               Future.delayed(Duration(seconds: 2), () {
// // // //                 Get.back(); // Close loading dialog

// // // //                 // Show success message
// // // //                 Get.snackbar(
// // // //                   'Success',
// // // //                   'UPI ID updated successfully',
// // // //                   snackPosition: SnackPosition.BOTTOM,
// // // //                   backgroundColor: Colors.green,
// // // //                   colorText: Colors.white,
// // // //                   duration: Duration(seconds: 2),
// // // //                 );

// // // //                 // Return true to refresh the list
// // // //                 // CustomNavigator.pop(context, true);
// // // //               });
// // // //             },
// // // //             child: AppFonts.textPoppins(
// // // //               context,
// // // //               "Confirm Update",
// // // //               w * 0.035,
// // // //               FontWeight.w500,
// // // //               AppColors.white,
// // // //               TextAlign.center,
// // // //               TextOverflow.ellipsis,
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
// // // import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// // // import 'package:nzcu_driver/utilities/colors/colors.dart';
// // // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // // import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// // // import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// // // import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// // // import 'package:nzcu_driver/utilities/widgets/form_field.dart';
// // // import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';

// // // class EditUpi extends StatefulWidget {
// // //   final dynamic account;
// // //   final dynamic account_id;

// // //   const EditUpi({super.key, required this.account, required this.account_id});

// // //   @override
// // //   State<EditUpi> createState() => _EditUpiState();
// // // }

// // // class _EditUpiState extends State<EditUpi> {
// // //   final BankAccountAddController bankAccountAddController =
// // //       Get.find<BankAccountAddController>();

// // //   late TextEditingController upiIdController;
// // //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     // Initialize controller with existing UPI ID
// // //     upiIdController = TextEditingController(text: widget.account?.upiId ?? "");
// // //   }

// // //   @override
// // //   void dispose() {
// // //     upiIdController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double w = MediaQuery.of(context).size.width;
// // //     return Scaffold(
// // //       backgroundColor: ColorsList.scaffoldColor,
// // //       resizeToAvoidBottomInset: true,
// // //       appBar: AppBar(
// // //         backgroundColor: ColorsList.scaffoldColor,
// // //         automaticallyImplyLeading: false,
// // //         scrolledUnderElevation: 0,
// // //         elevation: 0,
// // //         titleSpacing: w * .03,
// // //         title: Row(
// // //           children: [
// // //             GestureDetector(
// // //               onTap: () {
// // //                 CustomNavigator.pop(context);
// // //               },
// // //               child: Icon(
// // //                 Icons.arrow_back,
// // //                 size: w * .07,
// // //                 color: ColorsList.iconColor,
// // //               ),
// // //             ),
// // //             SizedBox(width: w * .035),
// // //             CustomText(
// // //               text: "Edit UPI",
// // //               textColor: ColorsList.titleTextColor,
// // //               textFontSize: w * .05,
// // //               textFontWeight: FontWeight.w500,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       body: Form(
// // //         key: _formKey,
// // //         child: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
// // //           child: SingleChildScrollView(
// // //             padding: EdgeInsets.only(
// // //               bottom: MediaQuery.of(context).viewInsets.bottom,
// // //             ),
// // //             child: Column(
// // //               children: [
// // //                 Image.asset(
// // //                   "assets/images/upi_image.png",
// // //                   width: 300,
// // //                   height: 300,
// // //                 ),
// // //                 AppFonts.textPoppins(
// // //                   context,
// // //                   "Edit UPI ID",
// // //                   w * 0.046,
// // //                   FontWeight.w600,
// // //                   AppColors.black,
// // //                   TextAlign.center,
// // //                   TextOverflow.ellipsis,
// // //                 ),

// // //                 // Show current UPI ID being edited
// // //                 Container(
// // //                   margin: EdgeInsets.symmetric(vertical: w * 0.02),
// // //                   padding: EdgeInsets.all(w * 0.03),
// // //                   decoration: BoxDecoration(
// // //                     color: AppColors.primaryRed.withOpacity(0.1),
// // //                     borderRadius: BorderRadius.circular(w * 0.02),
// // //                     border: Border.all(
// // //                       color: AppColors.primaryRed.withOpacity(0.3),
// // //                     ),
// // //                   ),
// // //                   child: Row(
// // //                     children: [
// // //                       Icon(
// // //                         Icons.info_outline,
// // //                         color: AppColors.primaryRed,
// // //                         size: w * 0.05,
// // //                       ),
// // //                       SizedBox(width: w * 0.02),
// // //                       Expanded(
// // //                         child: AppFonts.textPoppins(
// // //                           context,
// // //                           "Editing: ${widget.account?.upiId ?? 'N/A'}",
// // //                           w * 0.032,
// // //                           FontWeight.w500,
// // //                           AppColors.primaryRed,
// // //                           TextAlign.left,
// // //                           TextOverflow.ellipsis,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),

// // //                 Padding(
// // //                   padding: EdgeInsets.only(top: w * .03, bottom: w * .02),
// // //                   child: AppFormFields.custTextFormOther(
// // //                     context: context,
// // //                     hintText: "Example: abcdef@phonepe",
// // //                     // labelText: "UPI ID",
// // //                     controller: upiIdController,
// // //                     keyboardType: TextInputType.text,
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return 'Please enter UPI ID';
// // //                       }
// // //                       if (!value.contains('@')) {
// // //                         return 'Please enter a valid UPI ID';
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                 ),

// // //                 Container(
// // //                   width: w,
// // //                   color: Color.fromRGBO(240, 247, 255, 1),
// // //                   child: Padding(
// // //                     padding: EdgeInsets.symmetric(
// // //                       horizontal: w * .02,
// // //                       vertical: w * .02,
// // //                     ),
// // //                     child: Row(
// // //                       mainAxisAlignment: MainAxisAlignment.start,
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         CustomImages.images(
// // //                           "assets/icons/addupiIcon1.png",
// // //                           w * .06,
// // //                           w * .06,
// // //                         ),
// // //                         Padding(
// // //                           padding: EdgeInsets.symmetric(horizontal: w * .015),
// // //                           child: SizedBox(
// // //                             width: w * .8,
// // //                             child: AppFonts.textPoppins(
// // //                               context,
// // //                               "Please enter the UPI details carefully and don't worry, it is 100% safe!",
// // //                               w * 0.026,
// // //                               FontWeight.w500,
// // //                               ColorsList.linksTextColor,
// // //                               TextAlign.start,
// // //                               TextOverflow.visible,
// // //                               maxLines: 3,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),

// // //                 SizedBox(height: w * .3),

// // //                 // Update Button
// // //                 AppButtons.solid(
// // //                   context: context,
// // //                   text: "Update UPI",
// // //                   onClicked: () {
// // //                     if (_formKey.currentState!.validate()) {
// // //                       _showUpdateConfirmationDialog(context, w);
// // //                     }
// // //                   },
// // //                   isFullWidth: true,
// // //                   backgroundColor: AppColors.primaryRed,
// // //                   textColor: AppColors.white,
// // //                   fontSize: w * .045,
// // //                   height: w * .140,
// // //                   radius: 12.0,
// // //                 ),

// // //                 // Cancel Button
// // //                 SizedBox(height: w * .02),
// // //                 AppButtons.solid(
// // //                   context: context,
// // //                   text: "Cancel",
// // //                   onClicked: () {
// // //                     CustomNavigator.pop(context);
// // //                   },
// // //                   isFullWidth: true,
// // //                   backgroundColor: AppColors.lightGray,
// // //                   textColor: AppColors.mediumGray,
// // //                   fontSize: w * .045,
// // //                   height: w * .140,
// // //                   radius: 12.0,
// // //                 ),

// // //                 SizedBox(height: w * .1),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _showUpdateConfirmationDialog(BuildContext context, double w) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: Row(
// // //           children: [
// // //             Icon(
// // //               Icons.edit,
// // //               color: AppColors.primaryRed,
// // //               size: w * 0.06,
// // //             ),
// // //             SizedBox(width: w * 0.02),
// // //             AppFonts.textPoppins(
// // //               context,
// // //               "Confirm Update",
// // //               w * 0.04,
// // //               FontWeight.w600,
// // //               AppColors.black,
// // //               TextAlign.left,
// // //               TextOverflow.ellipsis,
// // //             ),
// // //           ],
// // //         ),
// // //         content: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             AppFonts.textPoppins(
// // //               context,
// // //               "Are you sure you want to update this UPI ID?",
// // //               w * 0.032,
// // //               FontWeight.w500,
// // //               AppColors.darkGray,
// // //               TextAlign.left,
// // //               TextOverflow.visible,
// // //             ),
// // //             SizedBox(height: w * 0.02),
// // //             Container(
// // //               padding: EdgeInsets.all(w * 0.03),
// // //               decoration: BoxDecoration(
// // //                 color: AppColors.lightGray.withOpacity(0.3),
// // //                 borderRadius: BorderRadius.circular(w * 0.02),
// // //               ),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   AppFonts.textPoppins(
// // //                     context,
// // //                     "Account Holder: ${widget.account?.accountHolderName ?? 'N/A'}",
// // //                     w * 0.03,
// // //                     FontWeight.w500,
// // //                     AppColors.black,
// // //                     TextAlign.left,
// // //                     TextOverflow.ellipsis,
// // //                   ),
// // //                   SizedBox(height: w * 0.01),
// // //                   Row(
// // //                     children: [
// // //                       AppFonts.textPoppins(
// // //                         context,
// // //                         "Old UPI: ",
// // //                         w * 0.03,
// // //                         FontWeight.w400,
// // //                         AppColors.darkGray,
// // //                         TextAlign.left,
// // //                         TextOverflow.ellipsis,
// // //                       ),
// // //                       AppFonts.textPoppins(
// // //                         context,
// // //                         widget.account?.upiId ?? 'N/A',
// // //                         w * 0.03,
// // //                         FontWeight.w500,
// // //                         Colors.red,
// // //                         TextAlign.left,
// // //                         TextOverflow.ellipsis,
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   SizedBox(height: w * 0.005),
// // //                   Row(
// // //                     children: [
// // //                       AppFonts.textPoppins(
// // //                         context,
// // //                         "New UPI: ",
// // //                         w * 0.03,
// // //                         FontWeight.w400,
// // //                         AppColors.darkGray,
// // //                         TextAlign.left,
// // //                         TextOverflow.ellipsis,
// // //                       ),
// // //                       AppFonts.textPoppins(
// // //                         context,
// // //                         upiIdController.text,
// // //                         w * 0.03,
// // //                         FontWeight.w500,
// // //                         Colors.green,
// // //                         TextAlign.left,
// // //                         TextOverflow.ellipsis,
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //             SizedBox(height: w * 0.02),
// // //             AppFonts.textPoppins(
// // //               context,
// // //               "Note: This action will update your UPI ID.",
// // //               w * 0.028,
// // //               FontWeight.w400,
// // //               AppColors.mediumGray,
// // //               TextAlign.left,
// // //               TextOverflow.visible,
// // //             ),
// // //           ],
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context),
// // //             child: AppFonts.textPoppins(
// // //               context,
// // //               "Cancel",
// // //               w * 0.035,
// // //               FontWeight.w500,
// // //               AppColors.darkGray,
// // //               TextAlign.center,
// // //               TextOverflow.ellipsis,
// // //             ),
// // //           ),
// // //           ElevatedButton(
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: AppColors.primaryRed,
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(8),
// // //               ),
// // //             ),
// // //             onPressed: () async {
// // //               Navigator.pop(context); // Close confirmation dialog

// // //               // Show loading dialog
// // //               Get.dialog(
// // //                 Center(
// // //                   child: CircularProgressIndicator(color: AppColors.primaryRed),
// // //                 ),
// // //                 barrierDismissible: false,
// // //               );

// // //               try {
// // //                 // Get token from SharedPreferences
// // //                 final prefs = await SharedPreferences.getInstance();
// // //                 final String? token = prefs.getString("auth_token");

// // //                 // Create multipart request
// // //                 var request = http.MultipartRequest(
// // //                   'POST',
// // //                   Uri.parse('https://nzcu.smarttechbros.com/api/v1/bank-accounts/update/${widget.account_id}')
// // //                 );

// // //                 // Add headers
// // //                 request.headers['Authorization'] = 'Bearer $token';

// // //                 // Add form data
// // //                 request.fields['type'] = 'UPI';
// // //                 request.fields['upiId'] = upiIdController.text;

// // //                 // Send request
// // //                 var response = await request.send();
// // //                 var responseBody = await response.stream.bytesToString();

// // //                 // Close loading dialog
// // //                 Get.back();

// // //                 if (response.statusCode == 200) {
// // //                   // Success
// // //                   Get.snackbar(
// // //                     'Success',
// // //                     'UPI ID updated successfully',
// // //                     snackPosition: SnackPosition.BOTTOM,
// // //                     backgroundColor: Colors.green,
// // //                     colorText: Colors.white,
// // //                     duration: Duration(seconds: 2),
// // //                   );

// // //                   // Return true to refresh the list in MoneyTransferScreen
// // //                   CustomNavigator.pop(context, true);
// // //                 } else {
// // //                   // Error
// // //                   Get.snackbar(
// // //                     'Error',
// // //                     'Failed to update UPI ID. Status: ${response.statusCode}',
// // //                     snackPosition: SnackPosition.BOTTOM,
// // //                     backgroundColor: Colors.red,
// // //                     colorText: Colors.white,
// // //                     duration: Duration(seconds: 3),
// // //                   );
// // //                 }
// // //               } catch (e) {
// // //                 // Close loading dialog
// // //                 Get.back();

// // //                 // Handle network errors
// // //                 Get.snackbar(
// // //                   'Error',
// // //                   'Network error: $e',
// // //                   snackPosition: SnackPosition.BOTTOM,
// // //                   backgroundColor: Colors.red,
// // //                   colorText: Colors.white,
// // //                   duration: Duration(seconds: 3),
// // //                 );
// // //               }
// // //             },
// // //             child: AppFonts.textPoppins(
// // //               context,
// // //               "Confirm Update",
// // //               w * 0.035,
// // //               FontWeight.w500,
// // //               AppColors.white,
// // //               TextAlign.center,
// // //               TextOverflow.ellipsis,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
// // import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// // import 'package:nzcu_driver/utilities/colors/colors.dart';
// // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// // import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// // import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// // import 'package:nzcu_driver/utilities/widgets/form_field.dart';
// // import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';

// // class EditUpi extends StatefulWidget {
// //   final dynamic account;
// //   final dynamic account_id;

// //   const EditUpi({super.key, required this.account, required this.account_id});

// //   @override
// //   State<EditUpi> createState() => _EditUpiState();
// // }

// // class _EditUpiState extends State<EditUpi> {
// //   final BankAccountAddController bankAccountAddController =
// //       Get.find<BankAccountAddController>();

// //   late TextEditingController upiIdController;
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Initialize controller with existing UPI ID
// //     upiIdController = TextEditingController(text: widget.account?.upiId ?? "");
// //   }

// //   @override
// //   void dispose() {
// //     upiIdController.dispose();
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
// //                 Get.back();
// //               },
// //               child: Icon(
// //                 Icons.arrow_back,
// //                 size: w * .07,
// //                 color: ColorsList.iconColor,
// //               ),
// //             ),
// //             SizedBox(width: w * .035),
// //             CustomText(
// //               text: "Edit UPI",
// //               textColor: ColorsList.titleTextColor,
// //               textFontSize: w * .05,
// //               textFontWeight: FontWeight.w500,
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Form(
// //         key: _formKey,
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
// //           child: SingleChildScrollView(
// //             padding: EdgeInsets.only(
// //               bottom: MediaQuery.of(context).viewInsets.bottom,
// //             ),
// //             child: Column(
// //               children: [
// //                 Image.asset(
// //                   "assets/images/upi_image.png",
// //                   width: 300,
// //                   height: 300,
// //                 ),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   "Edit UPI ID",
// //                   w * 0.046,
// //                   FontWeight.w600,
// //                   AppColors.black,
// //                   TextAlign.center,
// //                   TextOverflow.ellipsis,
// //                 ),

// //                 // Show current UPI ID being edited
// //                 Container(
// //                   margin: EdgeInsets.symmetric(vertical: w * 0.02),
// //                   padding: EdgeInsets.all(w * 0.03),
// //                   decoration: BoxDecoration(
// //                     color: AppColors.primaryRed.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(w * 0.02),
// //                     border: Border.all(
// //                       color: AppColors.primaryRed.withOpacity(0.3),
// //                     ),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(
// //                         Icons.info_outline,
// //                         color: AppColors.primaryRed,
// //                         size: w * 0.05,
// //                       ),
// //                       SizedBox(width: w * 0.02),
// //                       Expanded(
// //                         child: AppFonts.textPoppins(
// //                           context,
// //                           "Editing: ${widget.account?.upiId ?? 'N/A'}",
// //                           w * 0.032,
// //                           FontWeight.w500,
// //                           AppColors.primaryRed,
// //                           TextAlign.left,
// //                           TextOverflow.ellipsis,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 Padding(
// //                   padding: EdgeInsets.only(top: w * .03, bottom: w * .02),
// //                   child: AppFormFields.custTextFormOther(
// //                     context: context,
// //                     hintText: "Example: abcdef@phonepe",
// //                     // labelText: "UPI ID",
// //                     controller: upiIdController,
// //                     keyboardType: TextInputType.text,
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter UPI ID';
// //                       }
// //                       if (!value.contains('@')) {
// //                         return 'Please enter a valid UPI ID';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 ),

// //                 Container(
// //                   width: w,
// //                   color: Color.fromRGBO(240, 247, 255, 1),
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(
// //                       horizontal: w * .02,
// //                       vertical: w * .02,
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         CustomImages.images(
// //                           "assets/icons/addupiIcon1.png",
// //                           w * .06,
// //                           w * .06,
// //                         ),
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: w * .015),
// //                           child: SizedBox(
// //                             width: w * .8,
// //                             child: AppFonts.textPoppins(
// //                               context,
// //                               "Please enter the UPI details carefully and don't worry, it is 100% safe!",
// //                               w * 0.026,
// //                               FontWeight.w500,
// //                               ColorsList.linksTextColor,
// //                               TextAlign.start,
// //                               TextOverflow.visible,
// //                               maxLines: 3,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 SizedBox(height: w * .3),

// //                 // Update Button
// //                 AppButtons.solid(
// //                   context: context,
// //                   text: "Update UPI",
// //                   onClicked: () {
// //                     if (_formKey.currentState!.validate()) {
// //                       _showUpdateConfirmationDialog(context, w);
// //                     }
// //                   },
// //                   isFullWidth: true,
// //                   backgroundColor: AppColors.primaryRed,
// //                   textColor: AppColors.white,
// //                   fontSize: w * .045,
// //                   height: w * .140,
// //                   radius: 12.0,
// //                 ),

// //                 // Cancel Button
// //                 SizedBox(height: w * .02),
// //                 AppButtons.solid(
// //                   context: context,
// //                   text: "Cancel",
// //                   onClicked: () {
// //                     Get.back();
// //                   },
// //                   isFullWidth: true,
// //                   backgroundColor: AppColors.lightGray,
// //                   textColor: AppColors.mediumGray,
// //                   fontSize: w * .045,
// //                   height: w * .140,
// //                   radius: 12.0,
// //                 ),

// //                 SizedBox(height: w * .1),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void _showUpdateConfirmationDialog(BuildContext context, double w) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Row(
// //           children: [
// //             Icon(Icons.edit, color: AppColors.primaryRed, size: w * 0.06),
// //             SizedBox(width: w * 0.02),
// //             AppFonts.textPoppins(
// //               context,
// //               "Confirm Update",
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
// //               "Are you sure you want to update this UPI ID?",
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
// //                     "Account Holder: ${widget.account?.accountHolderName ?? 'N/A'}",
// //                     w * 0.03,
// //                     FontWeight.w500,
// //                     AppColors.black,
// //                     TextAlign.left,
// //                     TextOverflow.ellipsis,
// //                   ),
// //                   SizedBox(height: w * 0.01),
// //                   Row(
// //                     children: [
// //                       AppFonts.textPoppins(
// //                         context,
// //                         "Old UPI: ",
// //                         w * 0.03,
// //                         FontWeight.w400,
// //                         AppColors.darkGray,
// //                         TextAlign.left,
// //                         TextOverflow.ellipsis,
// //                       ),
// //                       AppFonts.textPoppins(
// //                         context,
// //                         widget.account?.upiId ?? 'N/A',
// //                         w * 0.03,
// //                         FontWeight.w500,
// //                         Colors.red,
// //                         TextAlign.left,
// //                         TextOverflow.ellipsis,
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: w * 0.005),
// //                   Row(
// //                     children: [
// //                       AppFonts.textPoppins(
// //                         context,
// //                         "New UPI: ",
// //                         w * 0.03,
// //                         FontWeight.w400,
// //                         AppColors.darkGray,
// //                         TextAlign.left,
// //                         TextOverflow.ellipsis,
// //                       ),
// //                       AppFonts.textPoppins(
// //                         context,
// //                         upiIdController.text,
// //                         w * 0.03,
// //                         FontWeight.w500,
// //                         Colors.green,
// //                         TextAlign.left,
// //                         TextOverflow.ellipsis,
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: w * 0.02),
// //             AppFonts.textPoppins(
// //               context,
// //               "Note: This action will update your UPI ID.",
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
// //             onPressed: () async {
// //               Navigator.pop(context); // Close confirmation dialog

// //               // Show loading dialog
// //               Get.dialog(
// //                 Center(
// //                   child: CircularProgressIndicator(color: AppColors.primaryRed),
// //                 ),
// //                 barrierDismissible: false,
// //               );

// //               try {
// //                 // Get token from SharedPreferences
// //                 final prefs = await SharedPreferences.getInstance();
// //                 final String? token = prefs.getString("auth_token");

// //                 // Create multipart request
// //                 var request = http.MultipartRequest(
// //                   'PUT',
// //                   Uri.parse(
// //                     'https://nzcu.smarttechbros.com/api/v1/bank-accounts/update/${widget.account_id}',
// //                   ),
// //                 );

// //                 // Add headers
// //                 request.headers['Authorization'] = 'Bearer $token';

// //                 // Add form data
// //                 request.fields['type'] = 'UPI';
// //                 request.fields['upiId'] = upiIdController.text;

// //                 // Send request
// //                 var response = await request.send();
// //                 var responseBody = await response.stream.bytesToString();

// //                 // Close loading dialog
// //                 Get.back();

// //                 if (response.statusCode == 200) {
// //                   // Success
// //                   Get.snackbar(
// //                     'Success',
// //                     'UPI ID updated successfully',
// //                     snackPosition: SnackPosition.BOTTOM,
// //                     backgroundColor: Colors.green,
// //                     colorText: Colors.white,
// //                     duration: Duration(seconds: 2),
// //                   );

// //                   // Return true to refresh the list in MoneyTransferScreen
// //                   Get.back(result: true);
// //                 } else {
// //                   // Error
// //                   Get.snackbar(
// //                     'Error',
// //                     'Failed to update UPI ID. Status: ${response.statusCode}',
// //                     snackPosition: SnackPosition.BOTTOM,
// //                     backgroundColor: Colors.red,
// //                     colorText: Colors.white,
// //                     duration: Duration(seconds: 3),
// //                   );
// //                 }
// //               } catch (e) {
// //                 // Close loading dialog
// //                 Get.back();

// //                 // Handle network errors
// //                 Get.snackbar(
// //                   'Error',
// //                   'Network error: $e',
// //                   snackPosition: SnackPosition.BOTTOM,
// //                   backgroundColor: Colors.red,
// //                   colorText: Colors.white,
// //                   duration: Duration(seconds: 3),
// //                 );
// //               }
// //             },
// //             child: AppFonts.textPoppins(
// //               context,
// //               "Confirm Update",
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

// import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
// import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// import 'package:nzcu_driver/utilities/widgets/form_field.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class EditUpi extends StatefulWidget {
//   final dynamic account;
//   final dynamic account_id;

//   const EditUpi({super.key, required this.account, required this.account_id});

//   @override
//   State<EditUpi> createState() => _EditUpiState();
// }

// class _EditUpiState extends State<EditUpi> {
//   final BankAccountAddController bankAccountAddController =
//       Get.find<BankAccountAddController>();

//   late TextEditingController upiIdController;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controller with existing UPI ID
//     upiIdController = TextEditingController(text: widget.account?.upiId ?? "");
//   }

//   @override
//   void dispose() {
//     upiIdController.dispose();
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
//                 Navigator.pop(context);
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 size: w * .07,
//                 color: ColorsList.iconColor,
//               ),
//             ),
//             SizedBox(width: w * .035),
//             CustomText(
//               text: "Edit UPI",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Column(
//               children: [
//                 Image.asset(
//                   "assets/images/upi_image.png",
//                   width: 300,
//                   height: 300,
//                 ),
//                 AppFonts.textPoppins(
//                   context,
//                   "Edit UPI ID",
//                   w * 0.046,
//                   FontWeight.w600,
//                   AppColors.black,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                 ),

//                 // Show current UPI ID being edited
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: w * 0.02),
//                   padding: EdgeInsets.all(w * 0.03),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryRed.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(w * 0.02),
//                     border: Border.all(
//                       color: AppColors.primaryRed.withOpacity(0.3),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: AppColors.primaryRed,
//                         size: w * 0.05,
//                       ),
//                       SizedBox(width: w * 0.02),
//                       Expanded(
//                         child: AppFonts.textPoppins(
//                           context,
//                           "Editing: ${widget.account?.upiId ?? 'N/A'}",
//                           w * 0.032,
//                           FontWeight.w500,
//                           AppColors.primaryRed,
//                           TextAlign.left,
//                           TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.only(top: w * .03, bottom: w * .02),
//                   child: AppFormFields.custTextFormOther(
//                     context: context,
//                     hintText: "Example: abcdef@phonepe",
//                     // labelText: "UPI ID",
//                     controller: upiIdController,
//                     keyboardType: TextInputType.text,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter UPI ID';
//                       }
//                       if (!value.contains('@')) {
//                         return 'Please enter a valid UPI ID';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),

//                 Container(
//                   width: w,
//                   color: Color.fromRGBO(240, 247, 255, 1),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: w * .02,
//                       vertical: w * .02,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomImages.images(
//                           "assets/icons/addupiIcon1.png",
//                           w * .06,
//                           w * .06,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: w * .015),
//                           child: SizedBox(
//                             width: w * .8,
//                             child: AppFonts.textPoppins(
//                               context,
//                               "Please enter the UPI details carefully and don't worry, it is 100% safe!",
//                               w * 0.026,
//                               FontWeight.w500,
//                               ColorsList.linksTextColor,
//                               TextAlign.start,
//                               TextOverflow.visible,
//                               maxLines: 3,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: w * .3),

//                 // Update Button
//                 AppButtons.solid(
//                   context: context,
//                   text: "Update UPI",
//                   onClicked: () {
//                     if (_formKey.currentState!.validate()) {
//                       _showUpdateConfirmationDialog(context, w);
//                     }
//                   },
//                   isFullWidth: true,
//                   backgroundColor: AppColors.primaryRed,
//                   textColor: AppColors.white,
//                   fontSize: w * .045,
//                   height: w * .140,
//                   radius: 12.0,
//                 ),

//                 // Cancel Button
//                 SizedBox(height: w * .02),
//                 AppButtons.solid(
//                   context: context,
//                   text: "Cancel",
//                   onClicked: () {
//                     Navigator.pop(context);
//                   },
//                   isFullWidth: true,
//                   backgroundColor: AppColors.lightGray,
//                   textColor: AppColors.mediumGray,
//                   fontSize: w * .045,
//                   height: w * .140,
//                   radius: 12.0,
//                 ),

//                 SizedBox(height: w * .1),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showUpdateConfirmationDialog(BuildContext context, double w) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.edit, color: AppColors.primaryRed, size: w * 0.06),
//             SizedBox(width: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "Confirm Update",
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
//               "Are you sure you want to update this UPI ID?",
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
//                     "Account Holder: ${widget.account?.accountHolderName ?? 'N/A'}",
//                     w * 0.03,
//                     FontWeight.w500,
//                     AppColors.black,
//                     TextAlign.left,
//                     TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: w * 0.01),
//                   Row(
//                     children: [
//                       AppFonts.textPoppins(
//                         context,
//                         "Old UPI: ",
//                         w * 0.03,
//                         FontWeight.w400,
//                         AppColors.darkGray,
//                         TextAlign.left,
//                         TextOverflow.ellipsis,
//                       ),
//                       AppFonts.textPoppins(
//                         context,
//                         widget.account?.upiId ?? 'N/A',
//                         w * 0.03,
//                         FontWeight.w500,
//                         Colors.red,
//                         TextAlign.left,
//                         TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: w * 0.005),
//                   Row(
//                     children: [
//                       AppFonts.textPoppins(
//                         context,
//                         "New UPI: ",
//                         w * 0.03,
//                         FontWeight.w400,
//                         AppColors.darkGray,
//                         TextAlign.left,
//                         TextOverflow.ellipsis,
//                       ),
//                       AppFonts.textPoppins(
//                         context,
//                         upiIdController.text,
//                         w * 0.03,
//                         FontWeight.w500,
//                         Colors.green,
//                         TextAlign.left,
//                         TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: w * 0.02),
//             AppFonts.textPoppins(
//               context,
//               "Note: This action will update your UPI ID.",
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
//             onPressed: () async {
//               // Navigator.pop(context); // Close confirmation dialog

//               // Show loading dialog using normal Navigator
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (BuildContext context) {
//                   return Center(
//                     child: CircularProgressIndicator(color: AppColors.primaryRed),
//                   );
//                 },
//               );

//               try {
//                 // Get token from SharedPreferences
//                 final prefs = await SharedPreferences.getInstance();
//                 final String? token = prefs.getString("auth_token");

//                 // Create multipart request
//                 var request = http.MultipartRequest(
//                   'POST',
//                   Uri.parse(
//                     'https://nzcu.smarttechbros.com/api/v1/bank-accounts/update/${widget.account_id}',
//                   ),
//                 );

//                 // Add headers
//                 request.headers['Authorization'] = 'Bearer $token';

//                 // Add form data
//                 request.fields['type'] = 'UPI';
//                 request.fields['upiId'] = upiIdController.text;

//                 // Send request
//                 var response = await request.send();
//                 var responseBody = await response.stream.bytesToString();

//                 // Close loading dialog
//                 Navigator.pop(context);

//                 if (response.statusCode == 200) {
//                   // Show success message using ScaffoldMessenger
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('UPI ID updated successfully'),
//                       backgroundColor: Colors.green,
//                       duration: Duration(seconds: 2),
//                     ),
//                   );

//                   // Return to previous screen with result
//                   Navigator.pop(context, true);
//                 } else {
//                   // Show error message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to update UPI ID. Status: ${response.statusCode}'),
//                       backgroundColor: Colors.red,
//                       duration: Duration(seconds: 3),
//                     ),
//                   );
//                 }
//               } catch (e) {
//                 // Close loading dialog
//                 Navigator.pop(context);

//                 // Show error message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Network error: $e'),
//                     backgroundColor: Colors.red,
//                     duration: Duration(seconds: 3),
//                   ),
//                 );
//               }
//             },
//             child: AppFonts.textPoppins(
//               context,
//               "Confirm Update",
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
// }

import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/form_field.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditUpi extends StatefulWidget {
  final dynamic account;
  final dynamic account_id;

  const EditUpi({super.key, required this.account, required this.account_id});

  @override
  State<EditUpi> createState() => _EditUpiState();
}

class _EditUpiState extends State<EditUpi> {
  final BankAccountAddController bankAccountAddController =
      Get.find<BankAccountAddController>();

  late TextEditingController upiIdController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller with existing UPI ID
    upiIdController = TextEditingController(text: widget.account?.upiId ?? "");
  }

  @override
  void dispose() {
    upiIdController.dispose();
    super.dispose();
  }

  Future<void> _updateUpi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");

      // Create multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
          'https://nzcu.smarttechbros.com/api/v1/bank-accounts/update/${widget.account_id}',
        ),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add form data
      request.fields['type'] = 'UPI';
      request.fields['upiId'] = upiIdController.text;

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("myyy_the_total_resposne ${response}");
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('UPI ID updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Return to previous screen with result
        Navigator.pop(context, true);
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update UPI ID. Status: ${response.statusCode}',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
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
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: w * .07,
                color: ColorsList.iconColor,
              ),
            ),
            SizedBox(width: w * .035),
            CustomText(
              text: "Edit UPI",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/upi_image.png",
                  width: 300,
                  height: 300,
                ),
                AppFonts.textPoppins(
                  context,
                  "Edit UPI ID",
                  w * 0.046,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                ),

                // Show current UPI ID being edited
                Container(
                  margin: EdgeInsets.symmetric(vertical: w * 0.02),
                  padding: EdgeInsets.all(w * 0.03),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(w * 0.02),
                    border: Border.all(
                      color: AppColors.primaryRed.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryRed,
                        size: w * 0.05,
                      ),
                      SizedBox(width: w * 0.02),
                      Expanded(
                        child: AppFonts.textPoppins(
                          context,
                          "Editing: ${widget.account?.upiId ?? 'N/A'}",
                          w * 0.032,
                          FontWeight.w500,
                          AppColors.primaryRed,
                          TextAlign.left,
                          TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: w * .03, bottom: w * .02),
                  child: AppFormFields.custTextFormOther(
                    context: context,
                    hintText: "Example: abcdef@phonepe",
                    controller: upiIdController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter UPI ID';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid UPI ID';
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                  width: w,
                  color: Color.fromRGBO(240, 247, 255, 1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * .02,
                      vertical: w * .02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImages.images(
                          "assets/icons/addupiIcon1.png",
                          w * .06,
                          w * .06,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * .015),
                          child: SizedBox(
                            width: w * .8,
                            child: AppFonts.textPoppins(
                              context,
                              "Please enter the UPI details carefully and don't worry, it is 100% safe!",
                              w * 0.026,
                              FontWeight.w500,
                              ColorsList.linksTextColor,
                              TextAlign.start,
                              TextOverflow.visible,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: w * .3),

                // Update Button
                AppButtons.solid(
                  context: context,
                  text: _isLoading ? "Updating..." : "Update UPI",
                  onClicked: _updateUpi,
                  isFullWidth: true,
                  backgroundColor: _isLoading
                      ? AppColors.mediumGray
                      : AppColors.primaryRed,
                  textColor: AppColors.white,
                  fontSize: w * .045,
                  height: w * .140,
                  radius: 12.0,
                ),

                // Cancel Button
                SizedBox(height: w * .02),
                AppButtons.solid(
                  context: context,
                  text: "Cancel",
                  onClicked: () {
                    Navigator.pop(context);
                  },
                  isFullWidth: true,
                  backgroundColor: AppColors.lightGray,
                  textColor: AppColors.mediumGray,
                  fontSize: w * .045,
                  height: w * .140,
                  radius: 12.0,
                ),

                SizedBox(height: w * .1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
