// import 'dart:convert';
// import 'dart:io';
// import 'package:nzcu_driver/controllers/auth_controllers/driver_register_controller.dart';
// import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';
// import 'package:nzcu_driver/controllers/auth_controllers/vehicle_subtypes_controller.dart';
// import 'package:nzcu_driver/controllers/auth_controllers/vehicle_types_controller.dart';
// import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
// import 'package:nzcu_driver/modals/get_all_vehicle_categories_response.dart'
//     as VehicleTypesModal;
// import 'package:nzcu_driver/modals/get_all_sub_vehicle_categories_response.dart'
//     as VehicleSubTypesModal;
// import 'package:nzcu_driver/utilities/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/custom_document_uploader.dart';
// import 'package:nzcu_driver/utilities/custom_font.dart';
// import 'package:nzcu_driver/utilities/custom_text.dart';
// import 'package:nzcu_driver/utilities/form_field.dart';
// import 'package:nzcu_driver/utilities/navigator.dart';
// import 'package:nzcu_driver/utilities/widgets/vehicleCard.dart';
// import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class DriverRegistration extends StatefulWidget {
//   const DriverRegistration({super.key});

//   @override
//   State<DriverRegistration> createState() => _DriverRegistrationState();
// }

// class _DriverRegistrationState extends State<DriverRegistration> {
//   final DriverFormController driverFormController =
//       Get.find<DriverFormController>();

//   // Scroll controller for each step
//   final ScrollController _scrollController = ScrollController();

//   // Vehicle details controllers
//   final TextEditingController vehicleNameController = TextEditingController();
//   final TextEditingController vehicleNumberController = TextEditingController();
//   final TextEditingController vehicleTypeController = TextEditingController();
//   final TextEditingController vehicleSubTypeController =
//       TextEditingController(); // Added for sub-type
//   final TextEditingController modelController = TextEditingController();
//   final TextEditingController yearController = TextEditingController();
//   final TextEditingController colorController = TextEditingController();
//   final TextEditingController plateNumberController = TextEditingController();

//   // Personal details controllers
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController alternateContact1Controller =
//       TextEditingController();
//   final TextEditingController relation1Controller = TextEditingController();
//   final TextEditingController address1Controller = TextEditingController();
//   final TextEditingController alternateContact2Controller =
//       TextEditingController();
//   final TextEditingController relation2Controller = TextEditingController();
//   final TextEditingController address2Controller = TextEditingController();

//   final LoginController loginController = Get.put(LoginController());

//   final VehicleTypesController vehicleTypesController =
//       Get.find<VehicleTypesController>();

//   final VehicleSubtypesController vehicleSubtypesController =
//       Get.find<VehicleSubtypesController>();

//   // Image files
//   File? _registrationCertificateImage;
//   File? _licencePlateImage;
//   File? _vehicleInsuranceImage;
//   File? _aadharFrontImage;
//   File? _aadharBackImage;
//   File? _panCardImage;
//   File? _driverLicenseImage;
//   File? _profilePhotoImage;

//   bool _isLoading = false;
//   bool _isSubmitting = false;
//   late final DriverRegisterController driverRegisterController;

//   // Form Keys
//   final GlobalKey<FormState> _vehicleFormKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();

//   // Validation Error Flags
//   bool _showVehicleTypeError = false;
//   bool _showVehicleSubTypeError = false;
//   bool _showRcImageError = false;
//   bool _showPlateImageError = false;
//   bool _showInsuranceImageError = false;
//   bool _showAadharFrontError = false;
//   bool _showAadharBackError = false;
//   bool _showPanError = false;
//   bool _showDlError = false;
//   bool _showProfilePhotoError = false;

//   @override
//   void initState() {
//     driverRegisterController = Get.put(DriverRegisterController());
//     // Ensure submission flag is reset when screen loads
//     _isSubmitting = false;
//     print(
//       "🔄 Initialized driver registration screen, _isSubmitting: $_isSubmitting",
//     );
//     super.initState();

//     // Load vehicle types
//     vehicleTypesController.vehicalmethod();

//     // Debug listener for vehicle types
//     ever(vehicleTypesController.cashResponse, (response) {
//       if (response != null) {
//         print("✅ Vehicle types loaded:");
//         print("- Success: ${response.success}");
//         print("- Message: ${response.message}");
//         print("- Total vehicles: ${response.data?.length ?? 0}");
//         if (response.data != null && response.data!.isNotEmpty) {
//           response.data!.forEach((vehicle) {
//             print("  - ${vehicle.name} (ID: ${vehicle.id})");
//           });
//         }
//       }
//     });

//     // Debug listener for vehicle sub-types
//     ever(vehicleSubtypesController.cashResponse, (response) {
//       if (response != null) {
//         print("✅ Vehicle sub-types loaded:");
//         print("- Success: ${response.success}");
//         print("- Message: ${response.message}");
//         print("- Total sub-types: ${response.data?.length ?? 0}");
//         if (response.data != null && response.data!.isNotEmpty) {
//           response.data!.forEach((subType) {
//             print("  - ${subType.name} (ID: ${subType.id})");
//           });
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose all controllers
//     vehicleNameController.dispose();
//     vehicleNumberController.dispose();
//     vehicleTypeController.dispose();
//     vehicleSubTypeController.dispose(); // Dispose sub-type controller
//     modelController.dispose();
//     yearController.dispose();
//     colorController.dispose();
//     plateNumberController.dispose();
//     dobController.dispose();
//     nameController.dispose();
//     phoneNumberController.dispose();
//     emailController.dispose();
//     alternateContact1Controller.dispose();
//     relation1Controller.dispose();
//     address1Controller.dispose();
//     alternateContact2Controller.dispose();
//     relation2Controller.dispose();
//     address2Controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   // Function to scroll to top
//   void _scrollToTop() {
//     _scrollController.animateTo(
//       0,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   // Method to clear vehicle images when moving to next step
//   void _clearVehicleImages() {
//     setState(() {
//       _registrationCertificateImage = null;
//       _licencePlateImage = null;
//       _vehicleInsuranceImage = null;
//     });
//   }

//   // Method to clear personal details images when moving to next step
//   void _clearPersonalDetailsImages() {
//     setState(() {
//       _aadharFrontImage = null;
//       _aadharBackImage = null;
//       _panCardImage = null;
//       _driverLicenseImage = null;
//     });
//   }

//   // Validation helper methods

//   // Method to clear profile photo
//   void _clearProfilePhoto() {
//     setState(() {
//       _profilePhotoImage = null;
//     });
//   }

//   // Function to load vehicle sub-types when a vehicle type is selected
//   void _loadVehicleSubTypes(String vehicleCategoryId) {
//     // Clear previous sub-types data first
//     vehicleSubtypesController.clearData();
//     // Load sub-types for the selected vehicle category with pagination
//     vehicleSubtypesController.subvehicalmethod(
//       vehicalCategoryId: vehicleCategoryId,
//     );
//   }

//   // Show vehicle sub-type bottom sheet with pagination support
//   void _showVehicleSubTypeBottomSheet(BuildContext context, double w) {
//     final ScrollController scrollController = ScrollController();

//     // Add scroll listener for pagination
//     scrollController.addListener(() {
//       if (scrollController.position.pixels >=
//           scrollController.position.maxScrollExtent - 100) {
//         // User is near the bottom, load more if available
//         if (vehicleSubtypesController.hasMorePages.value &&
//             !vehicleSubtypesController.isLoadingMore.value) {
//           vehicleSubtypesController.loadMoreVehicleSubTypes();
//         }
//       }
//     });

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext bottomSheetContext) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               // Handle bar
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: w * .03),
//                 width: w * .12,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.mediumGray,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               // Title
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: w * .04,
//                   vertical: w * .02,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       "Select Vehicle Sub-Type",
//                       w * 0.045,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                     Obx(
//                       () => AppFonts.textPoppins(
//                         context,
//                         "${vehicleSubtypesController.allVehicleSubTypes.length}/${vehicleSubtypesController.totalItems.value}",
//                         w * 0.035,
//                         FontWeight.w400,
//                         AppColors.mediumGray,
//                         TextAlign.right,
//                         TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(color: AppColors.mediumGray.withOpacity(0.3)),
//               // Scrollable list
//               Expanded(
//                 child: Obx(() {
//                   final items = vehicleSubtypesController.allVehicleSubTypes;

//                   if (items.isEmpty &&
//                       !vehicleSubtypesController.isLoading.value) {
//                     return Center(
//                       child: AppFonts.textPoppins(
//                         context,
//                         "No vehicle sub-types available",
//                         w * 0.04,
//                         FontWeight.w400,
//                         AppColors.mediumGray,
//                         TextAlign.center,
//                         TextOverflow.ellipsis,
//                       ),
//                     );
//                   }

//                   return ListView.builder(
//                     controller: scrollController,
//                     padding: EdgeInsets.symmetric(horizontal: w * .04),
//                     itemCount: items.length + 1, // +1 for loading indicator
//                     itemBuilder: (context, index) {
//                       // Loading indicator at the bottom
//                       if (index == items.length) {
//                         return Obx(() {
//                           if (vehicleSubtypesController.isLoadingMore.value) {
//                             return Container(
//                               padding: EdgeInsets.symmetric(vertical: w * .04),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               AppColors.primaryRed,
//                                             ),
//                                       ),
//                                     ),
//                                     SizedBox(width: w * .02),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Loading more...",
//                                       w * 0.035,
//                                       FontWeight.w400,
//                                       AppColors.mediumGray,
//                                       TextAlign.center,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else if (vehicleSubtypesController
//                               .hasMorePages
//                               .value) {
//                             // Show "scroll to load more" hint
//                             return Container(
//                               padding: EdgeInsets.symmetric(vertical: w * .03),
//                               child: Center(
//                                 child: AppFonts.textPoppins(
//                                   context,
//                                   "Scroll down to load more",
//                                   w * 0.03,
//                                   FontWeight.w400,
//                                   AppColors.mediumGray.withOpacity(0.6),
//                                   TextAlign.center,
//                                   TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             // No more items
//                             return SizedBox(height: w * .02);
//                           }
//                         });
//                       }

//                       final datum = items[index];
//                       final isSelected =
//                           vehicleSubTypeController.text == datum.id;

//                       return InkWell(
//                         onTap: () {
//                           if (datum.id != null) {
//                             setState(() {
//                               vehicleSubTypeController.text = datum.id!;
//                             });

//                             // Show selection
//                             print(
//                               "Selected vehicle sub-type: ${datum.name} (ID: ${datum.id})",
//                             );

//                             Get.snackbar(
//                               "Selected",
//                               "${datum.name}",
//                               snackPosition: SnackPosition.BOTTOM,
//                               duration: Duration(seconds: 1),
//                               backgroundColor: AppColors.primaryRed.withOpacity(
//                                 0.9,
//                               ),
//                               colorText: Colors.white,
//                             );

//                             // Close the bottom sheet
//                             Navigator.pop(bottomSheetContext);
//                           }
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             vertical: w * .035,
//                             horizontal: w * .02,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? AppColors.primaryRed.withOpacity(0.1)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(8),
//                             border: isSelected
//                                 ? Border.all(
//                                     color: AppColors.primaryRed.withOpacity(
//                                       0.3,
//                                     ),
//                                   )
//                                 : null,
//                           ),
//                           margin: EdgeInsets.only(bottom: w * .02),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppFonts.textPoppins(
//                                       context,
//                                       datum.name ?? "Unknown",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       isSelected
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     if (datum.minimumPrice != null ||
//                                         datum.baseFare != null)
//                                       Padding(
//                                         padding: EdgeInsets.only(top: w * .01),
//                                         child: AppFonts.textPoppins(
//                                           context,
//                                           "Min: ₹${datum.minimumPrice ?? 0} | Base: ₹${datum.baseFare ?? 0}",
//                                           w * 0.03,
//                                           FontWeight.w400,
//                                           AppColors.mediumGray,
//                                           TextAlign.left,
//                                           TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                               if (isSelected)
//                                 Icon(
//                                   Icons.check_circle,
//                                   color: AppColors.primaryRed,
//                                   size: w * .06,
//                                 ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//             ],
//           ),
//         );
//       },
//     ).then((_) {
//       // Dispose scroll controller when bottom sheet is closed
//       scrollController.dispose();
//     });
//   }

//   // Show vehicle type bottom sheet with pagination support
//   void _showVehicleTypeBottomSheet(
//     BuildContext context,
//     double w,
//     List<VehicleTypesModal.Datum> vehicleList,
//   ) {
//     final ScrollController scrollController = ScrollController();

//     // Add scroll listener for pagination
//     scrollController.addListener(() {
//       if (scrollController.position.pixels >=
//           scrollController.position.maxScrollExtent - 100) {
//         // User is near the bottom, load more if available
//         if (vehicleTypesController.hasMorePages.value &&
//             !vehicleTypesController.isLoadingMore.value) {
//           vehicleTypesController.loadMoreVehicleTypes();
//         }
//       }
//     });

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext bottomSheetContext) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               // Handle bar
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: w * .03),
//                 width: w * .12,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.mediumGray,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               // Title
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: w * .04,
//                   vertical: w * .02,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       "Select Vehicle Type",
//                       w * 0.045,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.ellipsis,
//                     ),
//                     Obx(
//                       () => AppFonts.textPoppins(
//                         context,
//                         "${vehicleTypesController.allVehicleTypes.length}/${vehicleTypesController.totalItems.value}",
//                         w * 0.035,
//                         FontWeight.w400,
//                         AppColors.mediumGray,
//                         TextAlign.right,
//                         TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(color: AppColors.mediumGray.withOpacity(0.3)),
//               // Scrollable list
//               Expanded(
//                 child: Obx(() {
//                   final items = vehicleTypesController.allVehicleTypes;
//                   return ListView.builder(
//                     controller: scrollController,
//                     padding: EdgeInsets.symmetric(horizontal: w * .04),
//                     itemCount: items.length + 1, // +1 for loading indicator
//                     itemBuilder: (context, index) {
//                       // Loading indicator at the bottom
//                       if (index == items.length) {
//                         return Obx(() {
//                           if (vehicleTypesController.isLoadingMore.value) {
//                             return Container(
//                               padding: EdgeInsets.symmetric(vertical: w * .04),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               AppColors.primaryRed,
//                                             ),
//                                       ),
//                                     ),
//                                     SizedBox(width: w * .02),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Loading more...",
//                                       w * 0.035,
//                                       FontWeight.w400,
//                                       AppColors.mediumGray,
//                                       TextAlign.center,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else if (vehicleTypesController
//                               .hasMorePages
//                               .value) {
//                             // Show "scroll to load more" hint
//                             return Container(
//                               padding: EdgeInsets.symmetric(vertical: w * .03),
//                               child: Center(
//                                 child: AppFonts.textPoppins(
//                                   context,
//                                   "Scroll down to load more",
//                                   w * 0.03,
//                                   FontWeight.w400,
//                                   AppColors.mediumGray.withOpacity(0.6),
//                                   TextAlign.center,
//                                   TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             // No more items
//                             return SizedBox(height: w * .02);
//                           }
//                         });
//                       }

//                       final datum = items[index];
//                       final isSelected = vehicleTypeController.text == datum.id;

//                       return InkWell(
//                         onTap: () {
//                           if (datum.id != null) {
//                             setState(() {
//                               vehicleTypeController.text = datum.id!;

//                               // Clear the sub-type selection when vehicle type changes
//                               vehicleSubTypeController.clear();

//                               // Load vehicle sub-types for the selected vehicle type
//                               _loadVehicleSubTypes(datum.id!);
//                             });

//                             // Show selection
//                             print(
//                               "Selected vehicle type: ${datum.name} (ID: ${datum.id})",
//                             );

//                             Get.snackbar(
//                               "Selected",
//                               "${datum.name}",
//                               snackPosition: SnackPosition.BOTTOM,
//                               duration: Duration(seconds: 1),
//                               backgroundColor: AppColors.primaryRed.withOpacity(
//                                 0.9,
//                               ),
//                               colorText: Colors.white,
//                             );

//                             // Close the bottom sheet
//                             Navigator.pop(bottomSheetContext);
//                           }
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             vertical: w * .035,
//                             horizontal: w * .02,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? AppColors.primaryRed.withOpacity(0.1)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(8),
//                             border: isSelected
//                                 ? Border.all(
//                                     color: AppColors.primaryRed.withOpacity(
//                                       0.3,
//                                     ),
//                                   )
//                                 : null,
//                           ),
//                           margin: EdgeInsets.only(bottom: w * .02),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppFonts.textPoppins(
//                                       context,
//                                       datum.name ?? "Unknown",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       isSelected
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     if (datum.minimumPrice != null ||
//                                         datum.baseFare != null)
//                                       Padding(
//                                         padding: EdgeInsets.only(top: w * .01),
//                                         child: AppFonts.textPoppins(
//                                           context,
//                                           "Min: ₹${datum.minimumPrice ?? 0} | Base: ₹${datum.baseFare ?? 0}",
//                                           w * 0.03,
//                                           FontWeight.w400,
//                                           AppColors.mediumGray,
//                                           TextAlign.left,
//                                           TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                               if (isSelected)
//                                 Icon(
//                                   Icons.check_circle,
//                                   color: AppColors.primaryRed,
//                                   size: w * .06,
//                                 ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//             ],
//           ),
//         );
//       },
//     ).then((_) {
//       // Dispose scroll controller when bottom sheet is closed
//       scrollController.dispose();
//     });
//   }

//   Future<void> _submitVehicleDetails() async {
//     setState(() {
//       _showVehicleTypeError = false;
//       _showVehicleSubTypeError = false;
//       _showRcImageError = false;
//       _showPlateImageError = false;
//       _showInsuranceImageError = false;

//       // Custom validations
//       if (vehicleTypeController.text.isEmpty) _showVehicleTypeError = true;
//       if (vehicleSubTypeController.text.isEmpty)
//         _showVehicleSubTypeError = true;
//       if (_registrationCertificateImage == null) _showRcImageError = true;
//       if (_licencePlateImage == null) _showPlateImageError = true;
//       if (_vehicleInsuranceImage == null) _showInsuranceImageError = true;
//     });

//     if (_vehicleFormKey.currentState!.validate()) {
//       // Form fields are valid, check custom fields
//       if (_showVehicleTypeError ||
//           _showVehicleSubTypeError ||
//           _showRcImageError ||
//           _showPlateImageError ||
//           _showInsuranceImageError) {
//         Get.snackbar(
//           'Incomplete Form',
//           'Please fill all fields and upload all required documents',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//     } else {
//       // Form fields invalid
//       Get.snackbar(
//         'Incomplete Form',
//         'Please fill all fields correctly',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     print("myyy_vehicallll_number ${vehicleNumberController.text}");

//     // Debug all fields
//     print("=== VEHICLE DETAILS DEBUG ===");
//     print("Vehicle Name: ${vehicleNameController.text}");
//     print("Vehicle Number: ${vehicleNumberController.text}");
//     print("Vehicle Type (ID): ${vehicleTypeController.text}");
//     print("Vehicle Sub-Type (ID): ${vehicleSubTypeController.text}");
//     print("Model: ${modelController.text}");
//     print("Year: ${yearController.text}");
//     print("Color: ${colorController.text}");
//     print("Plate Number: ${plateNumberController.text}");
//     print("=============================");

//     // Find and print the selected vehicle name
//     final vehicleData = vehicleTypesController.cashResponse.value;
//     String? selectedVehicleName = "Unknown";
//     if (vehicleData != null && vehicleData.data != null) {
//       final selectedVehicle = vehicleData.data!.firstWhere(
//         (vehicle) => vehicle.id == vehicleTypeController.text,
//         orElse: () => VehicleTypesModal.Datum(),
//       );
//       if (selectedVehicle.name != null) {
//         selectedVehicleName = selectedVehicle.name;
//         print("Selected Vehicle Name: $selectedVehicleName");
//       }
//     }

//     // Find and print the selected vehicle sub-type name
//     final subTypeData = vehicleSubtypesController.cashResponse.value;
//     String? selectedSubTypeName = "Unknown";
//     if (subTypeData != null && subTypeData.data != null) {
//       final selectedSubType = subTypeData.data!.firstWhere(
//         (subType) => subType.id == vehicleSubTypeController.text,
//         orElse: () => VehicleSubTypesModal.Datum(),
//       );
//       if (selectedSubType.name != null) {
//         selectedSubTypeName = selectedSubType.name;
//         print("Selected Vehicle Sub-Type Name: $selectedSubTypeName");
//       }
//     }

//     if (_isLoading) return;

//     // Validate required fields
//     if (vehicleNameController.text.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter vehicle name',
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     if (vehicleNumberController.text.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter vehicle number',
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     if (vehicleTypeController.text.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please select a vehicle type',
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     if (vehicleSubTypeController.text.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please select a vehicle sub-type',
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     if (modelController.text.isEmpty) {
//       Get.snackbar('Error', 'Please enter model', backgroundColor: Colors.red);
//       return;
//     }

//     setState(() {
//       _showVehicleTypeError = false;
//       _showVehicleSubTypeError = false;
//       _showRcImageError = false;
//       _showPlateImageError = false;
//       _showInsuranceImageError = false;

//       // Custom validations
//       if (vehicleTypeController.text.isEmpty) _showVehicleTypeError = true;
//       if (vehicleSubTypeController.text.isEmpty)
//         _showVehicleSubTypeError = true;
//       if (_registrationCertificateImage == null) _showRcImageError = true;
//       if (_licencePlateImage == null) _showPlateImageError = true;
//       if (_vehicleInsuranceImage == null) _showInsuranceImageError = true;
//     });

//     if (_vehicleFormKey.currentState!.validate()) {
//       // Form fields are valid, check custom fields
//       if (_showVehicleTypeError ||
//           _showVehicleSubTypeError ||
//           _showRcImageError ||
//           _showPlateImageError ||
//           _showInsuranceImageError) {
//         Get.snackbar(
//           'Incomplete Form',
//           'Please fill all fields and upload all required documents',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//     } else {
//       // Form fields invalid
//       Get.snackbar(
//         'Incomplete Form',
//         'Please fill all fields correctly',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       print(
//         "the____idddisssss_sub_carigoriee_id ${vehicleSubTypeController.text}",
//       );
//       await loginController.createVehicleMethod(
//         vehicleName: vehicleNameController.text,
//         driverId: "", // You need to get the driver ID from somewhere
//         vehicleCapacity: 4, // Add vehicle capacity field if needed
//         vehicleColor: colorController.text,
//         vehicleModel: modelController.text,
//         vehicleNumber: vehicleNumberController.text,
//         vehicleStatus: "Active",
//         vehicleType: vehicleTypeController.text,
//         vehicleSubType: vehicleSubTypeController
//             .text, // Add this if your API accepts sub-type
//         vehicleYear: int.tryParse(yearController.text),
//         rcImage: _registrationCertificateImage,
//         vehicleInsuraneImage: _vehicleInsuranceImage,
//         vehicleNumberImage: _licencePlateImage,
//       );

//       print("✅ Vehicle details submitted successfully");
//       print("✅ Vehicle Number submitted: ${vehicleNumberController.text}");
//       print("✅ Vehicle Type ID submitted: ${vehicleTypeController.text}");
//       print(
//         "✅ Vehicle Sub-Type ID submitted: ${vehicleSubTypeController.text}",
//       );

//       // Move to next step
//       // driverFormController.activeStep.value = 2;
//       // Clear vehicle images
//       _clearVehicleImages();
//       // Scroll to top
//       _scrollToTop();
//     } catch (e) {
//       print("❌ Error submitting vehicle details: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to submit vehicle details: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _submitPersonalDetails() async {
//     setState(() {
//       _showAadharFrontError = false;
//       _showAadharBackError = false;
//       _showPanError = false;
//       _showDlError = false;

//       if (_aadharFrontImage == null) _showAadharFrontError = true;
//       if (_aadharBackImage == null) _showAadharBackError = true;
//       if (_panCardImage == null) _showPanError = true;
//       if (_driverLicenseImage == null) _showDlError = true;
//     });

//     if (_personalFormKey.currentState!.validate()) {
//       if (_showAadharFrontError ||
//           _showAadharBackError ||
//           _showPanError ||
//           _showDlError) {
//         Get.snackbar(
//           'Incomplete Form',
//           'Please upload all required documents',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//     } else {
//       Get.snackbar(
//         'Incomplete Form',
//         'Please fill all fields correctly',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     print("✅ All validations passed, starting submission...");

//     print("✅ All validations passed, starting submission...");
//     print("Files to upload:");
//     print("- DL Image: ${_driverLicenseImage?.path}");
//     print("- Aadhar Front: ${_aadharFrontImage?.path}");
//     print("- Aadhar Back: ${_aadharBackImage?.path}");
//     print("- PAN Image: ${_panCardImage?.path}");

//     setState(() {
//       _isSubmitting = true;
//       print("📝 Set _isSubmitting to TRUE");
//     });

//     try {
//       print("📤 Calling createRegisterMethod...");
//       // Call the API method with File objects directly
//       await loginController.createRegisterMethod(
//         name: nameController.text,
//         aadharBack: _aadharBackImage,
//         aadharFront: _aadharFrontImage,
//         dlImage: _driverLicenseImage,
//         email: emailController.text,
//         panImage: _panCardImage,
//         phone: phoneNumberController.text,
//         dob: dobController.text,
//         alternateContact1: alternateContact1Controller.text.isNotEmpty
//             ? alternateContact1Controller.text
//             : null,
//         relation1: relation1Controller.text.isNotEmpty
//             ? relation1Controller.text
//             : null,
//         address1: address1Controller.text.isNotEmpty
//             ? address1Controller.text
//             : null,
//         alternateContact2: alternateContact2Controller.text.isNotEmpty
//             ? alternateContact2Controller.text
//             : null,
//         relation2: relation2Controller.text.isNotEmpty
//             ? relation2Controller.text
//             : null,
//         address2: address2Controller.text.isNotEmpty
//             ? address2Controller.text
//             : null,
//       );

//       print("✅ Personal details submitted successfully");

//       // Move to next step
//       // driverFormController.activeStep.value = 3;
//       // Clear personal details images
//       _clearPersonalDetailsImages();
//       // Scroll to top
//       _scrollToTop();
//     } catch (e, stackTrace) {
//       print("❌ Error in submission: $e");
//       print("Stack trace: $stackTrace");
//       Get.snackbar(
//         'Error',
//         'Failed to submit personal details: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSubmitting = false;
//           print("📝 Set _isSubmitting to FALSE");
//         });
//       } else {
//         _isSubmitting = false;
//         print("📝 Set _isSubmitting to FALSE (widget not mounted)");
//       }
//       print("🏁 Submission process completed");
//     }
//   }

//   Future<void> _submitProfilePhoto() async {
//     setState(() {
//       _showProfilePhotoError = false;
//       if (_profilePhotoImage == null) {
//         _showProfilePhotoError = true;
//       }
//     });

//     if (_showProfilePhotoError) {
//       Get.snackbar(
//         'Error',
//         'Please upload your profile photo',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     setState(() {
//       _isSubmitting = true;
//     });

//     print("\n📸 ===== SUBMIT PROFILE PHOTO =====");
//     print("Image Path: ${_profilePhotoImage?.path}");

//     try {
//       // Call the image upload API and wait for it to complete
//       await loginController.upload_new_image(
//         image: _profilePhotoImage!,
//         context: context,
//       );

//       print("✅ Profile photo uploaded successfully");

//       // Show success message
//       // Get.snackbar(
//       //   'Success',
//       //   'Registration completed successfully!',
//       //   backgroundColor: Colors.green,
//       //   colorText: Colors.white,
//       // );

//       // // Navigate to main screen after a delay
//       // await Future.delayed(Duration(seconds: 2));

//       // CustomNavigator.push(
//       //   context,
//       //   BottomnavmainScreen(),
//       //   transition: TransitionType.fade,
//       // );
//     } catch (e) {
//       print("❌ Failed to upload profile photo: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to submit profile photo: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//       print("\n🏁 PROFILE PHOTO SUBMISSION COMPLETED");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: ColorsList.scaffoldColor,
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         titleSpacing: w * .03,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (driverFormController.activeStep.value > 0 &&
//                     driverFormController.activeStep.value <= 3) {
//                   driverFormController.activeStep.value--;
//                   _scrollToTop();
//                 } else {
//                   CustomNavigator.pop(context);
//                 }
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 size: w * .07,
//                 color: ColorsList.iconColor,
//               ),
//             ),
//             SizedBox(width: w * .02),
//             CustomText(
//               text: "Driver Registration",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Obx(
//             () => EasyStepper(
//               activeStep: driverFormController.activeStep.value,
//               lineStyle: LineStyle(
//                 lineType: LineType.normal,
//                 unreachedLineType: LineType.normal,
//                 defaultLineColor: AppColors.lightGray,
//                 finishedLineColor: AppColors.primaryRed,
//                 lineLength: w * .18,
//                 lineThickness: 2,
//               ),
//               internalPadding: 0,
//               stepRadius: w * 0.04,
//               showStepBorder: false,
//               steps: [
//                 buildStep(
//                   0,
//                   'Preference',
//                   w,
//                   driverFormController.activeStep.value,
//                 ),
//                 buildStep(
//                   1,
//                   'Vehicle Details',
//                   w,
//                   driverFormController.activeStep.value,
//                 ),
//                 buildStep(
//                   2,
//                   'Personal Details',
//                   w,
//                   driverFormController.activeStep.value,
//                 ),
//                 buildStep(
//                   3,
//                   'Profile Photo',
//                   w,
//                   driverFormController.activeStep.value,
//                 ),
//               ],
//               onStepReached: (index) {
//                 driverFormController.reachStep(index);
//                 _scrollToTop();
//               },
//             ),
//           ),
//           Expanded(
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (scrollNotification) {
//                 return false;
//               },
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: 1,
//                 itemBuilder: (context, index) => Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * .03),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Obx(
//                         () => driverFormController.activeStep.value == 0
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: w * .03,
//                                     ),
//                                     child: AppFonts.textPoppins(
//                                       context,
//                                       "Tell us your vehicle preference",
//                                       w * 0.05,
//                                       FontWeight.w600,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   SizedBox(height: w * .02),
//                                   InkWell(
//                                     onTap: () {
//                                       driverFormController.activeStep.value = 1;
//                                       _scrollToTop();
//                                     },
//                                     child: Container(
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               SizedBox(
//                                                 width: w * 0.94,
//                                                 height: h * 0.55,
//                                                 child: vehicleCard(
//                                                   image:
//                                                       "assets/images/image1.png",
//                                                   title: "I have a vehicle",
//                                                   desc:
//                                                       "Register your vehicle to begin driving. A quick verification will get you on the road.",
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: w * .1),
//                                 ],
//                               )
//                             : driverFormController.activeStep.value == 1
//                             ? Form(
//                                 key: _vehicleFormKey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: w * .01,
//                                       ),
//                                       child: AppFonts.textPoppins(
//                                         context,
//                                         "Add your vehicle",
//                                         w * 0.06,
//                                         FontWeight.w500,
//                                         AppColors.black,
//                                         TextAlign.left,
//                                         TextOverflow.visible,
//                                       ),
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Add your car, bike, or auto – drive your way.",
//                                       w * 0.036,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "vehicle name",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Car",
//                                       controller: vehicleNameController,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Vehicle Name is required';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "vehicle number",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Car",
//                                       controller: vehicleNumberController,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Vehicle Number is required';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Vehicle type",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     // Dropdown for Vehicle Type with Pagination
//                                     Obx(() {
//                                       // Check if data is loading (initial load)
//                                       if (vehicleTypesController
//                                               .isLoading
//                                               .value &&
//                                           vehicleTypesController
//                                               .allVehicleTypes
//                                               .isEmpty) {
//                                         return Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: w * .04,
//                                           ),
//                                           height: w * .14,
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: AppColors.mediumGray,
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           child: Center(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 20,
//                                                   height: 20,
//                                                   child: CircularProgressIndicator(
//                                                     strokeWidth: 2,
//                                                     valueColor:
//                                                         AlwaysStoppedAnimation<
//                                                           Color
//                                                         >(AppColors.primaryRed),
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: w * .03),
//                                                 AppFonts.textPoppins(
//                                                   context,
//                                                   "Loading vehicle types...",
//                                                   w * 0.035,
//                                                   FontWeight.w400,
//                                                   AppColors.mediumGray,
//                                                   TextAlign.left,
//                                                   TextOverflow.ellipsis,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       }

//                                       // Check if there's an error or empty data
//                                       if (vehicleTypesController
//                                               .allVehicleTypes
//                                               .isEmpty &&
//                                           !vehicleTypesController
//                                               .isLoading
//                                               .value) {
//                                         // Check if there's an error message
//                                         if (vehicleTypesController
//                                             .errorMessage
//                                             .value
//                                             .isNotEmpty) {
//                                           return Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: w * .04,
//                                             ),
//                                             height: w * .14,
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: Colors.red.withOpacity(
//                                                   0.3,
//                                                 ),
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               color: Colors.red.withOpacity(
//                                                 0.1,
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: AppFonts.textPoppins(
//                                                 context,
//                                                 "Error loading vehicle types",
//                                                 w * 0.035,
//                                                 FontWeight.w400,
//                                                 Colors.red,
//                                                 TextAlign.center,
//                                                 TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           );
//                                         }

//                                         return Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: w * .04,
//                                           ),
//                                           height: w * .14,
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: AppColors.mediumGray,
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           child: Center(
//                                             child: AppFonts.textPoppins(
//                                               context,
//                                               "No vehicle types available",
//                                               w * 0.035,
//                                               FontWeight.w400,
//                                               AppColors.mediumGray,
//                                               TextAlign.center,
//                                               TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         );
//                                       }

//                                       final vehicleList = vehicleTypesController
//                                           .allVehicleTypes;

//                                       // Get selected vehicle name if available
//                                       String selectedName =
//                                           "Select vehicle type";
//                                       if (vehicleTypeController
//                                           .text
//                                           .isNotEmpty) {
//                                         final selected = vehicleList.firstWhere(
//                                           (v) =>
//                                               v.id ==
//                                               vehicleTypeController.text,
//                                           orElse: () =>
//                                               VehicleTypesModal.Datum(),
//                                         );
//                                         if (selected.name != null) {
//                                           selectedName = selected.name!;
//                                         }
//                                       }

//                                       return GestureDetector(
//                                         onTap: () {
//                                           _showVehicleTypeBottomSheet(
//                                             context,
//                                             w,
//                                             vehicleList,
//                                           );
//                                         },
//                                         child: Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: w * .04,
//                                             vertical: w * .035,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: _showVehicleTypeError
//                                                   ? AppColors.primaryRed
//                                                   : AppColors.mediumGray,
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: AppFonts.textPoppins(
//                                                   context,
//                                                   selectedName,
//                                                   w * 0.035,
//                                                   FontWeight.w400,
//                                                   vehicleTypeController
//                                                           .text
//                                                           .isEmpty
//                                                       ? AppColors.mediumGray
//                                                       : AppColors.black,
//                                                   TextAlign.left,
//                                                   TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                               Icon(
//                                                 Icons.arrow_drop_down,
//                                                 color: AppColors.primaryRed,
//                                                 size: w * 0.07,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }),

//                                     /////////////////////////////////////
//                                     // VEHICLE SUB-TYPE DROPDOWN
//                                     SizedBox(height: w * .04),

//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Vehicle sub type",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     // Combine Obx with regular widget logic
//                                     Container(
//                                       height: w * .14,
//                                       child: Column(
//                                         children: [
//                                           // First check if vehicle type is selected (non-reactive check)
//                                           if (vehicleTypeController
//                                               .text
//                                               .isEmpty)
//                                             Container(
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: w * .04,
//                                               ),
//                                               height: w * .14,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   color: AppColors.mediumGray,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               child: Center(
//                                                 child: AppFonts.textPoppins(
//                                                   context,
//                                                   "Please select a vehicle type first",
//                                                   w * 0.035,
//                                                   FontWeight.w400,
//                                                   AppColors.mediumGray,
//                                                   TextAlign.center,
//                                                   TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             )
//                                           else
//                                             // Use Obx only for the reactive part
//                                             Obx(() {
//                                               // Check if data is loading
//                                               if (vehicleSubtypesController
//                                                   .isLoading
//                                                   .value) {
//                                                 return Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: w * .04,
//                                                   ),
//                                                   height: w * .14,
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                       color:
//                                                           AppColors.mediumGray,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           8,
//                                                         ),
//                                                   ),
//                                                   child: Center(
//                                                     child: Row(
//                                                       children: [
//                                                         CircularProgressIndicator(
//                                                           strokeWidth: 2,
//                                                           valueColor:
//                                                               AlwaysStoppedAnimation<
//                                                                 Color
//                                                               >(
//                                                                 AppColors
//                                                                     .primaryRed,
//                                                               ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: w * .03,
//                                                         ),
//                                                         AppFonts.textPoppins(
//                                                           context,
//                                                           "Loading vehicle sub-types...",
//                                                           w * 0.035,
//                                                           FontWeight.w400,
//                                                           AppColors.mediumGray,
//                                                           TextAlign.left,
//                                                           TextOverflow.ellipsis,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               }

//                                               // Check if there's an error or empty data
//                                               if (vehicleSubtypesController
//                                                           .cashResponse
//                                                           .value ==
//                                                       null ||
//                                                   vehicleSubtypesController
//                                                           .cashResponse
//                                                           .value!
//                                                           .data ==
//                                                       null ||
//                                                   vehicleSubtypesController
//                                                       .cashResponse
//                                                       .value!
//                                                       .data!
//                                                       .isEmpty) {
//                                                 // Check if there's an error message
//                                                 if (vehicleSubtypesController
//                                                     .errorMessage
//                                                     .value
//                                                     .isNotEmpty) {
//                                                   return Container(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                           horizontal: w * .04,
//                                                         ),
//                                                     height: w * .14,
//                                                     decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                         color: Colors.red
//                                                             .withOpacity(0.3),
//                                                       ),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             8,
//                                                           ),
//                                                       color: Colors.red
//                                                           .withOpacity(0.1),
//                                                     ),
//                                                     child: Center(
//                                                       child: AppFonts.textPoppins(
//                                                         context,
//                                                         "Error loading vehicle sub-types: ${vehicleSubtypesController.errorMessage.value}",
//                                                         w * 0.035,
//                                                         FontWeight.w400,
//                                                         Colors.red,
//                                                         TextAlign.center,
//                                                         TextOverflow.ellipsis,
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }

//                                                 return Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: w * .04,
//                                                   ),
//                                                   height: w * .14,
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                       color:
//                                                           AppColors.mediumGray,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           8,
//                                                         ),
//                                                   ),
//                                                   child: Center(
//                                                     child: AppFonts.textPoppins(
//                                                       context,
//                                                       "No vehicle sub-types available for this vehicle type",
//                                                       w * 0.035,
//                                                       FontWeight.w400,
//                                                       AppColors.mediumGray,
//                                                       TextAlign.center,
//                                                       TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 );
//                                               }

//                                               final subTypeData =
//                                                   vehicleSubtypesController
//                                                       .cashResponse
//                                                       .value;
//                                               final subTypeList =
//                                                   subTypeData!.data!;

//                                               return Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: w * .04,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                     color:
//                                                         _showVehicleSubTypeError
//                                                         ? AppColors.primaryRed
//                                                         : AppColors.mediumGray,
//                                                   ),
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                 ),
//                                                 child: DropdownButton<String>(
//                                                   value:
//                                                       vehicleSubTypeController
//                                                           .text
//                                                           .isEmpty
//                                                       ? null
//                                                       : vehicleSubTypeController
//                                                             .text,
//                                                   hint: AppFonts.textPoppins(
//                                                     context,
//                                                     "Select vehicle sub-type",
//                                                     w * 0.035,
//                                                     FontWeight.w400,
//                                                     AppColors.mediumGray,
//                                                     TextAlign.left,
//                                                     TextOverflow.ellipsis,
//                                                   ),
//                                                   icon: Icon(
//                                                     Icons.arrow_drop_down,
//                                                     color: AppColors.primaryRed,
//                                                     size: w * 0.07,
//                                                   ),
//                                                   underline: SizedBox(),
//                                                   isExpanded: true,
//                                                   style: TextStyle(
//                                                     fontSize: w * 0.035,
//                                                     color: AppColors.black,
//                                                     fontWeight: FontWeight.w400,
//                                                   ),
//                                                   items: subTypeList
//                                                       .where(
//                                                         (datum) =>
//                                                             datum.id != null &&
//                                                             datum.name != null,
//                                                       ) // Filter out null IDs and names
//                                                       .map<
//                                                         DropdownMenuItem<String>
//                                                       >((
//                                                         VehicleSubTypesModal.Datum
//                                                         datum,
//                                                       ) {
//                                                         return DropdownMenuItem<
//                                                           String
//                                                         >(
//                                                           value: datum.id!,
//                                                           child: Container(
//                                                             padding:
//                                                                 EdgeInsets.symmetric(
//                                                                   vertical:
//                                                                       w * .03,
//                                                                 ),
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 AppFonts.textPoppins(
//                                                                   context,
//                                                                   datum.name ??
//                                                                       "Unknown",
//                                                                   w * 0.045,
//                                                                   FontWeight
//                                                                       .w400,
//                                                                   AppColors
//                                                                       .black,
//                                                                   TextAlign
//                                                                       .left,
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                                 ),
//                                                                 if (datum.minimumPrice !=
//                                                                         null ||
//                                                                     datum.baseFare !=
//                                                                         null)
//                                                                   SizedBox(
//                                                                     height:
//                                                                         w *
//                                                                         .005,
//                                                                   ),
//                                                                 // if (datum.minimumPrice != null &&
//                                                                 //     datum.baseFare != null)
//                                                                 //   AppFonts.textPoppins(
//                                                                 //     context,
//                                                                 //     "Min: ₹${datum.minimumPrice} | Base: ₹${datum.baseFare}",
//                                                                 //     w * 0.025,
//                                                                 //     FontWeight.w400,
//                                                                 //     AppColors.mediumGray,
//                                                                 //     TextAlign.left,
//                                                                 //     TextOverflow.ellipsis,
//                                                                 //   ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       })
//                                                       .toList(),
//                                                   onChanged: (String? newValue) {
//                                                     if (newValue != null) {
//                                                       setState(() {
//                                                         vehicleSubTypeController
//                                                                 .text =
//                                                             newValue;

//                                                         // Find the selected vehicle sub-type
//                                                         final selectedSubType =
//                                                             subTypeList
//                                                                 .firstWhere(
//                                                                   (subType) =>
//                                                                       subType
//                                                                           .id ==
//                                                                       newValue,
//                                                                 );

//                                                         // Show selection
//                                                         print(
//                                                           "Selected vehicle sub-type: ${selectedSubType.name} (ID: $newValue)",
//                                                         );
//                                                         if (selectedSubType
//                                                                 .minimumPrice !=
//                                                             null) {
//                                                           print(
//                                                             "Minimum Price: ${selectedSubType.minimumPrice}",
//                                                           );
//                                                         }
//                                                         if (selectedSubType
//                                                                 .baseFare !=
//                                                             null) {
//                                                           print(
//                                                             "Base Fare: ${selectedSubType.baseFare}",
//                                                           );
//                                                         }

//                                                         Get.snackbar(
//                                                           "Selected",
//                                                           "${selectedSubType.name}",
//                                                           snackPosition:
//                                                               SnackPosition
//                                                                   .BOTTOM,
//                                                           duration: Duration(
//                                                             seconds: 1,
//                                                           ),
//                                                           backgroundColor:
//                                                               AppColors
//                                                                   .primaryRed
//                                                                   .withOpacity(
//                                                                     0.9,
//                                                                   ),
//                                                           colorText:
//                                                               Colors.white,
//                                                         );
//                                                       });
//                                                     }
//                                                   },
//                                                 ),
//                                               );
//                                             }),
//                                         ],
//                                       ),
//                                     ),

//                                     // AppFonts.textPoppins(
//                                     //     context,
//                                     //     "Vehicle sub type",
//                                     //     w * 0.04,
//                                     //     FontWeight.w500,
//                                     //     AppColors.black,
//                                     //     TextAlign.left,
//                                     //     TextOverflow.ellipsis,
//                                     //   ),
//                                     //   SizedBox(height: w * .01),
//                                     //   // Dropdown for Vehicle Sub-Type
//                                     //   Obx(() {
//                                     //     // Check if vehicle type is selected
//                                     //     if (vehicleTypeController.text.isEmpty) {
//                                     //       return Container(
//                                     //         padding: EdgeInsets.symmetric(
//                                     //           horizontal: w * .04,
//                                     //         ),
//                                     //         height: w * .14,
//                                     //         decoration: BoxDecoration(
//                                     //           border: Border.all(
//                                     //             color: AppColors.mediumGray,
//                                     //           ),
//                                     //           borderRadius: BorderRadius.circular(
//                                     //             8,
//                                     //           ),
//                                     //         ),
//                                     //         child: Center(
//                                     //           child: AppFonts.textPoppins(
//                                     //             context,
//                                     //             "Please select a vehicle type first",
//                                     //             w * 0.035,
//                                     //             FontWeight.w400,
//                                     //             AppColors.mediumGray,
//                                     //             TextAlign.center,
//                                     //             TextOverflow.ellipsis,
//                                     //           ),
//                                     //         ),
//                                     //       );
//                                     //     }

//                                     //     // Check if data is loading
//                                     //     if (vehicleSubtypesController
//                                     //         .isLoading
//                                     //         .value) {
//                                     //       return Container(
//                                     //         padding: EdgeInsets.symmetric(
//                                     //           horizontal: w * .04,
//                                     //         ),
//                                     //         height: w * .14,
//                                     //         decoration: BoxDecoration(
//                                     //           border: Border.all(
//                                     //             color: AppColors.mediumGray,
//                                     //           ),
//                                     //           borderRadius: BorderRadius.circular(
//                                     //             8,
//                                     //           ),
//                                     //         ),
//                                     //         child: Center(
//                                     //           child: Row(
//                                     //             children: [
//                                     //               CircularProgressIndicator(
//                                     //                 strokeWidth: 2,
//                                     //                 valueColor:
//                                     //                     AlwaysStoppedAnimation<
//                                     //                       Color
//                                     //                     >(AppColors.primaryRed),
//                                     //               ),
//                                     //               SizedBox(width: w * .03),
//                                     //               AppFonts.textPoppins(
//                                     //                 context,
//                                     //                 "Loading vehicle sub-types...",
//                                     //                 w * 0.035,
//                                     //                 FontWeight.w400,
//                                     //                 AppColors.mediumGray,
//                                     //                 TextAlign.left,
//                                     //                 TextOverflow.ellipsis,
//                                     //               ),
//                                     //             ],
//                                     //           ),
//                                     //         ),
//                                     //       );
//                                     //     }

//                                     //     // Check if there's an error or empty data
//                                     //     if (vehicleSubtypesController
//                                     //                 .cashResponse
//                                     //                 .value ==
//                                     //             null ||
//                                     //         vehicleSubtypesController
//                                     //                 .cashResponse
//                                     //                 .value!
//                                     //                 .data ==
//                                     //             null ||
//                                     //         vehicleSubtypesController
//                                     //             .cashResponse
//                                     //             .value!
//                                     //             .data!
//                                     //             .isEmpty) {
//                                     //       // Check if there's an error message
//                                     //       if (vehicleSubtypesController
//                                     //           .errorMessage
//                                     //           .value
//                                     //           .isNotEmpty) {
//                                     //         return Container(
//                                     //           padding: EdgeInsets.symmetric(
//                                     //             horizontal: w * .04,
//                                     //           ),
//                                     //           height: w * .14,
//                                     //           decoration: BoxDecoration(
//                                     //             border: Border.all(
//                                     //               color: Colors.red.withOpacity(
//                                     //                 0.3,
//                                     //               ),
//                                     //             ),
//                                     //             borderRadius: BorderRadius.circular(
//                                     //               8,
//                                     //             ),
//                                     //             color: Colors.red.withOpacity(0.1),
//                                     //           ),
//                                     //           child: Center(
//                                     //             child: AppFonts.textPoppins(
//                                     //               context,
//                                     //               "Error loading vehicle sub-types: ${vehicleSubtypesController.errorMessage.value}",
//                                     //               w * 0.035,
//                                     //               FontWeight.w400,
//                                     //               Colors.red,
//                                     //               TextAlign.center,
//                                     //               TextOverflow.ellipsis,
//                                     //             ),
//                                     //           ),
//                                     //         );
//                                     //       }

//                                     //       return Container(
//                                     //         padding: EdgeInsets.symmetric(
//                                     //           horizontal: w * .04,
//                                     //         ),
//                                     //         height: w * .14,
//                                     //         decoration: BoxDecoration(
//                                     //           border: Border.all(
//                                     //             color: AppColors.mediumGray,
//                                     //           ),
//                                     //           borderRadius: BorderRadius.circular(
//                                     //             8,
//                                     //           ),
//                                     //         ),
//                                     //         child: Center(
//                                     //           child: AppFonts.textPoppins(
//                                     //             context,
//                                     //             "No vehicle sub-types available for this vehicle type",
//                                     //             w * 0.035,
//                                     //             FontWeight.w400,
//                                     //             AppColors.mediumGray,
//                                     //             TextAlign.center,
//                                     //             TextOverflow.ellipsis,
//                                     //           ),
//                                     //         ),
//                                     //       );
//                                     //     }

//                                     //     final subTypeData = vehicleSubtypesController
//                                     //         .cashResponse
//                                     //         .value;
//                                     //     final subTypeList = subTypeData!.data!;

//                                     //     return Container(
//                                     //       padding: EdgeInsets.symmetric(
//                                     //         horizontal: w * .04,
//                                     //       ),
//                                     //       decoration: BoxDecoration(
//                                     //         border: Border.all(
//                                     //           color: AppColors.mediumGray,
//                                     //         ),
//                                     //         borderRadius: BorderRadius.circular(8),
//                                     //       ),
//                                     //       child: DropdownButton<String>(
//                                     //         value:
//                                     //             vehicleSubTypeController.text.isEmpty
//                                     //             ? null
//                                     //             : vehicleSubTypeController.text,
//                                     //         hint: AppFonts.textPoppins(
//                                     //           context,
//                                     //           "Select vehicle sub-type",
//                                     //           w * 0.035,
//                                     //           FontWeight.w400,
//                                     //           AppColors.mediumGray,
//                                     //           TextAlign.left,
//                                     //           TextOverflow.ellipsis,
//                                     //         ),
//                                     //         icon: Icon(
//                                     //           Icons.arrow_drop_down,
//                                     //           color: AppColors.primaryRed,
//                                     //           size: w * 0.07,
//                                     //         ),
//                                     //         underline: SizedBox(),
//                                     //         isExpanded: true,
//                                     //         style: TextStyle(
//                                     //           fontSize: w * 0.035,
//                                     //           color: AppColors.black,
//                                     //           fontWeight: FontWeight.w400,
//                                     //         ),
//                                     //         items: subTypeList
//                                     //             .where(
//                                     //               (datum) => datum.id != null && datum.name != null,
//                                     //             ) // Filter out null IDs and names
//                                     //             .map<DropdownMenuItem<String>>((
//                                     //               VehicleSubTypesModal.Datum datum,
//                                     //             ) {
//                                     //               return DropdownMenuItem<String>(
//                                     //                 value: datum.id!,
//                                     //                 child: Container(
//                                     //                   padding: EdgeInsets.symmetric(
//                                     //                     vertical: w * .03,
//                                     //                   ),
//                                     //                   child: Column(
//                                     //                     crossAxisAlignment:
//                                     //                         CrossAxisAlignment
//                                     //                             .start,
//                                     //                     children: [
//                                     //                       AppFonts.textPoppins(
//                                     //                         context,
//                                     //                         datum.name ?? "Unknown",
//                                     //                         w * 0.045,
//                                     //                         FontWeight.w400,
//                                     //                         AppColors.black,
//                                     //                         TextAlign.left,
//                                     //                         TextOverflow.ellipsis,
//                                     //                       ),
//                                     //                       if (datum.minimumPrice !=
//                                     //                               null ||
//                                     //                           datum.baseFare !=
//                                     //                               null)
//                                     //                         SizedBox(
//                                     //                           height: w * .005,
//                                     //                         ),
//                                     //                       if (datum.minimumPrice !=
//                                     //                               null &&
//                                     //                           datum.baseFare !=
//                                     //                               null)
//                                     //                         AppFonts.textPoppins(
//                                     //                           context,
//                                     //                           "Min: ₹${datum.minimumPrice} | Base: ₹${datum.baseFare}",
//                                     //                           w * 0.025,
//                                     //                           FontWeight.w400,
//                                     //                           AppColors.mediumGray,
//                                     //                           TextAlign.left,
//                                     //                           TextOverflow.ellipsis,
//                                     //                         ),
//                                     //                     ],
//                                     //                   ),
//                                     //                 ),
//                                     //               );
//                                     //             })
//                                     //             .toList(),
//                                     //         onChanged: (String? newValue) {
//                                     //           if (newValue != null) {
//                                     //             setState(() {
//                                     //               vehicleSubTypeController.text =
//                                     //                   newValue;

//                                     //               // Find the selected vehicle sub-type
//                                     //               final selectedSubType =
//                                     //                   subTypeList.firstWhere(
//                                     //                 (subType) =>
//                                     //                     subType.id == newValue,
//                                     //               );

//                                     //               // Show selection
//                                     //               print(
//                                     //                 "Selected vehicle sub-type: ${selectedSubType.name} (ID: $newValue)",
//                                     //               );
//                                     //               if (selectedSubType.minimumPrice != null) {
//                                     //                 print("Minimum Price: ${selectedSubType.minimumPrice}");
//                                     //               }
//                                     //               if (selectedSubType.baseFare != null) {
//                                     //                 print("Base Fare: ${selectedSubType.baseFare}");
//                                     //               }

//                                     //               Get.snackbar(
//                                     //                 "Selected",
//                                     //                 "${selectedSubType.name}",
//                                     //                 snackPosition:
//                                     //                     SnackPosition.BOTTOM,
//                                     //                 duration: Duration(seconds: 1),
//                                     //                 backgroundColor: AppColors
//                                     //                     .primaryRed
//                                     //                     .withOpacity(0.9),
//                                     //                 colorText: Colors.white,
//                                     //               );
//                                     //             });
//                                     //           }
//                                     //         },
//                                     //       ),
//                                     //     );
//                                     //   }),

//                                     //////////////////////////////
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Model",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Swift Dzire",
//                                       controller: modelController,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Model is required';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             AppFonts.textPoppins(
//                                               context,
//                                               "Year",
//                                               w * 0.04,
//                                               FontWeight.w500,
//                                               AppColors.black,
//                                               TextAlign.left,
//                                               TextOverflow.ellipsis,
//                                             ),
//                                             SizedBox(height: w * .01),
//                                             AppFormFields.custTextFormOther(
//                                               context: context,
//                                               hintText: "e.g. 2014",
//                                               controller: yearController,
//                                               width: w * .45,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.trim().isEmpty) {
//                                                   return 'Year is required';
//                                                 }
//                                                 if (value.length != 4 ||
//                                                     int.tryParse(value) ==
//                                                         null) {
//                                                   return 'Invalid Year';
//                                                 }
//                                                 return null;
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             AppFonts.textPoppins(
//                                               context,
//                                               "Color",
//                                               w * 0.04,
//                                               FontWeight.w500,
//                                               AppColors.black,
//                                               TextAlign.left,
//                                               TextOverflow.ellipsis,
//                                             ),
//                                             SizedBox(height: w * .01),
//                                             AppFormFields.custTextFormOther(
//                                               context: context,
//                                               hintText: "e.g. Black",
//                                               controller: colorController,
//                                               width: w * .45,
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.trim().isEmpty) {
//                                                   return 'Color is required';
//                                                 }
//                                                 return null;
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Licence Plate Number",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. 6WED298",
//                                       controller: plateNumberController,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Plate Number is required';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),

//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Photo of Registration Certificate",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     CustomDocumentUploader(
//                                       width: w,
//                                       height: w * .4,
//                                       borderRadius: 5,
//                                       uploadText: 'Upload',
//                                       borderColor: _showRcImageError
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       errorText: _showRcImageError
//                                           ? "Registration Certificate image is required"
//                                           : null,
//                                       onImageSelected: (File? image) {
//                                         setState(() {
//                                           _registrationCertificateImage = image;
//                                           if (image != null)
//                                             _showRcImageError = false;
//                                         });
//                                       },
//                                       isImageUploaded:
//                                           _registrationCertificateImage != null,
//                                       onClearImage: () {
//                                         setState(() {
//                                           _registrationCertificateImage = null;
//                                         });
//                                       },
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Make sure your Registration Certificate photo are clear and visible.",
//                                       w * 0.025,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Photo of Licence Plate Number",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     CustomDocumentUploader(
//                                       width: w,
//                                       height: w * .4,
//                                       borderRadius: 5,
//                                       uploadText: 'Upload',
//                                       borderColor: _showPlateImageError
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       errorText: _showPlateImageError
//                                           ? "Licence Plate image is required"
//                                           : null,
//                                       onImageSelected: (File? image) {
//                                         setState(() {
//                                           _licencePlateImage = image;
//                                           if (image != null)
//                                             _showPlateImageError = false;
//                                         });
//                                       },
//                                       isImageUploaded:
//                                           _licencePlateImage != null,
//                                       onClearImage: () {
//                                         setState(() {
//                                           _licencePlateImage = null;
//                                         });
//                                       },
//                                     ),

//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Make sure your vehicle's licence plate number photo are clear and visible.",
//                                       w * 0.025,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Photo of Vehicle Insurance",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     CustomDocumentUploader(
//                                       width: w,
//                                       height: w * .4,
//                                       borderRadius: 5,
//                                       uploadText: 'Upload',
//                                       borderColor: _showInsuranceImageError
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       errorText: _showInsuranceImageError
//                                           ? "Vehicle Insurance image is required"
//                                           : null,
//                                       onImageSelected: (File? image) {
//                                         setState(() {
//                                           _vehicleInsuranceImage = image;
//                                           if (image != null)
//                                             _showInsuranceImageError = false;
//                                         });
//                                       },
//                                       isImageUploaded:
//                                           _vehicleInsuranceImage != null,
//                                       onClearImage: () {
//                                         setState(() {
//                                           _vehicleInsuranceImage = null;
//                                         });
//                                       },
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Make sure your vehicle's insurance photo are clear and visible.",
//                                       w * 0.025,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppButtons.solid(
//                                       context: context,
//                                       text: "Continue",
//                                       onClicked: _submitVehicleDetails,
//                                       isLoading: _isLoading,
//                                       isFullWidth: true,
//                                       backgroundColor: AppColors.primaryRed,
//                                       textColor: AppColors.white,
//                                       fontSize: w * .045,
//                                       height: w * .140,
//                                       radius: 12.0,
//                                     ),
//                                     SizedBox(height: w * .1),
//                                   ],
//                                 ), // Closing Column for Step 1
//                               ) // Closing Form for Step 1
//                             : driverFormController.activeStep.value == 2
//                             ? Form(
//                                 key: _personalFormKey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: w * .01,
//                                       ),
//                                       child: AppFonts.textPoppins(
//                                         context,
//                                         "Add your Personal Details",
//                                         w * 0.06,
//                                         FontWeight.w500,
//                                         AppColors.black,
//                                         TextAlign.left,
//                                         TextOverflow.visible,
//                                       ),
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Fill in your details to become a verified driver.",
//                                       w * 0.036,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Name",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Mahavir",
//                                       controller: nameController,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Name is required';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Phone Number",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. 9865431062",
//                                       controller: phoneNumberController,
//                                       keyboardType: TextInputType.number,
//                                       maxLength: 10,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Phone Number is required';
//                                         }
//                                         if (value.length != 10) {
//                                           return 'Phone Number must be 10 digits';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Date of Birth",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "DD/MM/YYYY",
//                                       controller: dobController,
//                                       readOnly: true,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Date of Birth is required';
//                                         }
//                                         return null;
//                                       },
//                                       onClicked: () async {
//                                         DateTime initialDate = DateTime.now()
//                                             .subtract(
//                                               const Duration(days: 365 * 20),
//                                             );
//                                         DateTime firstDate = DateTime(1900);
//                                         DateTime lastDate = DateTime.now();

//                                         final DateTime? picked =
//                                             await showDatePicker(
//                                               context: context,
//                                               initialDate: initialDate,
//                                               firstDate: firstDate,
//                                               lastDate: lastDate,
//                                             );

//                                         if (picked != null) {
//                                           setState(() {
//                                             dobController.text = DateFormat(
//                                               "dd/MM/yyyy",
//                                             ).format(picked);
//                                           });
//                                         }
//                                       },
//                                       suffixIcon: Icon(
//                                         Icons.calendar_month,
//                                         color: AppColors.primaryRed,
//                                         size: w * 0.055,
//                                       ),
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Email",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Mahavir@gmail.com",
//                                       controller: emailController,
//                                       keyboardType: TextInputType.emailAddress,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Email is required';
//                                         }
//                                         if (!value.contains('@')) {
//                                           return 'Invalid Email';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Alternate Contact (1)",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. 9865431062",
//                                       controller: alternateContact1Controller,
//                                       keyboardType: TextInputType.number,
//                                       maxLength: 10,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Alternate Contact is required';
//                                         }
//                                         if (value.length != 10) {
//                                           return 'Phone Number must be 10 digits';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Relation",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Mother",
//                                       controller: relation1Controller,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Relation is required';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Address",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Bhopal",
//                                       controller: address1Controller,
//                                       validator: (value) {
//                                         if (value == null ||
//                                             value.trim().isEmpty) {
//                                           return 'Address is required';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Alternate Contact (2)",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. 9865431062",
//                                       controller: alternateContact2Controller,
//                                       keyboardType: TextInputType.number,
//                                       maxLength: 10,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Relation",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Mother",
//                                       controller: relation2Controller,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Address",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: w * .01),
//                                     AppFormFields.custTextFormOther(
//                                       context: context,
//                                       hintText: "e.g. Bhopal",
//                                       controller: address2Controller,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Upload Photo of Aadhar Card (Front)",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     CustomDocumentUploader(
//                                       width: w,
//                                       height: w * .4,
//                                       borderRadius: 5,
//                                       uploadText: 'Upload',
//                                       borderColor: _showAadharFrontError
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       errorText: _showAadharFrontError
//                                           ? "Aadhar Front image is required"
//                                           : null,
//                                       onImageSelected: (File? image) {
//                                         setState(() {
//                                           _aadharFrontImage = image;
//                                           if (image != null)
//                                             _showAadharFrontError = false;
//                                         });
//                                       },
//                                       isImageUploaded:
//                                           _aadharFrontImage != null,
//                                       onClearImage: () {
//                                         setState(() {
//                                           _aadharFrontImage = null;
//                                         });
//                                       },
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Make sure your Front Aadhar card photo are clear and visible.",
//                                       w * 0.025,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Upload Photo of Aadhar Card (Back)",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     CustomDocumentUploader(
//                                       width: w,
//                                       height: w * .4,
//                                       borderRadius: 5,
//                                       uploadText: 'Upload',
//                                       borderColor: _showAadharBackError
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       errorText: _showAadharBackError
//                                           ? "Aadhar Back image is required"
//                                           : null,
//                                       onImageSelected: (File? image) {
//                                         setState(() {
//                                           _aadharBackImage = image;
//                                           if (image != null)
//                                             _showAadharBackError = false;
//                                         });
//                                       },
//                                       isImageUploaded: _aadharBackImage != null,
//                                       onClearImage: () {
//                                         setState(() {
//                                           _aadharBackImage = null;
//                                         });
//                                       },
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Make sure your Aadhar card back photo are clear and visible.",
//                                       w * 0.025,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Upload Photo of PAN Card",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     CustomDocumentUploader(
//                                       width: w,
//                                       height: w * .4,
//                                       borderRadius: 5,
//                                       uploadText: 'Upload',
//                                       borderColor: _showPanError
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       errorText: _showPanError
//                                           ? "PAN Card image is required"
//                                           : null,
//                                       onImageSelected: (File? image) {
//                                         setState(() {
//                                           _panCardImage = image;
//                                           if (image != null)
//                                             _showPanError = false;
//                                         });
//                                       },
//                                       isImageUploaded: _panCardImage != null,
//                                       onClearImage: () {
//                                         setState(() {
//                                           _panCardImage = null;
//                                         });
//                                       },
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Make sure your PAN card photo are clear and visible.",
//                                       w * 0.025,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: w * .04),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Upload Photo of Driver License",
//                                       w * 0.04,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.ellipsis,
//                                     ),
//                                     CustomDocumentUploader(
//                                       width: w,
//                                       height: w * .4,
//                                       borderRadius: 5,
//                                       uploadText: 'Upload',
//                                       borderColor: _showDlError
//                                           ? AppColors.primaryRed
//                                           : AppColors.black,
//                                       errorText: _showDlError
//                                           ? "Driver License image is required"
//                                           : null,
//                                       onImageSelected: (File? image) {
//                                         setState(() {
//                                           _driverLicenseImage = image;
//                                           if (image != null)
//                                             _showDlError = false;
//                                         });
//                                       },
//                                       isImageUploaded:
//                                           _driverLicenseImage != null,
//                                       onClearImage: () {
//                                         setState(() {
//                                           _driverLicenseImage = null;
//                                         });
//                                       },
//                                     ),
//                                     AppFonts.textPoppins(
//                                       context,
//                                       "Make sure your driver license photo are clear and visible.",
//                                       w * 0.025,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                     SizedBox(height: w * .1),
//                                     AppButtons.solid(
//                                       context: context,
//                                       text: "Continue",
//                                       onClicked: _submitPersonalDetails,
//                                       isLoading: _isSubmitting,
//                                       isFullWidth: true,
//                                       backgroundColor: AppColors.primaryRed,
//                                       textColor: AppColors.white,
//                                       fontSize: w * .045,
//                                       height: w * .140,
//                                       radius: 12.0,
//                                     ),
//                                     SizedBox(height: w * .1),
//                                   ],
//                                 ), // Closing Column for Step 2
//                               ) // Closing Form for Step 2
//                             : driverFormController.activeStep.value == 3
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: w * .01,
//                                     ),
//                                     child: AppFonts.textPoppins(
//                                       context,
//                                       "Add Profile Photo",
//                                       w * 0.06,
//                                       FontWeight.w500,
//                                       AppColors.black,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: w * .8,
//                                     child: AppFonts.textPoppins(
//                                       context,
//                                       "Upload a recent photo of yourself (no sunglasses, no mask).",
//                                       w * 0.036,
//                                       FontWeight.w500,
//                                       AppColors.mediumGray,
//                                       TextAlign.left,
//                                       TextOverflow.visible,
//                                       maxLines: 2,
//                                     ),
//                                   ),
//                                   SizedBox(height: w * .02),
//                                   Center(
//                                     child: Column(
//                                       children: [
//                                         CustomDocumentUploader(
//                                           width: w * .4,
//                                           height: w * .4,
//                                           isCircular: true,
//                                           uploadText: 'Upload',
//                                           borderColor: _showProfilePhotoError
//                                               ? AppColors.primaryRed
//                                               : AppColors.black,
//                                           errorText: _showProfilePhotoError
//                                               ? "Profile Photo is required"
//                                               : null,
//                                           onImageSelected: (File? image) {
//                                             setState(() {
//                                               _profilePhotoImage = image;
//                                               if (image != null)
//                                                 _showProfilePhotoError = false;
//                                             });
//                                           },
//                                           isImageUploaded:
//                                               _profilePhotoImage != null,
//                                           onClearImage: () {
//                                             setState(() {
//                                               _profilePhotoImage = null;
//                                             });
//                                           },
//                                         ),
//                                         SizedBox(
//                                           width: w * .7,
//                                           child: AppFonts.textPoppins(
//                                             context,
//                                             "Your profile photo must clearly show your face.",
//                                             w * 0.036,
//                                             FontWeight.w500,
//                                             AppColors.mediumGray,
//                                             TextAlign.center,
//                                             TextOverflow.visible,
//                                             maxLines: 2,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: w * .4),
//                                   AppButtons.solid(
//                                     context: context,
//                                     text: "Submit",
//                                     onClicked: _submitProfilePhoto,
//                                     isLoading: _isSubmitting,
//                                     isFullWidth: true,
//                                     backgroundColor: AppColors.primaryRed,
//                                     textColor: AppColors.white,
//                                     fontSize: w * .045,
//                                     height: w * .140,
//                                     radius: 12.0,
//                                   ),
//                                   SizedBox(height: w * .1),
//                                 ],
//                               )
//                             : SizedBox(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   EasyStep buildStep(int stepIndex, String title, double w, int activeStep) {
//     bool isActive = activeStep >= stepIndex;

//     return EasyStep(
//       customStep: isActive
//           ? CircleAvatar(
//               radius: w * 0.04,
//               backgroundColor: AppColors.primaryRed,
//               child: Icon(Icons.check, size: w * 0.045, color: AppColors.white),
//             )
//           : CircleAvatar(
//               radius: w * 0.04,
//               backgroundColor: AppColors.lightGray,
//               child: CircleAvatar(
//                 radius: w * 0.025,
//                 backgroundColor: AppColors.white,
//               ),
//             ),
//       customTitle: AppFonts.textPoppins(
//         context,
//         title,
//         w * 0.025,
//         FontWeight.w400,
//         AppColors.black,
//         TextAlign.center,
//         TextOverflow.ellipsis,
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:nzcu_driver/controllers/auth_controllers/driver_register_controller.dart';
import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';
import 'package:nzcu_driver/controllers/auth_controllers/vehicle_subtypes_controller.dart';
import 'package:nzcu_driver/controllers/auth_controllers/vehicle_types_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/modals/get_all_vehicle_categories_response.dart'
    as VehicleTypesModal;
import 'package:nzcu_driver/modals/get_all_sub_vehicle_categories_response.dart'
    as VehicleSubTypesModal;
import 'package:nzcu_driver/utilities/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/custom_document_uploader.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';
import 'package:nzcu_driver/utilities/custom_text.dart';
import 'package:nzcu_driver/utilities/form_field.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/utilities/widgets/vehicleCard.dart';
import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {
  final DriverFormController driverFormController =
      Get.find<DriverFormController>();

  // Scroll controller for each step
  final ScrollController _scrollController = ScrollController();

  // Vehicle details controllers
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController vehicleSubTypeController =
      TextEditingController(); // Added for sub-type
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();

  // Personal details controllers
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alternateContact1Controller =
      TextEditingController();
  final TextEditingController relation1Controller = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController alternateContact2Controller =
      TextEditingController();
  final TextEditingController relation2Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();

  final LoginController loginController = Get.put(LoginController());

  final VehicleTypesController vehicleTypesController =
      Get.find<VehicleTypesController>();

  final VehicleSubtypesController vehicleSubtypesController =
      Get.find<VehicleSubtypesController>();

  // Image files
  File? _registrationCertificateImage;
  File? _licencePlateImage;
  File? _vehicleInsuranceImage;
  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _panCardImage;
  File? _driverLicenseImage;
  File? _profilePhotoImage;

  bool _isLoading = false;
  bool _isSubmitting = false;
  late final DriverRegisterController driverRegisterController;

  // Form Keys
  final GlobalKey<FormState> _vehicleFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();

  // Validation Error Flags
  bool _showVehicleTypeError = false;
  bool _showVehicleSubTypeError = false;
  bool _showRcImageError = false;
  bool _showPlateImageError = false;
  bool _showInsuranceImageError = false;
  bool _showAadharFrontError = false;
  bool _showAadharBackError = false;
  bool _showPanError = false;
  bool _showDlError = false;
  bool _showProfilePhotoError = false;

  @override
  void initState() {
    driverRegisterController = Get.put(DriverRegisterController());
    
    // Clear any existing errors before loading
    vehicleTypesController.clearError();
    vehicleSubtypesController.clearError();
    
    // Ensure submission flag is reset when screen loads
    _isSubmitting = false;
    print(
      "🔄 Initialized driver registration screen, _isSubmitting: $_isSubmitting",
    );
    super.initState();

    // Debug current state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🚀 Initializing Driver Registration Screen");
      print("📊 Vehicle Types Error Message: ${vehicleTypesController.errorMessage.value}");
      print("📊 Vehicle Types Loading: ${vehicleTypesController.isLoading.value}");
      print("📊 Vehicle Types Has Data: ${vehicleTypesController.allVehicleTypes.isNotEmpty}");
    });

    // Load vehicle types
    vehicleTypesController.vehicalmethod();

    // Debug listener for vehicle types
    ever(vehicleTypesController.cashResponse, (response) {
      if (response != null) {
        print("✅ Vehicle types loaded:");
        print("- Success: ${response.success}");
        print("- Message: ${response.message}");
        print("- Total vehicles: ${response.data?.length ?? 0}");
        if (response.data != null && response.data!.isNotEmpty) {
          response.data!.forEach((vehicle) {
            print("  - ${vehicle.name} (ID: ${vehicle.id})");
          });
        }
      }
    });

    // Debug listener for vehicle sub-types
    ever(vehicleSubtypesController.cashResponse, (response) {
      if (response != null) {
        print("✅ Vehicle sub-types loaded:");
        print("- Success: ${response.success}");
        print("- Message: ${response.message}");
        print("- Total sub-types: ${response.data?.length ?? 0}");
        if (response.data != null && response.data!.isNotEmpty) {
          response.data!.forEach((subType) {
            print("  - ${subType.name} (ID: ${subType.id})");
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    vehicleNameController.dispose();
    vehicleNumberController.dispose();
    vehicleTypeController.dispose();
    vehicleSubTypeController.dispose(); // Dispose sub-type controller
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    plateNumberController.dispose();
    dobController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    alternateContact1Controller.dispose();
    relation1Controller.dispose();
    address1Controller.dispose();
    alternateContact2Controller.dispose();
    relation2Controller.dispose();
    address2Controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Function to scroll to top
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Method to clear vehicle images when moving to next step
  void _clearVehicleImages() {
    setState(() {
      _registrationCertificateImage = null;
      _licencePlateImage = null;
      _vehicleInsuranceImage = null;
    });
  }

  // Method to clear personal details images when moving to next step
  void _clearPersonalDetailsImages() {
    setState(() {
      _aadharFrontImage = null;
      _aadharBackImage = null;
      _panCardImage = null;
      _driverLicenseImage = null;
    });
  }

  // Validation helper methods

  // Method to clear profile photo
  void _clearProfilePhoto() {
    setState(() {
      _profilePhotoImage = null;
    });
  }

  // Function to load vehicle sub-types when a vehicle type is selected
  void _loadVehicleSubTypes(String vehicleCategoryId) {
    // Clear previous sub-types data first
    vehicleSubtypesController.clearData();
    // Load sub-types for the selected vehicle category with pagination
    vehicleSubtypesController.subvehicalmethod(
      vehicalCategoryId: vehicleCategoryId,
    );
  }

  // Show vehicle sub-type bottom sheet with pagination support
  void _showVehicleSubTypeBottomSheet(BuildContext context, double w) {
    final ScrollController scrollController = ScrollController();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        // User is near the bottom, load more if available
        if (vehicleSubtypesController.hasMorePages.value &&
            !vehicleSubtypesController.isLoadingMore.value) {
          vehicleSubtypesController.loadMoreVehicleSubTypes();
        }
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: w * .03),
                width: w * .12,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .04,
                  vertical: w * .02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppFonts.textPoppins(
                      context,
                      "Select Vehicle Sub-Type",
                      w * 0.045,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                    Obx(
                      () => AppFonts.textPoppins(
                        context,
                        "${vehicleSubtypesController.allVehicleSubTypes.length}/${vehicleSubtypesController.totalItems.value}",
                        w * 0.035,
                        FontWeight.w400,
                        AppColors.mediumGray,
                        TextAlign.right,
                        TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.mediumGray.withOpacity(0.3)),
              // Scrollable list
              Expanded(
                child: Obx(() {
                  final items = vehicleSubtypesController.allVehicleSubTypes;

                  if (items.isEmpty &&
                      !vehicleSubtypesController.isLoading.value) {
                    return Center(
                      child: AppFonts.textPoppins(
                        context,
                        "No vehicle sub-types available",
                        w * 0.04,
                        FontWeight.w400,
                        AppColors.mediumGray,
                        TextAlign.center,
                        TextOverflow.ellipsis,
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: w * .04),
                    itemCount: items.length + 1, // +1 for loading indicator
                    itemBuilder: (context, index) {
                      // Loading indicator at the bottom
                      if (index == items.length) {
                        return Obx(() {
                          if (vehicleSubtypesController.isLoadingMore.value) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: w * .04),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primaryRed,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: w * .02),
                                    AppFonts.textPoppins(
                                      context,
                                      "Loading more...",
                                      w * 0.035,
                                      FontWeight.w400,
                                      AppColors.mediumGray,
                                      TextAlign.center,
                                      TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (vehicleSubtypesController
                              .hasMorePages
                              .value) {
                            // Show "scroll to load more" hint
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: w * .03),
                              child: Center(
                                child: AppFonts.textPoppins(
                                  context,
                                  "Scroll down to load more",
                                  w * 0.03,
                                  FontWeight.w400,
                                  AppColors.mediumGray.withOpacity(0.6),
                                  TextAlign.center,
                                  TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          } else {
                            // No more items
                            return SizedBox(height: w * .02);
                          }
                        });
                      }

                      final datum = items[index];
                      final isSelected =
                          vehicleSubTypeController.text == datum.id;

                      return InkWell(
                        onTap: () {
                          if (datum.id != null) {
                            setState(() {
                              vehicleSubTypeController.text = datum.id!;
                            });

                            // Show selection
                            print(
                              "Selected vehicle sub-type: ${datum.name} (ID: ${datum.id})",
                            );

                            Get.snackbar(
                              "Selected",
                              "${datum.name}",
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 1),
                              backgroundColor: AppColors.primaryRed.withOpacity(
                                0.9,
                              ),
                              colorText: Colors.white,
                            );

                            // Close the bottom sheet
                            Navigator.pop(bottomSheetContext);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: w * .035,
                            horizontal: w * .02,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryRed.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.primaryRed.withOpacity(
                                      0.3,
                                    ),
                                  )
                                : null,
                          ),
                          margin: EdgeInsets.only(bottom: w * .02),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppFonts.textPoppins(
                                      context,
                                      datum.name ?? "Unknown",
                                      w * 0.04,
                                      FontWeight.w500,
                                      isSelected
                                          ? AppColors.primaryRed
                                          : AppColors.black,
                                      TextAlign.left,
                                      TextOverflow.ellipsis,
                                    ),
                                    if (datum.minimumPrice != null ||
                                        datum.baseFare != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: w * .01),
                                        child: AppFonts.textPoppins(
                                          context,
                                          "Min: ₹${datum.minimumPrice ?? 0} | Base: ₹${datum.baseFare ?? 0}",
                                          w * 0.03,
                                          FontWeight.w400,
                                          AppColors.mediumGray,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryRed,
                                  size: w * .06,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Dispose scroll controller when bottom sheet is closed
      scrollController.dispose();
    });
  }

  // Show vehicle type bottom sheet with pagination support
  void _showVehicleTypeBottomSheet(
    BuildContext context,
    double w,
    List<VehicleTypesModal.Datum> vehicleList,
  ) {
    final ScrollController scrollController = ScrollController();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        // User is near the bottom, load more if available
        if (vehicleTypesController.hasMorePages.value &&
            !vehicleTypesController.isLoadingMore.value) {
          vehicleTypesController.loadMoreVehicleTypes();
        }
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: w * .03),
                width: w * .12,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .04,
                  vertical: w * .02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppFonts.textPoppins(
                      context,
                      "Select Vehicle Type",
                      w * 0.045,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                    Obx(
                      () => AppFonts.textPoppins(
                        context,
                        "${vehicleTypesController.allVehicleTypes.length}/${vehicleTypesController.totalItems.value}",
                        w * 0.035,
                        FontWeight.w400,
                        AppColors.mediumGray,
                        TextAlign.right,
                        TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.mediumGray.withOpacity(0.3)),
              // Scrollable list
              Expanded(
                child: Obx(() {
                  final items = vehicleTypesController.allVehicleTypes;
                  return ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: w * .04),
                    itemCount: items.length + 1, // +1 for loading indicator
                    itemBuilder: (context, index) {
                      // Loading indicator at the bottom
                      if (index == items.length) {
                        return Obx(() {
                          if (vehicleTypesController.isLoadingMore.value) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: w * .04),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primaryRed,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: w * .02),
                                    AppFonts.textPoppins(
                                      context,
                                      "Loading more...",
                                      w * 0.035,
                                      FontWeight.w400,
                                      AppColors.mediumGray,
                                      TextAlign.center,
                                      TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (vehicleTypesController
                              .hasMorePages
                              .value) {
                            // Show "scroll to load more" hint
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: w * .03),
                              child: Center(
                                child: AppFonts.textPoppins(
                                  context,
                                  "Scroll down to load more",
                                  w * 0.03,
                                  FontWeight.w400,
                                  AppColors.mediumGray.withOpacity(0.6),
                                  TextAlign.center,
                                  TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          } else {
                            // No more items
                            return SizedBox(height: w * .02);
                          }
                        });
                      }

                      final datum = items[index];
                      final isSelected = vehicleTypeController.text == datum.id;

                      return InkWell(
                        onTap: () {
                          if (datum.id != null) {
                            setState(() {
                              vehicleTypeController.text = datum.id!;

                              // Clear the sub-type selection when vehicle type changes
                              vehicleSubTypeController.clear();

                              // Load vehicle sub-types for the selected vehicle type
                              _loadVehicleSubTypes(datum.id!);
                            });

                            // Show selection
                            print(
                              "Selected vehicle type: ${datum.name} (ID: ${datum.id})",
                            );

                            Get.snackbar(
                              "Selected",
                              "${datum.name}",
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 1),
                              backgroundColor: AppColors.primaryRed.withOpacity(
                                0.9,
                              ),
                              colorText: Colors.white,
                            );

                            // Close the bottom sheet
                            Navigator.pop(bottomSheetContext);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: w * .035,
                            horizontal: w * .02,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryRed.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.primaryRed.withOpacity(
                                      0.3,
                                    ),
                                  )
                                : null,
                          ),
                          margin: EdgeInsets.only(bottom: w * .02),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppFonts.textPoppins(
                                      context,
                                      datum.name ?? "Unknown",
                                      w * 0.04,
                                      FontWeight.w500,
                                      isSelected
                                          ? AppColors.primaryRed
                                          : AppColors.black,
                                      TextAlign.left,
                                      TextOverflow.ellipsis,
                                    ),
                                    if (datum.minimumPrice != null ||
                                        datum.baseFare != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: w * .01),
                                        child: AppFonts.textPoppins(
                                          context,
                                          "Min: ₹${datum.minimumPrice ?? 0} | Base: ₹${datum.baseFare ?? 0}",
                                          w * 0.03,
                                          FontWeight.w400,
                                          AppColors.mediumGray,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryRed,
                                  size: w * .06,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Dispose scroll controller when bottom sheet is closed
      scrollController.dispose();
    });
  }

  Future<void> _submitVehicleDetails() async {
    setState(() {
      _showVehicleTypeError = false;
      _showVehicleSubTypeError = false;
      _showRcImageError = false;
      _showPlateImageError = false;
      _showInsuranceImageError = false;

      // Custom validations
      if (vehicleTypeController.text.isEmpty) _showVehicleTypeError = true;
      if (vehicleSubTypeController.text.isEmpty)
        _showVehicleSubTypeError = true;
      if (_registrationCertificateImage == null) _showRcImageError = true;
      if (_licencePlateImage == null) _showPlateImageError = true;
      if (_vehicleInsuranceImage == null) _showInsuranceImageError = true;
    });

    if (_vehicleFormKey.currentState!.validate()) {
      // Form fields are valid, check custom fields
      if (_showVehicleTypeError ||
          _showVehicleSubTypeError ||
          _showRcImageError ||
          _showPlateImageError ||
          _showInsuranceImageError) {
        Get.snackbar(
          'Incomplete Form',
          'Please fill all fields and upload all required documents',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    } else {
      // Form fields invalid
      Get.snackbar(
        'Incomplete Form',
        'Please fill all fields correctly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print("myyy_vehicallll_number ${vehicleNumberController.text}");

    // Debug all fields
    print("=== VEHICLE DETAILS DEBUG ===");
    print("Vehicle Name: ${vehicleNameController.text}");
    print("Vehicle Number: ${vehicleNumberController.text}");
    print("Vehicle Type (ID): ${vehicleTypeController.text}");
    print("Vehicle Sub-Type (ID): ${vehicleSubTypeController.text}");
    print("Model: ${modelController.text}");
    print("Year: ${yearController.text}");
    print("Color: ${colorController.text}");
    print("Plate Number: ${plateNumberController.text}");
    print("=============================");

    // Find and print the selected vehicle name
    final vehicleData = vehicleTypesController.cashResponse.value;
    String? selectedVehicleName = "Unknown";
    if (vehicleData != null && vehicleData.data != null) {
      final selectedVehicle = vehicleData.data!.firstWhere(
        (vehicle) => vehicle.id == vehicleTypeController.text,
        orElse: () => VehicleTypesModal.Datum(),
      );
      if (selectedVehicle.name != null) {
        selectedVehicleName = selectedVehicle.name;
        print("Selected Vehicle Name: $selectedVehicleName");
      }
    }

    // Find and print the selected vehicle sub-type name
    final subTypeData = vehicleSubtypesController.cashResponse.value;
    String? selectedSubTypeName = "Unknown";
    if (subTypeData != null && subTypeData.data != null) {
      final selectedSubType = subTypeData.data!.firstWhere(
        (subType) => subType.id == vehicleSubTypeController.text,
        orElse: () => VehicleSubTypesModal.Datum(),
      );
      if (selectedSubType.name != null) {
        selectedSubTypeName = selectedSubType.name;
        print("Selected Vehicle Sub-Type Name: $selectedSubTypeName");
      }
    }

    if (_isLoading) return;

    // Validate required fields
    if (vehicleNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter vehicle name',
        backgroundColor: Colors.red,
      );
      return;
    }

    if (vehicleNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter vehicle number',
        backgroundColor: Colors.red,
      );
      return;
    }

    if (vehicleTypeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a vehicle type',
        backgroundColor: Colors.red,
      );
      return;
    }

    if (vehicleSubTypeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a vehicle sub-type',
        backgroundColor: Colors.red,
      );
      return;
    }

    if (modelController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter model', backgroundColor: Colors.red);
      return;
    }

    setState(() {
      _showVehicleTypeError = false;
      _showVehicleSubTypeError = false;
      _showRcImageError = false;
      _showPlateImageError = false;
      _showInsuranceImageError = false;

      // Custom validations
      if (vehicleTypeController.text.isEmpty) _showVehicleTypeError = true;
      if (vehicleSubTypeController.text.isEmpty)
        _showVehicleSubTypeError = true;
      if (_registrationCertificateImage == null) _showRcImageError = true;
      if (_licencePlateImage == null) _showPlateImageError = true;
      if (_vehicleInsuranceImage == null) _showInsuranceImageError = true;
    });

    if (_vehicleFormKey.currentState!.validate()) {
      // Form fields are valid, check custom fields
      if (_showVehicleTypeError ||
          _showVehicleSubTypeError ||
          _showRcImageError ||
          _showPlateImageError ||
          _showInsuranceImageError) {
        Get.snackbar(
          'Incomplete Form',
          'Please fill all fields and upload all required documents',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    } else {
      // Form fields invalid
      Get.snackbar(
        'Incomplete Form',
        'Please fill all fields correctly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print(
        "the____idddisssss_sub_carigoriee_id ${vehicleSubTypeController.text}",
      );
      await loginController.createVehicleMethod(
        vehicleName: vehicleNameController.text,
        driverId: "", // You need to get the driver ID from somewhere
        vehicleCapacity: 4, // Add vehicle capacity field if needed
        vehicleColor: colorController.text,
        vehicleModel: modelController.text,
        vehicleNumber: vehicleNumberController.text,
        vehicleStatus: "Active",
        vehicleType: vehicleTypeController.text,
        vehicleSubType: vehicleSubTypeController
            .text, // Add this if your API accepts sub-type
        vehicleYear: int.tryParse(yearController.text),
        rcImage: _registrationCertificateImage,
        vehicleInsuraneImage: _vehicleInsuranceImage,
        vehicleNumberImage: _licencePlateImage,
      );

      print("✅ Vehicle details submitted successfully");
      print("✅ Vehicle Number submitted: ${vehicleNumberController.text}");
      print("✅ Vehicle Type ID submitted: ${vehicleTypeController.text}");
      print(
        "✅ Vehicle Sub-Type ID submitted: ${vehicleSubTypeController.text}",
      );

      // Move to next step
      // driverFormController.activeStep.value = 2;
      // Clear vehicle images
      _clearVehicleImages();
      // Scroll to top
      _scrollToTop();
    } catch (e) {
      print("❌ Error submitting vehicle details: $e");
      Get.snackbar(
        'Error',
        'Failed to submit vehicle details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitPersonalDetails() async {
    setState(() {
      _showAadharFrontError = false;
      _showAadharBackError = false;
      _showPanError = false;
      _showDlError = false;

      if (_aadharFrontImage == null) _showAadharFrontError = true;
      if (_aadharBackImage == null) _showAadharBackError = true;
      if (_panCardImage == null) _showPanError = true;
      if (_driverLicenseImage == null) _showDlError = true;
    });

    if (_personalFormKey.currentState!.validate()) {
      if (_showAadharFrontError ||
          _showAadharBackError ||
          _showPanError ||
          _showDlError) {
        Get.snackbar(
          'Incomplete Form',
          'Please upload all required documents',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    } else {
      Get.snackbar(
        'Incomplete Form',
        'Please fill all fields correctly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print("✅ All validations passed, starting submission...");

    print("✅ All validations passed, starting submission...");
    print("Files to upload:");
    print("- DL Image: ${_driverLicenseImage?.path}");
    print("- Aadhar Front: ${_aadharFrontImage?.path}");
    print("- Aadhar Back: ${_aadharBackImage?.path}");
    print("- PAN Image: ${_panCardImage?.path}");

    setState(() {
      _isSubmitting = true;
      print("📝 Set _isSubmitting to TRUE");
    });

    try {
      print("📤 Calling createRegisterMethod...");
      // Call the API method with File objects directly
      await loginController.createRegisterMethod(
        name: nameController.text,
        aadharBack: _aadharBackImage,
        aadharFront: _aadharFrontImage,
        dlImage: _driverLicenseImage,
        email: emailController.text,
        panImage: _panCardImage,
        phone: phoneNumberController.text,
        dob: dobController.text,
        alternateContact1: alternateContact1Controller.text.isNotEmpty
            ? alternateContact1Controller.text
            : null,
        relation1: relation1Controller.text.isNotEmpty
            ? relation1Controller.text
            : null,
        address1: address1Controller.text.isNotEmpty
            ? address1Controller.text
            : null,
        alternateContact2: alternateContact2Controller.text.isNotEmpty
            ? alternateContact2Controller.text
            : null,
        relation2: relation2Controller.text.isNotEmpty
            ? relation2Controller.text
            : null,
        address2: address2Controller.text.isNotEmpty
            ? address2Controller.text
            : null,
      );

      print("✅ Personal details submitted successfully");

      // Move to next step
      // driverFormController.activeStep.value = 3;
      // Clear personal details images
      _clearPersonalDetailsImages();
      // Scroll to top
      _scrollToTop();
    } catch (e, stackTrace) {
      print("❌ Error in submission: $e");
      print("Stack trace: $stackTrace");
      Get.snackbar(
        'Error',
        'Failed to submit personal details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          print("📝 Set _isSubmitting to FALSE");
        });
      } else {
        _isSubmitting = false;
        print("📝 Set _isSubmitting to FALSE (widget not mounted)");
      }
      print("🏁 Submission process completed");
    }
  }

  Future<void> _submitProfilePhoto() async {
    setState(() {
      _showProfilePhotoError = false;
      if (_profilePhotoImage == null) {
        _showProfilePhotoError = true;
      }
    });

    if (_showProfilePhotoError) {
      Get.snackbar(
        'Error',
        'Please upload your profile photo',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    print("\n📸 ===== SUBMIT PROFILE PHOTO =====");
    print("Image Path: ${_profilePhotoImage?.path}");

    try {
      // Call the image upload API and wait for it to complete
      await loginController.upload_new_image(
        image: _profilePhotoImage!,
        context: context,
      );

      print("✅ Profile photo uploaded successfully");

      // Show success message
      // Get.snackbar(
      //   'Success',
      //   'Registration completed successfully!',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );

      // // Navigate to main screen after a delay
      // await Future.delayed(Duration(seconds: 2));

      // CustomNavigator.push(
      //   context,
      //   BottomnavmainScreen(),
      //   transition: TransitionType.fade,
      // );
    } catch (e) {
      print("❌ Failed to upload profile photo: $e");
      Get.snackbar(
        'Error',
        'Failed to submit profile photo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
      print("\n🏁 PROFILE PHOTO SUBMISSION COMPLETED");
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: w * .03,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (driverFormController.activeStep.value > 0 &&
                    driverFormController.activeStep.value <= 3) {
                  driverFormController.activeStep.value--;
                  _scrollToTop();
                } else {
                  CustomNavigator.pop(context);
                }
              },
              child: Icon(
                Icons.arrow_back,
                size: w * .07,
                color: ColorsList.iconColor,
              ),
            ),
            SizedBox(width: w * .02),
            CustomText(
              text: "Driver Registration ",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => EasyStepper(
              activeStep: driverFormController.activeStep.value,
              lineStyle: LineStyle(
                lineType: LineType.normal,
                unreachedLineType: LineType.normal,
                defaultLineColor: AppColors.lightGray,
                finishedLineColor: AppColors.primaryRed,
                lineLength: w * .18,
                lineThickness: 2,
              ),
              internalPadding: 0,
              stepRadius: w * 0.04,
              showStepBorder: false,
              steps: [
                buildStep(
                  0,
                  'Preference',
                  w,
                  driverFormController.activeStep.value,
                ),
                buildStep(
                  1,
                  'Vehicle Details',
                  w,
                  driverFormController.activeStep.value,
                ),
                buildStep(
                  2,
                  'Personal Details',
                  w,
                  driverFormController.activeStep.value,
                ),
                buildStep(
                  3,
                  'Profile Photo',
                  w,
                  driverFormController.activeStep.value,
                ),
              ],
              onStepReached: (index) {
                driverFormController.reachStep(index);
                _scrollToTop();
              },
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: 1,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * .03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => driverFormController.activeStep.value == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: w * .03,
                                    ),
                                    child: AppFonts.textPoppins(
                                      context,
                                      "Tell us your vehicle preference",
                                      w * 0.05,
                                      FontWeight.w600,
                                      AppColors.black,
                                      TextAlign.left,
                                      TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: w * .02),
                                  InkWell(
                                    onTap: () {
                                      driverFormController.activeStep.value = 1;
                                      _scrollToTop();
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: w * 0.94,
                                                height: h * 0.55,
                                                child: vehicleCard(
                                                  image:
                                                      "assets/images/image1.png",
                                                  title: "I have a vehicle",
                                                  desc:
                                                      "Register your vehicle to begin driving. A quick verification will get you on the road.",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: w * .1),
                                ],
                              )
                            : driverFormController.activeStep.value == 1
                                ? Form(
                                    key: _vehicleFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: w * .01,
                                          ),
                                          child: AppFonts.textPoppins(
                                            context,
                                            "Add your vehicle",
                                            w * 0.06,
                                            FontWeight.w500,
                                            AppColors.black,
                                            TextAlign.left,
                                            TextOverflow.visible,
                                          ),
                                        ),
                                        AppFonts.textPoppins(
                                          context,
                                          "Add your car, bike, or auto – drive your way.",
                                          w * 0.036,
                                          FontWeight.w500,
                                          AppColors.mediumGray,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "vehicle name",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * .01),
                                        AppFormFields.custTextFormOther(
                                          context: context,
                                          hintText: "e.g. Car",
                                          controller: vehicleNameController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Vehicle Name is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "vehicle number",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * .01),
                                        AppFormFields.custTextFormOther(
                                          context: context,
                                          hintText: "e.g. Car",
                                          controller: vehicleNumberController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Vehicle Number is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "Vehicle type",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * .01),
                                        // Dropdown for Vehicle Type with Pagination
                                        Obx(() {
                                          // Check if data is loading (initial load)
                                          if (vehicleTypesController
                                                  .isLoading
                                                  .value &&
                                              vehicleTypesController
                                                  .allVehicleTypes
                                                  .isEmpty) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: w * .04,
                                              ),
                                              height: w * .14,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.mediumGray,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8,
                                                ),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          AppColors.primaryRed,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: w * .03),
                                                    AppFonts.textPoppins(
                                                      context,
                                                      "Loading vehicle types...",
                                                      w * 0.035,
                                                      FontWeight.w400,
                                                      AppColors.mediumGray,
                                                      TextAlign.left,
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          // Check if there's an error or empty data
                                          if (vehicleTypesController
                                                  .allVehicleTypes
                                                  .isEmpty &&
                                              !vehicleTypesController
                                                  .isLoading
                                                  .value) {
                                            // Check if there's an error message
                                            if (!vehicleTypesController
                                                    .isLoading
                                                    .value &&
                                                vehicleTypesController
                                                    .errorMessage
                                                    .value
                                                    .isNotEmpty) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: w * .04,
                                                ),
                                                height: w * .14,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.red
                                                        .withOpacity(0.3),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color:
                                                      Colors.red.withOpacity(
                                                          0.1),
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      AppFonts.textPoppins(
                                                        context,
                                                        "Error loading vehicle types",
                                                        w * 0.032,
                                                        FontWeight.w400,
                                                        Colors.red,
                                                        TextAlign.center,
                                                        TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(height: w * .01),
                                                      GestureDetector(
                                                        onTap: () {
                                                          // Clear error and retry
                                                          vehicleTypesController
                                                              .clearError();
                                                          vehicleTypesController
                                                              .vehicalmethod();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                            horizontal:
                                                                w * .04,
                                                            vertical: w * .01,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .primaryRed,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                4),
                                                          ),
                                                          child: AppFonts
                                                              .textPoppins(
                                                            context,
                                                            "Retry",
                                                            w * 0.03,
                                                            FontWeight.w500,
                                                            Colors.white,
                                                            TextAlign.center,
                                                            TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }

                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: w * .04,
                                              ),
                                              height: w * .14,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.mediumGray,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8,
                                                ),
                                              ),
                                              child: Center(
                                                child: AppFonts.textPoppins(
                                                  context,
                                                  "No vehicle types available",
                                                  w * 0.035,
                                                  FontWeight.w400,
                                                  AppColors.mediumGray,
                                                  TextAlign.center,
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                            );
                                          }

                                          final vehicleList =
                                              vehicleTypesController
                                                  .allVehicleTypes;

                                          // Get selected vehicle name if available
                                          String selectedName =
                                              "Select vehicle type";
                                          if (vehicleTypeController
                                              .text
                                              .isNotEmpty) {
                                            final selected = vehicleList
                                                .firstWhere(
                                              (v) =>
                                                  v.id ==
                                                  vehicleTypeController.text,
                                              orElse: () =>
                                                  VehicleTypesModal.Datum(),
                                            );
                                            if (selected.name != null) {
                                              selectedName = selected.name!;
                                            }
                                          }

                                          return GestureDetector(
                                            onTap: () {
                                              _showVehicleTypeBottomSheet(
                                                context,
                                                w,
                                                vehicleList,
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: w * .04,
                                                vertical: w * .035,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: _showVehicleTypeError
                                                      ? AppColors.primaryRed
                                                      : AppColors.mediumGray,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: AppFonts.textPoppins(
                                                      context,
                                                      selectedName,
                                                      w * 0.035,
                                                      FontWeight.w400,
                                                      vehicleTypeController
                                                              .text
                                                              .isEmpty
                                                          ? AppColors.mediumGray
                                                          : AppColors.black,
                                                      TextAlign.left,
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_drop_down,
                                                    color: AppColors.primaryRed,
                                                    size: w * 0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),

                                        /////////////////////////////////////
                                        // VEHICLE SUB-TYPE DROPDOWN
                                        SizedBox(height: w * .04),

                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "Vehicle sub type",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * .01),
                                        // Combine Obx with regular widget logic
                                        Container(
                                          height: w * .14,
                                          child: Column(
                                            children: [
                                              // First check if vehicle type is selected (non-reactive check)
                                              if (vehicleTypeController
                                                  .text
                                                  .isEmpty)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: w * .04,
                                                  ),
                                                  height: w * .14,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          AppColors.mediumGray,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                    child: AppFonts.textPoppins(
                                                      context,
                                                      "Please select a vehicle type first",
                                                      w * 0.035,
                                                      FontWeight.w400,
                                                      AppColors.mediumGray,
                                                      TextAlign.center,
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                              else
                                                // Use Obx only for the reactive part
                                                Obx(() {
                                                  // Check if data is loading
                                                  if (vehicleSubtypesController
                                                      .isLoading
                                                      .value) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: w * .04,
                                                      ),
                                                      height: w * .14,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: AppColors
                                                              .mediumGray,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Row(
                                                          children: [
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                AppColors
                                                                    .primaryRed,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: w * .03,
                                                            ),
                                                            AppFonts.textPoppins(
                                                              context,
                                                              "Loading vehicle sub-types...",
                                                              w * 0.035,
                                                              FontWeight.w400,
                                                              AppColors
                                                                  .mediumGray,
                                                              TextAlign.left,
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  // Check if there's an error or empty data
                                                  if (vehicleSubtypesController
                                                              .cashResponse
                                                              .value ==
                                                          null ||
                                                      vehicleSubtypesController
                                                              .cashResponse
                                                              .value!
                                                              .data ==
                                                          null ||
                                                      vehicleSubtypesController
                                                          .cashResponse
                                                          .value!
                                                          .data!
                                                          .isEmpty) {
                                                    // Check if there's an error message
                                                    if (!vehicleSubtypesController
                                                            .isLoading
                                                            .value &&
                                                        vehicleSubtypesController
                                                            .errorMessage
                                                            .value
                                                            .isNotEmpty) {
                                                      return Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                          horizontal: w * .04,
                                                        ),
                                                        height: w * .14,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.red
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            8,
                                                          ),
                                                          color: Colors.red
                                                              .withOpacity(0.1),
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              AppFonts
                                                                  .textPoppins(
                                                                context,
                                                                "Error loading vehicle sub-types",
                                                                w * 0.032,
                                                                FontWeight.w400,
                                                                Colors.red,
                                                                TextAlign
                                                                    .center,
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      w * .01),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  // Clear error and retry
                                                                  vehicleSubtypesController
                                                                      .clearError();
                                                                  _loadVehicleSubTypes(
                                                                      vehicleTypeController
                                                                          .text);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal:
                                                                        w *
                                                                            .04,
                                                                    vertical:
                                                                        w *
                                                                            .01,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .primaryRed,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4),
                                                                  ),
                                                                  child: AppFonts
                                                                      .textPoppins(
                                                                    context,
                                                                    "Retry",
                                                                    w * 0.03,
                                                                    FontWeight
                                                                        .w500,
                                                                    Colors
                                                                        .white,
                                                                    TextAlign
                                                                        .center,
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: w * .04,
                                                      ),
                                                      height: w * .14,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: AppColors
                                                              .mediumGray,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: AppFonts
                                                            .textPoppins(
                                                          context,
                                                          "No vehicle sub-types available for this vehicle type",
                                                          w * 0.035,
                                                          FontWeight.w400,
                                                          AppColors.mediumGray,
                                                          TextAlign.center,
                                                          TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  final subTypeData =
                                                      vehicleSubtypesController
                                                          .cashResponse
                                                          .value;
                                                  final subTypeList =
                                                      subTypeData!.data!;

                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: w * .04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: _showVehicleSubTypeError
                                                            ? AppColors
                                                                .primaryRed
                                                            : AppColors
                                                                .mediumGray,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child:
                                                        DropdownButton<String>(
                                                      value:
                                                          vehicleSubTypeController
                                                              .text
                                                              .isEmpty
                                                              ? null
                                                              : vehicleSubTypeController
                                                                  .text,
                                                      hint:
                                                          AppFonts.textPoppins(
                                                        context,
                                                        "Select vehicle sub-type",
                                                        w * 0.035,
                                                        FontWeight.w400,
                                                        AppColors.mediumGray,
                                                        TextAlign.left,
                                                        TextOverflow.ellipsis,
                                                      ),
                                                      icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: AppColors
                                                            .primaryRed,
                                                        size: w * 0.07,
                                                      ),
                                                      underline: SizedBox(),
                                                      isExpanded: true,
                                                      style: TextStyle(
                                                        fontSize: w * 0.035,
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      items: subTypeList
                                                          .where(
                                                            (datum) =>
                                                                datum.id !=
                                                                    null &&
                                                                datum.name !=
                                                                    null,
                                                          ) // Filter out null IDs and names
                                                          .map<
                                                              DropdownMenuItem<
                                                                  String>>((
                                                            VehicleSubTypesModal
                                                                    .Datum
                                                                datum,
                                                          ) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: datum.id!,
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical:
                                                                      w * .03,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    AppFonts.textPoppins(
                                                                      context,
                                                                      datum.name ??
                                                                          "Unknown",
                                                                      w * 0.045,
                                                                      FontWeight
                                                                          .w400,
                                                                      AppColors
                                                                          .black,
                                                                      TextAlign
                                                                          .left,
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                    ),
                                                                    if (datum.minimumPrice !=
                                                                            null ||
                                                                        datum.baseFare !=
                                                                            null)
                                                                      SizedBox(
                                                                        height:
                                                                            w *
                                                                                .005,
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                          .toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        if (newValue != null) {
                                                          setState(() {
                                                            vehicleSubTypeController
                                                                    .text =
                                                                newValue;

                                                            // Find the selected vehicle sub-type
                                                            final selectedSubType =
                                                                subTypeList
                                                                    .firstWhere(
                                                              (subType) =>
                                                                  subType.id ==
                                                                  newValue,
                                                            );

                                                            // Show selection
                                                            print(
                                                              "Selected vehicle sub-type: ${selectedSubType.name} (ID: $newValue)",
                                                            );
                                                            if (selectedSubType
                                                                    .minimumPrice !=
                                                                null) {
                                                              print(
                                                                "Minimum Price: ${selectedSubType.minimumPrice}",
                                                              );
                                                            }
                                                            if (selectedSubType
                                                                    .baseFare !=
                                                                null) {
                                                              print(
                                                                "Base Fare: ${selectedSubType.baseFare}",
                                                              );
                                                            }

                                                            Get.snackbar(
                                                              "Selected",
                                                              "${selectedSubType.name}",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              duration:
                                                                  Duration(
                                                                seconds: 1,
                                                              ),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primaryRed
                                                                      .withOpacity(
                                                                        0.9,
                                                                      ),
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  );
                                                }),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "Model",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * .01),
                                        AppFormFields.custTextFormOther(
                                          context: context,
                                          hintText: "e.g. Swift Dzire",
                                          controller: modelController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Model is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: w * .04),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppFonts.textPoppins(
                                                  context,
                                                  "Year",
                                                  w * 0.04,
                                                  FontWeight.w500,
                                                  AppColors.black,
                                                  TextAlign.left,
                                                  TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: w * .01),
                                                AppFormFields.custTextFormOther(
                                                  context: context,
                                                  hintText: "e.g. 2014",
                                                  controller: yearController,
                                                  width: w * .45,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.trim().isEmpty) {
                                                      return 'Year is required';
                                                    }
                                                    if (value.length != 4 ||
                                                        int.tryParse(value) ==
                                                            null) {
                                                      return 'Invalid Year';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppFonts.textPoppins(
                                                  context,
                                                  "Color",
                                                  w * 0.04,
                                                  FontWeight.w500,
                                                  AppColors.black,
                                                  TextAlign.left,
                                                  TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: w * .01),
                                                AppFormFields.custTextFormOther(
                                                  context: context,
                                                  hintText: "e.g. Black",
                                                  controller: colorController,
                                                  width: w * .45,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.trim().isEmpty) {
                                                      return 'Color is required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "Licence Plate Number",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: w * .01),
                                        AppFormFields.custTextFormOther(
                                          context: context,
                                          hintText: "e.g. 6WED298",
                                          controller: plateNumberController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Plate Number is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: w * .04),

                                        AppFonts.textPoppins(
                                          context,
                                          "Photo of Registration Certificate",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        CustomDocumentUploader(
                                          width: w,
                                          height: w * .4,
                                          borderRadius: 5,
                                          uploadText: 'Upload',
                                          borderColor: _showRcImageError
                                              ? AppColors.primaryRed
                                              : AppColors.black,
                                          errorText: _showRcImageError
                                              ? "Registration Certificate image is required"
                                              : null,
                                          onImageSelected: (File? image) {
                                            setState(() {
                                              _registrationCertificateImage =
                                                  image;
                                              if (image != null)
                                                _showRcImageError = false;
                                            });
                                          },
                                          isImageUploaded:
                                              _registrationCertificateImage !=
                                                  null,
                                          onClearImage: () {
                                            setState(() {
                                              _registrationCertificateImage =
                                                  null;
                                            });
                                          },
                                        ),
                                        AppFonts.textPoppins(
                                          context,
                                          "Make sure your Registration Certificate photo are clear and visible.",
                                          w * 0.025,
                                          FontWeight.w500,
                                          AppColors.mediumGray,
                                          TextAlign.left,
                                          TextOverflow.visible,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "Photo of Licence Plate Number",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        CustomDocumentUploader(
                                          width: w,
                                          height: w * .4,
                                          borderRadius: 5,
                                          uploadText: 'Upload',
                                          borderColor: _showPlateImageError
                                              ? AppColors.primaryRed
                                              : AppColors.black,
                                          errorText: _showPlateImageError
                                              ? "Licence Plate image is required"
                                              : null,
                                          onImageSelected: (File? image) {
                                            setState(() {
                                              _licencePlateImage = image;
                                              if (image != null)
                                                _showPlateImageError = false;
                                            });
                                          },
                                          isImageUploaded:
                                              _licencePlateImage != null,
                                          onClearImage: () {
                                            setState(() {
                                              _licencePlateImage = null;
                                            });
                                          },
                                        ),

                                        AppFonts.textPoppins(
                                          context,
                                          "Make sure your vehicle's licence plate number photo are clear and visible.",
                                          w * 0.025,
                                          FontWeight.w500,
                                          AppColors.mediumGray,
                                          TextAlign.left,
                                          TextOverflow.visible,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: w * .04),
                                        AppFonts.textPoppins(
                                          context,
                                          "Photo of Vehicle Insurance",
                                          w * 0.04,
                                          FontWeight.w500,
                                          AppColors.black,
                                          TextAlign.left,
                                          TextOverflow.ellipsis,
                                        ),
                                        CustomDocumentUploader(
                                          width: w,
                                          height: w * .4,
                                          borderRadius: 5,
                                          uploadText: 'Upload',
                                          borderColor: _showInsuranceImageError
                                              ? AppColors.primaryRed
                                              : AppColors.black,
                                          errorText: _showInsuranceImageError
                                              ? "Vehicle Insurance image is required"
                                              : null,
                                          onImageSelected: (File? image) {
                                            setState(() {
                                              _vehicleInsuranceImage = image;
                                              if (image != null)
                                                _showInsuranceImageError =
                                                    false;
                                            });
                                          },
                                          isImageUploaded:
                                              _vehicleInsuranceImage != null,
                                          onClearImage: () {
                                            setState(() {
                                              _vehicleInsuranceImage = null;
                                            });
                                          },
                                        ),
                                        AppFonts.textPoppins(
                                          context,
                                          "Make sure your vehicle's insurance photo are clear and visible.",
                                          w * 0.025,
                                          FontWeight.w500,
                                          AppColors.mediumGray,
                                          TextAlign.left,
                                          TextOverflow.visible,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: w * .04),
                                        AppButtons.solid(
                                          context: context,
                                          text: "Continue",
                                          onClicked: _submitVehicleDetails,
                                          isLoading: _isLoading,
                                          isFullWidth: true,
                                          backgroundColor: AppColors.primaryRed,
                                          textColor: AppColors.white,
                                          fontSize: w * .045,
                                          height: w * .140,
                                          radius: 12.0,
                                        ),
                                        SizedBox(height: w * .1),
                                      ],
                                    ), // Closing Column for Step 1
                                  ) // Closing Form for Step 1
                                : driverFormController.activeStep.value == 2
                                    ? Form(
                                        key: _personalFormKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: w * .01,
                                              ),
                                              child: AppFonts.textPoppins(
                                                context,
                                                "Add your Personal Details",
                                                w * 0.06,
                                                FontWeight.w500,
                                                AppColors.black,
                                                TextAlign.left,
                                                TextOverflow.visible,
                                              ),
                                            ),
                                            AppFonts.textPoppins(
                                              context,
                                              "Fill in your details to become a verified driver.",
                                              w * 0.036,
                                              FontWeight.w500,
                                              AppColors.mediumGray,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Name",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. Mahavir",
                                              controller: nameController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Name is required';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Phone Number",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. 9865431062",
                                              controller: phoneNumberController,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 10,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Phone Number is required';
                                                }
                                                if (value.length != 10) {
                                                  return 'Phone Number must be 10 digits';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Date of Birth",
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
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Date of Birth is required';
                                                }
                                                return null;
                                              },
                                              onClicked: () async {
                                                DateTime initialDate =
                                                    DateTime.now().subtract(
                                                  const Duration(days: 365 * 20),
                                                );
                                                DateTime firstDate =
                                                    DateTime(1900);
                                                DateTime lastDate =
                                                    DateTime.now();

                                                final DateTime? picked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: initialDate,
                                                  firstDate: firstDate,
                                                  lastDate: lastDate,
                                                );

                                                if (picked != null) {
                                                  setState(() {
                                                    dobController.text =
                                                        DateFormat(
                                                      "dd/MM/yyyy",
                                                    ).format(picked);
                                                  });
                                                }
                                              },
                                              suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: AppColors.primaryRed,
                                                size: w * 0.055,
                                              ),
                                            ),
                                            SizedBox(height: w * .04),
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
                                              hintText: "e.g. Mahavir@gmail.com",
                                              controller: emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Email is required';
                                                }
                                                if (!value.contains('@')) {
                                                  return 'Invalid Email';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Alternate Contact (1)",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. 9865431062",
                                              controller:
                                                  alternateContact1Controller,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 10,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Alternate Contact is required';
                                                }
                                                if (value.length != 10) {
                                                  return 'Phone Number must be 10 digits';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Relation",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. Mother",
                                              controller: relation1Controller,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Relation is required';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Address",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. Bhopal",
                                              controller: address1Controller,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Address is required';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Alternate Contact (2)",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. 9865431062",
                                              controller:
                                                  alternateContact2Controller,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 10,
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Relation",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. Mother",
                                              controller: relation2Controller,
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Address",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: w * .01),
                                            AppFormFields.custTextFormOther(
                                              context: context,
                                              hintText: "e.g. Bhopal",
                                              controller: address2Controller,
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Upload Photo of Aadhar Card (Front)",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            CustomDocumentUploader(
                                              width: w,
                                              height: w * .4,
                                              borderRadius: 5,
                                              uploadText: 'Upload',
                                              borderColor: _showAadharFrontError
                                                  ? AppColors.primaryRed
                                                  : AppColors.black,
                                              errorText: _showAadharFrontError
                                                  ? "Aadhar Front image is required"
                                                  : null,
                                              onImageSelected: (File? image) {
                                                setState(() {
                                                  _aadharFrontImage = image;
                                                  if (image != null)
                                                    _showAadharFrontError =
                                                        false;
                                                });
                                              },
                                              isImageUploaded:
                                                  _aadharFrontImage != null,
                                              onClearImage: () {
                                                setState(() {
                                                  _aadharFrontImage = null;
                                                });
                                              },
                                            ),
                                            AppFonts.textPoppins(
                                              context,
                                              "Make sure your Front Aadhar card photo are clear and visible.",
                                              w * 0.025,
                                              FontWeight.w500,
                                              AppColors.mediumGray,
                                              TextAlign.left,
                                              TextOverflow.visible,
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Upload Photo of Aadhar Card (Back)",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            CustomDocumentUploader(
                                              width: w,
                                              height: w * .4,
                                              borderRadius: 5,
                                              uploadText: 'Upload',
                                              borderColor: _showAadharBackError
                                                  ? AppColors.primaryRed
                                                  : AppColors.black,
                                              errorText: _showAadharBackError
                                                  ? "Aadhar Back image is required"
                                                  : null,
                                              onImageSelected: (File? image) {
                                                setState(() {
                                                  _aadharBackImage = image;
                                                  if (image != null)
                                                    _showAadharBackError =
                                                        false;
                                                });
                                              },
                                              isImageUploaded:
                                                  _aadharBackImage != null,
                                              onClearImage: () {
                                                setState(() {
                                                  _aadharBackImage = null;
                                                });
                                              },
                                            ),
                                            AppFonts.textPoppins(
                                              context,
                                              "Make sure your Aadhar card back photo are clear and visible.",
                                              w * 0.025,
                                              FontWeight.w500,
                                              AppColors.mediumGray,
                                              TextAlign.left,
                                              TextOverflow.visible,
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Upload Photo of PAN Card",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            CustomDocumentUploader(
                                              width: w,
                                              height: w * .4,
                                              borderRadius: 5,
                                              uploadText: 'Upload',
                                              borderColor: _showPanError
                                                  ? AppColors.primaryRed
                                                  : AppColors.black,
                                              errorText: _showPanError
                                                  ? "PAN Card image is required"
                                                  : null,
                                              onImageSelected: (File? image) {
                                                setState(() {
                                                  _panCardImage = image;
                                                  if (image != null)
                                                    _showPanError = false;
                                                });
                                              },
                                              isImageUploaded:
                                                  _panCardImage != null,
                                              onClearImage: () {
                                                setState(() {
                                                  _panCardImage = null;
                                                });
                                              },
                                            ),
                                            AppFonts.textPoppins(
                                              context,
                                              "Make sure your PAN card photo are clear and visible.",
                                              w * 0.025,
                                              FontWeight.w500,
                                              AppColors.mediumGray,
                                              TextAlign.left,
                                              TextOverflow.visible,
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: w * .04),
                                            AppFonts.textPoppins(
                                              context,
                                              "Upload Photo of Driver License",
                                              w * 0.04,
                                              FontWeight.w500,
                                              AppColors.black,
                                              TextAlign.left,
                                              TextOverflow.ellipsis,
                                            ),
                                            CustomDocumentUploader(
                                              width: w,
                                              height: w * .4,
                                              borderRadius: 5,
                                              uploadText: 'Upload',
                                              borderColor: _showDlError
                                                  ? AppColors.primaryRed
                                                  : AppColors.black,
                                              errorText: _showDlError
                                                  ? "Driver License image is required"
                                                  : null,
                                              onImageSelected: (File? image) {
                                                setState(() {
                                                  _driverLicenseImage = image;
                                                  if (image != null)
                                                    _showDlError = false;
                                                });
                                              },
                                              isImageUploaded:
                                                  _driverLicenseImage != null,
                                              onClearImage: () {
                                                setState(() {
                                                  _driverLicenseImage = null;
                                                });
                                              },
                                            ),
                                            AppFonts.textPoppins(
                                              context,
                                              "Make sure your driver license photo are clear and visible.",
                                              w * 0.025,
                                              FontWeight.w500,
                                              AppColors.mediumGray,
                                              TextAlign.left,
                                              TextOverflow.visible,
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: w * .1),
                                            AppButtons.solid(
                                              context: context,
                                              text: "Continue",
                                              onClicked: _submitPersonalDetails,
                                              isLoading: _isSubmitting,
                                              isFullWidth: true,
                                              backgroundColor:
                                                  AppColors.primaryRed,
                                              textColor: AppColors.white,
                                              fontSize: w * .045,
                                              height: w * .140,
                                              radius: 12.0,
                                            ),
                                            SizedBox(height: w * .1),
                                          ],
                                        ), // Closing Column for Step 2
                                      ) // Closing Form for Step 2
                                    : driverFormController.activeStep.value == 3
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: w * .01,
                                                ),
                                                child: AppFonts.textPoppins(
                                                  context,
                                                  "Add Profile Photo",
                                                  w * 0.06,
                                                  FontWeight.w500,
                                                  AppColors.black,
                                                  TextAlign.left,
                                                  TextOverflow.visible,
                                                ),
                                              ),
                                              SizedBox(
                                                width: w * .8,
                                                child: AppFonts.textPoppins(
                                                  context,
                                                  "Upload a recent photo of yourself (no sunglasses, no mask).",
                                                  w * 0.036,
                                                  FontWeight.w500,
                                                  AppColors.mediumGray,
                                                  TextAlign.left,
                                                  TextOverflow.visible,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              SizedBox(height: w * .02),
                                              Center(
                                                child: Column(
                                                  children: [
                                                    CustomDocumentUploader(
                                                      width: w * .4,
                                                      height: w * .4,
                                                      isCircular: true,
                                                      uploadText: 'Upload',
                                                      borderColor:
                                                          _showProfilePhotoError
                                                              ? AppColors
                                                                  .primaryRed
                                                              : AppColors
                                                                  .black,
                                                      errorText:
                                                          _showProfilePhotoError
                                                              ? "Profile Photo is required"
                                                              : null,
                                                      onImageSelected:
                                                          (File? image) {
                                                        setState(() {
                                                          _profilePhotoImage =
                                                              image;
                                                          if (image != null)
                                                            _showProfilePhotoError =
                                                                false;
                                                        });
                                                      },
                                                      isImageUploaded:
                                                          _profilePhotoImage !=
                                                              null,
                                                      onClearImage: () {
                                                        setState(() {
                                                          _profilePhotoImage =
                                                              null;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: w * .7,
                                                      child: AppFonts.textPoppins(
                                                        context,
                                                        "Your profile photo must clearly show your face.",
                                                        w * 0.036,
                                                        FontWeight.w500,
                                                        AppColors.mediumGray,
                                                        TextAlign.center,
                                                        TextOverflow.visible,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: w * .4),
                                              AppButtons.solid(
                                                context: context,
                                                text: "Submit",
                                                onClicked: _submitProfilePhoto,
                                                isLoading: _isSubmitting,
                                                isFullWidth: true,
                                                backgroundColor:
                                                    AppColors.primaryRed,
                                                textColor: AppColors.white,
                                                fontSize: w * .045,
                                                height: w * .140,
                                                radius: 12.0,
                                              ),
                                              SizedBox(height: w * .1),
                                            ],
                                          )
                                        : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  EasyStep buildStep(int stepIndex, String title, double w, int activeStep) {
    bool isActive = activeStep >= stepIndex;

    return EasyStep(
      customStep: isActive
          ? CircleAvatar(
              radius: w * 0.04,
              backgroundColor: AppColors.primaryRed,
              child:
                  Icon(Icons.check, size: w * 0.045, color: AppColors.white),
            )
          : CircleAvatar(
              radius: w * 0.04,
              backgroundColor: AppColors.lightGray,
              child: CircleAvatar(
                radius: w * 0.025,
                backgroundColor: AppColors.white,
              ),
            ),
      customTitle: AppFonts.textPoppins(
        context,
        title,
        w * 0.025,
        FontWeight.w400,
        AppColors.black,
        TextAlign.center,
        TextOverflow.ellipsis,
      ),
    );
  }
}