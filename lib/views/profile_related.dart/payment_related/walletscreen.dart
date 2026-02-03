import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/add_money.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/money_transfer_screen.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_related/transactions.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Wallet"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Wallet balance card
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      const Text(
                        "₹500.0",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Your wallet balance",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: Divider()),
                      GestureDetector(
                        onTap: () {

                          print("i_was_tapped");
                          CustomNavigator.push(
                                              context,
                                              AddMoney(),
                                              transition: TransitionType.slideLeft,
                                            );
                        },
                        child: const Text(
                          "+ Add Money",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Maintain a minimum balance of ₹200 in your wallet to accept rides.",

              
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 20),

            // Money Transfer Card
            SizedBox(

               width: 250,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                                         CustomNavigator.push(
                    context,
                    const MoneyTransferScreen(),
                    transition: TransitionType.fade,
                  );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/money2.png",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Money Transfer",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Transactions Card
            SizedBox(
               width: 250,
              child: Card(
                 color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                     CustomNavigator.push(
                                              context,
                                              Transactions(),
                                              transition: TransitionType.slideLeft,
                                            );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/money3.png",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Transactions",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
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
