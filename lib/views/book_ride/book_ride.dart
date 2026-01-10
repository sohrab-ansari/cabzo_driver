import 'package:corezap_driver/controller/login.controller.dart';
import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/form_field.dart';
import 'package:corezap_driver/utilities/location_input_textfield.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  DriverFormController driverFormController = Get.put(DriverFormController());
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  //initialized login controller

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: AppFonts.textPoppins(
          context,
          "Ride ready",
          w * 0.06,
          FontWeight.w500,
          AppColors.black,
          TextAlign.left,
          TextOverflow.visible,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.black,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.06),
            // Ensure SVG has visible bounds: give it an explicit height and use contain
            SvgPicture.asset(
                  "assets/images/bookridemain.svg",
                  height: h * 0.25,
                  fit: BoxFit.contain,
                )
                .animate()
                .fade(duration: 800.ms, curve: Curves.easeInOut)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),

            //column
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //space 1
                  SizedBox(height: w * 0.04),
                  //text
                  AppFonts.textPoppins(
                        context,
                        "Set your route – pickup & drop.",
                        w * 0.0455,
                        FontWeight.w600,
                        const Color(0xFF242731),
                        TextAlign.left,
                        TextOverflow.visible,
                      )
                      .animate()
                      .fade(duration: 900.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),

                  //text 2
                  SizedBox(height: w * 0.03),
                  Column(
                    children: [
                      //custom app bar==================
                      SizedBox(height: w * .02),
                      LocationInputTextfield(
                        onPressed: () {},
                        preffixImage: "assets/icons/greenDot.png",
                        preffixhorizontalPadding: w * .02,
                        // preffixverticalPadding: w * .04,
                        hintText: "Your Current Location",
                      ),
                      SizedBox(height: w * .02),
                      LocationInputTextfield(
                        onPressed: () {},
                        preffixImage: "assets/icons/redDot.png",
                        //  preffixhorizontalPadding: w * .02,
                        // preffixverticalPadding: w * .04,
                        hintText: "Drop location",
                      ),
                      SizedBox(height: w * .02),
                    ],
                  ),

                  //space 2
                  SizedBox(height: w * 0.04),
                  Divider(
                    height: 0.5,
                    color: AppColors.darkGray.withValues(alpha: 0.2),
                    thickness: 1.5,
                  ),
                  SizedBox(height: w * 0.04),

                  //text 3
                  AppFonts.textPoppins(
                        context,
                        "Full Name",
                        w * 0.038,
                        FontWeight.w500,
                        AppColors.black.withOpacity(0.8),
                        TextAlign.left,
                        TextOverflow.visible,
                      )
                      .animate()
                      .fade(duration: 1100.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),

                  //space 3
                  SizedBox(height: w * 0.02),

                  //text field
                  AppFormFields.custTextFormOther(
                        context: context,
                        hintText: "Livy",
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w300,
                        controller: name,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                      )
                      .animate()
                      .fade(duration: 1200.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
                  SizedBox(height: w * 0.02),
                  AppFonts.textPoppins(
                        context,
                        "Mobile Number",
                        w * 0.038,
                        FontWeight.w500,
                        AppColors.black.withOpacity(0.8),
                        TextAlign.left,
                        TextOverflow.visible,
                      )
                      .animate()
                      .fade(duration: 1100.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
                  SizedBox(height: w * 0.02),
                  AppFormFields.custTextFormOther(
                        context: context,
                        hintText: "+91 8344661034",
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w300,
                        controller: phone,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                      )
                      .animate()
                      .fade(duration: 1200.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
                ],
              ),
            ),

            SizedBox(height: w * 0.1),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child:
                  AppButtons.solid(
                        context: context,
                        text: "Book Now",
                        onClicked: () {},
                        isFullWidth: true,
                        fontSize: w * 0.045,
                        height: w * 0.140,
                        radius: 12.0,
                        isLoading: false,
                        textColor: AppColors.black,
                        fontWeight: FontWeight.w500,
                      )
                      .animate()
                      .fade(duration: 1600.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
            ),
            SizedBox(height: w * .1),
          ],
        ),
      ),
    );
  }

  //common widger
  Widget commonWidget(
    String icon,
    String text,
    BuildContext context,
    //on click
    VoidCallback onClicked,
  ) {
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      onTap: onClicked,
      child: Container(
        height: w * 0.13,
        width: w * 0.45,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black.withOpacity(0.1), width: 1),
          borderRadius: BorderRadius.circular(w * 0.03),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: w * 0.05, width: w * 0.05),
            SizedBox(width: w * 0.03),
            AppFonts.textPoppins(
              context,
              text,
              w * 0.036,
              FontWeight.w600,
              AppColors.black.withOpacity(0.7),
              TextAlign.left,
              TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
