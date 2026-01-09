import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/alerts/driver_agreement.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/home_maps_screen.dart';
import 'package:corezap_driver/views/home_related/live_ride.dart';
import 'package:corezap_driver/views/home_related/raise_requiest.dart';
import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Controllers controllers = Get.put(Controllers());

  StepperController stepperController = Get.put(StepperController());
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w * .300),
        child:
            Container(
                  height: w * .290,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(
                          0,
                          3,
                        ), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(w * 0.04),
                      bottomRight: Radius.circular(w * 0.04),
                    ),
                  ),

                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //first row
                          Row(
                            children: [
                              //user profile
                              CircleAvatar(
                                radius: w * 0.06,
                                backgroundImage: const AssetImage(
                                  'assets/images/home2.png',
                                ),
                              ),
                              //space
                              SizedBox(width: w * 0.03),
                              //user name
                              AppFonts.textPoppins(
                                context,
                                "Ayaan Malviya",
                                w * 0.05,
                                FontWeight.w600,
                                AppColors.black,
                                TextAlign.left,
                                TextOverflow.visible,
                              ),
                            ],
                          ),

                          //online status
                          // Obx(
                          //   () => InkWell(
                          //     onTap: () {
                          //       controllers.driverStatus.value =
                          //           !controllers.driverStatus.value;
                          //     },
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         color: controllers.driverStatus.value
                          //             ? AppColors.green.withOpacity(0.1)
                          //             : AppColors.primaryRed.withOpacity(0.1),
                          //         borderRadius: BorderRadius.circular(w * 0.06),
                          //       ),
                          //       child: Padding(
                          //         padding: EdgeInsets.symmetric(
                          //           horizontal: w * 0.03,
                          //           vertical: w * 0.015,
                          //         ),
                          //         child: AppFonts.textPoppins(
                          //           context,
                          //           controllers.driverStatus.value
                          //               ? "Online"
                          //               : "Offline",
                          //           w * 0.033,
                          //           FontWeight.w500,
                          //           controllers.driverStatus.value
                          //               ? AppColors.green
                          //               : AppColors.primaryRed,
                          //           TextAlign.left,
                          //           TextOverflow.visible,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // toggle
                          Container(
                            width: w * 0.26,
                            height: w * 0.10,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF26061),
                              borderRadius: BorderRadius.circular(w * 0.06),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Offline',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.032,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Obx(
                          //   () => InkWell(
                          //     onTap: () {
                          //       controllers.driverStatus.value =
                          //           !controllers.driverStatus.value;
                          //     },
                          //     borderRadius: BorderRadius.circular(w * 0.06),
                          //     child: AnimatedContainer(
                          //       duration: const Duration(milliseconds: 250),
                          //       curve: Curves.easeInOut,
                          //       width: w * 0.26,
                          //       height: w * 0.10,
                          //       padding: EdgeInsets.symmetric(
                          //         horizontal: w * 0.015,
                          //       ),
                          //       decoration: BoxDecoration(
                          //         color: controllers.driverStatus.value
                          //             ? AppColors.green.withOpacity(0.1)
                          //             : const Color.fromARGB(255, 227, 104, 38).withOpacity(0.1),
                          //         borderRadius: BorderRadius.circular(w * 0.06),
                          //         border: Border.all(
                          //           color: controllers.driverStatus.value
                          //               ? AppColors.green
                          //               : AppColors.primaryRed,
                          //           width: 1.2,
                          //         ),
                          //       ),
                          //       child: Stack(
                          //         alignment: Alignment.center,
                          //         children: [
                          //           // Text
                          //           Align(
                          //             alignment: controllers.driverStatus.value
                          //                 ? Alignment.centerRight
                          //                 : Alignment.centerLeft,
                          //             child: Padding(
                          //               padding: EdgeInsets.symmetric(
                          //                 horizontal: w * 0.025,
                          //               ),
                          //               child: AppFonts.textPoppins(
                          //                 context,
                          //                 controllers.driverStatus.value
                          //                     ? "Online"
                          //                     : "Offline",
                          //                 w * 0.032,
                          //                 FontWeight.w500,
                          //                 controllers.driverStatus.value
                          //                     ? AppColors.green
                          //                     : AppColors.primaryRed,
                          //                 TextAlign.center,
                          //                 TextOverflow.visible,
                          //               ),
                          //             ),
                          //           ),

                          //           // Circle knob
                          //           AnimatedAlign(
                          //             duration: const Duration(
                          //               milliseconds: 250,
                          //             ),
                          //             alignment: controllers.driverStatus.value
                          //                 ? Alignment.centerLeft
                          //                 : Alignment.centerRight,
                          //             child: Container(
                          //               width: w * 0.06,
                          //               height: w * 0.06,
                          //               decoration: BoxDecoration(
                          //                 color: controllers.driverStatus.value
                          //                     ? AppColors.green
                          //                     : AppColors.primaryRed,
                          //                 shape: BoxShape.circle,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate()
                .fade(duration: 800.ms, curve: Curves.easeInOut)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),
      ),

      //body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // driver agreement
              SizedBox(height: w * 0.04),

              Image.asset("assets/images/offline_image.png"),

              Text(
                "You're Offline",
                style: TextStyle(
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "Go online to start accepting rides.",
                style: TextStyle(
                  color: const Color(0xFF5F6165),
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: w * 0.04),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BottomnavmainScreen(startWithMaps: true),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF34C759),
                  minimumSize: const Size(double.infinity, 50), // full width
                ),
                child: Text(
                  "Go Online",
                  style: TextStyle(fontSize: w * 0.04, color: Colors.white),
                ),
              ),

              //text todays's update
              SizedBox(height: w * 0.05),
              Align(
                alignment: Alignment.centerLeft,
                child:
                    AppFonts.textPoppins(
                          context,
                          "Today's Update",
                          w * 0.038,
                          FontWeight.w600,
                          AppColors.black,
                          TextAlign.left,
                          TextOverflow.visible,
                        )
                        .animate()
                        .fade(duration: 820.ms, curve: Curves.easeInOut)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        ),
              ),

              //some space
              SizedBox(height: w * 0.04),

              Column(
                children: [
                  /// Today's Earnings (Full Width)
                  _elevatedBox(
                    shadowColor: const Color(0xFF4CAF50),
                    width: double.infinity,
                    child: Column(
                      children: const [
                        Text(
                          "Today's Earnings",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF414142),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "₹1000.00",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // /// Today's Earnings
                  // _elevatedBox(
                  //   child: Column(
                  //     children: const [
                  //       Text(
                  //         "Today's Earnings",
                  //         style: TextStyle(fontSize: 14, color: Colors.grey),
                  //       ),
                  //       SizedBox(height: 6),
                  //       Text(
                  //         "₹1000.00",
                  //         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 16),

                  /// Online & Cash
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      SizedBox(
                        // width: 150,
                        width: w * 0.45,
                        child: _elevatedBox(
                          shadowColor: const Color(0xFFFEBC2F),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Online",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "₹500 Total",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      SizedBox(
                        width: w * 0.45,
                        child: _elevatedBox(
                          shadowColor: const Color(0xFF7C7C8D),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Cash",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "₹500 On Hand",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 16),
                  SizedBox(height: w * 0.05),

                  /// Ride Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: w * 0.45,
                        child: _elevatedBox(
                          shadowColor: const Color(0xFF439AFE),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Rides",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "50",
                                      style: TextStyle(
                                        fontSize: 18, // bigger height
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " / 45 Completed",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Text("50 / 45 Completed",
                              //     style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      SizedBox(
                        width: w * 0.45,
                        child: _elevatedBox(
                          shadowColor: const Color(0xFFF26061),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Rides",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "50",
                                      style: TextStyle(
                                        fontSize: 18, // bigger height
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " / 45 Completed",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Text("50 / 05 Cancelled",
                              //     style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              //  Column(
              //    children: [
              //      Column(
              //        children: [
              //          Text("TodaYS Earnings "),

              //           Text("₹1000.00"),
              //        ],
              //      ),

              //      Row(
              //        children: [
              //          Column(
              //            children: [
              //              Text("Online"),
              //              Text("₹500 Total")
              //            ],
              //          ),
              //           Column(
              //            children: [
              //              Text("Cash"),
              //              Text("₹500 On Hand")
              //            ],
              //          ),
              //        ],
              //      ),

              //          Row(
              //        children: [
              //          Column(
              //            children: [
              //              Text("Total Rides"),
              //              Text("50/ 45  Completed")
              //            ],
              //          ),
              //           Column(
              //            children: [
              //              Text("Total Rides"),
              //              Text("50/ 05  Cancelled")
              //            ],
              //          ),
              //        ],
              //      )
              //    ],
              //  ),
              SizedBox(height: w * 0.04),

              // Wrap(
              //   spacing: w * 0.04,
              //   runSpacing: w * 0.04,
              //   children: [
              //     //common widget 1
              //     commonWidget1(
              //           w,
              //           Colors.green,
              //           "Total Earnings",
              //           "Cash",
              //           "300",
              //           "100",
              //         )
              //         .animate()
              //         .fade(duration: 830.ms, curve: Curves.easeInOut)
              //         .scale(
              //           begin: const Offset(0.95, 0.95),
              //           end: const Offset(1, 1),
              //         ),

              //     //common widget 1
              //     commonWidget1(
              //           w,
              //           Colors.green.withOpacity(0.4),
              //           "Total Earnings",
              //           "Online",
              //           "300",
              //           "200",
              //         )
              //         .animate()
              //         .fade(duration: 830.ms, curve: Curves.easeInOut)
              //         .scale(
              //           begin: const Offset(0.95, 0.95),
              //           end: const Offset(1, 1),
              //         ),

              //     //common widget 1
              //     commonWidget1(
              //           w,
              //           Colors.blueAccent.withOpacity(0.6),
              //           "Total Rides",
              //           "Completed",
              //           "100",
              //           "80",
              //         )
              //         .animate()
              //         .fade(duration: 860.ms, curve: Curves.easeInOut)
              //         .scale(
              //           begin: const Offset(0.95, 0.95),
              //           end: const Offset(1, 1),
              //         ),

              //     //common widget 1
              //     commonWidget1(
              //           w,
              //           Colors.red,
              //           "Total Rides",
              //           "Cancel",
              //           "100",
              //           "10",
              //         )
              //         .animate()
              //         .fade(duration: 860.ms, curve: Curves.easeInOut)
              //         .scale(
              //           begin: const Offset(0.95, 0.95),
              //           end: const Offset(1, 1),
              //         ),
              //   ],
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: w * .03),
                child: AppFonts.textPoppins(
                  context,
                  "Your Scheduled Pickups",
                  w * 0.04,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.visible,
                ),
              ),
              InkWell(
                onTap: () {
                  stepperController.resetSteps();
                  // stepperController.nextStep();
                  CustomNavigator.push(context, ArrivingClient());
                },
                child: SizedBox(
                  height: w * 0.65,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    clipBehavior: Clip.none, // 4 containers
                    //  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: w * 0.03),
                        child: Container(
                          width: w * 0.8,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(w * 0.03),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/map.png",
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: w * .03),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * .03,
                                  //   vertical: w * .01,
                                ),
                                child: Details().rideLocations(context),
                              ),
                              SizedBox(height: w * .03),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * .03,
                                  // vertical: w * .01,
                                ),
                                child: Details().rideCostDetails(context),
                              ),
                              SizedBox(height: w * .03),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: w * .05),
              Container(
                // height: w * 0.4,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * .03,
                    vertical: w * .03,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: w * .06,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.person,
                                    size: w * .05,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      //  Pick Image from gallery
                                    },
                                    child: CircleAvatar(
                                      radius: w * .015,
                                      backgroundColor: Colors.grey.shade300,
                                      child: CircleAvatar(
                                        radius: w * .012,
                                        backgroundColor: AppColors.white,
                                        child: CircleAvatar(
                                          radius: w * .01,
                                          backgroundColor: AppColors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: w * .02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AppFonts.textPoppins(
                                    context,
                                    "Swift Dzire",
                                    w * 0.04,
                                    FontWeight.w600,
                                    AppColors.black,
                                    TextAlign.left,
                                    TextOverflow.visible,
                                  ),
                                  SizedBox(width: w * .02),
                                  CircleAvatar(
                                    radius: 2,
                                    backgroundColor: AppColors.black,
                                  ),
                                  SizedBox(width: w * .02),
                                  AppFonts.textPoppins(
                                    context,
                                    "Mini",
                                    w * 0.04,
                                    FontWeight.w600,
                                    const Color.fromARGB(255, 0, 94, 255),
                                    TextAlign.left,
                                    TextOverflow.visible,
                                  ),
                                  SizedBox(width: w * .07),
                                  AppButtons.solid(
                                    padding: EdgeInsets.zero,
                                    context: context,
                                    text: "Assigned Vehicle",
                                    onClicked: () {},
                                    isFullWidth: false,
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      234,
                                      241,
                                      255,
                                    ),
                                    radius: 30,
                                    textColor: ColorsList.linksTextColor,
                                    fontSize: w * .025,
                                    height: w * .05,
                                    width: w * .28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              AppFonts.textPoppins(
                                context,
                                "HR26DQ5551",
                                w * 0.035,
                                FontWeight.w400,
                                AppColors.mediumGray,
                                TextAlign.left,
                                TextOverflow.visible,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: w * .02),
                      // raise requiest
                      RaiseRequestDropdown(
                        onSelected: (value) {
                          debugPrint("Selected Option: $value");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: w * .04),

              //////////////////////////live ride button is commented for now on this screen as we dont need it here  can remove code id dont need////////
              // AppButtons.solid(
              //   context: context,
              //   text: "Live Ride",
              //   onClicked: () {
              //     CustomNavigator.push(
              //       context,
              //       LiveRide(),
              //       transition: TransitionType.fade,
              //     );
              //   },
              //   isFullWidth: true,
              //   backgroundColor: ColorsList.mainButtonColor,
              //   textColor: ColorsList.mainButtonTextColor,
              //   fontSize: w * .045,
              //   height: w * .140,
              //   radius: 12.0,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _elevatedBox({
    required Widget child,
    double? height,
    double? width,
    Color? shadowColor,
  }) {
    final Color shadow = shadowColor ?? Colors.black12;
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2)),
        ],
      ),
      child: child,
    );
  }

  // Widget _elevatedBox({required Widget child}) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.06),
  //           blurRadius: 8,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: child,
  //   );
  // }

  //? commanWidget--------
  Widget commonWidget1(
    double w,
    Color color,
    String text1,
    String text2,
    String amount1,
    String amount2,
  ) {
    return Container(
      height: w * .23,
      width: w * .43,

      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(w * 0.012),
      ),

      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: w * .23,
          width: w * .423,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(w * 0.012),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: w * 0.03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //text1
                Row(
                  children: [
                    AppFonts.textPoppins(
                      context,
                      "$amount1 - ",
                      w * 0.032,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                    AppFonts.textPoppins(
                      context,
                      text1,
                      w * 0.028,
                      FontWeight.w400,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                  ],
                ),

                //some space
                SizedBox(height: w * 0.02),

                //text2
                Row(
                  children: [
                    AppFonts.textPoppins(
                      context,
                      "$amount2 - ",
                      w * 0.028,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                    AppFonts.textPoppins(
                      context,
                      text2,
                      w * 0.028,
                      FontWeight.w400,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
