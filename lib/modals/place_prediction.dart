/// Place prediction model for Google Places Autocomplete
class PlacePrediction {
  final String placeId;
  final String description;
  final String? mainText;
  final String? secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    this.mainText,
    this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting = json['structured_formatting'] ?? {};
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: structuredFormatting['main_text'],
      secondaryText: structuredFormatting['secondary_text'],
    );
  }
}

/// Place details with coordinates
class PlaceDetails {
  final double lat;
  final double lng;
  final String address;
  final String? name;

  PlaceDetails({
    required this.lat,
    required this.lng,
    required this.address,
    this.name,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final result = json['result'] ?? {};
    final geometry = result['geometry'] ?? {};
    final location = geometry['location'] ?? {};

    return PlaceDetails(
      lat: (location['lat'] ?? 0.0).toDouble(),
      lng: (location['lng'] ?? 0.0).toDouble(),
      address: result['formatted_address'] ?? '',
      name: result['name'],
    );
  }
}
