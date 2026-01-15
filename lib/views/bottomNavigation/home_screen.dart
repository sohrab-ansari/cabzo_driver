// import 'package:corezap_driver/controller/controllers.dart';
// import 'package:corezap_driver/controller/home_controller.dart';
// import 'package:corezap_driver/controller/stepper_controller.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';

// import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Controllers controllers = Get.put(Controllers());

//   final HomeController homeController = Get.put(HomeController());

//   StepperController stepperController = Get.put(StepperController());

//   @override
//   void initState() {
//     // TODO: implement initState

//     homeController.home_data_method();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(w * .300),
//         child:
//             Container(
//                   height: w * .290,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 1,
//                         blurRadius: 2,
//                         offset: const Offset(
//                           0,
//                           3,
//                         ), // changes position of shadow
//                       ),
//                     ],
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(w * 0.04),
//                       bottomRight: Radius.circular(w * 0.04),
//                     ),
//                   ),

//                   child: SafeArea(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           //first row
//                           Row(
//                             children: [
//                               //user profile
//                               CircleAvatar(
//                                 radius: w * 0.06,
//                                 backgroundImage: const AssetImage(
//                                   'assets/images/home2.png',
//                                 ),
//                               ),
//                               //space
//                               SizedBox(width: w * 0.03),
//                               //user name
//                               AppFonts.textPoppins(
//                                 context,
//                                 "Ayaan Malviya",
//                                 w * 0.05,
//                                 FontWeight.w600,
//                                 AppColors.black,
//                                 TextAlign.left,
//                                 TextOverflow.visible,
//                               ),
//                             ],
//                           ),

//                           Container(
//                             width: w * 0.26,
//                             height: w * 0.10,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF26061),
//                               borderRadius: BorderRadius.circular(w * 0.06),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               'Offline',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: w * 0.032,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//                 .animate()
//                 .fade(duration: 800.ms, curve: Curves.easeInOut)
//                 .scale(
//                   begin: const Offset(0.95, 0.95),
//                   end: const Offset(1, 1),
//                 ),
//       ),

//       //body
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // driver agreement
//               SizedBox(height: w * 0.04),

//               Image.asset("assets/images/offline_image.png"),

//               Text(
//                 "You're Offline",
//                 style: TextStyle(
//                   fontSize: w * 0.05,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               Text(
//                 "Go online to start accepting rides.",
//                 style: TextStyle(
//                   color: const Color(0xFF5F6165),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               SizedBox(height: w * 0.04),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           const BottomnavmainScreen(startWithMaps: true),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF34C759),
//                   minimumSize: const Size(double.infinity, 50), // full width
//                 ),
//                 child: Text(
//                   "Go Online",
//                   style: TextStyle(fontSize: w * 0.04, color: Colors.white),
//                 ),
//               ),

//               //text todays's update
//               SizedBox(height: w * 0.05),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child:
//                     AppFonts.textPoppins(
//                           context,
//                           "Today's Update",
//                           w * 0.038,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.left,
//                           TextOverflow.visible,
//                         )
//                         .animate()
//                         .fade(duration: 820.ms, curve: Curves.easeInOut)
//                         .scale(
//                           begin: const Offset(0.95, 0.95),
//                           end: const Offset(1, 1),
//                         ),
//               ),

//               //some space
//               SizedBox(height: w * 0.04),

//               Column(
//                 children: [
//                   /// Today's Earnings (Full Width)
//                   _elevatedBox(
//                     shadowColor: const Color(0xFF4CAF50),
//                     width: double.infinity,
//                     child: Column(
//                       children: const [
//                         Text(
//                           "Today's Earnings",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Color(0xFF414142),
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           "₹1000.00",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // /// Today's Earnings
//                   // _elevatedBox(
//                   //   child: Column(
//                   //     children: const [
//                   //       Text(
//                   //         "Today's Earnings",
//                   //         style: TextStyle(fontSize: 14, color: Colors.grey),
//                   //       ),
//                   //       SizedBox(height: 6),
//                   //       Text(
//                   //         "₹1000.00",
//                   //         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   const SizedBox(height: 16),

//                   /// Online & Cash
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                     children: [
//                       SizedBox(
//                         // width: 150,
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFFFEBC2F),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 "Online",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "₹500 Total",
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFF7C7C8D),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 "Cash",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "₹500 On Hand",
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   // const SizedBox(height: 16),
//                   SizedBox(height: w * 0.05),

//                   /// Ride Stats
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFF439AFE),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Total Rides",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: const Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               RichText(
//                                 text: const TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: "50",
//                                       style: TextStyle(
//                                         fontSize: 18, // bigger height
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: " / 45 Completed",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // Text("50 / 45 Completed",
//                               //     style: TextStyle(fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFFF26061),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Total Rides",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: const Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               RichText(
//                                 text: const TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: "50",
//                                       style: TextStyle(
//                                         fontSize: 18, // bigger height
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: " / 45 Completed",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // Text("50 / 05 Cancelled",
//                               //     style: TextStyle(fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               SizedBox(height: w * 0.04),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _elevatedBox({
//     required Widget child,
//     double? height,
//     double? width,
//     Color? shadowColor,
//   }) {
//     final Color shadow = shadowColor ?? Colors.black12;
//     return Container(
//       height: height,
//       width: width,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2)),
//         ],
//       ),
//       child: child,
//     );
//   }

//   //? commanWidget--------
//   Widget commonWidget1(
//     double w,
//     Color color,
//     String text1,
//     String text2,
//     String amount1,
//     String amount2,
//   ) {
//     return Container(
//       height: w * .23,
//       width: w * .43,

//       decoration: BoxDecoration(
//         color: color,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 3,
//             // changes position of shadow
//           ),
//         ],
//         borderRadius: BorderRadius.circular(w * 0.012),
//       ),

//       child: Align(
//         alignment: Alignment.bottomRight,
//         child: Container(
//           height: w * .23,
//           width: w * .423,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(w * 0.012),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * 0.03,
//               vertical: w * 0.03,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //text1
//                 Row(
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       "$amount1 - ",
//                       w * 0.032,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                     AppFonts.textPoppins(
//                       context,
//                       text1,
//                       w * 0.028,
//                       FontWeight.w400,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                   ],
//                 ),

//                 //some space
//                 SizedBox(height: w * 0.02),

//                 //text2
//                 Row(
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       "$amount2 - ",
//                       w * 0.028,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                     AppFonts.textPoppins(
//                       context,
//                       text2,
//                       w * 0.028,
//                       FontWeight.w400,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/home_controller.dart';
import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Controllers controllers = Get.put(Controllers());
  final HomeController homeController = Get.put(HomeController());
  StepperController stepperController = Get.put(StepperController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w * .300),
        child: Obx(() => _buildAppBar(w, homeController)),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return _buildLoadingView();
        } else if (homeController.errorMessage.value.isNotEmpty) {
          return _buildErrorView(homeController.errorMessage.value);
        } else if (homeController.homemodalresponse.value == null) {
          return _buildEmptyView();
        }
        return _buildBody(w, homeController.homemodalresponse.value!);
      }),
    );
  }

  Widget _buildAppBar(double w, HomeController controller) {
    final driver = controller.homemodalresponse.value?.driver;
    final isOnline = driver?.isOnline ?? false;
    final userName = driver?.name ?? "Driver";
    final imagePath = driver?.image ?? 'assets/images/home2.png';

    return Container(
      height: w * .290,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
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
              // First row with user info
              Row(
                children: [
                  // User profile
                  CircleAvatar(
                    radius: w * 0.06,
                    backgroundImage: imagePath.startsWith('assets/')
                        ? AssetImage(imagePath) as ImageProvider
                        : NetworkImage(imagePath) as ImageProvider,
                  ),
                  // Space
                  SizedBox(width: w * 0.03),
                  // User name
                  AppFonts.textPoppins(
                    context,
                    userName,
                    w * 0.035,
                    FontWeight.w600,
                    AppColors.black,
                    TextAlign.left,
                    TextOverflow.visible,
                  ),
                ],
              ),
              // Online/Offline status
              Container(
                width: w * 0.26,
                height: w * 0.10,
                decoration: BoxDecoration(
                  color: isOnline ? const Color(0xFF34C759) : const Color(0xFFF26061),
                  borderRadius: BorderRadius.circular(w * 0.06),
                ),
                alignment: Alignment.center,
                child: Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.032,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 800.ms, curve: Curves.easeInOut).scale(
      begin: const Offset(0.95, 0.95),
      end: const Offset(1, 1),
    );
  }

  Widget _buildBody(double w, HomeModalResponse response) {
    final todayStats = response.todayStats;
    final driver = response.driver;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display online/offline message based on driver status
            SizedBox(height: w * 0.04),
            
            Image.asset(driver?.isOnline == true 
                ? "assets/images/online_image.png" // Create this image
                : "assets/images/offline_image.png"
            ),
            
            Text(
              driver?.isOnline == true ? "You're Online" : "You're Offline",
              style: TextStyle(
                fontSize: w * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Text(
              driver?.isOnline == true 
                  ? "Accepting rides" 
                  : "Go online to start accepting rides.",
              style: TextStyle(
                color: const Color(0xFF5F6165),
                fontWeight: FontWeight.w500,
              ),
            ),
            
            SizedBox(height: w * 0.04),
            
            ElevatedButton(
              onPressed: () {
                if (driver?.isOnline == true) {
                  // Already online - maybe show a message
                  Get.snackbar(
                    'Info',
                    'You are already online',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => 
                          const BottomnavmainScreen(startWithMaps: true),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: driver?.isOnline == true 
                    ? Color(0xFFF26061) // Red for going offline
                    : Color(0xFF34C759), // Green for going online
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                driver?.isOnline == true ? "Go Offline" : "Go Online",
                style: TextStyle(fontSize: w * 0.04, color: Colors.white),
              ),
            ),

            // Today's update section
            SizedBox(height: w * 0.05),
            Align(
              alignment: Alignment.centerLeft,
              child: AppFonts.textPoppins(
                context,
                "Today's Update",
                w * 0.038,
                FontWeight.w600,
                AppColors.black,
                TextAlign.left,
                TextOverflow.visible,
              ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
              ),
            ),

            // Stats section
            SizedBox(height: w * 0.04),
            _buildStatsSection(w, todayStats),

            SizedBox(height: w * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(double w, TodayStats? todayStats) {
    final earnings = todayStats?.earnings;
    final rides = todayStats?.rides;
    
    return Column(
      children: [
        /// Today's Earnings (Full Width)
        _elevatedBox(
          shadowColor: const Color(0xFF4CAF50),
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "Today's Earnings",
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF414142),
                ),
              ),
              SizedBox(height: 6),
              Text(
                "₹${earnings?.total?.toStringAsFixed(2) ?? '0.00'}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        /// Online & Cash Earnings
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: w * 0.45,
              child: _elevatedBox(
                shadowColor: const Color(0xFFFEBC2F),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Online",
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF414142),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "₹${earnings?.online?.toStringAsFixed(2) ?? '0.00'} Total",
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
                  children: [
                    Text(
                      "Cash",
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF414142),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "₹${earnings?.cash?.toStringAsFixed(2) ?? '0.00'} On Hand",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

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
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${rides?.total ?? 0}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " / ${rides?.completed ?? 0} Completed",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      "Cancelled Rides",
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF414142),
                      ),
                    ),
                    SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${rides?.cancelled ?? 0}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " / ${rides?.total ?? 0} Total",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading your data...'),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 20),
          Text('Error: $error', textAlign: TextAlign.center),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => homeController.home_data_method(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 60, color: Colors.blue),
          SizedBox(height: 20),
          Text('No data available'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => homeController.home_data_method(),
            child: Text('Load Data'),
          ),
        ],
      ),
    );
  }
}