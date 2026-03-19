import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/profile_controllers/terms_and_policy_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/profile_screens/payment_related/add_money.dart';
import 'package:nzcu_driver/views/profile_screens/payment_related/money_transfer_screen.dart';
import 'package:nzcu_driver/views/profile_screens/payment_related/transactions.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletController walletController = Get.find<WalletController>();
  final TermsAndPolicyController termsController = Get.put(
    TermsAndPolicyController(),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (walletController.walletresponse.value == null) {
        walletController.wallet_method();
      }
      if (termsController.termspolicyres.value == null) {
        termsController.terms_pricy_method();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Wallet"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ── Wallet balance card ──────────────────────────────────────
            Obx(() {
              final controller = walletController;

              if (controller.isLoading.value &&
                  controller.walletresponse.value == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: w * .1),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.walletresponse.value == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: w * .1),
                    child: Column(
                      children: [
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: w * .02),
                        ElevatedButton(
                          onPressed: () => controller.wallet_method(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        color: ColorsList.scaffoldColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: w * .04,
                          vertical: w * .04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: w * .80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppFonts.textPoppins(
                                    context,
                                    "Available Balance",
                                    w * 0.030,
                                    FontWeight.w500,
                                    const Color(0xFF72767C),
                                    TextAlign.center,
                                    TextOverflow.visible,
                                  ),
                                  SizedBox(height: w * .01),

                                  if (controller.walletresponse.value == null &&
                                      controller.isLoading.value)
                                    SizedBox(
                                      height: w * 0.1,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Color(0xFF27C840)),
                                        ),
                                      ),
                                    )
                                  else if (controller.walletresponse.value !=
                                      null)
                                    Column(
                                      children: [
                                        AppFonts.textPoppins(
                                          context,
                                          "₹${controller.walletresponse.value!.data?.availableBalance?.toStringAsFixed(2) ?? '0.00'}",
                                          w * 0.1,
                                          FontWeight.w600,
                                          const Color(0xFF27C840),
                                          TextAlign.center,
                                          TextOverflow.visible,
                                        ).animate().fade(duration: 900.ms).scale(),
                                        const Text(
                                          "Your wallet balance",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const SizedBox(
                                          width: double.infinity,
                                          child: Divider(),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            AppLogger.d("i_was_tapped");
                                            CustomNavigator.push(
                                              context,
                                              AddMoney(),
                                              transition:
                                                  TransitionType.slideLeft,
                                            );
                                          },
                                          child: const Text(
                                            "+ Add Money",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    AppFonts.textPoppins(
                                      context,
                                      "₹0.00",
                                      w * 0.1,
                                      FontWeight.w600,
                                      const Color(0xFF27C840),
                                      TextAlign.center,
                                      TextOverflow.visible,
                                    ),

                                  SizedBox(height: w * .02),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 12),

            // ── Commission & Minimum balance info cards ──────────────────
            Obx(() {
              final commission =
                  termsController.termspolicyres.value?.data?.driverCommision;
              final minBalance =
                  termsController.termspolicyres.value?.data?.driverWalletLimit;

              return Column(
                children: [
                  // Commission info card
                  if (commission != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryRed.withOpacity(0.08),
                            AppColors.primaryRed.withOpacity(0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primaryRed.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.percent_rounded,
                            color: AppColors.primaryRed,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(text: 'Platform commission: '),
                                  TextSpan(
                                    text: '$commission%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                  const TextSpan(
                                    text:
                                        ' is deducted from each completed ride.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Minimum balance info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Maintain a minimum balance of ',
                                ),
                                TextSpan(
                                  text: minBalance != null
                                      ? '₹${minBalance.toStringAsFixed(0)}'
                                      : '₹200',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' in your wallet to accept rides.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),

            // ── Money Transfer Card ──────────────────────────────────────
            SizedBox(
              width: 250,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    CustomNavigator.push(
                      context,
                      const MoneyTransferScreen(),
                      transition: TransitionType.fade,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/money2.png",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Money Transfer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Transactions Card ────────────────────────────────────────
            SizedBox(
              width: 250,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    CustomNavigator.push(
                      context,
                      Transactions(),
                      transition: TransitionType.slideLeft,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/money3.png",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Transactions",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
