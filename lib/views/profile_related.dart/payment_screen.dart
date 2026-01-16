

// import 'package:corezap_driver/controller/profilecontoller/wallet_controller.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/add_bank.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/add_money.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/add_upi.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/transactions.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/wallet.dart';
// import 'package:corezap_driver/views/profile_related.dart/payment_related/walletscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
  

//    final WalletController walletController = Get.put(
//     WalletController(),
//   ); // Add


// @override
//   void initState() {


//     walletController.wallet_method();
//     // TODO: implement initState
//     super.initState();
//   }



//   final List paymentAppNameList = [
//     "PhonePe UPI",
//     "Google Pay",
//     "Paytm UPI",
//     "Amazon Pay UPI",
//   ];
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
//                 CustomNavigator.pop(context);
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
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: w * .04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppFonts.textPoppins(
//                     context,
//                     "Wallets",
//                     w * 0.04,
//                     FontWeight.w600,
//                     AppColors.black,
//                     TextAlign.left,
//                     TextOverflow.visible,
//                   )
//                   .animate()
//                   .fade(duration: 900.ms, curve: Curves.easeInOut)
//                   .scale(
//                     begin: const Offset(0.95, 0.95),
//                     end: const Offset(1, 1),
//                   ),
//               SizedBox(height: w * .02),

          
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         CustomNavigator.push(
//                           context,
//                           Wallet(),
//                           transition: TransitionType.slideLeft,
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         color: ColorsList.scaffoldColor,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: w * .04,
//                           vertical: w * .04,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: w * .75,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   AppFonts.textPoppins(
//                                     context,
//                                     "Available Balance",
//                                     w * 0.030,
//                                     FontWeight.w500,
//                                     const Color(0xFF72767C),
//                                     TextAlign.center,
//                                     TextOverflow.visible,
//                                   ).animate().fade(duration: 900.ms).scale(),

//                                   SizedBox(height: w * .01),

                           

//                                     AppFonts.textPoppins(
//                                     context,
//                                     "₹${walletController.walletresponse.value!.data!.availableBalance}",
//                                     w * 0.1,
//                                     FontWeight.w600,
//                                     Color(0xFF27C840),
//                                     // AppColors.green,
//                                     TextAlign.center,
//                                     TextOverflow.visible,
//                                   ).animate().fade(duration: 900.ms).scale(),

//                                   SizedBox(height: w * .02),


//                                   // walletController
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Row(
//                 children: [
//                   SizedBox(
//                     height: w * .12,
//                     width: w * .45,
//                     child: AppButtons.outlined(
//                       context: context,
//                       text: "Add Money",
//                       onClicked: () {
//                         CustomNavigator.push(
//                           context,
//                           WalletScreen(),
//                           transition: TransitionType.slideLeft,
//                         );
//                       },
//                       // prefixIcon: Container(
//                       //   width: w * .04,
//                       //   height: w * .04,
//                       //   decoration: BoxDecoration(
//                       //     borderRadius: BorderRadius.circular(20),
//                       //     color: ColorsList.addBackgroundColor,
//                       //   ),
//                       //   child: Icon(
//                       //     Icons.add,
//                       //     color: ColorsList.mainButtonColor,
//                       //     size: w * .04,
//                       //   ),
//                       // ),
//                       isFullWidth: false,
//                       width: w * .3,
//                       height: w * .08,
//                       borderColor: AppColors.primaryRed,
//                       backgroundColor: AppColors.white,
//                       textColor: AppColors.black,
//                       fontSize: w * .03,
//                       radius: 10,
//                       fontWeight: FontWeight.w500,
//                       padding: EdgeInsets.symmetric(horizontal: w * .005),
//                     ),
//                   ),
//                   //-----------------
//                   SizedBox(width: w * .02),
//                   SizedBox(
//                     height: w * .12,
//                     width: w * .45,
//                     child: AppButtons.outlined(
//                       context: context,
//                       text: "Transactions",
//                       onClicked: () {
//                         CustomNavigator.push(
//                           context,
//                           Transactions(),
//                           transition: TransitionType.slideLeft,
//                         );
//                       },

//                       // prefixIcon: CustomImages.images(
//                       //   "assets/icons/transButtonIcon.png",
//                       //   w * .04,
//                       //   w * .04,
//                       // ),
//                       isFullWidth: false,
//                       width: w * .3,
//                       height: w * .08,
//                       borderColor: AppColors.primaryRed,
//                       backgroundColor: AppColors.white,
//                       textColor: AppColors.black,
//                       fontSize: w * .03,
//                       radius: 10,
//                       fontWeight: FontWeight.w500,
//                       padding: EdgeInsets.symmetric(horizontal: w * .005),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: w * .06),

//               AppFonts.textPoppins(
//                     context,
//                     "Add your Account",
//                     w * 0.04,
//                     FontWeight.w600,
//                     AppColors.black,
//                     TextAlign.left,
//                     TextOverflow.visible,
//                   )
//                   .animate()
//                   .fade(duration: 900.ms, curve: Curves.easeInOut)
//                   .scale(
//                     begin: const Offset(0.95, 0.95),
//                     end: const Offset(1, 1),
//                   ),
//               SizedBox(height: w * .02),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   AppButtons.solid(
//                     context: context,
//                     text: "Bank",
//                     onClicked: () {
//                       CustomNavigator.push(
//                         context,
//                         AddBank(),
//                         transition: TransitionType.fade,
//                       );
//                     },
//                     prefixIcon: CustomImages.images(
//                       "assets/icons/bank1.png",
//                       w * .04,
//                       w * .04,
//                     ),
//                     isFullWidth: false,
//                     width: w * .44,
//                     // height: w * .0,
//                     backgroundColor: AppColors.white,
//                     textColor: AppColors.black,
//                     fontSize: w * .039,
//                     //  radius: 3,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   AppButtons.solid(
//                     context: context,
//                     text: "UPI Account",
//                     onClicked: () {
//                       CustomNavigator.push(
//                         context,
//                         AddUpi(),
//                         transition: TransitionType.fade,
//                       );
//                     },
//                     prefixIcon: CustomImages.images(
//                       "assets/icons/upi1.png",
//                       w * .042,
//                       w * .042,
//                     ),
//                     isFullWidth: false,
//                     width: w * .44,
//                     //    height: w * .0,
//                     backgroundColor: AppColors.white,
//                     textColor: AppColors.black,
//                     fontSize: w * .039,
//                     //radius: 30,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:corezap_driver/controller/profilecontoller/wallet_controller.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/add_bank.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/add_upi.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/transactions.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/wallet.dart';
import 'package:corezap_driver/views/profile_related.dart/payment_related/walletscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final WalletController walletController = 

  Get.put(WalletController());

  @override
  void initState() {
    super.initState();
    walletController.wallet_method();
  }

  final List paymentAppNameList = [
    "PhonePe UPI",
    "Google Pay",
    "Paytm UPI",
    "Amazon Pay UPI",
  ];

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
              onTap: () {
                CustomNavigator.pop(context);
              },
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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

              // Use Obx to reactively update when data loads
              Obx(() {
                // Show loading indicator
                if (walletController.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: w * .1),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Show error message if any
                if (walletController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: w * .1),
                      child: Text(
                        walletController.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                // Show data when available
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          CustomNavigator.push(
                            context,
                            Wallet(),
                            transition: TransitionType.slideLeft,
                          );
                        },
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
                                    ).animate().fade(duration: 900.ms).scale(),

                                    SizedBox(height: w * .01),

                                    // FIXED: Use null-safe access
                                    AppFonts.textPoppins(
                                      context,
                                      "₹${walletController.walletresponse.value?.data?.availableBalance ?? '0'}",
                                      w * 0.1,
                                      FontWeight.w600,
                                      Color(0xFF27C840),
                                      TextAlign.center,
                                      TextOverflow.visible,
                                    ).animate().fade(duration: 900.ms).scale(),

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

              Row(
                children: [
                  SizedBox(
                    height: w * .12,
                    width: w * .45,
                    child: AppButtons.outlined(
                      context: context,
                      text: "Add Money",
                      onClicked: () {
                        CustomNavigator.push(
                          context,
                          WalletScreen(),
                          transition: TransitionType.slideLeft,
                        );
                      },
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
                      onClicked: () {
                        CustomNavigator.push(
                          context,
                          Transactions(),
                          transition: TransitionType.slideLeft,
                        );
                      },
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
                    onClicked: () {
                      CustomNavigator.push(
                        context,
                        AddBank(),
                        transition: TransitionType.fade,
                      );
                    },
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
                    onClicked: () {
                      CustomNavigator.push(
                        context,
                        AddUpi(),
                        transition: TransitionType.fade,
                      );
                    },
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
    );
  }
}