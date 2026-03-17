import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/ride_request_queue_controller.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/views/ride_screens/widgets/ride_request_card.dart';

class RideRequestQueueScreen extends StatefulWidget {
  const RideRequestQueueScreen({super.key});

  static const String routeName = '/ride_request_queue';

  @override
  State<RideRequestQueueScreen> createState() => _RideRequestQueueScreenState();
}

class _RideRequestQueueScreenState extends State<RideRequestQueueScreen> {
  final RideRequestQueueController queue =
      Get.find<RideRequestQueueController>();
  final OrderUpdateController orderUpdateController =
      Get.find<OrderUpdateController>();

  bool _suppressEmptyAutoHome = false;

  @override
  void initState() {
    super.initState();
    AppLogger.d('🧾 [RideQueue] RideRequestQueueScreen opened');
    queue.isQueueScreenOpen.value = true;
  }

  @override
  void dispose() {
    queue.isQueueScreenOpen.value = false;
    super.dispose();
  }

  void _goHomeIfEmpty() {
    if (!queue.hasRides) {
      AppLogger.d('🧾 [RideQueue] Queue empty → going home');
      Get.offAll(() => BottomnavmainScreen(isOnDuty: true));
    }
  }

  Future<void> _acceptRide(RideRequestItem item) async {
    final orderId = item.orderId;
    if (queue.acceptingOrderId.value.isNotEmpty) return;

    _suppressEmptyAutoHome = true;
    queue.markAccepting(orderId);
    NotificationService.instance.cancelRideNotification();

    AppLogger.i('✅ [RideQueue] Accept tapped orderId=$orderId');

    // Keep behavior consistent with existing RideRequestScreen:
    // accept via API (OrderUpdateController) which navigates to ArrivingClient.
    orderUpdateController.updateOrder(
      context: context,
      buttonId: 'accept_button_$orderId',
      orderStatus: 'Accepted',
      orderId: orderId,
      rideData: item.rideData,
      stepControl: 'Accepted',
      successMessage: 'Ride accepted successfully!',
      shouldTriggerNavigation: true,
    );

    // Clear queue immediately to avoid leftover offers after starting a ride.
    queue.clearAll(reason: 'accepted');
  }

  Future<void> _declineRide(RideRequestItem item) async {
    final orderId = item.orderId;
    if (queue.acceptingOrderId.value.isNotEmpty) return;

    NotificationService.instance.cancelRideNotification();
    AppLogger.i('❌ [RideQueue] Decline tapped orderId=$orderId');

    await queue.declineRideNow(orderId, reason: 'decline');
    _goHomeIfEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        CustomToast.showError('Please respond to ride requests first');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF6F7FB), Color(0xFFFFFFFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_bike, size: 20),
                        const SizedBox(width: 10),
                        const Text(
                          'New ride requests',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Obx(() {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${queue.rideRequests.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (queue.rideRequests.isEmpty) {
                        // Defer navigation slightly to avoid setState during build.
                        if (!_suppressEmptyAutoHome) {
                          Future.microtask(_goHomeIfEmpty);
                        }
                        return const SizedBox.shrink();
                      }

                      final accepting = queue.acceptingOrderId.value;

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: queue.rideRequests.length,
                        itemBuilder: (context, index) {
                          final item = queue.rideRequests[index];
                          final isBusy =
                              accepting.isNotEmpty && accepting != item.orderId;

                          return RideRequestCard(
                            item: item,
                            isBusy: isBusy,
                            onAccept: () => _acceptRide(item),
                            onDecline: () => _declineRide(item),
                          );
                        },
                      );
                    }),
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

