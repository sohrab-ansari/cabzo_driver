import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget vehicleCard({
  required String image,
  required String title,
  required String desc,
}) {
  return Card(
    color: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              image,
              height: Get.height * 0.4,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    ),
  );
}
