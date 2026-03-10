// import 'package:nzcu_driver/controllers/home_controllers/controllers.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/update_bank_and_upi_controller.dart';
// import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// import 'package:nzcu_driver/utilities/widgets/form_field.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class EditBank extends StatefulWidget {
//   dynamic account;

//   dynamic account_id;
//   EditBank({super.key, required this.account, required this.account_id});

//   @override
//   State<EditBank> createState() => _EditBankState();
// }

// class _EditBankState extends State<EditBank> {
//   Controllers controllers = Get.find<Controllers>();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController accountNumberController = TextEditingController();
//   TextEditingController confirmAccountNumberController =
//       TextEditingController();
//   TextEditingController ifscController = TextEditingController();
//   TextEditingController bankNameController = TextEditingController();

//   final BankAccountAddController bankAccountAddController =
//       Get.find<BankAccountAddController>();

//   @override
//   void dispose() {
//     controllers.addBankAccoundButtonController.value = false;
//     super.dispose();
//   }
//   // Add this controller
//   late final UpdateBankAndUpiController updateBankAndUpiController;
//   initState()
//   {

//     super.initState();
//       updateBankAndUpiController = Get.put(UpdateBankAndUpiController());
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
//               onTap: () => CustomNavigator.pop(context),
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

//       /// 🔥 SingleChildScrollView ADDED
//       body: SingleChildScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         padding: EdgeInsets.only(
//           left: w * .03,
//           right: w * .03,
//           top: w * .04,
//           bottom: MediaQuery.of(context).viewInsets.bottom + w * .04,
//         ),
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

//             /// IFSC Code
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

//             SizedBox(height: w * .08),

//             /// Confirm Button
//             ///
//             Obx(
//               () => SizedBox(
//                 width: double.infinity,
//                 height: w * .140,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.cyan.shade300, // Aqua color
//                     foregroundColor: Colors.white, // Text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     elevation: 0,
//                   ),
//                   onPressed: () {

//                      await updateBankAndUpiController.update_bank_method(
//         accountid: widget.account_id, // Make sure parameter name matches

//         accountHolderName:  accountNumberController.text,
//         accountNumber: accountNumberController.text.trim(),
//         acoountid:    widget.account_id,

//         bankName: bankNameController.text.trim(),
//         ifscCode: ifscController.text.trim(),
//         type:  "BankAccount"
//       );

//                     // bankAccountAddController.addbankaccount_method(
//                     //   accountHolderName: nameController.text.trim(),
//                     //   accountNumber: accountNumberController.text.trim(),
//                     //   bankName: bankNameController.text.trim(),
//                     //   ifscCode: ifscController.text.trim(),
//                     //   type: "BankAccount",
//                     //   context: context,
//                     // );
//                   },
//                   child: Text(
//                     "Confirm",
//                     style: TextStyle(
//                       fontSize: w * .045,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:nzcu_driver/controllers/home_controllers/controllers.dart';
import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/update_bank_and_upi_controller.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/form_field.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditBank extends StatefulWidget {
  final dynamic account;
  final dynamic account_id;

  const EditBank({super.key, required this.account, required this.account_id});

  @override
  State<EditBank> createState() => _EditBankState();
}

class _EditBankState extends State<EditBank> {
  Controllers controllers = Get.find<Controllers>();

  TextEditingController nameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController confirmAccountNumberController =
      TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  final BankAccountAddController bankAccountAddController =
      Get.find<BankAccountAddController>();

  late final UpdateBankAndUpiController updateBankAndUpiController;

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updateBankAndUpiController = Get.put(UpdateBankAndUpiController());

    // Pre-fill existing bank details
    if (widget.account != null) {
      nameController.text = widget.account.accountHolderName ?? "";
      accountNumberController.text = widget.account.accountNumber ?? "";
      confirmAccountNumberController.text = widget.account.accountNumber ?? "";
      ifscController.text = widget.account.ifscCode ?? "";
      bankNameController.text = widget.account.bankName ?? "";
    }
  }

  @override
  void dispose() {
    controllers.addBankAccoundButtonController.value = false;
    nameController.dispose();
    accountNumberController.dispose();
    confirmAccountNumberController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    super.dispose();
  }

  Future<void> _updateBankAccount() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Check if account numbers match
    if (accountNumberController.text.trim() !=
        confirmAccountNumberController.text.trim()) {
      Get.snackbar(
        "Error",
        "Account numbers do not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await updateBankAndUpiController.update_bank_method(
        accountid: widget.account_id,
        accountHolderName: nameController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        bankName: bankNameController.text.trim(),
        ifscCode: ifscController.text.trim().toUpperCase(),
      );

      // Show success message
      Get.snackbar(
        "Success",
        "Bank account updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );

      // Navigate back with success
      Navigator.pop(context, true);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update bank account: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
              text: "Edit Bank Account",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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

              // Account Holder Name
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
                hintText: "Enter account holder name",
                controller: nameController,
                // textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account holder name';
                  }
                  if (value.length < 3) {
                    return 'Name is too short';
                  }
                  return null;
                },
              ),

              SizedBox(height: w * .04),

              // Account Number
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
                hintText: "Enter account number",
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  if (value.length < 9 || value.length > 18) {
                    return 'Account number should be 9-18 digits';
                  }
                  return null;
                },
              ),

              SizedBox(height: w * .04),

              // Confirm Account Number
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
                hintText: "Re-enter account number",
                controller: confirmAccountNumberController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm account number';
                  }
                  return null;
                },
              ),

              SizedBox(height: w * .04),

              // IFSC Code
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
                hintText: "Enter IFSC code",
                controller: ifscController,
                // textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IFSC code';
                  }
                  // Basic IFSC validation (4 letters + 7 characters)
                  if (value.length != 11) {
                    return 'IFSC code must be 11 characters';
                  }
                  if (!RegExp(r'^[A-Z]{4}').hasMatch(value.substring(0, 4))) {
                    return 'Invalid IFSC format';
                  }
                  return null;
                },
              ),

              SizedBox(height: w * .04),

              // Bank Name
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
                hintText: "Enter bank name",
                controller: bankNameController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bank name';
                  }
                  return null;
                },
              ),

              SizedBox(height: w * .08),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: w * .140,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading
                        ? Colors.grey
                        : Colors.cyan.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _updateBankAccount,
                  child: Text(
                    _isLoading ? "Updating..." : "Update Bank Account",
                    style: TextStyle(
                      fontSize: w * .045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: w * .02),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: w * .140,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: w * .045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: w * .02),
            ],
          ),
        ),
      ),
    );
  }
}
