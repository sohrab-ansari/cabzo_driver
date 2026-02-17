import 'package:nzcu_driver/controllers/home_controllers/controllers.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/services/apiservices/earnings_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class Earnings extends StatefulWidget {
  const Earnings({super.key});

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  ButtonController controller = Get.put(ButtonController());
  PageController _pageController = PageController(initialPage: 0);
  late Future<Map<String, dynamic>> earningsReportFuture;
  late Future<List<dynamic>> rideHistoryFuture;
  
  final tripStatuses = [
    {'name': 'Completed Trip', 'progress': 3, 'color': AppColors.yellow},
    {'name': 'Canceled Trip', 'progress': 2, 'color': AppColors.mediumYellow},
    {'name': 'Denied Trip', 'progress': 1, 'color': AppColors.lightYellow},
  ];
  final weeklyTripData = [
    {'day': 'Mon', 'completed': 8, 'canceled': 3, 'denied': 1},
    {'day': 'Tue', 'completed': 6, 'canceled': 2, 'denied': 4},
    {'day': 'Wed', 'completed': 9, 'canceled': 1, 'denied': 2},
    {'day': 'Thu', 'completed': 3, 'canceled': 5, 'denied': 6},
    {'day': 'Fri', 'completed': 7, 'canceled': 4, 'denied': 3},
    {'day': 'Sat', 'completed': 5, 'canceled': 2, 'denied': 7},
  ];

  @override
  void initState() {
    super.initState();
    controller.selectedIndex.value = 0;
    _loadData(0);
  }

  void _loadData(int pageIndex) {
    String period = ['today', 'weekly', 'monthly'][pageIndex];
    earningsReportFuture = EarningsService.getEarningReport(period);
    rideHistoryFuture = EarningsService.getRideHistory();
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _infoCard({
    required String imagePath,
    required String title,
    required String value,
    required Color borderColor,
    required double w,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.01,
        vertical: w * 0.03, // slightly increased
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(color: borderColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 🔵 Increased Image Circle
          Container(
            width: w * 0.14, // increased
            height: w * 0.14, // increased
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: Image.asset(
                imagePath,
                width: w * 0.07, // increased icon
                height: w * 0.07,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(width: w * 0.01),

          /// 📝 Text section (Container instead of Expanded)
          Container(
            width: w * 0.25, // controls layout without Expanded
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: w * 0.028,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: w * 0.01),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: w * 0.036,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      //appbar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w * .300),
        child:
            Container(
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
                  ),
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * .04,
                          vertical: w * .02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: w * .01),
                            AppFonts.textPoppins(
                              context,
                              "Earning Report",
                              w * 0.05,
                              FontWeight.w600,
                              AppColors.black,
                              TextAlign.center,
                              TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: w * .05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (index) {
                                return Obx(() {
                                  bool isSelected =
                                      controller.selectedIndex.value == index;
                                  List<String> buttonText = [
                                    "Today",
                                    "Weekly",
                                    "Monthly",
                                  ];
                                  return AppButtons.solid(
                                    width: w * .28,
                                    context: context,
                                    text: buttonText[index],
                                    onClicked: () {
                                      controller.selectedIndex.value = index;
                                      _loadData(index);
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    isFullWidth: false,
                                    backgroundColor: isSelected
                                        ? AppColors.primaryRed
                                        : AppColors.lightGray,
                                    textColor: isSelected
                                        ? AppColors.white
                                        : AppColors.primaryRed,
                                    fontSize: w * .035,
                                    height: w * .1,
                                    radius: 30,
                                  );
                                });
                              }),
                            ),
                          ],
                        ),
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
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (int index) {
          controller.selectedIndex.value = index;
          _loadData(index);
        },
        itemCount: 3,
        itemBuilder: (context, pageIndex) {
          String period = ['today', 'weekly', 'monthly'][pageIndex];
          
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.02,
              ),
              child: Column(
                children: [
                  SizedBox(height: w * 0.02),
                  FutureBuilder<Map<String, dynamic>>(
                    future: earningsReportFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          elevation: 6,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.04),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: w * 0.06,
                              horizontal: w * 0.05,
                            ),
                            // child: Center(
                            //   child: CircularProgressIndicator(),
                            // ),

                             child: Center(
                              child: SizedBox.shrink(),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Card(
                          elevation: 6,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.04),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: w * 0.06,
                              horizontal: w * 0.05,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.error,
                                    color: Colors.red, size: w * 0.08),
                                SizedBox(height: w * 0.02),
                                Text("Error loading data",
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        );
                      }

                      final data = snapshot.data ?? {};
                      final earnings = data['earnings'] ?? {};
                      final totalEarning = earnings['total']?.toString() ?? "0";

                      return Card(
                        elevation: 6,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w * 0.04),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: w * 0.06,
                            horizontal: w * 0.05,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppFonts.textPoppins(
                                context,
                                "Total Earnings",
                                w * 0.03,
                                FontWeight.w500,
                                AppColors.black,
                                TextAlign.center,
                                TextOverflow.visible,
                              ),
                              SizedBox(height: w * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.currency_rupee,
                                    color: AppColors.black,
                                    size: w * .063,
                                  ),
                                  AppFonts.textPoppins(
                                    context,
                                    totalEarning,
                                    w * 0.08,
                                    FontWeight.bold,
                                    AppColors.black,
                                    TextAlign.center,
                                    TextOverflow.visible,
                                  ),
                                ],
                              ),
                              SizedBox(height: w * 0.03),
                              AppFonts.textPoppins(
                                context,
                                EarningsService.getFormattedDate(period),
                                w * 0.04,
                                FontWeight.w500,
                                AppColors.darkGray,
                                TextAlign.center,
                                TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fade(duration: 820.ms, curve: Curves.easeInOut)
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1),
                          );
                    },
                  ),

                  SizedBox(height: w * 0.04),

                  FutureBuilder<Map<String, dynamic>>(
                    future: earningsReportFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          height: w * 0.5,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final data = snapshot.data ?? {};
                      final earnings = data['earnings'] ?? {};
                      final trips = data['trips'] ?? {};
                      final cashEarnings =
                          earnings['cash']?.toString() ?? "0";
                      final completed = trips['completed']?.toString() ?? "0";
                      final cancelled = trips['cancelled']?.toString() ?? "0";

                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: w * .03,
                        mainAxisSpacing: w * .03,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 2.4,
                        children: [
                          _infoCard(
                            imagePath: "assets/images/approval.png",
                            title: "Completed",
                            value: completed,
                            borderColor: Colors.blue,
                            w: w,
                          ),
                          _infoCard(
                            imagePath: "assets/images/cancelride.png",
                            title: "Cancelled",
                            value: cancelled,
                            borderColor: Colors.redAccent,
                            w: w,
                          ),
                          FutureBuilder<List<dynamic>>(
                            future: rideHistoryFuture,
                            builder: (context, historySnapshot) {
                              String timeOnline = "0h 0m";
                              if (historySnapshot.hasData) {
                                timeOnline = EarningsService.calculateTimeOnline(
                                    historySnapshot.data ?? []);
                              }
                              return _infoCard(
                                imagePath: "assets/images/new1.png",
                                title: "Time Online",
                                value: timeOnline,
                                borderColor: Colors.blueGrey,
                                w: w,
                              );
                            },
                          ),
                          _infoCard(
                            imagePath: "assets/images/cruncy.png",
                            title: "In cash",
                            value: "₹$cashEarnings",
                            borderColor: Colors.orange,
                            w: w,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: w * 0.04),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppFonts.textPoppins(
                      context,
                      "Recent Trips",
                      w * 0.04,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: w * 0.02),

                  FutureBuilder<List<dynamic>>(
                    future: rideHistoryFuture,
                    builder: (context, snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Center(child: CircularProgressIndicator());
                      // }


  if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error loading trips"),
                        );
                      }

                      final trips = snapshot.data ?? [];
                      if (trips.isEmpty) {
                        return Center(
                          child: Text("No trips available"),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trips.length > 3 ? 3 : trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          final amount =
                              trip['totalFare']?.toString() ?? "0";
                          final time =
                              trip['createdAt']?.toString().split('T')[1] ?? "N/A";
                          final location = trip['startLocation']?['address']?.toString().split(',')[0] ?? "Unknown location";

                          return TripTile(
                            amount: "₹$amount",
                            time: time.substring(0, 5),
                            location: location,
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: w * 0.06),

                  Container(
                    padding: EdgeInsets.all(20),
                    color: Color(0xFFEFFCFC),
                    height: h * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Track your daily and \n weekly earnings in one \n place.",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Image.asset(
                          "assets/images/bannerimage.png",
                          height: 200,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Reusable widget for displaying trip status progress bars
class TripStatusSection extends StatelessWidget {
  final List<Map<String, dynamic>> tripStatuses;
  final int totalSteps;

  const TripStatusSection({
    Key? key,
    required this.tripStatuses,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppFonts.textPoppins(
              context,
              "Trip Status",
              w * 0.04,
              FontWeight.w600,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * 0.03),
            ...tripStatuses.map((status) {
              final name = status['name'] as String;
              final progressValue = (status['progress'] as int) / totalSteps;
              final color = status['color'] as Color;
              return Padding(
                padding: EdgeInsets.only(bottom: w * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppFonts.textPoppins(
                          context,
                          name,
                          w * 0.035,
                          FontWeight.w500,
                          AppColors.black,
                          TextAlign.left,
                          TextOverflow.visible,
                        ),
                        AppFonts.textPoppins(
                          context,
                          "${(status['progress'] as int)} trips",
                          w * 0.03,
                          FontWeight.w500,
                          AppColors.darkGray,
                          TextAlign.right,
                          TextOverflow.visible,
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.01),
                    LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(5),
                      color: color,
                      minHeight: w * 0.015,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Dashed line painter for background
class DashLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;

  DashLinePainter({this.dashWidth = 5, this.dashSpace = 5});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(size.width, startY), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Reusable widget for displaying trip status bar chart
class TripStatusSectionWeekly extends StatelessWidget {
  final List<Map<String, dynamic>> tripData;

  const TripStatusSectionWeekly({Key? key, required this.tripData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    // Calculate the maximum value dynamically for scaling
    final maxValue = tripData
        .map(
          (e) =>
              (e['completed'] as int) +
              (e['canceled'] as int) +
              (e['denied'] as int),
        )
        .reduce((a, b) => a > b ? a : b);

    // Colors mapping
    final colors = {
      'completed': AppColors.yellow,
      'canceled': AppColors.mediumYellow,
      'denied': AppColors.lightYellow,
    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppFonts.textPoppins(
              context,
              "Weekly Trip Status",
              w * 0.04,
              FontWeight.w600,
              AppColors.black,
              TextAlign.left,
              TextOverflow.ellipsis,
            ),
            SizedBox(height: w * 0.02),
            // Legend
            Padding(
              padding: EdgeInsets.symmetric(vertical: w * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegend('Completed', colors['completed']!, w),
                  _buildLegend('Canceled', colors['canceled']!, w),
                  _buildLegend('Denied', colors['denied']!, w),
                ],
              ),
            ),
            SizedBox(height: w * 0.03),
            // Bar chart
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: tripData.map((data) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Dashed background
                            Container(
                              width: w * 0.1,
                              height: w * 0.25,
                              child: CustomPaint(
                                painter: DashLinePainter(
                                  dashWidth: 5,
                                  dashSpace: 5,
                                ),
                              ),
                            ),
                            // Bars Stack
                            Container(
                              width: w * 0.08,
                              height: w * 0.25,
                              child: Stack(
                                children: [
                                  // Denied trips (bottom)
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: w * 0.08,
                                      height:
                                          (w * 0.25) *
                                          (data['denied'] as int) /
                                          maxValue,
                                      decoration: BoxDecoration(
                                        color: colors['denied'],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                  // Canceled trips (middle)
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: w * 0.08,
                                      height:
                                          (w * 0.25) *
                                          (data['canceled'] as int) /
                                          maxValue,
                                      decoration: BoxDecoration(
                                        color: colors['canceled'],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                  // Completed trips (top)
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: w * 0.08,
                                      height:
                                          (w * 0.25) *
                                          (data['completed'] as int) /
                                          maxValue,
                                      decoration: BoxDecoration(
                                        color: colors['completed'],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: w * 0.02),
                        // Day Label
                        Text(
                          data['day'],
                          style: TextStyle(
                            fontSize: w * 0.03,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Legend widget
  Widget _buildLegend(String text, Color color, double w) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.lightGray,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .01),
        child: Row(
          children: [
            Container(
              width: w * 0.02,
              height: w * 0.02,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
            ),
            SizedBox(width: w * 0.01),
            Text(
              text,
              style: TextStyle(
                fontSize: w * 0.03,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWeeklyEarningsChart extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String amount;

  const CustomWeeklyEarningsChart({
    super.key,
    this.width = double.infinity,
    this.height = 200.0,
    this.title = "Weekly Earning",
    this.amount = "₹900",
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
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
        padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFonts.textPoppins(
                      context,
                      title,
                      w * 0.035,
                      FontWeight.w500,
                      AppColors.darkGray,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                    AppFonts.textPoppins(
                      context,
                      amount,
                      w * 0.045,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Icon(
                  Icons.trending_up,
                  color: AppColors.primaryRed,
                  size: w * 0.06,
                ),
              ],
            ),
            SizedBox(height: w * 0.03),

            Expanded(
              child:
                  LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  const days = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < days.length) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: w * .02,
                                      ),
                                      child: Text(
                                        days[value.toInt()],
                                        style: TextStyle(
                                          fontSize: w * .03,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: 5,
                          minY: 0,
                          maxY: 1000,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 200), // Mon
                                FlSpot(1, 500), // Tue
                                FlSpot(2, 300), // Wed
                                FlSpot(3, 800), // Thu
                                FlSpot(4, 600), // Fri
                                FlSpot(5, 900), // Sat
                              ],
                              isCurved: true,
                              color: AppColors.primaryRed,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primaryRed.withOpacity(0.2),
                                    Colors.white,
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  if (index == 4) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: AppColors.primaryRed,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  }
                                  return FlDotCirclePainter(
                                    radius: 2,
                                    color: AppColors.primaryRed,
                                  );
                                },
                              ),
                            ),
                          ],
                          extraLinesData: ExtraLinesData(
                            verticalLines: [
                              VerticalLine(
                                x: 4,
                                color: AppColors.primaryRed.withOpacity(0.5),
                                strokeWidth: 2,
                                dashArray: [5, 5],
                              ),
                            ],
                          ),
                        ),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripTile extends StatelessWidget {
  final String amount;
  final String time;
  final String location;

  const TripTile({
    required this.amount,
    this.time = "N/A",
    this.location = "Unknown location",
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: w * 0.02),
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.lightGray,
            radius: w * 0.04,
            child: Icon(
              Icons.directions_car,
              color: AppColors.primaryRed,
              size: w * 0.045,
            ),
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: w * 0.005),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: w * 0.03, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
