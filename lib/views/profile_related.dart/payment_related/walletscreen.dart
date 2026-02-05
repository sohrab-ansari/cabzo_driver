import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/add_money.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/money_transfer_screen.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/transactions.dart';
import 'package:flutter/material.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/wallet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletController walletController = Get.find<WalletController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch data if not already loaded
      if (walletController.walletresponse.value == null) {
        walletController.wallet_method();
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
            // Wallet balance card
            Obx(() {
              final controller = walletController;

              // Show loading indicator for the entire section
              if (controller.isLoading.value &&
                  controller.walletresponse.value == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: w * .1),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Show error message if any
              if (controller.errorMessage.value.isNotEmpty &&
                  controller.walletresponse.value == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: w * .1),
                    child: Column(
                      children: [
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: w * .02),
                        ElevatedButton(
                          onPressed: () => controller.wallet_method(),
                          child: Text("Retry"),
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
                      // onTap: () => Get.to(() => Wallet()),
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

                                  // Show loader only when initially loading
                                  if (controller.walletresponse.value == null &&
                                      controller.isLoading.value)
                                    SizedBox(
                                      height: w * 0.1,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF27C840),
                                              ),
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
                                          Color(0xFF27C840),
                                          TextAlign.center,
                                          TextOverflow.visible,
                                        ).animate().fade(duration: 900.ms).scale(),

                                        // Text("gashdghs"),
                                        const Text(
                                          "Yours wallet balance",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        SizedBox(
                                          width: double.infinity,
                                          child: Divider(),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("i_was_tapped");
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
                                      Color(0xFF27C840),
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
            // SizedBox(
            //   width: double.infinity,
            //   child: Card(
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     elevation: 2,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            //       child: Column(
            //         children: [
            //           const Text(
            //             "₹500.0",
            //             style: TextStyle(
            //               fontSize: 28,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.green,
            //             ),
            //           ),
            //           const SizedBox(height: 8),
            //           const Text(
            //             "Yoursss wallet balance",
            //             style: TextStyle(fontSize: 16, color: Colors.grey),
            //           ),
            //           const SizedBox(height: 12),

            //           SizedBox(
            //             width: double.infinity,
            //             child: Divider()),
            //           GestureDetector(
            //             onTap: () {

            //               print("i_was_tapped");
            //               CustomNavigator.push(
            //                                   context,
            //                                   AddMoney(),
            //                                   transition: TransitionType.slideLeft,
            //                                 );
            //             },
            //             child: const Text(
            //               "+ Add Money",
            //               style: TextStyle(
            //                 color: Colors.red,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 16,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 12),

            const Text(
              "Maintain a minimum balance of ₹200 in your wallet to accept rides.",

              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 20),

            // Money Transfer Card
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

            // Transactions Card
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
