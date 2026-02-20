import 'package:nzcu_driver/controllers/home_controllers/controllers.dart';
import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/form_field.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
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
      Get.find<BankAccountAddController>();

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
            ///
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: w * .140,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade300, // Aqua color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  onPressed: bankAccountAddController.isLoading.value
                      ? null
                      : () {
                          bankAccountAddController.addbankaccount_method(
                            accountHolderName: nameController.text.trim(),
                            accountNumber: accountNumberController.text.trim(),
                            bankName: bankNameController.text.trim(),
                            ifscCode: ifscController.text.trim(),
                            type: "BankAccount",
                            context: context,
                          );
                        },
                  child: bankAccountAddController.isLoading.value
                      ? SizedBox(
                          height: w * 0.06,
                          width: w * 0.06,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: w * .045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),

            // SizedBox(height: w * .08),
          ],
        ),
      ),
    );
  }
}
