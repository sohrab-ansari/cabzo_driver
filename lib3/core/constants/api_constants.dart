/// API Constants for the Corezap Driver App
class ApiConstants {
  /// Google Maps API Key
  /// Replace this with your actual Google Maps API key
  /// Get it from: https://console.cloud.google.com/
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  /// Google Directions API endpoint
  static const String googleDirectionsUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  /// Corezap backend API base URL
  static const String baseUrl = 'https://corezap.smarttechbros.com/api/v1';

  /// Order endpoints
  static const String orderUpdateEndpoint = '/order/update';
  static const String orderDeclineEndpoint = '/order/decline';
  static const String orderAcceptEndpoint = '/order/accept';
  static const String verifyOtpEndpoint = '/order/verifyOtp';
}
