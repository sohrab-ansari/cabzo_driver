
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

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
        AppLogger.d('⚠️ Error clearing button state for $buttonId: $e');
      }
    });
  }

  static void clearAllStates() {
    // Clear all states safely using microtask
    Future.microtask(() {
      try {
        _loadingStates.clear();
      } catch (e) {
        AppLogger.d('⚠️ Error clearing all button states: $e');
      }
    });
  }
}