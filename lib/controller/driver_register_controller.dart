


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DriverRegisterController extends GetxController {
  Future<void> Driver_register_controll_method1({
    String? vehicleName,
    String? vehicleNumber,
    String? vehicleColor,
    String? vehicleType,
    String? vehicleStatus,
    String? vehicleModel,
    String? vehicleCapacity,
    String? vehicleYear,
    File? vehicleNumberImageFile,
    File? vehicleInsuraneImageFile,
    File? registrationCertificateImageFile,
    String? driverId,
  }) async {
    final url = Uri.parse(
      "https://api.corezap.framekarts.com/api/v1/createVehicle",
    );

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add text fields
      request.fields['vehicleName'] = vehicleName ?? '';
      request.fields['vehicleNumber'] = vehicleNumber ?? '';
      request.fields['vehicleColor'] = vehicleColor ?? '';
      request.fields['vehicleType'] = vehicleType ?? '';
      request.fields['vehicleStatus'] = vehicleStatus ?? 'pending';
      request.fields['vehicleModel'] = vehicleModel ?? '';
      request.fields['vehicleCapacity'] = vehicleCapacity ?? '';
      request.fields['vehicleYear'] = vehicleYear ?? '';
      request.fields['driverId'] = driverId ?? '695907abb30f1d4e3c7ce75c';

      // Add image files if they exist
      if (vehicleNumberImageFile != null && vehicleNumberImageFile.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'vehicleNumberImage',
            vehicleNumberImageFile.path,
            filename: 'vehicle_number.jpg',
          ),
        );
      }

      if (vehicleInsuraneImageFile != null && vehicleInsuraneImageFile.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'vehicleInsuraneImage',
            vehicleInsuraneImageFile.path,
            filename: 'vehicle_insurance.jpg',
          ),
        );
      }

      if (registrationCertificateImageFile != null && 
          registrationCertificateImageFile.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'registrationCertificateImage',
            registrationCertificateImageFile.path,
            filename: 'registration_certificate.jpg',
          ),
        );
      }

      print("Sending multipart request with ${request.files.length} files");

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Vehicle details submitted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = data['message'] ?? "Something went wrong";
        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar(
        "Error",
        "Server error: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
}