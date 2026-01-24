



// // import 'package:corezap_driver/controllers/controllers.dart';
// // import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
// // import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
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
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';

// // class LiveRide extends StatefulWidget {
// //   final Map<String, dynamic> rideData;
  
// //   const LiveRide({super.key, required this.rideData});

// //   @override
// //   State<LiveRide> createState() => _LiveRideState();
// // }

// // class _LiveRideState extends State<LiveRide> {
// //   final StepperController stepperController = Get.find();
// //   final Controllers cancelRideController = Get.find();

// //   final OrderUpdateController orderUpdateController = Get.find<OrderUpdateController>();

// //   // Pickup & Drop LatLng
// //   LatLng? pickupLatLng;
// //   LatLng? dropLatLng;

// //   final Set<Marker> _markers = {};

// //   GoogleMapController? _mapController;

// //   // Timer for auto-cancel
// //   Timer? _autoCancelTimer;
// //   int _secondsRemaining = 10;
// //   bool _isTimerRunning = true;
// //   bool _hasAccepted = false;
// //   bool _hasCancelled = false;

// //   @override
// //   void initState() {
// //     super.initState();

// //     // Print received data for debugging
// //     print("================ LIVE RIDE DATA ================");
// //     print("Full ride data received in LiveRide: ${widget.rideData}");
    
// //     // Extract data from rideData
// //     _extractRideData();

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       cancelRideController.cancelRideReasonIndex.value = -1;
// //     });

// //     if (pickupLatLng != null && dropLatLng != null) {
// //       _setMarkers();
// //     }

// //     // Start auto-cancel timer
// //     _startAutoCancelTimer();
// //   }

// //   @override
// //   void dispose() {
// //     // Cancel timer when widget is disposed
// //     _autoCancelTimer?.cancel();
// //     super.dispose();
// //   }

// //   void _startAutoCancelTimer() {
// //     _autoCancelTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (_secondsRemaining > 0 && _isTimerRunning) {
// //         setState(() {
// //           _secondsRemaining--;
// //         });
// //       } else if (_secondsRemaining <= 0 && _isTimerRunning && !_hasAccepted) {
// //         // Auto-cancel after 10 seconds
// //         timer.cancel();
// //         _autoCancelRide();
// //       }
// //     });
// //   }

// //   Future<void> _autoCancelRide() async {
// //     if (_hasCancelled || _hasAccepted) return;
    
// //     _hasCancelled = true;
// //     _isTimerRunning = false;
    
// //     print("⏰ Auto-cancelling ride after 10 seconds...");
    
// //     final orderId = widget.rideData['rideId'];
// //     await OrderService.declineOrder(orderId: orderId);
    
// //     // Navigate back or show message
// //     if (mounted) {
// //       Get.back(); // Navigate back to previous screen
// //       Get.snackbar(
// //         'Ride Auto-Cancelled',
// //         'You did not accept the ride in time',
// //         backgroundColor: Colors.orange,
// //         colorText: Colors.white,
// //       );
// //     }
// //   }

// //   void _extractRideData() {
// //     try {
// //       // Extract pickup coordinates
// //       if (widget.rideData['pickup'] != null) {
// //         final pickup = widget.rideData['pickup'];
// //         pickupLatLng = LatLng(
// //           pickup['latitude']?.toDouble() ?? 0.0,
// //           pickup['longitude']?.toDouble() ?? 0.0,
// //         );
// //       } else if (widget.rideData['startLocation'] != null) {
// //         final startLocation = widget.rideData['startLocation'];
// //         if (startLocation['coordinates'] != null &&
// //             startLocation['coordinates'].length >= 2) {
// //           pickupLatLng = LatLng(
// //             startLocation['coordinates'][1]?.toDouble() ?? 0.0,
// //             startLocation['coordinates'][0]?.toDouble() ?? 0.0,
// //           );
// //         }
// //       }

// //       // Extract drop coordinates
// //       if (widget.rideData['destination'] != null) {
// //         final destination = widget.rideData['destination'];
// //         dropLatLng = LatLng(
// //           destination['latitude']?.toDouble() ?? 0.0,
// //           destination['longitude']?.toDouble() ?? 0.0,
// //         );
// //       } else if (widget.rideData['endLocation'] != null) {
// //         final endLocation = widget.rideData['endLocation'];
// //         if (endLocation['coordinates'] != null &&
// //             endLocation['coordinates'].length >= 2) {
// //           dropLatLng = LatLng(
// //             endLocation['coordinates'][1]?.toDouble() ?? 0.0,
// //             endLocation['coordinates'][0]?.toDouble() ?? 0.0,
// //           );
// //         }
// //       } else if (widget.rideData['dropoff'] != null) {
// //         final dropoff = widget.rideData['dropoff'];
// //         dropLatLng = LatLng(
// //           dropoff['latitude']?.toDouble() ?? 0.0,
// //           dropoff['longitude']?.toDouble() ?? 0.0,
// //         );
// //       }

// //       print("Pickup LatLng: $pickupLatLng");
// //       print("Drop LatLng: $dropLatLng");
// //       print("==============================================");
// //     } catch (e) {
// //       print("Error extracting ride data: $e");
// //       // Set default values if extraction fails
// //       pickupLatLng = const LatLng(17.4065, 78.4772);
// //       dropLatLng = const LatLng(17.4120, 78.4850);
// //     }
// //   }

// //   void _setMarkers() {
// //     if (pickupLatLng != null) {
// //       _markers.add(Marker(
// //         markerId: const MarkerId("pickup"),
// //         position: pickupLatLng!,
// //         infoWindow: const InfoWindow(title: "Pickup Location"),
// //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
// //       ));
// //     }

// //     if (dropLatLng != null) {
// //       _markers.add(Marker(
// //         markerId: const MarkerId("drop"),
// //         position: dropLatLng!,
// //         infoWindow: const InfoWindow(title: "Drop Location"),
// //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
// //       ));
// //     }
// //   }

// //   void _fitMapToMarkers() async {
// //     if (_mapController == null || pickupLatLng == null || dropLatLng == null) {
// //       return;
// //     }

// //     LatLngBounds bounds;
// //     if (pickupLatLng!.latitude > dropLatLng!.latitude &&
// //         pickupLatLng!.longitude > dropLatLng!.longitude) {
// //       bounds = LatLngBounds(southwest: dropLatLng!, northeast: pickupLatLng!);
// //     } else if (pickupLatLng!.longitude > dropLatLng!.longitude) {
// //       bounds = LatLngBounds(
// //         southwest: LatLng(pickupLatLng!.latitude, dropLatLng!.longitude),
// //         northeast: LatLng(dropLatLng!.latitude, pickupLatLng!.longitude),
// //       );
// //     } else if (pickupLatLng!.latitude > dropLatLng!.latitude) {
// //       bounds = LatLngBounds(
// //         southwest: LatLng(dropLatLng!.latitude, pickupLatLng!.longitude),
// //         northeast: LatLng(pickupLatLng!.latitude, dropLatLng!.longitude),
// //       );
// //     } else {
// //       bounds = LatLngBounds(southwest: pickupLatLng!, northeast: dropLatLng!);
// //     }

// //     CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
// //     _mapController!.animateCamera(cameraUpdate);
// //   }

// //   // Helper method to format timestamp
// //   String _formatDateFromTimestamp(int timestamp) {
// //     try {
// //       final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
// //       return "${date.day} ${_getMonthName(date.month)}, ${date.year}";
// //     } catch (e) {
// //       return "30 August, 2025"; // Default fallback
// //     }
// //   }

// //   String _getMonthName(int month) {
// //     const months = [
// //       'January', 'February', 'March', 'April', 'May', 'June',
// //       'July', 'August', 'September', 'October', 'November', 'December'
// //     ];
// //     return months[month - 1];
// //   }

// //   Future<void> _acceptRide() async {
// //     if (_hasAccepted || _hasCancelled) return;
    
// //     _hasAccepted = true;
// //     _isTimerRunning = false;
// //     _autoCancelTimer?.cancel();
    
// //     final orderId = widget.rideData['rideId'];
// //     print("🚗 Accepting ride with ID: $orderId");

// //     stepperController.resetSteps();
    
// //     // // Pass context and rideData as parameters
// //     // await OrderService.acceptOrder(
// //     //   orderId: orderId, 
// //     //   status: "Accepted",
// //     //   context: context,
// //     //   rideData: widget.rideData,
// //     // );

// //    await orderUpdateController.update_order_method(orderstatus: "Accepted",orderid: orderId);
// //    CustomNavigator.push(
// //             context,
// //             ArrivingClient(
// //               // typeCheck: rideData['rideType'] == 'scheduled',
// //               rideData: widget.rideData,
// //             ),
// //             transition: TransitionType.slideLeft,
// //           );
// //   }

// //   Future<void> _cancelRide() async {
// //     if (_hasCancelled || _hasAccepted) return;
    
// //     _hasCancelled = true;
// //     _isTimerRunning = false;
// //     _autoCancelTimer?.cancel();
    
// //     final orderId = widget.rideData['rideId'];
// //     await OrderService.declineOrder(orderId: orderId);
    
// //     Get.back(); // Navigate back
// //     Get.snackbar(
// //       'Ride Cancelled',
// //       'You have cancelled the ride',
// //       backgroundColor: Colors.orange,
// //       colorText: Colors.white,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final double w = MediaQuery.of(context).size.width;

// //     // Extract ride information with null safety
// //     final riderName = widget.rideData['riderName']?.toString() ?? 'N/A';
// //     final riderPhone = widget.rideData['riderNumber']?.toString() ?? 'N/A';
// //     final totalFare = widget.rideData['totalFare']?.toString() ?? 'N/A';
// //     final distance = widget.rideData['distance']?.toString() ?? 'N/A';
    
// //     // Extract addresses
// //     final pickupAddress = widget.rideData['startLocation']?['address']?.toString() ?? 
// //                          'Manikonda Jagir, Hyderabad, Telangana';
// //     final dropAddress = widget.rideData['endLocation']?['address']?.toString() ?? 
// //                        'Manikonda Jagir, Hyderabad, Telangana';
    
// //     // Format date from timestamp
// //     final timestamp = widget.rideData['timestamp'];
// //     final formattedDate = timestamp != null 
// //         ? _formatDateFromTimestamp(timestamp is String ? int.parse(timestamp) : timestamp)
// //         : "30 August, 2025";

// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.all(w * 0.04),
// //           child: Column(
// //             children: [
// //               // Timer display
// //               _timerWidget(context, w),
// //               SizedBox(height: w * 0.02),
// //               _dateText(context, w, formattedDate),
// //               SizedBox(height: w * 0.02),
// //               _fareCard(context, w, riderName, totalFare, riderPhone),
// //               SizedBox(height: w * 0.03),
// //               _mapView(w),
// //               SizedBox(height: w * 0.04),
// //               _locationInfo(context, w, pickupAddress, dropAddress),
// //               SizedBox(height: w * 0.04),
// //               _distanceCard(context, w, distance),
// //               SizedBox(height: w * 0.03),
// //               _actionButtons(context, w),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _timerWidget(BuildContext context, double w) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
// //       decoration: BoxDecoration(
// //         color: _secondsRemaining <= 3 ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(w * 0.02),
// //         border: Border.all(
// //           color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
// //         ),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(
// //             Icons.timer,
// //             size: w * 0.05,
// //             color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
// //           ),
// //           SizedBox(width: w * 0.02),
// //           Text(
// //             'Auto-cancel in: $_secondsRemaining seconds',
// //             style: TextStyle(
// //               fontSize: w * 0.04,
// //               fontWeight: FontWeight.w600,
// //               color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _dateText(BuildContext context, double w, String date) {
// //     return AppFonts.textPoppins(
// //       context,
// //       date,
// //       w * 0.04,
// //       FontWeight.w500,
// //       const Color(0xFF5F6165),
// //       TextAlign.center,
// //       TextOverflow.visible,
// //     );
// //   }

// //   Widget _fareCard(BuildContext context, double w, String riderName, String totalFare, String riderPhone) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(w * 0.035),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.08),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //         border: Border.all(color: AppColors.mediumGray.withOpacity(0.3)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Image.asset(
// //                 "assets/images/profil.png",
// //                 height: w * 0.12,
// //                 width: w * 0.12,
// //               ),
// //               SizedBox(width: w * 0.04),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     AppFonts.textPoppins(
// //                       context,
// //                       riderName,
// //                       w * 0.048,
// //                       FontWeight.w600,
// //                       AppColors.black,
// //                       TextAlign.start,
// //                       TextOverflow.ellipsis,
// //                     ),
// //                     SizedBox(height: w * 0.01),
// //                     AppFonts.textPoppins(
// //                       context,
// //                       riderPhone,
// //                       w * 0.035,
// //                       FontWeight.w500,
// //                       AppColors.mediumGray,
// //                       TextAlign.start,
// //                       TextOverflow.ellipsis,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Icon(Icons.currency_rupee, color: AppColors.green, size: w * 0.065),
// //                       AppFonts.textPoppins(
// //                         context,
// //                         totalFare,
// //                         w * 0.055,
// //                         FontWeight.w600,
// //                         AppColors.green,
// //                         TextAlign.center,
// //                         TextOverflow.visible,
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: w * 0.01),
// //                   Container(
// //                     padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.01),
// //                     decoration: BoxDecoration(
// //                       color: AppColors.green.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(w * 0.02),
// //                     ),
// //                     child: AppFonts.textPoppins(
// //                       context,
// //                       widget.rideData['rideType']?.toString().toUpperCase() ?? 'IMMEDIATE',
// //                       w * 0.03,
// //                       FontWeight.w600,
// //                       AppColors.green,
// //                       TextAlign.center,
// //                       TextOverflow.visible,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           // SizedBox(height: w * 0.02),
// //           // Additional ride info
// //           // Row(
// //           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           //   children: [
// //           //     _rideInfoItem(context, w, "Ride ID", widget.rideData['rideId']?.toString() ?? 'N/A'),
// //           //     _rideInfoItem(context, w, "Order ID", widget.rideData['orderId']?.toString() ?? 'N/A'),
// //           //   ],
// //           // ),
// //         ],
// //       ),
// //     ).animate().fade(duration: 700.ms).scale();
// //   }

// //   Widget _rideInfoItem(BuildContext context, double w, String title, String value) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         AppFonts.textPoppins(
// //           context,
// //           title,
// //           w * 0.03,
// //           FontWeight.w500,
// //           AppColors.mediumGray,
// //           TextAlign.start,
// //           TextOverflow.ellipsis,
// //         ),
// //         SizedBox(height: w * 0.005),
// //         AppFonts.textPoppins(
// //           context,
// //           value,
// //           w * 0.035,
// //           FontWeight.w600,
// //           AppColors.black,
// //           TextAlign.start,
// //           TextOverflow.ellipsis,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _mapView(double w) {
// //     final initialPosition = pickupLatLng ?? const LatLng(17.4065, 78.4772);
    
// //     return SizedBox(
// //       height: w * 0.95,
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(w * 0.03),
// //         child: GoogleMap(
// //           initialCameraPosition: CameraPosition(
// //             target: initialPosition,
// //             zoom: 14.5,
// //           ),
// //           myLocationEnabled: true,
// //           zoomControlsEnabled: false,
// //           markers: _markers,
// //           onMapCreated: (GoogleMapController controller) {
// //             _mapController = controller;
// //             if (pickupLatLng != null && dropLatLng != null) {
// //               _fitMapToMarkers(); // fit camera to both markers
// //             }
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _locationInfo(BuildContext context, double w, String pickupAddress, String dropAddress) {
// //     return Column(
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text(
// //               "Location",
// //               style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w500),
// //             ),
// //             Text.rich(
// //               TextSpan(
// //                 text: "Time ",
// //                 style: TextStyle(
// //                   fontSize: w * 0.029,
// //                   fontWeight: FontWeight.w500,
// //                   color: const Color(0xFF7C7C8D),
// //                 ),
// //                 children: [
// //                   TextSpan(
// //                     text: "10 min",
// //                     style: TextStyle(
// //                       fontSize: w * 0.04,
// //                       fontWeight: FontWeight.w600,
// //                       color: AppColors.black,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //         SizedBox(height: 10),
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Column(
// //               children: [
// //                 CustomImages.images(
// //                   "assets/icons/greenDot.png",
// //                   w * 0.05,
// //                   w * 0.05,
// //                 ),
// //                 SizedBox(
// //                   height: w * 0.1,
// //                   child: DottedLine(
// //                     direction: Axis.vertical,
// //                     dashLength: 4,
// //                     dashColor: AppColors.green,
// //                   ),
// //                 ),
// //                 CustomImages.images(
// //                   "assets/icons/redDot.png",
// //                   w * 0.05,
// //                   w * 0.05,
// //                 ),
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
// //                     pickupAddress,
// //                   ),
// //                   SizedBox(height: w * 0.05),
// //                   _locationText(
// //                     context,
// //                     "Drop",
// //                     dropAddress,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _locationText(BuildContext context, String title, String address) {
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
// //           maxLines: 2,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _distanceCard(BuildContext context, double w, String distance) {
// //     // Calculate pickup and drop distances (you might want to calculate actual distances)
// //     final pickupDistance = "${widget.rideData['driverDistance']?.toString() ?? '1.1'} Km";
// //     final dropDistance = "$distance Km";

// //     return SizedBox(
// //       height: w * 0.18,
// //       child: Row(
// //         children: [
// //           _distanceItem(context, w, "Pickup", pickupDistance),
// //           SizedBox(width: w * 0.03),
// //           _distanceItem(context, w, "Drop", dropDistance),
// //           SizedBox(width: w * 0.03),
// //           _distanceItem(context, w, "Fare", "₹${widget.rideData['totalFare'] ?? '100'}"),
// //         ],
// //       ),
// //     ).animate().fade(duration: 700.ms).scale();
// //   }

// //   Widget _distanceItem(BuildContext context, double w, String title, String value) {
// //     return Expanded(
// //       child: Container(
// //         padding: EdgeInsets.symmetric(
// //           vertical: w * 0.02,
// //           horizontal: w * 0.02,
// //         ),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(w * 0.025),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.08),
// //               blurRadius: 6,
// //               offset: const Offset(0, 3),
// //             ),
// //           ],
// //           border: Border.all(
// //             color: AppColors.mediumGray.withOpacity(0.3),
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             AppFonts.textPoppins(
// //               context,
// //               title,
// //               w * 0.037,
// //               FontWeight.w600,
// //               AppColors.mediumGray,
// //               TextAlign.center,
// //               TextOverflow.visible,
// //             ),
// //             AppFonts.textPoppins(
// //               context,
// //               value,
// //               w * 0.042,
// //               FontWeight.bold,
// //               AppColors.black,
// //               TextAlign.center,
// //               TextOverflow.visible,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _actionButtons(BuildContext context, double w) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         // Cancel Button
// //         ElevatedButton(
// //           onPressed: _hasAccepted || _hasCancelled ? null : _cancelRide,
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: AppColors.lightGray,
// //             foregroundColor: AppColors.mediumGray,
// //             minimumSize: Size(w * 0.43, w * 0.14),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               side: BorderSide(color: AppColors.mediumGray.withOpacity(0.5)),
// //             ),
// //             elevation: 0,
// //             disabledBackgroundColor: AppColors.lightGray.withOpacity(0.5),
// //             disabledForegroundColor: AppColors.mediumGray.withOpacity(0.5),
// //           ),
// //           child: Text(
// //             "Cancel",
// //             style: TextStyle(
// //               fontSize: w * 0.045,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //         ),

// //         // Accept Button
// //         ElevatedButton(
// //           onPressed: _hasAccepted || _hasCancelled ? null : _acceptRide,
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: ColorsList.mainButtonColor,
// //             foregroundColor: ColorsList.mainButtonTextColor,
// //             minimumSize: Size(w * 0.43, w * 0.14),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             elevation: 2,
// //             shadowColor: ColorsList.mainButtonColor.withOpacity(0.3),
// //             disabledBackgroundColor: ColorsList.mainButtonColor.withOpacity(0.5),
// //             disabledForegroundColor: ColorsList.mainButtonTextColor.withOpacity(0.5),
// //           ),
// //           child: Text(
// //             "Accept",
// //             style: TextStyle(
// //               fontSize: w * 0.045,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class OrderService {


// //   // static Future<void> acceptOrder({
// //   //   required String orderId,
// //   //   required String status,
// //   //   required BuildContext context,
// //   //   required Map<String, dynamic> rideData,
// //   // }) async {
// //   //   final prefs = await SharedPreferences.getInstance();
// //   //   final String? token = prefs.getString("auth_token");

// //   //   // Save orderId
// //   //   await prefs.setString("order_id", orderId);

// //   //   if (token == null || token.isEmpty) {
// //   //     Fluttertoast.showToast(
// //   //       msg: "Authentication token missing",
// //   //       toastLength: Toast.LENGTH_SHORT,
// //   //       gravity: ToastGravity.BOTTOM,
// //   //       backgroundColor: Colors.red,
// //   //       textColor: Colors.white,
// //   //     );
// //   //     return;
// //   //   }

// //   //   final Uri url = Uri.parse(
// //   //     "https://corezap.smarttechbros.com/api/v1/order/update/$orderId",
// //   //   );

// //   //   print("🔵 ACCEPT ORDER API");
// //   //   print("URL : $url");
// //   //   print("Order ID : $orderId");
// //   //   print("Status : $status");

// //   //   try {
// //   //     final response = await http.patch(
// //   //       url,
// //   //       headers: {
// //   //         "Authorization": "Bearer $token",
// //   //         "Content-Type": "application/json",
// //   //       },
// //   //       body: jsonEncode({
// //   //         "orderStatus": status,
// //   //       }),
// //   //     );

// //   //     print("✅ Status Code : ${response.statusCode}");
// //   //     print("📦 Raw Response : ${response.body}");

// //   //     final decoded = jsonDecode(response.body);
// //   //     print("🎯 Decoded Response : $decoded");

// //   //     /// ✅ SUCCESS / FAILURE HANDLING
// //   //     if (decoded['success'] == true) {
// //   //       // Navigate to ArrivingClient screen on success
// //   //       if (context.mounted) {
// //   //         CustomNavigator.push(
// //   //           context,
// //   //           ArrivingClient(
// //   //             typeCheck: rideData['rideType'] == 'scheduled',
// //   //             rideData: rideData,
// //   //           ),
// //   //           transition: TransitionType.slideLeft,
// //   //         );
// //   //       }
        
// //   //       Fluttertoast.showToast(
// //   //         msg: decoded['message'] ?? "Order accepted successfully",
// //   //         toastLength: Toast.LENGTH_SHORT,
// //   //         gravity: ToastGravity.BOTTOM,
// //   //         backgroundColor: Colors.green,
// //   //         textColor: Colors.white,
// //   //       );
// //   //     } else {
// //   //       Fluttertoast.showToast(
// //   //         msg: decoded['message'] ?? "Order accept failed",
// //   //         toastLength: Toast.LENGTH_LONG,
// //   //         gravity: ToastGravity.BOTTOM,
// //   //         backgroundColor: Colors.red,
// //   //         textColor: Colors.white,
// //   //       );
// //   //     }
// //   //   } catch (e) {
// //   //     print("❌ Error accepting order : $e");

// //   //     Fluttertoast.showToast(
// //   //       msg: "Something went wrong. Please try again.",
// //   //       toastLength: Toast.LENGTH_LONG,
// //   //       gravity: ToastGravity.BOTTOM,
// //   //       backgroundColor: Colors.red,
// //   //       textColor: Colors.white,
// //   //     );
// //   //   }
// //   // }

// //   // static Future<void> ArrivingOrder({
// //   //   required String orderId,
// //   //   required String status,
// //   // }) async {
// //   //   final prefs = await SharedPreferences.getInstance();
// //   //   final String? token = prefs.getString("auth_token");

// //   //     final String? order_id = prefs.getString("order_id");

// //   //   print("🔑 Token: $token");
// //   //   print("📦 Order ID: $orderId");

// //   //   print("checkkkkk_the_ariving_status  ${status}");

// //   //   final Uri url = Uri.parse(
// //   //     "https://corezap.smarttechbros.com/api/v1/order/update/$order_id",
// //   //   );

// //   //   print("🔵 ARRIVING ORDER API");
// //   //   print("URL : $url");

// //   //   try {
// //   //     final response = await http.patch(
// //   //       url,
// //   //       headers: {
// //   //         "Authorization": "Bearer $token",
// //   //         "Content-Type": "application/json",
// //   //       },
// //   //       body: jsonEncode({
// //   //         "orderStatus": status,
// //   //       }),
// //   //     );

// //   //     print("✅ Status Code : ${response.statusCode}");
// //   //     print("📦 Raw Response : ${response.body}");

// //   //     final decoded = jsonDecode(response.body);
// //   //     print("🎯 Decoded Response : $decoded");

// //   //     /// ✅ SHOW TOAST IF API FAILS
// //   //     if (decoded['success'] == false) {
// //   //       Fluttertoast.showToast(
// //   //         msg: decoded['message'],
// //   //         toastLength: Toast.LENGTH_LONG,
// //   //         gravity: ToastGravity.BOTTOM,
// //   //         backgroundColor: Colors.red,
// //   //         textColor: Colors.white,
// //   //       );
// //   //     }
// //   //   } catch (e) {
// //   //     print("❌ Error arriving order : $e");

// //   //     Fluttertoast.showToast(
// //   //       msg: "Something went wrong",
// //   //       toastLength: Toast.LENGTH_SHORT,
// //   //       gravity: ToastGravity.BOTTOM,
// //   //     );
// //   //   }
// //   // }

// //   static Future<void> declineOrder({
// //     String? orderId,
// //   }) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final String? token = prefs.getString("auth_token");

// //     final String? order_id = prefs.getString("order_id");

// //     print("my___token_here ${token}");
// //     print("declineddddd__myyyyy_orderid_iss ${orderId}");

// //     final Uri url = Uri.parse(
// //       "https://corezap.smarttechbros.com/api/v1/order/decline/$order_id",
// //     );

// //     print("🔵 DECLINE ORDER API");
// //     print("URL : $url");

// //     try {
// //       final response = await http.patch(
// //         url,
// //         headers: {
// //           "Authorization": "Bearer $token",
// //           "Content-Type": "application/json",
// //         },
// //       );

// //       print("✅ Status Code : ${response.statusCode}");
// //       print("📦 Raw Response : ${response.body}");

// //       final decoded = jsonDecode(response.body);
// //       print("🎯 Decoded Response : $decoded");
// //         Fluttertoast.showToast(
// //           msg: decoded['message'] ?? "start   successfully",
// //           toastLength: Toast.LENGTH_SHORT,
// //           gravity: ToastGravity.BOTTOM,
// //           backgroundColor: Colors.green,
// //           textColor: Colors.white,
// //         );
// //     } catch (e) {
// //       print("❌ Error declining order : $e");
// //     }
// //   }

//   // static Future<void> VerifyOtpOrder({
//   //   required String orderId,
//   //   required String rideOtpEnter,
//   // }) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final String? token = prefs.getString("auth_token");

//   //   final String? order_id = prefs.getString("order_id");

//   //   print("my___token_here ${token}");
//   //   print("myyyyy_orderid_iss in verifyOtpppp>>>>> ${order_id}");

//   //   final Uri url = Uri.parse(
//   //     "https://corezap.smarttechbros.com/api/v1/order/verifyOtp",
//   //   );

//   //   print("🔵 ACCEPT ORDER API");
//   //   print("URL : $url");

//   //   try {
//   //     final response = await http.post(
//   //       url,
//   //       headers: {
//   //         "Authorization": "Bearer $token",
//   //         "Content-Type": "application/json",
//   //       },
//   //       body: jsonEncode({
//   //         "orderId": order_id,
//   //         "rideOtp": rideOtpEnter
//   //       }),
//   //     );

//   //     print("arriivinngggggggggggggggggggggggg");
//   //     print("✅ Status Code : ${response.statusCode}");
//   //     print("📦 Raw Response arrivinggggggggg : ${response.body}");
//   //     print("arriivinngggggggggggggggggggggggg");

//   //     final decoded = jsonDecode(response.body);
//   //     print("🎯 Decoded Response : $decoded");
//   //   } catch (e) {
//   //     print("❌ Error accepting order : $e");
//   //   }
//   // }





// //   //   static Future<void> startStripOrder({
// //   //   required String orderId,
// //   //   required String status,
// //   //   required BuildContext context,
    
// //   // }) async {
// //   //   final prefs = await SharedPreferences.getInstance();
// //   //   final String? token = prefs.getString("auth_token");

// //   //   // Save orderId
// //   //   // await prefs.setString("order_id", orderId);

// //   //   final String? order_id = prefs.getString("order_id");


// //   //   print("myyyyy>>>>start_trip_orderiddd>>>>>>sharedpref  ${order_id}");

// //   //   if (token == null || token.isEmpty) {
// //   //     Fluttertoast.showToast(
// //   //       msg: "Authentication token missing",
// //   //       toastLength: Toast.LENGTH_SHORT,
// //   //       gravity: ToastGravity.BOTTOM,
// //   //       backgroundColor: Colors.red,
// //   //       textColor: Colors.white,
// //   //     );
// //   //     return;
// //   //   }

// //   //   final Uri url = Uri.parse(
// //   //     "https://corezap.smarttechbros.com/api/v1/order/update/$order_id",
// //   //   );

// //   //   print("🔵 ACCEPT ORDER API");
// //   //   print("URL : $url");
// //   //   print("Order ID : $orderId");
// //   //   print("Status : $status");

// //   //   try {
// //   //     final response = await http.patch(
// //   //       url,
// //   //       headers: {
// //   //         "Authorization": "Bearer $token",
// //   //         "Content-Type": "application/json",
// //   //       },
// //   //       // body: jsonEncode({
// //   //       //   "orderStatus": status,
// //   //       // }),

// //   //        body: jsonEncode({
// //   //         "orderStatus": "Progress",
// //   //       }),
// //   //     );

// //   //  print("starttripppppp_progresss>>>>>>> Status Code : ${response.statusCode}");
// //   //     print("starttripppppp_progresss >>>>>>>>>>Raw Response : ${response.body}");

// //   //     final decoded = jsonDecode(response.body);
// //   //     print("starttripppppp_progresss resposneeeeee Decoded Response : $decoded");

// //   //     /// ✅ SUCCESS / FAILURE HANDLING
// //   //     if (decoded['success'] == true) {
// //   //       final data = decoded['data'];
        
// //   //       Fluttertoast.showToast(
// //   //         msg: "Trip started successfully",
// //   //         toastLength: Toast.LENGTH_SHORT,
// //   //         gravity: ToastGravity.BOTTOM,
// //   //         backgroundColor: Colors.green,
// //   //         textColor: Colors.white,
// //   //       );
// //   //     } else {
// //   //       Fluttertoast.showToast(
// //   //         msg: decoded['message'] ?? "Failed to start trip",
// //   //         toastLength: Toast.LENGTH_LONG,
// //   //         gravity: ToastGravity.BOTTOM,
// //   //         backgroundColor: Colors.red,
// //   //         textColor: Colors.white,
// //   //       );
// //   //     }
// //   //   } catch (e) {
// //   //     print("❌ Error accepting order : $e");

// //   //     Fluttertoast.showToast(
// //   //       msg: "Something went wrong. Please try again.",
// //   //       toastLength: Toast.LENGTH_LONG,
// //   //       gravity: ToastGravity.BOTTOM,
// //   //       backgroundColor: Colors.red,
// //   //       textColor: Colors.white,
// //   //     );
// //   //   }
// //   // }



// //   //    static Future<void> CompleteOrder({
// //   //   required String orderId,
// //   //   required String status,
// //   //   required BuildContext context,
   
// //   // }) async {
// //   //   final prefs = await SharedPreferences.getInstance();
// //   //   final String? token = prefs.getString("auth_token");

// //   //   // Save orderId
// //   //   // await prefs.setString("order_id", orderId);

// //   //   final String? order_id = prefs.getString("order_id");


// //   //       print("myyyyy>>>>completeeeee_trip_orderiddd>>>>>>sharedpref  ${order_id}");


// //   //   if (token == null || token.isEmpty) {
// //   //     Fluttertoast.showToast(
// //   //       msg: "Authentication token missing",
// //   //       toastLength: Toast.LENGTH_SHORT,
// //   //       gravity: ToastGravity.BOTTOM,
// //   //       backgroundColor: Colors.red,
// //   //       textColor: Colors.white,
// //   //     );
// //   //     return;
// //   //   }

// //   //   final Uri url = Uri.parse(
// //   //     "https://corezap.smarttechbros.com/api/v1/order/update/$order_id",
// //   //   );

// //   //   print("🔵 ACCEPT ORDER API");
// //   //   print("URL : $url");
// //   //   print("Order ID : $orderId");
// //   //   print("Status : $status");

// //   //   try {
// //   //     final response = await http.patch(
// //   //       url,
// //   //       headers: {
// //   //         "Authorization": "Bearer $token",
// //   //         "Content-Type": "application/json",
// //   //       },
// //   //       // body: jsonEncode({
// //   //       //   "orderStatus": status,
// //   //       // }),

// //   //        body: jsonEncode({
// //   //         "orderStatus": "Completed",
// //   //       }),
// //   //     );


// //   //     print("completeddddddd>>>>>>> Status Code : ${response.statusCode}");
// //   //     print("completeddddd rideeee >>>>>>>>>>Raw Response : ${response.body}");

// //   //     final decoded = jsonDecode(response.body);
// //   //     print("completeddddd resposneeeeee Decoded Response : $decoded");

// //   //     /// ✅ SUCCESS / FAILURE HANDLING
// //   //     if (decoded['success'] == true) {
// //   //       final data = decoded['data'];
        
// //   //       Fluttertoast.showToast(
// //   //         msg: "Trip completed successfully",
// //   //         toastLength: Toast.LENGTH_SHORT,
// //   //         gravity: ToastGravity.BOTTOM,
// //   //         backgroundColor: Colors.green,
// //   //         textColor: Colors.white,
// //   //       );
// //   //     } else {
// //   //       Fluttertoast.showToast(
// //   //         msg: decoded['message'] ?? "Failed to complete trip",
// //   //         toastLength: Toast.LENGTH_LONG,
// //   //         gravity: ToastGravity.BOTTOM,
// //   //         backgroundColor: Colors.red,
// //   //         textColor: Colors.white,
// //   //       );
// //   //     }
// //   //   } catch (e) {
// //   //     print("❌ Error accepting order : $e");

// //   //     Fluttertoast.showToast(
// //   //       msg: "Something went wrong. Please try again.",
// //   //       toastLength: Toast.LENGTH_LONG,
// //   //       gravity: ToastGravity.BOTTOM,
// //   //       backgroundColor: Colors.red,
// //   //       textColor: Colors.white,
// //   //     );
// //   //   }
// //   // }

// // }



// import 'package:corezap_driver/controllers/controllers.dart';
// import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
// import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
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
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LiveRide extends StatefulWidget {
//   final Map<String, dynamic> rideData;
  
//   const LiveRide({super.key, required this.rideData});

//   @override
//   State<LiveRide> createState() => _LiveRideState();
// }

// class _LiveRideState extends State<LiveRide> {
//   final StepperController stepperController = Get.find();
//   final Controllers cancelRideController = Get.find();
//   final OrderUpdateController orderUpdateController = Get.find<OrderUpdateController>();

//   // Pickup & Drop LatLng
//   LatLng? pickupLatLng;
//   LatLng? dropLatLng;

//   final Set<Marker> _markers = {};
//   GoogleMapController? _mapController;

//   // Timer for auto-cancel
//   Timer? _autoCancelTimer;
//   int _secondsRemaining = 10;
//   bool _isTimerRunning = true;
//   bool _hasAccepted = false;
//   bool _hasCancelled = false;

//   // Local variables to store ride data
//   late String _riderName;
//   late String _riderPhone;
//   late String _totalFare;
//   late String _distance;
//   late String _pickupAddress;
//   late String _dropAddress;
//   late String _formattedDate;
//   late String _rideId;
//   late String _orderId;

//   @override
//   void initState() {
//     super.initState();

//     // Extract and store ride data locally
//     _extractAndStoreRideData();

//     // Print received data for debugging
//     print("\n================ LIVE RIDE INITIALIZED ================");
//     print("📦 Full ride data received: ${widget.rideData}");
//     print("📊 Stored local data:");
//     print("├─ Rider Name: $_riderName");
//     print("├─ Rider Phone: $_riderPhone");
//     print("├─ Total Fare: $_totalFare");
//     print("├─ Distance: $_distance");
//     print("├─ Ride ID: $_rideId");
//     print("└─ Order ID: $_orderId");

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       cancelRideController.cancelRideReasonIndex.value = -1;
//     });

//     if (pickupLatLng != null && dropLatLng != null) {
//       _setMarkers();
//     }

//     // Start auto-cancel timer
//     _startAutoCancelTimer();
//   }

//   void _extractAndStoreRideData() {
//     try {
//       // Store all data locally
//       _riderName = widget.rideData['riderName']?.toString() ?? 'Customer';
//       _riderPhone = widget.rideData['riderNumber']?.toString() ?? 'N/A';
//       _totalFare = widget.rideData['totalFare']?.toString() ?? '0';
//       _distance = widget.rideData['distance']?.toString() ?? '0';
//       _rideId = widget.rideData['rideId']?.toString() ?? widget.rideData['orderId']?.toString() ?? 'N/A';
//       _orderId = widget.rideData['orderId']?.toString() ?? 'N/A';
      
//       // Extract addresses with multiple fallbacks
//       _pickupAddress = widget.rideData['startLocation']?['address']?.toString() ??
//                       widget.rideData['pickup']?['address']?.toString() ??
//                       'Manikonda Jagir, Hyderabad, Telangana';
      
//       _dropAddress = widget.rideData['endLocation']?['address']?.toString() ??
//                     widget.rideData['destination']?['address']?.toString() ??
//                     widget.rideData['dropoff']?['address']?.toString() ??
//                     'Manikonda Jagir, Hyderabad, Telangana';
      
//       // Format date from timestamp
//       final timestamp = widget.rideData['timestamp'];
//       _formattedDate = timestamp != null 
//           ? _formatDateFromTimestamp(timestamp is String ? int.parse(timestamp) : timestamp)
//           : "30 August, 2025";

//       // Extract coordinates
//       _extractCoordinates();

//     } catch (e) {
//       print("❌ Error extracting ride data: $e");
//       // Set default values if extraction fails
//       _riderName = 'Customer';
//       _riderPhone = 'N/A';
//       _totalFare = '0';
//       _distance = '0';
//       _pickupAddress = 'Manikonda Jagir, Hyderabad, Telangana';
//       _dropAddress = 'Manikonda Jagir, Hyderabad, Telangana';
//       _formattedDate = "30 August, 2025";
//       _rideId = 'N/A';
//       _orderId = 'N/A';
//       pickupLatLng = const LatLng(17.4065, 78.4772);
//       dropLatLng = const LatLng(17.4120, 78.4850);
//     }
//   }

//   void _extractCoordinates() {
//     try {
//       print("📍 Extracting coordinates...");
      
//       // Extract pickup coordinates - check multiple possible keys
//       if (widget.rideData['pickup'] != null) {
//         final pickup = widget.rideData['pickup'];
//         pickupLatLng = LatLng(
//           pickup['latitude']?.toDouble() ?? 0.0,
//           pickup['longitude']?.toDouble() ?? 0.0,
//         );
//         print("📍 Pickup from 'pickup' key: $pickupLatLng");
//       } 
//       else if (widget.rideData['startLocation'] != null) {
//         final startLocation = widget.rideData['startLocation'];
//         if (startLocation['coordinates'] != null && startLocation['coordinates'].length >= 2) {
//           pickupLatLng = LatLng(
//             startLocation['coordinates'][1]?.toDouble() ?? 0.0,
//             startLocation['coordinates'][0]?.toDouble() ?? 0.0,
//           );
//           print("📍 Pickup from 'startLocation' coordinates: $pickupLatLng");
//         }
//         else if (startLocation['latitude'] != null && startLocation['longitude'] != null) {
//           pickupLatLng = LatLng(
//             startLocation['latitude']?.toDouble() ?? 0.0,
//             startLocation['longitude']?.toDouble() ?? 0.0,
//           );
//           print("📍 Pickup from 'startLocation' lat/lng: $pickupLatLng");
//         }
//       }

//       // Extract drop coordinates - check multiple possible keys
//       if (widget.rideData['destination'] != null) {
//         final destination = widget.rideData['destination'];
//         dropLatLng = LatLng(
//           destination['latitude']?.toDouble() ?? 0.0,
//           destination['longitude']?.toDouble() ?? 0.0,
//         );
//         print("📍 Drop from 'destination' key: $dropLatLng");
//       } 
//       else if (widget.rideData['endLocation'] != null) {
//         final endLocation = widget.rideData['endLocation'];
//         if (endLocation['coordinates'] != null && endLocation['coordinates'].length >= 2) {
//           dropLatLng = LatLng(
//             endLocation['coordinates'][1]?.toDouble() ?? 0.0,
//             endLocation['coordinates'][0]?.toDouble() ?? 0.0,
//           );
//           print("📍 Drop from 'endLocation' coordinates: $dropLatLng");
//         }
//         else if (endLocation['latitude'] != null && endLocation['longitude'] != null) {
//           dropLatLng = LatLng(
//             endLocation['latitude']?.toDouble() ?? 0.0,
//             endLocation['longitude']?.toDouble() ?? 0.0,
//           );
//           print("📍 Drop from 'endLocation' lat/lng: $dropLatLng");
//         }
//       }
//       else if (widget.rideData['dropoff'] != null) {
//         final dropoff = widget.rideData['dropoff'];
//         dropLatLng = LatLng(
//           dropoff['latitude']?.toDouble() ?? 0.0,
//           dropoff['longitude']?.toDouble() ?? 0.0,
//         );
//         print("📍 Drop from 'dropoff' key: $dropLatLng");
//       }

//       // Fallback coordinates if none found
//       if (pickupLatLng == null) {
//         pickupLatLng = const LatLng(17.4065, 78.4772);
//         print("⚠️ Using default pickup coordinates");
//       }
      
//       if (dropLatLng == null) {
//         dropLatLng = const LatLng(17.4120, 78.4850);
//         print("⚠️ Using default drop coordinates");
//       }

//       print("✅ Final coordinates - Pickup: $pickupLatLng, Drop: $dropLatLng");
      
//     } catch (e) {
//       print("❌ Error extracting coordinates: $e");
//       pickupLatLng = const LatLng(17.4065, 78.4772);
//       dropLatLng = const LatLng(17.4120, 78.4850);
//     }
//   }

//   @override
//   void dispose() {
//     // Cancel timer when widget is disposed
//     _autoCancelTimer?.cancel();
//     super.dispose();
//   }

//   void _startAutoCancelTimer() {
//     _autoCancelTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_secondsRemaining > 0 && _isTimerRunning) {
//         setState(() {
//           _secondsRemaining--;
//         });
//       } else if (_secondsRemaining <= 0 && _isTimerRunning && !_hasAccepted) {
//         // Auto-cancel after 10 seconds
//         timer.cancel();
//         _autoCancelRide();
//       }
//     });
//   }

//   Future<void> _autoCancelRide() async {
//     if (_hasCancelled || _hasAccepted) return;
    
//     _hasCancelled = true;
//     _isTimerRunning = false;
    
//     print("⏰ Auto-cancelling ride after 10 seconds...");
    
//     await OrderService.declineOrder(orderId: _orderId);
    
//     // Navigate back or show message
//     if (mounted) {
//       Get.back(); // Navigate back to previous screen
//       Get.snackbar(
//         'Ride Auto-Cancelled',
//         'You did not accept the ride in time',
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//     }
//   }

//   void _setMarkers() {
//     if (pickupLatLng != null) {
//       _markers.add(Marker(
//         markerId: const MarkerId("pickup"),
//         position: pickupLatLng!,
//         infoWindow: const InfoWindow(title: "Pickup Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//       ));
//     }

//     if (dropLatLng != null) {
//       _markers.add(Marker(
//         markerId: const MarkerId("drop"),
//         position: dropLatLng!,
//         infoWindow: const InfoWindow(title: "Drop Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       ));
//     }
//   }

//   void _fitMapToMarkers() async {
//     if (_mapController == null || pickupLatLng == null || dropLatLng == null) {
//       return;
//     }

//     LatLngBounds bounds;
//     if (pickupLatLng!.latitude > dropLatLng!.latitude &&
//         pickupLatLng!.longitude > dropLatLng!.longitude) {
//       bounds = LatLngBounds(southwest: dropLatLng!, northeast: pickupLatLng!);
//     } else if (pickupLatLng!.longitude > dropLatLng!.longitude) {
//       bounds = LatLngBounds(
//         southwest: LatLng(pickupLatLng!.latitude, dropLatLng!.longitude),
//         northeast: LatLng(dropLatLng!.latitude, pickupLatLng!.longitude),
//       );
//     } else if (pickupLatLng!.latitude > dropLatLng!.latitude) {
//       bounds = LatLngBounds(
//         southwest: LatLng(dropLatLng!.latitude, pickupLatLng!.longitude),
//         northeast: LatLng(pickupLatLng!.latitude, dropLatLng!.longitude),
//       );
//     } else {
//       bounds = LatLngBounds(southwest: pickupLatLng!, northeast: dropLatLng!);
//     }

//     CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
//     _mapController!.animateCamera(cameraUpdate);
//   }

//   // Helper method to format timestamp
//   String _formatDateFromTimestamp(int timestamp) {
//     try {
//       final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
//       return "${date.day} ${_getMonthName(date.month)}, ${date.year}";
//     } catch (e) {
//       return "30 August, 2025"; // Default fallback
//     }
//   }

//   String _getMonthName(int month) {
//     const months = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return months[month - 1];
//   }

//   Future<void> _acceptRide() async {
//     if (_hasAccepted || _hasCancelled) return;
    
//     _hasAccepted = true;
//     _isTimerRunning = false;
//     _autoCancelTimer?.cancel();
    
//     print("🚗 Accepting ride with ID: $_orderId");

//     stepperController.resetSteps();
    
//     await orderUpdateController.update_order_method(orderstatus: "Accepted", orderid: _orderId);
    
//     CustomNavigator.push(
//       context,
//       ArrivingClient(
//         rideData: widget.rideData,
//       ),
//       transition: TransitionType.slideLeft,
//     );
//   }

//   Future<void> _cancelRide() async {
//     if (_hasCancelled || _hasAccepted) return;
    
//     _hasCancelled = true;
//     _isTimerRunning = false;
//     _autoCancelTimer?.cancel();
    
//     await OrderService.declineOrder(orderId: _orderId);
    
//     Get.back(); // Navigate back
//     Get.snackbar(
//       'Ride Cancelled',
//       'You have cancelled the ride',
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double w = MediaQuery.of(context).size.width;

//     // Debug: Print current values
//     print("\n🎨 BUILDING LiveRide WIDGET 🎨");
//     print("📊 Using local stored data:");
//     print("├─ riderName: $_riderName");
//     print("├─ riderPhone: $_riderPhone");
//     print("├─ totalFare: $_totalFare");
//     print("├─ distance: $_distance");
//     print("├─ pickupAddress: $_pickupAddress");
//     print("├─ dropAddress: $_dropAddress");
//     print("└─ formattedDate: $_formattedDate");

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(w * 0.04),
//           child: Column(
//             children: [
//               // Timer display
//               _timerWidget(context, w),
//               SizedBox(height: w * 0.02),
//               _dateText(context, w, _formattedDate),
//               SizedBox(height: w * 0.02),
//               _fareCard(context, w, _riderName, _totalFare, _riderPhone, _rideId, _orderId),
//               SizedBox(height: w * 0.03),
//               _mapView(w),
//               SizedBox(height: w * 0.04),
//               _locationInfo(context, w, _pickupAddress, _dropAddress),
//               SizedBox(height: w * 0.04),
//               _distanceCard(context, w, _distance),
//               SizedBox(height: w * 0.03),
//               _actionButtons(context, w),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _timerWidget(BuildContext context, double w) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
//       decoration: BoxDecoration(
//         color: _secondsRemaining <= 3 ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(w * 0.02),
//         border: Border.all(
//           color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.timer,
//             size: w * 0.05,
//             color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
//           ),
//           SizedBox(width: w * 0.02),
//           Text(
//             'Auto-cancel in: $_secondsRemaining seconds',
//             style: TextStyle(
//               fontSize: w * 0.04,
//               fontWeight: FontWeight.w600,
//               color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _dateText(BuildContext context, double w, String date) {
//     return AppFonts.textPoppins(
//       context,
//       date,
//       w * 0.04,
//       FontWeight.w500,
//       const Color(0xFF5F6165),
//       TextAlign.center,
//       TextOverflow.visible,
//     );
//   }

//   Widget _fareCard(BuildContext context, double w, String riderName, String totalFare, String riderPhone, String rideId, String orderId) {
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Image.asset(
//                 "assets/images/profil.png",
//                 height: w * 0.12,
//                 width: w * 0.12,
//               ),
//               SizedBox(width: w * 0.04),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       riderName,
//                       w * 0.048,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.start,
//                       TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: w * 0.01),
//                     AppFonts.textPoppins(
//                       context,
//                       riderPhone,
//                       w * 0.035,
//                       FontWeight.w500,
//                       AppColors.mediumGray,
//                       TextAlign.start,
//                       TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.currency_rupee, color: AppColors.green, size: w * 0.065),
//                       AppFonts.textPoppins(
//                         context,
//                         totalFare,
//                         w * 0.055,
//                         FontWeight.w600,
//                         AppColors.green,
//                         TextAlign.center,
//                         TextOverflow.visible,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: w * 0.01),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.01),
//                     decoration: BoxDecoration(
//                       color: AppColors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(w * 0.02),
//                     ),
//                     child: AppFonts.textPoppins(
//                       context,
//                       widget.rideData['rideType']?.toString().toUpperCase() ?? 'IMMEDIATE',
//                       w * 0.03,
//                       FontWeight.w600,
//                       AppColors.green,
//                       TextAlign.center,
//                       TextOverflow.visible,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: w * 0.02),
//           // Additional ride info
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _rideInfoItem(context, w, "Ride ID", rideId),
//               _rideInfoItem(context, w, "Order ID", orderId),
//             ],
//           ),
//         ],
//       ),
//     ).animate().fade(duration: 700.ms).scale();
//   }

//   Widget _rideInfoItem(BuildContext context, double w, String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppFonts.textPoppins(
//           context,
//           title,
//           w * 0.03,
//           FontWeight.w500,
//           AppColors.mediumGray,
//           TextAlign.start,
//           TextOverflow.ellipsis,
//         ),
//         SizedBox(height: w * 0.005),
//         AppFonts.textPoppins(
//           context,
//           value,
//           w * 0.035,
//           FontWeight.w600,
//           AppColors.black,
//           TextAlign.start,
//           TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }

//   Widget _mapView(double w) {
//     final initialPosition = pickupLatLng ?? const LatLng(17.4065, 78.4772);
    
//     return SizedBox(
//       height: w * 0.95,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(w * 0.03),
//         child: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: initialPosition,
//             zoom: 14.5,
//           ),
//           myLocationEnabled: true,
//           zoomControlsEnabled: false,
//           markers: _markers,
//           onMapCreated: (GoogleMapController controller) {
//             _mapController = controller;
//             if (pickupLatLng != null && dropLatLng != null) {
//               _fitMapToMarkers(); // fit camera to both markers
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _locationInfo(BuildContext context, double w, String pickupAddress, String dropAddress) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Location",
//               style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w500),
//             ),
//             Text.rich(
//               TextSpan(
//                 text: "Time ",
//                 style: TextStyle(
//                   fontSize: w * 0.029,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF7C7C8D),
//                 ),
//                 children: [
//                   TextSpan(
//                     text: "10 min",
//                     style: TextStyle(
//                       fontSize: w * 0.04,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 CustomImages.images(
//                   "assets/icons/greenDot.png",
//                   w * 0.05,
//                   w * 0.05,
//                 ),
//                 SizedBox(
//                   height: w * 0.1,
//                   child: DottedLine(
//                     direction: Axis.vertical,
//                     dashLength: 4,
//                     dashColor: AppColors.green,
//                   ),
//                 ),
//                 CustomImages.images(
//                   "assets/icons/redDot.png",
//                   w * 0.05,
//                   w * 0.05,
//                 ),
//               ],
//             ),
//             SizedBox(width: w * 0.03),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _locationText(
//                     context,
//                     "Pickup",
//                     pickupAddress,
//                   ),
//                   SizedBox(height: w * 0.05),
//                   _locationText(
//                     context,
//                     "Drop",
//                     dropAddress,
//                   ),
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
//           maxLines: 2,
//         ),
//       ],
//     );
//   }

//   Widget _distanceCard(BuildContext context, double w, String distance) {
//     // Calculate pickup and drop distances
//     final pickupDistance = "${widget.rideData['driverDistance']?.toString() ?? '1.1'} Km";
//     final dropDistance = "$distance Km";

//     return SizedBox(
//       height: w * 0.18,
//       child: Row(
//         children: [
//           _distanceItem(context, w, "Pickup", pickupDistance),
//           SizedBox(width: w * 0.03),
//           _distanceItem(context, w, "Drop", dropDistance),
//           SizedBox(width: w * 0.03),
//           _distanceItem(context, w, "Fare", "₹${_totalFare}"),
//         ],
//       ),
//     ).animate().fade(duration: 700.ms).scale();
//   }

//   Widget _distanceItem(BuildContext context, double w, String title, String value) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           vertical: w * 0.02,
//           horizontal: w * 0.02,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(w * 0.025),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//           border: Border.all(
//             color: AppColors.mediumGray.withOpacity(0.3),
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AppFonts.textPoppins(
//               context,
//               title,
//               w * 0.037,
//               FontWeight.w600,
//               AppColors.mediumGray,
//               TextAlign.center,
//               TextOverflow.visible,
//             ),
//             AppFonts.textPoppins(
//               context,
//               value,
//               w * 0.042,
//               FontWeight.bold,
//               AppColors.black,
//               TextAlign.center,
//               TextOverflow.visible,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _actionButtons(BuildContext context, double w) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Cancel Button
//         ElevatedButton(
//           onPressed: _hasAccepted || _hasCancelled ? null : _cancelRide,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.lightGray,
//             foregroundColor: AppColors.mediumGray,
//             minimumSize: Size(w * 0.43, w * 0.14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//               side: BorderSide(color: AppColors.mediumGray.withOpacity(0.5)),
//             ),
//             elevation: 0,
//             disabledBackgroundColor: AppColors.lightGray.withOpacity(0.5),
//             disabledForegroundColor: AppColors.mediumGray.withOpacity(0.5),
//           ),
//           child: Text(
//             "Cancel",
//             style: TextStyle(
//               fontSize: w * 0.045,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),

//         // Accept Button
//         ElevatedButton(
//           onPressed: _hasAccepted || _hasCancelled ? null : _acceptRide,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: ColorsList.mainButtonColor,
//             foregroundColor: ColorsList.mainButtonTextColor,
//             minimumSize: Size(w * 0.43, w * 0.14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             elevation: 2,
//             shadowColor: ColorsList.mainButtonColor.withOpacity(0.3),
//             disabledBackgroundColor: ColorsList.mainButtonColor.withOpacity(0.5),
//             disabledForegroundColor: ColorsList.mainButtonTextColor.withOpacity(0.5),
//           ),
//           child: Text(
//             "Accept",
//             style: TextStyle(
//               fontSize: w * 0.045,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class OrderService {
//   static Future<void> declineOrder({
//     String? orderId,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString("auth_token");
//     final String? order_id = prefs.getString("order_id");

//     print("my___token_here ${token}");
//     print("declineddddd__myyyyy_orderid_iss ${orderId}");

//     final Uri url = Uri.parse(
//       "https://corezap.smarttechbros.com/api/v1/order/decline/$order_id",
//     );

//     print("🔵 DECLINE ORDER API");
//     print("URL : $url");

//     try {
//       final response = await http.patch(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );

//       print("✅ Status Code : ${response.statusCode}");
//       print("📦 Raw Response : ${response.body}");

//       final decoded = jsonDecode(response.body);
//       print("🎯 Decoded Response : $decoded");
      
//       Fluttertoast.showToast(
//         msg: decoded['message'] ?? "Ride declined successfully",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//       );
//     } catch (e) {
//       print("❌ Error declining order : $e");
//     }
//   }


  //   static Future<void> VerifyOtpOrder({
  //   required String orderId,
  //   required String rideOtpEnter,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString("auth_token");

  //   final String? order_id = prefs.getString("order_id");

  //   print("my___token_here ${token}");
  //   print("myyyyy_orderid_iss in verifyOtpppp>>>>> ${order_id}");

  //   final Uri url = Uri.parse(
  //     "https://corezap.smarttechbros.com/api/v1/order/verifyOtp",
  //   );

  //   print("🔵 ACCEPT ORDER API");
  //   print("URL : $url");

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         "orderId": order_id,
  //         "rideOtp": rideOtpEnter
  //       }),
  //     );

  //     print("arriivinngggggggggggggggggggggggg");
  //     print("✅ Status Code : ${response.statusCode}");
  //     print("📦 Raw Response arrivinggggggggg : ${response.body}");
  //     print("arriivinngggggggggggggggggggggggg");

  //     final decoded = jsonDecode(response.body);
  //     print("🎯 Decoded Response : $decoded");
  //   } catch (e) {
  //     print("❌ Error accepting order : $e");
  //   }
  // }
// }


import 'package:corezap_driver/controllers/controllers.dart';
import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/bottom_Sheets/custom_bottom_sheets.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LiveRide extends StatefulWidget {
  final Map<String, dynamic> rideData;
  
  const LiveRide({super.key, required this.rideData});

  @override
  State<LiveRide> createState() => _LiveRideState();
}

class _LiveRideState extends State<LiveRide> {
  final StepperController stepperController = Get.find();
  final Controllers cancelRideController = Get.find();
  final OrderUpdateController orderUpdateController = Get.find<OrderUpdateController>();

  // Pickup & Drop LatLng
  LatLng? pickupLatLng;
  LatLng? dropLatLng;

  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  // Timer for auto-cancel
  Timer? _autoCancelTimer;
  int _secondsRemaining = 10;
  bool _isTimerRunning = true;
  bool _hasAccepted = false;
  bool _hasCancelled = false;

  // Local variables to store ride data
  late String _riderName;
  late String _riderPhone;
  late String _totalFare;
  late String _distance;
  late String _pickupAddress;
  late String _dropAddress;
  late String _formattedDate;
  late String _rideId;
  late String _orderId;

  @override
  void initState() {
    super.initState();

    // Extract and store ride data locally
    _extractAndStoreRideData();

    // Print received data for debugging
    print("\n================ LIVE RIDE INITIALIZED ================");
    print("📦 Full ride data received: ${widget.rideData}");
    print("📊 Stored local data:");
    print("├─ Rider Name: $_riderName");
    print("├─ Rider Phone: $_riderPhone");
    print("├─ Total Fare: $_totalFare");
    print("├─ Distance: $_distance");
    print("├─ Ride ID: $_rideId");
    print("└─ Order ID: $_orderId");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cancelRideController.cancelRideReasonIndex.value = -1;
    });

    if (pickupLatLng != null && dropLatLng != null) {
      _setMarkers();
    }

    // Start auto-cancel timer
    _startAutoCancelTimer();
  }

  void _extractAndStoreRideData() {
    try {
      // Store all data locally
      _riderName = widget.rideData['riderName']?.toString() ?? 'Customer';
      _riderPhone = widget.rideData['riderNumber']?.toString() ?? 'N/A';
      _totalFare = widget.rideData['totalFare']?.toString() ?? '0';
      _distance = widget.rideData['distance']?.toString() ?? '0';
      _rideId = widget.rideData['rideId']?.toString() ?? widget.rideData['orderId']?.toString() ?? 'N/A';
      _orderId = widget.rideData['orderId']?.toString() ?? 'N/A';
      
      // Extract addresses with multiple fallbacks
      _pickupAddress = widget.rideData['startLocation']?['address']?.toString() ??
                      widget.rideData['pickup']?['address']?.toString() ??
                      'Manikonda Jagir, Hyderabad, Telangana';
      
      _dropAddress = widget.rideData['endLocation']?['address']?.toString() ??
                    widget.rideData['destination']?['address']?.toString() ??
                    widget.rideData['dropoff']?['address']?.toString() ??
                    'Manikonda Jagir, Hyderabad, Telangana';
      
      // Format date from timestamp
      final timestamp = widget.rideData['timestamp'];
      _formattedDate = timestamp != null 
          ? _formatDateFromTimestamp(timestamp is String ? int.parse(timestamp) : timestamp)
          : "30 August, 2025";

      // Extract coordinates
      _extractCoordinates();

    } catch (e) {
      print("❌ Error extracting ride data: $e");
      // Set default values if extraction fails
      _riderName = 'Customer';
      _riderPhone = 'N/A';
      _totalFare = '0';
      _distance = '0';
      _pickupAddress = 'Manikonda Jagir, Hyderabad, Telangana';
      _dropAddress = 'Manikonda Jagir, Hyderabad, Telangana';
      _formattedDate = "30 August, 2025";
      _rideId = 'N/A';
      _orderId = 'N/A';
      pickupLatLng = const LatLng(17.4065, 78.4772);
      dropLatLng = const LatLng(17.4120, 78.4850);
    }
  }

  void _extractCoordinates() {
    try {
      print("📍 Extracting coordinates...");
      
      // Extract pickup coordinates - check multiple possible keys
      if (widget.rideData['pickup'] != null) {
        final pickup = widget.rideData['pickup'];
        pickupLatLng = LatLng(
          pickup['latitude']?.toDouble() ?? 0.0,
          pickup['longitude']?.toDouble() ?? 0.0,
        );
        print("📍 Pickup from 'pickup' key: $pickupLatLng");
      } 
      else if (widget.rideData['startLocation'] != null) {
        final startLocation = widget.rideData['startLocation'];
        if (startLocation['coordinates'] != null && startLocation['coordinates'].length >= 2) {
          pickupLatLng = LatLng(
            startLocation['coordinates'][1]?.toDouble() ?? 0.0,
            startLocation['coordinates'][0]?.toDouble() ?? 0.0,
          );
          print("📍 Pickup from 'startLocation' coordinates: $pickupLatLng");
        }
        else if (startLocation['latitude'] != null && startLocation['longitude'] != null) {
          pickupLatLng = LatLng(
            startLocation['latitude']?.toDouble() ?? 0.0,
            startLocation['longitude']?.toDouble() ?? 0.0,
          );
          print("📍 Pickup from 'startLocation' lat/lng: $pickupLatLng");
        }
      }

      // Extract drop coordinates - check multiple possible keys
      if (widget.rideData['destination'] != null) {
        final destination = widget.rideData['destination'];
        dropLatLng = LatLng(
          destination['latitude']?.toDouble() ?? 0.0,
          destination['longitude']?.toDouble() ?? 0.0,
        );
        print("📍 Drop from 'destination' key: $dropLatLng");
      } 
      else if (widget.rideData['endLocation'] != null) {
        final endLocation = widget.rideData['endLocation'];
        if (endLocation['coordinates'] != null && endLocation['coordinates'].length >= 2) {
          dropLatLng = LatLng(
            endLocation['coordinates'][1]?.toDouble() ?? 0.0,
            endLocation['coordinates'][0]?.toDouble() ?? 0.0,
          );
          print("📍 Drop from 'endLocation' coordinates: $dropLatLng");
        }
        else if (endLocation['latitude'] != null && endLocation['longitude'] != null) {
          dropLatLng = LatLng(
            endLocation['latitude']?.toDouble() ?? 0.0,
            endLocation['longitude']?.toDouble() ?? 0.0,
          );
          print("📍 Drop from 'endLocation' lat/lng: $dropLatLng");
        }
      }
      else if (widget.rideData['dropoff'] != null) {
        final dropoff = widget.rideData['dropoff'];
        dropLatLng = LatLng(
          dropoff['latitude']?.toDouble() ?? 0.0,
          dropoff['longitude']?.toDouble() ?? 0.0,
        );
        print("📍 Drop from 'dropoff' key: $dropLatLng");
      }

      // Fallback coordinates if none found
      if (pickupLatLng == null) {
        pickupLatLng = const LatLng(17.4065, 78.4772);
        print("⚠️ Using default pickup coordinates");
      }
      
      if (dropLatLng == null) {
        dropLatLng = const LatLng(17.4120, 78.4850);
        print("⚠️ Using default drop coordinates");
      }

      print("✅ Final coordinates - Pickup: $pickupLatLng, Drop: $dropLatLng");
      
    } catch (e) {
      print("❌ Error extracting coordinates: $e");
      pickupLatLng = const LatLng(17.4065, 78.4772);
      dropLatLng = const LatLng(17.4120, 78.4850);
    }
  }

  @override
  void dispose() {
    // Cancel timer when widget is disposed
    _autoCancelTimer?.cancel();
    super.dispose();
  }

  void _startAutoCancelTimer() {
    _autoCancelTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0 && _isTimerRunning) {
        setState(() {
          _secondsRemaining--;
        });
      } else if (_secondsRemaining <= 0 && _isTimerRunning && !_hasAccepted) {
        // Auto-cancel after 10 seconds
        timer.cancel();
        _autoCancelRide();
      }
    });
  }

  Future<void> _autoCancelRide() async {
    if (_hasCancelled || _hasAccepted) return;
    
    _hasCancelled = true;
    _isTimerRunning = false;
    
    print("⏰ Auto-cancelling ride after 10 seconds...");
    
    await OrderService.declineOrder(orderId: _orderId);
    
    // Navigate back or show message
    if (mounted) {
      Get.back(); // Navigate back to previous screen
      Get.snackbar(
        'Ride Auto-Cancelled',
        'You did not accept the ride in time',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _setMarkers() {
    if (pickupLatLng != null) {
      _markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: pickupLatLng!,
        infoWindow: const InfoWindow(title: "Pickup Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    if (dropLatLng != null) {
      _markers.add(Marker(
        markerId: const MarkerId("drop"),
        position: dropLatLng!,
        infoWindow: const InfoWindow(title: "Drop Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
  }

  void _fitMapToMarkers() async {
    if (_mapController == null || pickupLatLng == null || dropLatLng == null) {
      return;
    }

    LatLngBounds bounds;
    if (pickupLatLng!.latitude > dropLatLng!.latitude &&
        pickupLatLng!.longitude > dropLatLng!.longitude) {
      bounds = LatLngBounds(southwest: dropLatLng!, northeast: pickupLatLng!);
    } else if (pickupLatLng!.longitude > dropLatLng!.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng!.latitude, dropLatLng!.longitude),
        northeast: LatLng(dropLatLng!.latitude, pickupLatLng!.longitude),
      );
    } else if (pickupLatLng!.latitude > dropLatLng!.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(dropLatLng!.latitude, pickupLatLng!.longitude),
        northeast: LatLng(pickupLatLng!.latitude, dropLatLng!.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: pickupLatLng!, northeast: dropLatLng!);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    _mapController!.animateCamera(cameraUpdate);
  }

  // Helper method to format timestamp
  String _formatDateFromTimestamp(int timestamp) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return "${date.day} ${_getMonthName(date.month)}, ${date.year}";
    } catch (e) {
      return "30 August, 2025"; // Default fallback
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Future<void> _acceptRide() async {
    if (_hasAccepted || _hasCancelled) return;
    
    _hasAccepted = true;
    _isTimerRunning = false;
    _autoCancelTimer?.cancel();
    
    print("🚗 Accepting ride with ID: $_orderId");

    stepperController.resetSteps();
    
    await orderUpdateController.update_order_method(orderstatus: "Accepted", orderid: _orderId);
    
    CustomNavigator.push(
      context,
      ArrivingClient(
        rideData: widget.rideData,
      ),
      transition: TransitionType.slideLeft,
    );
  }

  Future<void> _cancelRide() async {
    if (_hasCancelled || _hasAccepted) return;
    
    _hasCancelled = true;
    _isTimerRunning = false;
    _autoCancelTimer?.cancel();
    
    await OrderService.declineOrder(orderId: _orderId);
    
    Get.back(); // Navigate back
    Get.snackbar(
      'Ride Cancelled',
      'You have cancelled the ride',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    // Debug: Print current values
    print("\n🎨 BUILDING LiveRide WIDGET 🎨");
    print("📊 Using local stored data:");
    print("├─ riderName: $_riderName");
    print("├─ riderPhone: $_riderPhone");
    print("├─ totalFare: $_totalFare");
    print("├─ distance: $_distance");
    print("├─ pickupAddress: $_pickupAddress");
    print("├─ dropAddress: $_dropAddress");
    print("└─ formattedDate: $_formattedDate");

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            children: [
              // REMOVED TIMER WIDGET FROM HERE
              // _timerWidget(context, w),
              // SizedBox(height: w * 0.02),
              _dateText(context, w, _formattedDate),
              SizedBox(height: w * 0.02),
              _fareCard(context, w, _riderName, _totalFare, _riderPhone, _rideId, _orderId),
              SizedBox(height: w * 0.03),
              _mapView(w),
              SizedBox(height: w * 0.04),
              _locationInfo(context, w, _pickupAddress, _dropAddress),
              SizedBox(height: w * 0.04),
              _distanceCard(context, w, _distance),
              SizedBox(height: w * 0.03),
              _actionButtons(context, w),
            ],
          ),
        ),
      ),
    );
  }

  // REMOVED THE SEPARATE _timerWidget METHOD SINCE IT'S NOW PART OF _actionButtons

  Widget _dateText(BuildContext context, double w, String date) {
    return AppFonts.textPoppins(
      context,
      date,
      w * 0.04,
      FontWeight.w500,
      const Color(0xFF5F6165),
      TextAlign.center,
      TextOverflow.visible,
    );
  }

  Widget _fareCard(BuildContext context, double w, String riderName, String totalFare, String riderPhone, String rideId, String orderId) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/profil.png",
                height: w * 0.12,
                width: w * 0.12,
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFonts.textPoppins(
                      context,
                      riderName,
                      w * 0.048,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.start,
                      TextOverflow.ellipsis,
                    ),
                    SizedBox(height: w * 0.01),
                    AppFonts.textPoppins(
                      context,
                      riderPhone,
                      w * 0.035,
                      FontWeight.w500,
                      AppColors.mediumGray,
                      TextAlign.start,
                      TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, color: AppColors.green, size: w * 0.065),
                      AppFonts.textPoppins(
                        context,
                        totalFare,
                        w * 0.055,
                        FontWeight.w600,
                        AppColors.green,
                        TextAlign.center,
                        TextOverflow.visible,
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.01),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.01),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    child: AppFonts.textPoppins(
                      context,
                      widget.rideData['rideType']?.toString().toUpperCase() ?? 'IMMEDIATE',
                      w * 0.03,
                      FontWeight.w600,
                      AppColors.green,
                      TextAlign.center,
                      TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: w * 0.02),
          // Additional ride info
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     _rideInfoItem(context, w, "Ride ID", rideId),
          //     _rideInfoItem(context, w, "Order ID", orderId),
          //   ],
          // ),
        ],
      ),
    ).animate().fade(duration: 700.ms).scale();
  }

  Widget _rideInfoItem(BuildContext context, double w, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFonts.textPoppins(
          context,
          title,
          w * 0.03,
          FontWeight.w500,
          AppColors.mediumGray,
          TextAlign.start,
          TextOverflow.ellipsis,
        ),
        SizedBox(height: w * 0.005),
        AppFonts.textPoppins(
          context,
          value,
          w * 0.035,
          FontWeight.w600,
          AppColors.black,
          TextAlign.start,
          TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _mapView(double w) {
    final initialPosition = pickupLatLng ?? const LatLng(17.4065, 78.4772);
    
    return SizedBox(
      height: w * 0.95,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(w * 0.03),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 14.5,
          ),
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            if (pickupLatLng != null && dropLatLng != null) {
              _fitMapToMarkers(); // fit camera to both markers
            }
          },
        ),
      ),
    );
  }

  Widget _locationInfo(BuildContext context, double w, String pickupAddress, String dropAddress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Location",
              style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w500),
            ),
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
                    pickupAddress,
                  ),
                  SizedBox(height: w * 0.05),
                  _locationText(
                    context,
                    "Drop",
                    dropAddress,
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
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _distanceCard(BuildContext context, double w, String distance) {
    // Calculate pickup and drop distances
    final pickupDistance = "${widget.rideData['driverDistance']?.toString() ?? '1.1'} Km";
    final dropDistance = "$distance Km";

    return SizedBox(
      height: w * 0.18,
      child: Row(
        children: [
          _distanceItem(context, w, "Pickup", pickupDistance),
          SizedBox(width: w * 0.03),
          _distanceItem(context, w, "Drop", dropDistance),
          SizedBox(width: w * 0.03),
          _distanceItem(context, w, "Fare", "₹${_totalFare}"),
        ],
      ),
    ).animate().fade(duration: 700.ms).scale();
  }

  Widget _distanceItem(BuildContext context, double w, String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: w * 0.02,
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
              title,
              w * 0.037,
              FontWeight.w600,
              AppColors.mediumGray,
              TextAlign.center,
              TextOverflow.visible,
            ),
            AppFonts.textPoppins(
              context,
              value,
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
  }

  Widget _actionButtons(BuildContext context, double w) {
    return Column(
      children: [
        // Timer display above buttons
        Container(
          margin: EdgeInsets.only(bottom: w * 0.03),
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
          decoration: BoxDecoration(
            color: _secondsRemaining <= 3 ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(w * 0.02),
            border: Border.all(
              color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer,
                size: w * 0.05,
                color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
              ),
              SizedBox(width: w * 0.02),
              Text(
                'Accept within: $_secondsRemaining seconds',
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w600,
                  color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
                ),
              ),
            ],
          ),
        ),
        
        // Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel Button
            Expanded(
              child: ElevatedButton(
                onPressed: _hasAccepted || _hasCancelled ? null : _cancelRide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGray,
                  foregroundColor: AppColors.mediumGray,
                  minimumSize: Size(w * 0.43, w * 0.14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.mediumGray.withOpacity(0.5)),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: AppColors.lightGray.withOpacity(0.5),
                  disabledForegroundColor: AppColors.mediumGray.withOpacity(0.5),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: w * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(width: w * 0.03),

            // Accept Button with timer integration
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: _secondsRemaining <= 3 
                      ? Border.all(color: Colors.red, width: 2)
                      : _secondsRemaining <= 6
                      ? Border.all(color: Colors.orange, width: 2)
                      : null,
                ),
                child: ElevatedButton(
                  onPressed: _hasAccepted || _hasCancelled ? null : _acceptRide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondsRemaining <= 3 
                        ? Colors.red 
                        : _secondsRemaining <= 6
                        ? Colors.orange
                        : ColorsList.mainButtonColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(w * 0.43, w * 0.14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    shadowColor: ColorsList.mainButtonColor.withOpacity(0.3),
                    disabledBackgroundColor: ColorsList.mainButtonColor.withOpacity(0.5),
                    disabledForegroundColor: Colors.white.withOpacity(0.5),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Accept Ride",
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: w * 0.005),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            size: w * 0.03,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          SizedBox(width: w * 0.01),
                          Text(
                            "$_secondsRemaining s",
                            style: TextStyle(
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrderService {
  static Future<void> declineOrder({
    String? orderId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final String? order_id = prefs.getString("order_id");

    print("my___token_here ${token}");
    print("declineddddd__myyyyy_orderid_iss ${orderId}");

    final Uri url = Uri.parse(
      "https://corezap.smarttechbros.com/api/v1/order/decline/$order_id",
    );

    print("🔵 DECLINE ORDER API");
    print("URL : $url");

    try {
      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("✅ Status Code : ${response.statusCode}");
      print("📦 Raw Response : ${response.body}");

      final decoded = jsonDecode(response.body);
      print("🎯 Decoded Response : $decoded");
      
      Fluttertoast.showToast(
        msg: decoded['message'] ?? "Ride declined successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print("❌ Error declining order : $e");
    }
  }


      static Future<void> VerifyOtpOrder({
    required String orderId,
    required String rideOtpEnter,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? order_id = prefs.getString("order_id");

    print("my___token_here ${token}");
    print("myyyyy_orderid_iss in verifyOtpppp>>>>> ${order_id}");

    final Uri url = Uri.parse(
      "https://corezap.smarttechbros.com/api/v1/order/verifyOtp",
    );

    print("🔵 ACCEPT ORDER API");
    print("URL : $url");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "orderId": order_id,
          "rideOtp": rideOtpEnter
        }),
      );

      print("arriivinngggggggggggggggggggggggg");
      print("✅ Status Code : ${response.statusCode}");
      print("📦 Raw Response arrivinggggggggg : ${response.body}");
      print("arriivinngggggggggggggggggggggggg");

      final decoded = jsonDecode(response.body);
      print("🎯 Decoded Response : $decoded");
    } catch (e) {
      print("❌ Error accepting order : $e");
    }
  }
}