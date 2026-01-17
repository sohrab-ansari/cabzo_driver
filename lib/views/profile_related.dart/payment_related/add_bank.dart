// // import 'package:corezap_driver/controller/controllers.dart';
// // import 'package:corezap_driver/controller/profilecontoller/bank_account_add_controller.dart';
// // import 'package:corezap_driver/utilities/app_buttons.dart';
// // import 'package:corezap_driver/utilities/colors.dart';
// // import 'package:corezap_driver/utilities/colors/colors_list.dart';
// // import 'package:corezap_driver/utilities/custom_font.dart';
// // import 'package:corezap_driver/utilities/custom_text.dart';
// // import 'package:corezap_driver/utilities/form_field.dart';
// // import 'package:corezap_driver/utilities/navigator.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get/instance_manager.dart';

// // class AddBank extends StatefulWidget {
// //   const AddBank({super.key});

// //   @override
// //   State<AddBank> createState() => _AddBankState();
// // }

// // class _AddBankState extends State<AddBank> {
// //   Controllers controllers = Get.find<Controllers>();
// //   TextEditingController nameController = TextEditingController();
// //   TextEditingController accountNumberController = TextEditingController();
// //   TextEditingController confirmAccountNumberController =
// //       TextEditingController();
// //   TextEditingController ifscController = TextEditingController();
// //   TextEditingController bankNameController = TextEditingController();


// //   final BankAccountAddController bankAccountAddController = Get.put(
// //     BankAccountAddController(),
// //   );
// //   @override
// //   void dispose() {
// //     // TODO: implement dispose
// //     super.dispose();
// //     controllers.addBankAccoundButtonController.value = false;

    
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     nameController.text.isNotEmpty
// //         ? controllers.addBankAccoundButtonController.value = true
// //         : false;
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
// //               text: "Add a Bank Account",
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
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Bank Account Details",
// //                 w * 0.046,
// //                 FontWeight.w600,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: w * .04),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Account Holder Name",
// //                 w * 0.035,
// //                 FontWeight.w500,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: w * .01),
// //               AppFormFields.custTextFormOther(
// //                 context: context,
// //                 hintText: "Monika",
// //                 controller: nameController,
// //               ),
// //               SizedBox(height: w * .04),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Bank Account Number",
// //                 w * 0.035,
// //                 FontWeight.w500,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: w * .01),
// //               AppFormFields.custTextFormOther(
// //                 context: context,
// //                 hintText: "Enter here",
// //                 controller: accountNumberController,
// //               ),
// //               SizedBox(height: w * .04),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Confirm Account Number",
// //                 w * 0.035,
// //                 FontWeight.w500,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: w * .01),
// //               AppFormFields.custTextFormOther(
// //                 context: context,
// //                 hintText: "Enter here",
// //                 controller: confirmAccountNumberController,
// //               ),
// //               SizedBox(height: w * .04),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "IFSC Code",
// //                 w * 0.035,
// //                 FontWeight.w500,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: w * .01),
// //               AppFormFields.custTextFormOther(
// //                 context: context,
// //                 hintText: "Enter here",
// //                 controller: ifscController,
// //               ),
// //               SizedBox(height: w * .04),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Bank Name",
// //                 w * 0.035,
// //                 FontWeight.w500,
// //                 AppColors.black,
// //                 TextAlign.left,
// //                 TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: w * .01),
// //               AppFormFields.custTextFormOther(
// //                 context: context,
// //                 hintText: "Enter here",
// //                 controller: bankNameController,
// //               ),
// //               SizedBox(height: w * .4),
// //               Obx(
// //                 () => AppButtons.solid(
// //                   context: context,
// //                   text: "Confirm",
// //                   onClicked: () {

// //                     bankAccountAddController.addbankaccount_method(

// //                       accountHolderName: ,
// //                       accountNumber: ,
// //                       bankName: ,
// //                       ifscCode: ,
// //                     );



// //                     // CustomNavigator.push(
// //                     //   context,
// //                     //   MoneyTransferScreen(),
// //                     //   transition: TransitionType.fade,
// //                     // );
// //                   },
// //                   isFullWidth: true,
// //                   backgroundColor:
// //                       controllers.addBankAccoundButtonController.value
// //                       ? AppColors.primaryRed
// //                       : AppColors.lightGray,
// //                   textColor: controllers.addBankAccoundButtonController.value
// //                       ? AppColors.white
// //                       : AppColors.mediumGray,
// //                   fontSize: w * .045,
// //                   height: w * .140,
// //                   radius: 12.0,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:corezap_driver/controller/controllers.dart';
// import 'package:corezap_driver/controller/profilecontoller/bank_account_add_controller.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/form_field.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AddBank extends StatefulWidget {
//   const AddBank({super.key});

//   @override
//   State<AddBank> createState() => _AddBankState();
// }

// class _AddBankState extends State<AddBank> {
//   Controllers controllers = Get.find<Controllers>();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController accountNumberController = TextEditingController();
//   TextEditingController confirmAccountNumberController =
//       TextEditingController();
//   TextEditingController ifscController = TextEditingController();
//   TextEditingController bankNameController = TextEditingController();

//   final BankAccountAddController bankAccountAddController =
//       Get.put(BankAccountAddController());

//   @override
//   void dispose() {
//     controllers.addBankAccoundButtonController.value = false;
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
//               text: "Add a Bank Account",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppFonts.textPoppins(
//               context,
//               "Bank Account Details",
//               w * 0.046,
//               FontWeight.w600,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//             SizedBox(height: w * .04),

//             /// Account Holder Name
//             AppFonts.textPoppins(
//               context,
//               "Account Holder Name",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//             SizedBox(height: w * .01),
//             AppFormFields.custTextFormOther(
//               context: context,
//               hintText: "Monika",
//               controller: nameController,
//             ),

//             SizedBox(height: w * .04),

//             /// Account Number
//             AppFonts.textPoppins(
//               context,
//               "Bank Account Number",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//             SizedBox(height: w * .01),
//             AppFormFields.custTextFormOther(
//               context: context,
//               hintText: "Enter here",
//               controller: accountNumberController,
//             ),

//             SizedBox(height: w * .04),

//             /// Confirm Account Number
//             AppFonts.textPoppins(
//               context,
//               "Confirm Account Number",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//             SizedBox(height: w * .01),
//             AppFormFields.custTextFormOther(
//               context: context,
//               hintText: "Enter here",
//               controller: confirmAccountNumberController,
//             ),

//             SizedBox(height: w * .04),

//             /// IFSC
//             AppFonts.textPoppins(
//               context,
//               "IFSC Code",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//             SizedBox(height: w * .01),
//             AppFormFields.custTextFormOther(
//               context: context,
//               hintText: "Enter here",
//               controller: ifscController,
//             ),

//             SizedBox(height: w * .04),

//             /// Bank Name
//             AppFonts.textPoppins(
//               context,
//               "Bank Name",
//               w * 0.035,
//               FontWeight.w500,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.ellipsis,
//             ),
//             SizedBox(height: w * .01),
//             AppFormFields.custTextFormOther(
//               context: context,
//               hintText: "Enter here",
//               controller: bankNameController,
//             ),

//             Spacer(),

//             /// Confirm Button
//             Obx(
//               () => AppButtons.solid(
//                 context: context,
//                 text: "Confirm",
//                 isFullWidth: true,
//                 backgroundColor:
//                     controllers.addBankAccoundButtonController.value
//                         ? AppColors.primaryRed
//                         : AppColors.lightGray,
//                 textColor:
//                     controllers.addBankAccoundButtonController.value
//                         ? AppColors.white
//                         : AppColors.mediumGray,
//                 fontSize: w * .045,
//                 height: w * .140,
//                 radius: 12.0,
//                 onClicked: () {
//                   bankAccountAddController.addbankaccount_method(
//                     accountHolderName: nameController.text.trim(),
//                     accountNumber: accountNumberController.text.trim(),
//                     bankName: bankNameController.text.trim(),
//                     ifscCode: ifscController.text.trim(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/profilecontoller/bank_account_add_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/form_field.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBank extends StatefulWidget {
  const AddBank({super.key});

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  Controllers controllers = Get.find<Controllers>();

  TextEditingController nameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController confirmAccountNumberController =
      TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  final BankAccountAddController bankAccountAddController =
      Get.put(BankAccountAddController());

  @override
  void dispose() {
    controllers.addBankAccoundButtonController.value = false;
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
        elevation: 0,
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
              text: "Add a Bank Account",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),

      /// 🔥 SingleChildScrollView ADDED
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          left: w * .03,
          right: w * .03,
          top: w * .04,
          bottom: MediaQuery.of(context).viewInsets.bottom + w * .04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppFonts.textPoppins(
              context,
              "Bank Account Details",
              w * 0.046,
              FontWeight.w600,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * .04),

            /// Account Holder Name
            AppFonts.textPoppins(
              context,
              "Account Holder Name",
              w * 0.035,
              FontWeight.w500,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * .01),
            AppFormFields.custTextFormOther(
              context: context,
              hintText: "Monika",
              controller: nameController,
            ),

            SizedBox(height: w * .04),

            /// Account Number
            AppFonts.textPoppins(
              context,
              "Bank Account Number",
              w * 0.035,
              FontWeight.w500,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * .01),
            AppFormFields.custTextFormOther(
              context: context,
              hintText: "Enter here",
              controller: accountNumberController,
            ),

            SizedBox(height: w * .04),

            /// Confirm Account Number
            AppFonts.textPoppins(
              context,
              "Confirm Account Number",
              w * 0.035,
              FontWeight.w500,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * .01),
            AppFormFields.custTextFormOther(
              context: context,
              hintText: "Enter here",
              controller: confirmAccountNumberController,
            ),

            SizedBox(height: w * .04),

            /// IFSC Code
            AppFonts.textPoppins(
              context,
              "IFSC Code",
              w * 0.035,
              FontWeight.w500,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * .01),
            AppFormFields.custTextFormOther(
              context: context,
              hintText: "Enter here",
              controller: ifscController,
            ),

            SizedBox(height: w * .04),

            /// Bank Name
            AppFonts.textPoppins(
              context,
              "Bank Name",
              w * 0.035,
              FontWeight.w500,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * .01),
            AppFormFields.custTextFormOther(
              context: context,
              hintText: "Enter here",
              controller: bankNameController,
            ),

            SizedBox(height: w * .08),

            /// Confirm Button
            Obx(
              () => AppButtons.solid(
                context: context,
                text: "Confirm",
                isFullWidth: true,
                backgroundColor:
                    controllers.addBankAccoundButtonController.value
                        ? AppColors.primaryRed
                        : AppColors.lightGray,
                textColor:
                    controllers.addBankAccoundButtonController.value
                        ? AppColors.white
                        : AppColors.mediumGray,
                fontSize: w * .045,
                height: w * .140,
                radius: 12.0,
                onClicked: () {
                  bankAccountAddController.addbankaccount_method(
                    accountHolderName: nameController.text.trim(),
                    accountNumber: accountNumberController.text.trim(),
                    bankName: bankNameController.text.trim(),
                    ifscCode: ifscController.text.trim(),
                    context: context
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
