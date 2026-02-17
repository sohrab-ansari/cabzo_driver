import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nzcu_driver/modals/home_modals/place_prediction.dart';

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

      print('🔍 Places Autocomplete: $query');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final predictions = (data['predictions'] as List)
              .map((p) => PlacePrediction.fromJson(p))
              .toList();

          print('✅ Found ${predictions.length} places');
          return predictions;
        } else {
          print('⚠️ Places API status: ${data['status']}');
          return [];
        }
      } else {
        print('❌ Places API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Places API exception: $e');
      return [];
    }
  }

  /// Get place details (lat, lng) from placeId
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/details/json?place_id=$placeId&fields=geometry,formatted_address,name&key=$_apiKey',
      );

      print('📍 Getting place details for: $placeId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final details = PlaceDetails.fromJson(data);
          print(
            '✅ Place details: ${details.address} (${details.lat}, ${details.lng})',
          );
          return details;
        } else {
          print('⚠️ Place Details API status: ${data['status']}');
          return null;
        }
      } else {
        print('❌ Place Details API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Place Details API exception: $e');
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

      print('📍 Reverse geocoding: ($lat, $lng)');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final address = data['results'][0]['formatted_address'] as String;
          print('✅ Address: $address');
          return address;
        } else {
          print('⚠️ Geocoding status: ${data['status']}');
          return null;
        }
      } else {
        print('❌ Geocoding error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Geocoding exception: $e');
      return null;
    }
  }
}
