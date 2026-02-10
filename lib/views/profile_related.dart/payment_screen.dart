


// import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
// import 'package:nzcu_driver/utilities/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/custom_font.dart';
// import 'package:nzcu_driver/utilities/custom_images.dart';
// import 'package:nzcu_driver/utilities/custom_text.dart';
// import 'package:nzcu_driver/utilities/navigator.dart';
// import 'package:nzcu_driver/views/profile_related.dart/payment_related/add_bank.dart';
// import 'package:nzcu_driver/views/profile_related.dart/payment_related/add_upi.dart';
// import 'package:nzcu_driver/views/profile_related.dart/payment_related/transactions.dart';
// import 'package:nzcu_driver/views/profile_related.dart/payment_related/wallet.dart';
// import 'package:nzcu_driver/views/profile_related.dart/payment_related/walletscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   // Use Get.find instead of Get.put to avoid creating multiple instances
//   // final WalletController walletController = Get.put(WalletController());

//   final WalletController walletController = Get.find<WalletController>();

  
//   // Track if this is the first build
//   bool _isFirstBuild = true;

//   @override
//   void initState() {
//     super.initState();
    
//     // Don't call API directly in initState, use post-frame callback
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Only fetch data if it's not already loaded or if there was an error
//       if (walletController.walletresponse.value == null || 
//           walletController.errorMessage.value.isNotEmpty) {
//         walletController.wallet_method();
//       }
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Alternative: Fetch data when dependencies change
//     if (_isFirstBuild) {
//       _isFirstBuild = false;
//     }
//   }

//   // Add a pull-to-refresh functionality
//   Future<void> _refreshData() async {
//     await walletController.wallet_method();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 250, 250, 250),
//       appBar: AppBar(
//         backgroundColor: ColorsList.scaffoldColor,
//         automaticallyImplyLeading: false,
//         titleSpacing: w * .03,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Use Get.back() instead of CustomNavigator for consistency
//                 Get.back();
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 size: w * .07,
//                 color: ColorsList.iconColor,
//               ),
//             ),
//             SizedBox(width: w * .02),
//             CustomText(
//               text: "Payment",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .04),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppFonts.textPoppins(
//                       context,
//                       "Wallets",
//                       w * 0.04,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     )
//                     .animate()
//                     .fade(duration: 900.ms, curve: Curves.easeInOut)
//                     .scale(
//                       begin: const Offset(0.95, 0.95),
//                       end: const Offset(1, 1),
//                     ),
//                 SizedBox(height: w * .02),

//                 // Use GetBuilder instead of Obx to avoid the setState during build error
//                 GetBuilder<WalletController>(
//                   id: 'wallet-balance', // Add an ID for specific updates
//                   builder: (controller) {
//                     // Show loading indicator
//                     if (controller.isLoading.value && controller.walletresponse.value == null) {
//                       return Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: w * .1),
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     }

//                     // Show error message if any
//                     if (controller.errorMessage.value.isNotEmpty && controller.walletresponse.value == null) {
//                       return Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: w * .1),
//                           child: Column(
//                             children: [
//                               Text(
//                                 controller.errorMessage.value,
//                                 style: TextStyle(color: Colors.red),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: w * .02),
//                               ElevatedButton(
//                                 onPressed: () => controller.wallet_method(),
//                                 child: Text("Retry"),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }

//                     // Show data when available
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               // Use Get.to instead of CustomNavigator
//                               Get.to(() => Wallet());
//                             },
//                             child: Container(
//                               width: double.infinity,
//                               color: ColorsList.scaffoldColor,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: w * .04,
//                                 vertical: w * .04,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: w * .75,
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         AppFonts.textPoppins(
//                                           context,
//                                           "Available Balance",
//                                           w * 0.030,
//                                           FontWeight.w500,
//                                           const Color(0xFF72767C),
//                                           TextAlign.center,
//                                           TextOverflow.visible,
//                                         ).animate().fade(duration: 900.ms).scale(),

//                                         SizedBox(height: w * .01),

//                                         // FIXED: Use null-safe access
//                                         AppFonts.textPoppins(
//                                           context,
//                                           "₹${controller.walletresponse.value?.data?.availableBalance ?? '0'}",
//                                           w * 0.1,
//                                           FontWeight.w600,
//                                           Color(0xFF27C840),
//                                           TextAlign.center,
//                                           TextOverflow.visible,
//                                         ).animate().fade(duration: 900.ms).scale(),

//                                         SizedBox(height: w * .02),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),

//                 SizedBox(height: w * .02),

//                 Row(
//                   children: [
//                     SizedBox(
//                       height: w * .12,
//                       width: w * .45,
//                       child: AppButtons.outlined(
//                         context: context,
//                         text: "Add Money",
//                         onClicked: () {
//                           Get.to(() => WalletScreen());
//                         },
//                         isFullWidth: false,
//                         width: w * .3,
//                         height: w * .08,
//                         borderColor: AppColors.primaryRed,
//                         backgroundColor: AppColors.white,
//                         textColor: AppColors.black,
//                         fontSize: w * .03,
//                         radius: 10,
//                         fontWeight: FontWeight.w500,
//                         padding: EdgeInsets.symmetric(horizontal: w * .005),
//                       ),
//                     ),
//                     SizedBox(width: w * .02),
//                     SizedBox(
//                       height: w * .12,
//                       width: w * .45,
//                       child: AppButtons.outlined(
//                         context: context,
//                         text: "Transactions",
//                         onClicked: () {
//                           Get.to(() => Transactions());
//                         },
//                         isFullWidth: false,
//                         width: w * .3,
//                         height: w * .08,
//                         borderColor: AppColors.primaryRed,
//                         backgroundColor: AppColors.white,
//                         textColor: AppColors.black,
//                         fontSize: w * .03,
//                         radius: 10,
//                         fontWeight: FontWeight.w500,
//                         padding: EdgeInsets.symmetric(horizontal: w * .005),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: w * .06),

//                 AppFonts.textPoppins(
//                       context,
//                       "Add your Account",
//                       w * 0.04,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     )
//                     .animate()
//                     .fade(duration: 900.ms, curve: Curves.easeInOut)
//                     .scale(
//                       begin: const Offset(0.95, 0.95),
//                       end: const Offset(1, 1),
//                     ),
//                 SizedBox(height: w * .02),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppButtons.solid(
//                       context: context,
//                       text: "Bank",
//                       onClicked: () {
//                         Get.to(() => AddBank());
//                       },
//                       prefixIcon: CustomImages.images(
//                         "assets/icons/bank1.png",
//                         w * .04,
//                         w * .04,
//                       ),
//                       isFullWidth: false,
//                       width: w * .44,
//                       backgroundColor: AppColors.white,
//                       textColor: AppColors.black,
//                       fontSize: w * .039,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     AppButtons.solid(
//                       context: context,
//                       text: "UPI Account",
//                       onClicked: () {
//                         Get.to(() => AddUpi());
//                       },
//                       prefixIcon: CustomImages.images(
//                         "assets/icons/upi1.png",
//                         w * .042,
//                         w * .042,
//                       ),
//                       isFullWidth: false,
//                       width: w * .44,
//                       backgroundColor: AppColors.white,
//                       textColor: AppColors.black,
//                       fontSize: w * .039,
//                       fontWeight: FontWeight.w500,
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

import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/utilities/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';
import 'package:nzcu_driver/utilities/custom_images.dart';
import 'package:nzcu_driver/utilities/custom_text.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/add_bank.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/add_upi.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/transactions.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/wallet.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/walletscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? rideData;
  const PaymentScreen({super.key, this.rideData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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

  Future<void> _refreshData() async {
    await walletController.wallet_method();
  }

  

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        automaticallyImplyLeading: false,
        titleSpacing: w * .03,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                size: w * .07,
                color: ColorsList.iconColor,
              ),
            ),
            SizedBox(width: w * .02),
            CustomText(
              text: "Payment",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFonts.textPoppins(
                      context,
                      "Wallets",
                      w * 0.04,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    )
                    .animate()
                    .fade(duration: 900.ms, curve: Curves.easeInOut)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
                SizedBox(height: w * .02),

                // Use Obx for reactive updates
                Obx(() {
                  final controller = walletController;
                  
                  // Show loading indicator for the entire section
                  if (controller.isLoading.value && controller.walletresponse.value == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: w * .1),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Show error message if any
                  if (controller.errorMessage.value.isNotEmpty && controller.walletresponse.value == null) {
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
                          onTap: (){
                            
                          },
                          // onTap: () => Get.to(() => Wallet(balance:  controller.walletresponse.value?.data?.availableBalance,)),
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
                                  width: w * .75,
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
                                      if (controller.walletresponse.value == null && controller.isLoading.value)
                                        SizedBox(
                                          height: w * 0.1,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF27C840)),
                                            ),
                                          ),
                                        )
                                      else if (controller.walletresponse.value != null)
                                        AppFonts.textPoppins(
                                          context,
                                          "₹${controller.walletresponse.value!.data?.availableBalance?.toStringAsFixed(2) ?? '0.00'}",
                                          w * 0.1,
                                          FontWeight.w600,
                                          Color(0xFF27C840),
                                          TextAlign.center,
                                          TextOverflow.visible,
                                        ).animate().fade(duration: 900.ms).scale()
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

                SizedBox(height: w * .02),

                // Rest of your UI...
                Row(
                  children: [
                    SizedBox(
                      height: w * .12,
                      width: w * .45,
                      child: AppButtons.outlined(
                        context: context,
                        text: "Add Money",
                        onClicked: () => Get.to(() => WalletScreen()),
                        isFullWidth: false,
                        width: w * .3,
                        height: w * .08,
                        borderColor: AppColors.primaryRed,
                        backgroundColor: AppColors.white,
                        textColor: AppColors.black,
                        fontSize: w * .03,
                        radius: 10,
                        fontWeight: FontWeight.w500,
                        padding: EdgeInsets.symmetric(horizontal: w * .005),
                      ),
                    ),
                    SizedBox(width: w * .02),
                    SizedBox(
                      height: w * .12,
                      width: w * .45,
                      child: AppButtons.outlined(
                        context: context,
                        text: "Transactions",
                        onClicked: () => Get.to(() => Transactions()),
                        isFullWidth: false,
                        width: w * .3,
                        height: w * .08,
                        borderColor: AppColors.primaryRed,
                        backgroundColor: AppColors.white,
                        textColor: AppColors.black,
                        fontSize: w * .03,
                        radius: 10,
                        fontWeight: FontWeight.w500,
                        padding: EdgeInsets.symmetric(horizontal: w * .005),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: w * .06),

                AppFonts.textPoppins(
                      context,
                      "Add your Account",
                      w * 0.04,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    )
                    .animate()
                    .fade(duration: 900.ms, curve: Curves.easeInOut)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
                SizedBox(height: w * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButtons.solid(
                      context: context,
                      text: "Bank",
                      onClicked: () => Get.to(() => AddBank()),
                      prefixIcon: CustomImages.images(
                        "assets/icons/bank1.png",
                        w * .04,
                        w * .04,
                      ),
                      isFullWidth: false,
                      width: w * .44,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.black,
                      fontSize: w * .039,
                      fontWeight: FontWeight.w500,
                    ),
                    AppButtons.solid(
                      context: context,
                      text: "UPI Account",
                      onClicked: () => Get.to(() => AddUpi()),
                      prefixIcon: CustomImages.images(
                        "assets/icons/upi1.png",
                        w * .042,
                        w * .042,
                      ),
                      isFullWidth: false,
                      width: w * .44,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.black,
                      fontSize: w * .039,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}