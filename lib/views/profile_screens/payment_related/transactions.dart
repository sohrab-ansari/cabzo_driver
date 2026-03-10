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
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    transactionController.transactions_method();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Near the bottom, load more
      transactionController.loadMoreTransactions();
    }
  }

  // Helper method to convert UTC to local time if needed
  DateTime _toLocal(DateTime date) {
    return date.toLocal();
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

  // Helper method to format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Date not available';

    final localDate = _toLocal(date);

    if (_isToday(localDate)) {
      return 'Today at ${DateFormat('hh:mm a').format(localDate)}';
    } else if (_isYesterday(localDate)) {
      return 'Yesterday at ${DateFormat('hh:mm a').format(localDate)}';
    } else {
      return DateFormat('dd MMM yyyy, hh:mm a').format(localDate);
    }
  }

  // Get date header key for grouping
  String _getDateKey(DateTime date) {
    final localDate = _toLocal(date);

    if (_isToday(localDate)) {
      return 'Today';
    } else if (_isYesterday(localDate)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(localDate);
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
  String _getTransactionTitle(
    String? title,
    String? type,
    String? description,
  ) {
    if (title != null && title.isNotEmpty) {
      return title;
    }

    // Use description if title is not available
    if (description != null && description.isNotEmpty) {
      if (description.length > 30) {
        return '${description.substring(0, 30)}...';
      }
      return description;
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
      final date = transaction.createdAt;
      if (date == null) continue;

      final dateKey = _getDateKey(date);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    // Sort transactions within each group by date (newest first)
    grouped.forEach((key, list) {
      list.sort((a, b) {
        final dateA = a.createdAt;
        final dateB = b.createdAt;
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA); // Descending order
      });
    });

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
        // Show loading indicator for initial load
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
        final transactions = transactionController.allTransactions;
        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: w * 0.2,
                  color: Colors.grey.withOpacity(0.5),
                ),
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

        // Sort date keys (Today first, then Yesterday, then other dates in descending order)
        final dateKeys = groupedTransactions.keys.toList()
          ..sort((a, b) {
            if (a == 'Today') return -1;
            if (b == 'Today') return 1;
            if (a == 'Yesterday') return -1;
            if (b == 'Yesterday') return 1;

            // Parse other dates for comparison
            try {
              final dateA = DateFormat('dd MMM yyyy').parse(a);
              final dateB = DateFormat('dd MMM yyyy').parse(b);
              return dateB.compareTo(dateA); // Newest first
            } catch (e) {
              return a.compareTo(b);
            }
          });

        return RefreshIndicator(
          onRefresh: () => transactionController.transactions_method(),
          color: ColorsList.mainButtonColor,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: w * 0.02),
            // +1 for the loading indicator / end-of-list item at the bottom
            itemCount: groupedTransactions.length + 1,
            itemBuilder: (context, dateIndex) {
              // Last item: show loading indicator or "no more" text
              if (dateIndex == groupedTransactions.length) {
                return Obx(() {
                  if (transactionController.isLoadingMore.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: w * 0.05),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorsList.mainButtonColor,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  if (!transactionController.hasMorePages) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: w * 0.04),
                      child: Center(
                        child: Text(
                          'No more transactions',
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                });
              }

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
                        w * 0.04,
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
                        final transactionStatus = transaction.status;
                        final transactionDate = transaction.createdAt;
                        final isPending =
                            transactionStatus?.toLowerCase() == 'pending';
                        final isDebit =
                            transaction.type?.toLowerCase() == 'debit';

                        // Use amber/orange colors for pending, otherwise normal colors
                        final Color amountColor;
                        final Color iconColor;
                        final Color iconBgColor;
                        if (isPending) {
                          amountColor = Colors.orange;
                          iconColor = Colors.orange;
                          iconBgColor = Colors.orange.withOpacity(0.1);
                        } else if (isDebit) {
                          amountColor = AppColors.primaryRed2;
                          iconColor = Colors.red;
                          iconBgColor = Colors.red.withOpacity(0.1);
                        } else {
                          amountColor = Colors.green;
                          iconColor = Colors.green;
                          iconBgColor = Colors.green.withOpacity(0.1);
                        }

                        final amountPrefix = isDebit ? '-₹' : '+₹';
                        final amount = transaction.amount ?? 0;

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: w * .01),
                          child:
                              Container(
                                    width: w,
                                    decoration: BoxDecoration(
                                      color: isPending
                                          ? Colors.orange.withOpacity(0.03)
                                          : AppColors.white,
                                      border: isPending
                                          ? Border.all(
                                              color: Colors.orange
                                                  .withOpacity(0.3),
                                              width: 1,
                                            )
                                          : null,
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
                                            backgroundColor: iconBgColor,
                                            child: isPending
                                                ? Icon(
                                                    Icons.access_time_rounded,
                                                    color: iconColor,
                                                    size: w * .055,
                                                  )
                                                : Image.asset(
                                                    _getTransactionIcon(
                                                      transaction.type,
                                                      transaction.category,
                                                    ),
                                                    width: w * .055,
                                                    color: iconColor,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Icon(
                                                        isDebit
                                                            ? Icons
                                                                .arrow_downward
                                                            : Icons
                                                                .arrow_upward,
                                                        color: iconColor,
                                                        size: w * .055,
                                                      );
                                                    },
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
                                                    transaction.description,
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
                                                        .isNotEmpty &&
                                                    (transaction.title ==
                                                            null ||
                                                        transaction
                                                            .title!
                                                            .isEmpty))
                                                  AppFonts.textPoppins(
                                                    context,
                                                    transaction.description!,
                                                    w * 0.03,
                                                    FontWeight.w400,
                                                    AppColors.mediumGray,
                                                    TextAlign.left,
                                                    TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                SizedBox(height: w * 0.01),
                                                Row(
                                                  children: [
                                                    AppFonts.textPoppins(
                                                      context,
                                                      _formatDate(
                                                          transactionDate),
                                                      w * 0.03,
                                                      FontWeight.w500,
                                                      AppColors.mediumGray,
                                                      TextAlign.left,
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    if (isPending) ...[
                                                      SizedBox(
                                                          width: w * 0.02),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              w * 0.018,
                                                          vertical: w * 0.005,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.orange
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            w * 0.01,
                                                          ),
                                                        ),
                                                        child:
                                                            AppFonts.textPoppins(
                                                          context,
                                                          'Pending',
                                                          w * 0.025,
                                                          FontWeight.w600,
                                                          Colors.orange,
                                                          TextAlign.center,
                                                          TextOverflow.visible,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: w * .02),

                                          // Transaction Amount
                                          AppFonts.textPoppins(
                                            context,
                                            '$amountPrefix${amount.toStringAsFixed(2)}',
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
                                  .fade(
                                    duration: 820.ms,
                                    curve: Curves.easeInOut,
                                  )
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
          ),
        );
      }),
    );
  }
}
