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
    print("my_Sended_number_came $phoneNumber");
    print("my_Sended_number_came_otp $otp");

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

      print("===== CREATE REGISTER METHOD ======");
      print("name: $name");
      print("email: $email");
      print("phone: $phone");
      print("dob: $dob");
      print("dlImage exists: ${dlImage != null}");
      print("aadharFront exists: ${aadharFront != null}");
      print("aadharBack exists: ${aadharBack != null}");
      print("panImage exists: ${panImage != null}");
      print("alternateContact1: $alternateContact1");
      print("relation1: $relation1");
      print("address1: $address1");
      print("alternateContact2: $alternateContact2");
      print("relation2: $relation2");
      print("address2: $address2");

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

      print("API Response - Success: ${res.success}");
      print("API Response - Message: ${res.message}");

      if (res.success == true) {
        isOtpVerified.value = true;
        print("Registration successful!");
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
      print("Error in createRegisterMethod: $e");
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
      print("\n📸 ===== UPLOAD NEW IMAGE METHOD =====");
      isLoading.value = true;

      print("└─ Image Path: ${image.path}");

      // Call API with File objects
      final DriverImageUploadRes res =
          await AuthApiService.uploadNewDriverImage(
            image: image,

            userType: "Driver",
          );

      print("\n📨 IMAGE UPLOAD RESPONSE:");
      print("├─ Success: ${res.success}");
      print("├─ Message: ${res.message}");
      // print("└─ Data: ${res.data}");

      if (res.success == true) {
        print("\n✅ IMAGE UPLOAD SUCCESSFUL!");

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
      print("\n❌ ERROR IN IMAGE UPLOAD:");
      print("├─ Error: $e");
      CustomToast.showError('Failed to upload profile photo: $e');

      rethrow; // Re-throw to handle in calling method
    } finally {
      isLoading.value = false;
      print("\n🏁 IMAGE UPLOAD COMPLETED");
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
