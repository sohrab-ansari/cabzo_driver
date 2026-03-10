import 'package:nzcu_driver/services/apiservices/auth_api_service.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/auth_modals/get_all_sub_vehicle_categories_response.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleSubtypesController extends GetxController {
  // Rx variables for state management
  Rx<GetAllsubVehicleCategoriesResponse?> cashResponse =
      Rx<GetAllsubVehicleCategoriesResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Pagination state variables
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;
  RxBool hasMorePages = true.obs;
  RxBool isLoadingMore = false.obs;
  RxList<Datum> allVehicleSubTypes = <Datum>[].obs;

  // Typedef for Datum to avoid confusion with other Datum classes
  // Using Datum from get_all_sub_vehicle_categories_response.dart

  // Store current vehicle category ID for pagination
  RxString currentVehicleCategoryId = ''.obs;

  // Default pagination limit
  final int defaultLimit = 10;

  // Fetch vehicle sub-types with pagination support
  Future<void> subvehicalmethod({
    required String vehicalCategoryId,
    int? limit,
    int? page,
    bool isLoadMore = false,
  }) async {
    // Use default values if not provided
    final int fetchLimit = limit ?? defaultLimit;
    final int fetchPage = page ?? (isLoadMore ? currentPage.value + 1 : 1);

    // Check if category changed - if so, reset pagination
    if (vehicalCategoryId != currentVehicleCategoryId.value) {
      allVehicleSubTypes.clear();
      currentPage.value = 1;
      hasMorePages.value = true;
      isLoadMore = false;
    }

    // Update current category ID
    currentVehicleCategoryId.value = vehicalCategoryId;

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
      allVehicleSubTypes.clear();
      currentPage.value = 1;
    }

    try {
      // Call API
      final GetAllsubVehicleCategoriesResponse response =
          await AuthApiService.get_sub_vehical_data(
            vehicalCategoryId: vehicalCategoryId,
            limit: fetchLimit,
            page: fetchPage,
          );

      // Update response
      cashResponse.value = response;

      if (response.success == true) {
        print("✅ Vehicle sub-types fetched successfully - Page: $fetchPage");

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
            allVehicleSubTypes.addAll(response.data!);
          } else {
            // Replace list for fresh fetch
            allVehicleSubTypes.assignAll(response.data!);
          }
          print("📦 Total sub-types in list: ${allVehicleSubTypes.length}");
        }
      } else {
        // Fetch failed
        errorMessage.value =
            response.message ??
            'Vehicle sub-types fetch failed. Please try again.';
        print("❌ Vehicle sub-types failed: ${errorMessage.value}");

        // Show error snackbar only for initial load
        if (!isLoadMore) {
          Get.snackbar(
            'Vehicle Sub-types Failed',
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
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
      print("❌ Exception in vehicle sub-types fetch: $e");

      // Show error snackbar only for initial load
      if (!isLoadMore) {
        Get.snackbar(
          'Error',
          'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP,
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

  void clearError() {
  errorMessage.value = '';
}

  // Load more vehicle sub-types (next page)
  Future<void> loadMoreVehicleSubTypes() async {
    if (hasMorePages.value &&
        !isLoadingMore.value &&
        currentVehicleCategoryId.value.isNotEmpty) {
      await subvehicalmethod(
        vehicalCategoryId: currentVehicleCategoryId.value,
        isLoadMore: true,
      );
    }
  }

  // Reset pagination and reload from scratch for a specific category
  Future<void> resetPagination(String vehicleCategoryId) async {
    currentPage.value = 1;
    totalPages.value = 1;
    totalItems.value = 0;
    hasMorePages.value = true;
    allVehicleSubTypes.clear();
    cashResponse.value = null;
    currentVehicleCategoryId.value = vehicleCategoryId;
    await subvehicalmethod(vehicalCategoryId: vehicleCategoryId);
  }

  // Clear all data (when vehicle type changes)
  void clearData() {
    currentPage.value = 1;
    totalPages.value = 1;
    totalItems.value = 0;
    hasMorePages.value = true;
    allVehicleSubTypes.clear();
    cashResponse.value = null;
    currentVehicleCategoryId.value = '';
    errorMessage.value = '';
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
