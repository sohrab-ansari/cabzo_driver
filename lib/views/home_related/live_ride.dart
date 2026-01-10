// // // import 'package:corezap_driver/controller/controllers.dart';
// // // import 'package:corezap_driver/controller/stepper_controller.dart';
// // // import 'package:corezap_driver/utilities/app_buttons.dart';
// // // import 'package:corezap_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
// // // import 'package:corezap_driver/utilities/colors.dart';
// // // import 'package:corezap_driver/utilities/colors/colors_list.dart';
// // // import 'package:corezap_driver/utilities/custom_appbar.dart';
// // // import 'package:corezap_driver/utilities/custom_font.dart';
// // // import 'package:corezap_driver/utilities/custom_images.dart';
// // // import 'package:corezap_driver/utilities/navigator.dart';
// // // import 'package:corezap_driver/views/home_related/circular_timer.dart';
// // // import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
// // // import 'package:dotted_line/dotted_line.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/widgets.dart';
// // // import 'package:flutter_animate/flutter_animate.dart';
// // // import 'package:get/instance_manager.dart';
// // // import 'package:get/route_manager.dart';
// // // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // // class LiveRide extends StatefulWidget {
// // //   const LiveRide({super.key});

// // //   @override
// // //   State<LiveRide> createState() => _LiveRideState();
// // // }

// // // class _LiveRideState extends State<LiveRide> {
// // //   StepperController stepperController = Get.find<StepperController>();
// // //   Controllers cancelRideController = Get.find<Controllers>();
// // //   // pickup drop time
// // //   // List detailsAbout = ["Pick up", "Drop", "Time"];
// // //    List detailsAbout = ["Pick up", "Drhghop", ];
// // //   List details = ["1.1 Km", "4 km",];
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       cancelRideController.cancelRideReasonIndex.value = -1;
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double w = MediaQuery.of(context).size.width;

// // //     return Scaffold(
// // //       backgroundColor: AppColors.white,
// // //       body: SafeArea(
// // //         child: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .04),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [

// // //               SizedBox(height: w * .05),
// // //                AppFonts.textPoppins(
// // //                             context,
// // //                             "30, August, 2025",
// // //                             w * 0.03,
// // //                             FontWeight.w500,
// // //                             AppColors.black,
// // //                             TextAlign.center,
// // //                             TextOverflow.visible,
// // //                           ),
// // //               Container(
// // //                     width: w,
// // //                     height: w * 0.40,
// // //                     decoration: BoxDecoration(
// // //                       color: AppColors.white,
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.grey.withOpacity(0.2),
// // //                           spreadRadius: 2,
// // //                           blurRadius: 3,
// // //                           // changes position of shadow
// // //                         ),
// // //                       ],
// // //                       borderRadius: BorderRadius.circular(w * 0.03),
// // //                     ),
// // //                     child: Padding(
// // //                       padding: EdgeInsets.only(left: w * 0.04),
// // //                       child: Column(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         crossAxisAlignment: CrossAxisAlignment.center,
// // //                         children: [

// // //                           Row(
// // //                             mainAxisAlignment: MainAxisAlignment.center,
// // //                             children: [

// // //                               Row(
// // //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                                 children: [
// // //                                   Image.asset("assets/images/profil.png",height: 20,width: 30,),
// // //                                   Text("Rohan")
// // //                                 ],
// // //                               ),
// // //                               Icon(
// // //                                 Icons.currency_rupee,
// // //                                 color: AppColors.green,
// // //                                 size: w * .063,
// // //                                 fontWeight: FontWeight.bold,
// // //                               ),
// // //                               AppFonts.textPoppins(
// // //                                 context,
// // //                                 "100.0",
// // //                                 w * 0.08,
// // //                                 FontWeight.bold,
// // //                                 AppColors.green,
// // //                                 TextAlign.center,
// // //                                 TextOverflow.visible,
// // //                               ),
// // //                             ],
// // //                           ),

// // //                         ],
// // //                       ),
// // //                     ),
// // //                   )
// // //                   .animate()
// // //                   .fade(duration: 820.ms, curve: Curves.easeInOut)
// // //                   .scale(
// // //                     begin: const Offset(0.95, 0.95),
// // //                     end: const Offset(1, 1),
// // //                   ),

// // //              GoogleMap(initialCameraPosition: initialCameraPosition),
// // //               AppFonts.textPoppins(
// // //                 context,
// // //                 "Location",
// // //                 w * 0.035,
// // //                 FontWeight.w500,
// // //                 AppColors.black,
// // //                 TextAlign.left,
// // //                 TextOverflow.visible,
// // //               ),
// // //               Padding(
// // //                 padding: EdgeInsets.symmetric(vertical: w * .03),
// // //                 child: Row(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Column(
// // //                       children: [
// // //                         CustomImages.images(
// // //                           "assets/icons/greenDot.png",
// // //                           w * .05,
// // //                           w * .05,
// // //                         ),
// // //                         SizedBox(
// // //                           height: w * .1,
// // //                           child: DottedLine(
// // //                             direction: Axis.vertical,
// // //                             lineLength: double.infinity,
// // //                             dashLength: 4,
// // //                             dashColor: AppColors.green,
// // //                           ),
// // //                         ),
// // //                         CustomImages.images(
// // //                           "assets/icons/redDot.png",
// // //                           w * .05,
// // //                           w * .05,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     SizedBox(width: w * .01),
// // //                     Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         AppFonts.textPoppins(
// // //                           context,
// // //                           "Pickup",
// // //                           w * 0.035,
// // //                           FontWeight.w500,
// // //                           AppColors.mediumGray,
// // //                           TextAlign.left,
// // //                           TextOverflow.visible,
// // //                         ),
// // //                         SizedBox(
// // //                           width: w * .85,
// // //                           // color: Colors.amber,
// // //                           child: AppFonts.textPoppins(
// // //                             context,
// // //                             "C95F+J2M, Manikonda Jagir, Hyderabad, Telangana 500089",
// // //                             w * 0.039,
// // //                             FontWeight.w500,
// // //                             AppColors.black,
// // //                             TextAlign.left,
// // //                             TextOverflow.ellipsis,
// // //                           ),
// // //                         ),
// // //                         SizedBox(height: w * .048),
// // //                         AppFonts.textPoppins(
// // //                           context,
// // //                           "Drop",
// // //                           w * 0.035,
// // //                           FontWeight.w500,
// // //                           AppColors.mediumGray,
// // //                           TextAlign.left,
// // //                           TextOverflow.visible,
// // //                         ),
// // //                         SizedBox(
// // //                           width: w * .85,
// // //                           //  color: Colors.amber,
// // //                           child: AppFonts.textPoppins(
// // //                             context,
// // //                             "C95F+J2M, Manikonda Jagir, Hyderabad, Telangana 500089",
// // //                             w * 0.039,
// // //                             FontWeight.w500,
// // //                             AppColors.black,
// // //                             TextAlign.left,
// // //                             TextOverflow.ellipsis,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),

// // //                Padding(
// // //                 padding: EdgeInsets.symmetric(vertical: w * .04),
// // //                 child:
// // //                     Container(
// // //                           width: w,
// // //                           height: w * 0.28,
// // //                           decoration: BoxDecoration(
// // //                             color: AppColors.white,
// // //                             boxShadow: [
// // //                               BoxShadow(
// // //                                 color: Colors.grey.withOpacity(0.2),
// // //                                 spreadRadius: 2,
// // //                                 blurRadius: 3,
// // //                                 // changes position of shadow
// // //                               ),
// // //                             ],
// // //                             borderRadius: BorderRadius.circular(w * 0.03),
// // //                           ),
// // //                           child: Padding(
// // //                             padding: EdgeInsets.symmetric(
// // //                               horizontal: w * .04,
// // //                               vertical: w * .04,
// // //                             ),
// // //                             child: Row(
// // //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                               children: List.generate(2, (index) {
// // //                                 return Row(
// // //                                   children: [
// // //                                     Container(
// // //                                       width: w * .25,
// // //                                       color: AppColors.white,
// // //                                       child: Column(
// // //                                         mainAxisAlignment:
// // //                                             MainAxisAlignment.center,
// // //                                         crossAxisAlignment:
// // //                                             CrossAxisAlignment.center,
// // //                                         children: [
// // //                                           AppFonts.textPoppins(
// // //                                             context,
// // //                                             detailsAbout[index],
// // //                                             w * 0.035,
// // //                                             FontWeight.w600,
// // //                                             AppColors.mediumGray,
// // //                                             TextAlign.center,
// // //                                             TextOverflow.visible,
// // //                                           ),

// // //                                           AppFonts.textPoppins(
// // //                                             context,
// // //                                             details[index],
// // //                                             w * 0.035,
// // //                                             FontWeight.bold,
// // //                                             AppColors.black,
// // //                                             TextAlign.center,
// // //                                             TextOverflow.visible,
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     ),

// // //                                     index < 2
// // //                                         ? VerticalDivider(
// // //                                             color: AppColors.mediumGray,
// // //                                             thickness: 1,
// // //                                             // width: w * .1,
// // //                                           )
// // //                                         : SizedBox(),
// // //                                   ],
// // //                                 );
// // //                               }),
// // //                             ),
// // //                           ),
// // //                         )
// // //                         .animate()
// // //                         .fade(duration: 820.ms, curve: Curves.easeInOut)
// // //                         .scale(
// // //                           begin: const Offset(0.95, 0.95),
// // //                           end: const Offset(1, 1),
// // //                         ),
// // //               ),

// // //               //? timer for except ride
// // //               // Center(child: CircularTimer(size: w * .5)),
// // //               Padding(
// // //                 padding: EdgeInsets.symmetric(vertical: w * .05),
// // //                 child: Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                   children: [
// // //                     AppButtons.outlined(
// // //                       width: w * .43,
// // //                       context: context,
// // //                       text: "Cancel",
// // //                       onClicked: () {
// // //                         CustomBottomSheets().cancelRide(context);
// // //                         // CustomNavigator.push(
// // //                         //   context,
// // //                         //   LiveRide(),
// // //                         //   transition: TransitionType.fade,
// // //                         // );
// // //                       },
// // //                       isFullWidth: false,
// // //                       backgroundColor: AppColors.lightGray,
// // //                       textColor: AppColors.mediumGray,
// // //                       borderColor: Colors.transparent,
// // //                       fontSize: w * .045,
// // //                       height: w * .140,
// // //                       radius: 10,
// // //                     ),
// // //                     AppButtons.outlined(
// // //                       width: w * .43,
// // //                       context: context,
// // //                       text: "Accept",
// // //                       onClicked: () {
// // //                         stepperController.resetSteps();
// // //                         // stepperController.activeStep.value = 1;
// // //                         CustomNavigator.push(
// // //                           context,

// // //                           ArrivingClient(),
// // //                           transition: TransitionType.slideLeft,
// // //                         );
// // //                       },
// // //                       isFullWidth: false,
// // //                       backgroundColor: ColorsList.mainButtonColor,
// // //                       textColor: ColorsList.mainButtonTextColor,
// // //                       fontSize: w * .045,
// // //                       height: w * .140,
// // //                       radius: 10.0,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:corezap_driver/controller/controllers.dart';
// // import 'package:corezap_driver/controller/stepper_controller.dart';
// // import 'package:corezap_driver/utilities/app_buttons.dart';
// // import 'package:corezap_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
// // import 'package:corezap_driver/utilities/colors.dart';
// // import 'package:corezap_driver/utilities/colors/colors_list.dart';
// // import 'package:corezap_driver/utilities/custom_font.dart';
// // import 'package:corezap_driver/utilities/custom_images.dart';
// // import 'package:corezap_driver/utilities/navigator.dart';
// // import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
// // import 'package:dotted_line/dotted_line.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // /// ─────────────────────────────────────────────────────────
// // /// INITIAL CAMERA POSITION (FIXED ERROR)
// // /// ─────────────────────────────────────────────────────────
// // const CameraPosition initialCameraPosition = CameraPosition(
// //   target: LatLng(17.4065, 78.4772), // Hyderabad
// //   zoom: 14.5,
// // );

// // class LiveRide extends StatefulWidget {
// //   const LiveRide({super.key});

// //   @override
// //   State<LiveRide> createState() => _LiveRideState();
// // }

// // class _LiveRideState extends State<LiveRide> {
// //   final StepperController stepperController = Get.find();
// //   final Controllers cancelRideController = Get.find();

// //   final List<String> detailsTitle = ["Pickup", "Drop"];
// //   final List<String> detailsValue = ["1.1 Km", "4 Km"];

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       cancelRideController.cancelRideReasonIndex.value = -1;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final double w = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.all(w * 0.04),
// //           child: Column(
// //             // crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _dateText(context, w),
// //               SizedBox(height: w * 0.04),

// //               SizedBox(height: w * 0.04),

// //               Stack(children :[
// // _mapView(w),

// //                  _fareCard(context, w),
// //               ] ),
// //               SizedBox(height: w * 0.04),

// //               _locationInfo(context, w),
// //               SizedBox(height: w * 0.04),

// //               _distanceCard(context, w),
// //               SizedBox(height: w * 0.06),

// //               _actionButtons(context, w),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   //──────────────── DATE ────────────────
// //   Widget _dateText(BuildContext context, double w) {
// //     return AppFonts.textPoppins(
// //       context,
// //       "30 August, 2025",
// //       w * 0.04,
// //       FontWeight.w500,
// //       AppColors.black,
// //       TextAlign.center,
// //       TextOverflow.visible,
// //     );
// //   }

// //   //──────────────── FARE CARD ────────────────
// //   // Widget _fareCard(BuildContext context, double w) {
// //   //   return Container(
// //   //     height: w * 0.2,
// //   //     decoration: _cardDecoration(w),
// //   //     child: Center(
// //   //       child: Row(
// //   //         mainAxisAlignment: MainAxisAlignment.start,
// //   //         children: [
// //   //           SizedBox(width: 5,),
// //   //           Image.asset("assets/images/profil.png", height:  w * 0.12),
// //   //           SizedBox(width: w * 0.05),
// //   //           AppFonts.textPoppins(
// //   //             context,
// //   //             "Rohan",
// //   //             w * 0.05,
// //   //             FontWeight.w600,
// //   //             AppColors.black,
// //   //             TextAlign.center,
// //   //             TextOverflow.visible,
// //   //           ),
// //   //           SizedBox(width: w * 0.25),
// //   //           Icon(Icons.currency_rupee,
// //   //               color: AppColors.green, size: w * 0.07),
// //   //           AppFonts.textPoppins(
// //   //             context,
// //   //             "100.0",
// //   //             w * 0.06,
// //   //             FontWeight.w500,
// //   //             AppColors.green,
// //   //             TextAlign.center,
// //   //             TextOverflow.visible,
// //   //           ),
// //   //         ],
// //   //       ),
// //   //     ),
// //   //   ).animate().fade(duration: 700.ms).scale();
// //   // }

// // Widget _fareCard(BuildContext context, double w) {
// //   return Container(
// //     padding: EdgeInsets.symmetric(
// //       horizontal: w * 0.04,
// //       vertical: w * 0.03,
// //     ),
// //     decoration: BoxDecoration(
// //       color: Colors.white,
// //       borderRadius: BorderRadius.circular(w * 0.035),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Colors.black.withOpacity(0.08),
// //           blurRadius: 10,
// //           offset: const Offset(0, 4),
// //         ),
// //       ],
// //       border: Border.all(
// //         color: AppColors.mediumGray.withOpacity(0.3),
// //       ),
// //     ),
// //     child: Row(
// //       children: [
// //         /// Profile image
// //         Container(
// //           padding: EdgeInsets.all(w * 0.01),
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             // border: Border.all(
// //             //   // color: AppColors.primary.withOpacity(0.3),
// //             //   width: 1.5,
// //             // ),
// //           ),
// //           child: Image.asset(
// //             "assets/images/profil.png",
// //             height: w * 0.12,
// //             width: w * 0.12,
// //             fit: BoxFit.cover,
// //           ),
// //         ),

// //         SizedBox(width: w * 0.04),

// //         /// Name
// //         Expanded(
// //           child: AppFonts.textPoppins(
// //             context,
// //             "Rohan",
// //             w * 0.048,
// //             FontWeight.w600,
// //             AppColors.black,
// //             TextAlign.start,
// //             TextOverflow.ellipsis,
// //           ),
// //         ),

// //         /// Fare
// //         Row(
// //           children: [
// //             Icon(
// //               Icons.currency_rupee,
// //               color: AppColors.green,
// //               size: w * 0.065,
// //             ),
// //             AppFonts.textPoppins(
// //               context,
// //               "100.0",
// //               w * 0.055,
// //               FontWeight.w600,
// //               AppColors.green,
// //               TextAlign.center,
// //               TextOverflow.visible,
// //             ),
// //           ],
// //         ),
// //       ],
// //     ),
// //   ).animate().fade(duration: 700.ms).scale();
// // }

// //   //──────────────── MAP ────────────────
// //   Widget _mapView(double w) {
// //     return SizedBox(
// //       height: w * 0.95,
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(w * 0.03),
// //         child: GoogleMap(
// //           initialCameraPosition: initialCameraPosition,
// //           myLocationEnabled: true,
// //           zoomControlsEnabled: false,
// //         ),
// //       ),
// //     );
// //   }

// //   //──────────────── LOCATION ────────────────
// //   Widget _locationInfo(BuildContext context, double w) {
// //     return Column(
// //       children: [

// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text("Location",style: TextStyle(fontWeight: FontWeight.w500),),
// //             Text("Time  10 min",style: TextStyle(fontWeight: FontWeight.w500))
// //           ],
// //         ),
// //         SizedBox(height: 10,),
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Column(
// //               children: [
// //                 CustomImages.images("assets/icons/greenDot.png", w * 0.05, w * 0.05),
// //                 SizedBox(
// //                   height: w * 0.1,
// //                   child: DottedLine(
// //                     direction: Axis.vertical,
// //                     dashLength: 4,
// //                     dashColor: AppColors.green,
// //                   ),
// //                 ),
// //                 CustomImages.images("assets/icons/redDot.png", w * 0.05, w * 0.05),
// //               ],
// //             ),
// //             SizedBox(width: w * 0.03),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _locationText(
// //                     context,
// //                     "Pickup",
// //                     "Manikonda Jagir, Hyderabad, Telangana",
// //                   ),
// //                   SizedBox(height: w * 0.05),
// //                   _locationText(
// //                     context,
// //                     "Drop",
// //                     "Manikonda Jagir, Hyderabad, Telangana",
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _locationText(
// //       BuildContext context, String title, String address) {
// //     final double w = MediaQuery.of(context).size.width;
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         AppFonts.textPoppins(
// //           context,
// //           title,
// //           w * 0.035,
// //           FontWeight.w500,
// //           AppColors.mediumGray,
// //           TextAlign.left,
// //           TextOverflow.visible,
// //         ),
// //         AppFonts.textPoppins(
// //           context,
// //           address,
// //           w * 0.039,
// //           FontWeight.w500,
// //           AppColors.black,
// //           TextAlign.left,
// //           TextOverflow.ellipsis,
// //         ),
// //       ],
// //     );
// //   }

// //   //──────────────── DISTANCE ────────────────

// //   Widget _distanceCard(BuildContext context, double w) {
// //   return Container(
// //     height: w * 0.20,
// //     width: w * 02,
// //     // padding: EdgeInsets.all(w * 0.02),
// //     // decoration: _cardDecoration(w),
// //     child: Row(
// //       children: List.generate(detailsTitle.length, (index) {
// //         return Expanded(
// //           child: Container(
// //             margin: EdgeInsets.symmetric(horizontal: w * 0.015),
// //             padding: EdgeInsets.symmetric(
// //               vertical: w * 0.03,
// //               horizontal: w * 0.02,
// //             ),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(w * 0.025),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.08),
// //                   blurRadius: 6,
// //                   offset: const Offset(0, 3),
// //                 ),
// //               ],
// //               border: Border.all(
// //                 color: AppColors.mediumGray.withOpacity(0.3),
// //               ),
// //             ),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 AppFonts.textPoppins(
// //                   context,
// //                   detailsTitle[index],
// //                   w * 0.032,
// //                   FontWeight.w600,
// //                   AppColors.mediumGray,
// //                   TextAlign.center,
// //                   TextOverflow.visible,
// //                 ),
// //                 SizedBox(height: w * 0.012),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   detailsValue[index],
// //                   w * 0.042,
// //                   FontWeight.bold,
// //                   AppColors.black,
// //                   TextAlign.center,
// //                   TextOverflow.visible,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       }),
// //     ),
// //   ).animate().fade(duration: 700.ms).scale();
// // }

// //   // Widget _distanceCard(BuildContext context, double w) {
// //   //   return Container(
// //   //     height: w * 0.28,
// //   //     decoration: _cardDecoration(w),
// //   //     child: Row(
// //   //       children: List.generate(detailsTitle.length, (index) {
// //   //         return Expanded(
// //   //           child: Column(
// //   //             mainAxisAlignment: MainAxisAlignment.center,
// //   //             children: [
// //   //               AppFonts.textPoppins(
// //   //                 context,
// //   //                 detailsTitle[index],
// //   //                 w * 0.035,
// //   //                 FontWeight.w600,
// //   //                 AppColors.mediumGray,
// //   //                 TextAlign.center,
// //   //                 TextOverflow.visible,
// //   //               ),
// //   //               SizedBox(height: w * 0.01),
// //   //               AppFonts.textPoppins(
// //   //                 context,
// //   //                 detailsValue[index],
// //   //                 w * 0.04,
// //   //                 FontWeight.bold,
// //   //                 AppColors.black,
// //   //                 TextAlign.center,
// //   //                 TextOverflow.visible,
// //   //               ),
// //   //             ],
// //   //           ),
// //   //         );
// //   //       }),
// //   //     ),
// //   //   ).animate().fade(duration: 700.ms).scale();
// //   // }

// //   //──────────────── BUTTONS ────────────────
// //   Widget _actionButtons(BuildContext context, double w) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         AppButtons.outlined(
// //           width: w * 0.43,
// //           context: context,
// //           text: "Cancel",
// //           onClicked: () => CustomBottomSheets().cancelRide(context),
// //           backgroundColor: AppColors.lightGray,
// //           textColor: AppColors.mediumGray,
// //           height: w * 0.14,
// //           radius: 10,
// //         ),
// //         AppButtons.outlined(
// //           width: w * 0.43,
// //           context: context,
// //           text: "Accept",
// //           onClicked: () {
// //             stepperController.resetSteps();
// //             CustomNavigator.push(
// //               context,
// //               ArrivingClient(),
// //               transition: TransitionType.slideLeft,
// //             );
// //           },
// //           backgroundColor: ColorsList.mainButtonColor,
// //           textColor: ColorsList.mainButtonTextColor,
// //           height: w * 0.14,
// //           radius: 10,
// //         ),
// //       ],
// //     );
// //   }

// //   //──────────────── COMMON CARD STYLE ────────────────
// //   BoxDecoration _cardDecoration(double w) {
// //     return BoxDecoration(
// //       color: AppColors.white,
// //       borderRadius: BorderRadius.circular(w * 0.03),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Colors.black.withOpacity(0.08),
// //           blurRadius: 8,
// //           offset: const Offset(0, 4),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:corezap_driver/controller/controllers.dart';
// import 'package:corezap_driver/controller/stepper_controller.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// /// ─────────────────────────────────────────────────────────
// /// INITIAL CAMERA POSITION
// /// ─────────────────────────────────────────────────────────
// const CameraPosition initialCameraPosition = CameraPosition(
//   target: LatLng(17.4065, 78.4772), // Hyderabad
//   zoom: 14.5,
// );

// class LiveRide extends StatefulWidget {
//   const LiveRide({super.key});

//   @override
//   State<LiveRide> createState() => _LiveRideState();
// }

// class _LiveRideState extends State<LiveRide> {
//   final StepperController stepperController = Get.find();
//   final Controllers cancelRideController = Get.find();

//   final List<String> detailsTitle = ["Pickup", "Drop"];
//   final List<String> detailsValue = ["1.1 Km", "4 Km"];

//   /// 📍 Pickup & Drop Locations
//   final LatLng pickupLatLng = const LatLng(17.4065, 78.4772);
//   final LatLng dropLatLng = const LatLng(17.4120, 78.4850);

//   /// 🟢🔴 Markers
//   Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       cancelRideController.cancelRideReasonIndex.value = -1;
//     });

//     _setMarkers();
//   }

//   void _setMarkers() {
//     _markers = {
//       /// GREEN PICKUP MARKER
//       Marker(
//         markerId: const MarkerId("pickup"),
//         position: pickupLatLng,
//         infoWindow: const InfoWindow(title: "Pickup Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueGreen,
//         ),
//       ),

//       /// RED DROP MARKER
//       Marker(
//         markerId: const MarkerId("drop"),
//         position: dropLatLng,
//         infoWindow: const InfoWindow(title: "Drop Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueRed,
//         ),
//       ),
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(w * 0.04),
//           child: Column(
//             children: [
//               _dateText(context, w),
//               SizedBox(height: w * 0.04),

//               Stack(
//                 children: [
//                   _mapView(w),
//                   Positioned(
//                     top: w * 0.04,
//                     left: w * 0.04,
//                     right: w * 0.04,
//                     child: _fareCard(context, w),
//                   ),
//                 ],
//               ),

//               SizedBox(height: w * 0.04),
//               _locationInfo(context, w),
//               SizedBox(height: w * 0.04),
//               _distanceCard(context, w),
//               SizedBox(height: w * 0.06),
//               _actionButtons(context, w),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //──────────────── DATE ────────────────
//   Widget _dateText(BuildContext context, double w) {
//     return AppFonts.textPoppins(
//       context,
//       "30 August, 2025",
//       w * 0.04,
//       FontWeight.w500,
//       AppColors.black,
//       TextAlign.center,
//       TextOverflow.visible,
//     );
//   }

//   //──────────────── FARE CARD ────────────────
//   Widget _fareCard(BuildContext context, double w) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(w * 0.035),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: AppColors.mediumGray.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             "assets/images/profil.png",
//             height: w * 0.12,
//             width: w * 0.12,
//           ),
//           SizedBox(width: w * 0.04),
//           Expanded(
//             child: AppFonts.textPoppins(
//               context,
//               "Rohan",
//               w * 0.048,
//               FontWeight.w600,
//               AppColors.black,
//               TextAlign.start,
//               TextOverflow.ellipsis,
//             ),
//           ),
//           Icon(Icons.currency_rupee, color: AppColors.green, size: w * 0.065),
//           AppFonts.textPoppins(
//             context,
//             "100.0",
//             w * 0.055,
//             FontWeight.w600,
//             AppColors.green,
//             TextAlign.center,
//             TextOverflow.visible,
//           ),
//         ],
//       ),
//     ).animate().fade(duration: 700.ms).scale();
//   }

//   //──────────────── MAP ────────────────
//   Widget _mapView(double w) {
//     return SizedBox(
//       height: w * 0.95,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(w * 0.03),
//         child: GoogleMap(
//           initialCameraPosition: initialCameraPosition,
//           myLocationEnabled: true,
//           zoomControlsEnabled: false,
//           markers: _markers, // ✅ MARKERS ADDED
//         ),
//       ),
//     );
//   }

//   //──────────────── LOCATION INFO ────────────────
//   Widget _locationInfo(BuildContext context, double w) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text("Location", style: TextStyle(fontWeight: FontWeight.w500)),
//             Text("Time 10 min", style: TextStyle(fontWeight: FontWeight.w500)),
//           ],
//         ),
//         SizedBox(height: 10),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 CustomImages.images("assets/icons/greenDot.png", w * 0.05, w * 0.05),
//                 SizedBox(
//                   height: w * 0.1,
//                   child: DottedLine(
//                     direction: Axis.vertical,
//                     dashLength: 4,
//                     dashColor: AppColors.green,
//                   ),
//                 ),
//                 CustomImages.images("assets/icons/redDot.png", w * 0.05, w * 0.05),
//               ],
//             ),
//             SizedBox(width: w * 0.03),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _locationText(context, "Pickup",
//                       "Manikonda Jagir, Hyderabad, Telangana"),
//                   SizedBox(height: w * 0.05),
//                   _locationText(context, "Drop",
//                       "Manikonda Jagir, Hyderabad, Telangana"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _locationText(BuildContext context, String title, String address) {
//     final double w = MediaQuery.of(context).size.width;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppFonts.textPoppins(
//           context,
//           title,
//           w * 0.035,
//           FontWeight.w500,
//           AppColors.mediumGray,
//           TextAlign.left,
//           TextOverflow.visible,
//         ),
//         AppFonts.textPoppins(
//           context,
//           address,
//           w * 0.039,
//           FontWeight.w500,
//           AppColors.black,
//           TextAlign.left,
//           TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }

//   //──────────────── DISTANCE CARD ────────────────
//   Widget _distanceCard(BuildContext context, double w) {
//     return Container(
//       height: w * 0.20,
//       child: Row(
//         children: List.generate(detailsTitle.length, (index) {
//           return Expanded(
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: w * 0.015),
//               padding: EdgeInsets.symmetric(
//                 vertical: w * 0.03,
//                 horizontal: w * 0.02,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(w * 0.025),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//                 border: Border.all(
//                   color: AppColors.mediumGray.withOpacity(0.3),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   AppFonts.textPoppins(
//                     context,
//                     detailsTitle[index],
//                     w * 0.032,
//                     FontWeight.w600,
//                     AppColors.mediumGray,
//                     TextAlign.center,
//                     TextOverflow.visible,
//                   ),
//                   SizedBox(height: w * 0.012),
//                   AppFonts.textPoppins(
//                     context,
//                     detailsValue[index],
//                     w * 0.042,
//                     FontWeight.bold,
//                     AppColors.black,
//                     TextAlign.center,
//                     TextOverflow.visible,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     ).animate().fade(duration: 700.ms).scale();
//   }

//   //──────────────── BUTTONS ────────────────
//   Widget _actionButtons(BuildContext context, double w) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         AppButtons.outlined(
//           width: w * 0.43,
//           context: context,
//           text: "Cancel",
//           onClicked: () => CustomBottomSheets().cancelRide(context),
//           backgroundColor: AppColors.lightGray,
//           textColor: AppColors.mediumGray,
//           height: w * 0.14,
//           radius: 10,
//         ),
//         AppButtons.outlined(
//           width: w * 0.43,
//           context: context,
//           text: "Accept",
//           onClicked: () {
//             stepperController.resetSteps();
//             CustomNavigator.push(
//               context,
//               ArrivingClient(),
//               transition: TransitionType.slideLeft,
//             );
//           },
//           backgroundColor: ColorsList.mainButtonColor,
//           textColor: ColorsList.mainButtonTextColor,
//           height: w * 0.14,
//           radius: 10,
//         ),
//       ],
//     );
//   }
// }

import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
import 'package:corezap_driver/views/splash/myscreen_arivinfclin%20et.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveRide extends StatefulWidget {
  const LiveRide({super.key});

  @override
  State<LiveRide> createState() => _LiveRideState();
}

class _LiveRideState extends State<LiveRide> {
  final StepperController stepperController = Get.find();
  final Controllers cancelRideController = Get.find();

  final List<String> detailsTitle = ["Pickup", "Drop"];
  final List<String> detailsValue = ["1.1 Km", "4 Km"];

  // Pickup & Drop LatLng
  final LatLng pickupLatLng = const LatLng(17.4065, 78.4772);
  final LatLng dropLatLng = const LatLng(17.4120, 78.4850);

  final Set<Marker> _markers = {};

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cancelRideController.cancelRideReasonIndex.value = -1;
    });

    _setMarkers();
  }

  void _setMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId("pickup"),
        position: pickupLatLng,
        infoWindow: const InfoWindow(title: "Pickup Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId("drop"),
        position: dropLatLng,
        infoWindow: const InfoWindow(title: "Drop Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);
  }

  void _fitMapToMarkers() async {
    if (_mapController == null) return;

    LatLngBounds bounds;
    if (pickupLatLng.latitude > dropLatLng.latitude &&
        pickupLatLng.longitude > dropLatLng.longitude) {
      bounds = LatLngBounds(southwest: dropLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > dropLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng.latitude, dropLatLng.longitude),
        northeast: LatLng(dropLatLng.latitude, pickupLatLng.longitude),
      );
    } else if (pickupLatLng.latitude > dropLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(dropLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, dropLatLng.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: pickupLatLng, northeast: dropLatLng);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    _mapController!.animateCamera(cameraUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            children: [
              _dateText(context, w),
              SizedBox(height: w * 0.04),

              Stack(
                children: [
                  _mapView(w),
                  Positioned(
                    top: w * 0.04,
                    left: w * 0.04,
                    right: w * 0.04,
                    child: _fareCard(context, w),
                  ),
                ],
              ),

              SizedBox(height: w * 0.04),
              _locationInfo(context, w),
              SizedBox(height: w * 0.04),
              _distanceCard(context, w),
              SizedBox(height: w * 0.06),
              _actionButtons(context, w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateText(BuildContext context, double w) {
    return AppFonts.textPoppins(
      context,
      "30 August, 2025",
      w * 0.04,
      FontWeight.w500,
      const Color(0xFF5F6165),
      TextAlign.center,
      TextOverflow.visible,
    );
  }

  Widget _fareCard(BuildContext context, double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.035),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.mediumGray.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profil.png",
            height: w * 0.12,
            width: w * 0.12,
          ),
          SizedBox(width: w * 0.04),
          Expanded(
            child: AppFonts.textPoppins(
              context,
              "Rohan",
              w * 0.048,
              FontWeight.w600,
              AppColors.black,
              TextAlign.start,
              TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.currency_rupee, color: AppColors.green, size: w * 0.065),
          AppFonts.textPoppins(
            context,
            "100.0",
            w * 0.055,
            FontWeight.w600,
            AppColors.green,
            TextAlign.center,
            TextOverflow.visible,
          ),
        ],
      ),
    ).animate().fade(duration: 700.ms).scale();
  }

  Widget _mapView(double w) {
    return SizedBox(
      height: w * 0.95,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(w * 0.03),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: pickupLatLng,
            zoom: 14.5,
          ),
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            _fitMapToMarkers(); // fit camera to both markers
          },
        ),
      ),
    );
  }

  Widget _locationInfo(BuildContext context, double w) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Location",
              style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w500),
            ),
            // Text("Time 10 min", style: TextStyle(fontWeight: FontWeight.w500)),
            Text.rich(
              TextSpan(
                text: "Time ",
                style: TextStyle(
                  fontSize: w * 0.029,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7C7C8D),
                ),
                children: [
                  TextSpan(
                    text: "10 min",
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CustomImages.images(
                  "assets/icons/greenDot.png",
                  w * 0.05,
                  w * 0.05,
                ),
                SizedBox(
                  height: w * 0.1,
                  child: DottedLine(
                    direction: Axis.vertical,
                    dashLength: 4,
                    dashColor: AppColors.green,
                  ),
                ),
                CustomImages.images(
                  "assets/icons/redDot.png",
                  w * 0.05,
                  w * 0.05,
                ),
              ],
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locationText(
                    context,
                    "Pickup",
                    "Manikonda Jagir, Hyderabad, Telangana",
                  ),
                  SizedBox(height: w * 0.05),
                  _locationText(
                    context,
                    "Drop",
                    "Manikonda Jagir, Hyderabad, Telangana",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locationText(BuildContext context, String title, String address) {
    final double w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFonts.textPoppins(
          context,
          title,
          w * 0.035,
          FontWeight.w500,
          AppColors.mediumGray,
          TextAlign.left,
          TextOverflow.visible,
        ),
        AppFonts.textPoppins(
          context,
          address,
          w * 0.039,
          FontWeight.w500,
          AppColors.black,
          TextAlign.left,
          TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _distanceCard(BuildContext context, double w) {
    return SizedBox(
      height: w * 0.20,
      child: Row(
        children: List.generate(detailsTitle.length, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.015),
              padding: EdgeInsets.symmetric(
                vertical: w * 0.03,
                horizontal: w * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.025),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: AppColors.mediumGray.withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppFonts.textPoppins(
                    context,
                    detailsTitle[index],
                    w * 0.037,
                    FontWeight.w600,
                    AppColors.mediumGray,
                    TextAlign.center,
                    TextOverflow.visible,
                  ),
                  SizedBox(height: w * 0.012),
                  AppFonts.textPoppins(
                    context,
                    detailsValue[index],
                    w * 0.042,
                    FontWeight.bold,
                    AppColors.black,
                    TextAlign.center,
                    TextOverflow.visible,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ).animate().fade(duration: 700.ms).scale();
  }

  Widget _actionButtons(BuildContext context, double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButtons.outlined(
          width: w * 0.43,
          context: context,
          text: "Cancel",
          onClicked: () => CustomBottomSheets().cancelRide(context),
          backgroundColor: AppColors.lightGray,
          textColor: AppColors.mediumGray,
          height: w * 0.14,
          radius: 10,
        ),
        AppButtons.outlined(
          width: w * 0.43,
          context: context,
          text: "Accept",
          onClicked: () {
            stepperController.resetSteps();
            CustomNavigator.push(
              context,
              ArrivingClient(),
              transition: TransitionType.slideLeft,
            );
          },
          backgroundColor: ColorsList.mainButtonColor,
          textColor: ColorsList.mainButtonTextColor,
          height: w * 0.14,
          radius: 10,
        ),
      ],
    );
  }
}
