import 'dart:async';
import 'dart:convert';

import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
import 'package:corezap_driver/services/socket_manager.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? rideData;

  const ChatScreen({super.key, required this.rideData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChartidController chartidController = Get.find<ChartidController>();
  final FocusNode _focusNode = FocusNode();

  // Store messages locally
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  bool _isConnected = false;
  String? _chatId;
  SocketManager? _socketManager;
  bool _mounted = true;
  String? _driverId;
  String? _driverName;
  bool _isSending = false; // To prevent double sending
  String _baseUrl = "https://api.corezap.framekarts.com"; // Your base URL
  Timer? _sendTimeoutTimer; // Timer for send timeout

  @override
  void initState() {
    super.initState();
    _mounted = true;
    print('💬 ChatScreen initState');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDriverInfo();
      await _initializeChat();
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _mounted) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollToBottom();
        });
      }
    });
  }

  Future<void> _loadDriverInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _driverId = prefs.getString("driver_userid");

      final storedDriverData = prefs.getString('driverData');
      if (storedDriverData != null) {
        final driverData = Map<String, dynamic>.from(
          json.decode(storedDriverData),
        );
        _driverName =
            driverData['name'] ?? driverData['driverName'] ?? 'Driver';
      }

      print('👤 Driver info loaded: $_driverName (ID: $_driverId)');
    } catch (e) {
      print('❌ Error loading driver info: $e');
    }
  }

  @override
  void dispose() {
    print('💬 ChatScreen dispose');
    _mounted = false;

    // Cancel any pending timeout timer
    _sendTimeoutTimer?.cancel();
    _sendTimeoutTimer = null;

    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();

    // Leave chat room when screen is disposed
    if (_socketManager != null) {
      final orderId = widget.rideData?['orderId']?.toString();
      if (orderId != null) {
        try {
          _socketManager!.leaveChatRoom(orderId);
        } catch (e) {
          print("Error leaving chat room: $e");
        }
      }
    }

    super.dispose();
  }

  Future<void> _initializeChat() async {
    if (!_mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print('💬 Initializing chat...');

      // Get the chat ID from controller
      await _getchartidmethod();

      // Wait a moment for the response to update
      await Future.delayed(const Duration(milliseconds: 500));

      // Get chat ID from controller response
      final chatId = chartidController.chartresposne.value?.data?.id;
      if (chatId != null) {
        _chatId = chatId;
        print("✅ Chat ID obtained: $_chatId");

        // Get chat history from API
        await _fetchChatHistory();

        // Get the socket manager instance
        try {
          _socketManager = Get.find<SocketManager>();
          print("✅ SocketManager found in GetX");
        } catch (e) {
          print("⚠️ SocketManager not found, creating new instance");
          _socketManager = SocketManager();
          Get.put(_socketManager!, permanent: true);
        }

        // Set up socket listeners
        _setupSocketListeners();

        // Join the chat room
        _joinChatRoom();
      } else {
        print("⚠️ No chat ID available");
        if (_mounted) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(
              content: Text('Chat initialization failed. Please try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print("❌ Error initializing chat: $e");
      if (_mounted) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getchartidmethod() async {
    try {
      final orderId = widget.rideData?['orderId']?.toString();
      if (orderId != null) {
        print('💬 Getting chart ID for order: $orderId');
        await chartidController.getchartidmethod(orderid: orderId);
      } else {
        throw Exception('No order ID in ride data');
      }
    } catch (e) {
      print('❌ Error in _getchartidmethod: $e');
      rethrow;
    }
  }

  // Method to fetch chat history from API
  Future<void> _fetchChatHistory() async {
    if (_chatId == null) {
      print('❌ No chat ID available for fetching history');
      return;
    }

    if (_isLoadingHistory) return;

    setState(() {
      _isLoadingHistory = true;
    });

    try {
      print('📡 Fetching chat history for chatId: $_chatId');

      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = '$_baseUrl/api/v1/chat/messages/$_chatId';
      print('🌐 API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> messages = responseData['data'] ?? [];

          // Clear existing messages first
          _messages.clear();

          // Add messages from API response
          for (var messageData in messages) {
            _addMessageFromApi(messageData);
          }

          // Sort messages by timestamp
          _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          print('✅ Loaded ${_messages.length} messages from API');

          if (_mounted) {
            setState(() {});
            _scrollToBottom();
          }
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error fetching chat history: $e');
      if (_mounted) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Failed to load chat history: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (_mounted) {
        setState(() {
          _isLoadingHistory = false;
        });
      }
    }
  }

  // Helper method to add message from API response
  void _addMessageFromApi(Map<String, dynamic> messageData) {
    try {
      final String messageId = messageData['_id']?.toString() ?? '';
      final String chatId = messageData['chatId']?.toString() ?? '';
      final String messageText = messageData['message']?.toString() ?? '';
      final String messageType =
          messageData['messageType']?.toString() ?? 'text';
      final String senderType = messageData['senderType']?.toString() ?? '';
      final String senderModel = messageData['senderModel']?.toString() ?? '';
      final String timestamp =
          messageData['createdAt']?.toString() ??
          DateTime.now().toIso8601String();
      final bool isRead = messageData['isRead'] ?? false;

      // Extract sender information
      dynamic senderIdData = messageData['senderId'];
      String senderId = '';
      String senderName = '';

      if (senderIdData is Map<String, dynamic>) {
        senderId = senderIdData['_id']?.toString() ?? '';
        senderName =
            senderIdData['name']?.toString() ??
            (senderType == 'Driver' ? 'Driver' : 'Rider');
      } else {
        senderId = senderIdData?.toString() ?? '';
        senderName = senderType == 'Driver' ? 'Driver' : 'Rider';
      }

      // Determine if the sender is the current driver
      final bool isRoleDriver = senderType.toLowerCase() == 'driver';
      final bool isSameDriverId = _driverId != null && senderId == _driverId;
      final bool isSameDriverName =
          senderName != null &&
          _driverName != null &&
          senderName == _driverName;

      final bool isSender = isRoleDriver || isSameDriverId || isSameDriverName;

      // Create ChatMessage object
      final message = ChatMessage(
        id: messageId,
        text: messageText,
        senderId: senderId,
        senderRole: senderType.toLowerCase(),
        receiverId: '', // Will be updated if needed
        receiverRole: isSender ? 'rider' : 'driver',
        timestamp: timestamp,
        isRead: isRead,
        isSender: isSender,
        senderName: senderName,
        chatId: chatId,
        messageType: messageType,
      );

      // Add to messages list
      if (_mounted) {
        setState(() {
          _messages.add(message);
        });
      }

      print('📝 Added message from API: "$messageText" from $senderName');
    } catch (e) {
      print('❌ Error adding message from API: $e');
      print('❌ Message data: $messageData');
    }
  }

  void _setupSocketListeners() {
    if (_socketManager == null) return;

    // Connection status
    _socketManager!.onConnectionStatusChange = (isConnected) {
      if (_mounted) {
        setState(() {
          _isConnected = isConnected;
          // If connection is restored, reset sending flag
          if (isConnected && _isSending) {
            _isSending = false;
          }
        });
      }
    };

    // Chat messages
    _socketManager!.onChatMessage = (data) {
      print("💬 New chat message received via socket: ${data.keys}");
      _handleIncomingMessage(data);
    };

    // Chat join success
    _socketManager!.onChatJoin = (data) {
      print("✅ Joined chat successfully: $data");
    };

    // Chat error
    _socketManager!.onChatError = (data) {
      print("❌ Chat error: $data");
      if (_mounted) {
        setState(() {
          _isSending = false; // Reset sending flag on error
        });
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Chat error: ${data.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    };

    // Message sent confirmation
    _socketManager!.onChatMessageSent = (data) {
      print("✅ Message sent successfully via socket: $data");

      // Cancel any pending timeout timer
      _sendTimeoutTimer?.cancel();
      _sendTimeoutTimer = null;

      // Reset sending flag when message is confirmed sent
      if (_mounted) {
        setState(() {
          _isSending = false;
        });
      }
    };
  }

  void _joinChatRoom() {
    if (_socketManager == null) return;

    final orderId = widget.rideData?['orderId']?.toString();
    if (orderId != null) {
      print('💬 Joining chat room for order: $orderId');
      _socketManager!.joinChatRoom(orderId, userRole: 'driver');
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    if (!_mounted) return;

    try {
      print('💬 Processing incoming socket message: ${data.keys}');

      // Extract the nested message object
      final Map<String, dynamic>? messageData = data['message'];

      if (messageData == null) {
        print('⚠️ No message data found in socket response');
        // Try direct fields
        final messageText =
            data['text']?.toString() ?? data['message']?.toString();
        if (messageText != null && messageText.isNotEmpty) {
          _addMessage(
            text: messageText,
            senderId: data['senderId']?.toString() ?? 'unknown',
            senderRole:
                data['senderRole']?.toString() ??
                data['senderType']?.toString() ??
                'rider',
            timestamp:
                data['timestamp']?.toString() ??
                DateTime.now().toIso8601String(),
            messageId: data['_id']?.toString() ?? UniqueKey().toString(),
          );
        }
        return;
      }

      print('💬 Extracted message data: ${messageData.keys}');

      // Extract sender info - handle both object and string formats
      dynamic senderIdData = messageData['senderId'];
      String senderId = '';
      String senderName = '';
      String senderType = messageData['senderType']?.toString() ?? '';

      if (senderIdData is Map<String, dynamic>) {
        // senderId is an object with _id and name
        senderId = senderIdData['_id']?.toString() ?? '';
        senderName = senderIdData['name']?.toString() ?? 'Rider';
      } else {
        // senderId is just a string ID
        senderId = senderIdData?.toString() ?? '';
        senderName = senderType == 'Driver' ? 'Driver' : 'Rider';
      }

      // Get message text
      final messageText = messageData['message']?.toString() ?? '';

      if (messageText.isEmpty) {
        print('⚠️ Empty message text received');
        return;
      }

      _addMessage(
        text: messageText,
        senderId: senderId,
        senderRole: senderType.toLowerCase(),
        timestamp:
            messageData['createdAt']?.toString() ??
            DateTime.now().toIso8601String(),
        messageId: messageData['_id']?.toString() ?? UniqueKey().toString(),
        senderName: senderName,
      );
    } catch (e) {
      print("❌ Error handling incoming socket message: $e");
      print("❌ Full data received: $data");

      // Fallback: try to extract message text directly
      try {
        final String? messageText =
            data['message']?.toString() ?? data['text']?.toString();
        if (messageText != null && messageText.isNotEmpty) {
          _addMessage(
            text: messageText,
            senderId: 'unknown',
            senderRole: 'rider',
            timestamp: DateTime.now().toIso8601String(),
            messageId: UniqueKey().toString(),
          );
          print('✅ Created fallback message: $messageText');
        }
      } catch (fallbackError) {
        print("❌ Even fallback failed: $fallbackError");
      }
    }
  }

  void _addMessage({
    required String text,
    required String senderId,
    required String senderRole,
    required String timestamp,
    required String messageId,
    String? senderName,
    String? chatId,
    String messageType = 'text',
  }) {
    // Create proper boolean conditions
    final bool isRoleDriver = senderRole.toLowerCase() == 'driver';
    final bool isSameDriverId = _driverId != null && senderId == _driverId;
    final bool isSameDriverName =
        senderName != null && _driverName != null && senderName == _driverName;

    final bool isSender = isRoleDriver || isSameDriverId || isSameDriverName;

    // Get receiver ID - make sure to handle null values
    final String receiverId;
    if (isSender) {
      receiverId = widget.rideData?['riderId']?.toString() ?? '';
    } else {
      receiverId = _driverId ?? '';
    }

    // Get receiver role
    final String receiverRole = isSender ? 'rider' : 'driver';

    // Check if message already exists to prevent duplicates
    final bool messageExists = _messages.any((msg) => msg.id == messageId);
    if (messageExists) {
      print('⚠️ Message already exists: $messageId');
      return;
    }

    // DEDUPLICATION LOGIC: Check if this is a real message that should replace a temp message
    if (!messageId.startsWith('temp_') && isSender) {
      print('🔍 Attempting deduplication for: "$text"');

      // Find a temp message with the same text
      final int tempIndex = _messages.indexWhere((msg) {
        final bool isTemp = msg.id.startsWith('temp_');
        // Relaxed matching: trim both and ignore case just in case
        final bool isSameText = msg.text.trim() == text.trim();
        final bool isMe = msg.isSender;
        return isTemp && isSameText && isMe;
      });

      if (tempIndex != -1) {
        print(
          '♻️ Replacing temp message ${_messages[tempIndex].id} with real message $messageId',
        );
        if (_mounted) {
          setState(() {
            _messages[tempIndex] = ChatMessage(
              id: messageId,
              text: text,
              senderId: senderId,
              senderRole: senderRole,
              receiverId: receiverId,
              receiverRole: receiverRole,
              timestamp: timestamp,
              isRead: false, // Maintain or update status
              isSender: isSender,
              senderName: senderName,
              chatId: chatId ?? _chatId,
              messageType: messageType,
            );
            // Sort by timestamp to maintain order
            _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          });
        }
        return; // Exit as we've replaced the message
      } else {
        print(
          '⚠️ No matching temp message found for deduplication. Adding as new.',
        );
      }
    }

    final message = ChatMessage(
      id: messageId,
      text: text,
      senderId: senderId,
      senderRole: senderRole,
      receiverId: receiverId,
      receiverRole: receiverRole,
      timestamp: timestamp,
      isRead: false,
      isSender: isSender,
      senderName: senderName,
      chatId: chatId ?? _chatId,
      messageType: messageType,
    );

    print(
      '✅ Created chat message: "$text" from ${senderName ?? senderRole} (isSender: $isSender)',
    );

    if (_mounted) {
      setState(() {
        _messages.add(message);
        // Sort by timestamp to maintain order
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && _mounted) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients && _mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage() {
    if (_isSending) {
      print('⚠️ Message is already being sent, please wait...');
      return;
    }

    final text = _messageController.text.trim();

    print("hellooooo>>  ${text}");
    if (text.isEmpty) return;

    if (_socketManager == null) {
      print("❌ Socket manager not available");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not connected to chat server'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final orderId = widget.rideData?['orderId']?.toString();
    final riderId = widget.rideData?['riderId']?.toString();

    if (orderId != null && riderId != null && _driverId != null) {
      // Set sending flag to prevent double sending
      setState(() {
        _isSending = true;
      });

      // Generate a unique temporary ID for the message
      final tempMessageId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

      // Add message to UI immediately
      // _addMessage(
      //   text: text,
      //   senderId: _driverId!,
      //   senderRole: 'driver',
      //   timestamp: DateTime.now().toIso8601String(),
      //   messageId: tempMessageId,
      //   senderName: _driverName,
      // );

      // Send via socket
      final success = _socketManager!.sendChatMessage(
        orderId,
        text,
        receiverId: riderId,
        chatId: _chatId,
      );

      _isSending = false;
      if (!success) {
        print('❌ Socket sendChatMessage returned false');

        // Remove the temporary message if sending failed
        if (_mounted) {
          setState(() {
            _messages.removeWhere((msg) => msg.id == tempMessageId);
            _isSending = false; // Reset the flag
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _messageController.clear();
      _scrollToBottom();

      // Set a timeout to reset _isSending if no response from server
      _sendTimeoutTimer?.cancel();
      _sendTimeoutTimer = Timer(const Duration(seconds: 10), () {
        if (_mounted && _isSending) {
          print('⏰ Timeout: Resetting _isSending flag');
          setState(() {
            _isSending = false;
          });

          // Find and mark the temp message as failed
          final tempIndex = _messages.indexWhere(
            (msg) => msg.id == tempMessageId,
          );
          if (tempIndex != -1 && _mounted) {
            setState(() {
              _messages[tempIndex] = ChatMessage(
                id: tempMessageId,
                text: text,
                senderId: _driverId!,
                senderRole: 'driver',
                receiverId: riderId,
                receiverRole: 'rider',
                timestamp: DateTime.now().toIso8601String(),
                isRead: false,
                isSender: true,
                senderName: _driverName,
                chatId: _chatId,
                messageType: 'text',
              );
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message may not have been delivered'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    } else {
      print(
        "❌ Missing required data. OrderId: $orderId, RiderId: $riderId, DriverId: $_driverId",
      );
      if (_mounted) {
        setState(() {
          _isSending = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot send message: Missing ride information'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTime(String timestamp) {
    try {
      final date = DateTime.parse(timestamp).toLocal();
      return DateFormat('h:mm a').format(date);
    } catch (e) {
      return '';
    }
  }

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (dateOnly == today) return 'Today';
      if (dateOnly == yesterday) return 'Yesterday';
      return DateFormat('d MMM yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final riderName = widget.rideData?['riderName'] ?? 'Rider';
    final riderImage = widget.rideData?['riderImage'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: w * 0.06,
                ),
              ),
              SizedBox(width: w * 0.03),
              CircleAvatar(
                radius: w * 0.05,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: riderImage.isNotEmpty
                    ? NetworkImage(riderImage)
                    : null,
                child: riderImage.isEmpty
                    ? Icon(Icons.person, color: Colors.grey, size: w * 0.06)
                    : null,
              ),
              SizedBox(width: w * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppFonts.textPoppins(
                    context,
                    riderName,
                    w * 0.04,
                    FontWeight.w600,
                    Colors.black,
                    TextAlign.start,
                    TextOverflow.ellipsis,
                  ),
                  AppFonts.textPoppins(
                    context,

                    // _isConnected ? 'Online' : 'Offline',
                    _isConnected ? 'Online' : 'Online',
                    w * 0.03,
                    FontWeight.w400,
                    _isConnected ? Colors.green : Colors.grey,
                    TextAlign.start,
                    TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (_isLoadingHistory)
            Padding(
              padding: EdgeInsets.only(right: w * 0.04),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: w * 0.045,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: w * 0.02),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildChatList(w),
          ),

          // Input Bar
          _buildInputBar(w),
        ],
      ),
    );
  }

  Widget _buildChatList(double w) {
    // Group messages by date
    List<Widget> listItems = [];
    String? lastDate;

    for (var msg in _messages) {
      final msgDate = _formatDate(msg.timestamp);

      if (msgDate != lastDate) {
        listItems.add(_buildDateSeparator(msgDate, w));
        lastDate = msgDate;
      }
      listItems.add(_buildMessageBubble(msg, w));
    }

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
      children: listItems,
    );
  }

  Widget _buildDateSeparator(String date, double w) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: w * 0.04),
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          date,
          style: TextStyle(fontSize: w * 0.03, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, double w) {
    final bool isMe = msg.isSender;
    final senderName = msg.senderName ?? (isMe ? 'You' : 'Rider');

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: w * 0.04),
        constraints: BoxConstraints(maxWidth: w * 0.75),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Sender name for non-me messages
            if (!isMe && senderName.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: w * 0.02, bottom: w * 0.01),
                child: Text(
                  senderName,
                  style: TextStyle(
                    fontSize: w * 0.03,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            Container(
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFC6EFC8) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 15 : 5),
                  topRight: Radius.circular(isMe ? 5 : 15),
                  bottomLeft: const Radius.circular(15),
                  bottomRight: const Radius.circular(15),
                ),
                boxShadow: isMe
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: w * 0.038,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(height: w * 0.01),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(msg.timestamp),
                  style: TextStyle(
                    fontSize: w * 0.028,
                    color: Colors.grey[600],
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: w * 0.01),
                  Icon(
                    msg.isRead ? Icons.done_all : Icons.done,
                    size: w * 0.035,
                    color: msg.isRead ? Colors.blue : Colors.grey,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _isSending ? Colors.grey.shade100 : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: _isSending
                        ? Colors.grey.shade300
                        : Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: _isSending ? "Sending..." : "Type a message...",
                    hintStyle: TextStyle(
                      color: _isSending ? Colors.grey.shade400 : Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    suffixIcon: _isSending
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey.shade400,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  minLines: 1,
                  maxLines: 4,
                  onSubmitted: (_) => _sendMessage(),
                  enabled: !_isSending,
                ),
              ),
            ),
            SizedBox(width: w * 0.02),
            GestureDetector(
              onTap: _isSending ? null : _sendMessage,
              child: Container(
                width: w * 0.12,
                height: w * 0.12,
                decoration: BoxDecoration(
                  color: _isSending
                      ? Colors.grey.shade300
                      : const Color(0xFF007AFF),
                  shape: BoxShape.circle,
                ),
                child: _isSending
                    ? Center(
                        child: SizedBox(
                          width: w * 0.04,
                          height: w * 0.04,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Icon(Icons.send, color: Colors.white, size: w * 0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat Message Model
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
