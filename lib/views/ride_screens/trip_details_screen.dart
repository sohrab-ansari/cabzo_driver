import 'package:flutter/material.dart';
// Removed unused import
import 'package:intl/intl.dart';
import 'package:nzcu_driver/modals/home_modals/ride_history_response.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// Removed unused import for api_path

class TripDetailsScreen extends StatelessWidget {
  final Datum ride;

  const TripDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    Map<String, String> _formatDateTime(DateTime? dateTime) {
      if (dateTime == null) {
        return {'full': '', 'date': '', 'time': ''};
      }

      try {
        // Convert to local time if needed
        final localDateTime = dateTime.toLocal();

        return {
          'full': DateFormat('hh:mm a, dd MMM yyyy').format(localDateTime),
          'date': DateFormat('MMM dd, yyyy').format(localDateTime),
          'time': DateFormat('h:mm a').format(localDateTime),
        };
      } catch (e) {
        AppLogger.d('Error formatting date: $e');
        return {
          'full': dateTime.toString(),
          'date': '',
          'time': dateTime.toString(),
        };
      }
    }

    final dateInfo = _formatDateTime(ride.createdAt);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: AppFonts.textPoppins(
          context,
          "Trip Details",
          w * 0.045,
          FontWeight.w600,
          AppColors.black,
          TextAlign.center,
          TextOverflow.ellipsis,
          maxLines: 1,
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Status and Date Section
              _buildHeaderSection(
                context,
                w,
                '${dateInfo['date']!} - ${dateInfo['time']!}',
              ),
              SizedBox(height: h * 0.03),

              // 2. Map / Locations
              _buildLocationSection(context, w),
              SizedBox(height: h * 0.03),

              // Passenger Info
              AppFonts.textPoppins(
                context,
                "Passenger: ${ride.userId?.name ?? 'Unknown'}",
                w * 0.045,
                FontWeight.w600,
                AppColors.black,
                TextAlign.left,
                TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: h * 0.02),

              // 4. Vehicle & Ride Stats (Distance, Duration)
              _buildRideStatsSection(context, w),
              SizedBox(height: h * 0.03),

              // 5. Fare Details
              _buildFareDetailsSection(context, w),
              SizedBox(height: h * 0.03),

              // 6. Cancellation details if any
              if (ride.orderStatus == "Cancelled")
                _buildCancellationSection(context, w),
              SizedBox(height: h * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    double w,
    String formattedDate,
  ) {
    Color statusColor = ride.orderStatus == "Cancelled"
        ? Colors.red
        : (ride.orderStatus == "Completed" ? Colors.green : Colors.blue);

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFonts.textPoppins(
                context,
                "Status",
                w * 0.03,
                FontWeight.w400,
                AppColors.black.withOpacity(0.6),
                TextAlign.left,
                TextOverflow.ellipsis,
                maxLines: 1,
              ),
              AppFonts.textPoppins(
                context,
                ride.orderStatus ?? "Unknown",
                w * 0.04,
                FontWeight.w600,
                statusColor,
                TextAlign.left,
                TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppFonts.textPoppins(
                context,
                "Date & Time",
                w * 0.03,
                FontWeight.w400,
                AppColors.black.withOpacity(0.6),
                TextAlign.right,
                TextOverflow.ellipsis,
                maxLines: 1,
              ),
              AppFonts.textPoppins(
                context,
                formattedDate,
                w * 0.035,
                FontWeight.w600,
                AppColors.black,
                TextAlign.right,
                TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, double w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFonts.textPoppins(
          context,
          "Trip Route",
          w * 0.04,
          FontWeight.w600,
          AppColors.black,
          TextAlign.left,
          TextOverflow.clip,
          maxLines: 1,
        ),
        SizedBox(height: w * 0.04),
        Row(
          children: [
            Column(
              children: [
                Icon(Icons.circle, color: Colors.green, size: w * 0.04),
                Container(
                  width: 2,
                  height: w * 0.1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                Icon(Icons.location_on, color: Colors.red, size: w * 0.05),
              ],
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppFonts.textPoppins(
                    context,
                    ride.startLocation?.address ?? "Unknown Pickup Location",
                    w * 0.035,
                    FontWeight.w500,
                    AppColors.black,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: w * 0.05),
                  AppFonts.textPoppins(
                    context,
                    ride.endLocation?.address ?? "Unknown Dropoff Location",
                    w * 0.035,
                    FontWeight.w500,
                    AppColors.black,
                    TextAlign.left,
                    TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRideStatsSection(BuildContext context, double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(color: AppColors.lightGray.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            context,
            w,
            Icons.directions_car,
            ride.vehicleSubType?.name ??
                ride.vehicleId?.vehicleName ??
                ride.vehicleType?.name ??
                "Vehicle",
            "Type",
          ),
          _buildStatColumn(
            context,
            w,
            Icons.route,
            "${ride.distance?.toStringAsFixed(1) ?? "0"} km",
            "Distance",
          ),
          _buildStatColumn(
            context,
            w,
            Icons.access_time,
            "${ride.duration ?? 0} mins",
            "Duration",
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    double w,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryRed, size: w * 0.06),
        SizedBox(height: w * 0.02),
        AppFonts.textPoppins(
          context,
          value,
          w * 0.035,
          FontWeight.w600,
          AppColors.black,
          TextAlign.center,
          TextOverflow.ellipsis,
          maxLines: 1,
        ),
        AppFonts.textPoppins(
          context,
          label,
          w * 0.03,
          FontWeight.w400,
          AppColors.black.withOpacity(0.6),
          TextAlign.center,
          TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildFareDetailsSection(BuildContext context, double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFonts.textPoppins(
            context,
            "Fare Details",
            w * 0.04,
            FontWeight.w600,
            AppColors.black,
            TextAlign.left,
            TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: w * 0.04),
          _buildFareRow(
            context,
            w,
            "Payment Method",
            ride.paymentMethod?.toUpperCase() ?? "UNKNOWN",
          ),
          SizedBox(height: w * 0.02),
          _buildFareRow(context, w, "Order Type", ride.orderType ?? "Normal"),

          if (ride.weather != null && ride.weather != "CLEAR") ...[
            SizedBox(height: w * 0.02),
            _buildFareRow(context, w, "Weather", ride.weather!),
          ],

          if (ride.traffic != null && ride.traffic != "LOW") ...[
            SizedBox(height: w * 0.02),
            _buildFareRow(context, w, "Traffic", ride.traffic!),
          ],

          SizedBox(height: w * 0.04),
          const Divider(),
          SizedBox(height: w * 0.04),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppFonts.textPoppins(
                context,
                "Total Fare",
                w * 0.04,
                FontWeight.w600,
                AppColors.black,
                TextAlign.left,
                TextOverflow.ellipsis,
                maxLines: 1,
              ),
              AppFonts.textPoppins(
                context,
                "₹${ride.totalFare ?? 0}",
                w * 0.05,
                FontWeight.w700,
                AppColors.primaryRed,
                TextAlign.right,
                TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(
    BuildContext context,
    double w,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppFonts.textPoppins(
          context,
          label,
          w * 0.035,
          FontWeight.w400,
          AppColors.black.withOpacity(0.7),
          TextAlign.left,
          TextOverflow.ellipsis,
          maxLines: 1,
        ),
        AppFonts.textPoppins(
          context,
          value,
          w * 0.035,
          FontWeight.w600,
          AppColors.black,
          TextAlign.right,
          TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildCancellationSection(BuildContext context, double w) {
    if (ride.cancellationHistory == null || ride.cancellationHistory!.isEmpty) {
      return const SizedBox.shrink();
    }

    final cancelData = ride.cancellationHistory!.last;

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFonts.textPoppins(
            context,
            "Cancellation Details",
            w * 0.035,
            FontWeight.w600,
            Colors.red,
            TextAlign.left,
            TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: w * 0.02),
          AppFonts.textPoppins(
            context,
            "Cancelled By: ${cancelData.cancelledBy ?? 'Unknown'}",
            w * 0.035,
            FontWeight.w500,
            AppColors.black,
            TextAlign.left,
            TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (ride.cancellationReason != null) ...[
            SizedBox(height: w * 0.01),
            AppFonts.textPoppins(
              context,
              "Reason: ${ride.cancellationReason}",
              w * 0.035,
              FontWeight.w400,
              AppColors.black.withOpacity(0.7),
              TextAlign.left,
              TextOverflow.clip,
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }
}
