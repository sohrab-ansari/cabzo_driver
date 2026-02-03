# Flutter Push Notifications Setup Guide

This guide covers the implementation of Firebase Cloud Messaging (FCM) and push notifications in your Flutter app, similar to your React Native implementation.

## 📁 Files Created

1. **`lib/services/notification_service.dart`** - Main notification service class
2. **`lib/services/storage/async_storage.dart`** - Persistent storage helper
3. **Updated `lib/main.dart`** - Firebase and notification initialization

## ✅ What's Implemented

### NotificationService Features
- ✅ FCM token management
- ✅ Device ID storage and retrieval
- ✅ Permission handling (Android 13+)
- ✅ Foreground notification display
- ✅ Background message handling
- ✅ Notification opened from background
- ✅ Initial notification from killed state
- ✅ Data-only message support
- ✅ Local notification display with big text style
- ✅ iOS and Android support

### AsyncStorage Features
- ✅ Initialize SharedPreferences
- ✅ Set/Get items
- ✅ Remove items
- ✅ Clear all data
- ✅ Get all keys

## 🔧 Configuration Required

### 1. Android Configuration

#### Add notification permission to `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

#### Update `android/app/build.gradle.kts`
Ensure `compileSdk` is at least 34 and `targetSdk` is at least 34 for Android 14+ support.

### 2. iOS Configuration

#### Update `ios/Runner/Info.plist`
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<true/>
```

#### Update `ios/Podfile`
Uncomment these lines in the Podfile:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCATION=1',
      ]
    end
  end
end
```

### 3. Dependencies (Already in pubspec.yaml)
- ✅ `firebase_core: ^4.4.0`
- ✅ `firebase_messaging: ^16.1.1`
- ✅ `flutter_local_notifications: ^20.0.0`
- ✅ `shared_preferences: ^2.5.4`
- ✅ `device_info_plus: ^12.3.0`

## 📝 How to Use

### Basic Setup in Your Widget/Page

```dart
import 'package:nzcu_driver/services/notification_service.dart';
import 'package:nzcu_driver/services/storage/async_storage.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  void _setupNotifications() {
    // Set callback for data-only messages
    NotificationService().onDataMessage = (data) {
      debugPrint('📩 Data message received: ${data['title']} - ${data['body']}');
      // Update UI based on data
      // Navigate to specific screen, etc.
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
```

### Get FCM Token and Device ID

```dart
final tokenInfo = await NotificationService().getFcmToken();
final token = tokenInfo['token'];
final deviceId = tokenInfo['deviceId'];

print('FCM Token: $token');
print('Device ID: $deviceId');
```

### Store Custom Data

```dart
// Store FCM token
await AsyncStorage.setItem('fcmToken', token);

// Retrieve FCM token
final storedToken = await AsyncStorage.getItem('fcmToken');

// Remove item
await AsyncStorage.removeItem('fcmToken');

// Clear all
await AsyncStorage.clear();
```

## 🔄 Notification Flow

### Foreground Message
1. App is open
2. `setupForegroundHandler()` receives message
3. `showNotification()` displays local notification
4. If data-only, `onDataMessage` callback is triggered

### Background Message
1. App is in background
2. `_backgroundMessageHandler()` processes message
3. Notification is displayed automatically

### Message from Killed State
1. User taps notification while app is closed
2. `getInitialNotification()` retrieves it
3. `setupNotificationOpenedHandler()` handles the tap

## 📊 Device Info Stored

```dart
{
  'fcmToken': '...',        // Firebase Cloud Messaging token
  'deviceId': '...',        // Unique device identifier
}
```

## 🎯 Notification Types

### Standard Notifications
```dart
{
  "notification": {
    "title": "Hello",
    "body": "This is a test"
  }
}
```

### Data-Only Messages
```dart
{
  "data": {
    "type": "corezap",
    "title": "Hello",
    "body": "Custom message",
    "suppressPush": "1"
  }
}
```

## 🐛 Debugging

All functions include debug prints with emojis for easy monitoring:
- ✅ Success
- ❌ Error
- 📩 Message received
- 🔥 Firebase token
- 📱 Device info
- 🔔 Notifications
- 📲 Notification opened
- 🖐️ Tapped
- ⚠️ Warnings

Enable verbose logging in main.dart to see all notifications:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable detailed logging
  debugPrintBeginFrame = true;
  
  // ... rest of initialization
}
```

## 🚀 Next Steps

1. Uncomment the Firebase initialization in `main.dart` (already done)
2. Update Android/iOS configuration as specified
3. Run `flutter pub get` to ensure all dependencies are installed
4. Test with Firebase Cloud Messaging console
5. Implement custom notification handling in your UI

## 📞 Testing

### Using Firebase Console
1. Go to Firebase Console → Cloud Messaging
2. Send test message to your device using FCM token
3. Check console logs and UI for notification

### Common Issues

**Notifications not showing in foreground:**
- Ensure `showNotification()` is called
- Check notification channel creation

**Background messages not processing:**
- Ensure `setupBackgroundHandler()` is registered in `main()`
- Check if app has notification permissions

**Device ID not saved:**
- Verify AsyncStorage is initialized before use
- Check if device has permission to access device info
