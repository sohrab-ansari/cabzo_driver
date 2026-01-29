

// // utils/button_state_manager.dart
// import 'package:get/get.dart';

// class ButtonStateManager {
//   static final RxMap<String, RxBool> _loadingStates = <String, RxBool>{}.obs;

//   static void setLoading(String buttonId, bool isLoading) {
//     if (!_loadingStates.containsKey(buttonId)) {
//       _loadingStates[buttonId] = false.obs;
//     }
//     _loadingStates[buttonId]!.value = isLoading;
//   }

//   static bool isLoading(String buttonId) {
//     return _loadingStates[buttonId]?.value ?? false;
//   }

//   static RxBool? watchLoading(String buttonId) {
//     if (!_loadingStates.containsKey(buttonId)) {
//       _loadingStates[buttonId] = false.obs;
//     }
//     return _loadingStates[buttonId];
//   }

//   static void clearState(String buttonId) {
//     _loadingStates.remove(buttonId);
//   }

//   static void dispose() {
//     _loadingStates.clear();
//   }
// }

import 'package:get/get.dart';

class ButtonStateManager {
  static final RxMap<String, RxBool> _loadingStates = <String, RxBool>{}.obs;

  static void setLoading(String buttonId, bool isLoading) {
    if (!_loadingStates.containsKey(buttonId)) {
      _loadingStates[buttonId] = false.obs;
    }
    _loadingStates[buttonId]!.value = isLoading;
  }

  static bool isLoading(String buttonId) {
    return _loadingStates[buttonId]?.value ?? false;
  }

  static RxBool? watchLoading(String buttonId) {
    if (!_loadingStates.containsKey(buttonId)) {
      _loadingStates[buttonId] = false.obs;
    }
    return _loadingStates[buttonId];
  }

  static void clearState(String buttonId) {
    // Use Future.microtask to defer the state update
    Future.microtask(() {
      try {
        if (_loadingStates.containsKey(buttonId)) {
          _loadingStates.remove(buttonId);
        }
      } catch (e) {
        // Silently catch any errors during disposal
        print('⚠️ Error clearing button state for $buttonId: $e');
      }
    });
  }

  static void clearAllStates() {
    // Clear all states safely using microtask
    Future.microtask(() {
      try {
        _loadingStates.clear();
      } catch (e) {
        print('⚠️ Error clearing all button states: $e');
      }
    });
  }
}