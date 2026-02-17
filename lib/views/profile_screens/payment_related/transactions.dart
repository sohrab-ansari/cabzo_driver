// import 'package:nzcu_driver/controller/profilecontoller/transaction_controller.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/utilities/colors/colors_list.dart';
// import 'package:nzcu_driver/utilities/custom_font.dart';
// import 'package:nzcu_driver/utilities/custom_text.dart';
// import 'package:nzcu_driver/utilities/navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';

// class Transactions extends StatefulWidget {
//   const Transactions({super.key});

//   @override
//   State<Transactions> createState() => _TransactionsState();
// }

// class _TransactionsState extends State<Transactions> {
//   final TransactionController transactionController =
//       Get.find<TransactionController>();
//   @override
//   void initState() {
//     transactionController.transactions_method();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColors.white,

//       appBar: AppBar(
//         backgroundColor: ColorsList.scaffoldColor,
//         automaticallyImplyLeading: false,
//         scrolledUnderElevation: 0,
//         elevation: 0,
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
//               text: "Transactions",
//               textColor: ColorsList.titleTextColor,
//               textFontSize: w * .05,
//               textFontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.symmetric(
//               vertical: w * .02,
//               horizontal: w * .03,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 index == 0
//                     ? Padding(
//                         padding: EdgeInsets.symmetric(vertical: w * .03),
//                         child: AppFonts.textPoppins(
//                           context,
//                           "Today",
//                           w * 0.037,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.center,
//                           TextOverflow.visible,
//                         ),
//                       )
//                     : index == 4
//                     ? Padding(
//                         padding: EdgeInsets.symmetric(vertical: w * .03),
//                         child: AppFonts.textPoppins(
//                           context,
//                           "Yesterday",
//                           w * 0.037,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.center,
//                           TextOverflow.visible,
//                         ),
//                       )
//                     : SizedBox(),

//                 Container(
//                       width: w,
//                       //  height: w * 0.40,
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.2),
//                             // spreadRadius: 1,
//                             blurRadius: 1,
//                             // changes position of shadow
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(w * 0.03),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           vertical: w * .025,
//                           horizontal: w * .04,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             CircleAvatar(
//                               radius: w * .055,
//                               backgroundColor: ColorsList.mainButtonLightColor,
//                               child: Image.asset(
//                                 "assets/icons/dline.png",
//                                 width: w * .055,
//                               ),

//                               // child: Image.asset(
//                               //                               "assets/icons/dplus.png",
//                               //                               width: w * .055,
//                               //                             ),
//                             ),
//                             SizedBox(width: w * .02),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Paid to Aditya",
//                                   w * 0.037,
//                                   FontWeight.w600,
//                                   AppColors.black,
//                                   TextAlign.center,
//                                   TextOverflow.visible,
//                                 ),
//                                 AppFonts.textPoppins(
//                                   context,
//                                   "Today at 09:20 am",
//                                   w * 0.03,
//                                   FontWeight.w500,
//                                   AppColors.mediumGray,
//                                   TextAlign.center,
//                                   TextOverflow.visible,
//                                 ),
//                               ],
//                             ),
//                             Spacer(),
//                             AppFonts.textPoppins(
//                               context,
//                               "-₹50.0",
//                               w * 0.05,
//                               FontWeight.w500,
//                               AppColors.primaryRed2,
//                               TextAlign.center,
//                               TextOverflow.visible,
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                     .animate()
//                     .fade(duration: 820.ms, curve: Curves.easeInOut)
//                     .scale(
//                       begin: const Offset(0.95, 0.95),
//                       end: const Offset(1, 1),
//                     ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:nzcu_driver/controllers/profile_controllers/transaction_controller.dart';
import 'package:nzcu_driver/modals/profile_modals/transactions_response.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
 


final TransactionController transactionController = Get.find<TransactionController>();
  @override
  void initState() {
    super.initState();
    // Fetch transactions data
    transactionController.transactions_method();
  }

  // Helper method to check if date is today
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Helper method to check if date is yesterday
  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    if (_isToday(date)) {
      return 'Today at ${DateFormat('hh:mm a').format(date)}';
    } else if (_isYesterday(date)) {
      return 'Yesterday at ${DateFormat('hh:mm a').format(date)}';
    } else {
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    }
  }

  // Get icon based on transaction type/category
  String _getTransactionIcon(String? type, String? category) {
    if (type == 'debit') {
      return "assets/icons/dline.png";
    } else if (type == 'credit') {
      return "assets/icons/dplus.png";
    }

    // Default icon or based on category
    switch (category?.toLowerCase()) {
      case 'ride':
        return "assets/icons/ride.png";
      case 'withdrawal':
        return "assets/icons/withdrawal.png";
      case 'bonus':
        return "assets/icons/bonus.png";
      case 'penalty':
        return "assets/icons/penalty.png";
      default:
        return "assets/icons/dline.png";
    }
  }

  // Get transaction title
  String _getTransactionTitle(String? title, String? type) {
    if (title != null && title.isNotEmpty) {
      return title;
    }

    if (type == 'debit') {
      return 'Money Deducted';
    } else if (type == 'credit') {
      return 'Money Added';
    }

    return 'Transaction';
  }

  // Group transactions by date
  Map<String, List<TransactionData>> _groupTransactionsByDate(
    List<TransactionData> transactions,
  ) {
    final Map<String, List<TransactionData>> grouped = {};

    for (var transaction in transactions) {
      if (transaction.createdAt == null) continue;

      final date = transaction.createdAt!;
      String dateKey;

      if (_isToday(date)) {
        dateKey = 'Today';
      } else if (_isYesterday(date)) {
        dateKey = 'Yesterday';
      } else {
        dateKey = DateFormat('dd MMM yyyy').format(date);
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: ColorsList.scaffoldColor,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: w * .03,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                CustomNavigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: w * .07,
                color: ColorsList.iconColor,
              ),
            ),
            SizedBox(width: w * .035),
            CustomText(
              text: "Transactions",
              textColor: ColorsList.titleTextColor,
              textFontSize: w * .05,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: Obx(() {
        // Show loading indicator
        if (transactionController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: ColorsList.mainButtonColor),
          );
        }

        // Show error message if any
        if (transactionController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: w * 0.15, color: Colors.red),
                SizedBox(height: w * 0.05),
                Text(
                  transactionController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: w * 0.04, color: Colors.red),
                ),
                SizedBox(height: w * 0.05),
                ElevatedButton(
                  onPressed: () {
                    transactionController.transactions_method();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsList.mainButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.05,
                      vertical: w * 0.03,
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(fontSize: w * 0.04, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Check if we have data
        final transactions = transactionController.transactionsres.value?.data;
        if (transactions == null || transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   "assets/icons/no_transactions.png",
                //   width: w * 0.4,
                //   height: w * 0.4,
                // ),
                SizedBox(height: w * 0.05),
                Text(
                  'No transactions found',
                  style: TextStyle(
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: w * 0.02),
                Text(
                  'Your transactions will appear here',
                  style: TextStyle(
                    fontSize: w * 0.035,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          );
        }

        // Group transactions by date
        final groupedTransactions = _groupTransactionsByDate(transactions);
        final dateKeys = groupedTransactions.keys.toList();

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: w * 0.02),
          itemCount: groupedTransactions.length,
          itemBuilder: (context, dateIndex) {
            final dateKey = dateKeys[dateIndex];
            final transactionsForDate = groupedTransactions[dateKey]!;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * .03,
                vertical: w * .01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Header
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: w * .02),
                    child: AppFonts.textPoppins(
                      context,
                      dateKey,
                      w * 0.037,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                  ),

                  // Transactions for this date
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transactionsForDate.length,
                    itemBuilder: (context, index) {
                      final transaction = transactionsForDate[index];
                      final isDebit =
                          transaction.type?.toLowerCase() == 'debit';
                      final amountColor = isDebit
                          ? AppColors.primaryRed2
                          : Colors.green;
                      final amountPrefix = isDebit ? '-₹' : '+₹';

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: w * .01),
                        child:
                            Container(
                                  width: w,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(
                                      w * 0.03,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: w * .025,
                                      horizontal: w * .04,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Transaction Icon
                                        CircleAvatar(
                                          radius: w * .055,
                                          backgroundColor: isDebit
                                              ? Colors.red.withOpacity(0.1)
                                              : Colors.green.withOpacity(0.1),
                                          child: Image.asset(
                                            _getTransactionIcon(
                                              transaction.type,
                                              transaction.category,
                                            ),
                                            width: w * .055,
                                            color: isDebit
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: w * .02),

                                        // Transaction Details
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppFonts.textPoppins(
                                                context,
                                                _getTransactionTitle(
                                                  transaction.title,
                                                  transaction.type,
                                                ),
                                                w * 0.037,
                                                FontWeight.w600,
                                                AppColors.black,
                                                TextAlign.left,
                                                TextOverflow.ellipsis,
                                              ),
                                              if (transaction.description !=
                                                      null &&
                                                  transaction
                                                      .description!
                                                      .isNotEmpty)
                                                AppFonts.textPoppins(
                                                  context,
                                                  transaction.description!,
                                                  w * 0.03,
                                                  FontWeight.w400,
                                                  AppColors.mediumGray,
                                                  TextAlign.left,
                                                  TextOverflow.ellipsis,
                                                ),
                                              SizedBox(height: w * 0.01),
                                              AppFonts.textPoppins(
                                                context,
                                                transaction.createdAt != null
                                                    ? _formatDate(
                                                        transaction.createdAt!,
                                                      )
                                                    : 'Date not available',
                                                w * 0.03,
                                                FontWeight.w500,
                                                AppColors.mediumGray,
                                                TextAlign.left,
                                                TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: w * .02),

                                        // Transaction Amount
                                        AppFonts.textPoppins(
                                          context,
                                          '$amountPrefix${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
                                          w * 0.045,
                                          FontWeight.w600,
                                          amountColor,
                                          TextAlign.right,
                                          TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .animate()
                                .fade(duration: 820.ms, curve: Curves.easeInOut)
                                .scale(
                                  begin: const Offset(0.95, 0.95),
                                  end: const Offset(1, 1),
                                ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
