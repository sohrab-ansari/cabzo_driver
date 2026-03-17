// // // import 'package:get/get.dart';

// // // class StepperController extends GetxController {
// // //   RxInt activeStep = 0.obs;

// // //   void reachStep(int index) {
// // //     activeStep.value = index;
// // //   }

// // //   void nextStep() {
// // //     if (activeStep.value < 3) {
// // //       activeStep.value++;
// // //     }
// // //   }

// // //   void resetSteps() {
// // //     activeStep.value = 1;
// // //   }
// // // }

// // // class DriverFormController extends GetxController {
// // //   RxInt activeStep = 0.obs;

// // //   void reachStep(int index) {
// // //     activeStep.value = index;
// // //   }

// // //   void nextStep() {
// // //     if (activeStep.value < 3) {
// // //       activeStep.value++;
// // //     }
// // //   }

// // //   void resetSteps() {
// // //     activeStep.value = 0;
// // //   }
// // // }



// // import 'package:get/get.dart';

// // class StepperController extends GetxController {
// //   RxInt activeStep = 0.obs;
  
// //   // Define step names for clarity
// //   final List<String> stepNames = [
// //     'Going to Pickup',
// //     'Arrived at Pickup',
// //     'Trip Started',
// //     'Trip Ended'
// //   ];

// //   void reachStep(int index) {
// //     if (index >= 0 && index < 3) {
// //       activeStep.value = index;
// //     }
// //   }

// //   void nextStep() {
// //     if (activeStep.value < 3) {
// //       activeStep.value++;
// //     }
// //   }

// //   void previousStep() {
// //     if (activeStep.value > 0) {
// //       activeStep.value--;
// //     }
// //   }

// //   void resetSteps() {
// //     activeStep.value = 0;
// //   }
  
// //   String get currentStepName => stepNames[activeStep.value];
// // }

// // class DriverFormController extends GetxController {
// //   RxInt activeStep = 0.obs;

// //   void reachStep(int index) {
// //     activeStep.value = index;
// //   }

// //   void nextStep() {
// //     if (activeStep.value < 3) {
// //       activeStep.value++;
// //     }
// //   }

// //   void resetSteps() {
// //     activeStep.value = 0;
// //   }
// // }


// import 'package:get/get.dart';

// class StepperController extends GetxController {
//   RxInt activeStep = 0.obs;
  
//   // Define step names for clarity
//   final List<String> stepNames = [
//     'Going to Pickup',
//     'Arrived at Pickup',
//     'Trip Started',
//     'Trip Completed'
//   ];

//   void reachStep(int index) {
//     if (index >= 0 && index <= 3) {
//       activeStep.value = index;
//     }
//   }

//   void nextStep() {
//     if (activeStep.value < 3) {
//       activeStep.value++;
//     }
//   }

//   void previousStep() {
//     if (activeStep.value > 0) {
//       activeStep.value--;
//     }
//   }

//   void resetSteps() {
//     activeStep.value = 0;
//   }
  
//   String get currentStepName => stepNames[activeStep.value];
// }

// class DriverFormController extends GetxController {
//   RxInt activeStep = 0.obs;

//   void reachStep(int index) {
//     activeStep.value = index;
//   }

//   void nextStep() {
//     if (activeStep.value < 3) {
//       activeStep.value++;
//     }
//   }

//   void resetSteps() {
//     activeStep.value = 0;
//   }
// }


// controllers/home_controllers/stepper_controller.dart
import 'package:get/get.dart';

class StepperController extends GetxController {
  RxInt activeStep = 0.obs;

  // Signal flag: when true, ArrivingClient should re-open the OTP screen.
  // This is used on socket reconnect when status is 'arriving' but OTP not verified.
  // We use a toggle (flip between true/false) so `ever()` always fires even if
  // the previous value was already true.
  RxBool shouldRestoreOtp = false.obs;

  // Define step names for clarity
  final List<String> stepNames = [
    'Going to Pickup',
    'Arrived at Pickup',
    'Trip Started',
    'Trip Completed'
  ];

  void reachStep(int index) {
    if (index >= 0 && index <= 3) {
      activeStep.value = index;
    }
  }

  void nextStep() {
    if (activeStep.value < 3) {
      activeStep.value++;
    }
  }

  void previousStep() {
    if (activeStep.value > 0) {
      activeStep.value--;
    }
  }

  void resetSteps() {
    activeStep.value = 0;
  }

  /// Signals ArrivingClient to restore the OTP screen.
  /// Toggles the flag so `ever()` fires even on repeated calls.
  void signalOtpRestore() {
    shouldRestoreOtp.value = !shouldRestoreOtp.value;
  }

  String get currentStepName => stepNames[activeStep.value];
}

class DriverFormController extends GetxController {
  RxInt activeStep = 0.obs;

  void reachStep(int index) {
    activeStep.value = index;
  }

  void nextStep() {
    if (activeStep.value < 3) {
      activeStep.value++;
    }
  }

  void resetSteps() {
    activeStep.value = 0;
  }
}