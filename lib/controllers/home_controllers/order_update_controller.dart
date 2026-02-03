import 'package:nzcu_driver/apiervices/services/profile_api_services.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/modals/update_order_response.dart';
import 'package:nzcu_driver/utilities/utils/api_response_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderUpdateController extends GetxController {
  final StepperController stepperController = Get.find<StepperController>();
  final Rx<Updateorderresposne?> _updateResponse = Rx<Updateorderresposne?>(
    null,
  );

  // Navigation triggers - make them public with $ suffix to indicate they're Rx
  final RxBool shouldNavigate$ = false.obs;
  final RxString navigationRoute$ = ''.obs;
  final Rx<Map<String, dynamic>?> navigationArgs$ = Rx<Map<String, dynamic>?>(
    null,
  );
  final RxBool clearAll$ = false.obs;

  Updateorderresposne? get updateResponse => _updateResponse.value;

  // Navigation getters for current values
  bool get shouldNavigate => shouldNavigate$.value;
  String get navigationRoute => navigationRoute$.value;
  Map<String, dynamic>? get navigationArgs => navigationArgs$.value;
  bool get clearAll => clearAll$.value;

  // Main method to handle order updates
  void updateOrder({
    required BuildContext context,
    required String buttonId,
    required String orderStatus,
    required String orderId,
    Map<String, dynamic>? rideData,
    String? stepControl,
    String? successMessage,
    bool shouldTriggerNavigation = true,
  }) {
    ApiResponseHandler.handleApiCall(
      context: context,
      buttonId: buttonId,
      apiCall: () => _performOrderUpdate(orderStatus, orderId),
      onSuccess: (response) => _handleSuccess(
        response: response,
        stepControl: stepControl,
        orderStatus: orderStatus,
        rideData: rideData,
        shouldTriggerNavigation: shouldTriggerNavigation,
      ),
      onError: (error) => _handleError(error, buttonId, context),
      successMessage: successMessage,
    );
  }

  Future<Updateorderresposne?> _performOrderUpdate(
    String orderStatus,
    String orderId,
  ) async {
    try {
      return await ProfileApiServices.order_update_data(
        orderstatus: orderStatus,
        orderid: orderId,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _handleSuccess({
    required Updateorderresposne response,
    String? stepControl,
    String? orderStatus,
    Map<String, dynamic>? rideData,
    bool shouldTriggerNavigation = true,
  }) {
    _updateResponse.value = response;

    // Handle stepper updates
    if (stepControl == "Progress") {
      stepperController.nextStep();
    }

    // Determine navigation based on order status
    if (shouldTriggerNavigation) {
      _determineNavigation(orderStatus, rideData);
    }

    if (stepControl == "Completed") {
      print("reeesetting_the_steps_after_done");
      stepperController.resetSteps();
    }

    // stepperController
  }

  void _determineNavigation(
    String? orderStatus,
    Map<String, dynamic>? rideData,
  ) {
    switch (orderStatus?.toLowerCase()) {
      case 'cancelled':
        navigationRoute$.value = 'bottom_nav';
        clearAll$.value = true;
        shouldNavigate$.value = true;
        break;
      case 'accepted':
      case 'arriving':
        navigationRoute$.value = 'arriving_screen';
        navigationArgs$.value = rideData;
        shouldNavigate$.value = true;
        break;
      case 'progress': // Add this case for starting trip
        navigationRoute$.value = 'otp_screen'; // Changed to otp_screen
        navigationArgs$.value = rideData;
        shouldNavigate$.value = true;
        break;
      case 'completed':
        navigationRoute$.value = 'payment_screen';
        clearAll$.value = true;
        shouldNavigate$.value = true;
        break;
      default:
        // Don't trigger navigation for other statuses
        break;
    }
  }
  // void _determineNavigation(
  //   String? orderStatus,
  //   Map<String, dynamic>? rideData,
  // ) {
  //   switch (orderStatus?.toLowerCase()) {
  //     case 'cancelled':
  //       navigationRoute$.value = 'bottom_nav';
  //       clearAll$.value = true;
  //       shouldNavigate$.value = true;
  //       break;
  //     case 'accepted':
  //     case 'arriving':
  //       navigationRoute$.value = 'arriving_screen';
  //       navigationArgs$.value = rideData;
  //       shouldNavigate$.value = true;
  //       break;
  //     case 'completed':
  //       navigationRoute$.value = 'payment_screen';
  //       clearAll$.value = true;
  //       shouldNavigate$.value = true;
  //       break;
  //     default:
  //       // Don't trigger navigation for other statuses
  //       break;
  //   }
  // }

  void _handleError(String error, String buttonId, BuildContext context) {
    print('Order update error on button $buttonId: $error');
  }

  void clearNavigation() {
    shouldNavigate$.value = false;
    navigationRoute$.value = '';
    navigationArgs$.value = null;
    clearAll$.value = false;
  }

  void reset() {
    _updateResponse.value = null;
    clearNavigation();
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
