


import 'package:corezap_driver/modals/review_rating_response.dart';
import 'package:corezap_driver/apiervices/services/profile_api_services.dart';

// import 'package:corezap_driver/apiServices/services/profile_api_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReviewAndRatingController extends GetxController {
  Rx<ReviewRatingResponse?> reviewRatingResponse = Rx<ReviewRatingResponse?>(null);
  
 
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // You can add any initialization logic here
  }

  Future<void> ratings_method() async {
    print("Fetching reviews...");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final ReviewRatingResponse res =
          await ProfileApiServices.get_review_rating_data();

      print("API Response Success: ${res.success}");
      print("API Response Data Count: ${res.data?.length ?? 0}");

      if (res.success == true) {
        print("Reviews fetched successfully");
        
        // Update the response
        reviewRatingResponse.value = res;
        
        // Show success message only if there are new reviews
        if (res.data != null && res.data!.isNotEmpty) {
          Fluttertoast.showToast(
            msg: "${res.data!.length} reviews loaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch reviews';
        print("Error: ${errorMessage.value}");
        
        // Only show snackbar if there's no existing data
        if (reviewRatingResponse.value == null) {
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
      print("Exception: $e");
      
      // Only show snackbar if there's no existing data
      if (reviewRatingResponse.value == null) {
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Helper method to get total reviews count
  int get totalReviews => reviewRatingResponse.value?.data?.length ?? 0;

  // Helper method to get average rating
  double get averageRating {
    final reviews = reviewRatingResponse.value?.data;
    if (reviews == null || reviews.isEmpty) return 0.0;
    
    double total = 0;
    for (var review in reviews) {
      total += (review.rating ?? 0).toDouble();
    }
    return total / reviews.length;
  }
}