


import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/home_related/live_ride.dart';
import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ArrivedOtpScreen extends StatefulWidget {
  bool? bookridetypecheck;

   ArrivedOtpScreen({super.key, this.bookridetypecheck});

  @override
  State<ArrivedOtpScreen> createState() => _ArrivedOtpScreenState();
}

class _ArrivedOtpScreenState extends State<ArrivedOtpScreen> {
  String enteredOtp = "";
  final StepperController stepperController = Get.find<StepperController>();


  final OrderUpdateController orderUpdateController = Get.find<OrderUpdateController>();

  @override
  void initState() {
    super.initState();
    // Prevent keyboard from auto opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;


      
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: w * 0.08,
        title:  Text("OTP  ${widget.bookridetypecheck}"),
        // centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: 

      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          w * 0.06,
          w * 0.06,
          w * 0.06,
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            /// Profile Image
            Container(
              height: w * 0.35,
              width: w * 0.35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                "assets/images/profile3.png",
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            /// Customer Name
            const Text(
              "Muskan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            /// Instruction
            const Text(
              "Enter the 4-digit code to begin the trip",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            /// OTP FIELD
            PinCodeTextField(
              appContext: context,
              length: 4,
              keyboardType: TextInputType.number,
              autoFocus: false, // This prevents keyboard from auto opening
              animationType: AnimationType.fade,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 55,
                fieldWidth: 55,
                activeColor: const Color(0xFF26E3DD),
                selectedColor: const Color(0xFF26E3DD),
                inactiveColor: Colors.grey.shade300,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
              ),
              animationDuration: const Duration(milliseconds: 200),
              enableActiveFill: true,
              onChanged: (value) => enteredOtp = value,
              onCompleted: (value) => enteredOtp = value,
            ),

            const SizedBox(height: 20),


            if(widget.bookridetypecheck == true) ...[

              Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: Colors.grey,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: w * 0.04,
      vertical: w * 0.035,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Red Dot Icon
        Image.asset(
          "assets/icons/redDot.png",
          height: w * 0.05,
          width: w * 0.05,
        ),

        SizedBox(width: w * 0.03),

        /// Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Label
              Text(
                "Drop",
                style: TextStyle(
                  fontSize: w * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 6),

              /// Address
              Text(
                "Bus Sta Upas, Majestic, Bengaluru, Karnataka 560009",
                style: TextStyle(
                  fontSize: w * 0.032,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
  SizedBox(height: 20),

//               Card(
//                 color: Colors.white,
//   elevation: 3,
//   shadowColor: Colors.black.withOpacity(0.15),
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(14),
//   ),
//   child: Padding(
//     padding: EdgeInsets.symmetric(
//       horizontal: w * 0.04,
//       vertical: w * 0.035,
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// Red Dot Icon
//         Image.asset(
//           "assets/icons/redDot.png",
//           height: w * 0.05,
//           width: w * 0.05,
//         ),

//         SizedBox(width: w * 0.03),

//         /// Text Content
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Label
//               Text(
//                 "Drop",
//                 style: TextStyle(
//                   fontSize: w * 0.035,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),

//               SizedBox(height: 6),

//               /// Address
//               Text(
//                 "Bus Sta Upas, Majestic, Bengaluru, Karnataka 560009",
//                 style: TextStyle(
//                   fontSize: w * 0.032,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.grey.shade700,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// )


 SizedBox(height: 10,)

    //           Column(
    //             children: [
    //               Row(
    //                 children: [

    // Image.asset(
    //                   "assets/icons/redDot.png",
    //                   height: w * 0.06,
    //                   width: w * 0.06,
    //                 ),
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text("Drop"),
    //                                         Text("Bus Sta Upas, Majestic, Bengaluru, Karnataka 560009")

    //                     ],
    //                   ),
    //                 ],
    //               ),

                
    //             ],
    //           )

              

            ],

            /// VERIFY BUTTON
            /// 
            // ArrivingClient
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:  widget.bookridetypecheck == true  ?
                
                 () {
            
              CustomNavigator.push(
        context,
         ArrivingClient(typeCheck:  true,),
        transition: TransitionType.fade,
      );
                       
                }

                :     ()  async{
                  if (enteredOtp.length != 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter valid OTP"),
                      ),
                    );
                    return;
                  }
                  
                  stepperController.nextStep();


                  await OrderService.VerifyOtpOrder(orderId: "",rideOtpEnter: enteredOtp);
                  Navigator.pop(context);
                  print("OTP Verified: $enteredOtp");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26E3DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



