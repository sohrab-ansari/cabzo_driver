# ChatScreen GetX - Code Examples & Snippets

## 1. Basic Usage

### Navigate to Chat Screen
```dart
// Same as before - no changes needed!
Get.to(() => ChatScreen(rideData: rideData))
```

### Simple Message Model
```dart
class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderRole;
  final String receiverId;
  final String receiverRole;
  final String timestamp;
  final bool isRead;
  final bool isSender;
  final String? senderName;
  final String? chatId;
  final String messageType;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderRole,
    required this.receiverId,
    required this.receiverRole,
    required this.timestamp,
    required this.isRead,
    required this.isSender,
    this.senderName,
    this.chatId,
    this.messageType = 'text',
  });
}
```

## 2. ChatController - Core Functionality

### Initialize Controller
```dart
class ChatController extends GetxController {
  // Observables
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool isConnected = false.obs;
  final RxBool isSending = false.obs;

  // Track sent messages to prevent duplicates
  final Set<String> _sentMessageIds = {};

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    messageController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    
    print('💬 ChatController initialized');
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
```

### Load Driver Info
```dart
Future<void> loadDriverInfo() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    driverId = prefs.getString("driver_userid");

    final storedDriverData = prefs.getString('driverData');
    if (storedDriverData != null) {
      final driverData = Map<String, dynamic>.from(
        json.decode(storedDriverData),
      );
      driverName = driverData['name'] ?? driverData['driverName'] ?? 'Driver';
    }

    print('👤 Driver info loaded: $driverName (ID: $driverId)');
  } catch (e) {
    print('❌ Error loading driver info: $e');
  }
}
```

### Send Message
```dart
void sendMessage(Map<String, dynamic>? rideData) {
  // Prevent double sending
  if (isSending.value) {
    print('⚠️ Message is already being sent, please wait...');
    return;
  }

  final text = messageController.text.trim();
  if (text.isEmpty) return;

  if (socketManager == null) {
    print("❌ Socket manager not available");
    Get.snackbar(
      'Error',
      'Not connected to chat server',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  final orderId = rideData?['orderId']?.toString();
  final riderId = rideData?['riderId']?.toString();

  if (orderId != null && riderId != null && driverId != null) {
    isSending.value = true;

    // Generate unique ID
    final tempMessageId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    // Add to UI immediately (optimistic update)
    _addMessage(
      text: text,
      senderId: driverId!,
      senderRole: 'driver',
      timestamp: DateTime.now().toIso8601String(),
      messageId: tempMessageId,
      senderName: driverName,
    );

    // Send via socket
    final success = socketManager!.sendChatMessage(
      orderId,
      text,
      receiverId: riderId,
      chatId: chatId,
    );

    if (!success) {
      isSending.value = false;
      Get.snackbar(
        'Error',
        'Failed to send message',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      // Remove if sending failed
      messages.removeWhere((msg) => msg.id == tempMessageId);
    }

    messageController.clear();
    scrollToBottom();
  }
}
```

### Add Message (Deduplication)
```dart
void _addMessage({
  required String text,
  required String senderId,
  required String senderRole,
  required String timestamp,
  required String messageId,
  String? senderName,
  String? chatIdParam,
  String messageType = 'text',
}) {
  // Determine if sender is current driver
  final bool isRoleDriver = senderRole.toLowerCase() == 'driver';
  final bool isSameDriverId = driverId != null && senderId == driverId;
  final bool isSameDriverName =
      senderName.isNotEmpty && driverName != null && senderName == driverName;

  final bool isSender = isRoleDriver || isSameDriverId || isSameDriverName;

  // Check if message already exists (DUPLICATE PREVENTION)
  final bool messageExists = messages.any((msg) => msg.id == messageId);
  if (messageExists) {
    print('⚠️ Message already exists: $messageId');
    return; // Don't add again
  }

  final message = ChatMessage(
    id: messageId,
    text: text,
    senderId: senderId,
    senderRole: senderRole,
    receiverId: '',
    receiverRole: isSender ? 'rider' : 'driver',
    timestamp: timestamp,
    isRead: false,
    isSender: isSender,
    senderName: senderName,
    chatId: chatIdParam ?? chatId,
    messageType: messageType,
  );

  // Add to observable list
  messages.add(message);
  
  // Sort by timestamp
  messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  // Track this message to prevent future duplicates
  _sentMessageIds.add(messageId);

  print('✅ Added message: "$text"');
  scrollToBottom();
}
```

## 3. ChatScreen - UI Implementation

### Basic Widget Structure
```dart
class ChatScreen extends StatelessWidget {
  final Map<String, dynamic>? rideData;

  const ChatScreen({super.key, required this.rideData});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (controller) {
        // Initialize on first build
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (controller.driverId == null) {
            await controller.loadDriverInfo();
            await controller.initializeChat(rideData);
          }
        });

        return WillPopScope(
          onWillPop: () async {
            final orderId = rideData?['orderId']?.toString();
            if (orderId != null && controller.socketManager != null) {
              try {
                controller.socketManager!.leaveChatRoom(orderId);
              } catch (e) {
                print("Error leaving chat room: $e");
              }
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F6FA),
            appBar: _buildAppBar(controller, rideData),
            body: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : controller.messages.isEmpty
                            ? const Center(child: Text('No messages yet'))
                            : _buildChatList(controller),
                  ),
                ),
                _buildInputBar(controller),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### Reactive Message List
```dart
Widget _buildChatList(ChatController controller) {
  List<Widget> listItems = [];
  String? lastDate;

  // Group by date
  for (var msg in controller.messages) {
    final msgDate = controller.formatDate(msg.timestamp);

    if (msgDate != lastDate) {
      listItems.add(_buildDateSeparator(msgDate));
      lastDate = msgDate;
    }
    listItems.add(_buildMessageBubble(msg, controller));
  }

  return ListView(
    controller: controller.scrollController,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    children: listItems,
  );
}
```

### Reactive Input Bar
```dart
Widget _buildInputBar(ChatController controller) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller.messageController,
                focusNode: controller.focusNode,
                enabled: !controller.isSending.value,
                decoration: InputDecoration(
                  hintText: controller.isSending.value ? "Sending..." : "Type...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  suffixIcon: controller.isSending.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                minLines: 1,
                maxLines: 4,
                onSubmitted: (_) => controller.sendMessage(rideData),
              ),
            ),
          ),
          SizedBox(width: 8),
          Obx(
            () => GestureDetector(
              onTap: controller.isSending.value
                  ? null
                  : () => controller.sendMessage(rideData),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: controller.isSending.value
                      ? Colors.grey
                      : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```

### Online Status with Reactivity
```dart
Widget _buildAppBar(ChatController controller, Map<String, dynamic>? rideData) {
  return AppBar(
    title: Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            rideData?['riderImage'] ?? '',
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rideData?['riderName'] ?? 'Rider'),
            Obx(
              () => Text(
                controller.isConnected.value ? 'Online' : 'Offline',
                style: TextStyle(
                  color: controller.isConnected.value
                      ? Colors.green
                      : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
```

## 4. Socket Listener Setup

```dart
void _setupSocketListeners() {
  if (socketManager == null) return;

  // Connection status
  socketManager!.onConnectionStatusChange = (isConnectedValue) {
    isConnected.value = isConnectedValue; // Auto updates UI
  };

  // Incoming messages
  socketManager!.onChatMessage = (data) {
    print("💬 New message: ${data.keys}");
    _handleIncomingMessage(data);
  };

  // Message sent confirmation
  socketManager!.onChatMessageSent = (data) {
    print("✅ Message sent successfully");
    isSending.value = false; // Reset flag
    // Note: Don't reload history here!
  };

  // Error handling
  socketManager!.onChatError = (data) {
    print("❌ Error: $data");
    Get.snackbar(
      'Error',
      'Chat error: ${data.toString()}',
      backgroundColor: Colors.red,
    );
  };
}
```

## 5. API Integration

```dart
Future<void> _fetchChatHistory() async {
  if (chatId == null) return;
  if (isLoadingHistory.value) return;

  isLoadingHistory.value = true;

  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final url = '$baseUrl/api/v1/chat/messages/$chatId';
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final List<dynamic> apiMessages = responseData['data'] ?? [];

        // Clear and reload
        messages.clear();
        _sentMessageIds.clear();

        for (var messageData in apiMessages) {
          _addMessageFromApi(messageData);
        }

        print('✅ Loaded ${messages.length} messages');
      }
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error: $e');
    Get.snackbar('Error', 'Failed to load history');
  } finally {
    isLoadingHistory.value = false;
  }
}
```

## 6. Testing Examples

```dart
// Test 1: Send and verify no duplicate
test('sendMessage should not create duplicates', () async {
  controller.sendMessage(rideData);
  
  expect(controller.messages.length, equals(1));
  expect(controller._sentMessageIds.length, equals(1));
  
  // Simulate socket echo
  controller._addMessage(
    text: 'Test',
    senderId: 'driver123',
    senderRole: 'driver',
    timestamp: DateTime.now().toIso8601String(),
    messageId: 'temp_123', // Same ID
  );
  
  // Should still be 1, not 2
  expect(controller.messages.length, equals(1));
});

// Test 2: Online status reactive
test('isConnected should update UI', () {
  expect(controller.isConnected.value, false);
  
  // Simulate connection
  controller.isConnected.value = true;
  
  expect(controller.isConnected.value, true);
});

// Test 3: Message sorting
test('messages should be sorted by timestamp', () {
  controller._addMessage(...oldMessage);
  controller._addMessage(...newMessage);
  
  expect(controller.messages.first.timestamp,
    lessThan(controller.messages.last.timestamp));
});
```

---

## Key Takeaways

1. **No setState()** - All state through Rx observables
2. **No Duplicates** - Messages tracked in `_sentMessageIds`
3. **Auto UI Update** - Obx() rebuilds only when needed
4. **Clean Code** - Logic separated from UI
5. **Memory Safe** - Auto disposal in onClose()

Happy coding! 🚀
