

import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/form_field.dart';
import 'package:corezap_driver/utilities/location_input_textfield.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/scheduled_pickups/arrived_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  final DriverFormController driverFormController =
      Get.put(DriverFormController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: Get.back,
        ),
        leadingWidth: w * 0.08,
        title: AppFonts.textPoppins(
          context,
          "Ride ready",
          w * 0.055,
          FontWeight.w600,
          AppColors.black,
          TextAlign.left,
          TextOverflow.visible,
        ).animateFadeScale(700),
      ),

      /// 🔹 Scrollable Body
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Image
              Image.asset(
                "assets/images/bookridemain.png",
                height: h * 0.22,
                width: w,
                fit: BoxFit.contain,
              ).animateFadeScale(600),

              SizedBox(height: h * 0.02),

              /// Title
              AppFonts.textPoppins(
                context,
                "Set your route – pickup & drop.",
                w * 0.045,
                FontWeight.w600,
                AppColors.black,
                TextAlign.left,
                TextOverflow.visible,
              ).animateFadeScale(700),

              SizedBox(height: h * 0.02),

              /// Pickup Location
              LocationInputTextfield(
                onPressed: () {},
                preffixImage: "assets/icons/greenDot.png",
                preffixhorizontalPadding: w * 0.02,
                hintText: "Your Current Location",
              ),

              SizedBox(height: h * 0.015),


              /// Drop Location
              LocationInputTextfield(
                onPressed: () {},
                preffixImage: "assets/icons/redDot.png",
                hintText: "Drop location",
              ),

              SizedBox(height: h * 0.02),

              Divider(
                thickness: 1.2,
                color: AppColors.darkGray.withOpacity(0.2),
              ),

              SizedBox(height: h * 0.02),

              /// Full Name
              _labelText(context, "Full Name", w),
              SizedBox(height: h * 0.01),
              AppFormFields.custTextFormOther(
                context: context,
                hintText: "Livy",
                controller: nameController,
                fontSize: w * 0.04,
                fontWeight: FontWeight.w300,
                keyboardType: TextInputType.name,
              ).animateFadeScale(900),

              SizedBox(height: h * 0.02),

              /// Mobile Number
              _labelText(context, "Mobile Number", w),
              SizedBox(height: h * 0.01),
              AppFormFields.custTextFormOther(
                context: context,
                hintText: "+91 8344661034",
                controller: phoneController,
                maxLength: 10,
                fontSize: w * 0.04,
                fontWeight: FontWeight.w300,
                keyboardType: TextInputType.phone,
              ).animateFadeScale(900),

              SizedBox(height: h * 0.04),

              /// Book Button
              AppButtons.solid(
                context: context,
                text: "Book Now",
                onClicked: () {

                 

  CustomNavigator.push(
        context,
         ArrivedOtpScreen(bookridetypecheck: true,),
        transition: TransitionType.fade,
      );

                },
                isFullWidth: true,
                height: w * 0.13,
                radius: 12,
                fontSize: w * 0.045,
                textColor: AppColors.black,
                fontWeight: FontWeight.w600,
                isLoading: false,
              ).animateFadeScale(1200),

              SizedBox(height: h * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelText(BuildContext context, String text, double w) {
    return AppFonts.textPoppins(
      context,
      text,
      w * 0.038,
      FontWeight.w500,
      AppColors.black.withOpacity(0.8),
      TextAlign.left,
      TextOverflow.visible,
    );
  }
}

/// 🔹 Animation Extension
extension AnimateHelper on Widget {
  Widget animateFadeScale(int durationMs) {
    return animate()
        .fade(duration: durationMs.ms, curve: Curves.easeInOut)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
        );
  }
}
