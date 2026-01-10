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
//                                 // decoration: BoxDecoration(
//                                 //   color: AppColors.white,
//                                 //   boxShadow: [
//                                 //     BoxShadow(
//                                 //       color: Colors.grey.withOpacity(0.2),
//                                 //       spreadRadius: 2,
//                                 //       blurRadius: 3,
//                                 //     ),
//                                 //   ],
//                                 //   borderRadius: BorderRadius.circular(w * 0.03),
//                                 // ),
//                                 //  ? documents screen same preference----

//                                 //?--------have vehicle-------------
//                                 SizedBox(height: w * .02),
//                                 InkWell(
//                                   onTap: () {
//                                     driverFormController.activeStep.value = 1;
//                                     // CustomNavigator.push(
//                                     //   context,
//                                     //   DriverRegistration(),
//                                     //   transition: TransitionType.slideLeft,
//                                     // );
//                                   },
//                                   child: Container(
//                                     // width: w * 0.8,
//                                     // decoration: BoxDecoration(
//                                     //   color: AppColors.white,
//                                     //   boxShadow: [
//                                     //     BoxShadow(
//                                     //       color: Colors.grey.withOpacity(0.2),
//                                     //       spreadRadius: 2,
//                                     //       blurRadius: 3,
//                                     //     ),
//                                     //   ],
//                                     //   borderRadius: BorderRadius.circular(
//                                     //     w * 0.03,
//                                     //   ),
//                                     // ),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Container(
//                                               width: w * 0.46,
//                                               child: vehicleCard(
//                                                 image:
//                                                     "assets/images/image1.png",
//                                                 title: "I have a vehicle",
//                                                 desc:
//                                                     "Register your vehicle to begin driving. A quick verification will get you on the road.",
//                                               ),
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Container(
//                                               width: w * 0.46,
//                                               child: vehicleCard(
//                                                 image:
//                                                     "assets/images/image2.png",
//                                                 title: "I have a vehicle",
//                                                 desc:
//                                                     "Register your vehicle to begin driving. A quick verification will get you on the road.",
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 12),
//                                         Row(
//                                           children: [
//                                             Container(
//                                               width: w * 0.46,
//                                               child: vehicleCard(
//                                                 image:
//                                                     "assets/images/image3.png",
//                                                 title: "I need a vehicle",
//                                                 desc:
//                                                     "Register your vehicle to begin driving. A quick verification will get you on the road.",
//                                               ),
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Container(
//                                               width: w * 0.46,
//                                               child: vehicleCard(
//                                                 image:
//                                                     "assets/images/image4.png",
//                                                 title: "I need a vehicle",
//                                                 desc:
//                                                     "Register your vehicle to begin driving. A quick verification will get you on the road.",
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),

//                                     //                                   Column(
//                                     //                                     mainAxisSize: MainAxisSize.min,
//                                     //                                     mainAxisAlignment:
//                                     //                                         MainAxisAlignment.start,
//                                     //                                     crossAxisAlignment:
//                                     //                                         CrossAxisAlignment.start,
//                                     //                                     children: [

//                                     //                                       Row(
//                                     //                                         mainAxisAlignment: MainAxisAlignment.start,
//                                     //                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                     //                                         children: [

//                                     //  Card(
//                                     //    child: Column(
//                                     //                                               crossAxisAlignment: CrossAxisAlignment.start,

//                                     //      children: [
//                                     //        Image.asset("assets/images/image1.png",
//                                     //        height: 150,
//                                     //        width: 150,
//                                     //        ),

//                                     //        Text("I have a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

//                                     //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
//                                     //      ],
//                                     //    ),
//                                     //  ),
//                                     //   Card(
//                                     //     child: Column(
//                                     //                                               crossAxisAlignment: CrossAxisAlignment.start,

//                                     //      children: [
//                                     //        Image.asset("assets/images/image2.png",
//                                     //        height: 150,
//                                     //        width: 150,
//                                     //        ),

//                                     //        Text("I have a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

//                                     //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
//                                     //      ],
//                                     //        ),
//                                     //   ),

//                                     //                                         ],
//                                     //                                       ),

//                                     //                                       Row(
//                                     //                                         mainAxisAlignment: MainAxisAlignment.start,
//                                     //                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                     //                                         children: [

//                                     //  Card(
//                                     //    child: Column(
//                                     //                                               crossAxisAlignment: CrossAxisAlignment.start,

//                                     //      children: [
//                                     //        Image.asset("assets/images/image3.png",
//                                     //        height: 150,
//                                     //        width: 150,
//                                     //        ),

//                                     //        Text("I need a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

//                                     //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
//                                     //      ],
//                                     //    ),
//                                     //  ),
//                                     //   Card(
//                                     //     child: Column(
//                                     //                                               crossAxisAlignment: CrossAxisAlignment.start,

//                                     //      children: [
//                                     //        Image.asset("assets/images/image4.png",
//                                     //        height: 150,
//                                     //        width: 150,
//                                     //        ),

//                                     //        Text("I need a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

//                                     //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
//                                     //      ],
//                                     //        ),
//                                     //   ),

//                                     //                                         ],
//                                     //                                       ),

//                                     //                                       // Align(
//                                     //                                       //   child: Image.asset(
//                                     //                                       //     "assets/images/vehicle1.png",
//                                     //                                       //     fit: BoxFit.contain,
//                                     //                                       //   ),
//                                     //                                       // ),
//                                     //                                       // SizedBox(height: w * .03),
//                                     //                                       // Padding(
//                                     //                                       //   padding: EdgeInsets.symmetric(
//                                     //                                       //     horizontal: w * .03,
//                                     //                                       //   ),
//                                     //                                       //   child: AppFonts.textPoppins(
//                                     //                                       //     context,
//                                     //                                       //     "I have a vehicle",
//                                     //                                       //     w * 0.05,
//                                     //                                       //     FontWeight.w600,
//                                     //                                       //     AppColors.black,
//                                     //                                       //     TextAlign.center,
//                                     //                                       //     TextOverflow.visible,
//                                     //                                       //   ),
//                                     //                                       // ),
//                                     //                                       // Padding(
//                                     //                                       //   padding: EdgeInsets.symmetric(
//                                     //                                       //     horizontal: w * .03,
//                                     //                                       //   ),
//                                     //                                       //   child: AppFonts.textPoppins(
//                                     //                                       //     context,
//                                     //                                       //     "Register your vehicle to begin driving. A quick verification will get you on the road.",
//                                     //                                       //     w * 0.038,
//                                     //                                       //     FontWeight.w500,
//                                     //                                       //     AppColors.mediumGray,
//                                     //                                       //     TextAlign.left,
//                                     //                                       //     TextOverflow.ellipsis,
//                                     //                                       //     maxLines: 2,
//                                     //                                       //   ),
//                                     //                                       // ),
//                                     //                                       // SizedBox(height: w * .03),

//                                     //                                       // SizedBox(height: w * .03),

//                                     //                                     ],
//                                     //                                   ),
//                                   ),
//                                 ),

//                                 //?------need vehicle
//                                 // Padding(
//                                 //   padding: EdgeInsets.symmetric(
//                                 //     vertical: w * .05,
//                                 //   ),
//                                 //   child: InkWell(
//                                 //     onTap: () {
//                                 //       driverFormController.activeStep.value = 2;
//                                 //       // CustomNavigator.push(
//                                 //       //   context,
//                                 //       //   DriverRegistration(),
//                                 //       //   transition: TransitionType.slideLeft,
//                                 //       // );
//                                 //     },
//                                 //     child: Container(
//                                 //       // width: w * 0.8,
//                                 //       decoration: BoxDecoration(
//                                 //         color: AppColors.white,
//                                 //         boxShadow: [
//                                 //           BoxShadow(
//                                 //             color: Colors.grey.withOpacity(0.2),
//                                 //             spreadRadius: 2,
//                                 //             blurRadius: 3,
//                                 //           ),
//                                 //         ],
//                                 //         borderRadius: BorderRadius.circular(
//                                 //           w * 0.03,
//                                 //         ),
//                                 //       ),
//                                 //       child: Column(
//                                 //         mainAxisSize: MainAxisSize.min,
//                                 //         mainAxisAlignment:
//                                 //             MainAxisAlignment.start,
//                                 //         crossAxisAlignment:
//                                 //             CrossAxisAlignment.start,
//                                 //         children: [
//                                 //           Align(
//                                 //             child: Image.asset(
//                                 //               "assets/images/needVehicle.png",
//                                 //               fit: BoxFit.contain,
//                                 //             ),
//                                 //           ),
//                                 //           SizedBox(height: w * .03),
//                                 //           Padding(
//                                 //             padding: EdgeInsets.symmetric(
//                                 //               horizontal: w * .03,
//                                 //             ),
//                                 //             child: AppFonts.textPoppins(
//                                 //               context,
//                                 //               "I need a vehicle",
//                                 //               w * 0.05,
//                                 //               FontWeight.w600,
//                                 //               AppColors.black,
//                                 //               TextAlign.center,
//                                 //               TextOverflow.visible,
//                                 //             ),
//                                 //           ),
//                                 //           Padding(
//                                 //             padding: EdgeInsets.symmetric(
//                                 //               horizontal: w * .03,
//                                 //             ),
//                                 //             child: AppFonts.textPoppins(
//                                 //               context,
//                                 //               "Don’t have a vehicle? We’ll help you get one to start driving.",
//                                 //               w * 0.038,
//                                 //               FontWeight.w500,
//                                 //               AppColors.mediumGray,
//                                 //               TextAlign.left,
//                                 //               TextOverflow.ellipsis,
//                                 //               maxLines: 2,
//                                 //             ),
//                                 //           ),
//                                 //           SizedBox(height: w * .06),
//                                 //         ],
//                                 //       ),
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 SizedBox(height: w * .1),
//                               ],
//                             )
//                           //?------------
//                           : driverFormController.activeStep.value == 1
//                           ? Column(
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
//                                 // Row(
//                                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 //   children: [
//                                 //     Column(
//                                 //       crossAxisAlignment: CrossAxisAlignment.start,
//                                 //       children: [
//                                 //         AppFonts.textPoppins(
//                                 //           context,
//                                 //           "Year",
//                                 //           w * 0.04,
//                                 //           FontWeight.w500,
//                                 //           AppColors.black,
//                                 //           TextAlign.left,
//                                 //           TextOverflow.ellipsis,
//                                 //         ),
//                                 //         SizedBox(height: w * .01),
//                                 //         AppFormFields.custTextFormOther(
//                                 //           context: context,
//                                 //           hintText: "e.g. 2014",
//                                 //           controller: carNameController,
//                                 //           width: w * .45,
//                                 //         ),
//                                 //       ],
//                                 //     ),
//                                 //     Column(
//                                 //       crossAxisAlignment: CrossAxisAlignment.start,
//                                 //       children: [
//                                 //         AppFonts.textPoppins(
//                                 //           context,
//                                 //           "Color",
//                                 //           w * 0.04,
//                                 //           FontWeight.w500,
//                                 //           AppColors.black,
//                                 //           TextAlign.left,
//                                 //           TextOverflow.ellipsis,
//                                 //         ),
//                                 //         SizedBox(height: w * .01),
//                                 //         AppFormFields.custTextFormOther(
//                                 //           context: context,
//                                 //           hintText: "e.g. Black",
//                                 //           controller: carNameController,
//                                 //           width: w * .45,
//                                 //         ),
//                                 //       ],
//                                 //     ),
//                                 //   ],
//                                 // ),
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
//                                 SizedBox(height: w * .17),
//                                 Center(
//                                   child: Column(
//                                     children: [
//                                       CustomDocumentUploader(
//                                         width: w * .5,
//                                         height: w * .5,
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

////////////////////////////////////////////////////////////////new code
///
///
///
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
import 'package:corezap_driver/views/bottomNavigation/home_screen.dart';
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
  DriverFormController driverFormController = Get.find<DriverFormController>();
  // add your vehicle textfields cotrollers
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController colorControlller = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  // add your prrsonal details textfields cotrollers
  TextEditingController dobController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController emailControlller = TextEditingController();
  TextEditingController alternateContactNumber1Controller =
      TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController alternateContactNumber2Controller =
      TextEditingController();
  TextEditingController relation2Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();

  String imagePath = "";
  int activeStep = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // driverFormController.resetSteps();
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
                //  driverFormController.resetSteps();
                if (driverFormController.activeStep.value > 0 &&
                    driverFormController.activeStep.value <= 3) {
                  driverFormController.activeStep.value--;
                } else if (driverFormController.activeStep.value == 0) {
                  CustomNavigator.pop(context);
                } else {
                  print(".. condition");
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
                //                  Preference
                // Vehicle Details
                // Personal Details
                // Profile Photo
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
                  // preference activestep 0
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
                                // decoration: BoxDecoration(
                                //   color: AppColors.white,
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.grey.withOpacity(0.2),
                                //       spreadRadius: 2,
                                //       blurRadius: 3,
                                //     ),
                                //   ],
                                //   borderRadius: BorderRadius.circular(w * 0.03),
                                // ),
                                //  ? documents screen same preference----

                                //?--------have vehicle-------------
                                SizedBox(height: w * .02),
                                InkWell(
                                  onTap: () {
                                    driverFormController.activeStep.value = 1;
                                    // CustomNavigator.push(
                                    //   context,
                                    //   DriverRegistration(),
                                    //   transition: TransitionType.slideLeft,
                                    // );
                                  },
                                  child: Container(
                                    // width: w * 0.8,
                                    // decoration: BoxDecoration(
                                    //   color: AppColors.white,
                                    //   boxShadow: [
                                    //     BoxShadow(
                                    //       color: Colors.grey.withOpacity(0.2),
                                    //       spreadRadius: 2,
                                    //       blurRadius: 3,
                                    //     ),
                                    //   ],
                                    //   borderRadius: BorderRadius.circular(
                                    //     w * 0.03,
                                    //   ),
                                    // ),
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

                                    //                                   Column(
                                    //                                     mainAxisSize: MainAxisSize.min,
                                    //                                     mainAxisAlignment:
                                    //                                         MainAxisAlignment.start,
                                    //                                     crossAxisAlignment:
                                    //                                         CrossAxisAlignment.start,
                                    //                                     children: [

                                    //                                       Row(
                                    //                                         mainAxisAlignment: MainAxisAlignment.start,
                                    //                                         crossAxisAlignment: CrossAxisAlignment.start,
                                    //                                         children: [

                                    //  Card(
                                    //    child: Column(
                                    //                                               crossAxisAlignment: CrossAxisAlignment.start,

                                    //      children: [
                                    //        Image.asset("assets/images/image1.png",
                                    //        height: 150,
                                    //        width: 150,
                                    //        ),

                                    //        Text("I have a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

                                    //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
                                    //      ],
                                    //    ),
                                    //  ),
                                    //   Card(
                                    //     child: Column(
                                    //                                               crossAxisAlignment: CrossAxisAlignment.start,

                                    //      children: [
                                    //        Image.asset("assets/images/image2.png",
                                    //        height: 150,
                                    //        width: 150,
                                    //        ),

                                    //        Text("I have a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

                                    //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
                                    //      ],
                                    //        ),
                                    //   ),

                                    //                                         ],
                                    //                                       ),

                                    //                                       Row(
                                    //                                         mainAxisAlignment: MainAxisAlignment.start,
                                    //                                         crossAxisAlignment: CrossAxisAlignment.start,
                                    //                                         children: [

                                    //  Card(
                                    //    child: Column(
                                    //                                               crossAxisAlignment: CrossAxisAlignment.start,

                                    //      children: [
                                    //        Image.asset("assets/images/image3.png",
                                    //        height: 150,
                                    //        width: 150,
                                    //        ),

                                    //        Text("I need a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

                                    //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
                                    //      ],
                                    //    ),
                                    //  ),
                                    //   Card(
                                    //     child: Column(
                                    //                                               crossAxisAlignment: CrossAxisAlignment.start,

                                    //      children: [
                                    //        Image.asset("assets/images/image4.png",
                                    //        height: 150,
                                    //        width: 150,
                                    //        ),

                                    //        Text("I need a vehicle",style: TextStyle(fontWeight: FontWeight.bold),),

                                    //          Text("Register your vehicle to \n begin driving. A quick \n verification will get you \n on the road.")
                                    //      ],
                                    //        ),
                                    //   ),

                                    //                                         ],
                                    //                                       ),

                                    //                                       // Align(
                                    //                                       //   child: Image.asset(
                                    //                                       //     "assets/images/vehicle1.png",
                                    //                                       //     fit: BoxFit.contain,
                                    //                                       //   ),
                                    //                                       // ),
                                    //                                       // SizedBox(height: w * .03),
                                    //                                       // Padding(
                                    //                                       //   padding: EdgeInsets.symmetric(
                                    //                                       //     horizontal: w * .03,
                                    //                                       //   ),
                                    //                                       //   child: AppFonts.textPoppins(
                                    //                                       //     context,
                                    //                                       //     "I have a vehicle",
                                    //                                       //     w * 0.05,
                                    //                                       //     FontWeight.w600,
                                    //                                       //     AppColors.black,
                                    //                                       //     TextAlign.center,
                                    //                                       //     TextOverflow.visible,
                                    //                                       //   ),
                                    //                                       // ),
                                    //                                       // Padding(
                                    //                                       //   padding: EdgeInsets.symmetric(
                                    //                                       //     horizontal: w * .03,
                                    //                                       //   ),
                                    //                                       //   child: AppFonts.textPoppins(
                                    //                                       //     context,
                                    //                                       //     "Register your vehicle to begin driving. A quick verification will get you on the road.",
                                    //                                       //     w * 0.038,
                                    //                                       //     FontWeight.w500,
                                    //                                       //     AppColors.mediumGray,
                                    //                                       //     TextAlign.left,
                                    //                                       //     TextOverflow.ellipsis,
                                    //                                       //     maxLines: 2,
                                    //                                       //   ),
                                    //                                       // ),
                                    //                                       // SizedBox(height: w * .03),

                                    //                                       // SizedBox(height: w * .03),

                                    //                                     ],
                                    //                                   ),
                                  ),
                                ),

                                //?------need vehicle
                                // Padding(
                                //   padding: EdgeInsets.symmetric(
                                //     vertical: w * .05,
                                //   ),
                                //   child: InkWell(
                                //     onTap: () {
                                //       driverFormController.activeStep.value = 2;
                                //       // CustomNavigator.push(
                                //       //   context,
                                //       //   DriverRegistration(),
                                //       //   transition: TransitionType.slideLeft,
                                //       // );
                                //     },
                                //     child: Container(
                                //       // width: w * 0.8,
                                //       decoration: BoxDecoration(
                                //         color: AppColors.white,
                                //         boxShadow: [
                                //           BoxShadow(
                                //             color: Colors.grey.withOpacity(0.2),
                                //             spreadRadius: 2,
                                //             blurRadius: 3,
                                //           ),
                                //         ],
                                //         borderRadius: BorderRadius.circular(
                                //           w * 0.03,
                                //         ),
                                //       ),
                                //       child: Column(
                                //         mainAxisSize: MainAxisSize.min,
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.start,
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Align(
                                //             child: Image.asset(
                                //               "assets/images/needVehicle.png",
                                //               fit: BoxFit.contain,
                                //             ),
                                //           ),
                                //           SizedBox(height: w * .03),
                                //           Padding(
                                //             padding: EdgeInsets.symmetric(
                                //               horizontal: w * .03,
                                //             ),
                                //             child: AppFonts.textPoppins(
                                //               context,
                                //               "I need a vehicle",
                                //               w * 0.05,
                                //               FontWeight.w600,
                                //               AppColors.black,
                                //               TextAlign.center,
                                //               TextOverflow.visible,
                                //             ),
                                //           ),
                                //           Padding(
                                //             padding: EdgeInsets.symmetric(
                                //               horizontal: w * .03,
                                //             ),
                                //             child: AppFonts.textPoppins(
                                //               context,
                                //               "Don’t have a vehicle? We’ll help you get one to start driving.",
                                //               w * 0.038,
                                //               FontWeight.w500,
                                //               AppColors.mediumGray,
                                //               TextAlign.left,
                                //               TextOverflow.ellipsis,
                                //               maxLines: 2,
                                //             ),
                                //           ),
                                //           SizedBox(height: w * .06),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(height: w * .1),
                              ],
                            )
                          //?------------
                          : driverFormController.activeStep.value == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "Vehicle type",
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
                                  controller: vehicleTypeController,
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
                                  hintText: "e.g. Swift Dzire ",
                                  controller: modelController,
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
                                          keyboardType: TextInputType.text,
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
                                          controller: colorControlller,
                                          width: w * .45,
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
                                  // onUploadPressed: () {
                                  //   // Handle file upload logic here, e.g., show file picker.
                                  // },
                                  uploadText: 'Upload',
                                  borderColor: AppColors.black,
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
                                  // onUploadPressed: () {
                                  //   // Handle file upload logic here, e.g., show file picker.
                                  // },
                                  uploadText: 'Upload',
                                  borderColor: AppColors.black,
                                ),

                                //    Make sure your vehicle’s licence plate number photo are clear and visible.
                                AppFonts.textPoppins(
                                  context,
                                  "Make sure your vehicle’s licence plate number photo are clear and visible.",
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
                                // upload document
                                CustomDocumentUploader(
                                  width: w,
                                  height: w * .4,
                                  borderRadius: 5,
                                  // onUploadPressed: () {
                                  //   // Handle file upload logic here, e.g., show file picker.
                                  // },
                                  uploadText: 'Upload',
                                  borderColor: AppColors.black,
                                ),
                                //    Make sure your vehicle’s licence plate number photo are clear and visible.
                                AppFonts.textPoppins(
                                  context,
                                  "Make sure your vehicle’s insurance photo are clear and visible.",
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
                                  onClicked: () {
                                    driverFormController.activeStep.value = 2;
                                    // CustomNavigator.push(
                                    //   context,
                                    //   LiveRide(),
                                    //   transition: TransitionType.fade,
                                    // );
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
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                ),
                                SizedBox(height: w * .04),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         AppFonts.textPoppins(
                                //           context,
                                //           "Year",
                                //           w * 0.04,
                                //           FontWeight.w500,
                                //           AppColors.black,
                                //           TextAlign.left,
                                //           TextOverflow.ellipsis,
                                //         ),
                                //         SizedBox(height: w * .01),
                                //         AppFormFields.custTextFormOther(
                                //           context: context,
                                //           hintText: "e.g. 2014",
                                //           controller: carNameController,
                                //           width: w * .45,
                                //         ),
                                //       ],
                                //     ),
                                //     Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         AppFonts.textPoppins(
                                //           context,
                                //           "Color",
                                //           w * 0.04,
                                //           FontWeight.w500,
                                //           AppColors.black,
                                //           TextAlign.left,
                                //           TextOverflow.ellipsis,
                                //         ),
                                //         SizedBox(height: w * .01),
                                //         AppFormFields.custTextFormOther(
                                //           context: context,
                                //           hintText: "e.g. Black",
                                //           controller: carNameController,
                                //           width: w * .45,
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
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
                                // AppFormFields.custTextFormOther(
                                //   context: context,
                                //   hintText: "e.g. 15/01/2002",
                                //   controller: dateOfBirthController,
                                // ),
                                AppFormFields.custTextFormOther(
                                  context: context,
                                  hintText: "DD/MM/YYYY",
                                  controller: dobController,
                                  readOnly: true,
                                  onClicked: () async {
                                    DateTime initialDate = DateTime.now()
                                        .subtract(
                                          const Duration(days: 365 * 20),
                                        );
                                    DateTime firstDate = DateTime(1900);
                                    DateTime lastDate = DateTime.now();

                                    final DateTime? picked =
                                        await showDatePicker(
                                          context: context,
                                          initialDate: initialDate,
                                          firstDate: firstDate,
                                          lastDate: lastDate,
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
                                  controller: emailControlller,
                                  keyboardType: TextInputType.emailAddress,
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
                                  controller: alternateContactNumber1Controller,
                                  keyboardType: TextInputType.number,
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
                                  controller: relationController,
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
                                  controller: alternateContactNumber2Controller,
                                  keyboardType: TextInputType.number,
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
                                // upload documnet
                                CustomDocumentUploader(
                                  width: w,
                                  height: w * .4,
                                  borderRadius: 5,
                                  // onUploadPressed: () {
                                  //   // Handle file upload logic here, e.g., show file picker.
                                  // },
                                  uploadText: 'Upload',
                                  borderColor: AppColors.black,
                                ),
                                //    Make sure your vehicle’s licence plate number photo are clear and visible.
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
                                  "Upload Photo of Aadhar Card",
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
                                  // onUploadPressed: () {
                                  //   // Handle file upload logic here, e.g., show file picker.
                                  // },
                                  uploadText: 'Upload',
                                  borderColor: AppColors.black,
                                ),
                                //    Make sure your vehicle’s licence plate number photo are clear and visible.
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
                                  // onUploadPressed: () {
                                  //   // Handle file upload logic here, e.g., show file picker.
                                  // },
                                  uploadText: 'Upload',
                                  borderColor: AppColors.black,
                                ),
                                //    Make sure your vehicle’s licence plate number photo are clear and visible.
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
                                  // onUploadPressed: () {
                                  //   // Handle file upload logic here, e.g., show file picker.
                                  // },
                                  uploadText: 'Upload',
                                  borderColor: AppColors.black,
                                ),
                                //    Make sure your vehicle’s licence plate number photo are clear and visible.
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
                                  onClicked: () {
                                    driverFormController.activeStep.value = 3;
                                    // CustomNavigator.push(
                                    //   context,
                                    //   LiveRide(),
                                    //   transition: TransitionType.fade,
                                    // );
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
                                        // onUploadPressed: () {
                                        //   // Handle file upload logic here, e.g., show file picker.
                                        // },
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

  //?----------------method
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
      // title:  title,
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
