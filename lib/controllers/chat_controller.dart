// import 'dart:convert';
// import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
// import 'package:corezap_driver/services/socket_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatMessage {
//   final String id;
//   final String text;
//   final String senderId;
//   final String senderRole;
//   final String receiverId;
//   final String receiverRole;
//   final String timestamp;
//   final bool isRead;
//   final bool isSender;
//   final String? senderName;
//   final String? chatId;
//   final String messageType;

//   ChatMessage({
//     required this.id,
//     required this.text,
//     required this.senderId,
//     required this.senderRole,
//     required this.receiverId,
//     required this.receiverRole,
//     required this.timestamp,
//     required this.isRead,
//     required this.isSender,
//     this.senderName,
//     this.chatId,
//     this.messageType = 'text',
//   });
// }

// class ChatController extends GetxController {
//   // Observables
//   final RxList<ChatMessage> messages = <ChatMessage>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isLoadingHistory = false.obs;
//   final RxBool isConnected = false.obs;
//   final RxBool isSending = false.obs;

//   // Variables
//   String? chatId;
//   String? driverId;
//   String? driverName;
//   SocketManager? socketManager;
//   final ChartidController chartidController = Get.find<ChartidController>();
  
//   final String baseUrl = "https://api.corezap.framekarts.com";
//   late TextEditingController messageController;
//   late ScrollController scrollController;
//   late FocusNode focusNode;

//   final Set<String> _sentMessageIds = {};

//   @override
//   void onInit() {
//     super.onInit();
//     messageController = TextEditingController();
//     scrollController = ScrollController();
//     focusNode = FocusNode();
    
//     focusNode.addListener(() {
//       if (focusNode.hasFocus) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           scrollToBottom();
//         });
//       }
//     });
    
//     print('💬 ChatController initialized');
//   }

//   @override
//   void onClose() {
//     print('💬 ChatController disposed');
//     messageController.dispose();
//     scrollController.dispose();
//     focusNode.dispose();

//     if (socketManager != null) {
//       socketManager = null;
//     }

//     super.onClose();
//   }

//   Future<void> loadDriverInfo() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       driverId = prefs.getString("driver_userid");

//       final storedDriverData = prefs.getString('driverData');
//       if (storedDriverData != null) {
//         final driverData = Map<String, dynamic>.from(
//           json.decode(storedDriverData),
//         );
//         driverName =
//             driverData['name'] ?? driverData['driverName'] ?? 'Driver';
//       }

//       print('👤 Driver info loaded: $driverName (ID: $driverId)');
//     } catch (e) {
//       print('❌ Error loading driver info: $e');
//     }
//   }

//   Future<void> initializeChat(Map<String, dynamic>? rideData) async {
//     if (rideData == null) return;

//     isLoading.value = true;

//     try {
//       print('💬 Initializing chat...');

//       // Get the chat ID from controller
//       await _getchartidmethod(rideData);

//       // Wait a moment for the response to update
//       await Future.delayed(const Duration(milliseconds: 500));

//       // Get chat ID from controller response
//       final chatIdFromResponse = chartidController.chartresposne.value?.data?.id;
//       if (chatIdFromResponse != null) {
//         chatId = chatIdFromResponse;
//         print("✅ Chat ID obtained: $chatId");

//         // Get chat history from API
//         await _fetchChatHistory();

//         // Get the socket manager instance
//         try {
//           socketManager = Get.find<SocketManager>();
//           print("✅ SocketManager found in GetX");
//         } catch (e) {
//           print("⚠️ SocketManager not found, creating new instance");
//           socketManager = SocketManager();
//           Get.put(socketManager!, permanent: true);
//         }

//         // Set up socket listeners
//         _setupSocketListeners();

//         // Join the chat room
//         _joinChatRoom(rideData);
//       } else {
//         print("⚠️ No chat ID available");
//         Get.snackbar(
//           'Chat Error',
//           'Chat initialization failed. Please try again.',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print("❌ Error initializing chat: $e");
//       Get.snackbar(
//         'Error',
//         'Error: ${e.toString()}',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> _getchartidmethod(Map<String, dynamic> rideData) async {
//     try {
//       final orderId = rideData['orderId']?.toString();
//       if (orderId != null) {
//         print('💬 Getting chart ID for order: $orderId');
//         await chartidController.getchartidmethod(orderid: orderId);
//       } else {
//         throw Exception('No order ID in ride data');
//       }
//     } catch (e) {
//       print('❌ Error in _getchartidmethod: $e');
//       rethrow;
//     }
//   }

//   Future<void> _fetchChatHistory() async {
//     if (chatId == null) {
//       print('❌ No chat ID available for fetching history');
//       return;
//     }

//     if (isLoadingHistory.value) return;

//     isLoadingHistory.value = true;

//     try {
//       print('📡 Fetching chat history for chatId: $chatId');

//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString("auth_token");

//       if (token == null) {
//         throw Exception('No authentication token found');
//       }

//       final url = '$baseUrl/api/v1/chat/messages/$chatId';
//       print('🌐 API URL: $url');

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           final List<dynamic> apiMessages = responseData['data'] ?? [];

//           // Clear existing messages and sent message IDs
//           messages.clear();
//           _sentMessageIds.clear();

//           // Add messages from API response
//           for (var messageData in apiMessages) {
//             _addMessageFromApi(messageData);
//           }

//           // Sort messages by timestamp
//           messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

//           print('✅ Loaded ${messages.length} messages from API');
//         } else {
//           throw Exception('API returned success: false');
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Error fetching chat history: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to load chat history: ${e.toString()}',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoadingHistory.value = false;
//     }
//   }

//   void _addMessageFromApi(Map<String, dynamic> messageData) {
//     try {
//       final String messageId = messageData['_id']?.toString() ?? '';
//       final String chatIdFromData = messageData['chatId']?.toString() ?? '';
//       final String messageText = messageData['message']?.toString() ?? '';
//       final String messageType =
//           messageData['messageType']?.toString() ?? 'text';
//       final String senderType = messageData['senderType']?.toString() ?? '';
//       final String timestamp =
//           messageData['createdAt']?.toString() ??
//           DateTime.now().toIso8601String();
//       final bool isRead = messageData['isRead'] ?? false;

//       // Extract sender information
//       dynamic senderIdData = messageData['senderId'];
//       String senderId = '';
//       String senderName = '';

//       if (senderIdData is Map<String, dynamic>) {
//         senderId = senderIdData['_id']?.toString() ?? '';
//         senderName =
//             senderIdData['name']?.toString() ??
//             (senderType == 'Driver' ? 'Driver' : 'Rider');
//       } else {
//         senderId = senderIdData?.toString() ?? '';
//         senderName = senderType == 'Driver' ? 'Driver' : 'Rider';
//       }

//       // Determine if the sender is the current driver
//       final bool isRoleDriver = senderType.toLowerCase() == 'driver';
//       final bool isSameDriverId = driverId != null && senderId == driverId;
//       final bool isSameDriverName =
//           senderName.isNotEmpty && driverName != null && senderName == driverName;

//       final bool isSender = isRoleDriver || isSameDriverId || isSameDriverName;

//       // Create ChatMessage object
//       final message = ChatMessage(
//         id: messageId,
//         text: messageText,
//         senderId: senderId,
//         senderRole: senderType.toLowerCase(),
//         receiverId: '',
//         receiverRole: isSender ? 'rider' : 'driver',
//         timestamp: timestamp,
//         isRead: isRead,
//         isSender: isSender,
//         senderName: senderName,
//         chatId: chatIdFromData,
//         messageType: messageType,
//       );

//       // Track the message as sent (from API)
//       _sentMessageIds.add(messageId);

//       // Add to messages list
//       messages.add(message);

//       print('📝 Added message from API: "$messageText" from $senderName');
//     } catch (e) {
//       print('❌ Error adding message from API: $e');
//       print('❌ Message data: $messageData');
//     }
//   }

//   void _setupSocketListeners() {
//     if (socketManager == null) return;

//     // Connection status
//     socketManager!.onConnectionStatusChange = (isConnectedValue) {
//       isConnected.value = isConnectedValue;
//     };

//     // Chat messages
//     socketManager!.onChatMessage = (data) {
//       print("💬 New chat message received via socket: ${data.keys}");
//       _handleIncomingMessage(data);
//     };

//     // Chat join success
//     socketManager!.onChatJoin = (data) {
//       print("✅ Joined chat successfully: $data");
//     };

//     // Chat error
//     socketManager!.onChatError = (data) {
//       print("❌ Chat error: $data");
//       Get.snackbar(
//         'Error',
//         'Chat error: ${data.toString()}',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     };

//     // Message sent confirmation
//     socketManager!.onChatMessageSent = (data) {
//       print("✅ Message sent successfully via socket: $data");
//       isSending.value = false;

//       // Don't fetch history here - we already added the message optimistically
//       // Just update the sent message ID if needed
//     };
//   }

//   void _joinChatRoom(Map<String, dynamic> rideData) {
//     if (socketManager == null) return;

//     final orderId = rideData['orderId']?.toString();
//     if (orderId != null) {
//       print('💬 Joining chat room for order: $orderId');
//       socketManager!.joinChatRoom(orderId, userRole: 'driver');
//     }
//   }

//   void _handleIncomingMessage(Map<String, dynamic> data) {
//     try {
//       print('💬 Processing incoming socket message: ${data.keys}');

//       // Extract the nested message object
//       final Map<String, dynamic>? messageData = data['message'];

//       if (messageData == null) {
//         print('⚠️ No message data found in socket response');
//         // Try direct fields
//         final messageText =
//             data['text']?.toString() ?? data['message']?.toString();
//         if (messageText != null && messageText.isNotEmpty) {
//           _addMessage(
//             text: messageText,
//             senderId: data['senderId']?.toString() ?? 'unknown',
//             senderRole:
//                 data['senderRole']?.toString() ??
//                 data['senderType']?.toString() ??
//                 'rider',
//             timestamp:
//                 data['timestamp']?.toString() ??
//                 DateTime.now().toIso8601String(),
//             messageId: data['_id']?.toString() ?? UniqueKey().toString(),
//           );
//         }
//         return;
//       }

//       print('💬 Extracted message data: ${messageData.keys}');

//       // Extract sender info - handle both object and string formats
//       dynamic senderIdData = messageData['senderId'];
//       String senderId = '';
//       String senderName = '';
//       String senderType = messageData['senderType']?.toString() ?? '';

//       if (senderIdData is Map<String, dynamic>) {
//         senderId = senderIdData['_id']?.toString() ?? '';
//         senderName = senderIdData['name']?.toString() ?? 'Rider';
//       } else {
//         senderId = senderIdData?.toString() ?? '';
//         senderName = senderType == 'Driver' ? 'Driver' : 'Rider';
//       }

//       // Get message text
//       final messageText = messageData['message']?.toString() ?? '';

//       if (messageText.isEmpty) {
//         print('⚠️ Empty message text received');
//         return;
//       }

//       final messageId = messageData['_id']?.toString() ?? '';

//       // Only add if we haven't seen this message ID before
//       if (!_sentMessageIds.contains(messageId)) {
//         _addMessage(
//           text: messageText,
//           senderId: senderId,
//           senderRole: senderType.toLowerCase(),
//           timestamp:
//               messageData['createdAt']?.toString() ??
//               DateTime.now().toIso8601String(),
//           messageId: messageId,
//           senderName: senderName,
//         );
//       }
//     } catch (e) {
//       print("❌ Error handling incoming socket message: $e");
//       print("❌ Full data received: $data");

//       // Fallback: try to extract message text directly
//       try {
//         final String? messageText =
//             data['message']?.toString() ?? data['text']?.toString();
//         if (messageText != null && messageText.isNotEmpty) {
//           _addMessage(
//             text: messageText,
//             senderId: 'unknown',
//             senderRole: 'rider',
//             timestamp: DateTime.now().toIso8601String(),
//             messageId: UniqueKey().toString(),
//           );
//           print('✅ Created fallback message: $messageText');
//         }
//       } catch (fallbackError) {
//         print("❌ Even fallback failed: $fallbackError");
//       }
//     }
//   }

//   void _addMessage({
//     required String text,
//     required String senderId,
//     required String senderRole,
//     required String timestamp,
//     required String messageId,
//     String? senderName,
//     String? chatIdParam,
//     String messageType = 'text',
//   }) {
//     // Create proper boolean conditions
//     final bool isRoleDriver = senderRole.toLowerCase() == 'driver';
//     final bool isSameDriverId = driverId != null && senderId == driverId;
//     final bool isSameDriverName =
//         senderName != null && driverName != null && senderName == driverName;

//     final bool isSender = isRoleDriver || isSameDriverId || isSameDriverName;

//     // Get receiver ID
//     final String receiverId = ''; // Will be updated if needed

//     // Get receiver role
//     final String receiverRole = isSender ? 'rider' : 'driver';

//     // Check if message already exists to prevent duplicates
//     final bool messageExists = messages.any((msg) => msg.id == messageId);
//     if (messageExists) {
//       print('⚠️ Message already exists: $messageId');
//       return;
//     }

//     final message = ChatMessage(
//       id: messageId,
//       text: text,
//       senderId: senderId,
//       senderRole: senderRole,
//       receiverId: receiverId,
//       receiverRole: receiverRole,
//       timestamp: timestamp,
//       isRead: false,
//       isSender: isSender,
//       senderName: senderName,
//       chatId: chatIdParam ?? chatId,
//       messageType: messageType,
//     );

//     print(
//       '✅ Created chat message: "$text" from ${senderName ?? senderRole} (isSender: $isSender)',
//     );

//     messages.add(message);
//     // Sort by timestamp to maintain order
//     messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

//     // Track this message ID to prevent duplicates
//     _sentMessageIds.add(messageId);

//     scrollToBottom();
//   }

//   void scrollToBottom() {
//     if (scrollController.hasClients) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (scrollController.hasClients) {
//           scrollController.animateTo(
//             scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     }
//   }

//   void sendMessage(
//     Map<String, dynamic>? rideData,
//   ) {
//     if (isSending.value) {
//       print('⚠️ Message is already being sent, please wait...');
//       return;
//     }

//     final text = messageController.text.trim();
//     if (text.isEmpty) return;

//     if (socketManager == null) {
//       print("❌ Socket manager not available");
//       Get.snackbar(
//         'Error',
//         'Not connected to chat server',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     final orderId = rideData?['orderId']?.toString();
//     final riderId = rideData?['riderId']?.toString();

//     if (orderId != null && riderId != null && driverId != null) {
//       // Set sending flag to prevent double sending
//       isSending.value = true;

//       // Generate a unique temporary ID for the message
//       final tempMessageId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

//       // Add message to UI immediately
//       _addMessage(
//         text: text,
//         senderId: driverId!,
//         senderRole: 'driver',
//         timestamp: DateTime.now().toIso8601String(),
//         messageId: tempMessageId,
//         senderName: driverName,
//       );

//       // Send via socket
//       final success = socketManager!.sendChatMessage(
//         orderId,
//         text,
//         receiverId: riderId,
//         chatId: chatId,
//       );

//       isSending.value = false;

//       if (!success) {
//         isSending.value = false;
//         Get.snackbar(
//           'Error',
//           'Failed to send message',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );

//         // Remove the temporary message if sending failed
//         messages.removeWhere((msg) => msg.id == tempMessageId);
//       }

//       messageController.clear();
//       scrollToBottom();

//       // Note: isSending will be reset when onChatMessageSent callback is called
//     } else {
//       print(
//         "❌ Missing required data. OrderId: $orderId, RiderId: $riderId, DriverId: $driverId",
//       );
//       Get.snackbar(
//         'Error',
//         'Cannot send message: Missing ride information',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   String formatTime(String timestamp) {
//     try {
//       final date = DateTime.parse(timestamp).toLocal();
//       return DateFormat('h:mm a').format(date);
//     } catch (e) {
//       return '';
//     }
//   }

//   String formatDate(String timestamp) {
//     try {
//       final date = DateTime.parse(timestamp).toLocal();
//       final now = DateTime.now();
//       final today = DateTime(now.year, now.month, now.day);
//       final yesterday = today.subtract(const Duration(days: 1));
//       final dateOnly = DateTime(date.year, date.month, date.day);

//       if (dateOnly == today) return 'Today';
//       if (dateOnly == yesterday) return 'Yesterday';
//       return DateFormat('d MMM yyyy').format(date);
//     } catch (e) {
//       return '';
//     }
//   }
// }
