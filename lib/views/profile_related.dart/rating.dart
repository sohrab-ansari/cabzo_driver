// // import 'package:nzcu_driver/utilities/colors.dart';
// // import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// // import 'package:nzcu_driver/utilities/custom_text.dart';
// // import 'package:nzcu_driver/utilities/navigator.dart';
// // import 'package:flutter/material.dart';

// // class Rating extends StatefulWidget {
// //   const Rating({super.key});

// //   @override
// //   State<Rating> createState() => _RatingState();
// // }

// // class _RatingState extends State<Rating> {
// //   String imagePath = "";
// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;
// //     return Scaffold(
// //       backgroundColor: ColorsList.scaffoldColor,
// //       appBar: AppBar(
// //         backgroundColor: ColorsList.scaffoldColor,
// //         automaticallyImplyLeading: false,
// //         titleSpacing: w * .035,
// //         title: Row(
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 CustomNavigator.pop(context);
// //               },
// //               child: Icon(
// //                 Icons.arrow_back,
// //                 size: w * .07,
// //                 color: AppColors.black,
// //               ),
// //             ),
// //             SizedBox(width: w * .02),
// //             CustomText(
// //               text: "Rating",
// //               textColor: ColorsList.titleTextColor,
// //               textFontSize: w * .05,
// //               textFontWeight: FontWeight.w500,
// //             ),
// //             Spacer(),
// //             // Buttons(
// //             //   buttonWidth: w * .15,
// //             //   buttonHeight: w * .07,
// //             //   borderRadius: w * .05,
// //             //   buttonColor: Colors.grey.shade200,

// //             //   // borderColor: ColorsList.mainBlurLightColor,
// //             //   onTap: () {
// //             //     //? navigation bottom sheet
// //             //     CustomNavigation.push(context, ReviewRating());
// //             //   },
// //             //   buttonText: Padding(
// //             //     padding: EdgeInsets.symmetric(
// //             //       horizontal: w * .005,
// //             //       vertical: w * .01,
// //             //     ),
// //             //     child: CustomText(
// //             //       text: "Skip", // 1,2,3,4
// //             //       textColor: ColorsList.titleTextColor,
// //             //       textFontSize: w * .03,
// //             //       textFontWeight: FontWeight.w500,
// //             //     ),
// //             //   ),
// //             // ),
// //           ],
// //         ),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .03),
// //         child: Column(
// //           //  crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Container(
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(5),

// //                 boxShadow: [
// //                   BoxShadow(
// //                     blurRadius: 1,
// //                     spreadRadius: 0.5,
// //                     color: Colors.grey.shade200,
// //                   ),
// //                 ],
// //                 color: ColorsList.scaffoldColor,
// //               ),
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(
// //                   horizontal: w * .02,
// //                   vertical: w * .02,
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       // crossAxisAlignment: CrossAxisAlignment.center,
// //                       mainAxisAlignment: MainAxisAlignment.center,

// //                       children: [
// //                         CircleAvatar(
// //                           radius: w * .07,
// //                           backgroundColor: Colors.grey.shade300,
// //                           backgroundImage:
// //                               imagePath != null && imagePath.isNotEmpty
// //                               ? AssetImage(imagePath) //  NetworkImage(imageUrl)
// //                               : null,
// //                           child: (imagePath == null || imagePath.isEmpty)
// //                               ? Icon(
// //                                   Icons.person,
// //                                   size: w * .08,
// //                                   color: Colors.grey.shade700,
// //                                 )
// //                               : null,
// //                         ),
// //                         SizedBox(width: w * .02),
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             CustomText(
// //                               text: "Amaan Shaikh", // 1,2,3,4
// //                               textColor: ColorsList.titleTextColor,
// //                               textFontSize: w * .046,
// //                               textFontWeight: FontWeight.w400,
// //                             ),
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 color: ColorsList.dividerColor,
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                               child: Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: w * .01,
// //                                   vertical: w * .002,
// //                                 ),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                       MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     CustomText(
// //                                       text: "5.0", // 1,2,3,4
// //                                       textColor: ColorsList.titleTextColor,
// //                                       textFontSize: w * .025,
// //                                       textFontWeight: FontWeight.w400,
// //                                     ),
// //                                     SizedBox(width: w * .005),
// //                                     Icon(
// //                                       Icons.star_rate_rounded,
// //                                       color: Colors.amber,
// //                                       size: w * .03,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         SizedBox(width: w * .01),
// //                       ],
// //                     ),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(vertical: w * .03),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: List.generate(5, (index) {
// //                           return Icon(
// //                             Icons.star,
// //                             color: Colors.amber,
// //                             size: w * .125,
// //                           );
// //                         }),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: w * .03),
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   children: List.generate(8, (index) {
// //                     return Padding(
// //                       padding: EdgeInsets.symmetric(vertical: w * .02),
// //                       child: Container(
// //                         decoration: BoxDecoration(
// //                           color: ColorsList.scaffoldOffWhiteColor,
// //                           borderRadius: BorderRadius.circular(w * .02),
// //                         ),
// //                         child: Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: w * .03,
// //                             vertical: w * .02,
// //                           ),
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Row(
// //                                 mainAxisAlignment: MainAxisAlignment.start,
// //                                 children: [
// //                                   CircleAvatar(
// //                                     radius: w * .05,
// //                                     backgroundColor: Colors.grey.shade300,
// //                                     backgroundImage:
// //                                         imagePath != null &&
// //                                             imagePath.isNotEmpty
// //                                         ? AssetImage(
// //                                             imagePath,
// //                                           ) //  NetworkImage(imageUrl)
// //                                         : null,
// //                                     child:
// //                                         (imagePath == null || imagePath.isEmpty)
// //                                         ? Icon(
// //                                             Icons.person,
// //                                             size: w * .065,
// //                                             color: Colors.grey.shade700,
// //                                           )
// //                                         : null,
// //                                   ),
// //                                   SizedBox(width: w * .02),
// //                                   SizedBox(
// //                                     width: w * .47,
// //                                     //  color: Colors.amber,
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         CustomText(
// //                                           text: "Jai Shaikh ", // 1,2,3,4
// //                                           textColor: ColorsList.titleTextColor,
// //                                           textFontSize: w * .042,
// //                                           textFontWeight: FontWeight.w400,
// //                                         ),
// //                                         CustomText(
// //                                           text:
// //                                               "Driver was very polite and helpful",
// //                                           textColor:
// //                                               ColorsList.subtitleTextColor,
// //                                           textFontSize: w * .029,
// //                                           textFontWeight: FontWeight.w400,
// //                                           overflow: TextOverflow.ellipsis,
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   SizedBox(width: w * .01),
// //                                   SizedBox(
// //                                     width: w * .28,
// //                                     // color: Colors.red,
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.end,
// //                                       children: [
// //                                         Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.center,
// //                                           children: List.generate(5, (index) {
// //                                             return Icon(
// //                                               Icons.star_rate_rounded,
// //                                               color: Colors.amber,
// //                                               size: w * .052,
// //                                             );
// //                                           }),
// //                                         ),
// //                                         CustomText(
// //                                           text: "Excellent ", // 1,2,3,4
// //                                           textColor:
// //                                               ColorsList.greenButtonColor,
// //                                           textFontSize: w * .029,
// //                                           textFontWeight: FontWeight.w400,
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:nzcu_driver/utilities/app_buttons.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/utilities/custom_font.dart';
// import 'package:nzcu_driver/utilities/navigator.dart';
// import 'package:flutter/material.dart';
// // import 'package:nzcu_user/utils/custom_images.dart';
// // import 'package:nzcu_user/utils/with_animations/app_buttons.dart';
// // import 'package:nzcu_user/utils/with_animations/colors.dart';
// // import 'package:nzcu_user/utils/with_animations/custom_font.dart';
// // import 'package:nzcu_user/utils/with_animations/navigator.dart';

// class Review extends StatefulWidget {
//   const Review({super.key});

//   @override
//   State<Review> createState() => _ReviewState();
// }

// class _ReviewState extends State<Review> {
//   String imagePath = "";
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
//             AppButtons.outlined(
//               context: context,
//               width: w * .15,
//               height: w * .06,
//               radius: 30,
//               fontSize: w * .025,
//               padding: EdgeInsets.zero,
//               text: "Skip",
//               onClicked: () {
//                 // CustomNavigator.push(
//                 //   context,
//                 //   EnterOtpScreen(),
//                 //   transition:
//                 //       TransitionType.slideLeft,
//                 // );
//               },
//               textColor: AppColors.primaryblue,
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .03),
//         child: Column(
//           //  crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),

//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 1,
//                     spreadRadius: 0.5,
//                     color: Colors.grey.shade200,
//                   ),
//                 ],
//                 color: AppColors.primaryblue.withOpacity(0.1),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: w * .04,
//                   vertical: w * .04,
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                       children: [
//                         Column(
//                           children: [
//                             CircleAvatar(
//                               radius: w * .05,
//                               backgroundColor: Colors.grey.shade300,
//                               backgroundImage:
//                                   imagePath != null && imagePath.isNotEmpty
//                                   ? AssetImage(
//                                       imagePath,
//                                     ) //  NetworkImage(imageUrl)
//                                   : null,
//                               child: (imagePath == null || imagePath.isEmpty)
//                                   ? Icon(
//                                       Icons.person,
//                                       size: w * .08,
//                                       color: Colors.grey.shade700,
//                                     )
//                                   : null,
//                             ),
//                             SizedBox(height: w * .01),
//                             AppFonts.textPoppins(
//                               context,
//                               "Niraj Ray",
//                               w * .04,
//                               FontWeight.w500,
//                               AppColors.black,
//                               TextAlign.start,
//                               TextOverflow.visible,
//                             ),
//                           ],
//                         ),

//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "5.0",
//                                   w * .06,
//                                   FontWeight.w500,
//                                   AppColors.black,
//                                   TextAlign.start,
//                                   TextOverflow.visible,
//                                 ),
//                                 Icon(
//                                   Icons.star,
//                                   color: AppColors.yellow,
//                                   size: w * .08,
//                                 ),
//                               ],
//                             ),
//                             AppFonts.textPoppins(
//                               context,
//                               "Rated by happy customers",
//                               w * .022,
//                               FontWeight.w500,
//                               AppColors.black,
//                               TextAlign.start,
//                               TextOverflow.visible,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     // Padding(
//                     //   padding: EdgeInsets.symmetric(vertical: w * .03),
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: List.generate(5, (index) {
//                     //       return Icon(
//                     //         Icons.star,
//                     //         color: Colors.amber,
//                     //         size: w * .125,
//                     //       );
//                     //     }),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: w * .03),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: List.generate(8, (index) {
//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: w * .02),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.lightGray.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(w * .02),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: w * .03,
//                             vertical: w * .02,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CircleAvatar(
//                                     radius: w * .05,
//                                     backgroundColor: Colors.grey.shade300,
//                                     backgroundImage:
//                                         imagePath != null &&
//                                             imagePath.isNotEmpty
//                                         ? AssetImage(
//                                             imagePath,
//                                           ) //  NetworkImage(imageUrl)
//                                         : null,
//                                     child:
//                                         (imagePath == null || imagePath.isEmpty)
//                                         ? Icon(
//                                             Icons.person,
//                                             size: w * .065,
//                                             color: Colors.grey.shade700,
//                                           )
//                                         : null,
//                                   ),
//                                   AppFonts.textPoppins(
//                                     context,
//                                     "Jai Shaikh ",
//                                     w * .03,
//                                     FontWeight.w500,
//                                     AppColors.black,
//                                     TextAlign.start,
//                                     TextOverflow.visible,
//                                   ),

//                                   AppFonts.textPoppins(
//                                     context,
//                                     "Driver was very polite and helpful",
//                                     w * .025,
//                                     FontWeight.w500,
//                                     AppColors.mediumGray,
//                                     TextAlign.start,
//                                     TextOverflow.visible,
//                                   ),
//                                 ],
//                               ),

//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: List.generate(5, (index) {
//                                       return Icon(
//                                         Icons.star_rate_rounded,
//                                         color: Colors.amber,
//                                         size: w * .07,
//                                       );
//                                     }),
//                                   ),
//                                   AppFonts.textPoppins(
//                                     context,
//                                     "Excellent ",
//                                     w * .035,
//                                     FontWeight.w500,
//                                     AppColors.green,
//                                     TextAlign.start,
//                                     TextOverflow.visible,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:nzcu_driver/controllers/profile_controllers/review_and_rating_controller.dart';
import 'package:nzcu_driver/utilities/app_buttons.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/custom_font.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String imagePath = "";
  
  


  
final ReviewAndRatingController reviewAndRatingController = Get.find<ReviewAndRatingController>();



  @override
  void initState() {
    reviewAndRatingController.ratings_method();
    super.initState();
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
            // Obx(() => AppButtons.outlined(
            //   context: context,
            //   width: w * .15,
            //   height: w * .06,
            //   radius: 30,
            //   fontSize: w * .025,
            //   padding: EdgeInsets.zero,
            //   text: "Skip",
            //   onClicked: () {
            //     // CustomNavigator.push(
            //     //   context,
            //     //   EnterOtpScreen(),
            //     //   transition:
            //     //       TransitionType.slideLeft,
            //     // );
            //   },
            //   textColor: AppColors.primaryblue,
            // )),
          ],
        ),
      ),
      body: Obx(() {
        // Show loading state
        if (reviewAndRatingController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryblue,
            ),
          );
        }

        // Get reviews data
        final reviews = reviewAndRatingController.reviewRatingResponse.value?.data;
        final averageRating = reviewAndRatingController.averageRating;
        final totalReviews = reviewAndRatingController.totalReviews;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .03),
          child: Column(
            children: [
              // Rating Summary Card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 0.5,
                      color: Colors.grey.shade200,
                    ),
                  ],
                  color: AppColors.primaryblue.withOpacity(0.1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * .04,
                    vertical: w * .04,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: w * .05,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage:
                                    imagePath.isNotEmpty
                                    ? AssetImage(imagePath)
                                    : null,
                                child: imagePath.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: w * .08,
                                        color: Colors.grey.shade700,
                                      )
                                    : null,
                              ),
                              SizedBox(height: w * .01),
                              AppFonts.textPoppins(
                                context,
                                "Niraj Ray", // You can replace this with actual driver name from API if available
                                w * .04,
                                FontWeight.w500,
                                AppColors.black,
                                TextAlign.start,
                                TextOverflow.visible,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppFonts.textPoppins(
                                    context,
                                    averageRating.toStringAsFixed(1),
                                    w * .06,
                                    FontWeight.w500,
                                    AppColors.black,
                                    TextAlign.start,
                                    TextOverflow.visible,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppColors.yellow,
                                    size: w * .08,
                                  ),
                                ],
                              ),
                              AppFonts.textPoppins(
                                context,
                                totalReviews > 0 
                                    ? "Rated by $totalReviews customer${totalReviews > 1 ? 's' : ''}"
                                    : "No ratings yet",
                                w * .022,
                                FontWeight.w500,
                                AppColors.black,
                                TextAlign.start,
                                TextOverflow.visible,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: w * .03),
              
              // Reviews List
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: reviews != null && reviews.isNotEmpty
                        ? reviews.map((review) {
                            final userName = review.user?.name ?? "Customer";
                            final userRating = review.rating ?? 0;
                            final experienceDescription = review.experienceDescription ?? "No comment provided";
                            
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: w * .02),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(w * .02),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * .03,
                                    vertical: w * .02,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: w * .05,
                                            backgroundColor: Colors.grey.shade300,
                                            backgroundImage:
                                                imagePath.isNotEmpty
                                                ? AssetImage(imagePath)
                                                : null,
                                            child: imagePath.isEmpty
                                                ? Icon(
                                                    Icons.person,
                                                    size: w * .065,
                                                    color: Colors.grey.shade700,
                                                  )
                                                : null,
                                          ),
                                          SizedBox(height: w * .01),
                                          AppFonts.textPoppins(
                                            context,
                                            userName,
                                            w * .03,
                                            FontWeight.w500,
                                            AppColors.black,
                                            TextAlign.start,
                                            TextOverflow.visible,
                                          ),
                                          SizedBox(height: w * .01),
                                          AppFonts.textPoppins(
                                            context,
                                            experienceDescription,
                                            w * .025,
                                            FontWeight.w500,
                                            AppColors.mediumGray,
                                            TextAlign.start,
                                            TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(5, (index) {
                                              return Icon(
                                                Icons.star_rate_rounded,
                                                color: index < userRating 
                                                    ? Colors.amber 
                                                    : Colors.grey.shade300,
                                                size: w * .07,
                                              );
                                            }),
                                          ),
                                          AppFonts.textPoppins(
                                            context,
                                            getRatingText(userRating),
                                            w * .035,
                                            FontWeight.w500,
                                            getRatingColor(userRating),
                                            TextAlign.start,
                                            TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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