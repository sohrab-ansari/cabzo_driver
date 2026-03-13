import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nzcu_driver/modals/home_modals/place_prediction.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class PlacesApiService {
  // Same API key as in AndroidManifest.xml
  static const String _apiKey = 'AIzaSyCtM1jo8qzhEn2XZ8SVCoboULcondCjZio';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  /// Get place predictions for autocomplete
  static Future<List<PlacePrediction>> getPlacePredictions(String query) async {
    if (query.isEmpty) return [];

    try {
      final Uri url = Uri.parse(
        '$_baseUrl/autocomplete/json?input=$query&key=$_apiKey&components=country:in',
      );

      AppLogger.d('🔍 Places Autocomplete: $query');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final predictions = (data['predictions'] as List)
              .map((p) => PlacePrediction.fromJson(p))
              .toList();

          AppLogger.d('✅ Found ${predictions.length} places');
          return predictions;
        } else {
          AppLogger.d('⚠️ Places API status: ${data['status']}');
          return [];
        }
      } else {
        AppLogger.d('❌ Places API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      AppLogger.d('❌ Places API exception: $e');
      return [];
    }
  }

  /// Get place details (lat, lng) from placeId
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/details/json?place_id=$placeId&fields=geometry,formatted_address,name&key=$_apiKey',
      );

      AppLogger.d('📍 Getting place details for: $placeId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final details = PlaceDetails.fromJson(data);
          AppLogger.d(
            '✅ Place details: ${details.address} (${details.lat}, ${details.lng})',
          );
          return details;
        } else {
          AppLogger.d('⚠️ Place Details API status: ${data['status']}');
          return null;
        }
      } else {
        AppLogger.d('❌ Place Details API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      AppLogger.d('❌ Place Details API exception: $e');
      return null;
    }
  }

  /// Reverse geocode: Get address from coordinates
  static Future<String?> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_apiKey',
      );

      AppLogger.d('📍 Reverse geocoding: ($lat, $lng)');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final address = data['results'][0]['formatted_address'] as String;
          AppLogger.d('✅ Address: $address');
          return address;
        } else {
          AppLogger.d('⚠️ Geocoding status: ${data['status']}');
          return null;
        }
      } else {
        AppLogger.d('❌ Geocoding error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      AppLogger.d('❌ Geocoding exception: $e');
      return null;
    }
  }
}
