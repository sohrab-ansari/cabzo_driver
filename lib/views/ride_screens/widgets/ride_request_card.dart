import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/home_controllers/ride_request_queue_controller.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';

class RideRequestCard extends StatelessWidget {
  const RideRequestCard({
    super.key,
    required this.item,
    required this.isBusy,
    required this.isAccepting,
    required this.onAccept,
    required this.onDecline,
  });

  final RideRequestItem item;
  final bool isBusy;
  final bool isAccepting;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  String _str(dynamic v, {String fallback = ''}) {
    final s = v?.toString();
    return (s == null || s.isEmpty) ? fallback : s;
  }

  @override
  Widget build(BuildContext context) {
    final ride = item.rideData;

    final fare = _str(ride['totalFare'] ?? ride['fare'], fallback: '0');
    final pickupAddress = _str(
      ride['startLocation']?['address'] ??
          ride['pickup']?['address'] ??
          ride['pickupLocation'],
      fallback: 'Pickup',
    );
    final dropAddress = _str(
      ride['endLocation']?['address'] ??
          ride['destination']?['address'] ??
          ride['dropoff']?['address'] ??
          ride['dropLocation'],
      fallback: 'Drop',
    );

    final pickupDistance = _str(
      ride['pickupDistance'] ?? ride['distanceToPickup'],
      fallback: '',
    );
    final tripDistance = _str(ride['distance'], fallback: '');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.currency_rupee,
                color: Color(0xFF22C55E),
                size: 20,
              ),
              const SizedBox(width: 2),
              Text(
                fare,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF22C55E),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '#${item.orderId.length > 6 ? item.orderId.substring(item.orderId.length - 6) : item.orderId}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (pickupDistance.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.near_me, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  '$pickupDistance km to pickup',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.circle, size: 10, color: Color(0xFF16A34A)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pickupAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (tripDistance.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.straighten, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  '$tripDistance km trip',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.circle, size: 10, color: Color(0xFFDC2626)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  dropAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: isBusy ? null : onDecline,
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.close, color: Colors.black87),
                  // OutlinedButton(
                  //   onPressed: isBusy ? null : onDecline,
                  //   style: OutlinedButton.styleFrom(
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //     side: BorderSide(color: Colors.grey.shade300),
                  //     backgroundColor: Colors.white,
                  //   ),
                  //   child: const Icon(Icons.close, color: Colors.black87),
                  // ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  final seconds = item.remainingSeconds.value;
                  final bool disabled = isBusy || isAccepting;
                  return ElevatedButton(
                    onPressed: disabled ? null : onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAccepting
                          ? const Color(0xFF00BFA6)
                          : const Color(0xFF00BFA6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: isAccepting
                          ? const Color(0xFF00BFA6)
                          : AppColors.mediumGray.withOpacity(0.4),
                      disabledForegroundColor: isAccepting
                          ? Colors.white
                          : null,
                    ),
                    child: isAccepting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Accepting...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '⏱ $seconds s',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
