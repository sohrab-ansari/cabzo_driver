// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:nzcu_driver/services/baseurl/api_path.dart';
// import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/edit_profile_controller.dart';
// import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
// import 'package:nzcu_driver/utilities/widgets/form_field.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:nzcu_driver/utilities/colors/colors.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_font.dart';

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

//   final EditProfileController editProfileController = Get.put(
//     EditProfileController(),
//   );

//   final DriveridController driveridController = Get.put(DriveridController());

//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = true;

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

//   Future<void> _updateProfile() async {
//     // Show loading indicator
//     // Get.dialog(
//     //   const Center(child: CircularProgressIndicator()),
//     //   barrierDismissible: false,
//     // );

//     try {
//       await editProfileController.edit_profile_method(
//         image: _profileImage,
//         name: fullNameController.text.trim().isNotEmpty
//             ? fullNameController.text.trim()
//             : null,
//         email: emailController.text.trim().isNotEmpty
//             ? emailController.text.trim()
//             : null,
//         dateOfBirth: dobController.text.isNotEmpty ? dobController.text : null,
//         gender: genderController.text.isNotEmpty ? genderController.text : null,
//       );

//       Get.back(); // Close loading dialog

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Profile updated successfully'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );

//       // Optional: Refresh driver data
//       await driveridController.driverid_mdethod();
//     } catch (e) {
//       Get.back(); // Close loading dialog
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   String? _validateEmail(String? value) {
//     if (value != null && value.isNotEmpty) {
//       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//         return 'Please enter a valid email address';
//       }
//     }
//     return null;
//   }

//   Future<void> _loadProfileData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await driveridController.driverid_mdethod();

//       // Wait a bit for data to load (you might want to use GetX observables instead)
//       await Future.delayed(const Duration(milliseconds: 500));

//       final driver = driveridController.driveridresponse.value?.driver;

//       if (driver != null) {
//         setState(() {
//           // Load data safely with null checks
//           fullNameController.text = driver.name?.toString() ?? '';
//           mobileNumberController.text = driver.phone?.toString() ?? '';
//           emailController.text = driver.email?.toString() ?? '';

//           // Parse and format date of birth if it exists
//           if (driver.dateOfBirth != null) {
//             try {
//               // Assuming date is in a parseable format
//               final parsedDate = DateTime.parse(driver.dateOfBirth.toString());
//               dobController.text = DateFormat("dd/MM/yyyy").format(parsedDate);
//             } catch (e) {
//               dobController.text = driver.dateOfBirth.toString();
//             }
//           }

//           // FIXED: Load gender from correct field
//           genderController.text = driver.gender?.toString() ?? '';
//         });
//       }
//     } catch (e) {
//       debugPrint('Error loading profile data: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }

//   @override
//   void dispose() {
//     fullNameController.dispose();
//     mobileNumberController.dispose();
//     emailController.dispose();
//     dobController.dispose();
//     genderController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     if (_isLoading) {
//       return Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           backgroundColor: ColorsList.scaffoldColor,
//           automaticallyImplyLeading: false,
//           scrolledUnderElevation: 0,
//           titleSpacing: w * .03,
//           title: Row(
//             children: [
//               GestureDetector(
//                 onTap: () => CustomNavigator.pop(context),
//                 child: Icon(
//                   Icons.arrow_back,
//                   size: w * .07,
//                   color: ColorsList.iconColor,
//                 ),
//               ),
//               SizedBox(width: w * .02),
//               CustomText(
//                 text: "Edit Profile",
//                 textColor: ColorsList.titleTextColor,
//                 textFontSize: w * .05,
//                 textFontWeight: FontWeight.w500,
//               ),
//             ],
//           ),
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

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
//               text: "Edit Profile",
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
//                       : driveridController
//                                 .driveridresponse
//                                 .value
//                                 ?.driver
//                                 ?.image !=
//                             null
//                       ? NetworkImage(
//                           ApiPath.imagebaseUrl +
//                               driveridController
//                                   .driveridresponse
//                                   .value!
//                                   .driver!
//                                   .image!,
//                         )
//                       : null,
//                   child:
//                       _profileImage == null &&
//                           (driveridController
//                                   .driveridresponse
//                                   .value
//                                   ?.driver
//                                   ?.image ==
//                               null)
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

//                 // AppFormFields.custTextFormOther(
//                 //   context: context,
//                 //   hintText: "Enter your full name",
//                 //   controller: fullNameController,
//                 //   keyboardType: TextInputType.name,
//                 // ),
//                 AppFormFields.custTextFormOther(
//                   context: context,
//                   hintText: "e.g. Mahavir",
//                   controller: fullNameController,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Name is required';
//                     }
//                     return null;
//                   },

//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(
//                       RegExp('[a-zA-Z ]'),
//                     ), // Allows only letters and spaces
//                   ],
//                 ),

//                 SizedBox(height: w * .04),

//                 // Mobile Number - Disabled
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
//                 AppFormFields.custTextFormOther2(
//                   context: context,
//                   hintText: "Enter mobile number",
//                   controller: mobileNumberController,
//                   keyboardType: TextInputType.number,
//                   maxLength: 10,
//                   enabled: false,
//                   readOnly: true,
//                   fillColor: Colors.grey.shade200,
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
//                 // AppFormFields.custTextFormOther(
//                 //   context: context,
//                 //   hintText: "email@example.com",
//                 //   controller: emailController,
//                 //   keyboardType: TextInputType.emailAddress,
//                 //   validator: _validateEmail,
//                 // ),
//                 TextFormField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Email is required';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Invalid Email';
//                     }
//                     return null;
//                   },
//                   onFieldSubmitted: (value) {
//                     FocusScope.of(context).nextFocus();
//                   },
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(
//                       RegExp(
//                         r'[a-zA-Z0-9@._-]',
//                       ), // Only letters, numbers, @, ., _, -
//                     ),
//                   ],
//                   decoration: InputDecoration(
//                     hintText: "e.g. Mahavir@gmail.com",
//                     prefixIcon: Icon(
//                       Icons.email_outlined,
//                       size: w * 0.05,
//                       color: AppColors.mediumGray,
//                     ),
//                     filled: true,
//                     fillColor: AppColors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: AppColors.mediumGray),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: AppColors.mediumGray),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(
//                         color: AppColors.mediumGray,
//                         width: 2,
//                       ),
//                     ),
//                     // errorBorder: OutlineInputBorder(
//                     //   borderRadius: BorderRadius.circular(
//                     //     8,
//                     //   ),
//                     //   borderSide: BorderSide(
//                     //     color: AppColors.primaryRed2,
//                     //   ),
//                     // ),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: w * 0.04,
//                       vertical: w * 0.03,
//                     ),
//                   ),
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
//                     DateTime? initialDate;

//                     // Try to parse existing date
//                     if (dobController.text.isNotEmpty) {
//                       try {
//                         final parts = dobController.text.split('/');
//                         if (parts.length == 3) {
//                           initialDate = DateTime(
//                             int.parse(parts[2]),
//                             int.parse(parts[1]),
//                             int.parse(parts[0]),
//                           );
//                         }
//                       } catch (e) {
//                         initialDate = DateTime.now().subtract(
//                           const Duration(days: 365 * 25),
//                         );
//                       }
//                     } else {
//                       initialDate = DateTime.now().subtract(
//                         const Duration(days: 365 * 25),
//                       );
//                     }

//                     final DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate:
//                           initialDate ??
//                           DateTime.now().subtract(
//                             const Duration(days: 365 * 25),
//                           ),
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
//                             ...[
//                               "Male",
//                               "Female",
//                               "Other",
//                               "Prefer not to say",
//                             ].map((gender) {
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
//                 Obx(() {
//                   final isLoading = editProfileController.isLoading.value;
//                   return AppButtons.solid2(
//                     context: context,
//                     text: isLoading ? "Updating..." : "Profile Update",
//                     onClicked: _updateProfile,
//                     isFullWidth: true,
//                     backgroundColor: isLoading
//                         ? Colors.grey
//                         : AppColors.primaryRed,
//                     textColor: AppColors.white,
//                     fontSize: w * .045,
//                     height: w * .140,
//                     radius: 12.0,
//                     fontWeight: FontWeight.w500,
//                   );
//                 }),
//                 SizedBox(height: w * .1),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/edit_profile_controller.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/form_field.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

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
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));


            Fluttertoast.showToast(
  msg: "Failed to pick image",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP, // 👈 Top position
  backgroundColor: Colors.green,
  textColor: Colors.white,
  fontSize: 16.0,
);
    }
  }

  Future<void> _updateProfile() async {
    // Validate form before submitting
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Profile updated successfully'),
      //     backgroundColor: Colors.green,
      //     duration: Duration(seconds: 2),
      //   ),
      // );


Fluttertoast.showToast(
  msg: "Profile updated successfully",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP, // 👈 Top position
  backgroundColor: Colors.green,
  textColor: Colors.white,
  fontSize: 16.0,
);
      // Refresh driver data
      await driveridController.driverid_mdethod();

      // Navigate back after successful update
      CustomNavigator.pop(context);
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

  // Simple email validation
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // Simple validation: check if contains @ and .
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Full Name validation
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter the full name';
    }
    return null;
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await driveridController.driverid_mdethod();

      // Wait a bit for data to load
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
              final parsedDate = DateTime.parse(driver.dateOfBirth.toString());
              dobController.text = DateFormat("dd/MM/yyyy").format(parsedDate);
            } catch (e) {
              dobController.text = driver.dateOfBirth.toString();
            }
          }

          // Load gender
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
        body: const Center(child: CircularProgressIndicator()),
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
                        : driveridController
                                  .driveridresponse
                                  .value
                                  ?.driver
                                  ?.image !=
                              null
                        ? NetworkImage(
                            ApiPath.imagebaseUrl +
                                driveridController
                                    .driveridresponse
                                    .value!
                                    .driver!
                                    .image!,
                          )
                        : null,
                    child:
                        _profileImage == null &&
                            (driveridController
                                    .driveridresponse
                                    .value
                                    ?.driver
                                    ?.image ==
                                null)
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
                      child: Container(
                        padding: EdgeInsets.all(w * 0.02),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: w * 0.04,
                          color: Colors.white,
                        ),
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
                  // Full Name Label
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

                  // Full Name Field with validation
                  TextFormField(
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                    ],
                    decoration: InputDecoration(
                      hintText: "e.g. Mahavir",
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: w * 0.05,
                        color: AppColors.mediumGray,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryRed,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: w * 0.03,
                      ),
                    ),
                  ),

                  SizedBox(height: w * .04),

                  // Mobile Number Label
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

                  // Mobile Number Field - Disabled
                  TextFormField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Enter mobile number",
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        size: w * 0.05,
                        color: AppColors.mediumGray,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryRed,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: w * 0.03,
                      ),
                    ),
                  ),
                  SizedBox(height: w * .04),

                  // Email Label
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

                  // Email Field with simple validation
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).nextFocus();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: "e.g. Mahavir@gmail.com",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: w * 0.05,
                        color: AppColors.mediumGray,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryRed,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: w * 0.03,
                      ),
                    ),
                  ),

                  SizedBox(height: w * .04),

                  // Date of Birth Label
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

                  // Date of Birth Field
                  TextFormField(
                    controller: dobController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? initialDate;

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
                        initialDate:
                            initialDate ??
                            DateTime.now().subtract(
                              const Duration(days: 365 * 25),
                            ),
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
                    decoration: InputDecoration(
                      hintText: "DD/MM/YYYY",
                      prefixIcon: Icon(
                        Icons.cake_outlined,
                        size: w * 0.05,
                        color: AppColors.mediumGray,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: AppColors.mediumGray,
                        size: w * 0.055,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryRed,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: w * 0.03,
                      ),
                    ),
                  ),
                  SizedBox(height: w * .04),

                  // Gender Label
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

                  // Gender Field
                  TextFormField(
                    controller: genderController,
                    readOnly: true,
                    onTap: () async {
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
                                padding: EdgeInsets.symmetric(
                                  vertical: w * .04,
                                ),
                                child: Text(
                                  "Select Gender",
                                  style: TextStyle(
                                    fontSize: w * .045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade300),
                              ...[
                                "Male",
                                "Female",
                                "Other",
                                "Prefer not to say",
                              ].map((gender) {
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
                    decoration: InputDecoration(
                      hintText: "Select Gender",
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: w * 0.05,
                        color: AppColors.mediumGray,
                      ),
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.mediumGray,
                        size: w * 0.065,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.mediumGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryRed,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: w * 0.03,
                      ),
                    ),
                  ),
                  SizedBox(height: w * .1),

                  // Update Button
                  Obx(() {
                    final isLoading = editProfileController.isLoading.value;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLoading
                              ? Colors.grey
                              : AppColors.primaryRed,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: w * .04),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isLoading ? "Updating..." : "Profile Update",
                          style: TextStyle(
                            fontSize: w * .045,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: w * .1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
