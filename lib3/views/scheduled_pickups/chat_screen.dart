// // // // // // import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
// // // // // // import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
// // // // // // import 'package:corezap_driver/utilities/colors.dart';
// // // // // // import 'package:corezap_driver/utilities/custom_font.dart';
// // // // // // import 'package:corezap_driver/utilities/navigator.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:get/get_core/src/get_main.dart';
// // // // // // import 'package:get/get_instance/src/extension_instance.dart';

// // // // // // class ChatScreen extends StatefulWidget {
// // // // // //   final Map<String, dynamic>? rideData;

// // // // // //   final dynamic orderid;

// // // // // //   ChatScreen({super.key, this.rideData, this.orderid});

// // // // // //   @override
// // // // // //   State<ChatScreen> createState() => _ChatScreenState();
// // // // // // }

// // // // // // class _ChatScreenState extends State<ChatScreen> {
// // // // // //   final ChartidController chartidController = Get.find<ChartidController>();

// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();

// // // // // //     chartidController.getchartidmethod(orderid: widget.orderid);
// // // // // //   }

// // // // // //   void socketgetdatacall() {
// // // // // //     chartidController.getchartidmethod(orderid: widget.orderid);

// // // // // //     var chartid = chartidController.chartresposne.value!.data!.id;

// // // // // //     print("the__chartttidd ${chartid}");
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     double w = MediaQuery.of(context).size.width;
// // // // // //     double h = MediaQuery.of(context).size.height;
// // // // // //     String imagePath = "";

// // // // // //     return Scaffold(
// // // // // //       backgroundColor: Colors.white,
// // // // // //       appBar: AppBar(
// // // // // //         backgroundColor: AppColors.white,
// // // // // //         automaticallyImplyLeading: false,
// // // // // //         titleSpacing: w * .03,
// // // // // //         title: Row(
// // // // // //           children: [
// // // // // //             GestureDetector(
// // // // // //               onTap: () {
// // // // // //                 CustomNavigator.pop(context);
// // // // // //               },
// // // // // //               child: Icon(
// // // // // //                 Icons.arrow_back,
// // // // // //                 size: w * .07,
// // // // // //                 color: AppColors.black,
// // // // // //               ),
// // // // // //             ),
// // // // // //             SizedBox(width: w * .03),
// // // // // //             CircleAvatar(
// // // // // //               radius: w * .055,
// // // // // //               backgroundColor: Colors.grey.shade300,
// // // // // //               backgroundImage: imagePath != null && imagePath.isNotEmpty
// // // // // //                   ? AssetImage(imagePath) //  NetworkImage(imageUrl)
// // // // // //                   : null,
// // // // // //               child: (imagePath == null || imagePath.isEmpty)
// // // // // //                   ? Icon(
// // // // // //                       Icons.person,
// // // // // //                       size: w * .08,
// // // // // //                       color: Colors.grey.shade700,
// // // // // //                     )
// // // // // //                   : null,
// // // // // //             ),
// // // // // //             SizedBox(width: w * .02),
// // // // // //             Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 AppFonts.textPoppins(
// // // // // //                   context,
// // // // // //                   "Amaan Shaikh",
// // // // // //                   w * 0.03,
// // // // // //                   FontWeight.w400,
// // // // // //                   AppColors.black,
// // // // // //                   TextAlign.left,
// // // // // //                   TextOverflow.visible,
// // // // // //                 ),

// // // // // //                 Row(
// // // // // //                   crossAxisAlignment: CrossAxisAlignment.center,
// // // // // //                   children: [
// // // // // //                     CircleAvatar(
// // // // // //                       radius: w * .007,
// // // // // //                       backgroundColor: AppColors.green.withOpacity(0.2),
// // // // // //                     ),
// // // // // //                     SizedBox(width: w * .01),
// // // // // //                     AppFonts.textPoppins(
// // // // // //                       context,
// // // // // //                       "Online",
// // // // // //                       w * 0.03,
// // // // // //                       FontWeight.w400,
// // // // // //                       AppColors.green,
// // // // // //                       TextAlign.left,
// // // // // //                       TextOverflow.visible,
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //             Spacer(),
// // // // // //             Container(
// // // // // //               // margin: EdgeInsets.all(w * .02),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 shape: BoxShape.circle,
// // // // // //                 color: Colors.grey.shade300,
// // // // // //               ),

// // // // // //               padding: EdgeInsets.all(w * 0.02),
// // // // // //               child: Icon(Icons.call, color: AppColors.black, size: w * .04),
// // // // // //             ),
// // // // // //             SizedBox(width: w * .02),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //       body: Column(
// // // // // //         children: [
// // // // // //           Expanded(
// // // // // //             child: ListView(
// // // // // //               padding: EdgeInsets.all(w * 0.04),
// // // // // //               children: [
// // // // // //                 _receiverMessage(
// // // // // //                   w,
// // // // // //                   h,
// // // // // //                   "Okay, so are you there now because I’m about to leave the hold up now",
// // // // // //                   "2:55 PM",
// // // // // //                 ),
// // // // // //                 _senderMessage(
// // // // // //                   w,
// // // // // //                   h,
// // // // // //                   "Yes. Currently at the that petrol station at that junction",
// // // // // //                   "3:12 PM",
// // // // // //                 ),
// // // // // //                 _senderMessage(w, h, "Hi", "3:12 PM"),
// // // // // //                 _senderMessage(
// // // // // //                   w,
// // // // // //                   h,
// // // // // //                   "Hello, are you there?\nI’m waiting for you already",
// // // // // //                   "3:12 PM",
// // // // // //                 ),
// // // // // //                 _receiverMessage(w, h, "Yes, 2 mins out", "2:55 PM"),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //           _messageBox(w, h),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _senderMessage(double w, double h, String text, String time) {
// // // // // //     return Align(
// // // // // //       alignment: Alignment.centerRight,
// // // // // //       child: Container(
// // // // // //         margin: EdgeInsets.only(top: h * 0.01),
// // // // // //         padding: EdgeInsets.symmetric(
// // // // // //           horizontal: w * 0.04,
// // // // // //           vertical: h * 0.012,
// // // // // //         ),
// // // // // //         constraints: BoxConstraints(maxWidth: w * 0.7),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: Colors.pink.shade100,
// // // // // //           borderRadius: BorderRadius.circular(w * 0.04),
// // // // // //         ),
// // // // // //         child: Column(
// // // // // //           crossAxisAlignment: CrossAxisAlignment.end,
// // // // // //           children: [
// // // // // //             Text(
// // // // // //               text,
// // // // // //               style: TextStyle(fontSize: w * 0.04, color: Colors.black),
// // // // // //             ),
// // // // // //             SizedBox(height: h * 0.005),
// // // // // //             Text(
// // // // // //               time,
// // // // // //               style: TextStyle(fontSize: w * 0.03, color: Colors.grey),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _receiverMessage(double w, double h, String text, String time) {
// // // // // //     return Align(
// // // // // //       alignment: Alignment.centerLeft,
// // // // // //       child: Container(
// // // // // //         margin: EdgeInsets.only(top: h * 0.01),
// // // // // //         padding: EdgeInsets.symmetric(
// // // // // //           horizontal: w * 0.04,
// // // // // //           vertical: h * 0.012,
// // // // // //         ),
// // // // // //         constraints: BoxConstraints(maxWidth: w * 0.7),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: Colors.grey.shade200,
// // // // // //           borderRadius: BorderRadius.circular(w * 0.04),
// // // // // //         ),
// // // // // //         child: Column(
// // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //           children: [
// // // // // //             Text(
// // // // // //               text,
// // // // // //               style: TextStyle(fontSize: w * 0.04, color: Colors.black),
// // // // // //             ),
// // // // // //             SizedBox(height: h * 0.005),
// // // // // //             Text(
// // // // // //               time,
// // // // // //               style: TextStyle(fontSize: w * 0.03, color: Colors.grey),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _messageBox(double w, double h) {
// // // // // //     return Padding(
// // // // // //       padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .02),
// // // // // //       child: Container(
// // // // // //         height: w * .13,
// // // // // //         //  padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: Colors.white,
// // // // // //           borderRadius: BorderRadius.circular(w * .02),
// // // // // //           boxShadow: [
// // // // // //             BoxShadow(
// // // // // //               color: Colors.grey.shade300,
// // // // // //               blurRadius: 4,
// // // // // //               offset: const Offset(0, -2),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //         child: Row(
// // // // // //           children: [
// // // // // //             Expanded(
// // // // // //               child: TextField(
// // // // // //                 decoration: InputDecoration(
// // // // // //                   hintText: "Send Message",
// // // // // //                   hintStyle: TextStyle(fontSize: w * 0.04, color: Colors.grey),
// // // // // //                   border: InputBorder.none,
// // // // // //                   contentPadding: EdgeInsets.symmetric(
// // // // // //                     horizontal: w * .04,
// // // // // //                     vertical: w * .01,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //             // Padding(
// // // // // //             //   padding: EdgeInsets.only(right: w * .04),
// // // // // //             //   child: CustomImages.images(
// // // // // //             //     "assets/icons/messageSend.png",
// // // // // //             //     w * .06,
// // // // // //             //     w * .06,
// // // // // //             //   ),
// // // // // //             // ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }



// // // // // import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
// // // // // import 'package:corezap_driver/utilities/custom_font.dart';
// // // // // import 'package:corezap_driver/utilities/navigator.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:get/get.dart';
// // // // // import 'package:intl/intl.dart';


// // // // // class ChatScreen extends StatefulWidget {

// // // // //   final Map<String, dynamic>? rideData;
 

// // // // //   const ChatScreen({
// // // // //     super.key,

// // // // //     required this.rideData,
 
// // // // //   });

// // // // //   @override
// // // // //   State<ChatScreen> createState() => _ChatScreenState();
// // // // // }


// // // // // class _ChatScreenState extends State<ChatScreen> {
// // // // //   final TextEditingController _messageController = TextEditingController();
// // // // //   final ScrollController _scrollController = ScrollController();

// // // // //    final ChartidController chartidController = Get.find<ChartidController>();
// // // // //   // final UserSocketController _socketController =
// // // // //   //     Get.find<UserSocketController>();


// // // // //   final dynamic _socketController =
// // // // //       Get.find<dynamic>();
// // // // //   final FocusNode _focusNode = FocusNode();

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();

// // // // //      _getchartidmethod();
// // // // //     _focusNode.addListener(() {
// // // // //       if (_focusNode.hasFocus) {
// // // // //         Future.delayed(const Duration(milliseconds: 300), () {
// // // // //           _scrollToBottom();
// // // // //         });
// // // // //       }
// // // // //     });



// // // // //     // Initialize chat (Fetch ID -> Join Room -> Fetch History)
// // // // //     _socketController.joinChat(
// // // // //       rideId: widget.orderId,
// // // // //       receiverId: widget.driverId,
// // // // //       receiverRole: 'Driver',
// // // // //     );

// // // // //     // Auto-scroll when messages change
// // // // //     ever(_socketController.messages, (_) => _scrollToBottom());
// // // // //   }


// // // // //    void _getchartidmethod() {
// // // // //     chartidController.getchartidmethod(orderid: widget.rideData!['orderId']);
// // // // //   }

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _messageController.dispose();
// // // // //     _scrollController.dispose();
// // // // //     _focusNode.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   void _scrollToBottom() {
// // // // //     if (_scrollController.hasClients) {
// // // // //       Future.delayed(const Duration(milliseconds: 100), () {
// // // // //         _scrollController.animateTo(
// // // // //           _scrollController.position.maxScrollExtent,
// // // // //           duration: const Duration(milliseconds: 300),
// // // // //           curve: Curves.easeOut,
// // // // //         );
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   void _sendMessage() {
// // // // //     final text = _messageController.text.trim();
// // // // //     if (text.isEmpty) return;

// // // // //     _socketController.sendChatMessage(
// // // // //       orderId: widget.orderId,
// // // // //       message: text,
// // // // //       receiverId: widget.driverId,
// // // // //     );

// // // // //     _messageController.clear();
// // // // //     _scrollToBottom();
// // // // //   }

// // // // //   String _formatTime(String timestamp) {
// // // // //     try {
// // // // //       final date = DateTime.parse(timestamp).toLocal();
// // // // //       return DateFormat('h:mm a').format(date);
// // // // //     } catch (e) {
// // // // //       return '';
// // // // //     }
// // // // //   }

// // // // //   String _formatDate(String timestamp) {
// // // // //     try {
// // // // //       final date = DateTime.parse(timestamp).toLocal();
// // // // //       final now = DateTime.now();
// // // // //       final today = DateTime(now.year, now.month, now.day);
// // // // //       final yesterday = today.subtract(const Duration(days: 1));
// // // // //       final dateOnly = DateTime(date.year, date.month, date.day);

// // // // //       if (dateOnly == today) return 'Today';
// // // // //       if (dateOnly == yesterday) return 'Yesterday';
// // // // //       return DateFormat('d MMM yyyy').format(date);
// // // // //     } catch (e) {
// // // // //       return '';
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final double w = MediaQuery.of(context).size.width;

// // // // //     return Scaffold(
// // // // //       backgroundColor: const Color(0xFFF5F6FA), // Match RN styles.root
// // // // //       appBar: AppBar(
// // // // //         elevation: 1,
// // // // //         backgroundColor: Colors.white,
// // // // //         automaticallyImplyLeading: false,
// // // // //         title: Padding(
// // // // //           padding: EdgeInsets.symmetric(horizontal: w * 0.02),
// // // // //           child: Row(
// // // // //             children: [
// // // // //               GestureDetector(
// // // // //                 onTap: () => CustomNavigator.pop(context),
// // // // //                 child: Icon(
// // // // //                   Icons.arrow_back,
// // // // //                   color: Colors.black,
// // // // //                   size: w * 0.06,
// // // // //                 ),
// // // // //               ),
// // // // //               SizedBox(width: w * 0.03),
// // // // //               CircleAvatar(
// // // // //                 radius: w * 0.05,
// // // // //                 backgroundColor: Colors.grey.shade200,
// // // // //                 backgroundImage: widget.driverImage != null
// // // // //                     ? NetworkImage(widget.driverImage!)
// // // // //                     : null,
// // // // //                 child: widget.driverImage == null
// // // // //                     ? Icon(Icons.person, color: Colors.grey, size: w * 0.06)
// // // // //                     : null,
// // // // //               ),
// // // // //               SizedBox(width: w * 0.03),
// // // // //               Column(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   AppFonts.textPoppins(
// // // // //                     context,
// // // // //                     widget.driverName,
// // // // //                     w * 0.04,
// // // // //                     FontWeight.w600,
// // // // //                     Colors.black,
// // // // //                     TextAlign.start,
// // // // //                     TextOverflow.ellipsis,
// // // // //                   ),
// // // // //                   Obx(
// // // // //                     () => AppFonts.textPoppins(
// // // // //                       context,
// // // // //                       _socketController.isConnected.value
// // // // //                           ? 'Online'
// // // // //                           : 'Offline',
// // // // //                       w * 0.03,
// // // // //                       FontWeight.w400,
// // // // //                       _socketController.isConnected.value
// // // // //                           ? Colors.green
// // // // //                           : Colors.grey,
// // // // //                       TextAlign.start,
// // // // //                       TextOverflow.ellipsis,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //       body: Column(
// // // // //         children: [
// // // // //           // Chat Area
// // // // //           Expanded(
// // // // //             child: Obx(() {
// // // // //               if (_socketController.isLoadingChat.value) {
// // // // //                 return const Center(child: CircularProgressIndicator());
// // // // //               }

// // // // //               // Group Messages Logic (Simulating RN useEffect logic)
// // // // //               final messages = _socketController.messages;
// // // // //               if (messages.isEmpty) {
// // // // //                 return Center(
// // // // //                   child: Column(
// // // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // // //                     children: [
// // // // //                       Text(
// // // // //                         'No messages yet',
// // // // //                         style: TextStyle(
// // // // //                           fontSize: w * 0.045,
// // // // //                           color: Colors.grey[400],
// // // // //                           fontWeight: FontWeight.w600,
// // // // //                         ),
// // // // //                       ),
// // // // //                       SizedBox(height: w * 0.02),
// // // // //                       Text(
// // // // //                         'Start a conversation',
// // // // //                         style: TextStyle(
// // // // //                           fontSize: w * 0.035,
// // // // //                           color: Colors.grey[400],
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 );
// // // // //               }

// // // // //               // Convert simple list to grouped list item structure for rendering
// // // // //               List<Widget> listItems = [];
// // // // //               String? lastDate;

// // // // //               for (var msg in messages) {
// // // // //                 final msgDate = _formatDate(msg.timestamp);

// // // // //                 if (msgDate != lastDate) {
// // // // //                   listItems.add(_buildDateSeparator(msgDate, w));
// // // // //                   lastDate = msgDate;
// // // // //                 }
// // // // //                 listItems.add(_buildMessageBubble(msg, w));
// // // // //               }

// // // // //               return ListView(
// // // // //                 controller: _scrollController,
// // // // //                 padding: EdgeInsets.symmetric(
// // // // //                   horizontal: w * 0.04,
// // // // //                   vertical: w * 0.02,
// // // // //                 ),
// // // // //                 children: listItems,
// // // // //               );
// // // // //             }),
// // // // //           ),

// // // // //           // Input Bar
// // // // //           _buildInputBar(w),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildDateSeparator(String date, double w) {
// // // // //     return Center(
// // // // //       child: Container(
// // // // //         margin: EdgeInsets.symmetric(vertical: w * 0.04),
// // // // //         padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
// // // // //         decoration: BoxDecoration(
// // // // //           color: const Color(0xFFF0F0F0),
// // // // //           borderRadius: BorderRadius.circular(10),
// // // // //         ),
// // // // //         child: Text(
// // // // //           date,
// // // // //           style: TextStyle(fontSize: w * 0.03, color: Colors.grey[600]),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildMessageBubble(dynamic msg, double w) {
// // // // //     // msg is ChatMessage model
// // // // //     final bool isMe = msg.isSender;

// // // // //     return Align(
// // // // //       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
// // // // //       child: Container(
// // // // //         margin: EdgeInsets.only(bottom: w * 0.04),
// // // // //         constraints: BoxConstraints(maxWidth: w * 0.75),
// // // // //         child: Column(
// // // // //           crossAxisAlignment: isMe
// // // // //               ? CrossAxisAlignment.end
// // // // //               : CrossAxisAlignment.start,
// // // // //           children: [
// // // // //             Container(
// // // // //               padding: EdgeInsets.all(w * 0.03),
// // // // //               decoration: BoxDecoration(
// // // // //                 color: isMe
// // // // //                     ? const Color(0xFFC6EFC8)
// // // // //                     : Colors.white, // Match RN colors
// // // // //                 borderRadius: BorderRadius.only(
// // // // //                   topLeft: Radius.circular(isMe ? 15 : 5),
// // // // //                   topRight: Radius.circular(isMe ? 5 : 15),
// // // // //                   bottomLeft: const Radius.circular(15),
// // // // //                   bottomRight: const Radius.circular(15),
// // // // //                 ),
// // // // //                 boxShadow: isMe
// // // // //                     ? []
// // // // //                     : [
// // // // //                         BoxShadow(
// // // // //                           color: Colors.black.withOpacity(0.05),
// // // // //                           blurRadius: 1,
// // // // //                           offset: const Offset(0, 1),
// // // // //                         ),
// // // // //                       ],
// // // // //               ),
// // // // //               child: Text(
// // // // //                 msg.text,
// // // // //                 style: TextStyle(
// // // // //                   fontSize: w * 0.038,
// // // // //                   color: Colors.black,
// // // // //                   height: 1.2,
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //             SizedBox(height: w * 0.01),
// // // // //             Row(
// // // // //               mainAxisSize: MainAxisSize.min,
// // // // //               children: [
// // // // //                 Text(
// // // // //                   _formatTime(msg.timestamp),
// // // // //                   style: TextStyle(
// // // // //                     fontSize: w * 0.028,
// // // // //                     color: Colors.grey[600],
// // // // //                   ),
// // // // //                 ),
// // // // //                 if (isMe) ...[
// // // // //                   SizedBox(width: w * 0.01),
// // // // //                   // Simple checkmark simulator logic
// // // // //                   Icon(Icons.done_all, size: w * 0.035, color: Colors.blue),
// // // // //                 ],
// // // // //               ],
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildInputBar(double w) {
// // // // //     return Container(
// // // // //       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         border: Border(top: BorderSide(color: Colors.grey.shade200)),
// // // // //       ),
// // // // //       child: SafeArea(
// // // // //         // Handle bottom notch
// // // // //         child: Row(
// // // // //           children: [
// // // // //             Expanded(
// // // // //               child: Container(
// // // // //                 decoration: BoxDecoration(
// // // // //                   color: Colors.white,
// // // // //                   borderRadius: BorderRadius.circular(25),
// // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // //                 ),
// // // // //                 child: TextField(
// // // // //                   controller: _messageController,
// // // // //                   focusNode: _focusNode,
// // // // //                   decoration: const InputDecoration(
// // // // //                     hintText: "Type a message...",
// // // // //                     hintStyle: TextStyle(color: Colors.grey),
// // // // //                     border: InputBorder.none,
// // // // //                     contentPadding: EdgeInsets.symmetric(
// // // // //                       horizontal: 16,
// // // // //                       vertical: 10,
// // // // //                     ),
// // // // //                   ),
// // // // //                   minLines: 1,
// // // // //                   maxLines: 4,
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //             SizedBox(width: w * 0.02),
// // // // //             GestureDetector(
// // // // //               onTap: _sendMessage,
// // // // //               child: Container(
// // // // //                 width: w * 0.12,
// // // // //                 height: w * 0.12,
// // // // //                 decoration: const BoxDecoration(
// // // // //                   color: Color(0xFF007AFF),
// // // // //                   shape: BoxShape.circle,
// // // // //                 ),
// // // // //                 child: Icon(Icons.send, color: Colors.white, size: w * 0.05),
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }


// // // // import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
// // // // import 'package:corezap_driver/services/socket_manager.dart';
// // // // import 'package:corezap_driver/utilities/custom_font.dart';
// // // // import 'package:corezap_driver/utilities/navigator.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:intl/intl.dart';

// // // // class ChatScreen extends StatefulWidget {
// // // //   final Map<String, dynamic>? rideData;

// // // //   const ChatScreen({
// // // //     super.key,
// // // //     required this.rideData,
// // // //   });

// // // //   @override
// // // //   State<ChatScreen> createState() => _ChatScreenState();
// // // // }

// // // // class _ChatScreenState extends State<ChatScreen> {
// // // //   final TextEditingController _messageController = TextEditingController();
// // // //   final ScrollController _scrollController = ScrollController();
// // // //   final ChartidController chartidController = Get.find<ChartidController>();
// // // //   final FocusNode _focusNode = FocusNode();
  
// // // //   // Store messages locally
// // // //   final List<ChatMessage> _messages = [];
// // // //   bool _isLoading = false;
// // // //   bool _isConnected = false;
// // // //   String? _chatId;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _initializeChat();
// // // //     _focusNode.addListener(() {
// // // //       if (_focusNode.hasFocus) {
// // // //         Future.delayed(const Duration(milliseconds: 300), () {
// // // //           _scrollToBottom();
// // // //         });
// // // //       }
// // // //     });
// // // //   }

// // // //   void _initializeChat() async {
// // // //     setState(() {
// // // //       _isLoading = true;
// // // //     });

// // // //     try {
// // // //       // First get the chat ID from controller
// // // //       await _getchartidmethod();

// // // //       // Wait a moment for chat ID to be available
// // // //       await Future.delayed(const Duration(milliseconds: 500));

// // // //       // Get chat ID from controller response
// // // //       final chatId = chartidController.chartresposne.value?.data?.id;
// // // //       if (chatId != null) {
// // // //         _chatId = chatId;
// // // //         print("Chat ID obtained: $_chatId");

// // // //         // Get the socket manager instance
// // // //         final socketManager = Get.find<SocketManager>();

// // // //         // Set up socket listeners
// // // //         _setupSocketListeners(socketManager);

// // // //         // Join the chat room
// // // //         _joinChatRoom(socketManager);

// // // //         // Get chat history
// // // //         _getChatHistory(socketManager);
// // // //       } else {
// // // //         print("No chat ID available");
// // // //       }
// // // //     } catch (e) {
// // // //       print("Error initializing chat: $e");
// // // //     } finally {
// // // //       setState(() {
// // // //         _isLoading = false;
// // // //       });
// // // //     }
// // // //   }

// // // //   void _setupSocketListeners(SocketManager socketManager) {
// // // //     // Connection status
// // // //     socketManager.onConnectionStatusChange = (isConnected) {
// // // //       setState(() {
// // // //         _isConnected = isConnected;
// // // //       });
// // // //     };

// // // //     // Chat messages
// // // //     socketManager.onChatMessage = (data) {
// // // //       print("New chat message received: $data");
// // // //       _handleIncomingMessage(data);
// // // //     };

// // // //     // Chat join success
// // // //     socketManager.onChatJoin = (data) {
// // // //       print("Joined chat successfully: $data");
// // // //     };

// // // //     // Chat error
// // // //     socketManager.onChatError = (data) {
// // // //       print("Chat error: $data");
// // // //       // Handle error (show snackbar, etc.)
// // // //     };

// // // //     // Message sent confirmation
// // // //     socketManager.onChatMessageSent = (data) {
// // // //       print("Message sent successfully: $data");
// // // //       // You can update message status here if needed
// // // //     };
// // // //   }

// // // //   void _joinChatRoom(SocketManager socketManager) {
// // // //     final orderId = widget.rideData?['orderId']?.toString();
// // // //     if (orderId != null) {
// // // //       socketManager.joinChatRoom(
// // // //         orderId,
// // // //         userRole: 'driver',
// // // //       );
// // // //     }
// // // //   }

// // // //   void _getChatHistory(SocketManager socketManager) {
// // // //     final orderId = widget.rideData?['orderId']?.toString();
// // // //     if (orderId != null) {
// // // //       // This will depend on your socket implementation
// // // //       // You might need to emit an event to get history
// // // //       socketManager.getChatHistory(orderId);
// // // //     }
// // // //   }

// // // //   void _handleIncomingMessage(Map<String, dynamic> data) {
// // // //     try {
// // // //       final message = ChatMessage(
// // // //         id: data['_id'] ?? data['messageId'] ?? UniqueKey().toString(),
// // // //         text: data['message'] ?? data['text'] ?? '',
// // // //         senderId: data['senderId'] ?? '',
// // // //         senderRole: data['senderRole'] ?? data['senderType'] ?? '',
// // // //         receiverId: data['receiverId'] ?? '',
// // // //         receiverRole: data['receiverRole'] ?? '',
// // // //         timestamp: data['timestamp'] ?? DateTime.now().toIso8601String(),
// // // //         isRead: data['isRead'] ?? false,
// // // //         isSender: (data['senderRole'] ?? data['senderType']) == 'driver',
// // // //       );

// // // //       setState(() {
// // // //         _messages.add(message);
// // // //       });

// // // //       _scrollToBottom();
// // // //     } catch (e) {
// // // //       print("Error handling incoming message: $e");
// // // //     }
// // // //   }

// // // //   void _getchartidmethod() {
// // // //     final orderId = widget.rideData?['orderId']?.toString();
// // // //     if (orderId != null) {
// // // //       chartidController.getchartidmethod(orderid: orderId);
// // // //     }
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _messageController.dispose();
// // // //     _scrollController.dispose();
// // // //     _focusNode.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   void _scrollToBottom() {
// // // //     if (_scrollController.hasClients) {
// // // //       Future.delayed(const Duration(milliseconds: 100), () {
// // // //         _scrollController.animateTo(
// // // //           _scrollController.position.maxScrollExtent,
// // // //           duration: const Duration(milliseconds: 300),
// // // //           curve: Curves.easeOut,
// // // //         );
// // // //       });
// // // //     }
// // // //   }

// // // //   void _sendMessage() {
// // // //     final text = _messageController.text.trim();
// // // //     if (text.isEmpty) return;

// // // //     final socketManager = Get.find<SocketManager>();
// // // //     final orderId = widget.rideData?['orderId']?.toString();
// // // //     final riderId = widget.rideData?['riderId']?.toString();

// // // //     if (orderId != null && riderId != null) {
// // // //       // Add message to UI immediately
// // // //       final tempMessage = ChatMessage(
// // // //         id: UniqueKey().toString(),
// // // //         text: text,
// // // //         senderId: 'driver', // You'll need to get actual driver ID
// // // //         senderRole: 'driver',
// // // //         receiverId: riderId,
// // // //         receiverRole: 'user',
// // // //         timestamp: DateTime.now().toIso8601String(),
// // // //         isRead: false,
// // // //         isSender: true,
// // // //       );

// // // //       setState(() {
// // // //         _messages.add(tempMessage);
// // // //       });

// // // //       // Send via socket
// // // //       socketManager.sendChatMessage(
// // // //         orderId,
// // // //         text,
// // // //         receiverId: riderId,
// // // //         chatId: _chatId,
// // // //       );

// // // //       _messageController.clear();
// // // //       _scrollToBottom();
// // // //     }
// // // //   }

// // // //   String _formatTime(String timestamp) {
// // // //     try {
// // // //       final date = DateTime.parse(timestamp).toLocal();
// // // //       return DateFormat('h:mm a').format(date);
// // // //     } catch (e) {
// // // //       return '';
// // // //     }
// // // //   }

// // // //   String _formatDate(String timestamp) {
// // // //     try {
// // // //       final date = DateTime.parse(timestamp).toLocal();
// // // //       final now = DateTime.now();
// // // //       final today = DateTime(now.year, now.month, now.day);
// // // //       final yesterday = today.subtract(const Duration(days: 1));
// // // //       final dateOnly = DateTime(date.year, date.month, date.day);

// // // //       if (dateOnly == today) return 'Today';
// // // //       if (dateOnly == yesterday) return 'Yesterday';
// // // //       return DateFormat('d MMM yyyy').format(date);
// // // //     } catch (e) {
// // // //       return '';
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final double w = MediaQuery.of(context).size.width;
// // // //     final riderName = widget.rideData?['riderName'] ?? 'Rider';
// // // //     final riderImage = widget.rideData?['riderImage'] ?? '';

// // // //     return Scaffold(
// // // //       backgroundColor: const Color(0xFFF5F6FA),
// // // //       appBar: AppBar(
// // // //         elevation: 1,
// // // //         backgroundColor: Colors.white,
// // // //         automaticallyImplyLeading: false,
// // // //         title: Padding(
// // // //           padding: EdgeInsets.symmetric(horizontal: w * 0.02),
// // // //           child: Row(
// // // //             children: [
// // // //               GestureDetector(
// // // //                 onTap: () => CustomNavigator.pop(context),
// // // //                 child: Icon(
// // // //                   Icons.arrow_back,
// // // //                   color: Colors.black,
// // // //                   size: w * 0.06,
// // // //                 ),
// // // //               ),
// // // //               SizedBox(width: w * 0.03),
// // // //               CircleAvatar(
// // // //                 radius: w * 0.05,
// // // //                 backgroundColor: Colors.grey.shade200,
// // // //                 backgroundImage: riderImage.isNotEmpty
// // // //                     ? NetworkImage(riderImage)
// // // //                     : null,
// // // //                 child: riderImage.isEmpty
// // // //                     ? Icon(Icons.person, color: Colors.grey, size: w * 0.06)
// // // //                     : null,
// // // //               ),
// // // //               SizedBox(width: w * 0.03),
// // // //               Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   AppFonts.textPoppins(
// // // //                     context,
// // // //                     riderName,
// // // //                     w * 0.04,
// // // //                     FontWeight.w600,
// // // //                     Colors.black,
// // // //                     TextAlign.start,
// // // //                     TextOverflow.ellipsis,
// // // //                   ),
// // // //                   AppFonts.textPoppins(
// // // //                     context,
// // // //                     _isConnected ? 'Online' : 'Offline',
// // // //                     w * 0.03,
// // // //                     FontWeight.w400,
// // // //                     _isConnected ? Colors.green : Colors.grey,
// // // //                     TextAlign.start,
// // // //                     TextOverflow.ellipsis,
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       body: Column(
// // // //         children: [
// // // //           // Chat Area
// // // //           Expanded(
// // // //             child: _isLoading
// // // //                 ? const Center(child: CircularProgressIndicator())
// // // //                 : _messages.isEmpty
// // // //                     ? Center(
// // // //                         child: Column(
// // // //                           mainAxisAlignment: MainAxisAlignment.center,
// // // //                           children: [
// // // //                             Text(
// // // //                               'No messages yet',
// // // //                               style: TextStyle(
// // // //                                 fontSize: w * 0.045,
// // // //                                 color: Colors.grey[400],
// // // //                                 fontWeight: FontWeight.w600,
// // // //                               ),
// // // //                             ),
// // // //                             SizedBox(height: w * 0.02),
// // // //                             Text(
// // // //                               'Start a conversation',
// // // //                               style: TextStyle(
// // // //                                 fontSize: w * 0.035,
// // // //                                 color: Colors.grey[400],
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       )
// // // //                     : _buildChatList(w),
// // // //           ),

// // // //           // Input Bar
// // // //           _buildInputBar(w),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildChatList(double w) {
// // // //     // Group messages by date
// // // //     List<Widget> listItems = [];
// // // //     String? lastDate;

// // // //     for (var msg in _messages) {
// // // //       final msgDate = _formatDate(msg.timestamp);

// // // //       if (msgDate != lastDate) {
// // // //         listItems.add(_buildDateSeparator(msgDate, w));
// // // //         lastDate = msgDate;
// // // //       }
// // // //       listItems.add(_buildMessageBubble(msg, w));
// // // //     }

// // // //     return ListView(
// // // //       controller: _scrollController,
// // // //       padding: EdgeInsets.symmetric(
// // // //         horizontal: w * 0.04,
// // // //         vertical: w * 0.02,
// // // //       ),
// // // //       children: listItems,
// // // //     );
// // // //   }

// // // //   Widget _buildDateSeparator(String date, double w) {
// // // //     return Center(
// // // //       child: Container(
// // // //         margin: EdgeInsets.symmetric(vertical: w * 0.04),
// // // //         padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
// // // //         decoration: BoxDecoration(
// // // //           color: const Color(0xFFF0F0F0),
// // // //           borderRadius: BorderRadius.circular(10),
// // // //         ),
// // // //         child: Text(
// // // //           date,
// // // //           style: TextStyle(fontSize: w * 0.03, color: Colors.grey[600]),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildMessageBubble(ChatMessage msg, double w) {
// // // //     final bool isMe = msg.isSender;

// // // //     return Align(
// // // //       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
// // // //       child: Container(
// // // //         margin: EdgeInsets.only(bottom: w * 0.04),
// // // //         constraints: BoxConstraints(maxWidth: w * 0.75),
// // // //         child: Column(
// // // //           crossAxisAlignment:
// // // //               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// // // //           children: [
// // // //             Container(
// // // //               padding: EdgeInsets.all(w * 0.03),
// // // //               decoration: BoxDecoration(
// // // //                 color: isMe ? const Color(0xFFC6EFC8) : Colors.white,
// // // //                 borderRadius: BorderRadius.only(
// // // //                   topLeft: Radius.circular(isMe ? 15 : 5),
// // // //                   topRight: Radius.circular(isMe ? 5 : 15),
// // // //                   bottomLeft: const Radius.circular(15),
// // // //                   bottomRight: const Radius.circular(15),
// // // //                 ),
// // // //                 boxShadow: isMe
// // // //                     ? []
// // // //                     : [
// // // //                         BoxShadow(
// // // //                           color: Colors.black.withOpacity(0.05),
// // // //                           blurRadius: 1,
// // // //                           offset: const Offset(0, 1),
// // // //                         ),
// // // //                       ],
// // // //               ),
// // // //               child: Text(
// // // //                 msg.text,
// // // //                 style: TextStyle(
// // // //                   fontSize: w * 0.038,
// // // //                   color: Colors.black,
// // // //                   height: 1.2,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             SizedBox(height: w * 0.01),
// // // //             Row(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 Text(
// // // //                   _formatTime(msg.timestamp),
// // // //                   style: TextStyle(
// // // //                     fontSize: w * 0.028,
// // // //                     color: Colors.grey[600],
// // // //                   ),
// // // //                 ),
// // // //                 if (isMe) ...[
// // // //                   SizedBox(width: w * 0.01),
// // // //                   Icon(Icons.done_all, size: w * 0.035, color: Colors.blue),
// // // //                 ],
// // // //               ],
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildInputBar(double w) {
// // // //     return Container(
// // // //       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         border: Border(top: BorderSide(color: Colors.grey.shade200)),
// // // //       ),
// // // //       child: SafeArea(
// // // //         child: Row(
// // // //           children: [
// // // //             Expanded(
// // // //               child: Container(
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.white,
// // // //                   borderRadius: BorderRadius.circular(25),
// // // //                   border: Border.all(color: Colors.grey.shade300),
// // // //                 ),
// // // //                 child: TextField(
// // // //                   controller: _messageController,
// // // //                   focusNode: _focusNode,
// // // //                   decoration: const InputDecoration(
// // // //                     hintText: "Type a message...",
// // // //                     hintStyle: TextStyle(color: Colors.grey),
// // // //                     border: InputBorder.none,
// // // //                     contentPadding: EdgeInsets.symmetric(
// // // //                       horizontal: 16,
// // // //                       vertical: 10,
// // // //                     ),
// // // //                   ),
// // // //                   minLines: 1,
// // // //                   maxLines: 4,
// // // //                   onSubmitted: (_) => _sendMessage(),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             SizedBox(width: w * 0.02),
// // // //             GestureDetector(
// // // //               onTap: _sendMessage,
// // // //               child: Container(
// // // //                 width: w * 0.12,
// // // //                 height: w * 0.12,
// // // //                 decoration: const BoxDecoration(
// // // //                   color: Color(0xFF007AFF),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.send, color: Colors.white, size: w * 0.05),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // Chat Message Model
// // // // class ChatMessage {
// // // //   final String id;
// // // //   final String text;
// // // //   final String senderId;
// // // //   final String senderRole;
// // // //   final String receiverId;
// // // //   final String receiverRole;
// // // //   final String timestamp;
// // // //   final bool isRead;
// // // //   final bool isSender;

// // // //   ChatMessage({
// // // //     required this.id,
// // // //     required this.text,
// // // //     required this.senderId,
// // // //     required this.senderRole,
// // // //     required this.receiverId,
// // // //     required this.receiverRole,
// // // //     required this.timestamp,
// // // //     required this.isRead,
// // // //     required this.isSender,
// // // //   });
// // // // }


// // // import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
// // // import 'package:corezap_driver/services/socket_manager.dart';
// // // import 'package:corezap_driver/utilities/custom_font.dart';
// // // import 'package:corezap_driver/utilities/navigator.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:intl/intl.dart';

// // // class ChatScreen extends StatefulWidget {
// // //   final Map<String, dynamic>? rideData;

// // //   const ChatScreen({
// // //     super.key,
// // //     required this.rideData,
// // //   });

// // //   @override
// // //   State<ChatScreen> createState() => _ChatScreenState();
// // // }

// // // class _ChatScreenState extends State<ChatScreen> {
// // //   final TextEditingController _messageController = TextEditingController();
// // //   final ScrollController _scrollController = ScrollController();
// // //   final ChartidController chartidController = Get.find<ChartidController>();
// // //   final FocusNode _focusNode = FocusNode();
  
// // //   // Store messages locally
// // //   final List<ChatMessage> _messages = [];
// // //   bool _isLoading = false;
// // //   bool _isConnected = false;
// // //   String? _chatId;
// // //   SocketManager? _socketManager;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initializeChat();
// // //     _focusNode.addListener(() {
// // //       if (_focusNode.hasFocus) {
// // //         Future.delayed(const Duration(milliseconds: 300), () {
// // //           _scrollToBottom();
// // //         });
// // //       }
// // //     });
// // //   }

// // //   Future<void> _initializeChat() async {
// // //     setState(() {
// // //       _isLoading = true;
// // //     });

// // //     try {
// // //       // Get the chat ID from controller
// // //       await _getchartidmethod();

// // //       // Get chat ID from controller response
// // //       final chatId = chartidController.chartresposne.value?.data?.id;
// // //       if (chatId != null) {
// // //         _chatId = chatId;
// // //         print("Chat ID obtained: $_chatId");

// // //         // Get the socket manager instance
// // //         _socketManager = Get.find<SocketManager>();

// // //         // Set up socket listeners
// // //         _setupSocketListeners();

// // //         // Join the chat room
// // //         _joinChatRoom();

// // //         // Get chat history
// // //         _getChatHistory();
// // //       } else {
// // //         print("No chat ID available");
// // //       }
// // //     } catch (e) {
// // //       print("Error initializing chat: $e");
// // //     } finally {
// // //       setState(() {
// // //         _isLoading = false;
// // //       });
// // //     }
// // //   }

// // //   Future<void> _getchartidmethod() async {
// // //     final orderId = widget.rideData?['orderId']?.toString();
// // //     if (orderId != null) {
// // //       await chartidController.getchartidmethod(orderid: orderId);
// // //     }
// // //   }

// // //   void _setupSocketListeners() {
// // //     if (_socketManager == null) return;

// // //     // Connection status
// // //     _socketManager!.onConnectionStatusChange = (isConnected) {
// // //       setState(() {
// // //         _isConnected = isConnected;
// // //       });
// // //     };

// // //     // Chat messages
// // //     _socketManager!.onChatMessage = (data) {
// // //       print("New chat message received: $data");
// // //       _handleIncomingMessage(data);
// // //     };

// // //     // Chat join success
// // //     _socketManager!.onChatJoin = (data) {
// // //       print("Joined chat successfully: $data");
// // //     };

// // //     // Chat error
// // //     _socketManager!.onChatError = (data) {
// // //       print("Chat error: $data");
// // //       // Handle error (show snackbar, etc.)
// // //     };

// // //     // Message sent confirmation
// // //     _socketManager!.onChatMessageSent = (data) {
// // //       print("Message sent successfully: $data");
// // //       // You can update message status here if needed
// // //     };
// // //   }

// // //   void _joinChatRoom() {
// // //     if (_socketManager == null) return;
    
// // //     final orderId = widget.rideData?['orderId']?.toString();
// // //     if (orderId != null) {
// // //       _socketManager!.joinChatRoom(
// // //         orderId,
// // //         userRole: 'driver',
// // //       );
// // //     }
// // //   }

// // //   void _getChatHistory() {
// // //     if (_socketManager == null) return;
    
// // //     final orderId = widget.rideData?['orderId']?.toString();
// // //     if (orderId != null) {
// // //       // This will depend on your socket implementation
// // //       // You might need to emit an event to get history
// // //       _socketManager!.getChatHistory(orderId);
// // //     }
// // //   }

// // //   void _handleIncomingMessage(Map<String, dynamic> data) {
// // //     try {
// // //       final message = ChatMessage(
// // //         id: data['_id'] ?? data['messageId'] ?? UniqueKey().toString(),
// // //         text: data['message'] ?? data['text'] ?? '',
// // //         senderId: data['senderId'] ?? '',
// // //         senderRole: data['senderRole'] ?? data['senderType'] ?? '',
// // //         receiverId: data['receiverId'] ?? '',
// // //         receiverRole: data['receiverRole'] ?? '',
// // //         timestamp: data['timestamp'] ?? DateTime.now().toIso8601String(),
// // //         isRead: data['isRead'] ?? false,
// // //         isSender: (data['senderRole'] ?? data['senderType']) == 'driver',
// // //       );

// // //       setState(() {
// // //         _messages.add(message);
// // //       });

// // //       _scrollToBottom();
// // //     } catch (e) {
// // //       print("Error handling incoming message: $e");
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _messageController.dispose();
// // //     _scrollController.dispose();
// // //     _focusNode.dispose();
// // //     // Leave chat room when screen is disposed
// // //     if (_socketManager != null) {
// // //       final orderId = widget.rideData?['orderId']?.toString();
// // //       if (orderId != null) {
// // //         _socketManager!.leaveChatRoom(orderId);
// // //       }
// // //     }
// // //     super.dispose();
// // //   }

// // //   void _scrollToBottom() {
// // //     if (_scrollController.hasClients) {
// // //       Future.delayed(const Duration(milliseconds: 100), () {
// // //         _scrollController.animateTo(
// // //           _scrollController.position.maxScrollExtent,
// // //           duration: const Duration(milliseconds: 300),
// // //           curve: Curves.easeOut,
// // //         );
// // //       });
// // //     }
// // //   }

// // //   void _sendMessage() {
// // //     final text = _messageController.text.trim();
// // //     if (text.isEmpty) return;

// // //     if (_socketManager == null) {
// // //       print("Socket manager not available");
// // //       return;
// // //     }

// // //     final orderId = widget.rideData?['orderId']?.toString();
// // //     final riderId = widget.rideData?['riderId']?.toString();

// // //     if (orderId != null && riderId != null) {
// // //       // Add message to UI immediately
// // //       final tempMessage = ChatMessage(
// // //         id: UniqueKey().toString(),
// // //         text: text,
// // //         senderId: 'driver', // You'll need to get actual driver ID
// // //         senderRole: 'driver',
// // //         receiverId: riderId,
// // //         receiverRole: 'user',
// // //         timestamp: DateTime.now().toIso8601String(),
// // //         isRead: false,
// // //         isSender: true,
// // //       );

// // //       setState(() {
// // //         _messages.add(tempMessage);
// // //       });

// // //       // Send via socket
// // //       _socketManager!.sendChatMessage(
// // //         orderId,
// // //         text,
// // //         receiverId: riderId,
// // //         chatId: _chatId,
// // //       );

// // //       _messageController.clear();
// // //       _scrollToBottom();
// // //     }
// // //   }

// // //   String _formatTime(String timestamp) {
// // //     try {
// // //       final date = DateTime.parse(timestamp).toLocal();
// // //       return DateFormat('h:mm a').format(date);
// // //     } catch (e) {
// // //       return '';
// // //     }
// // //   }

// // //   String _formatDate(String timestamp) {
// // //     try {
// // //       final date = DateTime.parse(timestamp).toLocal();
// // //       final now = DateTime.now();
// // //       final today = DateTime(now.year, now.month, now.day);
// // //       final yesterday = today.subtract(const Duration(days: 1));
// // //       final dateOnly = DateTime(date.year, date.month, date.day);

// // //       if (dateOnly == today) return 'Today';
// // //       if (dateOnly == yesterday) return 'Yesterday';
// // //       return DateFormat('d MMM yyyy').format(date);
// // //     } catch (e) {
// // //       return '';
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final double w = MediaQuery.of(context).size.width;
// // //     final riderName = widget.rideData?['riderName'] ?? 'Rider';
// // //     final riderImage = widget.rideData?['riderImage'] ?? '';

// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFF5F6FA),
// // //       appBar: AppBar(
// // //         elevation: 1,
// // //         backgroundColor: Colors.white,
// // //         automaticallyImplyLeading: false,
// // //         title: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: w * 0.02),
// // //           child: Row(
// // //             children: [
// // //               GestureDetector(
// // //                 onTap: () => CustomNavigator.pop(context),
// // //                 child: Icon(
// // //                   Icons.arrow_back,
// // //                   color: Colors.black,
// // //                   size: w * 0.06,
// // //                 ),
// // //               ),
// // //               SizedBox(width: w * 0.03),
// // //               CircleAvatar(
// // //                 radius: w * 0.05,
// // //                 backgroundColor: Colors.grey.shade200,
// // //                 backgroundImage: riderImage.isNotEmpty
// // //                     ? NetworkImage(riderImage)
// // //                     : null,
// // //                 child: riderImage.isEmpty
// // //                     ? Icon(Icons.person, color: Colors.grey, size: w * 0.06)
// // //                     : null,
// // //               ),
// // //               SizedBox(width: w * 0.03),
// // //               Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   AppFonts.textPoppins(
// // //                     context,
// // //                     riderName,
// // //                     w * 0.04,
// // //                     FontWeight.w600,
// // //                     Colors.black,
// // //                     TextAlign.start,
// // //                     TextOverflow.ellipsis,
// // //                   ),
// // //                   AppFonts.textPoppins(
// // //                     context,
// // //                     _isConnected ? 'Online' : 'Offline',
// // //                     w * 0.03,
// // //                     FontWeight.w400,
// // //                     _isConnected ? Colors.green : Colors.grey,
// // //                     TextAlign.start,
// // //                     TextOverflow.ellipsis,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // Chat Area
// // //           Expanded(
// // //             child: _isLoading
// // //                 ? const Center(child: CircularProgressIndicator())
// // //                 : _messages.isEmpty
// // //                     ? Center(
// // //                         child: Column(
// // //                           mainAxisAlignment: MainAxisAlignment.center,
// // //                           children: [
// // //                             Text(
// // //                               'No messages yet',
// // //                               style: TextStyle(
// // //                                 fontSize: w * 0.045,
// // //                                 color: Colors.grey[400],
// // //                                 fontWeight: FontWeight.w600,
// // //                               ),
// // //                             ),
// // //                             SizedBox(height: w * 0.02),
// // //                             Text(
// // //                               'Start a conversation',
// // //                               style: TextStyle(
// // //                                 fontSize: w * 0.035,
// // //                                 color: Colors.grey[400],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       )
// // //                     : _buildChatList(w),
// // //           ),

// // //           // Input Bar
// // //           _buildInputBar(w),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildChatList(double w) {
// // //     // Group messages by date
// // //     List<Widget> listItems = [];
// // //     String? lastDate;

// // //     for (var msg in _messages) {
// // //       final msgDate = _formatDate(msg.timestamp);

// // //       if (msgDate != lastDate) {
// // //         listItems.add(_buildDateSeparator(msgDate, w));
// // //         lastDate = msgDate;
// // //       }
// // //       listItems.add(_buildMessageBubble(msg, w));
// // //     }

// // //     return ListView(
// // //       controller: _scrollController,
// // //       padding: EdgeInsets.symmetric(
// // //         horizontal: w * 0.04,
// // //         vertical: w * 0.02,
// // //       ),
// // //       children: listItems,
// // //     );
// // //   }

// // //   Widget _buildDateSeparator(String date, double w) {
// // //     return Center(
// // //       child: Container(
// // //         margin: EdgeInsets.symmetric(vertical: w * 0.04),
// // //         padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
// // //         decoration: BoxDecoration(
// // //           color: const Color(0xFFF0F0F0),
// // //           borderRadius: BorderRadius.circular(10),
// // //         ),
// // //         child: Text(
// // //           date,
// // //           style: TextStyle(fontSize: w * 0.03, color: Colors.grey[600]),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildMessageBubble(ChatMessage msg, double w) {
// // //     final bool isMe = msg.isSender;

// // //     return Align(
// // //       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
// // //       child: Container(
// // //         margin: EdgeInsets.only(bottom: w * 0.04),
// // //         constraints: BoxConstraints(maxWidth: w * 0.75),
// // //         child: Column(
// // //           crossAxisAlignment:
// // //               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// // //           children: [
// // //             Container(
// // //               padding: EdgeInsets.all(w * 0.03),
// // //               decoration: BoxDecoration(
// // //                 color: isMe ? const Color(0xFFC6EFC8) : Colors.white,
// // //                 borderRadius: BorderRadius.only(
// // //                   topLeft: Radius.circular(isMe ? 15 : 5),
// // //                   topRight: Radius.circular(isMe ? 5 : 15),
// // //                   bottomLeft: const Radius.circular(15),
// // //                   bottomRight: const Radius.circular(15),
// // //                 ),
// // //                 boxShadow: isMe
// // //                     ? []
// // //                     : [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(0.05),
// // //                           blurRadius: 1,
// // //                           offset: const Offset(0, 1),
// // //                         ),
// // //                       ],
// // //               ),
// // //               child: Text(
// // //                 msg.text,
// // //                 style: TextStyle(
// // //                   fontSize: w * 0.038,
// // //                   color: Colors.black,
// // //                   height: 1.2,
// // //                 ),
// // //               ),
// // //             ),
// // //             SizedBox(height: w * 0.01),
// // //             Row(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Text(
// // //                   _formatTime(msg.timestamp),
// // //                   style: TextStyle(
// // //                     fontSize: w * 0.028,
// // //                     color: Colors.grey[600],
// // //                   ),
// // //                 ),
// // //                 if (isMe) ...[
// // //                   SizedBox(width: w * 0.01),
// // //                   Icon(Icons.done_all, size: w * 0.035, color: Colors.blue),
// // //                 ],
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInputBar(double w) {
// // //     return Container(
// // //       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         border: Border(top: BorderSide(color: Colors.grey.shade200)),
// // //       ),
// // //       child: SafeArea(
// // //         child: Row(
// // //           children: [
// // //             Expanded(
// // //               child: Container(
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.white,
// // //                   borderRadius: BorderRadius.circular(25),
// // //                   border: Border.all(color: Colors.grey.shade300),
// // //                 ),
// // //                 child: TextField(
// // //                   controller: _messageController,
// // //                   focusNode: _focusNode,
// // //                   decoration: const InputDecoration(
// // //                     hintText: "Type a message...",
// // //                     hintStyle: TextStyle(color: Colors.grey),
// // //                     border: InputBorder.none,
// // //                     contentPadding: EdgeInsets.symmetric(
// // //                       horizontal: 16,
// // //                       vertical: 10,
// // //                     ),
// // //                   ),
// // //                   minLines: 1,
// // //                   maxLines: 4,
// // //                   onSubmitted: (_) => _sendMessage(),
// // //                 ),
// // //               ),
// // //             ),
// // //             SizedBox(width: w * 0.02),
// // //             GestureDetector(
// // //               onTap: _sendMessage,
// // //               child: Container(
// // //                 width: w * 0.12,
// // //                 height: w * 0.12,
// // //                 decoration: const BoxDecoration(
// // //                   color: Color(0xFF007AFF),
// // //                   shape: BoxShape.circle,
// // //                 ),
// // //                 child: Icon(Icons.send, color: Colors.white, size: w * 0.05),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // Chat Message Model
// // // class ChatMessage {
// // //   final String id;
// // //   final String text;
// // //   final String senderId;
// // //   final String senderRole;
// // //   final String receiverId;
// // //   final String receiverRole;
// // //   final String timestamp;
// // //   final bool isRead;
// // //   final bool isSender;

// // //   ChatMessage({
// // //     required this.id,
// // //     required this.text,
// // //     required this.senderId,
// // //     required this.senderRole,
// // //     required this.receiverId,
// // //     required this.receiverRole,
// // //     required this.timestamp,
// // //     required this.isRead,
// // //     required this.isSender,
// // //   });
// // // }


// // import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
// // import 'package:corezap_driver/services/socket_manager.dart';
// // import 'package:corezap_driver/utilities/custom_font.dart';
// // import 'package:corezap_driver/utilities/navigator.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:intl/intl.dart';

// // class ChatScreen extends StatefulWidget {
// //   final Map<String, dynamic>? rideData;

// //   const ChatScreen({
// //     super.key,
// //     required this.rideData,
// //   });

// //   @override
// //   State<ChatScreen> createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> {
// //   final TextEditingController _messageController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //   final ChartidController chartidController = Get.find<ChartidController>();
// //   final FocusNode _focusNode = FocusNode();
  
// //   // Store messages locally
// //   final List<ChatMessage> _messages = [];
// //   bool _isLoading = false;
// //   bool _isConnected = false;
// //   String? _chatId;
// //   SocketManager? _socketManager;
// //   bool _mounted = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _mounted = true;
// //     print('💬 ChatScreen initState');
    
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       await _initializeChat();
// //     });
    
// //     _focusNode.addListener(() {
// //       if (_focusNode.hasFocus && _mounted) {
// //         Future.delayed(const Duration(milliseconds: 300), () {
// //           _scrollToBottom();
// //         });
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     print('💬 ChatScreen dispose');
// //     _mounted = false;
    
// //     _messageController.dispose();
// //     _scrollController.dispose();
// //     _focusNode.dispose();
    
// //     // Leave chat room when screen is disposed
// //     if (_socketManager != null) {
// //       final orderId = widget.rideData?['orderId']?.toString();
// //       if (orderId != null) {
// //         try {
// //           _socketManager!.leaveChatRoom(orderId);
// //         } catch (e) {
// //           print("Error leaving chat room: $e");
// //         }
// //       }
// //     }
    
// //     super.dispose();
// //   }

// //   Future<void> _initializeChat() async {
// //     if (!_mounted) return;
    
// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       print('💬 Initializing chat...');
      
// //       // Get the chat ID from controller
// //       await _getchartidmethod();
      
// //       // Wait a moment for the response to update
// //       await Future.delayed(const Duration(milliseconds: 500));
      
// //       // Get chat ID from controller response
// //       final chatId = chartidController.chartresposne.value?.data?.id;
// //       if (chatId != null) {
// //         _chatId = chatId;
// //         print("✅ Chat ID obtained: $_chatId");

// //         // Get the socket manager instance
// //         _socketManager = Get.find<SocketManager>();

// //         // Set up socket listeners
// //         _setupSocketListeners();

// //         // Join the chat room
// //         _joinChatRoom();

// //         // Get chat history
// //         _getChatHistory();
// //       } else {
// //         print("⚠️ No chat ID available");
// //         if (_mounted) {
// //           ScaffoldMessenger.of(Get.context!).showSnackBar(
// //             const SnackBar(
// //               content: Text('Chat initialization failed. Please try again.'),
// //               backgroundColor: Colors.orange,
// //             ),
// //           );
// //         }
// //       }
// //     } catch (e) {
// //       print("❌ Error initializing chat: $e");
// //       if (_mounted) {
// //         ScaffoldMessenger.of(Get.context!).showSnackBar(
// //           SnackBar(
// //             content: Text('Error: ${e.toString()}'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (_mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   Future<void> _getchartidmethod() async {
// //     try {
// //       final orderId = widget.rideData?['orderId']?.toString();
// //       if (orderId != null) {
// //         print('💬 Getting chart ID for order: $orderId');
// //         await chartidController.getchartidmethod(orderid: orderId);
// //       } else {
// //         throw Exception('No order ID in ride data');
// //       }
// //     } catch (e) {
// //       print('❌ Error in _getchartidmethod: $e');
// //       rethrow;
// //     }
// //   }

// //   void _setupSocketListeners() {
// //     if (_socketManager == null) return;

// //     // Connection status
// //     _socketManager!.onConnectionStatusChange = (isConnected) {
// //       if (_mounted) {
// //         setState(() {
// //           _isConnected = isConnected;
// //         });
// //       }
// //     };

// //     // Chat messages
// //     _socketManager!.onChatMessage = (data) {
// //       print("💬 New chat message received: $data");
// //       _handleIncomingMessage(data);
// //     };

// //     // Chat join success
// //     _socketManager!.onChatJoin = (data) {
// //       print("✅ Joined chat successfully: $data");
// //     };

// //     // Chat error
// //     _socketManager!.onChatError = (data) {
// //       print("❌ Chat error: $data");
// //       if (_mounted) {
// //         ScaffoldMessenger.of(Get.context!).showSnackBar(
// //           SnackBar(
// //             content: Text('Chat error: ${data.toString()}'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     };

// //     // Message sent confirmation
// //     _socketManager!.onChatMessageSent = (data) {
// //       print("✅ Message sent successfully: $data");
// //     };
// //   }

// //   void _joinChatRoom() {
// //     if (_socketManager == null) return;
    
// //     final orderId = widget.rideData?['orderId']?.toString();
// //     if (orderId != null) {
// //       print('💬 Joining chat room for order: $orderId');
// //       _socketManager!.joinChatRoom(
// //         orderId,
// //         userRole: 'driver',
// //       );
// //     }
// //   }

// //   void _getChatHistory() {
// //     if (_socketManager == null) return;
    
// //     final orderId = widget.rideData?['orderId']?.toString();
// //     if (orderId != null) {
// //       print('💬 Getting chat history for order: $orderId');
// //       _socketManager!.getChatHistory(orderId);
// //     }
// //   }

// //   void _handleIncomingMessage(Map<String, dynamic> data) {
// //     if (!_mounted) return;
    
// //     try {
// //       final message = ChatMessage(
// //         id: data['_id'] ?? data['messageId'] ?? UniqueKey().toString(),
// //         text: data['message'] ?? data['text'] ?? '',
// //         senderId: data['senderId'] ?? '',
// //         senderRole: data['senderRole'] ?? data['senderType'] ?? '',
// //         receiverId: data['receiverId'] ?? '',
// //         receiverRole: data['receiverRole'] ?? '',
// //         timestamp: data['timestamp'] ?? DateTime.now().toIso8601String(),
// //         isRead: data['isRead'] ?? false,
// //         isSender: (data['senderRole'] ?? data['senderType'] ?? '').toString().toLowerCase() == 'driver',
// //       );

// //       setState(() {
// //         _messages.add(message);
// //       });

// //       _scrollToBottom();
// //     } catch (e) {
// //       print("❌ Error handling incoming message: $e");
// //     }
// //   }

// //   void _scrollToBottom() {
// //     if (_scrollController.hasClients && _mounted) {
// //       Future.delayed(const Duration(milliseconds: 100), () {
// //         if (_scrollController.hasClients && _mounted) {
// //           _scrollController.animateTo(
// //             _scrollController.position.maxScrollExtent,
// //             duration: const Duration(milliseconds: 300),
// //             curve: Curves.easeOut,
// //           );
// //         }
// //       });
// //     }
// //   }

// //   void _sendMessage() {
// //     final text = _messageController.text.trim();
// //     if (text.isEmpty) return;

// //     if (_socketManager == null) {
// //       print("❌ Socket manager not available");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Not connected to chat server'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     final orderId = widget.rideData?['orderId']?.toString();
// //     final riderId = widget.rideData?['riderId']?.toString();

// //     if (orderId != null && riderId != null) {
// //       // Add message to UI immediately
// //       final tempMessage = ChatMessage(
// //         id: UniqueKey().toString(),
// //         text: text,
// //         senderId: 'driver', // You'll need to get actual driver ID
// //         senderRole: 'driver',
// //         receiverId: riderId,
// //         receiverRole: 'user',
// //         timestamp: DateTime.now().toIso8601String(),
// //         isRead: false,
// //         isSender: true,
// //       );

// //       if (_mounted) {
// //         setState(() {
// //           _messages.add(tempMessage);
// //         });
// //       }

// //       // Send via socket
// //       final success = _socketManager!.sendChatMessage(
// //         orderId,
// //         text,
// //         receiverId: riderId,
// //         chatId: _chatId,
// //       );

// //       if (!success) {
// //         if (_mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text('Failed to send message'),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //         }
// //       }

// //       _messageController.clear();
// //       _scrollToBottom();
// //     } else {
// //       print("❌ Missing orderId or riderId");
// //       if (_mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Cannot send message: Missing ride information'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     }
// //   }

// //   String _formatTime(String timestamp) {
// //     try {
// //       final date = DateTime.parse(timestamp).toLocal();
// //       return DateFormat('h:mm a').format(date);
// //     } catch (e) {
// //       return '';
// //     }
// //   }

// //   String _formatDate(String timestamp) {
// //     try {
// //       final date = DateTime.parse(timestamp).toLocal();
// //       final now = DateTime.now();
// //       final today = DateTime(now.year, now.month, now.day);
// //       final yesterday = today.subtract(const Duration(days: 1));
// //       final dateOnly = DateTime(date.year, date.month, date.day);

// //       if (dateOnly == today) return 'Today';
// //       if (dateOnly == yesterday) return 'Yesterday';
// //       return DateFormat('d MMM yyyy').format(date);
// //     } catch (e) {
// //       return '';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final double w = MediaQuery.of(context).size.width;
// //     final riderName = widget.rideData?['riderName'] ?? 'Rider';
// //     final riderImage = widget.rideData?['riderImage'] ?? '';

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F6FA),
// //       appBar: AppBar(
// //         elevation: 1,
// //         backgroundColor: Colors.white,
// //         automaticallyImplyLeading: false,
// //         title: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: w * 0.02),
// //           child: Row(
// //             children: [
// //               GestureDetector(
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: Icon(
// //                   Icons.arrow_back,
// //                   color: Colors.black,
// //                   size: w * 0.06,
// //                 ),
// //               ),
// //               SizedBox(width: w * 0.03),
// //               CircleAvatar(
// //                 radius: w * 0.05,
// //                 backgroundColor: Colors.grey.shade200,
// //                 backgroundImage: riderImage.isNotEmpty
// //                     ? NetworkImage(riderImage)
// //                     : null,
// //                 child: riderImage.isEmpty
// //                     ? Icon(Icons.person, color: Colors.grey, size: w * 0.06)
// //                     : null,
// //               ),
// //               SizedBox(width: w * 0.03),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   AppFonts.textPoppins(
// //                     context,
// //                     riderName,
// //                     w * 0.04,
// //                     FontWeight.w600,
// //                     Colors.black,
// //                     TextAlign.start,
// //                     TextOverflow.ellipsis,
// //                   ),
// //                   AppFonts.textPoppins(
// //                     context,
// //                     _isConnected ? 'Online' : 'Offline',
// //                     w * 0.03,
// //                     FontWeight.w400,
// //                     _isConnected ? Colors.green : Colors.grey,
// //                     TextAlign.start,
// //                     TextOverflow.ellipsis,
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           // Chat Area
// //           Expanded(
// //             child: _isLoading
// //                 ? const Center(child: CircularProgressIndicator())
// //                 : _messages.isEmpty
// //                     ? Center(
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text(
// //                               'No messages yet',
// //                               style: TextStyle(
// //                                 fontSize: w * 0.045,
// //                                 color: Colors.grey[400],
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                             ),
// //                             SizedBox(height: w * 0.02),
// //                             Text(
// //                               'Start a conversation',
// //                               style: TextStyle(
// //                                 fontSize: w * 0.035,
// //                                 color: Colors.grey[400],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       )
// //                     : _buildChatList(w),
// //           ),

// //           // Input Bar
// //           _buildInputBar(w),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildChatList(double w) {
// //     // Group messages by date
// //     List<Widget> listItems = [];
// //     String? lastDate;

// //     for (var msg in _messages) {
// //       final msgDate = _formatDate(msg.timestamp);

// //       if (msgDate != lastDate) {
// //         listItems.add(_buildDateSeparator(msgDate, w));
// //         lastDate = msgDate;
// //       }
// //       listItems.add(_buildMessageBubble(msg, w));
// //     }

// //     return ListView(
// //       controller: _scrollController,
// //       padding: EdgeInsets.symmetric(
// //         horizontal: w * 0.04,
// //         vertical: w * 0.02,
// //       ),
// //       children: listItems,
// //     );
// //   }

// //   Widget _buildDateSeparator(String date, double w) {
// //     return Center(
// //       child: Container(
// //         margin: EdgeInsets.symmetric(vertical: w * 0.04),
// //         padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFF0F0F0),
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Text(
// //           date,
// //           style: TextStyle(fontSize: w * 0.03, color: Colors.grey[600]),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMessageBubble(ChatMessage msg, double w) {
// //     final bool isMe = msg.isSender;

// //     return Align(
// //       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
// //       child: Container(
// //         margin: EdgeInsets.only(bottom: w * 0.04),
// //         constraints: BoxConstraints(maxWidth: w * 0.75),
// //         child: Column(
// //           crossAxisAlignment:
// //               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               padding: EdgeInsets.all(w * 0.03),
// //               decoration: BoxDecoration(
// //                 color: isMe ? const Color(0xFFC6EFC8) : Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: Radius.circular(isMe ? 15 : 5),
// //                   topRight: Radius.circular(isMe ? 5 : 15),
// //                   bottomLeft: const Radius.circular(15),
// //                   bottomRight: const Radius.circular(15),
// //                 ),
// //                 boxShadow: isMe
// //                     ? []
// //                     : [
// //                         BoxShadow(
// //                           color: Colors.black.withOpacity(0.05),
// //                           blurRadius: 1,
// //                           offset: const Offset(0, 1),
// //                         ),
// //                       ],
// //               ),
// //               child: Text(
// //                 msg.text,
// //                 style: TextStyle(
// //                   fontSize: w * 0.038,
// //                   color: Colors.black,
// //                   height: 1.2,
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: w * 0.01),
// //             Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text(
// //                   _formatTime(msg.timestamp),
// //                   style: TextStyle(
// //                     fontSize: w * 0.028,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //                 if (isMe) ...[
// //                   SizedBox(width: w * 0.01),
// //                   Icon(Icons.done_all, size: w * 0.035, color: Colors.blue),
// //                 ],
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInputBar(double w) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         border: Border(top: BorderSide(color: Colors.grey.shade200)),
// //       ),
// //       child: SafeArea(
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(25),
// //                   border: Border.all(color: Colors.grey.shade300),
// //                 ),
// //                 child: TextField(
// //                   controller: _messageController,
// //                   focusNode: _focusNode,
// //                   decoration: const InputDecoration(
// //                     hintText: "Type a message...",
// //                     hintStyle: TextStyle(color: Colors.grey),
// //                     border: InputBorder.none,
// //                     contentPadding: EdgeInsets.symmetric(
// //                       horizontal: 16,
// //                       vertical: 10,
// //                     ),
// //                   ),
// //                   minLines: 1,
// //                   maxLines: 4,
// //                   onSubmitted: (_) => _sendMessage(),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(width: w * 0.02),
// //             GestureDetector(
// //               onTap: _sendMessage,
// //               child: Container(
// //                 width: w * 0.12,
// //                 height: w * 0.12,
// //                 decoration: const BoxDecoration(
// //                   color: Color(0xFF007AFF),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.send, color: Colors.white, size: w * 0.05),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Chat Message Model
// // class ChatMessage {
// //   final String id;
// //   final String text;
// //   final String senderId;
// //   final String senderRole;
// //   final String receiverId;
// //   final String receiverRole;
// //   final String timestamp;
// //   final bool isRead;
// //   final bool isSender;

// //   ChatMessage({
// //     required this.id,
// //     required this.text,
// //     required this.senderId,
// //     required this.senderRole,
// //     required this.receiverId,
// //     required this.receiverRole,
// //     required this.timestamp,
// //     required this.isRead,
// //     required this.isSender,
// //   });
// // }


// import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
// import 'package:corezap_driver/services/socket_manager.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatScreen extends StatefulWidget {
//   final Map<String, dynamic>? rideData;

//   const ChatScreen({
//     super.key,
//     required this.rideData,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final ChartidController chartidController = Get.find<ChartidController>();
//   final FocusNode _focusNode = FocusNode();
  
//   // Store messages locally
//   final List<ChatMessage> _messages = [];
//   bool _isLoading = false;
//   bool _isConnected = false;
//   String? _chatId;
//   SocketManager? _socketManager;
//   bool _mounted = true;
//   String? _driverId;
//   String? _driverName;

//   @override
//   void initState() {
//     super.initState();
//     _mounted = true;
//     print('💬 ChatScreen initState');
    
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _loadDriverInfo();
//       await _initializeChat();
//     });
    
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus && _mounted) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           _scrollToBottom();
//         });
//       }
//     });
//   }

//   Future<void> _loadDriverInfo() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       _driverId = prefs.getString("driver_userid");
      
//       final storedDriverData = prefs.getString('driverData');
//       if (storedDriverData != null) {
//         final driverData = Map<String, dynamic>.from(json.decode(storedDriverData));
//         _driverName = driverData['name'] ?? driverData['driverName'] ?? 'Driver';
//       }
      
//       print('👤 Driver info loaded: $_driverName (ID: $_driverId)');
//     } catch (e) {
//       print('❌ Error loading driver info: $e');
//     }
//   }

//   @override
//   void dispose() {
//     print('💬 ChatScreen dispose');
//     _mounted = false;
    
//     _messageController.dispose();
//     _scrollController.dispose();
//     _focusNode.dispose();
    
//     // Leave chat room when screen is disposed
//     if (_socketManager != null) {
//       final orderId = widget.rideData?['orderId']?.toString();
//       if (orderId != null) {
//         try {
//           _socketManager!.leaveChatRoom(orderId);
//         } catch (e) {
//           print("Error leaving chat room: $e");
//         }
//       }
//     }
    
//     super.dispose();
//   }

//   Future<void> _initializeChat() async {
//     if (!_mounted) return;
    
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       print('💬 Initializing chat...');
      
//       // Get the chat ID from controller
//       await _getchartidmethod();
      
//       // Wait a moment for the response to update
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       // Get chat ID from controller response
//       final chatId = chartidController.chartresposne.value?.data?.id;
//       if (chatId != null) {
//         _chatId = chatId;
//         print("✅ Chat ID obtained: $_chatId");

//         // Get the socket manager instance
//         try {
//           _socketManager = Get.find<SocketManager>();
//           print("✅ SocketManager found in GetX");
//         } catch (e) {
//           print("⚠️ SocketManager not found, creating new instance");
//           _socketManager = SocketManager();
//           Get.put(_socketManager!, permanent: true);
//         }

//         // Set up socket listeners
//         _setupSocketListeners();

//         // Join the chat room
//         _joinChatRoom();

//         // Get chat history
//         _getChatHistory();
//       } else {
//         print("⚠️ No chat ID available");
//         if (_mounted) {
//           ScaffoldMessenger.of(Get.context!).showSnackBar(
//             const SnackBar(
//               content: Text('Chat initialization failed. Please try again.'),
//               backgroundColor: Colors.orange,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print("❌ Error initializing chat: $e");
//       if (_mounted) {
//         ScaffoldMessenger.of(Get.context!).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (_mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _getchartidmethod() async {
//     try {
//       final orderId = widget.rideData?['orderId']?.toString();
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

//   void _setupSocketListeners() {
//     if (_socketManager == null) return;

//     // Connection status
//     _socketManager!.onConnectionStatusChange = (isConnected) {
//       if (_mounted) {
//         setState(() {
//           _isConnected = isConnected;
//         });
//       }
//     };

//     // Chat messages
//     _socketManager!.onChatMessage = (data) {
//       print("💬 New chat message received: ${data.keys}");
//       _handleIncomingMessage(data);
//     };

//     // Chat join success
//     _socketManager!.onChatJoin = (data) {
//       print("✅ Joined chat successfully: $data");
//     };

//     // Chat error
//     _socketManager!.onChatError = (data) {
//       print("❌ Chat error: $data");
//       if (_mounted) {
//         ScaffoldMessenger.of(Get.context!).showSnackBar(
//           SnackBar(
//             content: Text('Chat error: ${data.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     };

//     // Message sent confirmation
//     _socketManager!.onChatMessageSent = (data) {
//       print("✅ Message sent successfully: $data");
//     };
//   }

//   void _joinChatRoom() {
//     if (_socketManager == null) return;
    
//     final orderId = widget.rideData?['orderId']?.toString();
//     if (orderId != null) {
//       print('💬 Joining chat room for order: $orderId');
//       _socketManager!.joinChatRoom(
//         orderId,
//         userRole: 'driver',
//       );
//     }
//   }

//   void _getChatHistory() {
//     if (_socketManager == null) return;
    
//     final orderId = widget.rideData?['orderId']?.toString();
//     if (orderId != null) {
//       print('💬 Getting chat history for order: $orderId');
//       _socketManager!.getChatHistory(orderId);
//     }
//   }

//   void _handleIncomingMessage(Map<String, dynamic> data) {
//     if (!_mounted) return;
    
//     try {
//       print('💬 Processing incoming message data: ${data.keys}');
      
//       // Extract the nested message object
//       final Map<String, dynamic>? messageData = data['message'];
      
//       if (messageData == null) {
//         print('⚠️ No message data found in socket response');
//         // Try direct fields
//         final messageText = data['text']?.toString() ?? data['message']?.toString();
//         if (messageText != null && messageText.isNotEmpty) {
//           _addMessage(
//             text: messageText,
//             senderId: data['senderId']?.toString() ?? 'unknown',
//             senderRole: data['senderRole']?.toString() ?? data['senderType']?.toString() ?? 'rider',
//             timestamp: data['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
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
//         // senderId is an object with _id and name
//         senderId = senderIdData['_id']?.toString() ?? '';
//         senderName = senderIdData['name']?.toString() ?? 'Rider';
//       } else {
//         // senderId is just a string ID
//         senderId = senderIdData?.toString() ?? '';
//         senderName = senderType == 'Driver' ? 'Driver' : 'Rider';
//       }
      
//       // Get message text
//       final messageText = messageData['message']?.toString() ?? '';
      
//       if (messageText.isEmpty) {
//         print('⚠️ Empty message text received');
//         return;
//       }
      
//       _addMessage(
//         text: messageText,
//         senderId: senderId,
//         senderRole: senderType.toLowerCase(),
//         timestamp: messageData['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
//         messageId: messageData['_id']?.toString() ?? UniqueKey().toString(),
//         senderName: senderName,
//       );
      
//     } catch (e) {
//       print("❌ Error handling incoming message: $e");
//       print("❌ Full data received: $data");
      
//       // Fallback: try to extract message text directly
//       try {
//         final String? messageText = data['message']?.toString() ?? data['text']?.toString();
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
//   }) {
//     final isSender = senderRole.toLowerCase() == 'driver' || 
//                      senderId == _driverId || 
//                      (senderName != null && senderName == _driverName);
    
//     final message = ChatMessage(
//       id: messageId,
//       text: text,
//       senderId: senderId,
//       senderRole: senderRole,
//       receiverId: isSender ? widget.rideData != null?['riderId']?.toString() ?? '' : _driverId ?? '' ,
//       receiverRole: isSender ? 'rider' : 'driver',
//       timestamp: timestamp,
//       isRead: false,
//       isSender: isSender,
//       senderName: senderName,
//     );

//     print('✅ Created chat message: "$text" from ${senderName ?? senderRole} (isSender: $isSender)');
    
//     setState(() {
//       _messages.add(message);
//     });

//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients && _mounted) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (_scrollController.hasClients && _mounted) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     }
//   }

//   void _sendMessage() {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;

//     if (_socketManager == null) {
//       print("❌ Socket manager not available");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Not connected to chat server'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     final orderId = widget.rideData?['orderId']?.toString();
//     final riderId = widget.rideData?['riderId']?.toString();

//     if (orderId != null && riderId != null && _driverId != null) {
//       // Add message to UI immediately
//       _addMessage(
//         text: text,
//         senderId: _driverId!,
//         senderRole: 'driver',
//         timestamp: DateTime.now().toIso8601String(),
//         messageId: UniqueKey().toString(),
//         senderName: _driverName,
//       );

//       // Send via socket
//       final success = _socketManager!.sendChatMessage(
//         orderId,
//         text,
//         receiverId: riderId,
//         chatId: _chatId,
//       );

//       if (!success) {
//         if (_mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Failed to send message'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }

//       _messageController.clear();
//       _scrollToBottom();
//     } else {
//       print("❌ Missing required data. OrderId: $orderId, RiderId: $riderId, DriverId: $_driverId");
//       if (_mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Cannot send message: Missing ride information'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   String _formatTime(String timestamp) {
//     try {
//       final date = DateTime.parse(timestamp).toLocal();
//       return DateFormat('h:mm a').format(date);
//     } catch (e) {
//       return '';
//     }
//   }

//   String _formatDate(String timestamp) {
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

//   @override
//   Widget build(BuildContext context) {
//     final double w = MediaQuery.of(context).size.width;
//     final riderName = widget.rideData?['riderName'] ?? 'Rider';
//     final riderImage = widget.rideData?['riderImage'] ?? '';

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: AppBar(
//         elevation: 1,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         title: Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * 0.02),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                   size: w * 0.06,
//                 ),
//               ),
//               SizedBox(width: w * 0.03),
//               CircleAvatar(
//                 radius: w * 0.05,
//                 backgroundColor: Colors.grey.shade200,
//                 backgroundImage: riderImage.isNotEmpty
//                     ? NetworkImage(riderImage)
//                     : null,
//                 child: riderImage.isEmpty
//                     ? Icon(Icons.person, color: Colors.grey, size: w * 0.06)
//                     : null,
//               ),
//               SizedBox(width: w * 0.03),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppFonts.textPoppins(
//                     context,
//                     riderName,
//                     w * 0.04,
//                     FontWeight.w600,
//                     Colors.black,
//                     TextAlign.start,
//                     TextOverflow.ellipsis,
//                   ),
//                   AppFonts.textPoppins(
//                     context,
//                     _isConnected ? 'Online' : 'Offline',
//                     w * 0.03,
//                     FontWeight.w400,
//                     _isConnected ? Colors.green : Colors.grey,
//                     TextAlign.start,
//                     TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Chat Area
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _messages.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'No messages yet',
//                               style: TextStyle(
//                                 fontSize: w * 0.045,
//                                 color: Colors.grey[400],
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             SizedBox(height: w * 0.02),
//                             Text(
//                               'Start a conversation',
//                               style: TextStyle(
//                                 fontSize: w * 0.035,
//                                 color: Colors.grey[400],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : _buildChatList(w),
//           ),

//           // Input Bar
//           _buildInputBar(w),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatList(double w) {
//     // Group messages by date
//     List<Widget> listItems = [];
//     String? lastDate;

//     for (var msg in _messages) {
//       final msgDate = _formatDate(msg.timestamp);

//       if (msgDate != lastDate) {
//         listItems.add(_buildDateSeparator(msgDate, w));
//         lastDate = msgDate;
//       }
//       listItems.add(_buildMessageBubble(msg, w));
//     }

//     return ListView(
//       controller: _scrollController,
//       padding: EdgeInsets.symmetric(
//         horizontal: w * 0.04,
//         vertical: w * 0.02,
//       ),
//       children: listItems,
//     );
//   }

//   Widget _buildDateSeparator(String date, double w) {
//     return Center(
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: w * 0.04),
//         padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF0F0F0),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           date,
//           style: TextStyle(fontSize: w * 0.03, color: Colors.grey[600]),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(ChatMessage msg, double w) {
//     final bool isMe = msg.isSender;
//     final senderName = msg.senderName ?? (isMe ? 'You' : 'Rider');

//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(bottom: w * 0.04),
//         constraints: BoxConstraints(maxWidth: w * 0.75),
//         child: Column(
//           crossAxisAlignment:
//               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             // Sender name for non-me messages
//             if (!isMe && senderName.isNotEmpty)
//               Padding(
//                 padding: EdgeInsets.only(left: w * 0.02, bottom: w * 0.01),
//                 child: Text(
//                   senderName,
//                   style: TextStyle(
//                     fontSize: w * 0.03,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
            
//             Container(
//               padding: EdgeInsets.all(w * 0.03),
//               decoration: BoxDecoration(
//                 color: isMe ? const Color(0xFFC6EFC8) : Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(isMe ? 15 : 5),
//                   topRight: Radius.circular(isMe ? 5 : 15),
//                   bottomLeft: const Radius.circular(15),
//                   bottomRight: const Radius.circular(15),
//                 ),
//                 boxShadow: isMe
//                     ? []
//                     : [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 1,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//               ),
//               child: Text(
//                 msg.text,
//                 style: TextStyle(
//                   fontSize: w * 0.038,
//                   color: Colors.black,
//                   height: 1.2,
//                 ),
//               ),
//             ),
//             SizedBox(height: w * 0.01),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _formatTime(msg.timestamp),
//                   style: TextStyle(
//                     fontSize: w * 0.028,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 if (isMe) ...[
//                   SizedBox(width: w * 0.01),
//                   Icon(Icons.done_all, size: w * 0.035, color: Colors.blue),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputBar(double w) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(25),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   focusNode: _focusNode,
//                   decoration: const InputDecoration(
//                     hintText: "Type a message...",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                   ),
//                   minLines: 1,
//                   maxLines: 4,
//                   onSubmitted: (_) => _sendMessage(),
//                 ),
//               ),
//             ),
//             SizedBox(width: w * 0.02),
//             GestureDetector(
//               onTap: _sendMessage,
//               child: Container(
//                 width: w * 0.12,
//                 height: w * 0.12,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF007AFF),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.send, color: Colors.white, size: w * 0.05),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Chat Message Model
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
//   });
// }

// // Add this import at the top if not already there
// import 'dart:convert';



import 'dart:convert';

import 'package:corezap_driver/controllers/chart_id_controller/chartid_controller.dart';
import 'package:corezap_driver/services/socket_manager.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? rideData;

  const ChatScreen({
    super.key,
    required this.rideData,
  });

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
  bool _isConnected = false;
  String? _chatId;
  SocketManager? _socketManager;
  bool _mounted = true;
  String? _driverId;
  String? _driverName;

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
        final driverData = Map<String, dynamic>.from(json.decode(storedDriverData));
        _driverName = driverData['name'] ?? driverData['driverName'] ?? 'Driver';
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

        // Get chat history
        _getChatHistory();
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

  void _setupSocketListeners() {
    if (_socketManager == null) return;

    // Connection status
    _socketManager!.onConnectionStatusChange = (isConnected) {
      if (_mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    };

    // Chat messages
    _socketManager!.onChatMessage = (data) {
      print("💬 New chat message received: ${data.keys}");
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
      print("✅ Message sent successfully: $data");
    };
  }

  void _joinChatRoom() {
    if (_socketManager == null) return;
    
    final orderId = widget.rideData?['orderId']?.toString();
    if (orderId != null) {
      print('💬 Joining chat room for order: $orderId');
      _socketManager!.joinChatRoom(
        orderId,
        userRole: 'driver',
      );
    }
  }

  void _getChatHistory() {
    if (_socketManager == null) return;
    
    final orderId = widget.rideData?['orderId']?.toString();
    if (orderId != null) {
      print('💬 Getting chat history for order: $orderId');
      _socketManager!.getChatHistory(orderId);
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    if (!_mounted) return;
    
    try {
      print('💬 Processing incoming message data: ${data.keys}');
      
      // Extract the nested message object
      final Map<String, dynamic>? messageData = data['message'];
      
      if (messageData == null) {
        print('⚠️ No message data found in socket response');
        // Try direct fields
        final messageText = data['text']?.toString() ?? data['message']?.toString();
        if (messageText != null && messageText.isNotEmpty) {
          _addMessage(
            text: messageText,
            senderId: data['senderId']?.toString() ?? 'unknown',
            senderRole: data['senderRole']?.toString() ?? data['senderType']?.toString() ?? 'rider',
            timestamp: data['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
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
        timestamp: messageData['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
        messageId: messageData['_id']?.toString() ?? UniqueKey().toString(),
        senderName: senderName,
      );
      
    } catch (e) {
      print("❌ Error handling incoming message: $e");
      print("❌ Full data received: $data");
      
      // Fallback: try to extract message text directly
      try {
        final String? messageText = data['message']?.toString() ?? data['text']?.toString();
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
}) {
  // Create proper boolean conditions
  final bool isRoleDriver = senderRole.toLowerCase() == 'driver';
  final bool isSameDriverId = _driverId != null && senderId == _driverId;
  final bool isSameDriverName = senderName != null && 
                                _driverName != null && 
                                senderName == _driverName;
  
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
  );

  print('✅ Created chat message: "$text" from ${senderName ?? senderRole} (isSender: $isSender)');
  
  setState(() {
    _messages.add(message);
  });

  _scrollToBottom();
}

  // void _addMessage({
  //   required String text,
  //   required String senderId,
  //   required String senderRole,
  //   required String timestamp,
  //   required String messageId,
  //   String? senderName,
  // }) {
  //   final isSender = senderRole.toLowerCase() == 'driver' || 
  //                    senderId == _driverId || 
  //                    (senderName != null && senderName == _driverName);
    
  //   final message = ChatMessage(
  //     id: messageId,
  //     text: text,
  //     senderId: senderId,
  //     senderRole: senderRole,
  //     receiverId: isSender ? widget.rideData?['riderId']?.toString() ?? '' : _driverId ?? '',
  //     receiverRole: isSender ? 'rider' : 'driver',
  //     timestamp: timestamp,
  //     isRead: false,
  //     isSender: isSender,
  //     senderName: senderName,
  //   );

  //   print('✅ Created chat message: "$text" from ${senderName ?? senderRole} (isSender: $isSender)');
    
  //   setState(() {
  //     _messages.add(message);
  //   });

  //   _scrollToBottom();
  // }

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
    final text = _messageController.text.trim();
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
      // Add message to UI immediately
      _addMessage(
        text: text,
        senderId: _driverId!,
        senderRole: 'driver',
        timestamp: DateTime.now().toIso8601String(),
        messageId: UniqueKey().toString(),
        senderName: _driverName,
      );

      // Send via socket
      final success = _socketManager!.sendChatMessage(
        orderId,
        text,
        receiverId: riderId,
        chatId: _chatId,
      );

      if (!success) {
        if (_mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send message'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      _messageController.clear();
      _scrollToBottom();
    } else {
      print("❌ Missing required data. OrderId: $orderId, RiderId: $riderId, DriverId: $_driverId");
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot send message: Missing ride information'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                    _isConnected ? 'Online' : 'Offline',
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
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.04,
        vertical: w * 0.02,
      ),
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
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                  Icon(Icons.done_all, size: w * 0.035, color: Colors.blue),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  minLines: 1,
                  maxLines: 4,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: w * 0.02),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: w * 0.12,
                height: w * 0.12,
                decoration: const BoxDecoration(
                  color: Color(0xFF007AFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.white, size: w * 0.05),
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
  });
}

// Add this import at the top if not already there
// import 'dart:convert';