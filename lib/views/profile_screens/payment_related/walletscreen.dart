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
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await walletController.wallet_method();
          await termsController.terms_pricy_method();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Wallet balance card (Hero) ───────────────────────────────
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

                final data = controller.walletresponse.value?.data;

                return Column(
                  children: [
                    // --- Hero Section ---
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorsList.scaffoldColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: w * .04,
                        vertical: w * .06,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppFonts.textPoppins(
                            context,
                            "Available Balance",
                            w * 0.035,
                            FontWeight.w500,
                            const Color(0xFF72767C),
                            TextAlign.center,
                            TextOverflow.visible,
                          ),
                          SizedBox(height: w * .01),

                          if (data == null && controller.isLoading.value)
                            SizedBox(
                              height: w * 0.1,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF27C840),
                                  ),
                                ),
                              ),
                            )
                          else if (data != null)
                            Column(
                              children: [
                                AppFonts.textPoppins(
                                  context,
                                  "₹${data.availableBalance?.toStringAsFixed(2) ?? '0.00'}",
                                  w * 0.1,
                                  FontWeight.w600,
                                  const Color(0xFF27C840),
                                  TextAlign.center,
                                  TextOverflow.visible,
                                ).animate().fade(duration: 900.ms).scale(),
                                // const Text(
                                //   "Available for withdrawal / use",
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                                // const SizedBox(height: 16),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Divider(),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    AppLogger.d("i_was_tapped");
                                    CustomNavigator.push(
                                      context,
                                      AddMoney(),
                                      transition: TransitionType.slideLeft,
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.blueAccent,
                                        size: 20,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Add Money",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
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
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --- Grid Section ---
                    if (data != null)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  "Wallet Balance",
                                  "₹${data.walletBalance?.toStringAsFixed(2) ?? '0.00'}",
                                  Icons.account_balance_wallet,
                                  Colors.blue,
                                  subtitle: "Total incl. pending",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  "Pending Withdrawals",
                                  "₹${data.pendingWithdrawals?.toStringAsFixed(2) ?? '0.00'}",
                                  Icons.hourglass_empty,
                                  Colors.orange,
                                  subtitle: "Processing by admin",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  "Driver Debt",
                                  "₹${data.driverDebtBalance?.toStringAsFixed(2) ?? '0.00'}",
                                  Icons.warning_amber_rounded,
                                  (data.driverDebtBalance ?? 0) > 0
                                      ? Colors.red
                                      : Colors.green,
                                  subtitle: "Amount owed to admin",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildMetricCard(
                                  context,
                                  "Total Expenses",
                                  "₹${data.totalExpenses?.toStringAsFixed(2) ?? '0.00'}",
                                  Icons.receipt_long,
                                  Colors.purple,
                                  subtitle: "Platform deductions",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              const Text(
                "Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // ── Commission & Minimum balance info cards ──────────────────
              Obx(() {
                final commission =
                    termsController.termspolicyres.value?.data?.driverCommision;
                final minBalance = termsController
                    .termspolicyres
                    .value
                    ?.data
                    ?.driverWalletLimit;

                return Column(
                  children: [
                    // Commission info card
                    if (commission != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryRed.withOpacity(0.08),
                              AppColors.primaryRed.withOpacity(0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryRed.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.percent_rounded,
                              color: AppColors.primaryRed,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Platform commission: ',
                                    ),
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
                      const SizedBox(height: 12),
                    ],

                    // Minimum balance info card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Colors.blueAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.4,
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

              const SizedBox(height: 24),

              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // ── Action Buttons ────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      "Money Transfer",
                      "assets/images/money2.png",
                      () {
                        CustomNavigator.push(
                          context,
                          const MoneyTransferScreen(),
                          transition: TransitionType.fade,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      "Transactions",
                      "assets/images/money3.png",
                      () {
                        CustomNavigator.push(
                          context,
                          Transactions(),
                          transition: TransitionType.slideLeft,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String imagePath,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 36, width: 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
