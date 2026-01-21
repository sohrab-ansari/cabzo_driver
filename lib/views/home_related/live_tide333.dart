


// import 'package:corezap_driver/controllers/controllers.dart';
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
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

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

//   // Pickup & Drop LatLng
//   LatLng? pickupLatLng;
//   LatLng? dropLatLng;

//   final Set<Marker> _markers = {};

//   GoogleMapController? _mapController;

//   @override
//   void initState() {
//     super.initState();

//     // Print received data for debugging
//     print("================ LIVE RIDE DATA ================");
//     print("Full ride data received in LiveRide: ${widget.rideData}");
    
//     // Extract data from rideData
//     _extractRideData();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       cancelRideController.cancelRideReasonIndex.value = -1;
//     });

//     if (pickupLatLng != null && dropLatLng != null) {
//       _setMarkers();
//     }
//   }

//   void _extractRideData() {
//     try {
//       // Extract pickup coordinates
//       if (widget.rideData['pickup'] != null) {
//         final pickup = widget.rideData['pickup'];
//         pickupLatLng = LatLng(
//           pickup['latitude']?.toDouble() ?? 0.0,
//           pickup['longitude']?.toDouble() ?? 0.0,
//         );
//       } else if (widget.rideData['startLocation'] != null) {
//         final startLocation = widget.rideData['startLocation'];
//         if (startLocation['coordinates'] != null &&
//             startLocation['coordinates'].length >= 2) {
//           pickupLatLng = LatLng(
//             startLocation['coordinates'][1]?.toDouble() ?? 0.0,
//             startLocation['coordinates'][0]?.toDouble() ?? 0.0,
//           );
//         }
//       }

//       // Extract drop coordinates
//       if (widget.rideData['destination'] != null) {
//         final destination = widget.rideData['destination'];
//         dropLatLng = LatLng(
//           destination['latitude']?.toDouble() ?? 0.0,
//           destination['longitude']?.toDouble() ?? 0.0,
//         );
//       } else if (widget.rideData['endLocation'] != null) {
//         final endLocation = widget.rideData['endLocation'];
//         if (endLocation['coordinates'] != null &&
//             endLocation['coordinates'].length >= 2) {
//           dropLatLng = LatLng(
//             endLocation['coordinates'][1]?.toDouble() ?? 0.0,
//             endLocation['coordinates'][0]?.toDouble() ?? 0.0,
//           );
//         }
//       } else if (widget.rideData['dropoff'] != null) {
//         final dropoff = widget.rideData['dropoff'];
//         dropLatLng = LatLng(
//           dropoff['latitude']?.toDouble() ?? 0.0,
//           dropoff['longitude']?.toDouble() ?? 0.0,
//         );
//       }

//       print("Pickup LatLng: $pickupLatLng");
//       print("Drop LatLng: $dropLatLng");
//       print("==============================================");
//     } catch (e) {
//       print("Error extracting ride data: $e");
//       // Set default values if extraction fails
//       pickupLatLng = const LatLng(17.4065, 78.4772);
//       dropLatLng = const LatLng(17.4120, 78.4850);
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

//   @override
//   Widget build(BuildContext context) {
//     final double w = MediaQuery.of(context).size.width;

//     // Extract ride information with null safety
//     final riderName = widget.rideData['riderName']?.toString() ?? 'Rohan';
//     final riderPhone = widget.rideData['riderNumber']?.toString() ?? 'N/A';
//     final totalFare = widget.rideData['totalFare']?.toString() ?? '100.0';
//     final distance = widget.rideData['distance']?.toString() ?? '0';
//     final rideType = widget.rideData['rideType']?.toString() ?? 'immediate';
    
//     // Extract addresses
//     final pickupAddress = widget.rideData['startLocation']?['address']?.toString() ?? 
//                          'Manikonda Jagir, Hyderabad, Telangana';
//     final dropAddress = widget.rideData['endLocation']?['address']?.toString() ?? 
//                        'Manikonda Jagir, Hyderabad, Telangana';
    
//     // Format date from timestamp
//     final timestamp = widget.rideData['timestamp'];
//     final formattedDate = timestamp != null 
//         ? _formatDateFromTimestamp(timestamp is String ? int.parse(timestamp) : timestamp)
//         : "30 August, 2025";

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(w * 0.04),
//           child: Column(
//             children: [
//               _dateText(context, w, formattedDate),
//               SizedBox(height: w * 0.02),
//               _fareCard(context, w, riderName, totalFare, riderPhone),
//               SizedBox(height: w * 0.03),
//               _mapView(w),
//               SizedBox(height: w * 0.04),
//               _locationInfo(context, w, pickupAddress, dropAddress),
//               SizedBox(height: w * 0.04),
//               _distanceCard(context, w, distance),
//               SizedBox(height: w * 0.03),
//               _actionButtons(context, w, widget.rideData),
//             ],
//           ),
//         ),
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

//   Widget _fareCard(BuildContext context, double w, String riderName, String totalFare, String riderPhone) {
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
//               _rideInfoItem(context, w, "Ride ID", widget.rideData['rideId']?.toString() ?? 'N/A'),
//               _rideInfoItem(context, w, "Order ID", widget.rideData['orderId']?.toString() ?? 'N/A'),
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
//     // Calculate pickup and drop distances (you might want to calculate actual distances)
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
//           _distanceItem(context, w, "Fare", "₹${widget.rideData['totalFare'] ?? '100'}"),
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

//   Widget _actionButtons(BuildContext context, double w, Map<String, dynamic> rideData) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         AppButtons.outlined(
//           width: w * 0.43,
//           context: context,
//           text: "Cancel",
//           onClicked: () async  {
//              final orderId = rideData['rideId'];

//     print("🚗 Accepting ride with ID: $orderId");

//     stepperController.resetSteps();

//    print("myyyyy_orderid_iss>>>>> ${orderId}");

//              await OrderService.declineOrder(
//       orderId: orderId,
//     );

//           },
          
         
//           backgroundColor: AppColors.lightGray,
//           textColor: AppColors.mediumGray,
//           height: w * 0.14,
//           radius: 10,
//         ),

//         AppButtons.outlined(
//   width: w * 0.43,
//   context: context,
//   text: "Accept",
//   onClicked: () async {
//     final orderId = rideData['rideId'];

//     print("🚗 Accepting ride with ID: $orderId");

//     stepperController.resetSteps();

//    print("myyyyy_orderid_iss>>>>> ${orderId}");

//     await OrderService.acceptOrder(
//       orderId: orderId,
//     );

//     // Navigate after success if needed
//     // CustomNavigator.push(
//     //   context,
//     //   ArrivingClient(),
//     //   transition: TransitionType.slideLeft,
//     // );
//   },
//   backgroundColor: ColorsList.mainButtonColor,
//   textColor: ColorsList.mainButtonTextColor,
//   height: w * 0.14,
//   radius: 10,
// ),

//         // AppButtons.outlined(
//         //   width: w * 0.43,
//         //   context: context,
//         //   text: "Accept",
//         //   onClicked: () {
//         //     print("Accepting ride with ID: ${rideData['rideId']}");
//         //     stepperController.resetSteps();



//         //     // CustomNavigator.push(
//         //     //   context,
//         //     //   // AcceptedScreen(rideData: rideData),
//         //     //   ArrivingClient(),
//         //     //   transition: TransitionType.slideLeft,
//         //     // );
//         //   },
//         //   backgroundColor: ColorsList.mainButtonColor,
//         //   textColor: ColorsList.mainButtonTextColor,
//         //   height: w * 0.14,
//         //   radius: 10,
//         // ),
//       ],
//     );
//   }
// }




// class OrderService {
//   static Future<void> acceptOrder({
//     required String orderId,
//   }) async {

//       final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString("auth_token");

  
//   print("my___token_here ${token}");
//     print("myyyyy_orderid_iss ${orderId}");
//     // final String token =
//     //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjhhYjU2NmJmMjE4MmM2MzQzODE0MyIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg5MDQ1NjQsImV4cCI6MTc3MTQ5NjU2NH0.bmq23toClwmbhocTc4ERX5qX-R5x9ogiSCC2N4siM-0";

//     final Uri url = Uri.parse(
//       "https://corezap.smarttechbros.com/api/v1/order/update/$orderId",
//     );

//     print("🔵 ACCEPT ORDER API");
//     print("URL : $url");

//     try {
//       final response = await http.patch(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "orderStatus": "Accepted",
//         }),
//       );

//       print("✅ Status Code : ${response.statusCode}");
//       print("📦 Raw Response : ${response.body}");

//       final decoded = jsonDecode(response.body);
//       print("🎯 Decoded Response : $decoded");
//     } catch (e) {
//       print("❌ Error accepting order : $e");
//     }
//   }



//   static Future<void> declineOrder({
//     required String orderId,
//   }) async {

//       final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString("auth_token");

  
//   print("my___token_here ${token}");
//     print("myyyyy_orderid_iss ${orderId}");
//     // final String token =
//     //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjhhYjU2NmJmMjE4MmM2MzQzODE0MyIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg5MDQ1NjQsImV4cCI6MTc3MTQ5NjU2NH0.bmq23toClwmbhocTc4ERX5qX-R5x9ogiSCC2N4siM-0";

//     final Uri url = Uri.parse(
//       "https://corezap.smarttechbros.com/api/v1/order/decline//$orderId",
//     );

//     print("🔵 ACCEPT ORDER API");
//     print("URL : $url");

//     try {
//       final response = await http.patch(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         // body: jsonEncode({
//         //   "orderStatus": "Accepted",
//         // }),
//       );

//       print("✅ Status Code : ${response.statusCode}");
//       print("📦 Raw Response : ${response.body}");

//       final decoded = jsonDecode(response.body);
//       print("🎯 Decoded Response : $decoded");
//     } catch (e) {
//       print("❌ Error accepting order : $e");
//     }
//   }

  
// }

