// import 'package:corezap_driver/controller/controllers.dart';
// import 'package:corezap_driver/controller/ridescontroller/rieds_history_controller.dart';
// import 'package:corezap_driver/controller/ridescontroller/rieds_history_controller2.dart';
// import 'package:corezap_driver/modals/ride_history_response.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:get/instance_manager.dart';

// class RidehistoryScreen extends StatefulWidget {
//   const RidehistoryScreen({super.key});

//   @override
//   State<RidehistoryScreen> createState() => _RidehistoryScreenState();
// }

// class _RidehistoryScreenState extends State<RidehistoryScreen>
//     with TickerProviderStateMixin {
//   final RiedsHistoryController2 riedsHistoryController = Get.put(
//     RiedsHistoryController2(),
//   );

//   Controllers currentTabBar = Get.find<Controllers>();

//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);

//     _tabController.addListener(() {
//       currentTabBar.currentTabIndex.value = _tabController.index;
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       //appbar
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         elevation: 0,
//         leadingWidth: w * 0.010,
//         // centerTitle: true,
//         leading: SizedBox(),
//         title:
//             AppFonts.textPoppins(
//                   context,
//                   "Ride History",
//                   w * 0.05,
//                   FontWeight.w600,
//                   AppColors.black,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                   maxLines: 1,
//                 )
//                 .animate()
//                 .fade(duration: 800.ms, curve: Curves.easeInOut)
//                 .scale(
//                   begin: const Offset(0.95, 0.95),
//                   end: const Offset(1, 1),
//                 ),
//       ),
//       body: Column(
//         children: [
//           //tab bar
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * .04,
//               vertical: w * .03,
//             ),
//             child:
//                 Container(
//                       height: w * .11,
//                       width: w,
//                       decoration: BoxDecoration(
//                         color: AppColors.lightGray.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(w * .035),
//                         border: Border.all(
//                           color: AppColors.black.withOpacity(0.4),
//                           width: w * .002,
//                         ),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: w * .005,
//                           vertical: w * .005,
//                         ),
//                         child: TabBar(
//                           controller: _tabController,
//                           indicator: BoxDecoration(
//                             color: AppColors.primaryRed,
//                             borderRadius: BorderRadius.circular(w * .03),
//                           ),
//                           indicatorColor: AppColors.darkGray,
//                           labelColor: AppColors.white,
//                           indicatorSize: TabBarIndicatorSize.tab,
//                           dividerHeight: 0.0,
//                           unselectedLabelColor: AppColors.darkGray.withOpacity(
//                             0.4,
//                           ),
//                           labelStyle: TextStyle(
//                             fontSize: w * .034,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           tabs: [
//                             Tab(text: "New trip"),
//                             Tab(text: "Completed"),
//                             Tab(text: "Cancelled"),
//                           ],
//                         ),
//                       ),
//                     )
//                     .animate()
//                     .fade(duration: 820.ms, curve: Curves.easeInOut)
//                     .scale(
//                       begin: const Offset(0.95, 0.95),
//                       end: const Offset(1, 1),
//                     ),
//           ),

//           //divider
//           Divider(
//             color: AppColors.mediumGray.withOpacity(0.4),
//             thickness: w * .002,
//           ),

//           //tab bar view
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // New trip tab content
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.04,
//                     vertical: w * 0.02,
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                         SizedBox(height: w * 0.06),
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                         SizedBox(height: w * 0.06),
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Completed tab content
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.04,
//                     vertical: w * 0.02,
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                         SizedBox(height: w * 0.06),
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                         SizedBox(height: w * 0.06),
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Cancelled tab content
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.04,
//                     vertical: w * 0.02,
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                         SizedBox(height: w * 0.06),
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                         SizedBox(height: w * 0.06),
//                         commonWidget(w)
//                             .animate()
//                             .fade(duration: 400.ms, curve: Curves.easeInOut)
//                             .scale(
//                               begin: const Offset(0.95, 0.95),
//                               end: const Offset(1, 1),
//                             ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   //commmon Widget
//   Widget commonWidget(double w) {
//     return Container(
//       width: w,
//       decoration: BoxDecoration(
//         color: AppColors.lightGray.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(w * .035),
//         border: Border.all(
//           color: AppColors.black.withOpacity(0.1),
//           width: w * .002,
//         ),
//       ),

//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Obx(() {
//                   return Column(
//                     children: [
//                       // Text("hiii  ${currentTabBar.currentTabIndex.value}"),
//                       Row(
//                         children: [
//                           if (currentTabBar.currentTabIndex.value == 0) ...[
//                             AppFonts.textPoppins(
//                               context,
//                               "New trip",
//                               w * 0.035,
//                               FontWeight.w600,
//                               AppColors.TextBuleColor,
//                               TextAlign.center,
//                               TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),

//                             AppFonts.textPoppins(
//                               context,
//                               " : ",
//                               w * 0.030,
//                               FontWeight.w600,
//                               AppColors.TextBuleColor,
//                               TextAlign.center,
//                               TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),

//                             AppFonts.textPoppins(
//                               context,
//                               "11:30 AM",
//                               w * 0.035,
//                               FontWeight.w600,
//                               AppColors.TextBuleColor,
//                               TextAlign.center,
//                               TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ] else if (currentTabBar.currentTabIndex.value ==
//                               1) ...[
//                             AppFonts.textPoppins(
//                               context,
//                               "Completed",
//                               w * 0.035,
//                               FontWeight.w600,
//                               AppColors.TextBuleColor,
//                               TextAlign.center,
//                               TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ] else ...[
//                             AppFonts.textPoppins(
//                               context,
//                               "Cancelled",
//                               w * 0.035,
//                               FontWeight.w600,
//                               Color(0xFFE02D3C),
//                               TextAlign.center,
//                               TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   );
//                 }),

//                 AppFonts.textPoppins(
//                   context,
//                   "₹105.99",
//                   w * 0.042,
//                   FontWeight.w600,
//                   AppColors.black,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               ],
//             ),

//             Obx(() {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (currentTabBar.currentTabIndex.value == 2) ...[
//                     AppFonts.textPoppins(
//                       context,
//                       "Booked by mistake",
//                       w * 0.032,
//                       FontWeight.w600,
//                       AppColors.black.withOpacity(0.5),
//                       TextAlign.center,
//                       TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ] else ...[
//                     AppFonts.textPoppins(
//                       context,
//                       "Neha Gupta",
//                       w * 0.032,
//                       FontWeight.w600,
//                       AppColors.black.withOpacity(0.5),
//                       TextAlign.center,
//                       TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ],

//                   //text1

//                   // Booked by mistake
//                   Row(
//                     children: [
//                       if (currentTabBar.currentTabIndex.value == 2) ...[
//                         AppFonts.textPoppins(
//                           context,
//                           "Neha Gupta",
//                           w * 0.032,
//                           FontWeight.w600,
//                           AppColors.black.withOpacity(0.5),
//                           TextAlign.center,
//                           TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ] else ...[
//                         Image.asset(
//                           "assets/images/moneyss.png",
//                           height: w * 0.05,
//                           width: w * 0.05,
//                         ),
//                         //text2
//                         AppFonts.textPoppins(
//                           context,
//                           " Cash",
//                           w * 0.035,
//                           FontWeight.w600,
//                           Color(0xFf4CAF50),
//                           TextAlign.center,
//                           TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               );
//             }),

//             SizedBox(height: w * 0.02),

//             Divider(
//               color: AppColors.mediumGray.withOpacity(0.4),
//               thickness: w * .002,
//               height: w * 0.1,
//             ),

//             Row(
//               children: [
//                 Image.asset(
//                   "assets/images/bike_image.png",
//                   height: 30,
//                   width: 30,
//                 ),
//                 SizedBox(width: w * 0.02),

//                 // Text("Bike"),
//                 AppFonts.textPoppins(
//                   context,
//                   "Bike",
//                   w * 0.035,
//                   FontWeight.w600,
//                   AppColors.black,
//                   TextAlign.center,
//                   TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               ],
//             ),

//             SizedBox(height: w * 0.06),

//             // row 3
//             Row(
//               children: [
//                 Column(
//                   children: [
//                     Image.asset(
//                       "assets/icons/greenDot.png",
//                       height: w * 0.06,
//                       width: w * 0.06,
//                     ),
//                     //vertical dotted line
//                     Container(
//                       width: w * 0.002,
//                       height: w * 0.10,
//                       // color: AppColors.mediumGray,
//                     ),
//                     Image.asset(
//                       "assets/icons/redDot.png",
//                       height: w * 0.06,
//                       width: w * 0.06,
//                     ),
//                   ],
//                 ),

//                 SizedBox(width: w * 0.04),

//                 SizedBox(
//                   width: w * 0.70,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //text1
//                       AppFonts.textPoppins(
//                         context,
//                         "Pickup",
//                         w * 0.032,
//                         FontWeight.w600,
//                         AppColors.green,
//                         TextAlign.start,
//                         TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),

//                       SizedBox(height: w * 0.02),

//                       ///text2
//                       AppFonts.textPoppins(
//                         context,
//                         "Bus Sta Upas, Majestic, Bengaluru, Karnataka 560009",
//                         w * 0.032,
//                         FontWeight.w600,
//                         AppColors.black,
//                         TextAlign.start,
//                         TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),

//                       SizedBox(height: w * 0.06),

//                       //text3
//                       AppFonts.textPoppins(
//                         context,
//                         "Destination",
//                         w * 0.032,
//                         FontWeight.w600,
//                         AppColors.primaryRed,
//                         TextAlign.start,
//                         TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),

//                       SizedBox(height: w * 0.02),

//                       ///text4
//                       AppFonts.textPoppins(
//                         context,
//                         "Bus Sta Upas, Majestic, Bengaluru, Karnataka 560009",
//                         w * 0.032,
//                         FontWeight.w600,
//                         AppColors.black,
//                         TextAlign.start,
//                         TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // // class RidehistoryScreen extends StatefulWidget {
// // //   const RidehistoryScreen({super.key});

// // //   @override
// // //   State<RidehistoryScreen> createState() => _RidehistoryScreenState();
// // // }

// // // class _RidehistoryScreenState extends State<RidehistoryScreen>
// // //     with TickerProviderStateMixin {
// // //   final RiedsHistoryController riedsHistoryController = Get.put(
// // //     RiedsHistoryController(),
// // //   );

// // //   Controllers currentTabBar = Get.find<Controllers>();

// // //   late TabController _tabController;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 3, vsync: this);

// // //     _tabController.addListener(() {
// // //       currentTabBar.currentTabIndex.value = _tabController.index;
// // //     });
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _tabController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double w = MediaQuery.of(context).size.width;
// // //     return Scaffold(
// // //       backgroundColor: AppColors.white,
// // //       appBar: AppBar(
// // //         backgroundColor: AppColors.white,
// // //         elevation: 0,
// // //         leadingWidth: w * 0.010,
// // //         leading: const SizedBox(),
// // //         title: AppFonts.textPoppins(
// // //               context,
// // //               "Ride History",
// // //               w * 0.05,
// // //               FontWeight.w600,
// // //               AppColors.black,
// // //               TextAlign.center,
// // //               TextOverflow.ellipsis,
// // //               maxLines: 1,
// // //             )
// // //             .animate()
// // //             .fade(duration: 800.ms, curve: Curves.easeInOut)
// // //             .scale(
// // //               begin: const Offset(0.95, 0.95),
// // //               end: const Offset(1, 1),
// // //             ),
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // Tab bar
// // //           Padding(
// // //             padding: EdgeInsets.symmetric(
// // //               horizontal: w * .04,
// // //               vertical: w * .03,
// // //             ),
// // //             child: Container(
// // //                   height: w * .11,
// // //                   width: w,
// // //                   decoration: BoxDecoration(
// // //                     color: AppColors.lightGray.withOpacity(0.3),
// // //                     borderRadius: BorderRadius.circular(w * .035),
// // //                     border: Border.all(
// // //                       color: AppColors.black.withOpacity(0.4),
// // //                       width: w * .002,
// // //                     ),
// // //                   ),
// // //                   child: Padding(
// // //                     padding: EdgeInsets.symmetric(
// // //                       horizontal: w * .005,
// // //                       vertical: w * .005,
// // //                     ),
// // //                     child: TabBar(
// // //                       controller: _tabController,
// // //                       indicator: BoxDecoration(
// // //                         color: AppColors.primaryRed,
// // //                         borderRadius: BorderRadius.circular(w * .03),
// // //                       ),
// // //                       indicatorColor: AppColors.darkGray,
// // //                       labelColor: AppColors.white,
// // //                       indicatorSize: TabBarIndicatorSize.tab,
// // //                       dividerHeight: 0.0,
// // //                       unselectedLabelColor:
// // //                           AppColors.darkGray.withOpacity(0.4),
// // //                       labelStyle: TextStyle(
// // //                         fontSize: w * .034,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                       tabs: const [
// // //                         Tab(text: "New trip"),
// // //                         Tab(text: "Completed"),
// // //                         Tab(text: "Cancelled"),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 )
// // //                 .animate()
// // //                 .fade(duration: 820.ms, curve: Curves.easeInOut)
// // //                 .scale(
// // //                   begin: const Offset(0.95, 0.95),
// // //                   end: const Offset(1, 1),
// // //                 ),
// // //           ),

// // //           // Divider
// // //           Divider(
// // //             color: AppColors.mediumGray.withOpacity(0.4),
// // //             thickness: w * .002,
// // //           ),

// // //           // Tab bar view with data
// // //           Expanded(
// // //             child: TabBarView(
// // //               controller: _tabController,
// // //               children: [
// // //                 // New trip tab - shows all data
// // //                 Obx(() => _buildRideList(w, 0)),
                
// // //                 // Completed tab - shows only completed rides
// // //                 Obx(() => _buildRideList(w, 1)),
                
// // //                 // Cancelled tab - shows only cancelled rides
// // //                 Obx(() => _buildRideList(w, 2)),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // Method to build ride list for each tab
// // //   Widget _buildRideList(double w, int tabIndex) {
// // //     final filteredRides = riedsHistoryController.getFilteredRides(tabIndex);
    
// // //     if (riedsHistoryController.isLoading.value) {
// // //       return const Center(
// // //         child: CircularProgressIndicator(),
// // //       );
// // //     }

// // //     if (filteredRides.isEmpty) {
// // //       return Center(
// // //         child: AppFonts.textPoppins(
// // //           context,
// // //           "No rides found",
// // //           w * 0.04,
// // //           FontWeight.w500,
// // //           AppColors.black.withOpacity(0.5),
// // //           TextAlign.center,
// // //           TextOverflow.ellipsis,
// // //           maxLines: 2,
// // //         ),
// // //       );
// // //     }

// // //     return Padding(
// // //       padding: EdgeInsets.symmetric(
// // //         horizontal: w * 0.04,
// // //         vertical: w * 0.02,
// // //       ),
// // //       child: ListView.builder(
// // //         itemCount: filteredRides.length,
// // //         itemBuilder: (context, index) {
// // //           final ride = filteredRides[index];
// // //           return Padding(
// // //             padding: EdgeInsets.only(bottom: w * 0.06),
// // //             child: rideWidget(w, ride, tabIndex)
// // //                 .animate()
// // //                 .fade(duration: 400.ms, curve: Curves.easeInOut)
// // //                 .scale(
// // //                   begin: const Offset(0.95, 0.95),
// // //                   end: const Offset(1, 1),
// // //                 ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   // Common widget for displaying ride information
// // //   Widget rideWidget(double w, RideHistory ride, int tabIndex) {
// // //     return Container(
// // //       width: w,
// // //       decoration: BoxDecoration(
// // //         color: AppColors.lightGray.withOpacity(0.3),
// // //         borderRadius: BorderRadius.circular(w * .035),
// // //         border: Border.all(
// // //           color: AppColors.black.withOpacity(0.1),
// // //           width: w * .002,
// // //         ),
// // //       ),
// // //       child: Padding(
// // //         padding: EdgeInsets.symmetric(
// // //           horizontal: w * 0.04,
// // //           vertical: w * 0.03,
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // Status and amount row
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 // Status based on orderStatus
// // //                 _buildStatusWidget(w, ride.orderStatus ?? ''),
                
// // //                 // Amount
// // //                 AppFonts.textPoppins(
// // //                   context,
// // //                   "₹${ride.totalFare?.toStringAsFixed(2) ?? '0.00'}",
// // //                   w * 0.042,
// // //                   FontWeight.w600,
// // //                   AppColors.black,
// // //                   TextAlign.center,
// // //                   TextOverflow.ellipsis,
// // //                   maxLines: 1,
// // //                 ),
// // //               ],
// // //             ),

// // //             // User name and payment method row
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 // User name
// // //                 AppFonts.textPoppins(
// // //                   context,
// // //                   ride.user?.name ?? 'Unknown User',
// // //                   w * 0.032,
// // //                   FontWeight.w600,
// // //                   AppColors.black.withOpacity(0.5),
// // //                   TextAlign.center,
// // //                   TextOverflow.ellipsis,
// // //                   maxLines: 1,
// // //                 ),

// // //                 // Payment method or cancellation reason
// // //                 _buildPaymentOrReasonWidget(w, ride, tabIndex),
// // //               ],
// // //             ),

// // //             SizedBox(height: w * 0.02),

// // //             Divider(
// // //               color: AppColors.mediumGray.withOpacity(0.4),
// // //               thickness: w * .002,
// // //               height: w * 0.1,
// // //             ),

// // //             // Vehicle type
// // //             Row(
// // //               children: [
// // //                 Image.asset(
// // //                   "assets/images/bike_image.png",
// // //                   height: 30,
// // //                   width: 30,
// // //                 ),
// // //                 SizedBox(width: w * 0.02),
// // //                 AppFonts.textPoppins(
// // //                   context,
// // //                   ride.orderType ?? 'Bike',
// // //                   w * 0.035,
// // //                   FontWeight.w600,
// // //                   AppColors.black,
// // //                   TextAlign.center,
// // //                   TextOverflow.ellipsis,
// // //                   maxLines: 1,
// // //                 ),
// // //               ],
// // //             ),

// // //             SizedBox(height: w * 0.06),

// // //             // Pickup and destination details
// // //             _buildLocationDetails(w, ride),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // Build status widget
// // //   Widget _buildStatusWidget(double w, String orderStatus) {
// // //     final status = orderStatus.toLowerCase();
// // //     Color statusColor;
// // //     String statusText;

// // //     if (status == 'completed') {
// // //       statusColor = AppColors.TextBuleColor;
// // //       statusText = 'Completed';
// // //     } else if (status == 'cancelled') {
// // //       statusColor = const Color(0xFFE02D3C);
// // //       statusText = 'Cancelled';
// // //     } else {
// // //       statusColor = AppColors.TextBuleColor;
// // //       statusText = 'New trip';
// // //     }

// // //     return Row(
// // //       children: [
// // //         AppFonts.textPoppins(
// // //           context,
// // //           statusText,
// // //           w * 0.035,
// // //           FontWeight.w600,
// // //           statusColor,
// // //           TextAlign.center,
// // //           TextOverflow.ellipsis,
// // //           maxLines: 1,
// // //         ),
// // //         if (currentTabBar.currentTabIndex.value == 0) ...[
// // //           AppFonts.textPoppins(
// // //             context,
// // //             " : ",
// // //             w * 0.030,
// // //             FontWeight.w600,
// // //             statusColor,
// // //             TextAlign.center,
// // //             TextOverflow.ellipsis,
// // //             maxLines: 1,
// // //           ),
// // //           AppFonts.textPoppins(
// // //             context,
// // //             _formatTime(ride.createdAt),
// // //             w * 0.035,
// // //             FontWeight.w600,
// // //             statusColor,
// // //             TextAlign.center,
// // //             TextOverflow.ellipsis,
// // //             maxLines: 1,
// // //           ),
// // //         ],
// // //       ],
// // //     );
// // //   }

// // //   // Build payment method or cancellation reason widget
// // //   Widget _buildPaymentOrReasonWidget(double w, RideHistory ride, int tabIndex) {
// // //     if (tabIndex == 2) {
// // //       // For cancelled tab, show cancellation reason if available
// // //       return AppFonts.textPoppins(
// // //         context,
// // //         ride.user?.name ?? 'Unknown User',
// // //         w * 0.032,
// // //         FontWeight.w600,
// // //         AppColors.black.withOpacity(0.5),
// // //         TextAlign.center,
// // //         TextOverflow.ellipsis,
// // //         maxLines: 1,
// // //       );
// // //     } else {
// // //       // For other tabs, show payment method
// // //       final paymentMethod = ride.paymentMethod?.toLowerCase();
// // //       return Row(
// // //         children: [
// // //           if (paymentMethod == 'cash') ...[
// // //             Image.asset(
// // //               "assets/images/moneyss.png",
// // //               height: w * 0.05,
// // //               width: w * 0.05,
// // //             ),
// // //             AppFonts.textPoppins(
// // //               context,
// // //               " Cash",
// // //               w * 0.035,
// // //               FontWeight.w600,
// // //               const Color(0xFf4CAF50),
// // //               TextAlign.center,
// // //               TextOverflow.ellipsis,
// // //               maxLines: 1,
// // //             ),
// // //           ] else if (paymentMethod == 'card' || paymentMethod == 'online') ...[
// // //             Image.asset(
// // //               "assets/images/card_icon.png", // Add card icon asset
// // //               height: w * 0.05,
// // //               width: w * 0.05,
// // //             ),
// // //             AppFonts.textPoppins(
// // //               context,
// // //               " Online",
// // //               w * 0.035,
// // //               FontWeight.w600,
// // //               AppColors.TextBuleColor,
// // //               TextAlign.center,
// // //               TextOverflow.ellipsis,
// // //               maxLines: 1,
// // //             ),
// // //           ] else ...[
// // //             AppFonts.textPoppins(
// // //               context,
// // //               ride.paymentMethod ?? 'Unknown',
// // //               w * 0.035,
// // //               FontWeight.w600,
// // //               AppColors.black.withOpacity(0.5),
// // //               TextAlign.center,
// // //               TextOverflow.ellipsis,
// // //               maxLines: 1,
// // //             ),
// // //           ],
// // //         ],
// // //       );
// // //     }
// // //   }

// // //   // Build location details
// // //   Widget _buildLocationDetails(double w, RideHistory ride) {
// // //     // Note: You'll need to update your API to include pickup and destination addresses
// // //     // For now, using placeholders
// // //     return Row(
// // //       children: [
// // //         Column(
// // //           children: [
// // //             Image.asset(
// // //               "assets/icons/greenDot.png",
// // //               height: w * 0.06,
// // //               width: w * 0.06,
// // //             ),
// // //             Container(
// // //               width: w * 0.002,
// // //               height: w * 0.10,
// // //             ),
// // //             Image.asset(
// // //               "assets/icons/redDot.png",
// // //               height: w * 0.06,
// // //               width: w * 0.06,
// // //             ),
// // //           ],
// // //         ),
// // //         SizedBox(width: w * 0.04),
// // //         SizedBox(
// // //           width: w * 0.70,
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               // Pickup
// // //               AppFonts.textPoppins(
// // //                 context,
// // //                 "Pickup",
// // //                 w * 0.032,
// // //                 FontWeight.w600,
// // //                 AppColors.green,
// // //                 TextAlign.start,
// // //                 TextOverflow.ellipsis,
// // //                 maxLines: 1,
// // //               ),
// // //               SizedBox(height: w * 0.02),
// // //               AppFonts.textPoppins(
// // //                 context,
// // //                 "Location details not available", // Update with actual pickup address
// // //                 w * 0.032,
// // //                 FontWeight.w600,
// // //                 AppColors.black,
// // //                 TextAlign.start,
// // //                 TextOverflow.ellipsis,
// // //                 maxLines: 2,
// // //               ),
// // //               SizedBox(height: w * 0.06),
// // //               // Destination
// // //               AppFonts.textPoppins(
// // //                 context,
// // //                 "Destination",
// // //                 w * 0.032,
// // //                 FontWeight.w600,
// // //                 AppColors.primaryRed,
// // //                 TextAlign.start,
// // //                 TextOverflow.ellipsis,
// // //                 maxLines: 1,
// // //               ),
// // //               SizedBox(height: w * 0.02),
// // //               AppFonts.textPoppins(
// // //                 context,
// // //                 "Location details not available", // Update with actual destination address
// // //                 w * 0.032,
// // //                 FontWeight.w600,
// // //                 AppColors.black,
// // //                 TextAlign.start,
// // //                 TextOverflow.ellipsis,
// // //                 maxLines: 2,
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   // Helper method to format time
// // //   String _formatTime(DateTime? dateTime) {
// // //     if (dateTime == null) return 'N/A';
    
// // //     final now = DateTime.now();
// // //     final difference = now.difference(dateTime);
    
// // //     if (difference.inDays > 0) {
// // //       return '${difference.inDays}d ago';
// // //     } else if (difference.inHours > 0) {
// // //       return '${difference.inHours}h ago';
// // //     } else if (difference.inMinutes > 0) {
// // //       return '${difference.inMinutes}m ago';
// // //     } else {
// // //       return 'Just now';
// // //     }
// // //   }
// // // }


// // import 'package:corezap_driver/controller/controllers.dart';
// // import 'package:corezap_driver/controller/ridescontroller/rieds_history_controller.dart';
// // import 'package:corezap_driver/modals/ride_history_response.dart';
// // import 'package:corezap_driver/utilities/colors.dart';
// // import 'package:corezap_driver/utilities/custom_font.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// // import 'package:get/instance_manager.dart';

// // class RidehistoryScreen extends StatefulWidget {
// //   const RidehistoryScreen({super.key});

// //   @override
// //   State<RidehistoryScreen> createState() => _RidehistoryScreenState();
// // }

// // class _RidehistoryScreenState extends State<RidehistoryScreen>
// //     with TickerProviderStateMixin {
// //   final RiedsHistoryController riedsHistoryController = Get.put(
// //     RiedsHistoryController(),
// //   );

// //   Controllers currentTabBar = Get.find<Controllers>();

// //   late TabController _tabController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this);

// //     _tabController.addListener(() {
// //       currentTabBar.currentTabIndex.value = _tabController.index;
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;
// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       appBar: AppBar(
// //         backgroundColor: AppColors.white,
// //         elevation: 0,
// //         leadingWidth: w * 0.010,
// //         leading: const SizedBox(),
// //         title: AppFonts.textPoppins(
// //               context,
// //               "Ride History",
// //               w * 0.05,
// //               FontWeight.w600,
// //               AppColors.black,
// //               TextAlign.center,
// //               TextOverflow.ellipsis,
// //               maxLines: 1,
// //             )
// //             .animate()
// //             .fade(duration: 800.ms, curve: Curves.easeInOut)
// //             .scale(
// //               begin: const Offset(0.95, 0.95),
// //               end: const Offset(1, 1),
// //             ),
// //       ),
// //       body: Column(
// //         children: [
// //           // Tab bar
// //           Padding(
// //             padding: EdgeInsets.symmetric(
// //               horizontal: w * .04,
// //               vertical: w * .03,
// //             ),
// //             child: Container(
// //                   height: w * .11,
// //                   width: w,
// //                   decoration: BoxDecoration(
// //                     color: AppColors.lightGray.withOpacity(0.3),
// //                     borderRadius: BorderRadius.circular(w * .035),
// //                     border: Border.all(
// //                       color: AppColors.black.withOpacity(0.4),
// //                       width: w * .002,
// //                     ),
// //                   ),
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(
// //                       horizontal: w * .005,
// //                       vertical: w * .005,
// //                     ),
// //                     child: TabBar(
// //                       controller: _tabController,
// //                       indicator: BoxDecoration(
// //                         color: AppColors.primaryRed,
// //                         borderRadius: BorderRadius.circular(w * .03),
// //                       ),
// //                       indicatorColor: AppColors.darkGray,
// //                       labelColor: AppColors.white,
// //                       indicatorSize: TabBarIndicatorSize.tab,
// //                       dividerHeight: 0.0,
// //                       unselectedLabelColor:
// //                           AppColors.darkGray.withOpacity(0.4),
// //                       labelStyle: TextStyle(
// //                         fontSize: w * .034,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                       tabs: const [
// //                         Tab(text: "New trip"),
// //                         Tab(text: "Completed"),
// //                         Tab(text: "Cancelled"),
// //                       ],
// //                     ),
// //                   ),
// //                 )
// //                 .animate()
// //                 .fade(duration: 820.ms, curve: Curves.easeInOut)
// //                 .scale(
// //                   begin: const Offset(0.95, 0.95),
// //                   end: const Offset(1, 1),
// //                 ),
// //           ),

// //           // Divider
// //           Divider(
// //             color: AppColors.mediumGray.withOpacity(0.4),
// //             thickness: w * .002,
// //           ),

// //           // Tab bar view with data
// //           Expanded(
// //             child: TabBarView(
// //               controller: _tabController,
// //               children: [
// //                 // New trip tab - shows all data
// //                 Obx(() => _buildRideList(w, 0)),
                
// //                 // Completed tab - shows only completed rides
// //                 Obx(() => _buildRideList(w, 1)),
                
// //                 // Cancelled tab - shows only cancelled rides
// //                 Obx(() => _buildRideList(w, 2)),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Method to build ride list for each tab
// //   Widget _buildRideList(double w, int tabIndex) {
// //     final filteredRides = riedsHistoryController.getFilteredRides(tabIndex);
    
// //     if (riedsHistoryController.isLoading.value) {
// //       return const Center(
// //         child: CircularProgressIndicator(),
// //       );
// //     }

// //     if (filteredRides.isEmpty) {
// //       return Center(
// //         child: AppFonts.textPoppins(
// //           context,
// //           "No rides found",
// //           w * 0.04,
// //           FontWeight.w500,
// //           AppColors.black.withOpacity(0.5),
// //           TextAlign.center,
// //           TextOverflow.ellipsis,
// //           maxLines: 2,
// //         ),
// //       );
// //     }

// //     return Padding(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: w * 0.04,
// //         vertical: w * 0.02,
// //       ),
// //       child: ListView.builder(
// //         itemCount: filteredRides.length,
// //         itemBuilder: (context, index) {
// //           final ride = filteredRides[index];
// //           return Padding(
// //             padding: EdgeInsets.only(bottom: w * 0.06),
// //             child: rideWidget(w, ride, tabIndex)
// //                 .animate()
// //                 .fade(duration: 400.ms, curve: Curves.easeInOut)
// //                 .scale(
// //                   begin: const Offset(0.95, 0.95),
// //                   end: const Offset(1, 1),
// //                 ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   // Common widget for displaying ride information
// //   Widget rideWidget(double w, RideHistory ride, int tabIndex) {
// //     return Container(
// //       width: w,
// //       decoration: BoxDecoration(
// //         color: AppColors.lightGray.withOpacity(0.3),
// //         borderRadius: BorderRadius.circular(w * .035),
// //         border: Border.all(
// //           color: AppColors.black.withOpacity(0.1),
// //           width: w * .002,
// //         ),
// //       ),
// //       child: Padding(
// //         padding: EdgeInsets.symmetric(
// //           horizontal: w * 0.04,
// //           vertical: w * 0.03,
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Status and amount row
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // Status based on orderStatus
// //                 _buildStatusWidget(w, ride.orderStatus ?? '', ride.createdAt),
                
// //                 // Amount
// //                 AppFonts.textPoppins(
// //                   context,
// //                   "₹${ride.totalFare?.toStringAsFixed(2) ?? '0.00'}",
// //                   w * 0.042,
// //                   FontWeight.w600,
// //                   AppColors.black,
// //                   TextAlign.center,
// //                   TextOverflow.ellipsis,
// //                   maxLines: 1,
// //                 ),
// //               ],
// //             ),

// //             // User name and payment method row
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // User name
// //                 AppFonts.textPoppins(
// //                   context,
// //                   ride.user?.name ?? 'Unknown User',
// //                   w * 0.032,
// //                   FontWeight.w600,
// //                   AppColors.black.withOpacity(0.5),
// //                   TextAlign.center,
// //                   TextOverflow.ellipsis,
// //                   maxLines: 1,
// //                 ),

// //                 // Payment method or cancellation reason
// //                 _buildPaymentOrReasonWidget(w, ride, tabIndex),
// //               ],
// //             ),

// //             SizedBox(height: w * 0.02),

// //             Divider(
// //               color: AppColors.mediumGray.withOpacity(0.4),
// //               thickness: w * .002,
// //               height: w * 0.1,
// //             ),

// //             // Vehicle type
// //             Row(
// //               children: [
// //                 Image.asset(
// //                   "assets/images/bike_image.png",
// //                   height: 30,
// //                   width: 30,
// //                 ),
// //                 SizedBox(width: w * 0.02),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   ride.orderType ?? 'Bike',
// //                   w * 0.035,
// //                   FontWeight.w600,
// //                   AppColors.black,
// //                   TextAlign.center,
// //                   TextOverflow.ellipsis,
// //                   maxLines: 1,
// //                 ),
// //               ],
// //             ),

// //             SizedBox(height: w * 0.06),

// //             // Pickup and destination details
// //             _buildLocationDetails(w, ride),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // Build status widget
// //   Widget _buildStatusWidget(double w, String orderStatus, DateTime? createdAt) {
// //     final status = orderStatus.toLowerCase();
// //     Color statusColor;
// //     String statusText;

// //     if (status == 'completed') {
// //       statusColor = AppColors.TextBuleColor;
// //       statusText = 'Completed';
// //     } else if (status == 'cancelled') {
// //       statusColor = const Color(0xFFE02D3C);
// //       statusText = 'Cancelled';
// //     } else {
// //       statusColor = AppColors.TextBuleColor;
// //       statusText = 'New trip';
// //     }

// //     return Row(
// //       children: [
// //         AppFonts.textPoppins(
// //           context,
// //           statusText,
// //           w * 0.035,
// //           FontWeight.w600,
// //           statusColor,
// //           TextAlign.center,
// //           TextOverflow.ellipsis,
// //           maxLines: 1,
// //         ),
// //         if (currentTabBar.currentTabIndex.value == 0) ...[
// //           AppFonts.textPoppins(
// //             context,
// //             " : ",
// //             w * 0.030,
// //             FontWeight.w600,
// //             statusColor,
// //             TextAlign.center,
// //             TextOverflow.ellipsis,
// //             maxLines: 1,
// //           ),
// //           AppFonts.textPoppins(
// //             context,
// //             _formatTime(createdAt),
// //             w * 0.035,
// //             FontWeight.w600,
// //             statusColor,
// //             TextAlign.center,
// //             TextOverflow.ellipsis,
// //             maxLines: 1,
// //           ),
// //         ],
// //       ],
// //     );
// //   }

// //   // Build payment method or cancellation reason widget
// //   Widget _buildPaymentOrReasonWidget(double w, RideHistory ride, int tabIndex) {
// //     if (tabIndex == 2) {
// //       // For cancelled tab, show cancellation reason if available
// //       return AppFonts.textPoppins(
// //         context,
// //         ride.user?.name ?? 'Unknown User',
// //         w * 0.032,
// //         FontWeight.w600,
// //         AppColors.black.withOpacity(0.5),
// //         TextAlign.center,
// //         TextOverflow.ellipsis,
// //         maxLines: 1,
// //       );
// //     } else {
// //       // For other tabs, show payment method
// //       final paymentMethod = ride.paymentMethod?.toLowerCase();
// //       return Row(
// //         children: [
// //           if (paymentMethod == 'cash') ...[
// //             Image.asset(
// //               "assets/images/moneyss.png",
// //               height: w * 0.05,
// //               width: w * 0.05,
// //             ),
// //             AppFonts.textPoppins(
// //               context,
// //               " Cash",
// //               w * 0.035,
// //               FontWeight.w600,
// //               const Color(0xFf4CAF50),
// //               TextAlign.center,
// //               TextOverflow.ellipsis,
// //               maxLines: 1,
// //             ),
// //           ] else if (paymentMethod == 'card' || paymentMethod == 'online') ...[
// //             Image.asset(
// //               "assets/images/card_icon.png", // Add card icon asset
// //               height: w * 0.05,
// //               width: w * 0.05,
// //             ),
// //             AppFonts.textPoppins(
// //               context,
// //               " Online",
// //               w * 0.035,
// //               FontWeight.w600,
// //               AppColors.TextBuleColor,
// //               TextAlign.center,
// //               TextOverflow.ellipsis,
// //               maxLines: 1,
// //             ),
// //           ] else ...[
// //             AppFonts.textPoppins(
// //               context,
// //               ride.paymentMethod ?? 'Unknown',
// //               w * 0.035,
// //               FontWeight.w600,
// //               AppColors.black.withOpacity(0.5),
// //               TextAlign.center,
// //               TextOverflow.ellipsis,
// //               maxLines: 1,
// //             ),
// //           ],
// //         ],
// //       );
// //     }
// //   }

// //   // Build location details
// //   Widget _buildLocationDetails(double w, RideHistory ride) {
// //     // Note: You'll need to update your API to include pickup and destination addresses
// //     // For now, using placeholders
// //     return Row(
// //       children: [
// //         Column(
// //           children: [
// //             Image.asset(
// //               "assets/icons/greenDot.png",
// //               height: w * 0.06,
// //               width: w * 0.06,
// //             ),
// //             Container(
// //               width: w * 0.002,
// //               height: w * 0.10,
// //             ),
// //             Image.asset(
// //               "assets/icons/redDot.png",
// //               height: w * 0.06,
// //               width: w * 0.06,
// //             ),
// //           ],
// //         ),
// //         SizedBox(width: w * 0.04),
// //         SizedBox(
// //           width: w * 0.70,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Pickup
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Pickup",
// //                 w * 0.032,
// //                 FontWeight.w600,
// //                 AppColors.green,
// //                 TextAlign.start,
// //                 TextOverflow.ellipsis,
// //                 maxLines: 1,
// //               ),
// //               SizedBox(height: w * 0.02),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Location details not available", // Update with actual pickup address
// //                 w * 0.032,
// //                 FontWeight.w600,
// //                 AppColors.black,
// //                 TextAlign.start,
// //                 TextOverflow.ellipsis,
// //                 maxLines: 2,
// //               ),
// //               SizedBox(height: w * 0.06),
// //               // Destination
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Destination",
// //                 w * 0.032,
// //                 FontWeight.w600,
// //                 AppColors.primaryRed,
// //                 TextAlign.start,
// //                 TextOverflow.ellipsis,
// //                 maxLines: 1,
// //               ),
// //               SizedBox(height: w * 0.02),
// //               AppFonts.textPoppins(
// //                 context,
// //                 "Location details not available", // Update with actual destination address
// //                 w * 0.032,
// //                 FontWeight.w600,
// //                 AppColors.black,
// //                 TextAlign.start,
// //                 TextOverflow.ellipsis,
// //                 maxLines: 2,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // Helper method to format time
// //   String _formatTime(DateTime? dateTime) {
// //     if (dateTime == null) return 'N/A';
    
// //     final now = DateTime.now();
// //     final difference = now.difference(dateTime);
    
// //     if (difference.inDays > 0) {
// //       return '${difference.inDays}d ago';
// //     } else if (difference.inHours > 0) {
// //       return '${difference.inHours}h ago';
// //     } else if (difference.inMinutes > 0) {
// //       return '${difference.inMinutes}m ago';
// //     } else {
// //       return 'Just now';
// //     }
// //   }
// // }