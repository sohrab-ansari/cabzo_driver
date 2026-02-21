import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/home_controllers/network_controller.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';


class NetworkStatusOverlay extends StatelessWidget {
  const NetworkStatusOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the network controller to listen to connection status
    // If not registered yet (e.g. during very early init), assume online to avoid flash
    if (!Get.isRegistered<NetworkController>()) return const SizedBox.shrink();

    final networkController = Get.find<NetworkController>();
    double w = MediaQuery.of(context).size.width;

    return Obx(() {
      // If connected, show nothing (SizedBox.shrink)
      if (networkController.isOnline.value) {
        return const SizedBox.shrink();
      }

      // If disconnected, show the banner in the center with a premium look
      return Material(
        color: Colors.black.withOpacity(
          0.4,
        ), // Dim background to focus attention
        child: Center(
          child:
              Container(
                    width: w * 0.85,
                    padding: EdgeInsets.symmetric(
                      vertical: w * 0.08,
                      horizontal: w * 0.06,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Icon with Pulse Effect
                        Container(
                          padding: EdgeInsets.all(w * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(
                                    Icons
                                        .signal_wifi_connected_no_internet_4_rounded,
                                    color: Colors.red,
                                    size: w * 0.12,
                                  )
                                  .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                  )
                                  .scale(
                                    begin: const Offset(0.9, 0.9),
                                    end: const Offset(1.1, 1.1),
                                    duration: 1000.ms,
                                    curve: Curves.easeInOut,
                                  ),
                        ),

                        SizedBox(height: w * 0.05),

                        AppFonts.textPoppins(
                          context,
                          "No Internet Connection",
                          w * 0.05,
                          FontWeight.w700,
                          Colors.black87,
                          TextAlign.center,
                          TextOverflow.visible,
                        ),

                        SizedBox(height: w * 0.03),

                        AppFonts.textPoppins(
                          context,
                          "Please check your internet settings. We'll reconnect you automatically.",
                          w * 0.035,
                          FontWeight.w400,
                          Colors.grey,
                          TextAlign.center,
                          TextOverflow.visible,
                          maxLines: 2,
                        ),

                        SizedBox(height: w * 0.07),

                        // Reconnecting Status Row
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.04,
                            vertical: w * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: w * 0.035,
                                height: w * 0.035,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(width: w * 0.02),
                              AppFonts.textPoppins(
                                context,
                                "Reconnecting...",
                                w * 0.032,
                                FontWeight.w500,
                                Colors.red,
                                TextAlign.center,
                                TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .scale(duration: 500.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 300.ms),
        ),
      );
    });
  }
}
