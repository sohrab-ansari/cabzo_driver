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

//     riedsHistoryController.get_history_method(status: "Pending");
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



import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/ridescontroller/rieds_history_controller2.dart';
import 'package:corezap_driver/modals/ride_history_response2.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RidehistoryScreen extends StatefulWidget {
  const RidehistoryScreen({super.key});

  @override
  State<RidehistoryScreen> createState() => _RidehistoryScreenState();
}

class _RidehistoryScreenState extends State<RidehistoryScreen>
    with TickerProviderStateMixin {
  final RiedsHistoryController2 riedsHistoryController =
      Get.put(RiedsHistoryController2());
  final Controllers currentTabBar = Get.find<Controllers>();

  late TabController _tabController;
  final List<String> _tabStatuses = ["Pending", "Completed", "Cancelled"];
  String _currentStatus = "Pending";

  // Track which tabs have been loaded
  final Map<String, bool> _tabLoaded = {
    "Pending": false,
    "Completed": false,
    "Cancelled": false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      currentTabBar.currentTabIndex.value = _tabController.index;
      _currentStatus = _tabStatuses[_tabController.index];
      
      // Call API when tab changes
      _fetchDataForCurrentTab();
    });

    // Initial fetch for first tab (Pending)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataForCurrentTab();
    });
  }

  void _fetchDataForCurrentTab() {
    // Only fetch if not already loaded or if we need to refresh
    if (!_tabLoaded[_currentStatus]! || 
        riedsHistoryController.transactionsres.value?.data == null) {
      riedsHistoryController.get_history_method(status: _currentStatus);
      _tabLoaded[_currentStatus] = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leadingWidth: w * 0.010,
        leading: const SizedBox(),
        title: AppFonts.textPoppins(
          context,
          "Ride History",
          w * 0.05,
          FontWeight.w600,
          AppColors.black,
          TextAlign.center,
          TextOverflow.ellipsis,
          maxLines: 1,
        )
            .animate()
            .fade(duration: 800.ms, curve: Curves.easeInOut)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
            ),
      ),
      body: Column(
        children: [
          // Tab bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * .04,
              vertical: w * .03,
            ),
            child: Container(
              height: w * .11,
              width: w,
              decoration: BoxDecoration(
                color: AppColors.lightGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(w * .035),
                border: Border.all(
                  color: AppColors.black.withOpacity(0.4),
                  width: w * .002,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .005,
                  vertical: w * .005,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(w * .03),
                  ),
                  indicatorColor: AppColors.darkGray,
                  labelColor: AppColors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerHeight: 0.0,
                  unselectedLabelColor: AppColors.darkGray.withOpacity(0.4),
                  labelStyle: TextStyle(
                    fontSize: w * .034,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: "New trip"),
                    Tab(text: "Completed"),
                    Tab(text: "Cancelled"),
                  ],
                ),
              ),
            )
                .animate()
                .fade(duration: 820.ms, curve: Curves.easeInOut)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),
          ),

          Divider(
            color: AppColors.mediumGray.withOpacity(0.4),
            thickness: w * .002,
          ),

          // Tab bar view
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // New trip (Pending) tab
                _buildRideListView("Pending"),
                // Completed tab
                _buildRideListView("Completed"),
                // Cancelled tab
                _buildRideListView("Cancelled"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideListView(String status) {
    double w = MediaQuery.of(context).size.width;
    
    return Obx(() {
      // Show loading only if current tab is active and loading
      bool shouldShowLoading = riedsHistoryController.isLoading.value && 
          _currentStatus == status;
      
      // Show error only if current tab is active and has error
      bool shouldShowError = riedsHistoryController.errorMessage.isNotEmpty && 
          _currentStatus == status && 
          _tabLoaded[status]!;

      if (shouldShowLoading) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryRed,
          ),
        );
      }

      if (shouldShowError) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(w * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppFonts.textPoppins(
                  context,
                  "Error",
                  w * 0.045,
                  FontWeight.w600,
                  AppColors.primaryRed,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: w * 0.02),
                AppFonts.textPoppins(
                  context,
                  riedsHistoryController.errorMessage.value,
                  w * 0.035,
                  FontWeight.w400,
                  AppColors.black.withOpacity(0.6),
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                SizedBox(height: w * 0.04),
                ElevatedButton(
                  onPressed: () {
                    riedsHistoryController.get_history_method(status: status);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.06,
                      vertical: w * 0.02,
                    ),
                    child: AppFonts.textPoppins(
                      context,
                      "Retry",
                      w * 0.035,
                      FontWeight.w600,
                      AppColors.white,
                      TextAlign.center,
                      TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Get rides for current status
      final rides = riedsHistoryController.transactionsres.value?.data ?? [];
      
      // Show empty state if no rides and tab has been loaded
      if (rides.isEmpty && _tabLoaded[status]!) {
        return RefreshIndicator(
          onRefresh: () async {
            await riedsHistoryController.get_history_method(status: status);
          },
          color: AppColors.primaryRed,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: w * 0.3),
              Center(
                child: AppFonts.textPoppins(
                  context,
                  "No $status rides found",
                  w * 0.045,
                  FontWeight.w500,
                  AppColors.black.withOpacity(0.6),
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      }

      // If tab hasn't been loaded yet and not loading, show initial state
      if (!_tabLoaded[status]! && !shouldShowLoading) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: w * 0.15,
                color: AppColors.lightGray,
              ),
              SizedBox(height: w * 0.03),
              AppFonts.textPoppins(
                context,
                "Tap to load $status rides",
                w * 0.04,
                FontWeight.w500,
                AppColors.black.withOpacity(0.5),
                TextAlign.center,
                TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await riedsHistoryController.get_history_method(status: status);
        },
        color: AppColors.primaryRed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.02,
          ),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Padding(
                padding: EdgeInsets.only(bottom: w * 0.06),
                child: _buildRideCard(ride, w, status)
                    .animate()
                    .fade(duration: 400.ms, curve: Curves.easeInOut)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildRideCard(Datum ride, double w, String status) {
    final isCompleted = status == "Completed";
    final isCancelled = status == "Cancelled";
    final isPending = status == "Pending";
    
    // Format time
    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('MMM dd, yyyy');
    final rideTime = ride.createdAt != null 
        ? timeFormat.format(ride.createdAt!)
        : "N/A";
    final rideDate = ride.createdAt != null 
        ? dateFormat.format(ride.createdAt!)
        : "N/A";
    
    return Container(
      width: w,
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(w * .035),
        border: Border.all(
          color: AppColors.black.withOpacity(0.1),
          width: w * .002,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppFonts.textPoppins(
                          context,
                          isPending 
                            ? "New trip" 
                            : isCompleted 
                              ? "Completed" 
                              : "Cancelled",
                          w * 0.035,
                          FontWeight.w600,
                          isCancelled ? const Color(0xFFE02D3C) : AppColors.TextBuleColor,
                          TextAlign.center,
                          TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        AppFonts.textPoppins(
                          context,
                          " : ",
                          w * 0.030,
                          FontWeight.w600,
                          isCancelled ? const Color(0xFFE02D3C) : AppColors.TextBuleColor,
                          TextAlign.center,
                          TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        AppFonts.textPoppins(
                          context,
                          rideTime,
                          w * 0.035,
                          FontWeight.w600,
                          isCancelled ? const Color(0xFFE02D3C) : AppColors.TextBuleColor,
                          TextAlign.center,
                          TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.01),
                    AppFonts.textPoppins(
                      context,
                      rideDate,
                      w * 0.028,
                      FontWeight.w400,
                      AppColors.black.withOpacity(0.5),
                      TextAlign.center,
                      TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                
                AppFonts.textPoppins(
                  context,
                  "₹${ride.totalFare?.toStringAsFixed(2) ?? "0.00"}",
                  w * 0.042,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),

            SizedBox(height: w * 0.015),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Customer name
                AppFonts.textPoppins(
                  context,
                  ride.userId?.name ?? "Unknown",
                  w * 0.032,
                  FontWeight.w600,
                  AppColors.black.withOpacity(0.5),
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                // Payment method
                Row(
                  children: [
                    if (ride.paymentMethod?.toLowerCase() == "cash")
                      Image.asset(
                        "assets/images/moneyss.png",
                        height: w * 0.05,
                        width: w * 0.05,
                      ),
                    AppFonts.textPoppins(
                      context,
                      ride.paymentMethod?.toLowerCase() == "cash" 
                        ? " Cash" 
                        : " ${ride.paymentMethod?.toUpperCase() ?? "N/A"}",
                      w * 0.035,
                      FontWeight.w600,
                      ride.paymentMethod?.toLowerCase() == "cash" 
                        ? const Color(0xFf4CAF50) 
                        : AppColors.primaryRed,
                      TextAlign.center,
                      TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: w * 0.02),

            Divider(
              color: AppColors.mediumGray.withOpacity(0.4),
              thickness: w * .002,
              height: w * 0.1,
            ),

            Row(
              children: [
                Image.asset(
                  _getVehicleIcon(ride.vehicleType ?? "bike"),
                  height: 30,
                  width: 30,
                ),
                SizedBox(width: w * 0.02),
                AppFonts.textPoppins(
                  context,
                  _getVehicleTypeText(ride.vehicleType ?? "bike"),
                  w * 0.035,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),

            SizedBox(height: w * 0.06),

            // Pickup and Destination
            Row(
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/icons/greenDot.png",
                      height: w * 0.06,
                      width: w * 0.06,
                    ),
                    Container(
                      width: w * 0.002,
                      height: w * 0.10,
                    ),
                    Image.asset(
                      "assets/icons/redDot.png",
                      height: w * 0.06,
                      width: w * 0.06,
                    ),
                  ],
                ),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup
                      AppFonts.textPoppins(
                        context,
                        "Pickup",
                        w * 0.032,
                        FontWeight.w600,
                        AppColors.green,
                        TextAlign.start,
                        TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: w * 0.02),
                      AppFonts.textPoppins(
                        context,
                        ride.startLocation?.address ?? "Not available",
                        w * 0.032,
                        FontWeight.w400,
                        AppColors.black,
                        TextAlign.start,
                        TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: w * 0.06),
                      // Destination
                      AppFonts.textPoppins(
                        context,
                        "Destination",
                        w * 0.032,
                        FontWeight.w600,
                        AppColors.primaryRed,
                        TextAlign.start,
                        TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: w * 0.02),
                      AppFonts.textPoppins(
                        context,
                        ride.endLocation?.address ?? "Not available",
                        w * 0.032,
                        FontWeight.w400,
                        AppColors.black,
                        TextAlign.start,
                        TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Ride details
          SizedBox(height: w * 0.04),



            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     _buildRideDetail(
            //       "Distance",
            //       "${ride.distance?.toStringAsFixed(1) ?? "0.0"} km",
            //       Icons.directions_car,
            //       w,
            //     ),
            //     _buildRideDetail(
            //       "Duration",
            //       "${ride.duration?.toStringAsFixed(0) ?? "0"} min",
            //       Icons.access_time,
            //       w,
            //     ),
            //     if (ride.orderType == "rental" && ride.rentalBillingDetails != null)
            //       _buildRideDetail(
            //         "Rental",
            //         "Package",
            //         Icons.card_membership,
            //         w,
            //       ),
            //   ],
            // ),
          
          
          ]
          
          ,
        ),
      ),
    );
  }

  Widget _buildRideDetail(String title, String value, IconData icon, double w) {
    return Column(
      children: [
        Icon(icon, size: w * 0.05, color: AppColors.primaryRed),
        SizedBox(height: w * 0.01),
        AppFonts.textPoppins(
          context,
          title,
          w * 0.028,
          FontWeight.w500,
          AppColors.black.withOpacity(0.6),
          TextAlign.center,
          TextOverflow.ellipsis,
          maxLines: 1,
        ),
        AppFonts.textPoppins(
          context,
          value,
          w * 0.032,
          FontWeight.w600,
          AppColors.black,
          TextAlign.center,
          TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  String _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case "car":
        return "assets/images/car_image.png";
      case "auto":
        return "assets/images/auto_image.png";
      case "bike":
      default:
        return "assets/images/bike_image.png";
    }
  }

  String _getVehicleTypeText(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case "car":
        return "Car";
      case "auto":
        return "Auto";
      case "bike":
        return "Bike";
      default:
        return vehicleType;
    }
  }
}