import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/update_bank_and_upi_controller.dart';
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
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

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

  late final UpdateBankAndUpiController updateBankAndUpiController;

  late TextEditingController upiIdController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller with existing UPI ID
    upiIdController = TextEditingController(text: widget.account?.upiId ?? "");

    // Initialize the update controller
    updateBankAndUpiController = Get.put(UpdateBankAndUpiController());
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
      await updateBankAndUpiController.update_upi_method(
        accountid: widget.account_id,
        upiId: upiIdController.text.trim(),
      );

      // Show success message
      if (mounted) {
        CustomToast.showSuccess("UPI ID updated successfully");

        // Navigate back with success
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        CustomToast.showError("Failed to update UPI ID: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteUpi() async {
    // Show confirmation dialog
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
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
                        widget.account?.upiId ?? 'N/A',
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
      _isDeleting = true;
    });

    try {
      print("Deleting UPI with accountid: ${widget.account_id}");

      await updateBankAndUpiController.delete_bank_upi_method(
        accountid: widget.account_id,
      );

      if (mounted) {
        CustomToast.showSuccess("UPI ID deleted successfully");

        Navigator.pop(context, true);
      }
    } catch (e) {
      print("Error in _deleteUpi: $e");
      if (mounted) {
        CustomToast.showError("Failed to delete UPI ID: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
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
                // UPI Image
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/upi_image.png",
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 100,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "UPI Image",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: w * .03),

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
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: w * 0.02),
                //   padding: EdgeInsets.all(w * 0.03),
                //   decoration: BoxDecoration(
                //     color: AppColors.primaryRed.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(w * 0.02),
                //     border: Border.all(
                //       color: AppColors.primaryRed.withOpacity(0.3),
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.info_outline,
                //         color: AppColors.primaryRed,
                //         size: w * 0.05,
                //       ),
                //       SizedBox(width: w * 0.02),
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             AppFonts.textPoppins(
                //               context,
                //               "Current UPI ID:",
                //               w * 0.028,
                //               FontWeight.w400,
                //               AppColors.primaryRed.withOpacity(0.8),
                //               TextAlign.left,
                //               TextOverflow.ellipsis,
                //             ),
                //             AppFonts.textPoppins(
                //               context,
                //               widget.account?.upiId ?? 'N/A',
                //               w * 0.035,
                //               FontWeight.w600,
                //               AppColors.primaryRed,
                //               TextAlign.left,
                //               TextOverflow.ellipsis,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: w * .03, bottom: w * .02),
                  child: AppFormFields.custTextFormOther(
                    context: context,
                    hintText: "Example: abcdef@phonepe",
                    controller: upiIdController,
                    keyboardType: TextInputType.text,
                    // enabled: !_isLoading && !_isDeleting,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter UPI ID';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid UPI ID (must contain @)';
                      }
                      if (value.length < 6) {
                        return 'UPI ID is too short';
                      }
                      if (value.contains(' ')) {
                        return 'UPI ID cannot contain spaces';
                      }
                      // Check if UPI ID has valid format (alphanumeric before @)
                      String localPart = value.split('@')[0];
                      if (localPart.isEmpty) {
                        return 'Invalid UPI ID format';
                      }
                      return null;
                    },
                  ),
                ),

                // Info Container
                Container(
                  width: w,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 247, 255, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                        SizedBox(width: w * .015),
                        Expanded(
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
                      ],
                    ),
                  ),
                ),

                SizedBox(height: w * .1),

                // Update Button
                AppButtons.solid(
                  context: context,
                  text: "Update UPI",
                  onClicked: _updateUpi,
                  isFullWidth: true,
                  backgroundColor: (_isLoading || _isDeleting)
                      ? AppColors.mediumGray
                      : AppColors.primaryRed,
                  textColor: AppColors.white,
                  fontSize: w * .045,
                  height: w * .140,
                  radius: 12.0,
                ),

                // Delete Button
                // SizedBox(height: w * .02),
                // AppButtons.solid(
                //   context: context,
                //   text: _isDeleting ? "Deleting..." : "Delete UPI",
                //   onClicked: _deleteUpi,
                //   isFullWidth: true,
                //   backgroundColor: (_isLoading || _isDeleting)
                //       ? AppColors.mediumGray
                //       : Colors.red.shade50,
                //   textColor: (_isLoading || _isDeleting)
                //       ? Colors.white
                //       : Colors.red,
                //   fontSize: w * .045,
                //   height: w * .140,
                //   radius: 12.0,
                // ),

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
