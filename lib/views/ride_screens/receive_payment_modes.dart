import 'dart:convert';

import 'package:nzcu_driver/controllers/home_controllers/controllers.dart';
import 'package:nzcu_driver/controllers/home_controllers/cash_controller.dart';
import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/views/payment_modes_screen.dart/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/views/Homeviewscreens/details.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class ReceivePaymentModes extends StatefulWidget {
  final dynamic rideData;

  const ReceivePaymentModes({super.key, required this.rideData});

  @override
  State<ReceivePaymentModes> createState() => _ReceivePaymentModesState();
}

class _ReceivePaymentModesState extends State<ReceivePaymentModes> {
  final Controllers controllers = Get.put(Controllers());
  final CashController cashController = Get.put(CashController());

  // Order details state
  Map<String, dynamic>? _orderDetails;
  bool _isLoadingOrder = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    AppLogger.d("🎯 ReceivePaymentModes initialized");
    AppLogger.d("📦 Ride Data (Pretty):");
    prettyPrint(widget.rideData);

    _fetchOrderDetails();
  }

  void prettyPrint(dynamic data) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(data);
    AppLogger.d(prettyString);
  }

  Future<void> _fetchOrderDetails() async {
    final orderId = widget.rideData?['orderId']?.toString();

    if (orderId == null || orderId.isEmpty) {
      AppLogger.d("❌ No orderId found in rideData");
      setState(() {
        _isLoadingOrder = false;
        _hasError = true;
      });
      return;
    }

    AppLogger.d("🔄 Fetching order details for: $orderId");

    setState(() {
      _isLoadingOrder = true;
      _hasError = false;
    });

    try {
      final data = await HomeApiServices.get_order_details(orderId: orderId);

      if (data != null) {
        AppLogger.d("✅ Order details received:");
        prettyPrint(data);
        setState(() {
          _orderDetails = data;
          _isLoadingOrder = false;
        });
      } else {
        AppLogger.d("❌ Order details returned null");
        setState(() {
          _isLoadingOrder = false;
          _hasError = true;
        });
      }
    } catch (e) {
      AppLogger.d("❌ Exception fetching order details: $e");
      setState(() {
        _isLoadingOrder = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    controllers.selectPaymentOnQr.value = false;
    controllers.selectPaymentOnCash.value = false;
    super.dispose();
  }

  void _handleQrPayment() {
    controllers.selectPaymentOnQr.value = true;
    controllers.selectPaymentOnCash.value = false;

    // Navigate to QR screen
    Get.to(() => QrCodeScreen(), transition: Transition.rightToLeft);
  }

  void _handleCashPayment() {
    if (cashController.isLoading.value) return;

    controllers.selectPaymentOnCash.value = true;
    controllers.selectPaymentOnQr.value = false;

    final orderId = widget.rideData['orderId']?.toString();

    if (orderId == null || orderId.isEmpty) {
      CustomToast.showError('Invalid order ID');
      return;
    }

    AppLogger.d("💰 Processing cash payment for order: $orderId");
    cashController.processCashPayment(
      orderId: orderId,
      rideData: widget.rideData,
    );
  }

  void _handleDone() {
    cashController.navigateToHome();
  }

  Widget _buildInvoiceSection(double w) {
    if (_isLoadingOrder) {
      return Container(
        padding: EdgeInsets.all(w * .06),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              width: w * .06,
              height: w * .06,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsList.mainButtonColor,
                ),
              ),
            ),
            SizedBox(height: w * .03),
            AppFonts.textPoppins(
              context,
              "Loading fare details...",
              w * .035,
              FontWeight.w400,
              AppColors.mediumGray,
              TextAlign.center,
              TextOverflow.visible,
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Container(
        padding: EdgeInsets.all(w * .06),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: w * .08),
            SizedBox(height: w * .02),
            AppFonts.textPoppins(
              context,
              "Failed to load fare details",
              w * .035,
              FontWeight.w500,
              AppColors.black,
              TextAlign.center,
              TextOverflow.visible,
            ),
            SizedBox(height: w * .03),
            GestureDetector(
              onTap: _fetchOrderDetails,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .06,
                  vertical: w * .025,
                ),
                decoration: BoxDecoration(
                  color: ColorsList.mainButtonColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppFonts.textPoppins(
                  context,
                  "Retry",
                  w * .035,
                  FontWeight.w500,
                  AppColors.white,
                  TextAlign.center,
                  TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show invoice with fetched order details
    return Container(
      padding: EdgeInsets.all(w * .04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Details().invoice(context, _orderDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w * .06),
              child: Column(
                children: [
                  SizedBox(height: w * .08),

                  // Illustration
                  CustomImages.images(
                    "assets/images/image12.png",
                    double.infinity,
                    w * .6,
                  ),

                  SizedBox(height: w * .06),

                  // Title
                  AppFonts.textPoppins(
                    context,
                    "Your Trip is Completed",
                    w * .05,
                    FontWeight.w600,
                    AppColors.black,
                    TextAlign.center,
                    TextOverflow.visible,
                  ),

                  SizedBox(height: w * .04),

                  // Invoice Card (with loading/error/data states)
                  _buildInvoiceSection(w),

                  SizedBox(height: w * .07),

                  // Payment Mode Buttons
                  Obx(
                    () => Column(
                      children: [
                        // QR Button
                        AppButtons.solid(
                          context: context,
                          text: "QR",
                          prefixIcon: Image.asset(
                            "assets/images/qr-code1.png",
                            height: w * .05,
                          ),
                          onClicked: _handleQrPayment,
                          isFullWidth: true,
                          height: w * .13,
                          radius: 14,
                          backgroundColor: controllers.selectPaymentOnQr.value
                              ? ColorsList.mainButtonColor
                              : AppColors.lightGray,
                          textColor: controllers.selectPaymentOnQr.value
                              ? AppColors.white
                              : AppColors.mediumGray,
                        ).animate().fade(duration: 400.ms).scale(),

                        SizedBox(height: w * .04),

                        // Cash Button
                        Stack(
                          children: [
                            AppButtons.solid(
                              context: context,
                              text: "Cash",
                              prefixIcon: Image.asset(
                                "assets/images/qr-code3.png",
                                width: w * .06,
                                color: controllers.selectPaymentOnCash.value
                                    ? AppColors.white
                                    : AppColors.mediumGray,
                              ),
                              onClicked: _handleCashPayment,
                              isFullWidth: true,
                              height: w * .13,
                              radius: 14,
                              backgroundColor:
                                  controllers.selectPaymentOnCash.value
                                  ? ColorsList.mainButtonColor
                                  : AppColors.lightGray,
                              textColor: controllers.selectPaymentOnCash.value
                                  ? AppColors.white
                                  : AppColors.mediumGray,
                            ),
                          ],
                        ).animate().fade(duration: 500.ms).scale(),
                      ],
                    ),
                  ),

                  SizedBox(height: w * .08),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
