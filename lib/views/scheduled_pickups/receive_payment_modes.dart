// import 'package:corezap_driver/controller/controllers.dart';
// import 'package:corezap_driver/utilities/app_buttons.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/payment_modes_screen.dart/cash_payment_screen.dart';
// import 'package:corezap_driver/views/payment_modes_screen.dart/qr_code_screen.dart';
// import 'package:corezap_driver/views/scheduled_pickups/details.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';

// class ReceivePaymentModes extends StatefulWidget {
//   const ReceivePaymentModes({super.key});

//   @override
//   State<ReceivePaymentModes> createState() => _ReceivePaymentModesState();
// }

// class _ReceivePaymentModesState extends State<ReceivePaymentModes> {
//   Controllers controllers = Get.find<Controllers>();
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     controllers.selectPaymentOnQr.value = false;
//     controllers.selectPaymentOnCash.value = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * .04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: w * .3),
//             CustomImages.images(
//               "assets/images/image12.png",
//               double.infinity,
//               w * .6,
//             ),
//             AppFonts.textPoppins(
//               context,
//               "Your Trip is Completed ",
//               w * 0.048,
//               FontWeight.w600,
//               AppColors.black,
//               TextAlign.left,
//               TextOverflow.visible,
//             ),
//             SizedBox(height: w * .03),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: w * .07),
//               child: Details().invoice(context),
//             ),
//             Obx(
//               () => Padding(
//                 padding: EdgeInsets.symmetric(vertical: w * .06),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AppButtons.solid(
//                           context: context,
//                           text: "QR",
//                           suffixIcon: Icon(
//                             Icons.qr_code_scanner,
//                             size: w * .04,
//                             color: controllers.selectPaymentOnQr.value
//                                 ? AppColors.white
//                                 : AppColors.mediumGray,
//                           ),
//                           onClicked: () {
//                             controllers.selectPaymentOnQr.value = true;
//                             controllers.selectPaymentOnCash.value = false;
//                             Future.delayed(Duration(milliseconds: 300), () {
//                               CustomNavigator.push(
//                                 context,
//                                 QrCodeScreen(),
//                                 transition: TransitionType.slideLeft,
//                               );
//                             });
//                             // controllers.selectPaymentOnQr.value = false;
//                           },
//                           width: w * .27,
//                           radius: 20,
//                           backgroundColor: controllers.selectPaymentOnQr.value
//                               ? AppColors.black
//                               : AppColors.lightGray,
//                           height: w * .1,
//                           textColor: controllers.selectPaymentOnQr.value
//                               ? AppColors.white
//                               : AppColors.mediumGray,
//                         )
//                         .animate()
//                         .fade(duration: 600.ms, curve: Curves.easeInOut)
//                         .scale(
//                           begin: const Offset(0.95, 0.95),
//                           end: const Offset(1, 1),
//                         ),
//                     SizedBox(width: w * .03),
//                     AppButtons.solid(
//                           context: context,
//                           text: "Cash",
//                           suffixIcon: Image.asset(
//                             "assets/icons/cashIcon.png",
//                             width: w * .05,
//                             color: controllers.selectPaymentOnCash.value
//                                 ? AppColors.white
//                                 : AppColors.mediumGray,
//                           ),
//                           onClicked: () {
//                             controllers.selectPaymentOnCash.value = true;
//                             controllers.selectPaymentOnQr.value = false;
//                             // 300ms delay (animation dikhane k liye)
//                             Future.delayed(Duration(milliseconds: 300), () {
//                               CustomNavigator.push(
//                                 context,
//                                 CashPaymentScreen(),
//                                 transition: TransitionType.slideLeft,
//                               );
//                             });
//                             // controllers.selectPaymentOnCash.value = false;
//                           },
//                           width: w * .32,
//                           radius: 20,
//                           backgroundColor: controllers.selectPaymentOnCash.value
//                               ? AppColors.black
//                               : AppColors.lightGray,
//                           height: w * .1,
//                           fontSize: w * .04,
//                           textColor: controllers.selectPaymentOnCash.value
//                               ? AppColors.white
//                               : AppColors.mediumGray,
//                         )
//                         .animate()
//                         .fade(duration: 1300.ms, curve: Curves.easeInOut)
//                         .scale(
//                           begin: const Offset(0.95, 0.95),
//                           end: const Offset(1, 1),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: w * .07),
//               child: AppButtons.solid(
//                 context: context,   
//                 text: "Done",
//                 onClicked: () {
//                   // CustomNavigator.push(
//                   //   context,
//                   //   LiveRide(),
//                   //   transition: TransitionType.fade,
//                   // );
//                 },
//                 isFullWidth: true,
//                 backgroundColor: ColorsList.mainButtonColor,
//                 textColor: ColorsList.mainButtonTextColor,  
//                 fontSize: w * .045,
//                 height: w * .140,
//                 radius: 10,
//               ),
//             ),

        
        
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/utilities/app_buttons.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/payment_modes_screen.dart/cash_payment_screen.dart';
import 'package:corezap_driver/views/payment_modes_screen.dart/qr_code_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ReceivePaymentModes extends StatefulWidget {
  const ReceivePaymentModes({super.key});

  @override
  State<ReceivePaymentModes> createState() => _ReceivePaymentModesState();
}

class _ReceivePaymentModesState extends State<ReceivePaymentModes> {
  final Controllers controllers = Get.find<Controllers>();

  @override
  void dispose() {
    controllers.selectPaymentOnQr.value = false;
    controllers.selectPaymentOnCash.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * .06),
          child: Column(
            children: [
              SizedBox(height: w * .08),

              /// 🚗 Illustration
              CustomImages.images(
                "assets/images/image12.png",
                double.infinity,
                w * .6,
              ),

              SizedBox(height: w * .06),

              /// ✅ Title
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

              /// 💳 Payment Detail Card
              Container(
                padding: EdgeInsets.all(w * .00),
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
                child: Details().invoice(context),
              ),

              SizedBox(height: w * .07),

              /// 💰 Payment Mode Buttons
              Obx(
                () => Column(
                  children: [
                    AppButtons.solid(
                      context: context,
                      text: "QR",

                      prefixIcon: Image.asset("assets/images/qr-code1.png",height: w * .05,),
                      
                      // Icon(
                      //   Icons.qr_code_scanner,
                      //   size: w * .05,
                      //   color: controllers.selectPaymentOnQr.value
                      //       ? AppColors.white
                      //       : AppColors.mediumGray,
                      // ),
                      onClicked: () {
                        controllers.selectPaymentOnQr.value = true;
                        controllers.selectPaymentOnCash.value = false;

                        Future.delayed(const Duration(milliseconds: 300), () {
                          CustomNavigator.push(
                            context,
                             QrCodeScreen(),
                            transition: TransitionType.slideLeft,
                          );
                        });
                      },
                      isFullWidth: true,
                      height: w * .13,
                      radius: 14,
                      backgroundColor: controllers.selectPaymentOnQr.value
                          ? ColorsList.mainButtonColor
                          : AppColors.lightGray,
                      textColor: controllers.selectPaymentOnQr.value
                          ? AppColors.white
                          : AppColors.mediumGray,
                    )
                        .animate()
                        .fade(duration: 400.ms)
                        .scale(),

                    SizedBox(height: w * .04),

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
                      onClicked: () {
                        controllers.selectPaymentOnCash.value = true;
                        controllers.selectPaymentOnQr.value = false;

                        Future.delayed(const Duration(milliseconds: 300), () {
                          CustomNavigator.push(
                            context,
                            const CashPaymentScreen(),
                            transition: TransitionType.slideLeft,
                          );
                        });
                      },
                      isFullWidth: true,
                      height: w * .13,
                      radius: 14,
                      backgroundColor: controllers.selectPaymentOnCash.value
                          ? ColorsList.mainButtonColor
                          : AppColors.lightGray,
                      textColor: controllers.selectPaymentOnCash.value
                          ? AppColors.white
                          : AppColors.mediumGray,
                    )
                        .animate()
                        .fade(duration: 500.ms)
                        .scale(),
                  ],
                ),
              ),

              SizedBox(height: w * .08),

              /// ✅ Done Button
              AppButtons.solid(
                context: context,
                text: "Done",
                onClicked: () {



  CustomNavigator.removeUntil(
        context,
        const BottomnavmainScreen(),
        transition: TransitionType.fade,
      );

                  // Navigate wherever needed
                },
                isFullWidth: true,
                height: w * .14,
                radius: 16,
                backgroundColor: ColorsList.mainButtonColor,
                textColor: ColorsList.titleTextColor,
                fontSize: w * .045,
              ),

              SizedBox(height: w * .06),
            ],
          ),
        ),
      ),
    );
  }
}
