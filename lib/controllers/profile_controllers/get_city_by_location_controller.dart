import 'package:nzcu_driver/modals/home_modals/get_city_by_location_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:nzcu_driver/utilities/widgets/connection_error_popup.dart';

class GetCityByLocationController extends GetxController {
  // Observable response
  Rx<GetCityByLocationResponse?> cityByLocationResponse =
      Rx<GetCityByLocationResponse?>(null);

  // Observable polygons for maps
  RxSet<Polygon> cityPolygons = <Polygon>{}.obs;

  // Loading and error states
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getCityByLocation({
    required String lat,
    required String lng,
  }) async {
    AppLogger.d("getCityByLocation called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final GetCityByLocationResponse res =
          await ProfileApiServices.get_cit_by_loc_method(lat: lat, lng: lng);

      AppLogger.d("API Response Success: ${res.success}");
      AppLogger.d("API Response Message: ${res.message}");

      if (res.success == true) {
        AppLogger.d("City location fetched successfully");

        // Assign the response to the observable
        cityByLocationResponse.value = res;

        // Create polygon
        final coordinates = res.data?.location?.coordinates;
        if (coordinates != null && coordinates.isNotEmpty) {
          final polygon = Polygon(
            polygonId: const PolygonId('city_boundary'),
            points: coordinates,
            strokeColor: Colors.black,
            strokeWidth: 3,
            fillColor: Colors.transparent,
          );
          cityPolygons.assignAll({polygon});
          AppLogger.d("City boundary polygon created and added to observable set.");
        } else {
           cityPolygons.clear();
        }

      } else {
        errorMessage.value = res.message ?? 'Failed to fetch city location';
        AppLogger.d("Error: ${errorMessage.value}");
        cityPolygons.clear();

        _handleErrorWithPopup(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception in getCityByLocation: $e");
      cityPolygons.clear();

      _handleErrorWithPopup(errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  void _handleErrorWithPopup(String errorMsg) {
    final lowerMsg = errorMsg.toLowerCase();
    if (lowerMsg.contains('connection error') ||
        lowerMsg.contains('socketexception') ||
        lowerMsg.contains('connection refused') ||
        lowerMsg.contains('failed host lookup') ||
        lowerMsg.contains('timed out')) {
      if (Get.context != null) {
        ConnectionErrorPopup.show(Get.context!, message: "Unable to connect to the server. Please check your internet connection and try again.");
      } else {
        CustomToast.showError("Unable to connect to the server.");
      }
    } else {
      CustomToast.showError(errorMsg);
    }
  }

  // Method to clear data
  void clearData() {
    cityByLocationResponse.value = null;
    cityPolygons.clear();
    errorMessage.value = '';
  }
}
