# Google Directions Implementation Guide

## 📍 Overview
This document explains the Google Directions implementation added to your `accepted_screen.dart` file.

## 🔑 Key Features Added

### 1. **Google Polyline Visualization**
- Shows the complete route from pickup to drop location on the Google Map
- Blue polyline (#26E3DD) highlights the driving route
- Auto-animates the camera to fit the entire route

### 2. **Distance & Duration Display**
- Real-time calculation of total distance
- Estimated travel duration
- Displayed in a professional route info card

### 3. **Route Markers**
- Green marker for pickup location
- Red marker for drop location
- Automatic info windows

### 4. **Graceful Fallbacks**
- If Google Directions API fails, shows a direct line between points
- Handles missing coordinates gracefully

## 🚀 Setup Instructions

### Step 1: Get Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable these APIs:
   - Google Maps Platform → Maps → Maps SDK for Android
   - Google Maps Platform → Maps → Maps SDK for iOS
   - Google Directions API
4. Create an API key (Credentials → Create Credentials → API Key)
5. Restrict your key to Android/iOS apps for security

### Step 2: Update API Key in Code
Replace the placeholder in your `accepted_screen.dart`:

```dart
final String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
// Change to:
final String googleMapsApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

Or use the constants file we created:
```dart
// lib/core/constants/api_constants.dart
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
```

### Step 3: Android Configuration
Edit `android/app/build.gradle` and ensure you have the Google Play Services dependency:

```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-maps:18.2.0'
}
```

### Step 4: iOS Configuration
Edit `ios/Runner/GeneratedPluginRegistrant.m` - it should be auto-generated.

## 📊 Data Flow

```
widget.rideData
    ↓
_initializeLocationData() [initState]
    ↓
Extract pickup & drop coordinates
    ↓
_getDirections() [Google Directions API]
    ↓
_decodePolyline() [PolylinePoints]
    ↓
Update Map with Polyline & Markers
    ↓
_animateCameraToRoute()
```

## 🔄 Key Methods

### `_initializeLocationData()`
Extracts location data from `widget.rideData` and initializes coordinates.

**Expected Data Structure:**
```dart
{
  "rideData": {
    "startLocation": {
      "address": "Pickup Location Name",
      "coordinates": [longitude, latitude] // GeoJSON format
    },
    "endLocation": {
      "address": "Drop Location Name",
      "coordinates": [longitude, latitude]
    }
  }
}
```

### `_getDirections()`
Fetches directions from Google Directions API and extracts:
- Distance (e.g., "5.2 km")
- Duration (e.g., "12 mins")
- Polyline points for route visualization

### `_decodePolyline(String polyline)`
Decodes Google's encoded polyline format into actual LatLng coordinates using `flutter_polyline_points` package.

### `_animateCameraToRoute()`
Smoothly animates the camera to show the entire route with padding.

## 🛠️ Customization

### Change Polyline Color
Edit `_decodePolyline()`:
```dart
Polyline(
  polylineId: const PolylineId('route'),
  color: Colors.blue, // Change this
  width: 5,
  points: polylineCoordinates,
)
```

### Adjust Camera Animation Speed
Edit `_animateCameraToRoute()`:
```dart
Future.delayed(const Duration(milliseconds: 500), () {
  mapController.animateCamera(
    CameraUpdate.newLatLngBounds(bounds, 100), // 100 = padding
  );
});
```

### Customize Route Info Card
Edit `_buildRouteInfo()` for styling changes.

## 🐛 Troubleshooting

### Issue: Map shows but no polyline appears
**Solution:** Ensure your Google Maps API key has Directions API enabled.

### Issue: "rideData is null"
**Solution:** Check that `widget.rideData` is being passed correctly from `LiveRide` screen.

### Issue: Coordinates are not extracting
**Solution:** Print `widget.rideData` to verify the coordinate format:
```dart
print('Full ride data: ${widget.rideData}');
print('Start location: ${widget.rideData?['startLocation']}');
```

### Issue: API quota exceeded
**Solution:** Your Google Maps API has usage limits. Check [Google Cloud Console](https://console.cloud.google.com/) for limits and upgrade if needed.

## 📦 Dependencies Used

- `google_maps_flutter: ^2.13.1` - Map display
- `flutter_polyline_points: ^3.1.0` - Polyline decoding
- `http: ^1.3.0` - API calls
- `get: ^4.7.2` - State management

All already in your `pubspec.yaml` ✅

## 🎨 UI Components Added

1. **Route Info Card** - Shows distance and duration
2. **Loading Indicator** - While fetching directions
3. **Polyline on Map** - Blue line showing the route
4. **Markers** - Green (pickup) and Red (drop)

## 🔐 Security Notes

⚠️ **Important:** Never commit your Google Maps API key to public repositories!

### Better Practice:
1. Store API key in `.env` file:
   ```
   GOOGLE_MAPS_API_KEY=your_key_here
   ```

2. Load from environment in code:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';
   
   final String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
   ```

3. Add `.env` to `.gitignore`

## 📈 Future Enhancements

- [ ] Real-time driver location updates on polyline
- [ ] Alternate routes display
- [ ] Traffic-aware route selection
- [ ] Route optimization with multiple stops
- [ ] ETA countdown timer
- [ ] Voice turn-by-turn navigation

## 🆘 Need Help?

- Google Maps Documentation: https://developers.google.com/maps/documentation
- Flutter Google Maps Plugin: https://pub.dev/packages/google_maps_flutter
- Polyline Points: https://pub.dev/packages/flutter_polyline_points

---
**Last Updated:** January 23, 2026
