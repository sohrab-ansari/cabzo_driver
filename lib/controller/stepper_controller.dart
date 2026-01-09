import 'package:get/get.dart';

class StepperController extends GetxController {
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
    activeStep.value = 1;
  }
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
