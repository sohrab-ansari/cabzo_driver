import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/location_input_textfield.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/scheduled_pickups/arrived_otp_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/chat_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/receive_payment_modes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArrivingClient extends StatefulWidget {
  bool? typeCheck;

   ArrivingClient({super.key, this.typeCheck});

  @override
  State<ArrivingClient> createState() => _ArrivingClientState();
}

class _ArrivingClientState extends State<ArrivingClient> {
  final StepperController stepperController = Get.find<StepperController>();
  late GoogleMapController mapController;

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(23.2599, 77.4126),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: _buildAppBar(w),
      body: Column(
        children: [
          _buildLocationInputs(w),
          _buildMapSection(w),
          Expanded(child: _buildBottomSheet(w)),
        ],
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * .03),
      child: Column(
        children: [
          SizedBox(height: w * .02),
          LocationInputTextfield(
            onPressed: () {},
            preffixImage: "assets/icons/greenDot.png",
            hintText: "Your Current Location",
          ),
          SizedBox(height: w * .02),
          LocationInputTextfield(
            onPressed: () {},
            preffixImage: "assets/icons/redDot.png",
            hintText: "Drop location",
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
            onMapCreated: (controller) => mapController = controller,
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
          Text("7 min", style: const TextStyle(fontWeight: FontWeight.w600)),
          const Text(
            "to pickup location",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: w * .04),


  if(widget.typeCheck == true) ...[
_buildClientCard2(w)

  ] else ...[

          _buildClientCard(w),

  ],


          
          const Spacer(),


            if(widget.typeCheck == true) ...[
_buildActionButtons2(w)

  ] else ...[

          _buildActionButtons(w),

  ],
          // _buildActionButtons(w),
        ],
      ),
    );
  }

  Widget _buildClientCard(double w) {
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
                child: CustomText(
                  text: "Amaan Shaikh",
                  textFontSize: w * .046,
                  textFontWeight: FontWeight.w500,
                ),
              ),
              _circleIcon(Icons.call, () {}),
              SizedBox(width: w * .02),
              _circleImage("assets/images/mess.png", () {
                CustomNavigator.push(context, const ChatScreen());
              }),
            ],
          ),
          SizedBox(height: w * .03),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Total Fare: ₹100",
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            ),
          ),
          SizedBox(height: w * .03),
          _buildPickupAddress(),
        ],
      ),
    );
  }



 Widget _buildClientCard2(double w) {
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
                child:Image.asset("assets/images/profile3.png")
                
                // profile3
                //  Icon(
                //   Icons.person,
                //   size: w * .07,
                //   color: Colors.grey.shade700,
                // ),
              ),
              SizedBox(width: w * .03),
              Expanded(
                child: CustomText(
                  text: "Muskan",
                  textFontSize: w * .046,
                  textFontWeight: FontWeight.w500,
                ),
              ),
              // _circleIcon(Icons.call, () {}),
              // SizedBox(width: w * .02),
              // _circleImage("assets/images/mess.png", () {
              //   CustomNavigator.push(context, const ChatScreen());
              // }),
            ],
          ),
          SizedBox(height: w * .08),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Total Fare: ₹100",
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue,fontSize: 18),
            ),
          ),
          SizedBox(height: w * .03),
          // _buildPickupAddress(),
        ],
      ),
    );
  }

  Widget _buildPickupAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: Color(0xFF08875D)),
            SizedBox(width: 8),
            Text("Pickup", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 4),
        Text(
          "Bus Stand, Majestic, Bengaluru, Karnataka 560009",
          style: TextStyle(color: Colors.black54),
        ),
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
              onTap: () {},
            ),
          ),
          SizedBox(width: w * .04),
          Expanded(
            child: _actionButton(
              text: step == 0
                  ? "I've Arrived"
                  : step == 1
                  ? "Start Trip"
                  : "Complete", // Step 2 and 3 will both show "Complete"
              color: const Color(0xFF26E3DD),
              textColor: Colors.black87,
              onTap: () {
                if (step == 0) {
                  // Navigate to OTP screen
                  CustomNavigator.push(
                    context,
                     ArrivedOtpScreen(),
                    transition: TransitionType.fade,
                  );
                } else if (step == 1) {
                  // Start trip action
                  _startTrip();
                } else if (step == 2) {
                  CustomNavigator.removeUntil(
                    context,
                    const ReceivePaymentModes(),
                    transition: TransitionType.fade,
                  );

                  // ReceivePaymentModes
                  // // Complete trip action (when trip is started)
                  // _completeTrip();
                } else {
                  // Complete trip action (when trip is already marked as completed)
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
              onTap: () {},
            ),
          ),
          SizedBox(width: w * .04),
          Expanded(
            child: _actionButton(
              text: step == 0
                  ? "Start Trip"
                  
                  : "Complete", // Step 2 and 3 will both show "Complete"
              color: const Color(0xFF26E3DD),
              textColor: Colors.black87,
              onTap: () {
               if (step == 0) {
                  // Start trip action
                  _startTrip();
                } else if (step == 1) {
                  CustomNavigator.removeUntil(
                    context,
                    const ReceivePaymentModes(),
                    transition: TransitionType.fade,
                  );

                  // ReceivePaymentModes
                  // // Complete trip action (when trip is started)
                  // _completeTrip();
                } else {
                  // Complete trip action (when trip is already marked as completed)
                  _finalizeTrip();
                }
              },
            ),
          ),
        ],
      );
    });
  }

  void _startTrip() {
    // Update to trip started step
    stepperController.nextStep(); // Step 1 -> Step 2

    // Show success message
    Get.snackbar(
      "Trip Started",
      "Your trip has started successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    print("Trip started");
  }

  void _completeTrip() {
    // Update to trip completed step
    stepperController.nextStep(); // Step 2 -> Step 3

    // Show success message
    Get.snackbar(
      "Trip Completed",
      "Trip completed successfully!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    print("Trip completed");
  }

  void _finalizeTrip() {
    // Reset stepper for next trip
    stepperController.resetSteps();

    // Navigate to home or completion screen
    Get.snackbar(
      "Trip Finalized",
      "Trip finalized successfully!",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );

    // You can navigate to home screen here if needed
    // Navigator.pop(context);

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
        child: Text(text, style: TextStyle(color: textColor)),
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
}
