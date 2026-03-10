


// // // // // import 'dart:convert';
// // // // // import 'dart:io';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:get/get.dart';
// // // // // import 'package:http/http.dart' as http;

// // // // // class DriverRegisterController extends GetxController {
// // // // //   Future<void> Driver_register_controll_method1({
// // // // //     String? vehicleName,
// // // // //     String? vehicleNumber,
// // // // //     String? vehicleColor,
// // // // //     String? vehicleType,
// // // // //     String? vehicleStatus,
// // // // //     String? vehicleModel,
// // // // //     String? vehicleCapacity,
// // // // //     String? vehicleYear,
// // // // //     File? vehicleNumberImageFile,
// // // // //     File? vehicleInsuraneImageFile,
// // // // //     File? registrationCertificateImageFile,
// // // // //     String? driverId,
// // // // //   }) async {
// // // // //     final url = Uri.parse(
// // // // //       "https://api.corezap.framekarts.com/api/v1/createVehicle",
// // // // //     );

// // // // //     try {
// // // // //       // Create multipart request
// // // // //       var request = http.MultipartRequest('POST', url);

// // // // //       // Add text fields
// // // // //       request.fields['vehicleName'] = vehicleName ?? '';
// // // // //       request.fields['vehicleNumber'] = vehicleNumber ?? '';
// // // // //       request.fields['vehicleColor'] = vehicleColor ?? '';
// // // // //       request.fields['vehicleType'] = vehicleType ?? '';
// // // // //       request.fields['vehicleStatus'] = vehicleStatus ?? 'pending';
// // // // //       request.fields['vehicleModel'] = vehicleModel ?? '';
// // // // //       request.fields['vehicleCapacity'] = vehicleCapacity ?? '';
// // // // //       request.fields['vehicleYear'] = vehicleYear ?? '';
// // // // //       request.fields['driverId'] = driverId ?? '695907abb30f1d4e3c7ce75c';

// // // // //       // Add image files if they exist
// // // // //       if (vehicleNumberImageFile != null && vehicleNumberImageFile.existsSync()) {
// // // // //         request.files.add(
// // // // //           await http.MultipartFile.fromPath(
// // // // //             'vehicleNumberImage',
// // // // //             vehicleNumberImageFile.path,
// // // // //             filename: 'vehicle_number.jpg',
// // // // //           ),
// // // // //         );
// // // // //       }

// // // // //       if (vehicleInsuraneImageFile != null && vehicleInsuraneImageFile.existsSync()) {
// // // // //         request.files.add(
// // // // //           await http.MultipartFile.fromPath(
// // // // //             'vehicleInsuraneImage',
// // // // //             vehicleInsuraneImageFile.path,
// // // // //             filename: 'vehicle_insurance.jpg',
// // // // //           ),
// // // // //         );
// // // // //       }

// // // // //       if (registrationCertificateImageFile != null && 
// // // // //           registrationCertificateImageFile.existsSync()) {
// // // // //         request.files.add(
// // // // //           await http.MultipartFile.fromPath(
// // // // //             'registrationCertificateImage',
// // // // //             registrationCertificateImageFile.path,
// // // // //             filename: 'registration_certificate.jpg',
// // // // //           ),
// // // // //         );
// // // // //       }

// // // // //       print("Sending multipart request with ${request.files.length} files");

// // // // //       // Send the request
// // // // //       var streamedResponse = await request.send();
// // // // //       var response = await http.Response.fromStream(streamedResponse);

// // // // //       print("STATUS CODE: ${response.statusCode}");
// // // // //       print("RESPONSE BODY: ${response.body}");

// // // // //       if (response.statusCode == 200) {
// // // // //         Get.snackbar(
// // // // //           "Success",
// // // // //           "Vehicle details submitted successfully",
// // // // //           backgroundColor: Colors.green,
// // // // //           colorText: Colors.white,
// // // // //         );
// // // // //       } else {
// // // // //         final data = jsonDecode(response.body);
// // // // //         String errorMessage = data['message'] ?? "Something went wrong";
// // // // //         Get.snackbar(
// // // // //           "Error",
// // // // //           errorMessage,
// // // // //           backgroundColor: Colors.red,
// // // // //           colorText: Colors.white,
// // // // //         );
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print("ERROR: $e");
// // // // //       Get.snackbar(
// // // // //         "Error",
// // // // //         "Server error: $e",
// // // // //         backgroundColor: Colors.red,
// // // // //         colorText: Colors.white,
// // // // //       );
// // // // //       rethrow;
// // // // //     }
// // // // //   }
// // // // // }


// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:http/http.dart' as http;

// // // // class DriverRegisterController extends GetxController {
// // // //   Future<void> Driver_register_controll_method1({
// // // //     String? vehicleName,
// // // //     String? vehicleNumber,
// // // //     String? vehicleColor,
// // // //     String? vehicleType,
// // // //     String? vehicleStatus,
// // // //     String? vehicleModel,
// // // //     String? vehicleCapacity,
// // // //     String? vehicleYear,
// // // //     File? vehicleNumberImageFile,
// // // //     File? vehicleInsuranceImageFile,
// // // //     File? registrationCertificateImageFile,
// // // //     String? driverId,
// // // //   }) async {
// // // //     final url = Uri.parse(
// // // //       "https://api.corezap.framekarts.com/api/v1/createVehicle",
// // // //     );

// // // //     try {
// // // //       // 🔹 Create multipart request
// // // //       var request = http.MultipartRequest('POST', url);

// // // //       // 🔐 Static Bearer Token
// // // //       request.headers['Authorization'] =
// // // //           'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjRjMTMwMzA3MDYyYTUwNzg3NjBkMCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3NjgyODAxOTMsImV4cCI6MTc3MDg3MjE5M30.Cp_rhuX5fFWwT51W3OvUf0lgIhnBPY9D5ku7to9rCdg';

// // // //       request.headers['Accept'] = 'application/json';

// // // //       // 🔹 Text fields
// // // //       // request.fields['vehicleName'] = vehicleName ?? '';
// // // //       // request.fields['vehicleNumber'] = vehicleNumber ?? '';
// // // //       // request.fields['vehicleColor'] = vehicleColor ?? '';
// // // //       // request.fields['vehicleType'] = vehicleType ?? '';
// // // //       // request.fields['vehicleStatus'] = vehicleStatus ?? 'pending';
// // // //       // request.fields['vehicleModel'] = vehicleModel ?? '';
// // // //       // request.fields['vehicleCapacity'] = vehicleCapacity ?? '';
// // // //       // request.fields['vehicleYear'] = vehicleYear ?? '';
// // // //       // request.fields['driverId'] =
// // // //       //     driverId ?? '695907abb30f1d4e3c7ce75c';

// // // //       request.fields['vehicleName'] = "honda civic" ?? '';
// // // //       request.fields['vehicleNumber'] = "MH12sdfsdASsdssdsadfsdddsdssafasdB112ddfsSDsas4adssd39adasdasasadsssss" ?? '';
// // // //       request.fields['vehicleColor'] = "Blue" ?? '';
// // // //       request.fields['vehicleType'] = "691581132fbb2cbdd65fbd8d" ?? '';
// // // //       request.fields['vehicleStatus'] = "Active" ?? 'pending';
// // // //       request.fields['vehicleModel'] = "VXI" ?? '';
// // // //       request.fields['vehicleCapacity'] = "4" ?? '';
// // // //       request.fields['vehicleYear'] = "2019" ?? '';
// // // //       request.fields['driverId'] =
// // // //           driverId ?? '695907abb30f1d4e3c7ce75c';

// // // //       // 🔹 Vehicle Number Image
// // // //       if (vehicleNumberImageFile != null &&
// // // //           vehicleNumberImageFile.existsSync()) {
// // // //         request.files.add(
// // // //           await http.MultipartFile.fromPath(
// // // //             'vehicleNumberImage',
// // // //             vehicleNumberImageFile.path,
// // // //             filename: 'vehicle_number.jpg',
// // // //           ),
// // // //         );
// // // //       }

// // // //       // 🔹 Insurance Image
// // // //       if (vehicleInsuranceImageFile != null &&
// // // //           vehicleInsuranceImageFile.existsSync()) {
// // // //         request.files.add(
// // // //           await http.MultipartFile.fromPath(
// // // //             'vehicleInsuraneImage',
// // // //             vehicleInsuranceImageFile.path,
// // // //             filename: 'vehicle_insurance.jpg',
// // // //           ),
// // // //         );
// // // //       }

// // // //       // 🔹 Registration Certificate Image
// // // //       if (registrationCertificateImageFile != null &&
// // // //           registrationCertificateImageFile.existsSync()) {
// // // //         request.files.add(
// // // //           await http.MultipartFile.fromPath(
// // // //             'registrationCertificateImage',
// // // //             registrationCertificateImageFile.path,
// // // //             filename: 'registration_certificate.jpg',
// // // //           ),
// // // //         );
// // // //       }

// // // //       print("🚀 Sending request with ${request.files.length} files");

// // // //       // 🔹 Send request
// // // //       var streamedResponse = await request.send();
// // // //       var response = await http.Response.fromStream(streamedResponse);

// // // //       print("📌 STATUS CODE: ${response.statusCode}");
// // // //       print("📦 RESPONSE BODY: ${response.body}");

// // // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // // //         Get.snackbar(
// // // //           "Success",
// // // //           "Vehicle details submitted successfully",
// // // //           backgroundColor: Colors.green,
// // // //           colorText: Colors.white,
// // // //         );
// // // //       } else {
// // // //         final data = jsonDecode(response.body);
// // // //         Get.snackbar(
// // // //           "Error",
// // // //           data['message'] ?? "Something went wrong",
// // // //           backgroundColor: Colors.red,
// // // //           colorText: Colors.white,
// // // //         );
// // // //       }
// // // //     } catch (e) {
// // // //       print("❌ ERROR: $e");
// // // //       Get.snackbar(
// // // //         "Error",
// // // //         "Server error: $e",
// // // //         backgroundColor: Colors.red,
// // // //         colorText: Colors.white,
// // // //       );
// // // //     }
// // // //   }
// // // // }


// // // import 'dart:convert';
// // // import 'dart:io';

// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:http/http.dart' as http;

// // // class DriverRegisterController extends GetxController {

// // //   Future<void> driverRegister({
// // //     required String vehicleName,
// // //     required String vehicleNumber,
// // //     required String vehicleColor,
// // //     required String vehicleType,
// // //     required String vehicleModel,
// // //     required String vehicleCapacity,
// // //     required String vehicleYear,
// // //     required String driverId,
// // //     File? vehicleNumberImage,
// // //     File? vehicleInsuranceImage,
// // //     File? registrationCertificateImage,
// // //   }) async {

// // //     final url = Uri.parse(
// // //       "https://api.corezap.framekarts.com/api/v1/createVehicle",
// // //     );

// // //     try {
// // //       // 🔹 Multipart request
// // //       final request = http.MultipartRequest('POST', url);

// // //       // 🔐 Headers
// // //       request.headers.addAll({
// // //         'Authorization':
// // //             'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjRjMTMwMzA3MDYyYTUwNzg3NjBkMCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3NjgyODAxOTMsImV4cCI6MTc3MDg3MjE5M30.Cp_rhuX5fFWwT51W3OvUf0lgIhnBPY9D5ku7to9rCdg',
// // //         'Accept': 'application/json',
// // //       });

// // //       // 🔹 Text fields
// // //       request.fields.addAll({
// // //         'vehicleName': vehicleName,
// // //         'vehicleNumber': vehicleNumber, // e.g. MH12AB1234
// // //         'vehicleColor': vehicleColor,
// // //         'vehicleType': vehicleType,     // VALID backend ID
// // //         'vehicleStatus': 'Active',
// // //         'vehicleModel': vehicleModel,
// // //         'vehicleCapacity': vehicleCapacity,
// // //         'vehicleYear': vehicleYear,
// // //         'driverId': driverId,
// // //       });

// // //       // 🔹 Vehicle number image
// // //       if (vehicleNumberImage != null && vehicleNumberImage.existsSync()) {
// // //         request.files.add(
// // //           await http.MultipartFile.fromPath(
// // //             'vehicleNumberImage',
// // //             vehicleNumberImage.path,
// // //           ),
// // //         );
// // //       }

// // //       // 🔹 Insurance image (FIXED KEY)
// // //       if (vehicleInsuranceImage != null &&
// // //           vehicleInsuranceImage.existsSync()) {
// // //         request.files.add(
// // //           await http.MultipartFile.fromPath(
// // //             'vehicleInsuranceImage',
// // //             vehicleInsuranceImage.path,
// // //           ),
// // //         );
// // //       }

// // //       // 🔹 RC image
// // //       if (registrationCertificateImage != null &&
// // //           registrationCertificateImage.existsSync()) {
// // //         request.files.add(
// // //           await http.MultipartFile.fromPath(
// // //             'registrationCertificateImage',
// // //             registrationCertificateImage.path,
// // //           ),
// // //         );
// // //       }

// // //       print("🚀 Sending request with ${request.files.length} files");

// // //       // 🔹 Send
// // //       final streamedResponse = await request.send();
// // //       final response = await http.Response.fromStream(streamedResponse);

// // //       print("📌 STATUS CODE: ${response.statusCode}");
// // //       print("📦 RESPONSE BODY: ${response.body}");

// // //       // ✅ Success
// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         Get.snackbar(
// // //           "Success",
// // //           "Vehicle created successfully",
// // //           backgroundColor: Colors.green,
// // //           colorText: Colors.white,
// // //         );
// // //         return;
// // //       }

// // //       // ❌ Error (SAFE JSON HANDLING)
// // //       String errorMessage = "Server error (${response.statusCode})";

// // //       try {
// // //         final data = jsonDecode(response.body);
// // //         errorMessage = data['message'] ?? errorMessage;
// // //       } catch (_) {
// // //         // HTML or plain text response
// // //       }

// // //       Get.snackbar(
// // //         "Error",
// // //         errorMessage,
// // //         backgroundColor: Colors.red,
// // //         colorText: Colors.white,
// // //       );

// // //     } catch (e) {
// // //       print("❌ EXCEPTION: $e");

// // //       Get.snackbar(
// // //         "Error",
// // //         "Something went wrong",
// // //         backgroundColor: Colors.red,
// // //         colorText: Colors.white,
// // //       );
// // //     }
// // //   }
// // // }


// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:http_parser/http_parser.dart';

// // class DriverRegisterController extends GetxController {

// //   Future<void> driverRegister({
// //     required String vehicleName,
// //     required String vehicleNumber,
// //     required String vehicleColor,
// //     required String vehicleType,
// //     required String vehicleModel,
// //     required String vehicleCapacity,
// //     required String vehicleYear,
// //     required String driverId,
// //     File? vehicleNumberImage,
// //     File? vehicleInsuranceImage,
// //     File? registrationCertificateImage,
// //   }) async {

// //     final uri = Uri.parse(
// //       "https://api.corezap.framekarts.com/api/v1/createVehicle",
// //     );

// //     try {
// //       final request = http.MultipartRequest('POST', uri);

// //       // ✅ ONLY headers that Postman sends
// //       request.headers.addAll({
// //         'Authorization':
// //             'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjRjMTMwMzA3MDYyYTUwNzg3NjBkMCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3NjgyODAxOTMsImV4cCI6MTc3MDg3MjE5M30.Cp_rhuX5fFWwT51W3OvUf0lgIhnBPY9D5ku7to9rCdg',
// //         'Accept': 'application/json',
// //       });

// //       // ✅ FORM DATA (TEXT)
// //       request.fields.addAll({
// //         'vehicleName': vehicleName,
// //         'vehicleNumber': vehicleNumber,
// //         'vehicleColor': vehicleColor,
// //         'vehicleType': vehicleType,
// //         'vehicleStatus': 'Active',
// //         'vehicleModel': vehicleModel,
// //         'vehicleCapacity': vehicleCapacity,
// //         'vehicleYear': vehicleYear,
// //         'driverId': driverId,
// //       });

// //       // ✅ FILE: Vehicle Number Image
// //       if (vehicleNumberImage != null) {
// //         request.files.add(
// //           await http.MultipartFile.fromPath(
// //             'vehicleNumberImage',
// //             vehicleNumberImage.path,
// //             filename: 'vehicle_number.jpg',
// //             contentType: MediaType('image', 'jpeg'),
// //           ),
// //         );
// //       }

// //       // ✅ FILE: Insurance Image
// //       if (vehicleInsuranceImage != null) {
// //         request.files.add(
// //           await http.MultipartFile.fromPath(
// //             'vehicleInsuranceImage',
// //             vehicleInsuranceImage.path,
// //             filename: 'insurance.jpg',
// //             contentType: MediaType('image', 'jpeg'),
// //           ),
// //         );
// //       }

// //       // ✅ FILE: RC Image
// //       if (registrationCertificateImage != null) {
// //         request.files.add(
// //           await http.MultipartFile.fromPath(
// //             'registrationCertificateImage',
// //             registrationCertificateImage.path,
// //             filename: 'rc.jpg',
// //             contentType: MediaType('image', 'jpeg'),
// //           ),
// //         );
// //       }

// //       print("🚀 FILE COUNT: ${request.files.length}");
// //       print("📤 FIELDS: ${request.fields}");

// //       final streamedResponse = await request.send();
// //       final response = await http.Response.fromStream(streamedResponse);

// //       print("📌 STATUS: ${response.statusCode}");
// //       print("📦 BODY: ${response.body}");

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         Get.snackbar(
// //           "Success",
// //           "Vehicle created successfully",
// //           backgroundColor: Colors.green,
// //           colorText: Colors.white,
// //         );
// //         return;
// //       }

// //       // ✅ SAFE ERROR
// //       String errorMessage = "Server error (${response.statusCode})";
// //       try {
// //         errorMessage = jsonDecode(response.body)['message'] ?? errorMessage;
// //       } catch (_) {}

// //       Get.snackbar(
// //         "Error",
// //         errorMessage,
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );

// //     } catch (e) {
// //       print("❌ EXCEPTION: $e");
// //       Get.snackbar(
// //         "Error",
// //         "Something went wrong",
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //     }
// //   }



// // }


// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide FormData, MultipartFile;

// class DriverRegisterController extends GetxController {
//   late Dio dio;

//   @override
//   void onInit() {
//     super.onInit();

//     dio = Dio(
//       BaseOptions(
//         baseUrl: "https://api.corezap.framekarts.com/api/v1",
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         headers: {
//           'Authorization':
//               'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjRjMTMwMzA3MDYyYTUwNzg3NjBkMCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3NjgyODAxOTMsImV4cCI6MTc3MDg3MjE5M30.Cp_rhuX5fFWwT51W3OvUf0lgIhnBPY9D5ku7to9rCdg',
//           'Accept': 'application/json',
//         },
//       ),
//     );

//     // 🔍 Logging (like Postman console)
//     dio.interceptors.add(
//       LogInterceptor(
//         request: true,
//         requestBody: true,
//         responseBody: true,
//         error: true,
//       ),
//     );
//   }

//   Future<void> driverRegister({
//     required String vehicleName,
//     required String vehicleNumber,
//     required String vehicleColor,
//     required String vehicleType,
//   required String vehicleModel,
//     required String vehicleCapacity,
//     required String vehicleYear,
//     required String driverId,
//     File? vehicleNumberImage,
//     File? vehicleInsuranceImage,
//     File? registrationCertificateImage,
//   }) async {
//     try {
//       final formData = FormData.fromMap({
//         // ✅ TEXT FIELDS (FORM-DATA)
//         'vehicleName': vehicleName,
//         'vehicleNumber': vehicleNumber,
//         'vehicleColor': vehicleColor,
//         'vehicleType': vehicleType,
//         'vehicleStatus': 'Active',
//         'vehicleModel': vehicleModel,
//         'vehicleCapacity': vehicleCapacity,
//         'vehicleYear': vehicleYear,
//         'driverId': driverId,

//         // ✅ FILES
//         if (vehicleNumberImage != null)
//           'vehicleNumberImage': await MultipartFile.fromFile(
//             vehicleNumberImage.path,
//             filename: 'vehicle_number.jpg',
//             contentType: DioMediaType('image', 'jpeg'),
//           ),

//         if (vehicleInsuranceImage != null)
//           'vehicleInsuranceImage': await MultipartFile.fromFile(
//             vehicleInsuranceImage.path,
//             filename: 'insurance.jpg',
//             contentType: DioMediaType('image', 'jpeg'),
//           ),

//         if (registrationCertificateImage != null)
//           'registrationCertificateImage': await MultipartFile.fromFile(
//             registrationCertificateImage.path,
//             filename: 'rc.jpg',
//             contentType: DioMediaType('image', 'jpeg'),
//           ),
//       });

//       print("🚀 Sending Dio form-data request");

//       final response = await dio.post(
//         "/createVehicle",
//         data: formData,
//         options: Options(
//           contentType: 'multipart/form-data',
//         ),
//       );

//       print("📌 STATUS: ${response.statusCode}");
//       print("📦 RESPONSE: ${response.data}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Get.snackbar(
//           "Success",
//           "Vehicle created successfully",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           "Error",
//           response.data['message'] ?? "Something went wrong",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       print("❌ DIO ERROR: ${e.response?.data}");

//       String message = "Server error";

//       if (e.response?.data is Map) {
//         message = e.response?.data['message'] ?? message;
//       }

//       Get.snackbar(
//         "Error",
//         message,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("❌ EXCEPTION: $e");

//       Get.snackbar(
//         "Error",
//         "Something went wrong",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }


import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

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

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
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
        Get.snackbar(
          "Success",
          response.data['message'] ?? "Vehicle created",
          backgroundColor: Colors.green,
          colorText: Colors.white, snackPosition: SnackPosition.TOP
        );
      }
    } on DioException catch (e) {
      final message =
          e.response?.data is Map ? e.response?.data['message'] : "Server error";

      Get.snackbar(
        "Error",
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white, snackPosition: SnackPosition.TOP
      );
    }
  }
}
