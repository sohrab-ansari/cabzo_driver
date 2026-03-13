import 'dart:io';

import 'package:nzcu_driver/services/apiservices/auth_api_service.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/modals/auth_modals/Otp_verify_res.dart';
import 'package:nzcu_driver/modals/auth_modals/create_vehicle_res.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/auth_modals/register_profile_res.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class LoginController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var isOtpVerified = false.obs;
  var isChecked = false.obs;
  var phoneError = ''.obs;
  var otpError = ''.obs;
  var receivedOtp = ''.obs;
  RxBool isProfileCompleted = false.obs;

  RxBool isProfileCompleted22 = false.obs;
  // For storing user data after successful login
  var userData = {}.obs;
  final DriverFormController driverFormController =
      Get.find<DriverFormController>();
  // Function to send OTP
  Future<void> sendOtp(String phoneNumber) async {
    try {
      // Validate phone number
      if (phoneNumber.isEmpty || phoneNumber.length != 10) {
        phoneError.value = 'Please enter a valid 10-digit phone number';
        return;
      }

      phoneError.value = '';
      isLoading.value = true;

      // Call API
      final isSuccess = await AuthApiService.sendOtp(phone: phoneNumber);

      if (isSuccess) {
        isOtpSent.value = true;
        receivedOtp.value = phoneNumber; // Store phone for verification
        CustomToast.showSuccess('OTP sent successfully to $phoneNumber');
      } else {
        phoneError.value = 'Failed to send OTP. Please try again.';
      }
    } catch (e) {
      phoneError.value = 'An error occurred. Please try again.';
      CustomToast.showError('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp({String? otp, String? phoneNumber}) async {
    AppLogger.d("my_Sended_number_came $phoneNumber");
    AppLogger.d("my_Sended_number_came_otp $otp");

    // 🔐 OTP validation
    if (otp == null || otp.isEmpty || otp.length != 4) {
      otpError.value = 'Please enter a valid 4-digit OTP';
      return;
    }

    try {
      otpError.value = '';
      isLoading.value = true;

      final OtpverifyRes res = await AuthApiService.verifyOtp(
        otp: otp,
        phoneNumber: phoneNumber,
      );

      /// ❌ CASE: INVALID OTP / API FAILURE
      if (res.success != true) {
        isOtpVerified.value = false;
        isProfileCompleted.value = false;

        otpError.value = res.message ?? 'Invalid OTP. Please try again.';

        CustomToast.showError(otpError.value);

        return;
      }

      /// ✅ CASE: OTP VERIFIED
      isOtpVerified.value = true;

      /// Driver data may still be null
      if (res.driver == null) {
        isProfileCompleted.value = false;
        return;
      }

      /// Save user data
      userData.value = {
        'id': res.driver!.id,
        'phone': res.driver!.phone,
        'imageVerificationStatus': res.driver!.imageVerificationStatus,
        'isProfileCompleted': res.driver!.isProfileCompleted,
      };

      /// Normalize isProfileCompleted (bool safe)
      final bool profileCompleted =
          res.driver!.isProfileCompleted == true ||
          res.driver!.isProfileCompleted == "true";

      isProfileCompleted.value = profileCompleted;
      isProfileCompleted22.value = profileCompleted;

      CustomToast.showSuccess('OTP verified successfully');
    } catch (e) {
      isOtpVerified.value = false;
      isProfileCompleted.value = false;

      otpError.value = 'Something went wrong. Please try again.';

      CustomToast.showError(otpError.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createVehicleMethod({
    required String vehicleName,
    String? vehicleNumber,
    String? vehicleColor,
    String? vehicleType,
    String? vehicleStatus,
    String? vehicleModel,
    int? vehicleCapacity,
    String? driverId,
    int? vehicleYear,
    File? rcImage,
    File? vehicleInsuraneImage,
    File? vehicleNumberImage,
    String? vehicleSubType,
  }) async {
    try {
      isLoading.value = true;

      // Call API
      final CreateVehicleRes res = await AuthApiService.createVehicle_Api(
        vehicleName: vehicleName,
        driverId: driverId,
        vehicleCapacity: vehicleCapacity,
        vehicleColor: vehicleColor,
        vehicleModel: vehicleModel,
        vehicleNumber: vehicleNumber,
        vehicleStatus: vehicleStatus,
        vehicleType: vehicleType,
        vehicleYear: vehicleYear,
        rcImage: rcImage,
        vehicleInsuraneImage: vehicleInsuraneImage,
        vehicleNumberImage: vehicleNumberImage,
        vehicleSubType: vehicleSubType,
      );

      if (res.success == true) {
        isOtpVerified.value = true;

        CustomToast.showSuccess('Vehicle created successfully');
      } else {
        isOtpVerified.value = false;
        otpError.value =
            res.message ?? 'Failed to create vehicle. Please try again.';
        CustomToast.showError(otpError.value);
      }
    } catch (e) {
      isOtpVerified.value = false;
      otpError.value = 'An error occurred. Please try again.';
      CustomToast.showError(otpError.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRegisterMethod({
    required String name,
    String? email,
    File? dlImage,
    File? aadharFront,
    File? aadharBack,
    File? panImage,
    String? vehicleCapacity,
    String? phone,
    String? dob,
    String? alternateContact1,
    String? relation1,
    String? alternateContact2,
    String? relation2,
    String? address1,
    String? address2,
  }) async {
    try {
      isLoading.value = true;

      AppLogger.d("===== CREATE REGISTER METHOD ======");
      AppLogger.d("name: $name");
      AppLogger.d("email: $email");
      AppLogger.d("phone: $phone");
      AppLogger.d("dob: $dob");
      AppLogger.d("dlImage exists: ${dlImage != null}");
      AppLogger.d("aadharFront exists: ${aadharFront != null}");
      AppLogger.d("aadharBack exists: ${aadharBack != null}");
      AppLogger.d("panImage exists: ${panImage != null}");
      AppLogger.d("alternateContact1: $alternateContact1");
      AppLogger.d("relation1: $relation1");
      AppLogger.d("address1: $address1");
      AppLogger.d("alternateContact2: $alternateContact2");
      AppLogger.d("relation2: $relation2");
      AppLogger.d("address2: $address2");

      // Call API with File objects
      final RegisterProfileRes res = await AuthApiService.createRegister_Api(
        name: name,
        email: email,
        dlImage: dlImage,
        aadharFront: aadharFront,
        aadharBack: aadharBack,
        panImage: panImage,
        phone: phone,
        dob: dob,
        alternateContact1: alternateContact1,
        relation1: relation1,
        alternateContact2: alternateContact2,
        relation2: relation2,
        address1: address1,
        address2: address2,
      );

      AppLogger.d("API Response - Success: ${res.success}");
      AppLogger.d("API Response - Message: ${res.message}");

      if (res.success == true) {
        isOtpVerified.value = true;
        AppLogger.d("Registration successful!");
        driverFormController.activeStep.value = 3;
        CustomToast.showSuccess('Registration completed successfully!');
      } else {
        isOtpVerified.value = false;
        otpError.value =
            res.message ?? 'Registration failed. Please try again.';
        CustomToast.showError(otpError.value);
      }
    } catch (e) {
      isOtpVerified.value = false;
      otpError.value = 'An error occurred. Please try again.';
      AppLogger.d("Error in createRegisterMethod: $e");
      CustomToast.showError('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> upload_new_image({
    required File image,
    BuildContext? context,
  }) async {
    try {
      AppLogger.d("\n📸 ===== UPLOAD NEW IMAGE METHOD =====");
      isLoading.value = true;

      AppLogger.d("└─ Image Path: ${image.path}");

      // Call API with File objects
      final DriverImageUploadRes res =
          await AuthApiService.uploadNewDriverImage(
            image: image,

            userType: "Driver",
          );

      AppLogger.d("\n📨 IMAGE UPLOAD RESPONSE:");
      AppLogger.d("├─ Success: ${res.success}");
      AppLogger.d("├─ Message: ${res.message}");
      // AppLogger.d("└─ Data: ${res.data}");

      if (res.success == true) {
        AppLogger.d("\n✅ IMAGE UPLOAD SUCCESSFUL!");

        CustomNavigator.removeUntil(
          context!,
          LoginScreen(),
          transition: TransitionType.fade,
        );
        CustomToast.showSuccess('Profile photo uploaded successfully!');

        driverFormController.resetSteps();

        return; // Return success
      } else {
        throw Exception(res.message ?? 'Image upload failed');
      }
    } catch (e) {
      AppLogger.d("\n❌ ERROR IN IMAGE UPLOAD:");
      AppLogger.d("├─ Error: $e");
      CustomToast.showError('Failed to upload profile photo: $e');

      rethrow; // Re-throw to handle in calling method
    } finally {
      isLoading.value = false;
      AppLogger.d("\n🏁 IMAGE UPLOAD COMPLETED");
    }
  }
  // Reset state
  void reset() {
    isLoading.value = false;
    isOtpSent.value = false;
    isOtpVerified.value = false;
    phoneError.value = '';
    otpError.value = '';
    receivedOtp.value = '';
    isProfileCompleted.value = false;
  }
}
