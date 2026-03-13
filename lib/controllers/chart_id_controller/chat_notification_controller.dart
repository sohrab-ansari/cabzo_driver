import 'package:get/get.dart';
import 'package:nzcu_driver/services/apiservices/socket_manager.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class ChatNotificationController extends GetxController {
  static ChatNotificationController get instance => Get.find();

  var unreadCount = 0.obs;
  bool isChatScreenActive = false;
  String? activeChatId;

  @override
  void onInit() {
    super.onInit();
    _setupSocketListener();
  }

  void _setupSocketListener() {
    SocketManager().chatMessageStream.listen((data) {
      handleIncomingMessage(data);
    });
  }

  void handleIncomingMessage(Map<String, dynamic> data) {
    if (isChatScreenActive) {
      AppLogger.d("💬 Chat screen is active, not incrementing count.");
      return;
    }

    unreadCount.value++;
    AppLogger.d("💬 Unread chat count: ${unreadCount.value}");

    // Show local notification
    _showLocalNotification(data);
  }

  void _showLocalNotification(Map<String, dynamic> data) {
    try {
      final messageObj = data['message'];
      if (messageObj == null) return;

      final senderName = messageObj['senderId']?['name'] ?? "New Message";
      final messageText = messageObj['message'] ?? "";

      NotificationService.instance.showNotificationDirectly(
        title: "Chat: $senderName",
        body: messageText,
        payload: data,
      );
    } catch (e) {
      AppLogger.d("❌ Error showing chat notification: $e");
    }
  }

  void resetCount() {
    unreadCount.value = 0;
    AppLogger.d("💬 Unread chat count reset.");
  }

  void setChatScreenActive(bool active, {String? chatId}) {
    isChatScreenActive = active;
    activeChatId = chatId;
    if (active) {
      resetCount();
    }
    AppLogger.d("💬 Chat screen active state: $active");
  }
}
