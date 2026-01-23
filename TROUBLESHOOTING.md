# Troubleshooting Guide - Google Directions

## 🔴 Common Issues & Solutions

### Issue 1: "YOUR_GOOGLE_MAPS_API_KEY" showing on map

**Problem:** The placeholder API key is still in the code.

**Solution:**
1. Go to Google Cloud Console: https://console.cloud.google.com/
2. Create or select your project
3. Enable "Directions API" and "Maps SDK for Android/iOS"
4. Go to Credentials → Create API Key
5. Copy the key (e.g., `AIzaSyD...`)
6. Open `lib/views/scheduled_pickups/accepted_screen.dart`
7. Find line ~135:
   ```dart
   final String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
   ```
8. Replace with your key:
   ```dart
   final String googleMapsApiKey = 'AIzaSyD1234567890abcdefghijklmnop';
   ```

---

### Issue 2: Routes not showing on map

**Problem:** Map displays but no blue polyline appears.

**Possible Causes:**

#### A) API Key not working
- ✅ Verify API key is correct
- ✅ Check "Directions API" is enabled in Google Cloud Console
- ✅ Check API key restrictions (should allow Maps & Directions)
- ✅ Try key in browser: 
  ```
  https://maps.googleapis.com/maps/api/directions/json?origin=13.1289,77.5708&destination=13.1939,77.5988&key=YOUR_KEY
  ```

#### B) Coordinates not extracting
- ✅ Check `rideData` contains correct structure:
  ```dart
  print('📍 Ride Data: ${widget.rideData}');
  print('📍 Start Location: ${widget.rideData?['startLocation']}');
  print('📍 End Location: ${widget.rideData?['endLocation']}');
  ```
- ✅ Verify coordinates array has [longitude, latitude] format
- ✅ Check coordinates are valid (lat: -90 to 90, lng: -180 to 180)

#### C) API quota exceeded
- ✅ Check Google Cloud Console for usage
- ✅ May need to upgrade billing
- ✅ Temporarily switch to fallback line by commenting out API call

---

### Issue 3: Distance/Duration showing "0 km" or "0 min"

**Problem:** Values aren't updating from API.

**Solution:**
1. Check console logs for: `❌ Directions API Error`
2. Verify API response format (should have "routes" array)
3. Check if coordinates are valid:
   ```dart
   // Valid ranges
   latitude: -90 to 90
   longitude: -180 to 180
   ```
4. Try with well-known locations first (like major cities)

---

### Issue 4: App crashes with "Null Exception"

**Problem:** Error related to null values.

**Solution:**
1. Check `rideData` is being passed to ArrivingClient:
   ```dart
   // In parent widget
   ArrivingClient(
     rideData: yourRideData,  // ← Must not be null
   )
   ```
2. Add null checks in `_initializeLocationData()`:
   ```dart
   if (widget.rideData == null) {
     print('❌ rideData is null');
     return;
   }
   ```
3. Check all nested objects exist before accessing

---

### Issue 5: "LocationInputTextfield widget not found"

**Problem:** Build error about custom widget.

**Solution:**
- ✅ Verify `LocationInputTextfield` exists in your utilities
- ✅ Check import path is correct
- ✅ If widget doesn't exist, replace with standard TextField

---

### Issue 6: Polyline appears but wrong color

**Problem:** Line color isn't cyan as expected.

**Solution:**
Edit `_decodePolyline()` method:
```dart
Polyline(
  polylineId: const PolylineId('route'),
  color: const Color(0xFF26E3DD),  // Change this
  width: 5,
  points: polylineCoordinates,
)
```

Available colors:
```dart
Colors.blue           // Standard blue
Colors.cyan          // Light blue
Colors.green         // Green
Colors.red           // Red
Colors.orange        // Orange
const Color(0xFF26E3DD)  // Custom cyan (current)
```

---

### Issue 7: Camera doesn't auto-fit to route

**Problem:** Map shows but doesn't zoom/pan to show route.

**Solution:**
1. Check `_animateCameraToRoute()` is being called
2. Add delay before camera animation:
   ```dart
   Future.delayed(const Duration(milliseconds: 500), () {
     mapController.animateCamera(...)
   });
   ```
3. Verify `mapController` is initialized:
   ```dart
   GoogleMap(
     onMapCreated: (controller) {
       mapController = controller;  // ← Must be set
     }
   )
   ```

---

### Issue 8: "The coordinates format is [lng, lat] not [lat, lng]"

**Problem:** Confusing coordinate order.

**Reference:**
```dart
// From your API (GeoJSON standard)
"coordinates": [77.5708, 13.1289]  // [LONGITUDE, LATITUDE]

// Convert to LatLng for Google Maps
LatLng(13.1289, 77.5708)  // (LATITUDE, LONGITUDE) - REVERSED!
```

**In your code:**
```dart
if (startLocation['coordinates'] != null &&
    startLocation['coordinates'] is List &&
    startLocation['coordinates'].length >= 2) {
  pickupLocation = LatLng(
    startLocation['coordinates'][1],  // ← latitude (index 1)
    startLocation['coordinates'][0],  // ← longitude (index 0)
  );
}
```

---

### Issue 9: Multiple polylines overlapping

**Problem:** Old routes not clearing, new ones stacking.

**Solution:**
In `_decodePolyline()`:
```dart
setState(() {
  polylines.clear();  // ← Add this to clear old routes
  polylines.add(
    Polyline(...)
  );
});
```

---

### Issue 10: Markers not showing

**Problem:** Pickup/Drop locations not marked on map.

**Solution:**
1. Verify `_buildMarkers()` is called:
   ```dart
   GoogleMap(
     markers: _buildMarkers(),  // ← Must be included
   )
   ```
2. Check coordinates are set:
   ```dart
   print('🟢 Pickup: $pickupLocation');
   print('🔴 Drop: $dropLocation');
   ```
3. Check marker IDs are unique:
   ```dart
   MarkerId('pickup')  // ← Must be different
   MarkerId('drop')    // ← Must be different
   ```

---

## 🔍 Debugging Checklist

Use this checklist to diagnose issues:

- [ ] Google API key is valid and not placeholder
- [ ] Directions API is enabled in Google Cloud Console
- [ ] `rideData` is being passed to widget
- [ ] Coordinates exist in `rideData`
- [ ] Coordinates format is [lng, lat]
- [ ] Coordinates are within valid ranges
- [ ] `GoogleMap.polylines` parameter is set
- [ ] `GoogleMap.markers` parameter is set
- [ ] `mapController` is initialized in `onMapCreated`
- [ ] Network connection is working
- [ ] No console errors are shown
- [ ] API response has "routes" array
- [ ] `_initializeLocationData()` is called in `initState`

---

## 📱 Testing on Device vs Emulator

### Android Emulator
- ✅ Usually works fine
- ✅ Make sure you have Google Play Services installed
- ⚠️ Network may be slow, API calls take longer

### iOS Simulator
- ⚠️ Maps may not load
- ⚠️ Build with real device recommended
- ✅ Use real device for testing

### Physical Device
- ✅ Most reliable
- ✅ Real network performance
- ✅ Test with actual GPS

---

## 🐛 Debug Prints to Add

Add these to help debug:

```dart
void _initializeLocationData() {
  print('🔍 Initializing location data...');
  print('📦 Full rideData: ${widget.rideData}');
  print('📍 Start Location: ${widget.rideData?['startLocation']}');
  print('📍 End Location: ${widget.rideData?['endLocation']}');
  
  // ... rest of code
}

Future<void> _getDirections() async {
  print('🔄 Fetching directions...');
  print('📍 From: $pickupLocation');
  print('📍 To: $dropLocation');
  
  // ... rest of code
  
  print('✅ API Response Success');
  print('📊 Distance: $_distance');
  print('⏱️ Duration: $_duration');
}
```

---

## 🆘 Still Not Working?

Follow this systematic approach:

1. **Verify API Key**
   - [ ] Key exists in code
   - [ ] Key is valid (copy-paste from console)
   - [ ] APIs are enabled

2. **Verify Data Flow**
   - [ ] Print rideData in widget
   - [ ] Print extracted coordinates
   - [ ] Print API response

3. **Verify Map Setup**
   - [ ] GoogleMap widget renders
   - [ ] Map centers on initial position
   - [ ] Markers appear at polylines

4. **Check Network**
   - [ ] Internet connection works
   - [ ] API endpoint is reachable
   - [ ] No firewall blocking Google APIs

5. **Review Logs**
   - [ ] Look for red error messages
   - [ ] Check "Directions API Error" prints
   - [ ] Check null reference errors

---

## 📞 Getting Help

If you're stuck:

1. **Google Maps Documentation**
   https://developers.google.com/maps/documentation/directions

2. **Flutter Google Maps Plugin**
   https://pub.dev/packages/google_maps_flutter

3. **Flutter Polyline Points**
   https://pub.dev/packages/flutter_polyline_points

4. **Stack Overflow**
   Tag: `flutter` + `google-maps`

---

**Need more help? Check these files:**
- `QUICK_START.md` - Quick setup
- `GOOGLE_DIRECTIONS_SETUP.md` - Detailed setup
- `IMPLEMENTATION_SUMMARY.md` - What was changed
- `VISUAL_GUIDE.md` - Visual diagrams

---

**Last Updated:** January 23, 2026
