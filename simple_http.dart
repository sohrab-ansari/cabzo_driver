import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var isLoading = false.obs;
  var responseMsg = ''.obs;

  Future<void> registerLogin(String phone) async {
    isLoading.value = true;

    final url = Uri.parse(
      "https://api.corezap.framekarts.com/api/v1/driver/registerLogin",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone": phone,
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        responseMsg.value = data['message'] ?? "Success";
        Get.snackbar("Success", responseMsg.value);
      } else {
        responseMsg.value = data['message'] ?? "Something went wrong";
        Get.snackbar("Error", responseMsg.value);
      }
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar("Error", "Server error");
    } finally {
      isLoading.value = false;
    }
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (phoneController.text.length == 10) {
                              controller.registerLogin(
                                phoneController.text,
                              );
                            } else {
                              Get.snackbar(
                                "Error",
                                "Enter valid phone number",
                              );
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Login"),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
