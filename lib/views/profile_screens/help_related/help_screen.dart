import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nzcu_driver/controllers/profile_controllers/faqs_categories_controler.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/profile_screens/help_related/F_a_qs.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final FaqsCategoriesControler faqsCategoriesControler = Get.put(
    FaqsCategoriesControler(),
  );

  // Default fallback topics in case API fails or returns no data
  final List<Map<String, String>> fallbackTopics = [
    {"icon": "assets/images/drive_image.png", "title": "Ride Issues"},
    {"icon": "assets/images/earnimage.png", "title": "Earning Issues"},
    {"icon": "assets/images/steering-wheel.png", "title": "Account Issues"},
    {"icon": "assets/images/steering-wheel2.png", "title": "Safety Issues"},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      faqsCategoriesControler.faqscategorimethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: _buildAppBar(w),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .04),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(w * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Common Topics Title
                CustomText(
                  text: "Common Topics",
                  textColor: ColorsList.titleTextColor,
                  textFontSize: w * .045,
                  textFontWeight: FontWeight.w600,
                ),

                SizedBox(height: w * .04),

                /// Common Topics Grid - Scrollable Section
                Expanded(
                  child: Obx(() {
                    if (faqsCategoriesControler.isLoading.value) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(w * .04),
                          child: CircularProgressIndicator(
                            color: ColorsList.buttonBlueColor,
                          ),
                        ),
                      );
                    }

                    if (faqsCategoriesControler.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(w * .04),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Failed to load categories",
                                textColor: Colors.red,
                                textFontSize: w * .04,
                              ),
                              SizedBox(height: w * .02),
                              ElevatedButton(
                                onPressed: () {
                                  faqsCategoriesControler.faqscategorimethod();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsList.buttonBlueColor,
                                ),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final categories =
                        faqsCategoriesControler
                            .faqsCategoriesResponse
                            .value
                            ?.categories ??
                        [];

                    // Use API categories if available, otherwise use fallback
                    final displayItems = categories.isNotEmpty
                        ? categories.map((category) {
                            return {
                              "icon":
                                  category.image ??
                                  "assets/images/drive_image.png",
                              "title": category.name ?? "Category",
                              "id": category.id ?? "",
                            };
                          }).toList()
                        : fallbackTopics;

                    if (displayItems.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(w * .04),
                          child: CustomText(
                            text: "No categories available",
                            textColor: ColorsList.subtitleTextColor,
                            textFontSize: w * .04,
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: w * .04,
                          mainAxisSpacing: w * .04,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          print("i_am_tapping");
                          final item = displayItems[index];
                          return _commonTopicItem(
                            icon: item['icon']!,
                            title: item['title']!,
                            categoryId: item['id'],
                          );
                        },
                      ),
                    );
                  }),
                ),

                SizedBox(height: w * .06),

                /// Illustration
                Center(
                  child: Image.asset(
                    "assets/images/image5.png",
                    width: w * .55,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: w * .55,
                        height: w * .3,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.support_agent,
                            size: w * .15,
                            color: ColorsList.buttonBlueColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: w * .04),

                /// Support Text
                Center(
                  child: CustomText(
                    text: "Need help? We're just a message away!",
                    textalign: TextAlign.center,
                    textColor: ColorsList.subtitleTextColor,
                    textFontSize: w * .04,
                    textFontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: w * .05),

                /// Contact Support Button
                Center(
                  child: SizedBox(
                    width: w * .6,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        CustomToast.showInfo("Coming soon!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Contact Live Support",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: w * .02), // Extra bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// -------------------- AppBar --------------------
  AppBar _buildAppBar(double w) {
    return AppBar(
      backgroundColor: ColorsList.scaffoldColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: w * .03,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => CustomNavigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              size: w * .07,
              color: ColorsList.iconColor,
            ),
          ),
          SizedBox(width: w * .02),
          CustomText(
            text: "Help",
            textColor: ColorsList.titleTextColor,
            textFontSize: w * .05,
            textFontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  /// -------------------- Common Topic Item --------------------
  Widget _commonTopicItem({
    required String icon,
    required String title,
    String? categoryId,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        CustomNavigator.push(
          context,
          FAQs(categoryId: categoryId, categoryName: title),
          transition: TransitionType.slideLeft,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsList.textfieldBorderColorSe),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Handle both network and asset images
            icon.startsWith('http')
                ? Image.network(
                    icon,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/drive_image.png",
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.help_outline,
                              color: ColorsList.buttonBlueColor,
                              size: 24,
                            ),
                          );
                        },
                      );
                    },
                  )
                : Image.asset(
                    icon,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: ColorsList.buttonBlueColor,
                          size: 24,
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 8),
            CustomText(
              text: title,
              textalign: TextAlign.center,
              textColor: ColorsList.titleTextColor,
              textFontSize: 13,
              textFontWeight: FontWeight.w500,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}