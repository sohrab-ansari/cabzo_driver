import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/location_input_textfield.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/home_related/live_ride.dart';
import 'package:corezap_driver/views/scheduled_pickups/arrived_otp_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/chat_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/receive_payment_modes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArrivingClient extends StatefulWidget {
  final bool? typeCheck;
  final Map<String, dynamic>? rideData;

  ArrivingClient({super.key, this.typeCheck, this.rideData});

  @override
  State<ArrivingClient> createState() => _ArrivingClientState();
}

class _ArrivingClientState extends State<ArrivingClient> {
  final StepperController stepperController = Get.find<StepperController>();
  late GoogleMapController mapController;
  final OrderUpdateController orderUpdateController = Get.find<OrderUpdateController>();

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(23.2599, 77.4126),
    zoom: 14,
  );

  // Direction variables
  Set<Polyline> polylines = {};
  LatLng? pickupLocation;
  LatLng? dropLocation;
  String? pickupAddress;
  String? dropAddress;
  String _distance = '0 km';
  String _duration = '0 min';
  bool _loadingDirections = false;

  @override
  void initState() {
    super.initState();
    _initializeLocationData();
  }

  void _initializeLocationData() {
    // Extract addresses and coordinates from ride data
    if (widget.rideData != null) {
      pickupAddress = widget.rideData?['startLocation']?['address']?.toString() ??
          'Your Current Location';
      dropAddress = widget.rideData?['endLocation']?['address']?.toString() ??
          'Drop location';

      // Extract coordinates
      final startLoc = widget.rideData?['startLocation'];
      final endLoc = widget.rideData?['endLocation'];

      if (startLoc?['coordinates'] != null &&
          startLoc['coordinates'] is List &&
          startLoc['coordinates'].length >= 2) {
        pickupLocation =
            LatLng(startLoc['coordinates'][1], startLoc['coordinates'][0]);
      }

      if (endLoc?['coordinates'] != null &&
          endLoc['coordinates'] is List &&
          endLoc['coordinates'].length >= 2) {
        dropLocation = LatLng(endLoc['coordinates'][1], endLoc['coordinates'][0]);
      }

      // Fetch directions if we have both locations
      if (pickupLocation != null && dropLocation != null) {
        _getDirections();
      }
    }
  }

  Future<void> _getDirections() async {
    if (pickupLocation == null || dropLocation == null) {
      print('❌ Pickup or Drop location is null');
      return;
    }

    setState(() {
      _loadingDirections = true;
    });

    try {
      // Use Google Directions API
      final String googleMapsApiKey =
          'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key

      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${pickupLocation!.latitude},${pickupLocation!.longitude}&'
          'destination=${dropLocation!.latitude},${dropLocation!.longitude}&'
          'key=$googleMapsApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['routes'].isNotEmpty) {
          final route = json['routes'][0];

          // Extract distance and duration
          _distance = route['legs'][0]['distance']['text'] ?? '0 km';
          _duration = route['legs'][0]['duration']['text'] ?? '0 min';

          print('✅ Distance: $_distance, Duration: $_duration');

          // Decode polyline
          _decodePolyline(route['overview_polyline']['points']);

          setState(() {});
        } else {
          print('❌ No routes found');
        }
      } else {
        print('❌ Directions API Error: ${response.statusCode}');
        _useAlternativeRoute();
      }
    } catch (e) {
      print('❌ Error fetching directions: $e');
      _useAlternativeRoute();
    } finally {
      setState(() {
        _loadingDirections = false;
      });
    }
  }

  void _decodePolyline(String polyline) {
    List<LatLng> polylineCoordinates = [];
    List<PointLatLng> points = PolylinePoints.decodePolyline(polyline);

    for (var point in points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    setState(() {
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: const Color(0xFF26E3DD),
          width: 5,
          points: polylineCoordinates,
          geodesic: true,
        ),
      );
    });

    // Animate camera to show full route
    _animateCameraToRoute();
  }

  void _useAlternativeRoute() {
    // Fallback: Create a simple polyline between two points
    if (pickupLocation != null && dropLocation != null) {
      setState(() {
        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: const Color(0xFF26E3DD),
            width: 5,
            points: [pickupLocation!, dropLocation!],
            geodesic: true,
          ),
        );
      });
      _animateCameraToRoute();
    }
  }

  void _animateCameraToRoute() {
    if (pickupLocation == null || dropLocation == null) return;

    // Calculate bounds
    double minLat = pickupLocation!.latitude < dropLocation!.latitude
        ? pickupLocation!.latitude
        : dropLocation!.latitude;
    double maxLat = pickupLocation!.latitude > dropLocation!.latitude
        ? pickupLocation!.latitude
        : dropLocation!.latitude;
    double minLng = pickupLocation!.longitude < dropLocation!.longitude
        ? pickupLocation!.longitude
        : dropLocation!.longitude;
    double maxLng = pickupLocation!.longitude > dropLocation!.longitude
        ? pickupLocation!.longitude
        : dropLocation!.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: _buildAppBar(w),
      body: SingleChildScrollView(
        // Added SingleChildScrollView here
        child: Column(
          children: [
            _buildLocationInputs(w),
            _buildMapSection(w),
            _buildBottomSheet(w),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double w) {
    return AppBar(
      backgroundColor: ColorsList.scaffoldColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: w * .03,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomImages.images(
              "assets/icons/arrowLeftIcon.png",
              w * .07,
              w * .07,
            ),
          ),
          SizedBox(width: w * .03),
          CustomText(
            text: "Arriving Client",
            textColor: ColorsList.titleTextColor,
            textFontSize: w * .055,
            textFontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInputs(double w) {
    // Use extracted addresses or fallback values
    final pickup = pickupAddress ?? 'Your Current Location';
    final drop = dropAddress ?? 'Drop location';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * .03),
      child: Column(
        children: [
          SizedBox(height: w * .02),
          LocationInputTextfield(
            onPressed: () {},
            preffixImage: "assets/icons/greenDot.png",
            hintText: pickup,
          ),
          SizedBox(height: w * .02),
          LocationInputTextfield(
            onPressed: () {},
            preffixImage: "assets/icons/redDot.png",
            hintText: drop,
          ),
          SizedBox(height: w * .02),
        ],
      ),
    );
  }

  Widget _buildMapSection(double w) {
    return SizedBox(
      height: w * .6,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            polylines: polylines,
            markers: _buildMarkers(),
            onMapCreated: (controller) {
              mapController = controller;
              if (pickupLocation != null && dropLocation != null) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  _animateCameraToRoute();
                });
              }
            },
          ),
          // Loading indicator for directions
          if (_loadingDirections)
            Center(
              child: Container(
                padding: EdgeInsets.all(w * .04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF26E3DD),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: w * .03,
            left: (w - (w * .6)) / 2,
            child: Container(
              width: w * .6,
              height: w * .1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorsList.iconGreyColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Obx(() {
                final step = stepperController.activeStep.value;
                String statusText;

                switch (step) {
                  case 0:
                    statusText = "Going to pickup location";
                    break;
                  case 1:
                    statusText = "Arrived at pickup location";
                    break;
                  case 2:
                    statusText = "Trip started";
                    break;
                  case 3:
                    statusText = "Trip completed";
                    break;
                  default:
                    statusText = "";
                }

                return CustomText(
                  text: statusText,
                  textColor: ColorsList.mainButtonTextColor,
                  textFontSize: w * .032,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    if (pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLocation!,
          infoWindow: const InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    if (dropLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('drop'),
          position: dropLocation!,
          infoWindow: const InfoWindow(title: 'Drop Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildBottomSheet(double w) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(w * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route Information
          _buildRouteInfo(w),
          SizedBox(height: w * .03),

          Text("to pickup location",
              style: const TextStyle(color: Colors.black54)),
          SizedBox(height: w * .04),

          if (widget.typeCheck == true) ...[
            _buildClientCard2(w),
          ] else ...[
            _buildClientCard(w),
          ],

          SizedBox(height: w * .04),

          if (widget.typeCheck == true) ...[
            _buildActionButtons2(w),
          ] else ...[
            _buildActionButtons(w),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteInfo(double w) {
    return Container(
      padding: EdgeInsets.all(w * .03),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              CustomText(
                text: _distance,
                textColor: Colors.black87,
                textFontSize: w * .045,
                textFontWeight: FontWeight.w600,
              ),
              SizedBox(height: w * .01),
              CustomText(
                text: "Distance",
                textColor: Colors.grey,
                textFontSize: w * .03,
              ),
            ],
          ),
          Container(
            height: w * .08,
            width: 1,
            color: Colors.grey.shade300,
          ),
          Column(
            children: [
              CustomText(
                text: _duration,
                textColor: Colors.black87,
                textFontSize: w * .045,
                textFontWeight: FontWeight.w600,
              ),
              SizedBox(height: w * .01),
              CustomText(
                text: "Duration",
                textColor: Colors.grey,
                textFontSize: w * .03,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(double w) {
    // Use rideData if available, otherwise use defaults
    final riderName =
        widget.rideData?['riderName']?.toString() ?? 'Amaan Shaikh';
    final riderPhone = widget.rideData?['riderNumber']?.toString() ?? '';
    final totalFare = widget.rideData?['totalFare']?.toString() ?? '100';
    final pickupAddress =
        widget.rideData?['startLocation']?['address']?.toString() ??
        'Bus Stand, Majestic, Bengaluru, Karnataka 560009';

    return Container(
      padding: EdgeInsets.all(w * .04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: w * .055,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  size: w * .07,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: w * .03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: riderName,
                      textFontSize: w * .046,
                      textFontWeight: FontWeight.w500,
                    ),
                    if (riderPhone.isNotEmpty) ...[
                      SizedBox(height: w * .01),
                      Text(
                        riderPhone,
                        style: TextStyle(
                          fontSize: w * .035,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (riderPhone.isNotEmpty) ...[
                _circleIcon(Icons.call, () {
                  _makePhoneCall(riderPhone);
                }),
                SizedBox(width: w * .02),
              ],
              _circleImage("assets/images/mess.png", () {
                CustomNavigator.push(
                  context,
                  ChatScreen(
                    // riderName: riderName,
                    // rideId: widget.rideData?['rideId'],
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: w * .03),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Total Fare: ₹$totalFare",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: w * .04,
              ),
            ),
          ),
          SizedBox(height: w * .03),
          _buildPickupAddress(pickupAddress),
        ],
      ),
    );
  }

  Widget _buildClientCard2(double w) {
    final riderName = widget.rideData?['riderName']?.toString() ?? 'Muskan';
    final totalFare = widget.rideData?['totalFare']?.toString() ?? '100';

    return Container(
      height: w * 0.5,
      padding: EdgeInsets.all(w * .04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: w * .055,
                backgroundColor: Colors.grey.shade300,
                child: Image.asset("assets/images/profile3.png"),
              ),
              SizedBox(width: w * .03),
              Expanded(
                child: CustomText(
                  text: riderName,
                  textFontSize: w * .046,
                  textFontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: w * .08),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Total Fare: ₹$totalFare",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: w * .045,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupAddress(String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: Color(0xFF08875D)),
            SizedBox(width: 8),
            Text("Pickup", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 4),
        Text(address, style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _buildActionButtons(double w) {
    return Obx(() {
      final step = stepperController.activeStep.value;

      return Row(
        children: [
          Expanded(
            child: _actionButton(
              text: "Cancel",
              color: const Color(0xFFE0E4E7),
              textColor: Colors.grey,
              onTap: () async {
                // await OrderService.declineOrder();
                print("caneceeeeeelll11111111111122222222222222222");

                      print("helloooo>>>>>123");
     final orderId = widget.rideData!['rideId']; 


print("my_data_orderrriddd_came1_in_cancel ${orderId}");


print("my_data_orderrriddd_came2  in_cancel_time ${widget.rideData}");

                       await orderUpdateController.update_order_method(orderstatus: "Cancelled",orderid: orderId);

                       CustomNavigator.removeUntil(
        context,
         BottomnavmainScreen(),
        transition: TransitionType.fade,
      );
              },
            ),
          ),
          SizedBox(width: w * .04),
          Expanded(
            child: _actionButton(
              text: step == 0
                  ? "I've Arrived"
                  : step == 1
                  ? "Start Trip"
                  : "Complete",
              color: const Color(0xFF26E3DD),
              textColor: Colors.black87,
              onTap: () async {
                if (step == 0) {

                  print("helloooo>>>>>123");
     final orderId = widget.rideData!['rideId']; 


print("my_data_orderrriddd_came1 ${orderId}");


print("my_data_orderrriddd_came2 ${widget.rideData}");
    //               await OrderService.ArrivingOrder(
    //                 orderId: orderId,
    //   status: "Arriving",
    //   // context: context,
      
    // );


       await orderUpdateController.update_order_method(orderstatus: "Arriving",orderid: orderId);

                  // Navigate to OTP screen
                  CustomNavigator.push(
                    context,
                    ArrivedOtpScreen(
                      // rideData: widget.rideData,
                    ),
                    transition: TransitionType.fade,
                  );
                } else if (step == 1) {

    final orderId = widget.rideData!['rideId']; 
                         await orderUpdateController.update_order_method(orderstatus: "Progress",orderid: orderId);


   stepperController.nextStep();
                  // Start trip action
                  // _startTrip();
                } else if (step == 2) {

final orderId = widget.rideData!['rideId']; 
  print("myyyyy_paymnet_taopppppp");

   print("myyyyy_paymnet_taopppppp ${orderId}");
                    
                         await orderUpdateController.update_order_method(orderstatus: "Completed",orderid: orderId);

                  CustomNavigator.removeUntil(
                    context,
                    ReceivePaymentModes(
                      // rideData: widget.rideData,
                    ),
                    transition: TransitionType.fade,
                  );
                } else {
                  // Complete trip action
                  _finalizeTrip();
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildActionButtons2(double w) {
    return Obx(() {
      final step = stepperController.activeStep.value;

      return Row(
        children: [
          Expanded(
            child: _actionButton(
              text: "Cancel",
              color: const Color(0xFFE0E4E7),
              textColor: Colors.grey,
              onTap: () async {

                print("caneceeeeeelll111111111111");

                 final orderId = widget.rideData!['rideId']; 


print("my_data_orderrriddd_came1_in_cancel ${orderId}");


print("my_data_orderrriddd_came2  in_cancel_time ${widget.rideData}");

                       await orderUpdateController.update_order_method(orderstatus: "Cancelled",orderid: orderId);

                       CustomNavigator.removeUntil(
        context,
         BottomnavmainScreen(),
        transition: TransitionType.fade,
      );
                // await OrderService.declineOrder();
              },
            ),
          ),
          SizedBox(width: w * .04),
          Expanded(
            child: _actionButton(
              text: step == 0 ? "Start Trip" : "Complete",
              color: const Color(0xFF26E3DD),
              textColor: Colors.black87,
              onTap: () {
                if (step == 0) {
                  // Start trip action
                  _startTrip();
                } else if (step == 1) {
                  CustomNavigator.removeUntil(
                    context,
                    ReceivePaymentModes(
                      // rideData: widget.rideData,
                    ),
                    transition: TransitionType.fade,
                  );
                } else {
                  // Complete trip action
                  _finalizeTrip();
                }
              },
            ),
          ),
        ],
      );
    });
  }

  void _startTrip() async{
    // Update to trip started step
    stepperController.nextStep(); // Step 1 -> Step 2

    // await OrderService.startStripOrder(
    //   orderId: "", 
    //   status: "",
    //   context: context,
      
    // );
    print("Trip started");
  }

  void _finalizeTrip() async{
    // Reset stepper for next trip
    stepperController.resetSteps();

    // await OrderService.CompleteOrder(
    //   orderId: "", 
    //   status: "",
    //   context: context,
      
    // );
    print("Trip finalized");
  }

  Widget _actionButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFE9FCFC),
        child: Icon(icon, size: 20, color: ColorsList.mainAppColor),
      ),
    );
  }

  Widget _circleImage(String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFE9FCFC),
        child: Image.asset(path, width: 30),
      ),
    );
  }

  // Helper method to make phone call
  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
