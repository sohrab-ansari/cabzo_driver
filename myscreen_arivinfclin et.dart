// // import 'package:corezap_driver/controller/controllers.dart';
// // import 'package:corezap_driver/controller/stepper_controller.dart';
// // import 'package:corezap_driver/utilities/app_buttons.dart';
// // import 'package:corezap_driver/utilities/colors.dart';
// // import 'package:corezap_driver/utilities/colors/colors_list.dart';
// // import 'package:corezap_driver/utilities/custom_font.dart';
// // import 'package:corezap_driver/utilities/custom_images.dart';
// // import 'package:corezap_driver/utilities/custom_text.dart';
// // import 'package:corezap_driver/utilities/location_input_textfield.dart';
// // import 'package:corezap_driver/utilities/navigator.dart';
// // import 'package:corezap_driver/views/scheduled_pickups/chat_screen.dart';
// // import 'package:corezap_driver/views/scheduled_pickups/enter_code_screen.dart';
// // import 'package:corezap_driver/views/scheduled_pickups/receive_payment_modes.dart';
// // import 'package:easy_stepper/easy_stepper.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// // import 'package:get/instance_manager.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // class ArrivingClient extends StatefulWidget {
// //   const ArrivingClient({super.key});

// //   @override
// //   State<ArrivingClient> createState() => _ArrivingClientState();
// // }

// // class _ArrivingClientState extends State<ArrivingClient> {
// //   StepperController stepperController = Get.find<StepperController>();
// //   String imagePath = "";
// //   int activeStep = 0;
// //   late GoogleMapController mapController;
// //   final CameraPosition _initialPosition = const CameraPosition(
// //     target: LatLng(23.2599, 77.4126), // Example: Bhopal
// //     zoom: 14,
// //   );
// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;
// //     return Scaffold(
// //       backgroundColor: ColorsList.scaffoldColor,
// //       appBar: AppBar(
// //         backgroundColor: ColorsList.scaffoldColor,
// //         automaticallyImplyLeading: false,
// //         titleSpacing: w * .03,
// //         title: Row(
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 //   CustomNavigation.pop(context);
// //               },
// //               child: CustomImages.images(
// //                 "assets/icons/arrowLeftIcon.png",
// //                 w * .07,
// //                 w * .07,
// //               ),
// //             ),
// //             SizedBox(width: w * .02),
// //             //Arriving Client
// //             CustomText(
// //               text: "Arriving Client",
// //               textColor: ColorsList.titleTextColor,
// //               textFontSize: w * .055,
// //               textFontWeight: FontWeight.w500,
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: w * .03),
// //             child: Column(
// //               children: [
// //                 //custom app bar==================
// //                 SizedBox(height: w * .02),
// //                 LocationInputTextfield(
// //                   onPressed: () {},
// //                   preffixImage: "assets/icons/greenDot.png",
// //                   //  preffixhorizontalPadding: w * .02,
// //                   // preffixverticalPadding: w * .04,
// //                   hintText: "Your Current Location",
// //                 ),
// //                 SizedBox(height: w * .02),
// //                 LocationInputTextfield(
// //                   onPressed: () {},
// //                   preffixImage: "assets/icons/redDot.png",
// //                   //  preffixhorizontalPadding: w * .02,
// //                   // preffixverticalPadding: w * .04,
// //                   hintText: "Drop location",
// //                 ),
// //                 SizedBox(height: w * .02),
// //               ],
// //             ),
// //           ),
// //           SizedBox(
// //             height: w * .5,
// //             child: Stack(
// //               children: [
// //                 GoogleMap(
// //                   initialCameraPosition: _initialPosition,
// //                   mapType: MapType.normal, // normal, satellite, hybrid, terrain
// //                   myLocationEnabled: true, // user location show
// //                   myLocationButtonEnabled: true, // location button
// //                   zoomControlsEnabled: false,
// //                   onMapCreated: (GoogleMapController controller) {
// //                     mapController = controller;
// //                   },
// //                 ),

// //                 Obx(() {
// //                   final step = stepperController.activeStep.value;
// //                   if (step == 1 || step == 2 || step == 3) {
// //                     return Positioned(
// //                       bottom: w * .02,
// //                       left: (w - (w * 0.6)) / 2,
// //                       child: Container(
// //                         width: w * .6,
// //                         height: w * .1,
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(5),
// //                           color: ColorsList.iconGreyColor,
// //                         ),
// //                         child: Center(
// //                           child: CustomText(
// //                             text: step == 1
// //                                 ? "5 min to reach client"
// //                                 : step == 2
// //                                 ? "You reach the client"
// //                                 : "End in 9 min",
// //                             textColor: ColorsList.mainButtonTextColor,
// //                             textFontSize: w * .032,
// //                             textFontWeight: FontWeight.w400,
// //                             textalign: TextAlign.center,
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }
// //                   return const SizedBox();
// //                 }),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: Container(
// //               color: AppColors.white,
// //               child: Column(
// //                 children: [
                  

// //                   Column(
// //                                                         crossAxisAlignment: CrossAxisAlignment.start,

// //                               children: [
// //                                 Text("7 min",style: TextStyle(fontWeight: FontWeight.w500),),
// //                                 Text("to pickup location ")
// //                               ],
// //                             ),
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(
// //                       horizontal: w * .03,
// //                       vertical: w * .04,
// //                     ),
// //                     child: Container(
// //                       // height: w * .3,
// //                       decoration: BoxDecoration(
// //                         color: AppColors.white,
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.grey.withOpacity(0.2),
// //                             spreadRadius: 2,
// //                             blurRadius: 3,
// //                           ),
// //                         ],
// //                         borderRadius: BorderRadius.circular(w * 0.03),
// //                       ),
// //                       child: Padding(
// //                         padding: EdgeInsets.symmetric(
// //                           horizontal: w * .03,
// //                           vertical: w * .03,
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [

                            
// //                             SizedBox(height: 10,),
// //                             GestureDetector(
// //                               onTap: () {
// //                                 //? review rating----------------------
// //                               },
// //                               child: Row(
// //                                 crossAxisAlignment: CrossAxisAlignment.center,
// //                                 children: [
// //                                   CircleAvatar(
// //                                     radius: w * .055,
// //                                     backgroundColor: Colors.grey.shade300,
// //                                     backgroundImage:
// //                                         imagePath != null &&
// //                                             imagePath.isNotEmpty
// //                                         ? AssetImage(
// //                                             imagePath,
// //                                           ) //  NetworkImage(imageUrl)
// //                                         : null,
// //                                     child:
// //                                         (imagePath == null || imagePath.isEmpty)
// //                                         ? Icon(
// //                                             Icons.person,
// //                                             size: w * .08,
// //                                             color: Colors.grey.shade700,
// //                                           )
// //                                         : null,
// //                                   ),
// //                                   SizedBox(width: w * .03),
// //                                   CustomText(
// //                                     text: "Amaan Shaikh ", // 1,2,3,4
// //                                     textColor: ColorsList.titleTextColor,
// //                                     textFontSize: w * .046,
// //                                     textFontWeight: FontWeight.w400,
// //                                   ),
// //                                   Spacer(),
// //                                   //======================call and chat btton================
// //                                   Container(
// //                                     // margin: EdgeInsets.all(w * .02),
// //                                     decoration: BoxDecoration(
// //                                       shape: BoxShape.circle,
// //                                       color: ColorsList.mainButtonLightColor,
// //                                     ),

// //                                     padding: EdgeInsets.all(w * 0.02),
// //                                     child: Icon(
// //                                       Icons.call,
// //                                       color: ColorsList.mainAppColor,
// //                                       size: w * .04,
// //                                     ),
// //                                   ),
// //                                   SizedBox(width: w * .02),
// //                                   GestureDetector(
// //                                     onTap: () {
// //                                       CustomNavigator.push(
// //                                         context,
// //                                         ChatScreen(),
// //                                         transition: TransitionType.slideTop,
// //                                       );
// //                                     },
// //                                     child: Container(
// //                                       // margin: EdgeInsets.all(w * .02),
// //                                       decoration: BoxDecoration(
// //                                         shape: BoxShape.circle,
// //                                         color: ColorsList.mainButtonLightColor,
// //                                       ),

// //                                       padding: EdgeInsets.all(w * 0.02),
// //                                       child: CustomImages.images(
// //                                         "assets/images/mess.png",
// //                                         w * .044,
// //                                         w * .044,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                             SizedBox(height: w * .02),

// //                          Align(
// //                           alignment: AlignmentGeometry.centerRight,
// //                           child: Text("Total Fare: ₹100",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.blue),))

// //                             // Container(
// //                             //   decoration: BoxDecoration(
// //                             //     color: ColorsList.mainButtonLightColor,
// //                             //     borderRadius: BorderRadius.circular(w * .02),
// //                             //   ),
// //                             //   child: Padding(
// //                             //     padding: EdgeInsets.symmetric(
// //                             //       horizontal: w * .03,
// //                             //       vertical: w * .03,
// //                             //     ),
// //                             //     child: Row(
// //                             //       mainAxisAlignment:
// //                             //           MainAxisAlignment.spaceBetween,
// //                             //       children: [
// //                             //         Column(
// //                             //           mainAxisAlignment:
// //                             //               MainAxisAlignment.spaceBetween,
// //                             //           children: [
// //                             //             CustomText(
// //                             //               text: "Trip takes ", // 1,2,3,4
// //                             //               textColor: ColorsList.titleTextColor,
// //                             //               textFontSize: w * .035,
// //                             //               textFontWeight: FontWeight.w400,
// //                             //             ),
// //                             //             CustomText(
// //                             //               text: "15 minute", // 1,2,3,4
// //                             //               textColor:
// //                             //                   ColorsList.subtitleTextColor,
// //                             //               textFontSize: w * .038,
// //                             //               textFontWeight: FontWeight.w400,
// //                             //             ),
// //                             //           ],
// //                             //         ),
// //                             //         CustomText(
// //                             //           text: "₹50", // 1,2,3,4
// //                             //           textColor: ColorsList.titleTextColor,
// //                             //           textFontSize: w * .04,
// //                             //           textFontWeight: FontWeight.w400,
// //                             //         ),
// //                             //       ],
// //                             //     ),
// //                             //   ),
// //                             // ),
                          
// //                           ,Column(
// //   crossAxisAlignment: CrossAxisAlignment.start,
// //   children: [
// //     Row(
// //       children: [
// //         Container(
// //   width: 18,
// //   height: 18,
// //   decoration: BoxDecoration(
// //     shape: BoxShape.circle,
// //     color: Color(0xFF08875D), // inner fill (very light)
// //     border: Border.all(
// //       color: Color(0xFFDAEDE7), // outer border (light green)
// //       width: 4,
// //     ),
// //   ),
// // ),

       
// //         const SizedBox(width: 8),
// //         const Text(
// //           "Pickup",
// //           style: TextStyle(fontWeight: FontWeight.w600),
// //         ),
// //       ],
// //     ),
// //     const SizedBox(height: 4),
// //     const Text(
// //       "Bus Sta Upas, Majestic, Bengaluru, Karnataka 560009",
// //       style: TextStyle(color: Colors.black54),
// //     ),
// //   ],
// // )

// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
                 

// //  Spacer(),
// //                   Container(
// //                     // margin: EdgeInsets.all(10),
// //                     margin: EdgeInsets.only(left: 12,bottom: 10),
// //                     child: Row(
// //                       children: [
                    
// //                     SizedBox(
// //                       width: w * 0.45,
// //                        height: w * 0.14,
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           // your action here
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Color(0xFFE0E4E7), // button color
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(5), // radius 5
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "Cancel",
// //                           style: TextStyle(color: Colors.grey),
// //                         ),
// //                       ),
// //                     ),
                    
// //                     SizedBox( width: w * 0.04,),
                      
                       
                    
// //                         SizedBox(
// //                            width: w * 0.45,
// //                            height: w * 0.14,
// //                           child: ElevatedButton(
// //                             onPressed: () {
// //                               // your action here
// //                             },
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Color(0xFF26E3DD), // button color
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(5), // radius 5
// //                               ),
// //                             ),
// //                             child: const Text(
// //                               "I’ve Arrived",
// //                               style: TextStyle(color: Colors.black87),
// //                             ),
// //                           ),
// //                         )
                    
// //                       ],
// //                     ),
// //                   ),
// //                   // Obx(
// //                   //   () => EasyStepper(
// //                   //     activeStep: stepperController.activeStep.value,
// //                   //     lineStyle: LineStyle(
// //                   //       lineType: LineType.normal,
// //                   //       unreachedLineType: LineType.normal,
// //                   //       defaultLineColor: AppColors.lightGray,
// //                   //       finishedLineColor: AppColors.primaryRed,
// //                   //       lineLength: w * .18,
// //                   //       lineThickness: 2,
// //                   //     ),
// //                   //     internalPadding: 0,
// //                   //     stepRadius: w * 0.04,
// //                   //     showStepBorder: false,
// //                   //     steps: [
// //                   //       buildStep(
// //                   //         0,
// //                   //         'Accepted',
// //                   //         w,
// //                   //         stepperController.activeStep.value,
// //                   //       ),
// //                   //       buildStep(
// //                   //         1,
// //                   //         'Arriving',
// //                   //         w,
// //                   //         stepperController.activeStep.value,
// //                   //       ),
// //                   //       buildStep(
// //                   //         2,
// //                   //         'Starting',
// //                   //         w,
// //                   //         stepperController.activeStep.value,
// //                   //       ),
// //                   //       buildStep(
// //                   //         3,
// //                   //         'End Trip',
// //                   //         w,
// //                   //         stepperController.activeStep.value,
// //                   //       ),
// //                   //     ],
// //                   //     onStepReached: (index) =>
// //                   //         stepperController.reachStep(index),
// //                   //   ),
// //                   // ),

                  

                  
// //                   // Obx(
// //                   //   () => Padding(
// //                   //     padding: EdgeInsets.symmetric(horizontal: w * .03),
// //                   //     child: AppButtons.outlined(
// //                   //       context: context,
// //                   //       text: stepperController.activeStep.value == 1
// //                   //           ? "Arrive Client"
// //                   //           : stepperController.activeStep.value == 2
// //                   //           ? "Start Trip"
// //                   //           : stepperController.activeStep.value == 3
// //                   //           ? "Completed trip"
// //                   //           : "Completed trip",
// //                   //       onClicked: () {
// //                   //         if (stepperController.activeStep.value == 1) {
// //                   //           CustomNavigator.push(
// //                   //             context,
// //                   //             EnterCodeScreen(),
// //                   //             transition: TransitionType.fade,
// //                   //           );
// //                   //         } else if (stepperController.activeStep.value == 2) {
// //                   //           stepperController.nextStep();
// //                   //         } else if (stepperController.activeStep.value == 3) {
// //                   //           stepperController.nextStep();
// //                   //           CustomNavigator.push(
// //                   //             context,
// //                   //             ReceivePaymentModes(),
// //                   //             transition: TransitionType.fade,
// //                   //           );
// //                   //         }
// //                   //       },
// //                   //       isFullWidth: true,
// //                   //       backgroundColor: stepperController.activeStep.value == 3
// //                   //           ? AppColors.white
// //                   //           : ColorsList.mainButtonColor,
// //                   //       borderColor: AppColors.primaryRed,
// //                   //       textColor: stepperController.activeStep.value == 3
// //                   //           ? AppColors.primaryRed
// //                   //           : ColorsList.mainButtonTextColor,
// //                   //       fontSize: w * .045,
// //                   //       height: w * .140,
// //                   //       radius: 12.0,
// //                   //     ),
// //                   //   ),
// //                   // ),
                 
                 
// //                   // Padding(
// //                   //   padding: EdgeInsets.symmetric(horizontal: w * .03),
// //                   //   child: AppButtons.solid(
// //                   //     context: context,
// //                   //     text: "Deny",
// //                   //     onClicked: () {
// //                   //       // CustomNavigator.push(
// //                   //       //   context,
// //                   //       //   LiveRide(),
// //                   //       //   transition: TransitionType.fade,
// //                   //       // );
// //                   //     },
// //                   //     isFullWidth: true,
// //                   //     backgroundColor: AppColors.white,
// //                   //     textColor: AppColors.mediumGray,
// //                   //     fontSize: w * .045,
// //                   //     height: w * .140,
// //                   //     radius: 12.0,
// //                   //   ),
// //                   // ),
                
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   EasyStep buildStep(int stepIndex, String title, double w, int activeStep) {
// //     bool isActive = activeStep >= stepIndex;

// //     return EasyStep(
// //       customStep: isActive
// //           ? CircleAvatar(
// //               radius: w * 0.05,
// //               backgroundColor: AppColors.primaryRed,
// //               child: Icon(Icons.check, size: w * 0.05, color: AppColors.white),
// //             )
// //           : CircleAvatar(
// //               radius: w * 0.05,
// //               backgroundColor: AppColors.lightGray,
// //               child: CircleAvatar(
// //                 radius: w * 0.025,
// //                 backgroundColor: AppColors.white,
// //               ),
// //             ),
// //       customTitle: AppFonts.textPoppins(
// //         context,
// //         title,
// //         w * 0.03,
// //         FontWeight.w400,
// //         AppColors.mediumGray,
// //         TextAlign.center,
// //         TextOverflow.ellipsis,
// //       ),
// //     );
// //   }
// // }


// import 'package:corezap_driver/controller/stepper_controller.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/location_input_textfield.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/scheduled_pickups/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class ArrivingClient extends StatefulWidget {
//   const ArrivingClient({super.key});

//   @override
//   State<ArrivingClient> createState() => _ArrivingClientState();
// }

// class _ArrivingClientState extends State<ArrivingClient> {
//   final StepperController stepperController = Get.find<StepperController>();
//   late GoogleMapController mapController;

//   final CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(23.2599, 77.4126),
//     zoom: 14,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: ColorsList.scaffoldColor,
//       appBar: _buildAppBar(w),
//       body: Column(
//         children: [
//           _buildLocationInputs(w),
//           _buildMapSection(w),
//           Expanded(child: _buildBottomSheet(w)),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(double w) {
//     return AppBar(
//       backgroundColor: ColorsList.scaffoldColor,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       titleSpacing: w * .03,
//       title: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: CustomImages.images(
//               "assets/icons/arrowLeftIcon.png",
//               w * .07,
//               w * .07,
//             ),
//           ),
//           SizedBox(width: w * .03),
//           CustomText(
//             text: "Arriving Client",
//             textColor: ColorsList.titleTextColor,
//             textFontSize: w * .055,
//             textFontWeight: FontWeight.w500,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationInputs(double w) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: w * .03),
//       child: Column(
//         children: [
//           SizedBox(height: w * .02),
//           LocationInputTextfield(
//             onPressed: () {},
//             preffixImage: "assets/icons/greenDot.png",
//             hintText: "Your Current Location",
//           ),
//           SizedBox(height: w * .02),
//           LocationInputTextfield(
//             onPressed: () {},
//             preffixImage: "assets/icons/redDot.png",
//             hintText: "Drop location",
//           ),
//           SizedBox(height: w * .02),
//         ],
//       ),
//     );
//   }

//   Widget _buildMapSection(double w) {
//     return SizedBox(
//       height: w * .6,
//       child: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: _initialPosition,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             onMapCreated: (controller) => mapController = controller,
//           ),
//           Obx(() {
//             final step = stepperController.activeStep.value;
//             if (step == 0) return const SizedBox();

//             return Positioned(
//               bottom: w * .03,
//               left: (w - (w * .6)) / 2,
//               child: Container(
//                 width: w * .6,
//                 height: w * .1,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: ColorsList.iconGreyColor,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: CustomText(
//                   text: step == 1
//                       ? "5 min to reach client"
//                       : step == 2
//                           ? "You reached the client"
//                           : "Trip ending soon",
//                   textColor: ColorsList.mainButtonTextColor,
//                   textFontSize: w * .032,
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomSheet(double w) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       padding: EdgeInsets.all(w * .04),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("7 min", style: const TextStyle(fontWeight: FontWeight.w600)),
//           const Text("to pickup location", style: TextStyle(color: Colors.black54)),
//           SizedBox(height: w * .04),
//           _buildClientCard(w),
//           const Spacer(),
//           _buildActionButtons(w),
//         ],
//       ),
//     );
//   }

//   Widget _buildClientCard(double w) {
//     return Container(
//       padding: EdgeInsets.all(w * .04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: w * .055,
//                 backgroundColor: Colors.grey.shade300,
//                 child: Icon(Icons.person, size: w * .07, color: Colors.grey.shade700),
//               ),
//               SizedBox(width: w * .03),
//               Expanded(
//                 child: CustomText(
//                   text: "Amaan Shaikh",
//                   textFontSize: w * .046,
//                   textFontWeight: FontWeight.w500,
//                 ),
//               ),
//               _circleIcon(Icons.call, () {}),
//               SizedBox(width: w * .02),
//               _circleImage("assets/images/mess.png", () {
//                 CustomNavigator.push(context, ChatScreen());
//               }),
//             ],
//           ),
//           SizedBox(height: w * .03),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               "Total Fare: ₹100",
//               style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
//             ),
//           ),
//           SizedBox(height: w * .03),
//           _buildPickupAddress(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPickupAddress() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Row(
//           children: [
//             CircleAvatar(radius: 6, backgroundColor: Color(0xFF08875D)),
//             SizedBox(width: 8),
//             Text("Pickup", style: TextStyle(fontWeight: FontWeight.w600)),
//           ],
//         ),
//         SizedBox(height: 4),
//         Text(
//           "Bus Stand, Majestic, Bengaluru, Karnataka 560009",
//           style: TextStyle(color: Colors.black54),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(double w) {
//     return Row(
//       children: [
//         Expanded(
//           child: _actionButton(
//             text: "Cancel",
//             color: const Color(0xFFE0E4E7),
//             textColor: Colors.grey,
//             onTap: () {},
//           ),
//         ),
//         SizedBox(width: w * .04),
//         Expanded(
//           child: _actionButton(
//             text: "I’ve Arrived",
//             color: const Color(0xFF26E3DD),
//             textColor: Colors.black87,
//             onTap: () {},
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _actionButton({
//     required String text,
//     required Color color,
//     required Color textColor,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       height: 52,
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           elevation: 0,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//         ),
//         child: Text(text, style: TextStyle(color: textColor)),
//       ),
//     );
//   }

//   Widget _circleIcon(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: 18,
//         backgroundColor: ColorsList.mainButtonLightColor,
//         child: Icon(icon, size: 18, color: ColorsList.mainAppColor),
//       ),
//     );
//   }

//   Widget _circleImage(String path, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: 18,
//         backgroundColor: ColorsList.mainButtonLightColor,
//         child: Image.asset(path, width: 18),
//       ),
//     );
//   }
// }
