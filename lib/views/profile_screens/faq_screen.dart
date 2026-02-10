// import 'package:nzcu_driver/views/profile_related.dart/faqs_details_screen.dart';
// import 'package:flutter/material.dart';

// class FaqScreen extends StatelessWidget {
//   const FaqScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> faqs = [
//       "How do I update my profile details?",
//       "What happens if I cancel a ride?",
//       "When will I receive online payments?",
//       "What if the user doesn’t pay?",
//       "The user is not at pickup point, what should I do?",
//       "How do I accept or reject a ride?",
//       "Why was my Aadhaar/ID rejected?",
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "FAsssssssssQs",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ListView.separated(
//             itemCount: faqs.length,
//             separatorBuilder: (_, __) => const Divider(
//               height: 1,
//               thickness: 0.8,
//             ),
//             itemBuilder: (context, index) {
//               return InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () {


// print("helloooe");
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => FaqsDetailsScreen() ));
//                   // TODO: Navigate to FAQ detail screen
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           faqs[index],
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       const Icon(
//                         Icons.chevron_right,
//                         color: Colors.grey,
//                         size: 22,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
