
// import 'package:corezap_driver/controller/stepper_controller.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_document_uploader.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/form_field.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/utilities/widgets/vehicleCard.dart';
// import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:corezap_driver/views/bottomNavigation/home_screen.dart';
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
//   DriverFormController driverFormController = Get.find<DriverFormController>();
//   // add your vehicle textfields cotrollers
//   TextEditingController vehicleTypeController = TextEditingController();
//   TextEditingController modelController = TextEditingController();
//   TextEditingController yearController = TextEditingController();
//   TextEditingController colorControlller = TextEditingController();
//   TextEditingController plateNumberController = TextEditingController();
//   // add your prrsonal details textfields cotrollers
//   TextEditingController dobController = TextEditingController();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController dateOfBirthController = TextEditingController();
//   TextEditingController emailControlller = TextEditingController();
//   TextEditingController alternateContactNumber1Controller =
//       TextEditingController();
//   TextEditingController relationController = TextEditingController();
//   TextEditingController address1Controller = TextEditingController();
//   TextEditingController alternateContactNumber2Controller =
//       TextEditingController();
//   TextEditingController relation2Controller = TextEditingController();
//   TextEditingController address2Controller = TextEditingController();

//   String imagePath = "";
//   int activeStep = 0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // driverFormController.resetSteps();
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
//                 //  driverFormController.resetSteps();
//                 if (driverFormController.activeStep.value > 0 &&
//                     driverFormController.activeStep.value <= 3) {
//                   driverFormController.activeStep.value--;
//                 } else if (driverFormController.activeStep.value == 0) {
//                   CustomNavigator.pop(context);
//                 } else {
//                   print(".. condition");
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
//                 //                  Preference
//                 // Vehicle Details
//                 // Personal Details
//                 // Profile Photo
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
//               onStepReached: (index) => driverFormController.reachStep(index),
//             ),
//           ),

//           Expanded(
//             child: ListView.builder(
//               itemCount: 1,
//               itemBuilder: (context, index) => Padding(
//                 padding: EdgeInsets.symmetric(horizontal: w * .03),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   // preference activestep 0
//                   children: [
//                     Obx(
//                       () => driverFormController.activeStep.value == 0
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: w * .03,
//                                   ),
//                                   child: AppFonts.textPoppins(
//                                     context,
//                                     "Tell us your vehicle preference",
//                                     w * 0.05,
//                                     FontWeight.w600,
//                                     AppColors.black,
//                                     TextAlign.left,
//                                     TextOverflow.ellipsis,
//                                   ),
//                                 ),
            
//                                 SizedBox(height: w * .02),
//                                 InkWell(
//                                   onTap: () {
//                                     driverFormController.activeStep.value = 1;
                 
//                                   },
//                                   child: Container(
                               
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             SizedBox(
//                                               width: w * 0.94,
//                                               height: h * 0.55,
//                                               child: vehicleCard(
//                                                 image:
//                                                     "assets/images/image1.png",
//                                                 title: "I have a vehicle",
//                                                 desc:
//                                                     "Register your vehicle to begin driving. A quick verification will get you on the road.",
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),

                                 
//                                   ),
//                                 ),


//                                 SizedBox(height: w * .1),
//                               ],
//                             )
//                           //?------------
//                           : driverFormController.activeStep.value == 1
//                           ? 
//                           Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: w * .01,
//                                   ),
//                                   child: AppFonts.textPoppins(
//                                     context,
//                                     "Add your vehicle",
//                                     w * 0.06,
//                                     FontWeight.w500,
//                                     AppColors.black,
//                                     TextAlign.left,
//                                     TextOverflow.visible,
//                                   ),
//                                 ),

//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Add your car, bike, or auto – drive your way.",
//                                   w * 0.036,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),

//                                   SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "vehicle name",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Car",
//                                   controller: vehicleTypeController,
//                                 ),

//                                   SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "vehicle number",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Car",
//                                   controller: vehicleTypeController,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Vehicle type",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Car",
//                                   controller: vehicleTypeController,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Model",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Swift Dzire ",
//                                   controller: modelController,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         AppFonts.textPoppins(
//                                           context,
//                                           "Year",
//                                           w * 0.04,
//                                           FontWeight.w500,
//                                           AppColors.black,
//                                           TextAlign.left,
//                                           TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(height: w * .01),
//                                         AppFormFields.custTextFormOther(
//                                           context: context,
//                                           hintText: "e.g. 2014",
//                                           controller: yearController,
//                                           width: w * .45,
//                                           keyboardType: TextInputType.text,
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         AppFonts.textPoppins(
//                                           context,
//                                           "Color",
//                                           w * 0.04,
//                                           FontWeight.w500,
//                                           AppColors.black,
//                                           TextAlign.left,
//                                           TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(height: w * .01),
//                                         AppFormFields.custTextFormOther(
//                                           context: context,
//                                           hintText: "e.g. Black",
//                                           controller: colorControlller,
//                                           width: w * .45,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Licence Plate Number",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. 6WED298",
//                                   controller: plateNumberController,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Photo of Registration Certificate",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 CustomDocumentUploader(
//                                   width: w,
//                                   height: w * .4,
//                                   borderRadius: 5,
//                                   // onUploadPressed: () {
//                                   //   // Handle file upload logic here, e.g., show file picker.
//                                   // },
//                                   uploadText: 'Upload',
//                                   borderColor: AppColors.black,
//                                 ),

//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Make sure your Registration Certificate photo are clear and visible.",
//                                   w * 0.025,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.visible,
//                                   maxLines: 2,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Photo of Licence Plate Number",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 CustomDocumentUploader(
//                                   width: w,
//                                   height: w * .4,
//                                   borderRadius: 5,
//                                   // onUploadPressed: () {
//                                   //   // Handle file upload logic here, e.g., show file picker.
//                                   // },
//                                   uploadText: 'Upload',
//                                   borderColor: AppColors.black,
//                                 ),

//                                 //    Make sure your vehicle’s licence plate number photo are clear and visible.
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Make sure your vehicle’s licence plate number photo are clear and visible.",
//                                   w * 0.025,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.visible,
//                                   maxLines: 2,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Photo of Vehicle Insurance",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 // upload document
//                                 CustomDocumentUploader(
//                                   width: w,
//                                   height: w * .4,
//                                   borderRadius: 5,
//                                   // onUploadPressed: () {
//                                   //   // Handle file upload logic here, e.g., show file picker.
//                                   // },
//                                   uploadText: 'Upload',
//                                   borderColor: AppColors.black,
//                                 ),
//                                 //    Make sure your vehicle’s licence plate number photo are clear and visible.
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Make sure your vehicle’s insurance photo are clear and visible.",
//                                   w * 0.025,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.visible,
//                                   maxLines: 2,
//                                 ),
//                                 SizedBox(height: w * .1),
//                                 AppButtons.solid(
//                                   context: context,
//                                   text: "Continue",
//                                   onClicked: () {
//                                     driverFormController.activeStep.value = 2;
//                                     // CustomNavigator.push(
//                                     //   context,
//                                     //   LiveRide(),
//                                     //   transition: TransitionType.fade,
//                                     // );
//                                   },
//                                   isFullWidth: true,
//                                   backgroundColor: AppColors.primaryRed,
//                                   textColor: AppColors.white,
//                                   fontSize: w * .045,
//                                   height: w * .140,
//                                   radius: 12.0,
//                                 ),
//                                 SizedBox(height: w * .1),
//                               ],
//                             )
                          
                          
                          
//                           : driverFormController.activeStep.value == 2
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: w * .01,
//                                   ),
//                                   child: AppFonts.textPoppins(
//                                     context,
//                                     "Add your Personal Details",
//                                     w * 0.06,
//                                     FontWeight.w500,
//                                     AppColors.black,
//                                     TextAlign.left,
//                                     TextOverflow.visible,
//                                   ),
//                                 ),

//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Fill in your details to become a verified driver.",
//                                   w * 0.036,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Name",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Mahavir",
//                                   controller: nameController,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Phone Number",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. 9865431062",
//                                   controller: phoneNumberController,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 10,
//                                 ),
//                                 SizedBox(height: w * .04),
                       
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Date of Birth",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 // AppFormFields.custTextFormOther(
//                                 //   context: context,
//                                 //   hintText: "e.g. 15/01/2002",
//                                 //   controller: dateOfBirthController,
//                                 // ),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "DD/MM/YYYY",
//                                   controller: dobController,
//                                   readOnly: true,
//                                   onClicked: () async {
//                                     DateTime initialDate = DateTime.now()
//                                         .subtract(
//                                           const Duration(days: 365 * 20),
//                                         );
//                                     DateTime firstDate = DateTime(1900);
//                                     DateTime lastDate = DateTime.now();

//                                     final DateTime? picked =
//                                         await showDatePicker(
//                                           context: context,
//                                           initialDate: initialDate,
//                                           firstDate: firstDate,
//                                           lastDate: lastDate,
//                                         );

//                                     if (picked != null) {
//                                       setState(() {
//                                         dobController.text = DateFormat(
//                                           "dd/MM/yyyy",
//                                         ).format(picked);
//                                       });
//                                     }
//                                   },
//                                   suffixIcon: Icon(
//                                     Icons.calendar_month,
//                                     color: AppColors.primaryRed,
//                                     size: w * 0.055,
//                                   ),
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Email",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Mahavir@gmail.com",
//                                   controller: emailControlller,
//                                   keyboardType: TextInputType.emailAddress,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Alternate Contact (1)",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. 9865431062",
//                                   controller: alternateContactNumber1Controller,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 10,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Relation",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Mother",
//                                   controller: relationController,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Address",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Bhopal",
//                                   controller: address1Controller,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Alternate Contact (2)",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. 9865431062",
//                                   controller: alternateContactNumber2Controller,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 10,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Relation",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Mother",
//                                   controller: relation2Controller,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Address",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(height: w * .01),
//                                 AppFormFields.custTextFormOther(
//                                   context: context,
//                                   hintText: "e.g. Bhopal",
//                                   controller: address2Controller,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Upload Photo of Aadhar Card (Front)",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 // upload documnet
//                                 CustomDocumentUploader(
//                                   width: w,
//                                   height: w * .4,
//                                   borderRadius: 5,
//                                   // onUploadPressed: () {
//                                   //   // Handle file upload logic here, e.g., show file picker.
//                                   // },
//                                   uploadText: 'Upload',
//                                   borderColor: AppColors.black,
//                                 ),
//                                 //    Make sure your vehicle’s licence plate number photo are clear and visible.
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Make sure your Front Aadhar card photo are clear and visible.",
//                                   w * 0.025,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.visible,
//                                   maxLines: 2,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Upload Photo of Aadhar Card",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 CustomDocumentUploader(
//                                   width: w,
//                                   height: w * .4,
//                                   borderRadius: 5,
//                                   // onUploadPressed: () {
//                                   //   // Handle file upload logic here, e.g., show file picker.
//                                   // },
//                                   uploadText: 'Upload',
//                                   borderColor: AppColors.black,
//                                 ),
//                                 //    Make sure your vehicle’s licence plate number photo are clear and visible.
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Make sure your Aadhar card back photo are clear and visible.",
//                                   w * 0.025,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.visible,
//                                   maxLines: 2,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Upload Photo of PAN Card",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 CustomDocumentUploader(
//                                   width: w,
//                                   height: w * .4,
//                                   borderRadius: 5,
//                                   // onUploadPressed: () {
//                                   //   // Handle file upload logic here, e.g., show file picker.
//                                   // },
//                                   uploadText: 'Upload',
//                                   borderColor: AppColors.black,
//                                 ),
//                                 //    Make sure your vehicle’s licence plate number photo are clear and visible.
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Make sure your PAN card photo are clear and visible.",
//                                   w * 0.025,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.visible,
//                                   maxLines: 2,
//                                 ),
//                                 SizedBox(height: w * .04),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Upload Photo of Driver License",
//                                   w * 0.04,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.left,
//                                   TextOverflow.ellipsis,
//                                 ),
//                                 CustomDocumentUploader(
//                                   width: w,
//                                   height: w * .4,
//                                   borderRadius: 5,
//                                   // onUploadPressed: () {
//                                   //   // Handle file upload logic here, e.g., show file picker.
//                                   // },
//                                   uploadText: 'Upload',
//                                   borderColor: AppColors.black,
//                                 ),
//                                 //    Make sure your vehicle’s licence plate number photo are clear and visible.
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Make sure your driver license photo are clear and visible.",
//                                   w * 0.025,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.left,
//                                   TextOverflow.visible,
//                                   maxLines: 2,
//                                 ),
//                                 SizedBox(height: w * .1),
//                                 AppButtons.solid(
//                                   context: context,
//                                   text: "Continue",
//                                   onClicked: () {
//                                     driverFormController.activeStep.value = 3;
//                                     // CustomNavigator.push(
//                                     //   context,
//                                     //   LiveRide(),
//                                     //   transition: TransitionType.fade,
//                                     // );
//                                   },
//                                   isFullWidth: true,
//                                   backgroundColor: AppColors.primaryRed,
//                                   textColor: AppColors.white,
//                                   fontSize: w * .045,
//                                   height: w * .140,
//                                   radius: 12.0,
//                                 ),
//                                 SizedBox(height: w * .1),
//                               ],
//                             )
//                           : driverFormController.activeStep.value == 3
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: w * .01,
//                                   ),
//                                   child: AppFonts.textPoppins(
//                                     context,
//                                     "Add Profile Photo",
//                                     w * 0.06,
//                                     FontWeight.w500,
//                                     AppColors.black,
//                                     TextAlign.left,
//                                     TextOverflow.visible,
//                                   ),
//                                 ),

//                                 SizedBox(
//                                   width: w * .8,
//                                   child: AppFonts.textPoppins(
//                                     context,
//                                     "Upload a recent photo of yourself (no sunglasses, no mask).",
//                                     w * 0.036,
//                                     FontWeight.w500,
//                                     AppColors.mediumGray,
//                                     TextAlign.left,
//                                     TextOverflow.visible,
//                                     maxLines: 2,
//                                   ),
//                                 ),
//                                 SizedBox(height: w * .02),
//                                 Center(
//                                   child: Column(
//                                     children: [
//                                       CustomDocumentUploader(
//                                         width: w * .4,
//                                         height: w * .4,
//                                         isCircular: true,
//                                         // onUploadPressed: () {
//                                         //   // Handle file upload logic here, e.g., show file picker.
//                                         // },
//                                         uploadText: 'Upload',
//                                         borderColor: AppColors.black,
//                                       ),
//                                       SizedBox(
//                                         width: w * .7,
//                                         child: AppFonts.textPoppins(
//                                           context,
//                                           "Your profile photo must clearly show your face.",
//                                           w * 0.036,
//                                           FontWeight.w500,
//                                           AppColors.mediumGray,
//                                           TextAlign.center,
//                                           TextOverflow.visible,
//                                           maxLines: 2,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 SizedBox(height: w * .4),
//                                 AppButtons.solid(
//                                   context: context,
//                                   text: "Submit",
//                                   onClicked: () {
//                                     driverFormController.resetSteps();
//                                     CustomNavigator.push(
//                                       context,
//                                       BottomnavmainScreen(),
//                                       transition: TransitionType.fade,
//                                     );
//                                   },
//                                   isFullWidth: true,
//                                   backgroundColor: AppColors.primaryRed,
//                                   textColor: AppColors.white,
//                                   fontSize: w * .045,
//                                   height: w * .140,
//                                   radius: 12.0,
//                                 ),
//                                 SizedBox(height: w * .1),
//                               ],
//                             )
//                           : SizedBox(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   //?----------------method
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
//       // title:  title,
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


import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_document_uploader.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/form_field.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/utilities/widgets/vehicleCard.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {
  DriverFormController driverFormController = Get.find<DriverFormController>();
  
  // Vehicle detail controllers
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  TextEditingController vehicleCapacityController = TextEditingController();
  
  // Personal detail controllers
  TextEditingController dobController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alternateContactNumber1Controller = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController alternateContactNumber2Controller = TextEditingController();
  TextEditingController relation2Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();

  // API response state
  bool _isLoading = false;
  String _apiResponseMessage = '';
  bool _apiSuccess = false;

  @override
  void initState() {
    super.initState();
    // Set default values
    vehicleCapacityController.text = "4";
  }

  // Method to create vehicle via API
  Future<void> _createVehicle() async {
    setState(() {
      _isLoading = true;
      _apiResponseMessage = '';
      _apiSuccess = false;
    });

    try {
      // API endpoint
      const String apiUrl = "https://api.corezap.framekarts.com/api/v1/createVehicle";
      
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "vehicleName": vehicleNameController.text,
        "vehicleNumber": vehicleNumberController.text,
        "vehicleColor": vehicleColorController.text,
        "vehicleType": "691581132fbb2cbdd65fbd8d", // Fixed ID from your params
        "vehicleStatus": "Active",
        "vehicleModel": vehicleModelController.text,
        "vehicleCapacity": vehicleCapacityController.text,
        "vehicleYear": vehicleYearController.text,
        "driverId": "695907abb30f1d4e3c7ce75c", // Fixed driver ID from your params
      };

      print("Sending request to: $apiUrl");
      print("Request body: $requestBody");

      // Make POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Parse response
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      setState(() {
        _apiSuccess = responseData['success'] ?? false;
        _apiResponseMessage = responseData['message'] ?? 'No message received';
        
        if (_apiSuccess) {
          // If successful, move to next step
          driverFormController.activeStep.value = 2;
        }
      });

    } catch (error) {
      print("Error: $error");
      setState(() {
        _apiSuccess = false;
        _apiResponseMessage = "Network error: $error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                } else if (driverFormController.activeStep.value == 0) {
                  CustomNavigator.pop(context);
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
              text: "Driver Registration",
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
                buildStep(0, 'Preference', w, driverFormController.activeStep.value),
                buildStep(1, 'Vehicle Details', w, driverFormController.activeStep.value),
                buildStep(2, 'Personal Details', w, driverFormController.activeStep.value),
                buildStep(3, 'Profile Photo', w, driverFormController.activeStep.value),
              ],
              onStepReached: (index) => driverFormController.reachStep(index),
            ),
          ),

          Expanded(
            child: ListView.builder(
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
                                  padding: EdgeInsets.symmetric(vertical: w * .03),
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
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: w * 0.94,
                                              height: h * 0.55,
                                              child: vehicleCard(
                                                image: "assets/images/image1.png",
                                                title: "I have a vehicle",
                                                desc: "Register your vehicle to begin driving. A quick verification will get you on the road.",
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
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: w * .01),
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
                                
                                // Vehicle Name
                                AppFonts.textPoppins(
                                  context,
                                  "Vehicle Name",
                                  w * 0.04,
                                  FontWeight.w500,
                                  AppColors.black,
                                  TextAlign.left,
                                  TextOverflow.ellipsis,
                                ),
                                SizedBox(height: w * .01),
                                AppFormFields.custTextFormOther(
                                  context: context,
                                  hintText: "e.g. Honda Civic",
                                  controller: vehicleNameController,
                                ),
                                
                                SizedBox(height: w * .04),
                                
                                // Vehicle Number
                                AppFonts.textPoppins(
                                  context,
                                  "Vehicle Number",
                                  w * 0.04,
                                  FontWeight.w500,
                                  AppColors.black,
                                  TextAlign.left,
                                  TextOverflow.ellipsis,
                                ),
                                SizedBox(height: w * .01),
                                AppFormFields.custTextFormOther(
                                  context: context,
                                  hintText: "e.g. MH12AB1234",
                                  controller: vehicleNumberController,
                                ),
                                
                                SizedBox(height: w * .04),
                                
                                // Vehicle Color
                                AppFonts.textPoppins(
                                  context,
                                  "Vehicle Color",
                                  w * 0.04,
                                  FontWeight.w500,
                                  AppColors.black,
                                  TextAlign.left,
                                  TextOverflow.ellipsis,
                                ),
                                SizedBox(height: w * .01),
                                AppFormFields.custTextFormOther(
                                  context: context,
                                  hintText: "e.g. Blue",
                                  controller: vehicleColorController,
                                ),
                                
                                SizedBox(height: w * .04),
                                
                                // Vehicle Type (Fixed value from params)
                                AppFonts.textPoppins(
                                  context,
                                  "Vehicle Type ID",
                                  w * 0.04,
                                  FontWeight.w500,
                                  AppColors.black,
                                  TextAlign.left,
                                  TextOverflow.ellipsis,
                                ),
                                SizedBox(height: w * .01),
                                AppFormFields.custTextFormOther(
                                  context: context,
                                  hintText: "e.g. 691581132fbb2cbdd65fbd8d",
                                  controller: vehicleTypeController..text = "691581132fbb2cbdd65fbd8d",
                                  readOnly: true,
                                ),
                                
                                SizedBox(height: w * .04),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Vehicle Model
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                          hintText: "e.g. VXI",
                                          controller: vehicleModelController,
                                          width: w * .45,
                                        ),
                                      ],
                                    ),
                                    // Vehicle Year
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          hintText: "e.g. 2019",
                                          controller: vehicleYearController,
                                          width: w * .45,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: w * .04),
                                
                                // Vehicle Capacity
                                AppFonts.textPoppins(
                                  context,
                                  "Vehicle Capacity",
                                  w * 0.04,
                                  FontWeight.w500,
                                  AppColors.black,
                                  TextAlign.left,
                                  TextOverflow.ellipsis,
                                ),
                                SizedBox(height: w * .01),
                                AppFormFields.custTextFormOther(
                                  context: context,
                                  hintText: "e.g. 4",
                                  controller: vehicleCapacityController..text = "4",
                                  keyboardType: TextInputType.number,
                                ),
                                
                                // API Response Message
                                if (_apiResponseMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: w * .02),
                                    child: Text(
                                      _apiResponseMessage,
                                      style: TextStyle(
                                        color: _apiSuccess ? Colors.green : Colors.red,
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                
                                SizedBox(height: w * .04),
                                
                                // Continue Button
                                _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryRed,
                                        ),
                                      )
                                    : AppButtons.solid(
                                        context: context,
                                        text: "Continue",
                                        onClicked: () async {
                                          // Validate required fields
                                          if (vehicleNameController.text.isEmpty ||
                                              vehicleNumberController.text.isEmpty ||
                                              vehicleColorController.text.isEmpty ||
                                              vehicleModelController.text.isEmpty ||
                                              vehicleYearController.text.isEmpty) {
                                            setState(() {
                                              _apiSuccess = false;
                                              _apiResponseMessage = "Please fill all required fields";
                                            });
                                            return;
                                          }
                                          
                                          await _createVehicle();
                                        },
                                        isFullWidth: true,
                                        backgroundColor: AppColors.primaryRed,
                                        textColor: AppColors.white,
                                        fontSize: w * .045,
                                        height: w * .140,
                                        radius: 12.0,
                                      ),
                                SizedBox(height: w * .1),
                              ],
                            )
                          : driverFormController.activeStep.value == 2
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: w * .01),
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
                                
                                // Name
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
                                ),
                                
                                SizedBox(height: w * .04),
                                
                                // Phone Number
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
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                ),
                                
                                SizedBox(height: w * .04),
                                
                                // Date of Birth
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
                                  onClicked: () async {
                                    DateTime initialDate = DateTime.now()
                                        .subtract(const Duration(days: 365 * 20));
                                    DateTime firstDate = DateTime(1900);
                                    DateTime lastDate = DateTime.now();

                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: initialDate,
                                      firstDate: firstDate,
                                      lastDate: lastDate,
                                    );

                                    if (picked != null) {
                                      setState(() {
                                        dobController.text = DateFormat("dd/MM/yyyy").format(picked);
                                      });
                                    }
                                  },
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    color: AppColors.primaryRed,
                                    size: w * 0.055,
                                  ),
                                ),
                                
                                // ... Continue with the rest of personal details fields from your original code
                                // (Email, Alternate Contacts, Relations, Addresses, Document Uploaders)
                                
                                SizedBox(height: w * .04),
                                
                                AppButtons.solid(
                                  context: context,
                                  text: "Continue",
                                  onClicked: () {
                                    driverFormController.activeStep.value = 3;
                                  },
                                  isFullWidth: true,
                                  backgroundColor: AppColors.primaryRed,
                                  textColor: AppColors.white,
                                  fontSize: w * .045,
                                  height: w * .140,
                                  radius: 12.0,
                                ),
                                SizedBox(height: w * .1),
                              ],
                            )
                          : driverFormController.activeStep.value == 3
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: w * .01),
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
                                        borderColor: AppColors.black,
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
                                  onClicked: () {
                                    driverFormController.resetSteps();
                                    CustomNavigator.push(
                                      context,
                                      BottomnavmainScreen(),
                                      transition: TransitionType.fade,
                                    );
                                  },
                                  isFullWidth: true,
                                  backgroundColor: AppColors.primaryRed,
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
              child: Icon(Icons.check, size: w * 0.045, color: AppColors.white),
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