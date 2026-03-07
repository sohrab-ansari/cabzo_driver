import 'package:nzcu_driver/controllers/profile_controllers/terms_and_policy_controller.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  final TermsAndPolicyController termsAndPolicyController =
      Get.find<TermsAndPolicyController>();

  @override
  void initState() {
    super.initState();
    termsAndPolicyController.terms_pricy_method();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: w * .03,
        elevation: 0,
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
            SizedBox(width: w * .035),
            CustomText(
              text: "Terms & Conditions",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (termsAndPolicyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (termsAndPolicyController.termspolicyres.value!.data == null) {
          return _errorView(w, "Unable to load terms & conditions");
        }

        final String termAndCondition =
            termsAndPolicyController
                .termspolicyres
                .value!
                .data!
                .termAndCondition ??
            '';

        if (termAndCondition.isEmpty) {
          return _errorView(w, "No terms & conditions found");
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(w * .04),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(w * .04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(w * .02),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Html(
              data: termAndCondition,
              style: {
                "body": Style(
                  fontSize: FontSize(w * .04),
                  color: Colors.black,
                  lineHeight: LineHeight.number(1.6),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "p": Style(margin: Margins.only(bottom: w * .03)),
                "li": Style(margin: Margins.only(bottom: w * .02)),
              },
              onLinkTap: (url, _, __) {
                debugPrint("Clicked link: $url");
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _errorView(double w, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: w * 0.12, color: Colors.grey),
          SizedBox(height: w * 0.04),
          CustomText(
            text: message,
            textColor: Colors.grey,
            textFontSize: w * 0.04,
          ),
        ],
      ),
    );
  }
}
