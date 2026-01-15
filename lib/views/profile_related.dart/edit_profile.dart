// import 'dart:io';
// import 'package:corezap_driver/controller/profilecontoller/edit_profile_controller.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/form_field.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController mobileNumberController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   TextEditingController genderController = TextEditingController();


//     final EditProfileController editProfileController = Get.put(
//     EditProfileController(),
//   );

//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();


//   Future<void> _pickProfileImage() async {
//     try {
//       final XFile? picked = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );
//       if (picked != null) {
//         setState(() {
//           _profileImage = File(picked.path);
//         });
//       }
//     } catch (e) {
//       debugPrint('Image picking failed: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
//     }
//   }


// @override
//   void initState() {


//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: ColorsList.scaffoldColor,
//         automaticallyImplyLeading: false,
//         scrolledUnderElevation: 0,
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
//             SizedBox(width: w * .02),
//             CustomText(
//               text: "Edit",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: ListView(
//         children: [
//           SizedBox(height: w * .03),
//           // Profile Image
//           Center(
//             child: Stack(
//               children: [
//                 CircleAvatar(
//                   radius: w * 0.15,
//                   backgroundColor: Colors.grey.shade300,
//                   backgroundImage: _profileImage != null
//                       ? FileImage(_profileImage!)
//                       : null,
//                   child: _profileImage == null
//                       ? Icon(
//                           Icons.person,
//                           size: w * 0.1,
//                           color: Colors.grey.shade700,
//                         )
//                       : null,
//                 ),
//                 // Edit button
//                 Positioned(
//                   bottom: 0,
//                   right: w * .05,
//                   child: GestureDetector(
//                     onTap: _pickProfileImage,
//                     child: CustomImages.images(
//                       "assets/icons/profileEdit1.png",
//                       w * .05,
//                       w * .05,
//                     ),
//                   ),
//                 ),
//                 // Cancel / Remove button
//                 if (_profileImage != null)
//                   Positioned(
//                     top: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _profileImage = null;
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryRed,
//                           shape: BoxShape.circle,
//                         ),
//                         padding: EdgeInsets.all(w * 0.01),
//                         child: Icon(
//                           Icons.close,
//                           size: w * 0.04,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           SizedBox(height: w * .01),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * .04,
//               vertical: w * .02,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Full Name
//                 AppFonts.textPoppins(
//                   context,
//                   "Full Name",
//                   w * 0.04,
//                   FontWeight.w500,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: w * .01),
//                 AppFormFields.custTextFormOther(
//                   context: context,
//                   hintText: "Monika",
//                   controller: fullNameController,
//                   keyboardType: TextInputType.name,
//                 ),
//                 SizedBox(height: w * .04),
//                 // Mobile Number
//                 AppFonts.textPoppins(
//                   context,
//                   "Mobile number",
//                   w * 0.04,
//                   FontWeight.w500,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: w * .01),
//                 AppFormFields.custTextFormOther(
//                   context: context,
//                   hintText: "+91 8344661034",
//                   controller: mobileNumberController,
//                   keyboardType: TextInputType.number,
//                   maxLength: 10,
//                 ),
//                 SizedBox(height: w * .04),
//                 // Email
//                 AppFonts.textPoppins(
//                   context,
//                   "Email",
//                   w * 0.04,
//                   FontWeight.w500,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: w * .01),
//                 AppFormFields.custTextFormOther(
//                   context: context,
//                   hintText: "email.com",
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 SizedBox(height: w * .04),
//                 // Date of Birth
//                 AppFonts.textPoppins(
//                   context,
//                   "Date of birth",
//                   w * 0.04,
//                   FontWeight.w500,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: w * .01),
//                 AppFormFields.custTextFormOther(
//                   context: context,
//                   hintText: "DD/MM/YYYY",
//                   controller: dobController,
//                   readOnly: true,
//                   onClicked: () async {
//                     DateTime initialDate = DateTime.now().subtract(
//                       const Duration(days: 365 * 20),
//                     );
//                     final DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: initialDate,
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() {
//                         dobController.text = DateFormat(
//                           "dd/MM/yyyy",
//                         ).format(picked);
//                       });
//                     }
//                   },
//                   suffixIcon: Icon(
//                     Icons.calendar_month,
//                     color: Colors.black,
//                     size: w * 0.055,
//                   ),
//                 ),
//                 SizedBox(height: w * .04),
//                 // Gender
//                 AppFonts.textPoppins(
//                   context,
//                   "Gender",
//                   w * 0.04,
//                   FontWeight.w500,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: w * .01),
//                 AppFormFields.custTextFormOther(
//                   context: context,
//                   hintText: "Select Gender",
//                   controller: genderController,
//                   readOnly: true,
//                   onClicked: () async {
//                     final selected = await showModalBottomSheet<String>(
//                       context: context,
//                       backgroundColor: Colors.white,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(16),
//                         ),
//                       ),
//                       builder: (context) {
//                         return Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(vertical: w * .04),
//                               child: Text(
//                                 "Select Gender",
//                                 style: TextStyle(
//                                   fontSize: w * .045,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             Divider(height: 1, color: Colors.grey.shade300),
//                             ...["Male", "Female", "Other"].map((gender) {
//                               return ListTile(
//                                 title: Text(gender),
//                                 onTap: () => Navigator.pop(context, gender),
//                               );
//                             }).toList(),
//                             SizedBox(height: w * .05),
//                           ],
//                         );
//                       },
//                     );
//                     if (selected != null) {
//                       setState(() {
//                         genderController.text = selected;
//                       });
//                     }
//                   },
//                   suffixIcon: Icon(
//                     Icons.keyboard_arrow_down_rounded,
//                     color: Colors.black,
//                     size: w * 0.065,
//                   ),
//                 ),
//                 SizedBox(height: w * .1),
//                 // Update Button
//                 AppButtons.solid(
//                   context: context,
//                   text: "Profile Update",
//                   onClicked: () {


//                     editProfileController.edit_profile_method(image: ,email: ,name: ,)



//                     // updateProfile();
//                     Get.back();
//                   },
//                   isFullWidth: true,
//                   backgroundColor: AppColors.primaryRed,
//                   textColor: AppColors.black,
//                   fontSize: w * .045,
//                   height: w * .140,
//                   radius: 12.0,

//                   fontWeight: FontWeight.w500,
//                 ),
//                 SizedBox(height: w * .3),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'dart:io';
import 'package:corezap_driver/controller/home_controller.dart';
import 'package:corezap_driver/controller/profilecontoller/edit_profile_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/form_field.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';

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

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
    }
  }

  // Method to update profile
  Future<void> _updateProfile() async {
    // Validate form
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading indicator
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // );

      try {
     
         await editProfileController.edit_profile_method(
          image: _profileImage,
          name: fullNameController.text.trim(),
          email: emailController.text.trim(),
        
        );

 
      
      } catch (e) {
        // Close loading dialog
        if (context.mounted) {
          Navigator.pop(context);
        }
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Form validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email address';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select date of birth';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select gender';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // TODO: Load existing profile data if needed
    // _loadProfileData();
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
      body: Form(
        key: _formKey,
        child: ListView(
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
                        : null,
                    child: _profileImage == null
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
                    "Full Name *",
                    w * 0.04,
                    FontWeight.w500,
                    AppColors.black,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * .01),
                  AppFormFields.custTextFormOther(
                    context: context,
                    hintText: "Monika",
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    validator: _validateName,
                  ),
                  SizedBox(height: w * .04),
                  // Mobile Number
                  AppFonts.textPoppins(
                    context,
                    "Mobile number *",
                    w * 0.04,
                    FontWeight.w500,
                    AppColors.black,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * .01),
                  AppFormFields.custTextFormOther(
                    context: context,
                    hintText: "+91 8344661034",
                    controller: mobileNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: _validateMobile,
                  ),
                  SizedBox(height: w * .04),
                  // Email
                  AppFonts.textPoppins(
                    context,
                    "Email *",
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
                    "Date of birth *",
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
                    validator: _validateDOB,
                    onClicked: () async {
                      DateTime initialDate = DateTime.now().subtract(
                        const Duration(days: 365 * 20),
                      );
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          dobController.text = DateFormat(
                            "dd/MM/yyyy",
                          ).format(picked);
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
                    "Gender *",
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
                    validator: _validateGender,
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
                              ...["Male", "Female", "Other"].map((gender) {
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
                  AppButtons.solid(
                    context: context,
                    text: "Profile Update",
                    onClicked: _updateProfile,
                    isFullWidth: true,
                    backgroundColor: AppColors.primaryRed,
                    textColor: AppColors.white,
                    fontSize: w * .045,
                    height: w * .140,
                    radius: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: w * .3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}