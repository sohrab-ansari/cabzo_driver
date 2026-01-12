
// import 'package:corezap_driver/controller/driver_register_controller.dart';
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
 
//   // final   driverRegisterController = Get.find<DriverRegisterController>();
//   // add your vehicle textfields cotrollers
//   TextEditingController vehicleNameController = TextEditingController();

//   TextEditingController vehicleNumberController = TextEditingController();

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

//    late final DriverRegisterController driverRegisterController;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();


      //  driverRegisterController = Get.put(DriverRegisterController());
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
//                                   controller: vehicleNameController,
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
//                                   controller: vehicleNumberController,
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

//                                 Text("hawskjdh ${driverFormController.activeStep.value}"),
//                                 if(driverFormController.activeStep.value == 1) ... [

                                 

//                                       AppButtons.solid(
//                                   context: context,
//                                   text: "Continue",
//                                   onClicked: () {
//                                     driverFormController.activeStep.value = 2;



// driverRegisterController.Driver_register_controll_method1(

//   vehicleColor:  colorControlller.text,
//   vehicleCapacity: "",
// vehicleYear:    yearController.text,
// driverId: "",
// vehicleModel:  modelController.text,
// vehicleType:  vehicleTypeController.text,
// vehicleName:  vehicleNameController.text,
// vehicleInsuraneImage: "",
// vehicleNumber: vehicleNumberController.text,
// vehicleNumberImage: "",
// vehicleStatus: "",


// );
                                    
                                    
//                                   },
//                                   isFullWidth: true,
//                                   backgroundColor: AppColors.primaryRed,
//                                   textColor: AppColors.white,
//                                   fontSize: w * .045,
//                                   height: w * .140,
//                                   radius: 12.0,
//                                 ),

//                                  Text("asdhgfh"),
//                                 ],
                              
                              
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


import 'dart:convert';
import 'dart:io';
import 'package:corezap_driver/controller/driver_register_controller.dart';
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

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {
  final DriverFormController driverFormController = Get.find<DriverFormController>();
  // final DriverRegisterController driverRegisterController = Get.find<DriverRegisterController>();

  // Vehicle details controllers
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  
  // Personal details controllers
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alternateContact1Controller = TextEditingController();
  final TextEditingController relation1Controller = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController alternateContact2Controller = TextEditingController();
  final TextEditingController relation2Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();

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
 late final DriverRegisterController driverRegisterController;
  @override
  void initState() {
           driverRegisterController = Get.put(DriverRegisterController());

    super.initState();
  }

  @override
  void dispose() {
    // Dispose all controllers
    vehicleNameController.dispose();
    vehicleNumberController.dispose();
    vehicleTypeController.dispose();
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
    super.dispose();
  }

  // Convert File to base64 string
  Future<String?> _fileToBase64(File? file) async {
    if (file == null) return null;
    try {
      List<int> imageBytes = await file.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print('Error converting file to base64: $e');
      return null;
    }
  }


// Remove the _fileToBase64 method and update _submitVehicleDetails:

Future<void> _submitVehicleDetails() async {
  if (_isLoading) return;
  
  // Validate required fields
  if (vehicleNameController.text.isEmpty ||
      vehicleNumberController.text.isEmpty ||
      vehicleTypeController.text.isEmpty ||
      modelController.text.isEmpty ||
      yearController.text.isEmpty ||
      colorController.text.isEmpty ||
      plateNumberController.text.isEmpty) {
    Get.snackbar(
      'Error',
      'Please fill all required fields',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  // Validate required images
  if (_licencePlateImage == null ||
      _vehicleInsuranceImage == null ||
      _registrationCertificateImage == null) {
    Get.snackbar(
      'Error',
      'Please upload all required images',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    // Call API with File objects
    await driverRegisterController.Driver_register_controll_method1(
      vehicleName: vehicleNameController.text,
      vehicleNumber: vehicleNumberController.text,
      vehicleColor: colorController.text,
      vehicleType: vehicleTypeController.text,
      vehicleStatus: "pending",
      vehicleModel: modelController.text,
      vehicleCapacity: "",
      vehicleYear: yearController.text,
      vehicleNumberImageFile: _licencePlateImage, // Send File object
      vehicleInsuraneImageFile: _vehicleInsuranceImage, // Send File object
      registrationCertificateImageFile: _registrationCertificateImage, // Send File object
      driverId: "", // You should get actual driver ID
    );

    // Move to next step
    driverFormController.activeStep.value = 2;
    
  } catch (e) {
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
  // Submit vehicle details
  // Future<void> _submitVehicleDetails() async {
  //   if (_isLoading) return;
    
  //   // Validate required fields
  //   if (vehicleNameController.text.isEmpty ||
  //       vehicleNumberController.text.isEmpty ||
  //       vehicleTypeController.text.isEmpty ||
  //       modelController.text.isEmpty ||
  //       yearController.text.isEmpty ||
  //       colorController.text.isEmpty ||
  //       plateNumberController.text.isEmpty) {
  //     Get.snackbar(
  //       'Error',
  //       'Please fill all required fields',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // Convert images to base64
  //     String? registrationCertBase64 = await _fileToBase64(_registrationCertificateImage);
  //     String? licencePlateBase64 = await _fileToBase64(_licencePlateImage);
  //     String? vehicleInsuranceBase64 = await _fileToBase64(_vehicleInsuranceImage);

  //     // Call API
  //     await driverRegisterController.Driver_register_controll_method1(
  //       vehicleName: vehicleNameController.text,
  //       vehicleNumber: vehicleNumberController.text,
  //       vehicleColor: colorController.text,
  //       vehicleType: vehicleTypeController.text,
  //       vehicleStatus: "pending",
  //       vehicleModel: modelController.text,
  //       vehicleCapacity: "",
  //       vehicleYear: yearController.text,
  //       vehicleNumberImage: licencePlateBase64,
  //       vehicleInsuraneImage: vehicleInsuranceBase64,
  //       registrationCertificateImage: registrationCertBase64,
  //       driverId: "", // You should get actual driver ID
  //     );

  //     // Move to next step
  //     driverFormController.activeStep.value = 2;
      
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to submit vehicle details: $e',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

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
                                      hintText: "e.g. Swift Dzire",
                                      controller: modelController,
                                    ),
                                    SizedBox(height: w * .04),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
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
                                              hintText: "e.g. 2014",
                                              controller: yearController,
                                              width: w * .45,
                                              keyboardType: TextInputType.text,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      uploadText: 'Upload',
                                      borderColor: AppColors.black,
                                      onImageSelected: (File? image) {
                                        setState(() {
                                          _registrationCertificateImage = image;
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
                                      borderColor: AppColors.black,
                                      onImageSelected: (File? image) {
                                        setState(() {
                                          _licencePlateImage = image;
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
                                      borderColor: AppColors.black,
                                      onImageSelected: (File? image) {
                                        setState(() {
                                          _vehicleInsuranceImage = image;
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
                                    _isLoading
                                        ? Center(child: CircularProgressIndicator())
                                        : AppButtons.solid(
                                            context: context,
                                            text: "Continue",
                                            onClicked: _submitVehicleDetails,
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
                                            DateTime initialDate = DateTime.now().subtract(
                                              const Duration(days: 365 * 20),
                                            );
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
                                          controller: alternateContact1Controller,
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
                                          controller: relation1Controller,
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
                                          controller: alternateContact2Controller,
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
                                        CustomDocumentUploader(
                                          width: w,
                                          height: w * .4,
                                          borderRadius: 5,
                                          uploadText: 'Upload',
                                          borderColor: AppColors.black,
                                          onImageSelected: (File? image) {
                                            setState(() {
                                              _aadharFrontImage = image;
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
                                          borderColor: AppColors.black,
                                          onImageSelected: (File? image) {
                                            setState(() {
                                              _aadharBackImage = image;
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
                                          borderColor: AppColors.black,
                                          onImageSelected: (File? image) {
                                            setState(() {
                                              _panCardImage = image;
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
                                          borderColor: AppColors.black,
                                          onImageSelected: (File? image) {
                                            setState(() {
                                              _driverLicenseImage = image;
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
                                                    onImageSelected: (File? image) {
                                                      setState(() {
                                                        _profilePhotoImage = image;
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