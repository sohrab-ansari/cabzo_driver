// // // import 'package:nzcu_driver/services/baseurl/api_path.dart';
// // // import 'package:nzcu_driver/controllers/profile_controllers/review_and_rating_controller.dart';
// // // import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// // // import 'package:nzcu_driver/utilities/colors/colors.dart';
// // // import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// // // import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';

// // // class Review extends StatefulWidget {
// // //   const Review({super.key});

// // //   @override
// // //   State<Review> createState() => _ReviewState();
// // // }

// // // class _ReviewState extends State<Review> {
// // //   String imagePath = "";

// // //   final ReviewAndRatingController reviewAndRatingController =
// // //       Get.find<ReviewAndRatingController>();

// // //   @override
// // //   void initState() {
// // //     reviewAndRatingController.ratings_method();
// // //     super.initState();
// // //   }

// // //   // Helper method to get rating text
// // //   String getRatingText(int? rating) {
// // //     if (rating == null) return "";
// // //     if (rating >= 4) return "Excellent";
// // //     if (rating >= 3) return "Good";
// // //     if (rating >= 2) return "Average";
// // //     if (rating >= 1) return "Below Average";
// // //     return "Poor";
// // //   }

// // //   // Helper method to get rating color
// // //   Color getRatingColor(int? rating) {
// // //     if (rating == null) return AppColors.mediumGray;
// // //     if (rating >= 4) return AppColors.green;
// // //     if (rating >= 3) return Colors.blue;
// // //     if (rating >= 2) return AppColors.yellow;
// // //     if (rating >= 1) return Colors.orange;
// // //     return Colors.red;
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double w = MediaQuery.of(context).size.width;

// // //     return Scaffold(
// // //       backgroundColor: AppColors.white,
// // //       appBar: AppBar(
// // //         scrolledUnderElevation: 0,
// // //         backgroundColor: AppColors.white,
// // //         automaticallyImplyLeading: false,
// // //         titleSpacing: w * .035,
// // //         title: Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //           children: [
// // //             Row(
// // //               children: [
// // //                 GestureDetector(
// // //                   onTap: () {
// // //                     CustomNavigator.pop(context);
// // //                   },
// // //                   child: Icon(
// // //                     Icons.arrow_back,
// // //                     size: w * .06,
// // //                     color: AppColors.black,
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: w * .02),
// // //                 AppFonts.textPoppins(
// // //                   context,
// // //                   "Review & Rating",
// // //                   w * .042,
// // //                   FontWeight.w500,
// // //                   AppColors.black,
// // //                   TextAlign.start,
// // //                   TextOverflow.visible,
// // //                 ),
// // //               ],
// // //             ),
// // //             // Obx(() => AppButtons.outlined(
// // //             //   context: context,
// // //             //   width: w * .15,
// // //             //   height: w * .06,
// // //             //   radius: 30,
// // //             //   fontSize: w * .025,
// // //             //   padding: EdgeInsets.zero,
// // //             //   text: "Skip",
// // //             //   onClicked: () {
// // //             //     // CustomNavigator.push(
// // //             //     //   context,
// // //             //     //   EnterOtpScreen(),
// // //             //     //   transition:
// // //             //     //       TransitionType.slideLeft,
// // //             //     // );
// // //             //   },
// // //             //   textColor: AppColors.primaryblue,
// // //             // )),
// // //           ],
// // //         ),
// // //       ),
// // //       body: Obx(() {
// // //         // Show loading state
// // //         if (reviewAndRatingController.isLoading.value) {
// // //           return Center(
// // //             child: CircularProgressIndicator(color: AppColors.primaryblue),
// // //           );
// // //         }

// // //         // Get reviews data
// // //         final reviews =
// // //             reviewAndRatingController.reviewRatingResponse.value?.data;
// // //         final averageRating = reviewAndRatingController.averageRating;
// // //         final totalReviews = reviewAndRatingController.totalReviews;

// // //         return Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .03),
// // //           child: Column(
// // //             children: [
// // //               // // Rating Summary Card
// // //               // Container(
// // //               //   decoration: BoxDecoration(
// // //               //     borderRadius: BorderRadius.circular(5),
// // //               //     boxShadow: [
// // //               //       BoxShadow(
// // //               //         blurRadius: 1,
// // //               //         spreadRadius: 0.5,
// // //               //         color: Colors.grey.shade200,
// // //               //       ),
// // //               //     ],
// // //               //     color: AppColors.primaryblue.withOpacity(0.1),
// // //               //   ),
// // //               //   child: Padding(
// // //               //     padding: EdgeInsets.symmetric(
// // //               //       horizontal: w * .04,
// // //               //       vertical: w * .04,
// // //               //     ),
// // //               //     child: Column(
// // //               //       children: [
// // //               //         Row(
// // //               //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               //           children: [
// // //               //             Column(
// // //               //               children: [
// // //               //                 CircleAvatar(
// // //               //                   radius: w * .05,
// // //               //                   backgroundColor: Colors.grey.shade300,
// // //               //                   backgroundImage:
// // //               //                       imagePath.isNotEmpty
// // //               //                       ? AssetImage(imagePath)
// // //               //                       : null,
// // //               //                   child: imagePath.isEmpty
// // //               //                       ? Icon(
// // //               //                           Icons.person,
// // //               //                           size: w * .08,
// // //               //                           color: Colors.grey.shade700,
// // //               //                         )
// // //               //                       : null,
// // //               //                 ),
// // //               //                 SizedBox(height: w * .01),
// // //               //                 AppFonts.textPoppins(
// // //               //                   context,
// // //               //                   "Nirddaj Ray", // You can replace this with actual driver name from API if available
// // //               //                   w * .04,
// // //               //                   FontWeight.w500,
// // //               //                   AppColors.black,
// // //               //                   TextAlign.start,
// // //               //                   TextOverflow.visible,
// // //               //                 ),
// // //               //               ],
// // //               //             ),
// // //               //             Column(
// // //               //               crossAxisAlignment: CrossAxisAlignment.end,
// // //               //               children: [
// // //               //                 Row(
// // //               //                   mainAxisAlignment: MainAxisAlignment.end,
// // //               //                   children: [
// // //               //                     AppFonts.textPoppins(
// // //               //                       context,
// // //               //                       averageRating.toStringAsFixed(1),
// // //               //                       w * .06,
// // //               //                       FontWeight.w500,
// // //               //                       AppColors.black,
// // //               //                       TextAlign.start,
// // //               //                       TextOverflow.visible,
// // //               //                     ),
// // //               //                     Icon(
// // //               //                       Icons.star,
// // //               //                       color: AppColors.yellow,
// // //               //                       size: w * .08,
// // //               //                     ),
// // //               //                   ],
// // //               //                 ),
// // //               //                 AppFonts.textPoppins(
// // //               //                   context,
// // //               //                   totalReviews > 0
// // //               //                       ? "Rated by $totalReviews customer${totalReviews > 1 ? 's' : ''}"
// // //               //                       : "No ratings yet",
// // //               //                   w * .022,
// // //               //                   FontWeight.w500,
// // //               //                   AppColors.black,
// // //               //                   TextAlign.start,
// // //               //                   TextOverflow.visible,
// // //               //                 ),
// // //               //               ],
// // //               //             ),
// // //               //           ],
// // //               //         ),
// // //               //       ],
// // //               //     ),
// // //               //   ),
// // //               // ),
// // //               // SizedBox(height: w * .03),

// // //               // Reviews List
// // //               Expanded(
// // //                 child: SingleChildScrollView(
// // //                   child: Column(
// // //                     children: reviews != null && reviews.isNotEmpty
// // //                         ? reviews.map((review) {
// // //                             final userName = review.user?.name ?? "Customer";
// // //                             final userRating = review.rating ?? 0;
// // //                             final experienceDescription =
// // //                                 review.experienceDescription ??
// // //                                 "No comment provided";

// // //                             return Padding(
// // //                               padding: EdgeInsets.symmetric(vertical: w * .02),
// // //                               child: Column(
// // //                                 children: [
// // //                                   Container(
// // //                                     decoration: BoxDecoration(
// // //                                       color: AppColors.lightGray.withOpacity(
// // //                                         0.2,
// // //                                       ),
// // //                                       borderRadius: BorderRadius.circular(
// // //                                         w * .02,
// // //                                       ),
// // //                                     ),
// // //                                     child: Padding(
// // //                                       padding: EdgeInsets.symmetric(
// // //                                         horizontal: w * .03,
// // //                                         vertical: w * .02,
// // //                                       ),
// // //                                       child: Row(
// // //                                         mainAxisAlignment:
// // //                                             MainAxisAlignment.spaceBetween,
// // //                                         children: [
// // //                                           Column(
// // //                                             crossAxisAlignment:
// // //                                                 CrossAxisAlignment.start,
// // //                                             children: [
// // //                                               CircleAvatar(
// // //                                                 radius: w * .05,
// // //                                                 backgroundColor:
// // //                                                     Colors.grey.shade300,
// // //                                                 backgroundImage:
// // //                                                     imagePath.isNotEmpty
// // //                                                     // ? AssetImage(imagePath)
// // //                                                     ? AssetImage(
// // //                                                         ApiPath.imagebaseUrl +
// // //                                                             imagePath,
// // //                                                       )
// // //                                                     : null,
// // //                                                 child: imagePath.isEmpty
// // //                                                     ? Icon(
// // //                                                         Icons.person,
// // //                                                         size: w * .065,
// // //                                                         color: Colors
// // //                                                             .grey
// // //                                                             .shade700,
// // //                                                       )
// // //                                                     : null,
// // //                                               ),
// // //                                               SizedBox(height: w * .01),
// // //                                               AppFonts.textPoppins(
// // //                                                 context,
// // //                                                 userName,
// // //                                                 w * .03,
// // //                                                 FontWeight.w500,
// // //                                                 AppColors.black,
// // //                                                 TextAlign.start,
// // //                                                 TextOverflow.visible,
// // //                                               ),
// // //                                               SizedBox(height: w * .01),
// // //                                               AppFonts.textPoppins(
// // //                                                 context,
// // //                                                 experienceDescription,
// // //                                                 w * .025,
// // //                                                 FontWeight.w500,
// // //                                                 AppColors.mediumGray,
// // //                                                 TextAlign.start,
// // //                                                 TextOverflow.visible,
// // //                                               ),
// // //                                             ],
// // //                                           ),
// // //                                           Column(
// // //                                             crossAxisAlignment:
// // //                                                 CrossAxisAlignment.end,
// // //                                             children: [
// // //                                               Row(
// // //                                                 mainAxisAlignment:
// // //                                                     MainAxisAlignment.center,
// // //                                                 children: List.generate(5, (
// // //                                                   index,
// // //                                                 ) {
// // //                                                   return Icon(
// // //                                                     Icons.star_rate_rounded,
// // //                                                     color: index < userRating
// // //                                                         ? Colors.amber
// // //                                                         : Colors.grey.shade300,
// // //                                                     size: w * .07,
// // //                                                   );
// // //                                                 }),
// // //                                               ),
// // //                                               AppFonts.textPoppins(
// // //                                                 context,
// // //                                                 getRatingText(userRating),
// // //                                                 w * .035,
// // //                                                 FontWeight.w500,
// // //                                                 getRatingColor(userRating),
// // //                                                 TextAlign.start,
// // //                                                 TextOverflow.visible,
// // //                                               ),
// // //                                             ],
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             );
// // //                           }).toList()
// // //                         : [
// // //                             // Show empty state if no reviews
// // //                             Padding(
// // //                               padding: EdgeInsets.symmetric(vertical: w * .1),
// // //                               child: Column(
// // //                                 children: [
// // //                                   Icon(
// // //                                     Icons.reviews_outlined,
// // //                                     size: w * .15,
// // //                                     color: AppColors.mediumGray,
// // //                                   ),
// // //                                   SizedBox(height: w * .03),
// // //                                   AppFonts.textPoppins(
// // //                                     context,
// // //                                     "No Reviews Yet",
// // //                                     w * .045,
// // //                                     FontWeight.w500,
// // //                                     AppColors.black,
// // //                                     TextAlign.center,
// // //                                     TextOverflow.visible,
// // //                                   ),
// // //                                   SizedBox(height: w * .02),
// // //                                   AppFonts.textPoppins(
// // //                                     context,
// // //                                     "You haven't received any reviews yet.",
// // //                                     w * .032,
// // //                                     FontWeight.w400,
// // //                                     AppColors.mediumGray,
// // //                                     TextAlign.center,
// // //                                     TextOverflow.visible,
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         );
// // //       }),
// // //     );
// // //   }
// // // }

// // import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
// // import 'package:nzcu_driver/services/baseurl/api_path.dart';
// // import 'package:nzcu_driver/controllers/profile_controllers/review_and_rating_controller.dart';
// // import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// // import 'package:nzcu_driver/utilities/colors/colors.dart';
// // import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// // import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class Review extends StatefulWidget {
// //   const Review({super.key});

// //   @override
// //   State<Review> createState() => _ReviewState();
// // }

// // class _ReviewState extends State<Review> {
// //   String imagePath = "";

// //   final ReviewAndRatingController reviewAndRatingController =
// //       Get.find<ReviewAndRatingController>();

// //         final DriveridController driveridController = Get.put(DriveridController());


// //   @override
// //   void initState() {
// //     reviewAndRatingController.ratings_method();

// //            driveridController.driverid_mdethod();

// //     super.initState();
// //   }

// //   // Helper method to get rating text
// //   String getRatingText(int? rating) {
// //     if (rating == null) return "";
// //     if (rating >= 4) return "Excellent";
// //     if (rating >= 3) return "Good";
// //     if (rating >= 2) return "Average";
// //     if (rating >= 1) return "Below Average";
// //     return "Poor";
// //   }

// //   // Helper method to get rating color
// //   Color getRatingColor(int? rating) {
// //     if (rating == null) return AppColors.mediumGray;
// //     if (rating >= 4) return AppColors.green;
// //     if (rating >= 3) return Colors.blue;
// //     if (rating >= 2) return AppColors.yellow;
// //     if (rating >= 1) return Colors.orange;
// //     return Colors.red;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       appBar: AppBar(
// //         scrolledUnderElevation: 0,
// //         backgroundColor: AppColors.white,
// //         automaticallyImplyLeading: false,
// //         titleSpacing: w * .035,
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Row(
// //               children: [
// //                 GestureDetector(
// //                   onTap: () {
// //                     CustomNavigator.pop(context);
// //                   },
// //                   child: Icon(
// //                     Icons.arrow_back,
// //                     size: w * .06,
// //                     color: AppColors.black,
// //                   ),
// //                 ),
// //                 SizedBox(width: w * .02),
// //                 AppFonts.textPoppins(
// //                   context,
// //                   "Review & Rating",
// //                   w * .042,
// //                   FontWeight.w500,
// //                   AppColors.black,
// //                   TextAlign.start,
// //                   TextOverflow.visible,
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Obx(() {
// //         // Show loading state
// //         if (reviewAndRatingController.isLoading.value) {
// //           return Center(
// //             child: CircularProgressIndicator(color: AppColors.primaryblue),
// //           );
// //         }

// //         // Get reviews data
// //         final reviews =
// //             reviewAndRatingController.reviewRatingResponse.value?.data;
// //         final averageRating = reviewAndRatingController.averageRating;
// //         final totalReviews = reviewAndRatingController.totalReviews;

// //         return Padding(
// //           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .03),
// //           child: Column(
// //             children: [
// //               Container(
// //                 margin: EdgeInsets.only(bottom: w * .04),
// //                 padding: EdgeInsets.symmetric(vertical: w * .04),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue.shade50,
// //                   borderRadius: BorderRadius.circular(w * .03),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     // Left side - Profile info
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         // 👤 Circular Profile Image
// //                         CircleAvatar(
// //                           radius: w * .08, // adjust size
// //                           backgroundColor: Colors.grey.shade300,
// //                           backgroundImage: NetworkImage(
// //                             "https://randomuser.me/api/portraits/men/1.jpg", // replace with your image
// //                           ),
// //                           // If you want asset image use:
// //                           // backgroundImage: AssetImage("assets/images/profile.png"),
// //                         ),

// //                         SizedBox(height: w * .03),

// //                         // 👤 Name Text
// //                         Text(
// //                           "Amaan Shaikh",
// //                           style: TextStyle(
// //                             fontSize: w * .05,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black,
// //                           ),
// //                         ),

// //                         SizedBox(height: w * .005),
// //                       ],
// //                     ),

                   
// //                     Column(
// //                       children: [
// //                         Container(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: w * .04,
// //                             vertical: w * .02,
// //                           ),
// //                           // decoration: BoxDecoration(
// //                           //   color: Colors.green,
// //                           //   borderRadius: BorderRadius.circular(w * .02),
// //                           // ),
// //                           child: Row(
// //                             children: [
// //                               Text(
// //                                 "5.0",
// //                                 style: TextStyle(
// //                                   fontSize: w * .045,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Colors.white,
// //                                 ),
// //                               ),

// //                               SizedBox(width: w * .01),
// //                               Icon(
// //                                 Icons.star,
// //                                 color: Colors.white,
// //                                 size: w * .05,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         Text(
// //                           "Rated By Happy Customers",
// //                           style: TextStyle(
// //                             fontSize: w * .03,
// //                             color: Colors.grey.shade600,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Reviews List
// //               Expanded(
// //                 child: SingleChildScrollView(
// //                   child: Column(
// //                     children: reviews != null && reviews.isNotEmpty
// //                         ? reviews.map((review) {
// //                             final userName = review.user?.name ?? "Customer";
// //                             final userRating = review.rating ?? 0;
// //                             final experienceDescription =
// //                                 review.experienceDescription ??
// //                                 "No comment provided";

// //                             return Padding(
// //                               padding: EdgeInsets.symmetric(vertical: w * .02),
// //                               child: Column(
// //                                 children: [
// //                                   Container(
// //                                     decoration: BoxDecoration(
// //                                       color: AppColors.lightGray.withOpacity(
// //                                         0.2,
// //                                       ),
// //                                       borderRadius: BorderRadius.circular(
// //                                         w * .02,
// //                                       ),
// //                                     ),
// //                                     child: Padding(
// //                                       padding: EdgeInsets.symmetric(
// //                                         horizontal: w * .03,
// //                                         vertical: w * .02,
// //                                       ),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.spaceBetween,
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.start,
// //                                         children: [
// //                                           // Left column - User info (Flexible to take available space)
// //                                           Flexible(
// //                                             flex: 2,
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                                   CrossAxisAlignment.start,
// //                                               children: [
// //                                                 CircleAvatar(
// //                                                   radius: w * .05,
// //                                                   backgroundColor:
// //                                                       Colors.grey.shade300,
// //                                                   backgroundImage:
// //                                                       imagePath.isNotEmpty
// //                                                       ? NetworkImage(
// //                                                               ApiPath.imagebaseUrl +
// //                                                                   imagePath,
// //                                                             )
// //                                                             as ImageProvider
// //                                                       : null,
// //                                                   child: imagePath.isEmpty
// //                                                       ? Icon(
// //                                                           Icons.person,
// //                                                           size: w * .065,
// //                                                           color: Colors
// //                                                               .grey
// //                                                               .shade700,
// //                                                         )
// //                                                       : null,
// //                                                 ),
// //                                                 SizedBox(height: w * .01),
// //                                                 AppFonts.textPoppins(
// //                                                   context,
// //                                                   userName,
// //                                                   w * .03,
// //                                                   FontWeight.w500,
// //                                                   AppColors.black,
// //                                                   TextAlign.start,
// //                                                   TextOverflow.ellipsis,
// //                                                 ),
// //                                                 SizedBox(height: w * .005),
// //                                                 AppFonts.textPoppins(
// //                                                   context,
// //                                                   experienceDescription,
// //                                                   w * .025,
// //                                                   FontWeight.w500,
// //                                                   AppColors.mediumGray,
// //                                                   TextAlign.start,
// //                                                   TextOverflow.ellipsis,
// //                                                   maxLines: 2,
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),

// //                                           // Right column - Rating (Fixed width)
// //                                           Container(
// //                                             width: w * .25,
// //                                             child: Column(
// //                                               crossAxisAlignment:
// //                                                   CrossAxisAlignment.end,
// //                                               mainAxisSize: MainAxisSize.min,
// //                                               children: [
// //                                                 Row(
// //                                                   mainAxisAlignment:
// //                                                       MainAxisAlignment.end,
// //                                                   mainAxisSize:
// //                                                       MainAxisSize.min,
// //                                                   children: List.generate(5, (
// //                                                     index,
// //                                                   ) {
// //                                                     return Icon(
// //                                                       Icons.star_rate_rounded,
// //                                                       color: index < userRating
// //                                                           ? Colors.amber
// //                                                           : Colors
// //                                                                 .grey
// //                                                                 .shade300,
// //                                                       size: w * .05,
// //                                                     );
// //                                                   }),
// //                                                 ),
// //                                                 SizedBox(height: w * .005),
// //                                                 AppFonts.textPoppins(
// //                                                   context,
// //                                                   getRatingText(userRating),
// //                                                   w * .03,
// //                                                   FontWeight.w500,
// //                                                   getRatingColor(userRating),
// //                                                   TextAlign.end,
// //                                                   TextOverflow.ellipsis,
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             );
// //                           }).toList()
// //                         : [
// //                             // Show empty state if no reviews
// //                             Padding(
// //                               padding: EdgeInsets.symmetric(vertical: w * .1),
// //                               child: Column(
// //                                 children: [
// //                                   Icon(
// //                                     Icons.reviews_outlined,
// //                                     size: w * .15,
// //                                     color: AppColors.mediumGray,
// //                                   ),
// //                                   SizedBox(height: w * .03),
// //                                   AppFonts.textPoppins(
// //                                     context,
// //                                     "No Reviews Yet",
// //                                     w * .045,
// //                                     FontWeight.w500,
// //                                     AppColors.black,
// //                                     TextAlign.center,
// //                                     TextOverflow.visible,
// //                                   ),
// //                                   SizedBox(height: w * .02),
// //                                   AppFonts.textPoppins(
// //                                     context,
// //                                     "You haven't received any reviews yet.",
// //                                     w * .032,
// //                                     FontWeight.w400,
// //                                     AppColors.mediumGray,
// //                                     TextAlign.center,
// //                                     TextOverflow.visible,
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       }),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
// import 'package:nzcu_driver/services/baseurl/api_path.dart';
// import 'package:nzcu_driver/controllers/profile_controllers/review_and_rating_controller.dart';
// import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors/colors.dart';
// import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';

// class Review extends StatefulWidget {
//   const Review({super.key});

//   @override
//   State<Review> createState() => _ReviewState();
// }

// class _ReviewState extends State<Review> {
//   String driverName = "";
//   String profileImage = "";

//   final ReviewAndRatingController reviewAndRatingController =
//       Get.find<ReviewAndRatingController>();

//   final DriveridController driveridController = Get.put(DriveridController());

//   @override
//   void initState() {
//     reviewAndRatingController.ratings_method();
//     driveridController.driverid_mdethod();
//     sharedpreferences();
//     super.initState();
//   }

//   Future<void> sharedpreferences() async {
//     final prefs = await SharedPreferences.getInstance();

//     setState(() {
//       driverName = prefs.getString("driver_name") ?? "";
//       profileImage = prefs.getString("driver_image") ?? "";
//     });
//     AppLogger.d("Driver Name from SharedPreferences: $driverName");
//   }

//   // Helper method to get rating text
//   String getRatingText(int? rating) {
//     if (rating == null) return "";
//     if (rating >= 4) return "Excellent";
//     if (rating >= 3) return "Good";
//     if (rating >= 2) return "Average";
//     if (rating >= 1) return "Below Average";
//     return "Poor";
//   }

//   // Helper method to get rating color
//   Color getRatingColor(int? rating) {
//     if (rating == null) return AppColors.mediumGray;
//     if (rating >= 4) return AppColors.green;
//     if (rating >= 3) return Colors.blue;
//     if (rating >= 2) return AppColors.yellow;
//     if (rating >= 1) return Colors.orange;
//     return Colors.red;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         backgroundColor: AppColors.white,
//         automaticallyImplyLeading: false,
//         titleSpacing: w * .035,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     CustomNavigator.pop(context);
//                   },
//                   child: Icon(
//                     Icons.arrow_back,
//                     size: w * .06,
//                     color: AppColors.black,
//                   ),
//                 ),
//                 SizedBox(width: w * .02),
//                 AppFonts.textPoppins(
//                   context,
//                   "Review & Rating",
//                   w * .042,
//                   FontWeight.w500,
//                   AppColors.black,
//                   TextAlign.start,
//                   TextOverflow.visible,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() {
//         // Show loading state
//         if (reviewAndRatingController.isLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(color: AppColors.primaryblue),
//           );
//         }

//         // Get reviews data
//         final reviews =
//             reviewAndRatingController.reviewRatingResponse.value?.data;
//         final averageRating = reviewAndRatingController.averageRating;
//         final totalReviews = reviewAndRatingController.totalReviews;

//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .03),
//           child: Column(
//             children: [
//               // Top Container with Driver Info and Rating
//               Container(
//                 margin: EdgeInsets.only(bottom: w * .04),
//                 padding: EdgeInsets.symmetric(vertical: w * .04),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(w * .03),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     // Left side - Profile info
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Circular Profile Image
//                         CircleAvatar(
//                           radius: w * .08,
//                           backgroundColor: Colors.grey.shade300,
//                           backgroundImage: profileImage.isNotEmpty
//                               ? NetworkImage(
//                                   ApiPath.imagebaseUrl + profileImage,
//                                 )
//                               : null,
//                           child: profileImage.isEmpty
//                               ? Icon(
//                                   Icons.person,
//                                   size: w * .065,
//                                   color: Colors.grey.shade700,
//                                 )
//                               : null,
//                         ),
//                         SizedBox(height: w * .03),

//                         // Driver Name
//                         Text(
//                           driverName.isNotEmpty ? driverName : "Driver Name",
//                           style: TextStyle(
//                             fontSize: w * .05,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: w * .005),
//                       ],
//                     ),

//                     // Right side - Rating info
//                     Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: w * .04,
//                             vertical: w * .02,
//                           ),
//                           child: Row(
//                             children: [
//                               Text(
//                                 // Format the rating to show 1 decimal place
//                                 (driveridController
//                                             .driveridresponse
//                                             .value
//                                             ?.driver
//                                             ?.rating !=
//                                         null)
//                                     ? driveridController
//                                         .driveridresponse
//                                         .value!
//                                         .driver!
//                                         .rating!
//                                         .toStringAsFixed(1)
//                                     : "0.0",
//                                 style: TextStyle(
//                                   fontSize: w * .045,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black, // Black color for rating number
//                                 ),
//                               ),
//                               SizedBox(width: w * .01),
//                               Icon(
//                                 Icons.star,
//                                 color: Colors.amber, // Original star color (amber/yellow)
//                                 size: w * .05,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           // Show total reviews count if available
//                           (driveridController
//                                       .driveridresponse
//                                       .value
//                                       ?.driver
//                                       ?.totalRating !=
//                                   null)
//                               ? "Rated by ${driveridController.driveridresponse.value!.driver!.totalRating} ${driveridController.driverIdResponse.value!.driver!.totalRating == 1 ? 'Customer' : 'Customers'}"
//                               : "No ratings yet",
//                           style: TextStyle(
//                             fontSize: w * .03,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // Reviews List
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: reviews != null && reviews.isNotEmpty
//                         ? reviews.map((review) {
//                             final userName = review.user?.name ?? "Customer";
//                             final userRating = review.rating ?? 0;
//                             final experienceDescription =
//                                 review.experienceDescription ??
//                                 "No comment provided";

//                             return Padding(
//                               padding: EdgeInsets.symmetric(vertical: w * .02),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: AppColors.lightGray.withOpacity(
//                                         0.2,
//                                       ),
//                                       borderRadius: BorderRadius.circular(
//                                         w * .02,
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: w * .03,
//                                         vertical: w * .02,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // Left column - User info (Flexible to take available space)
//                                           Flexible(
//                                             flex: 2,
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 CircleAvatar(
//                                                   radius: w * .05,
//                                                   backgroundColor:
//                                                       Colors.grey.shade300,
//                                                   backgroundImage:
//                                                       review.user?.image != null &&
//                                                               review.user!.image!.isNotEmpty
//                                                           ? NetworkImage(
//                                                               ApiPath.imagebaseUrl +
//                                                                   review.user!.image!,
//                                                             )
//                                                           : null,
//                                                   child: review.user?.image == null ||
//                                                           review.user!.image!.isEmpty
//                                                       ? Icon(
//                                                           Icons.person,
//                                                           size: w * .065,
//                                                           color: Colors
//                                                               .grey
//                                                               .shade700,
//                                                         )
//                                                       : null,
//                                                 ),
//                                                 SizedBox(height: w * .01),
//                                                 AppFonts.textPoppins(
//                                                   context,
//                                                   userName,
//                                                   w * .03,
//                                                   FontWeight.w500,
//                                                   AppColors.black,
//                                                   TextAlign.start,
//                                                   TextOverflow.ellipsis,
//                                                 ),
//                                                 SizedBox(height: w * .005),
//                                                 AppFonts.textPoppins(
//                                                   context,
//                                                   experienceDescription,
//                                                   w * .025,
//                                                   FontWeight.w500,
//                                                   AppColors.mediumGray,
//                                                   TextAlign.start,
//                                                   TextOverflow.ellipsis,
//                                                   maxLines: 2,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),

//                                           // Right column - Rating (Fixed width)
//                                           Container(
//                                             width: w * .25,
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.end,
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.end,
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   children: List.generate(5, (
//                                                     index,
//                                                   ) {
//                                                     return Icon(
//                                                       Icons.star_rate_rounded,
//                                                       color: index < userRating
//                                                           ? Colors.amber
//                                                           : Colors
//                                                                 .grey
//                                                                 .shade300,
//                                                       size: w * .05,
//                                                     );
//                                                   }),
//                                                 ),
//                                                 SizedBox(height: w * .005),
//                                                 AppFonts.textPoppins(
//                                                   context,
//                                                   getRatingText(userRating),
//                                                   w * .03,
//                                                   FontWeight.w500,
//                                                   getRatingColor(userRating),
//                                                   TextAlign.end,
//                                                   TextOverflow.ellipsis,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList()
//                         : [
//                             // Show empty state if no reviews
//                             Padding(
//                               padding: EdgeInsets.symmetric(vertical: w * .1),
//                               child: Column(
//                                 children: [
//                                   Icon(
//                                     Icons.reviews_outlined,
//                                     size: w * .15,
//                                     color: AppColors.mediumGray,
//                                   ),
//                                   SizedBox(height: w * .03),
//                                   AppFonts.textPoppins(
//                                     context,
//                                     "No Reviews Yet",
//                                     w * .045,
//                                     FontWeight.w500,
//                                     AppColors.black,
//                                     TextAlign.center,
//                                     TextOverflow.visible,
//                                   ),
//                                   SizedBox(height: w * .02),
//                                   AppFonts.textPoppins(
//                                     context,
//                                     "You haven't received any reviews yet.",
//                                     w * .032,
//                                     FontWeight.w400,
//                                     AppColors.mediumGray,
//                                     TextAlign.center,
//                                     TextOverflow.visible,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/controllers/profile_controllers/review_and_rating_controller.dart';
import 'package:nzcu_driver/utilities/widgets/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String driverName = "";
  String profileImage = "";

  final ReviewAndRatingController reviewAndRatingController =
      Get.find<ReviewAndRatingController>();

  final DriveridController driveridController = Get.put(DriveridController());

  @override
  void initState() {
    reviewAndRatingController.ratings_method();
    driveridController.driverid_mdethod();
    sharedpreferences();
    super.initState();
  }

  Future<void> sharedpreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      driverName = prefs.getString("driver_name") ?? "";
      profileImage = prefs.getString("driver_image") ?? "";
    });
    AppLogger.d("Driver Name from SharedPreferences: $driverName");
    AppLogger.d("Driver Image from SharedPreferences: $profileImage");
  }

  // Helper method to get rating text
  String getRatingText(int? rating) {
    if (rating == null) return "";
    if (rating >= 4) return "Excellent";
    if (rating >= 3) return "Good";
    if (rating >= 2) return "Average";
    if (rating >= 1) return "Below Average";
    return "Poor";
  }

  // Helper method to get rating color
  Color getRatingColor(int? rating) {
    if (rating == null) return AppColors.mediumGray;
    if (rating >= 4) return AppColors.green;
    if (rating >= 3) return Colors.blue;
    if (rating >= 2) return AppColors.yellow;
    if (rating >= 1) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        titleSpacing: w * .035,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    CustomNavigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: w * .06,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(width: w * .02),
                AppFonts.textPoppins(
                  context,
                  "Review & Rating",
                  w * .042,
                  FontWeight.w500,
                  AppColors.black,
                  TextAlign.start,
                  TextOverflow.visible,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Obx(() {
        // Show loading state
        if (reviewAndRatingController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryblue),
          );
        }

        // Get reviews data
        final reviews =
            reviewAndRatingController.reviewRatingResponse.value?.data;
        final averageRating = reviewAndRatingController.averageRating;
        final totalReviews = reviewAndRatingController.totalReviews;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .03),
          child: Column(
            children: [
              // Top Container with Driver Info and Rating
              Container(
                margin: EdgeInsets.only(bottom: w * .04),
                padding: EdgeInsets.symmetric(vertical: w * .04),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(w * .03),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left side - Profile info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circular Profile Image
                        CircleAvatar(
                          radius: w * .08,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: profileImage.isNotEmpty
                              ? NetworkImage(
                                  ApiPath.imagebaseUrl + profileImage,
                                )
                              : null,
                          child: profileImage.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: w * .065,
                                  color: Colors.grey.shade700,
                                )
                              : null,
                        ),
                        SizedBox(height: w * .03),

                        // Driver Name
                        Text(
                          driverName.isNotEmpty ? driverName : "Driver Name",
                          style: TextStyle(
                            fontSize: w * .05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: w * .005),
                      ],
                    ),

                    // Right side - Rating info
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * .04,
                            vertical: w * .02,
                          ),
                          child: Row(
                            children: [
                              Text(
                                // Format the rating to show 1 decimal place
                                (driveridController
                                            .driveridresponse
                                            .value
                                            ?.driver
                                            ?.rating !=
                                        null)
                                    ? driveridController
                                        .driveridresponse
                                        .value!
                                        .driver!
                                        .rating!
                                        .toStringAsFixed(1)
                                    : "0.0",
                                style: TextStyle(
                                  fontSize: w * .045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Black color for rating number
                                ),
                              ),
                              SizedBox(width: w * .01),
                              Icon(
                                Icons.star,
                                color: Colors.amber, // Original star color
                                size: w * .05,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          // Show total reviews count if available
                          (driveridController
                                      .driveridresponse
                                      .value
                                      ?.driver
                                      ?.totalRating !=
                                  null)
                              ? "Rated by ${driveridController.driveridresponse.value!.driver!.totalRating} ${driveridController.driveridresponse.value!.driver!.totalRating == 1 ? 'Customer' : 'Customers'}"
                              : "No ratings yet",
                          style: TextStyle(
                            fontSize: w * .03,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Reviews List
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: reviews != null && reviews.isNotEmpty
                        ? reviews.map((review) {
                            final userName = review.user?.name ?? "Customer";
                            final userRating = review.rating ?? 0;
                            final experienceDescription =
                                review.experienceDescription ??
                                "No comment provided";
                            final userImage = review.user?.image ?? "";

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: w * .02),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGray.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        w * .02,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w * .03,
                                        vertical: w * .02,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Left column - User info (Flexible to take available space)
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // User Profile Image
                                                CircleAvatar(
                                                  radius: w * .05,
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  backgroundImage: 
                                                      userImage.isNotEmpty
                                                          ? NetworkImage(
                                                              ApiPath.imagebaseUrl + 
                                                              userImage,
                                                            ) as ImageProvider
                                                          : null,
                                                  child: userImage.isEmpty
                                                      ? Icon(
                                                          Icons.person,
                                                          size: w * .065,
                                                          color: Colors
                                                              .grey
                                                              .shade700,
                                                        )
                                                      : null,
                                                ),
                                                SizedBox(height: w * .01),
                                                
                                                // User Name
                                                AppFonts.textPoppins(
                                                  context,
                                                  userName,
                                                  w * .03,
                                                  FontWeight.w500,
                                                  AppColors.black,
                                                  TextAlign.start,
                                                  TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: w * .005),
                                                
                                                // Review Description
                                                AppFonts.textPoppins(
                                                  context,
                                                  experienceDescription,
                                                  w * .025,
                                                  FontWeight.w500,
                                                  AppColors.mediumGray,
                                                  TextAlign.start,
                                                  TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Right column - Rating (Fixed width)
                                          Container(
                                            width: w * .25,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Star Rating
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: List.generate(5, (
                                                    index,
                                                  ) {
                                                    return Icon(
                                                      Icons.star_rate_rounded,
                                                      color: index < userRating
                                                          ? Colors.amber
                                                          : Colors
                                                                .grey
                                                                .shade300,
                                                      size: w * .05,
                                                    );
                                                  }),
                                                ),
                                                SizedBox(height: w * .005),
                                                
                                                // Rating Text
                                                AppFonts.textPoppins(
                                                  context,
                                                  getRatingText(userRating),
                                                  w * .03,
                                                  FontWeight.w500,
                                                  getRatingColor(userRating),
                                                  TextAlign.end,
                                                  TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList()
                        : [
                            // Show empty state if no reviews
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: w * .1),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.reviews_outlined,
                                    size: w * .15,
                                    color: AppColors.mediumGray,
                                  ),
                                  SizedBox(height: w * .03),
                                  AppFonts.textPoppins(
                                    context,
                                    "No Reviews Yet",
                                    w * .045,
                                    FontWeight.w500,
                                    AppColors.black,
                                    TextAlign.center,
                                    TextOverflow.visible,
                                  ),
                                  SizedBox(height: w * .02),
                                  AppFonts.textPoppins(
                                    context,
                                    "You haven't received any reviews yet.",
                                    w * .032,
                                    FontWeight.w400,
                                    AppColors.mediumGray,
                                    TextAlign.center,
                                    TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}