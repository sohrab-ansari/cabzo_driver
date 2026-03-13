import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class CashPaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? rideData;
  const CashPaymentScreen({super.key, required this.rideData});

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {

    final StepperController stepperController = Get.put(StepperController());
  @override
  void initState() {
    super.initState();
    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('pending_payment_ride');
      if (mounted) {
        Get.offAll(
          () => BottomnavmainScreen(isOnDuty: true),
          transition: Transition.fade,
        );
      }
    });
resetStepper();

    AppLogger.d("myyyy_full_ride_datat ${widget.rideData}");
  }


void resetStepper() {
  stepperController.resetSteps();
}
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        CustomToast.showWarning("Please complete the payment first");
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: w * .2),

              Image.asset(
                'assets/images/cash_collect.png',
                height: w * 0.8,
                width: w * 1.0,
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: w * .02),
                child: AppFonts.textPoppins(
                  context,
                  "Collect Cash Payment",
                  w * 0.065,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.center,
                  TextOverflow.visible,
                ),
              ),

              SizedBox(height: w * .01),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * .04),
                child: AppFonts.textPoppins(
                  context,
                  "Collect the shown fare in cash from the user. Make sure the amount is correct.",
                  w * 0.04,
                  FontWeight.w400,
                  AppColors.mediumGray,
                  TextAlign.center,
                  TextOverflow.visible,
                  maxLines: 2,
                ),
              ),

              SizedBox(height: w * .06),

              // Loading indicator
              CircularProgressIndicator(color: Colors.green),

              SizedBox(height: w * .03),

              AppFonts.textPoppins(
                context,
                "Redirecting to home screen...",
                w * 0.035,
                FontWeight.w400,
                AppColors.darkGray,
                TextAlign.center,
                TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
