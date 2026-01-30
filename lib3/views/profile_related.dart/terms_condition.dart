// import 'package:corezap_driver/controller/profilecontoller/terms_and_policy_controller.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';

// class TermsCondition extends StatefulWidget {
//   const TermsCondition({super.key});

//   @override
//   State<TermsCondition> createState() => _TermsConditionState();
// }

// class _TermsConditionState extends State<TermsCondition> {

//   final TermsAndPolicyController termsAndPolicyController = Get.put(TermsAndPolicyController());

//  initState(){
//   super.initState();

// termsAndPolicyController.terms_pricy_method();
  
//  }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: ColorsList.scaffoldColor,
//       appBar: AppBar(
//         backgroundColor: ColorsList.scaffoldColor,
//         automaticallyImplyLeading: false,
//         titleSpacing: w * .03,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 CustomNavigator.pop(context);
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 size: w * .07,
//                 color: ColorsList.iconColor,
//               ),
//             ),
//             SizedBox(width: w * .035),
//             CustomText(
//               text: "Terms & Conditions",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       // body: CustomImages.images(
//       //   "assets/images/termsCondition.png",
//       //   double.infinity,
//       //   double.infinity,
//       // ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(w * .04),
//         child: RichText(
//           text: TextSpan(
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: w * .04,
//               height: 1.5,
//             ),
//             children: [
//               const TextSpan(
//                 text:
//                     "Welcome to [Your App Name]. By using our app and services, you agree to follow these Terms & Conditions. Please read them carefully before booking or accepting a ride.\n\n",
//               ),

//               // 1. General
//               const TextSpan(
//                 text: "1. General\n",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               const TextSpan(
//                 text:
//                     "• These Terms govern your use of [Your App Name] (the “App” or “Service”).\n",
//               ),
//               const TextSpan(
//                 text:
//                     "• We may update these Terms from time to time. Continued use of the App means you accept the updated Terms.\n\n",
//               ),

//               // 2. User Eligibility
//               const TextSpan(
//                 text: "2. User Eligibility\n",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               const TextSpan(
//                 text: "• You must be 18 years or older to use the app.\n",
//               ),
//               const TextSpan(
//                 text:
//                     "• You must provide accurate personal details and maintain your account information.\n\n",
//               ),

//               // 3. Safety
//               const TextSpan(
//                 text: "3. Safety\n",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               const TextSpan(
//                 text:
//                     "• For your safety, share your ride details with family or friends.\n",
//               ),
//               const TextSpan(
//                 text:
//                     "• The company is not responsible for any accidents, delays, or incidents caused by third parties.\n\n",
//               ),

//               // 4. User Responsibilities
//               const TextSpan(
//                 text: "4. User Responsibilities\n",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               const TextSpan(
//                 text: "• Provide correct pickup and drop-off locations.\n",
//               ),
//               const TextSpan(
//                 text:
//                     "• Treat drivers, passengers, and vehicles with respect.\n",
//               ),
//               const TextSpan(
//                 text:
//                     "• No illegal or dangerous items are allowed in the vehicle.\n\n",
//               ),

//               // 5. Cancellation & Refunds
//               const TextSpan(
//                 text: "5. Cancellation & Refunds\n",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               const TextSpan(
//                 text:
//                     "• Passengers may cancel a ride before the driver reaches a certain distance from pickup (as per the app’s policy).\n",
//               ),
//               const TextSpan(
//                 text:
//                     "• Cancellation fees apply if canceled after this period.\n",
//               ),
//               const TextSpan(
//                 text:
//                     "• Refunds, if applicable, will be processed within [X] working days.\n",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:corezap_driver/controllers/profile_controllers/terms_and_policy_controller.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
 
final TermsAndPolicyController termsAndPolicyController = Get.find<TermsAndPolicyController>();


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
                    .termspolicyres.value!.data!.termAndCondition ??
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
                "p": Style(
                  margin: Margins.only(bottom: w * .03),
                ),
                "li": Style(
                  margin: Margins.only(bottom: w * .02),
                ),
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
          Icon(
            Icons.description_outlined,
            size: w * 0.12,
            color: Colors.grey,
          ),
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
