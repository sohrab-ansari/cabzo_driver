

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