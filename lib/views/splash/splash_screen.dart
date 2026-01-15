


import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/auth/login_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/home_screen.dart';
import 'package:corezap_driver/views/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted) return;
//       // CustomNavigator.removeUntil(
//       //   context,
//       //   const OnboardingScreen(),
//       //   transition: TransitionType.fade,
//       // );

//  CustomNavigator.removeUntil(
//         context,
//         const LoginScreen(),
//         transition: TransitionType.fade,
//       );
//       // LoginScreen
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

// final h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: h * 0.1 ,),
//               /// Logos Section
//               Container(
//                 // margin: EdgeInsets.only(left: 58),
//                  margin: EdgeInsets.only(left: w * 0.17),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/logo3.png',
//                       width: w * 0.55,
//                     ),
//                     Positioned(
//                       top: w * 0.11,
//                       child: Image.asset(
//                         'assets/images/logo4.png',
//                         width: w * 0.30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
          
//                SizedBox(height: h * 0.009 ),
          
//               Container(
//                 // margin: EdgeInsets.only(left: 8),
//                 margin: EdgeInsets.only(left: w * 0.03),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Image.asset(
//                     'assets/images/logo6.png',
//                     width: w * 0.35,
//                     // height: h * 0.3,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
          
             
//                   SizedBox(height: h * 0.05 ),
          
           
//               Container(
                
//                  margin: EdgeInsets.only(left: w * 0.04),
//                 child: Column(
                             
               
//                   children:  [
//                     Text(
//                       "Every journey made safer, every \n mile made better.",
//                    textAlign: TextAlign.center,
//                       style: TextStyle(

//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: h * 0.02 ),
//                     Text(
//                       "We take the wheel for your comfort.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      CustomNavigator.removeUntil(
        context,
        const LoginScreen(),
        transition: TransitionType.fade,
      );
    });

    tokenbasednav();
  }

  Future<void> tokenbasednav() async {
     final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    print("splashtokennnn ${token}");

   if(token !=null) {


   CustomNavigator.removeUntil(
        context,
        const BottomnavmainScreen(),
        transition: TransitionType.fade,
      );

   }else {

    CustomNavigator.removeUntil(
        context,
        const LoginScreen(),
        transition: TransitionType.fade,
      );

   }
  

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                SizedBox(height: h * 0.08),

                /// LOGO STACK
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo3.png',
                        width: w * 0.5,
                      ),
                      Positioned(
                        top: w * 0.13,
                        child: Image.asset(
                          'assets/images/logo4.png',
                          width: w * 0.25,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.02),

                /// SECOND LOGO
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/logo6.png',
                    width: w * 0.6,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: h * 0.06),

                /// TEXT SECTION
                Column(
                  children: [
                    Text(
                      "Every journey made safer,every\n mile made better.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: w * 0.06, // responsive text
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Text(
                      "We take the wheel for your comfort.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: w * 0.038,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

