


import 'dart:io';
import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/edit_profile_controller.dart';
import 'package:nzcu_driver/utilities/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/custom_images.dart';
import 'package:nzcu_driver/utilities/custom_text.dart';
import 'package:nzcu_driver/utilities/form_field.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  final EditProfileController editProfileController = Get.put(
    EditProfileController(),
  );

  final DriveridController driveridController = Get.put(DriveridController());

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  Future<void> _pickProfileImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _profileImage = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint('Image picking failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _updateProfile() async {
    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await editProfileController.edit_profile_method(
        image: _profileImage,
        name: fullNameController.text.trim().isNotEmpty
            ? fullNameController.text.trim()
            : null,
        email: emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : null,
        dateOfBirth: dobController.text.isNotEmpty ? dobController.text : null,
        gender: genderController.text.isNotEmpty ? genderController.text : null,
      );

      Get.back(); // Close loading dialog
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Optional: Refresh driver data
      await driveridController.driverid_mdethod();
      
    } catch (e) {
      Get.back(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await driveridController.driverid_mdethod();
      
      // Wait a bit for data to load (you might want to use GetX observables instead)
      await Future.delayed(const Duration(milliseconds: 500));
      
      final driver = driveridController.driveridresponse.value?.driver;
      
      if (driver != null) {
        setState(() {
          // Load data safely with null checks
          fullNameController.text = driver.name?.toString() ?? '';
          mobileNumberController.text = driver.phone?.toString() ?? '';
          emailController.text = driver.email?.toString() ?? '';
          
          // Parse and format date of birth if it exists
          if (driver.dateOfBirth != null) {
            try {
              // Assuming date is in a parseable format
              final parsedDate = DateTime.parse(driver.dateOfBirth.toString());
              dobController.text = DateFormat("dd/MM/yyyy").format(parsedDate);
            } catch (e) {
              dobController.text = driver.dateOfBirth.toString();
            }
          }
          
          // FIXED: Load gender from correct field
          genderController.text = driver.gender?.toString() ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    dobController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: ColorsList.scaffoldColor,
          automaticallyImplyLeading: false,
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
              SizedBox(width: w * .02),
              CustomText(
                text: "Edit Profile",
                textColor: ColorsList.titleTextColor,
                textFontSize: w * .05,
                textFontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        automaticallyImplyLeading: false,
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
            SizedBox(width: w * .02),
            CustomText(
              text: "Edit Profile",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: w * .03),
          // Profile Image
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: w * 0.15,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : driveridController.driveridresponse.value?.driver?.image != null
                          ? NetworkImage(driveridController.driveridresponse.value!.driver!.image!)
                          : null,
                  child: _profileImage == null && 
                         (driveridController.driveridresponse.value?.driver?.image == null)
                      ? Icon(
                          Icons.person,
                          size: w * 0.1,
                          color: Colors.grey.shade700,
                        )
                      : null,
                ),
                // Edit button
                Positioned(
                  bottom: 0,
                  right: w * .05,
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: CustomImages.images(
                      "assets/icons/profileEdit1.png",
                      w * .05,
                      w * .05,
                    ),
                  ),
                ),
                // Cancel / Remove button
                if (_profileImage != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _profileImage = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(w * 0.01),
                        child: Icon(
                          Icons.close,
                          size: w * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: w * .01),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * .04,
              vertical: w * .02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                AppFonts.textPoppins(
                  context,
                  "Full Name",
                  w * 0.04,
                  FontWeight.w500,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.ellipsis,
                ),
                SizedBox(height: w * .01),
                AppFormFields.custTextFormOther(
                  context: context,
                  hintText: "Enter your full name",
                  controller: fullNameController,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: w * .04),
                
                // Mobile Number - Disabled
                AppFonts.textPoppins(
                  context,
                  "Mobile number",
                  w * 0.04,
                  FontWeight.w500,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.ellipsis,
                ),
                SizedBox(height: w * .01),
                AppFormFields.custTextFormOther2(
                  context: context,
                  hintText: "Enter mobile number",
                  controller: mobileNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  enabled: false,
                  readOnly: true,
                  fillColor: Colors.grey.shade200,
                ),
                SizedBox(height: w * .04),
                
                // Email
                AppFonts.textPoppins(
                  context,
                  "Email",
                  w * 0.04,
                  FontWeight.w500,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.ellipsis,
                ),
                SizedBox(height: w * .01),
                AppFormFields.custTextFormOther(
                  context: context,
                  hintText: "email@example.com",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                SizedBox(height: w * .04),
                
                // Date of Birth
                AppFonts.textPoppins(
                  context,
                  "Date of birth",
                  w * 0.04,
                  FontWeight.w500,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.ellipsis,
                ),
                SizedBox(height: w * .01),
                AppFormFields.custTextFormOther(
                  context: context,
                  hintText: "DD/MM/YYYY",
                  controller: dobController,
                  readOnly: true,
                  onClicked: () async {
                    DateTime? initialDate;
                    
                    // Try to parse existing date
                    if (dobController.text.isNotEmpty) {
                      try {
                        final parts = dobController.text.split('/');
                        if (parts.length == 3) {
                          initialDate = DateTime(
                            int.parse(parts[2]),
                            int.parse(parts[1]),
                            int.parse(parts[0]),
                          );
                        }
                      } catch (e) {
                        initialDate = DateTime.now().subtract(
                          const Duration(days: 365 * 25),
                        );
                      }
                    } else {
                      initialDate = DateTime.now().subtract(
                        const Duration(days: 365 * 25),
                      );
                    }
                    
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate ?? DateTime.now().subtract(
                        const Duration(days: 365 * 25),
                      ),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    
                    if (picked != null) {
                      setState(() {
                        dobController.text = DateFormat("dd/MM/yyyy").format(picked);
                      });
                    }
                  },
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                    size: w * 0.055,
                  ),
                ),
                SizedBox(height: w * .04),
                
                // Gender
                AppFonts.textPoppins(
                  context,
                  "Gender",
                  w * 0.04,
                  FontWeight.w500,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.ellipsis,
                ),
                SizedBox(height: w * .01),
                AppFormFields.custTextFormOther(
                  context: context,
                  hintText: "Select Gender",
                  controller: genderController,
                  readOnly: true,
                  onClicked: () async {
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: w * .04),
                              child: Text(
                                "Select Gender",
                                style: TextStyle(
                                  fontSize: w * .045,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey.shade300),
                            ...["Male", "Female", "Other", "Prefer not to say"].map((gender) {
                              return ListTile(
                                title: Text(gender),
                                onTap: () => Navigator.pop(context, gender),
                              );
                            }).toList(),
                            SizedBox(height: w * .05),
                          ],
                        );
                      },
                    );
                    if (selected != null) {
                      setState(() {
                        genderController.text = selected;
                      });
                    }
                  },
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                    size: w * 0.065,
                  ),
                ),
                SizedBox(height: w * .1),
                
                // Update Button
                Obx(() {
                  final isLoading = editProfileController.isLoading.value;
                  return AppButtons.solid2(
                    context: context,
                    text: isLoading ? "Updating..." : "Profile Update",
                    onClicked:  _updateProfile,
                    isFullWidth: true,
                    backgroundColor: isLoading ? Colors.grey : AppColors.primaryRed,
                    textColor: AppColors.white,
                    fontSize: w * .045,
                    height: w * .140,
                    radius: 12.0,
                    fontWeight: FontWeight.w500,
                  );
                }),
                SizedBox(height: w * .1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}