

import 'package:nzcu_driver/services/apiservices/auth_api_service.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/auth_modals/get_all_vehicle_categories_response.dart';
import 'package:nzcu_driver/modals/home_modals/order_complete_cash_response.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleTypesController extends GetxController {
  // Rx variables for state management
  Rx<GetAllVehicleCategoriesResponse?> cashResponse =
      Rx<GetAllVehicleCategoriesResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Pagination state variables
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;
  RxBool hasMorePages = true.obs;
  RxBool isLoadingMore = false.obs;
  RxList<Datum> allVehicleTypes = <Datum>[].obs;

  // Default pagination limit
  final int defaultLimit = 10;

  @override
  void onInit() {
    super.onInit();
    // Clear any existing errors when controller is initialized
    clearError();
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // Reset all state
  void resetState() {
    cashResponse.value = null;
    isLoading.value = false;
    errorMessage.value = '';
    currentPage.value = 1;
    totalPages.value = 1;
    totalItems.value = 0;
    hasMorePages.value = true;
    isLoadingMore.value = false;
    allVehicleTypes.clear();
  }

  // Fetch vehicle types with pagination support
  Future<void> vehicalmethod({
    int? limit,
    int? page,
    bool isLoadMore = false,
  }) async {
    // Use default values if not provided
    final int fetchLimit = limit ?? defaultLimit;
    final int fetchPage = page ?? (isLoadMore ? currentPage.value + 1 : 1);

    // Prevent duplicate loading
    if (isLoadMore && isLoadingMore.value) return;
    if (!isLoadMore && isLoading.value) return;

    // Don't load more if no more pages available
    if (isLoadMore && !hasMorePages.value) return;

    // Set appropriate loading state
    if (isLoadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      errorMessage.value = '';
      // Reset list when doing fresh fetch
      allVehicleTypes.clear();
      currentPage.value = 1;
    }

    try {
      // Call API
      final GetAllVehicleCategoriesResponse response =
          await AuthApiService.get_vehical_data(
            limit: fetchLimit,
            page: fetchPage,
          );

      // Update response
      cashResponse.value = response;

      if (response.success == true) {
        print("✅ Vehicle data fetched successfully - Page: $fetchPage");

        // Update pagination info from response
        if (response.pagination != null) {
          currentPage.value = response.pagination!.page ?? fetchPage;
          totalPages.value = response.pagination!.pages ?? 1;
          totalItems.value = response.pagination!.total ?? 0;
          hasMorePages.value = currentPage.value < totalPages.value;

          print(
            "📊 Pagination - Page: ${currentPage.value}/${totalPages.value}, Total: ${totalItems.value}, HasMore: ${hasMorePages.value}",
          );
        }

        // Add new items to the list
        if (response.data != null && response.data!.isNotEmpty) {
          if (isLoadMore) {
            // Append to existing list for pagination
            allVehicleTypes.addAll(response.data!);
          } else {
            // Replace list for fresh fetch
            allVehicleTypes.assignAll(response.data!);
          }
          print("📦 Total items in list: ${allVehicleTypes.length}");
        }
      } else {
        // Fetch failed
        errorMessage.value =
            response.message ?? 'Vehicle types fetch failed. Please try again.';
        print("❌ Vehicle data failed: ${errorMessage.value}");

        // Show error snackbar only for initial load
        if (!isLoadMore) {
          Get.snackbar(
            'Vehicle Data Failed',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
          );
        }
      }
    } catch (e) {
      // Handle exceptions
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in vehicle types fetch: $e");

      // Show error snackbar only for initial load
      if (!isLoadMore) {
        Get.snackbar(
          'Error',
          'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
        );
      }
    } finally {
      // Always reset loading state
      if (isLoadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  // Load more vehicle types (next page)
  Future<void> loadMoreVehicleTypes() async {
    if (hasMorePages.value && !isLoadingMore.value) {
      await vehicalmethod(isLoadMore: true);
    }
  }

  // Reset pagination and reload from scratch
  Future<void> resetPagination() async {
    currentPage.value = 1;
    totalPages.value = 1;
    totalItems.value = 0;
    hasMorePages.value = true;
    allVehicleTypes.clear();
    cashResponse.value = null;
    await vehicalmethod();
  }

  // Navigate to home screen
  void navigateToHome() {
    Get.offAll(
      () => BottomnavmainScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 300),
    );
  }
}