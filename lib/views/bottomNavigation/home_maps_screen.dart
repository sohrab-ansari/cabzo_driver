import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/views/book_ride/book_ride.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:corezap_driver/views/home_related/live_ride.dart';

class HomeMapsScreen extends StatefulWidget {
  const HomeMapsScreen({super.key});

  @override
  State<HomeMapsScreen> createState() => _HomeMapsScreenState();
}

class _HomeMapsScreenState extends State<HomeMapsScreen> {
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    ///
    ///**** this need to modify */
    //this will navigate to live ride screen after 2 seconds when home map screen is loaded for demo purpose
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        // fake user live ride after 2 seconds
        if (!mounted) return;
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const LiveRide()));
      });
    });
  }

  ///
  ///
  ///

  String _selectedTab = "Driver"; // Tracks selected tab

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(19.0176, 72.8562), // Mumbai
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// 1️⃣ Google Map (BOTTOM)
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),

            /// 2️⃣ Book Ride Button (Top Right)
            Positioned(
              top: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const BookRide());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  elevation: 4,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Book Ride",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            /// 3️⃣ Bottom Offline Card (FIRST)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _bottomOfflineCard(),
            ),

            /// 4️⃣ Go Online Floating Button (LAST → ALWAYS ON TOP)
            // Positioned(
            //   bottom: 320,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.green,
            //         elevation: 2,
            //         shape: const StadiumBorder(),
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 36,
            //           vertical: 14,
            //         ),
            //       ),
            //       child: const Text(
            //         "Go Online",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 15,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),

      /// Bottom Navigation
      // bottomNavigationBar: BottomnavmainScreen(),
    );
  }

  /// 🧱 Bottom Offline UI
  Widget _bottomOfflineCard() {
    double w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Driver & Earnings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _topAction(
                icon: _selectedTab == "Driver"
                    ? "assets/icons/drive.png"
                    : "assets/icons/driveoff.svg",
                label: "Driver",
                onTap: () {
                  setState(() {
                    _selectedTab = "Driver";
                  });
                },
                isSelected: _selectedTab == "Driver",
              ),
              SizedBox(width: w * 0.25),
              _topAction(
                icon: _selectedTab == "Earnings"
                    ? "assets/icons/dolleron.svg"
                    : "assets/icons/doller.png",
                label: "Earnings",
                onTap: () {
                  setState(() {
                    _selectedTab = "Earnings";
                  });
                },
                isSelected: _selectedTab == "Earnings",
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Conditional Content
          if (_selectedTab == "Driver")
            _driverContent()
          else
            _earningsContent(),
        ],
      ),
    );
  }

  /// Driver Content
  Widget _driverContent() {
    return Column(
      children: [
        /// Offline Image
        Image.asset("assets/images/onlinee.png", height: 120),

        const SizedBox(height: 12),

        const Text(
          "You're Online",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        const Text(
          "Go offline to stop accepting rides.",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        /// Go Online Button (Bottom)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => const BottomnavmainScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Go Offline",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Earnings Content
  Widget _earningsContent() {
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
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
        SizedBox(height: w * 0.02),

        Column(
          children: [
            /// Today's Earnings (Full Width)
            _elevatedBox(
              width: double.infinity,
              shadowColor: const Color(0xFF4CAF50),
              child: Column(
                children: const [
                  Text(
                    "Today's Earnings",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 1),
                  Text(
                    "₹1000.00",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: w * 0.02),

            /// Online & Cash
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                SizedBox(
                  width: w * 0.4,
                  child: _elevatedBox(
                    shadowColor: const Color(0xFFFEBC2F),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Online",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "₹500 Total",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: w * 0.01),
                SizedBox(
                  width: w * 0.45,
                  child: _elevatedBox(
                    shadowColor: const Color(0xFF7C7C8D),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Cash",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
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
            SizedBox(height: w * 0.02),

            /// Ride Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: w * 0.4,
                  child: _elevatedBox(
                    shadowColor: const Color(0xFF439AFE),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Rides",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
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
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
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
      ],
    );
  }

  /// 🔁 Reusable Top Action
  Widget _topAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensures the entire area is clickable
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon.endsWith(".svg")
              ? SvgPicture.asset(icon, height: 24)
              : Image.asset(icon, height: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.black
                  : Colors.grey, // Optional: visual feedback
            ),
          ),
        ],
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
}
