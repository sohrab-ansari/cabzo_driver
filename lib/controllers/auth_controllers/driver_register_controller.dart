import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class DriverRegisterController extends GetxController {
  late Dio dio;

  @override
  void onInit() {
    super.onInit();

    dio = Dio(
      BaseOptions(
        baseUrl: "https://api.corezap.framekarts.com/api/v1",
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjRjMTMwMzA3MDYyYTUwNzg3NjBkMCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3NjgyODAxOTMsImV4cCI6MTc3MDg3MjE5M30.Cp_rhuX5fFWwT51W3OvUf0lgIhnBPY9D5ku7to9rCdg',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<void> driverRegister({
    required String vehicleName,
    required String vehicleNumber,
    required String vehicleColor,
    required String vehicleType,
    required String vehicleModel,
    required String vehicleCapacity,
    required String vehicleYear,
    required String driverId,
    File? vehicleNumberImage,
    File? vehicleInsuranceImage,
    File? registrationCertificateImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'vehicleName': vehicleName,
        'vehicleNumber': vehicleNumber,
        'vehicleColor': vehicleColor,
        'vehicleType': vehicleType,
        'vehicleStatus': 'Active',
        'vehicleModel': vehicleModel,
        'vehicleCapacity': vehicleCapacity,
        'vehicleYear': vehicleYear,
        'driverId': driverId,

        if (vehicleNumberImage != null)
          'vehicleNumberImage': await MultipartFile.fromFile(
            vehicleNumberImage.path,
            filename: 'vehicle_number.jpg',
          ),

        if (vehicleInsuranceImage != null)
          'vehicleInsuranceImage': await MultipartFile.fromFile(
            vehicleInsuranceImage.path,
            filename: 'insurance.jpg',
          ),

        if (registrationCertificateImage != null)
          'registrationCertificateImage': await MultipartFile.fromFile(
            registrationCertificateImage.path,
            filename: 'rc.jpg',
          ),
      });

      final response = await dio.post(
        "/createVehicle",
        data: formData, // ⚠️ NO contentType here
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess(response.data['message'] ?? "Vehicle created");
      }
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['message']
          : "Server error";

      CustomToast.showError(message);
    }
  }
}
