import 'dart:io';
import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
import 'package:nzcu_driver/modals/profile_modals/transactions_response.dart';
import 'package:nzcu_driver/modals/profile_modals/wallet_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';

import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class TransactionController extends GetxController {
  Rx<TransactionsResponse?> transactionsres = Rx<TransactionsResponse?>(null);

  // All accumulated transactions across pages
  RxList<TransactionData> allTransactions = <TransactionData>[].obs;

  // Loading states
  RxBool isLoading = false.obs; // Initial load
  RxBool isLoadingMore = false.obs; // Load more (pagination)
  RxString errorMessage = ''.obs;

  // Pagination state
  int _currentPage = 1;
  final int _limit = 10;
  int _totalPages = 1;
  bool get hasMorePages => _currentPage < _totalPages;

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch first page (initial load / refresh)
  Future<void> transactions_method() async {
    AppLogger.d("transactions_data_method called");

    // Reset pagination
    _currentPage = 1;
    _totalPages = 1;
    allTransactions.clear();

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final TransactionsResponse res =
          await ProfileApiServices.get_transactions_data(_limit, _currentPage);

      AppLogger.d("API Response: ${res.success}");
      AppLogger.d("API Response2222: ${res.data}");

      if (res.success == true) {
        AppLogger.d("transactions data fetched successfully");

        transactionsres.value = res;
        allTransactions.addAll(res.data ?? []);

        // Update pagination info
        if (res.pagination != null) {
          _totalPages = res.pagination!.pages ?? 1;
          _currentPage = res.pagination!.page ?? 1;
        }
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch transactions';
        AppLogger.d("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception: $e");
      CustomToast.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next page of transactions
  Future<void> loadMoreTransactions() async {
    if (isLoadingMore.value || !hasMorePages) return;

    AppLogger.d("Loading more transactions - page ${_currentPage + 1}");

    isLoadingMore.value = true;

    try {
      final TransactionsResponse res =
          await ProfileApiServices.get_transactions_data(
            _limit,
            _currentPage + 1,
          );

      if (res.success == true) {
        allTransactions.addAll(res.data ?? []);

        // Update pagination info
        if (res.pagination != null) {
          _totalPages = res.pagination!.pages ?? 1;
          _currentPage = res.pagination!.page ?? _currentPage + 1;
        }

        AppLogger.d(
          "Loaded page $_currentPage / $_totalPages, total items: ${allTransactions.length}",
        );
      } else {
        AppLogger.d("Error loading more: ${res.message}");
      }
    } catch (e) {
      AppLogger.d("Exception loading more: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}
