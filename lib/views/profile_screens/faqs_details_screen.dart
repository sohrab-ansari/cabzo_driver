


// import 'package:flutter/material.dart';

// class FaqsDetailsScreen extends StatefulWidget {
//   const FaqsDetailsScreen({super.key});

//   @override
//   State<FaqsDetailsScreen> createState() => _FaqsDetailsScreenState();
// }

// class _FaqsDetailsScreenState extends State<FaqsDetailsScreen> {
//   bool? isHelpful; // null = none, true = Yes, false = No

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: const Icon(Icons.arrow_back, color: Colors.black),
//         title: const Text(
//           "Back",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Question
//             const Text(
//               "HOW DO I UPDATE MY PROFILE DETAILS?",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 8),

//             /// Answer
//             const Text(
//               "Go to Profile > Edit Profile, update your name, photo, or contact, and save changes.",
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey,
//                 height: 1.5,
//               ),
//             ),

//             const SizedBox(height: 32),

//             /// Helpful Text
//             const Text(
//               "WAS THIS INFORMATION USEFUL ?",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// Yes / No Row
//             Row(
//               children: [
//                 /// YES
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         isHelpful = true;
//                       });
//                     },
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           isHelpful == true
//                               ? "assets/images/Thumb_Like_enable.png"
//                               : "assets/images/Thumb__Like.png",
//                           height: 28,
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "Yes",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color:
//                                 isHelpful == true ? Colors.blue : Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 /// Divider
//                 Container(
//                   height: 40,
//                   width: 1,
//                   color: Colors.grey.shade300,
//                 ),

//                 /// NO
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         isHelpful = false;
//                       });
//                     },
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           isHelpful == false
//                               ? "assets/images/Thumb_Dislike_enable.png"
//                               : "assets/images/Thumb_Dislike.png",
//                           height: 28,
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "No",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color:
//                                 isHelpful == false ? Colors.red : Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// // import 'package:flutter/material.dart';

// // class FaqsDetailsScreen extends StatefulWidget {
// //   const FaqsDetailsScreen({super.key});

// //   @override
// //   State<FaqsDetailsScreen> createState() => _FaqsDetailsScreenState();
// // }

// // class _FaqsDetailsScreenState extends State<FaqsDetailsScreen> {
// //   bool? isHelpful; // null = none, true = Yes, false = No

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         leading: const Icon(Icons.arrow_back, color: Colors.black),
// //         title: const Text(
// //           "Back",
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontSize: 16,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             /// Question
// //             const Text(
// //               "HOW DO I UPDATE MY PROFILE DETAILS?",
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.black,
// //               ),
// //             ),
// //             const SizedBox(height: 8),

// //             /// Answer
// //             const Text(
// //               "Go to Profile > Edit Profile, update your name, photo, or contact, and save changes.",
// //               style: TextStyle(
// //                 fontSize: 13,
// //                 color: Colors.grey,
// //                 height: 1.5,
// //               ),
// //             ),

// //             const SizedBox(height: 32),

// //             /// Helpful Text
// //             const Text(
// //               "WAS THIS INFORMATION USEFUL ?",
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.black,
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             /// Yes / No Row
// //             Row(
// //               children: [
// //                 /// YES
// //                 Expanded(
// //                   child: InkWell(
// //                     onTap: () {
// //                       setState(() {
// //                         isHelpful = true;
// //                       });
// //                     },
// //                     child: Column(
// //                       children: [
// //                         Image.asset(
// //                           isHelpful == true
// //                               ? "assets/images/Thumb_Like_enable.png"
// //                               : "assets/images/Thumb__Like.png",
// //                           height: 28,
// //                         ),
// //                         const SizedBox(height: 6),
// //                         Text(
// //                           "Yes",
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color:
// //                                 isHelpful == true ? Colors.blue : Colors.grey,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 /// Divider
// //                 Container(
// //                   height: 40,
// //                   width: 1,
// //                   color: Colors.grey.shade300,
// //                 ),

// //                 /// NO
// //                 Expanded(
// //                   child: InkWell(
// //                     onTap: () {
// //                       setState(() {
// //                         isHelpful = false;
// //                       });
// //                     },
// //                     child: Column(
// //                       children: [
// //                         Image.asset(
// //                           isHelpful == false
// //                               ? "assets/images/Thumb_Dislike_enable.png"
// //                               : "assets/images/Thumb_Dislike.png",
// //                           height: 28,
// //                         ),
// //                         const SizedBox(height: 6),
// //                         Text(
// //                           "No",
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color:
// //                                 isHelpful == false ? Colors.red : Colors.grey,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';

// class FaqsDetailsScreen extends StatefulWidget {
//   final String? question;
//   final String? answer;
//   final String? categoryName;

//   const FaqsDetailsScreen({
//     super.key,
//     this.question,
//     this.answer,
//     this.categoryName,
//   });

//   @override
//   State<FaqsDetailsScreen> createState() => _FaqsDetailsScreenState();
// }

// class _FaqsDetailsScreenState extends State<FaqsDetailsScreen> {
//   bool? isHelpful; // null = none, true = Yes, false = No

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: GestureDetector(
//           onTap: () {
//             CustomNavigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//         ),
//         title: Text(
//           widget.categoryName ?? "Back",
//           style: const TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Question
//             Text(
//               widget.question?.toUpperCase() ?? 
//                   "HOW DO I UPDATE MY PROFILE DETAILS?",
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 8),

//             /// Answer
//             Text(
//               widget.answer ?? 
//                   "Go to Profile > Edit Profile, update your name, photo, or contact, and save changes.",
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey,
//                 height: 1.5,
//               ),
//             ),

//             const SizedBox(height: 32),

//             /// Helpful Text
//             const Text(
//               "WAS THIS INFORMATION USEFUL ?",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// Yes / No Row
//             Row(
//               children: [
//                 /// YES
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         isHelpful = true;
//                       });
                      
//                       // Show feedback message
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Thank you for your feedback!"),
//                           duration: Duration(seconds: 2),
//                           backgroundColor: Colors.blue,
//                         ),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           isHelpful == true
//                               ? "assets/images/Thumb_Like_enable.png"
//                               : "assets/images/Thumb__Like.png",
//                           height: 28,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(
//                               Icons.thumb_up,
//                               color: isHelpful == true 
//                                   ? Colors.blue 
//                                   : Colors.grey,
//                               size: 28,
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "Yes",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isHelpful == true 
//                                 ? Colors.blue 
//                                 : Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 /// Divider
//                 Container(
//                   height: 40,
//                   width: 1,
//                   color: Colors.grey.shade300,
//                 ),

//                 /// NO
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         isHelpful = false;
//                       });
                      
//                       // Show feedback message
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Thank you for your feedback!"),
//                           duration: Duration(seconds: 2),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           isHelpful == false
//                               ? "assets/images/Thumb_Dislike_enable.png"
//                               : "assets/images/Thumb_Dislike.png",
//                           height: 28,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(
//                               Icons.thumb_down,
//                               color: isHelpful == false 
//                                   ? Colors.red 
//                                   : Colors.grey,
//                               size: 28,
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "No",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isHelpful == false 
//                                 ? Colors.red 
//                                 : Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';

class FaqsDetailsScreen extends StatefulWidget {
  final String? question;
  final String? answer;
  final String? categoryName;

  const FaqsDetailsScreen({
    super.key,
    this.question,
    this.answer,
    this.categoryName,
  });

  @override
  State<FaqsDetailsScreen> createState() => _FaqsDetailsScreenState();
}

class _FaqsDetailsScreenState extends State<FaqsDetailsScreen> {
  bool? isHelpful; // null = none, true = Yes, false = No

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            CustomNavigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.categoryName ?? "Back",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Question
            Text(
              widget.question?.toUpperCase() ?? 
                  "HOW DO I UPDATE MY PROFILE DETAILS?",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            /// Answer
            Text(
              widget.answer ?? 
                  "Go to Profile > Edit Profile, update your name, photo, or contact, and save changes.",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            /// Helpful Text
            const Text(
              "WAS THIS INFORMATION USEFUL ?",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            /// Yes / No Row
            Row(
              children: [
                /// YES
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isHelpful = true;
                      });
                      
                      // Show feedback message
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Thank you for your feedback!"),
                      //     duration: Duration(seconds: 2),
                      //     backgroundColor: Colors.blue,
                      //   ),
                      // );
                               Fluttertoast.showToast(
  msg: "Thank you for your feedback!",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP, // 👈 Top position
  backgroundColor: Colors.green,
  textColor: Colors.white,
  fontSize: 16.0,
);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          isHelpful == true
                              ? "assets/images/Thumb_Like_enable.png"
                              : "assets/images/Thumb__Like.png",
                          height: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.thumb_up,
                              color: isHelpful == true 
                                  ? Colors.blue 
                                  : Colors.grey,
                              size: 28,
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Yes",
                          style: TextStyle(
                            fontSize: 14,
                            color: isHelpful == true 
                                ? Colors.blue 
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Divider
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade300,
                ),

                /// NO
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isHelpful = false;
                      });
                      
                      // // Show feedback message
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Thank you for your feedback!"),
                      //     duration: Duration(seconds: 2),
                      //     backgroundColor: Colors.red,
                      //   ),
                      // );

                                                    Fluttertoast.showToast(
  msg: "Thank you for your feedback!",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP, // 👈 Top position
  backgroundColor: Colors.green,
  textColor: Colors.white,
  fontSize: 16.0,
);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          isHelpful == false
                              ? "assets/images/Thumb_Dislike_enable.png"
                              : "assets/images/Thumb_Dislike.png",
                          height: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.thumb_down,
                              color: isHelpful == false 
                                  ? Colors.red 
                                  : Colors.grey,
                              size: 28,
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "No",
                          style: TextStyle(
                            fontSize: 14,
                            color: isHelpful == false 
                                ? Colors.red 
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}