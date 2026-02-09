import 'dart:async';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';

class OtpController extends GetxController {

   final LoginController loginController = Get.find<LoginController>();
  var secondsRemaining = 29.obs; // countdown value
  Timer? _timer;

  void startTimer() {
    secondsRemaining.value = 29;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendCode({required String phoneNumber}) {
    
    loginController.sendOtp(phoneNumber);
    // Yaha resend API call ya logic lagana
    print("Resend OTP clicked!");
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
