import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';

class EarningsService {
  // Get earning report based on period (today, weekly, monthly)
  static Future<Map<String, dynamic>> getEarningReport(String period) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");

      if (token == null) {
        throw Exception("Auth token not found");
      }

      print("helloooo>>>>>  ${period}");

      final url = "${ApiPath.baseUri}/driver/earningReport?period=$period";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("myyyy_datattt_hererr ${response}");
        print("myyyy_datattt_hererr2 ${response.body}");
        final jsonData = jsonDecode(response.body);
        return jsonData['data'] ?? {};
      } else {
        throw Exception(
          'Failed to load earnings report: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error fetching earnings report: $e");
      rethrow;
    }
  }

  // Get ride/order history
  static Future<List<dynamic>> getRideHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");

      if (token == null) {
        throw Exception("Auth token not found");
      }

      final url = "${ApiPath.baseUri}/order/driver/history";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['data'] ?? [];
      } else {
        throw Exception('Failed to load ride history: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching ride history: $e");
      rethrow;
    }
  }

  static String calculateTimeOnline(List<dynamic> trips) {
    int totalMinutes = 0;

    for (var trip in trips) {
      if (trip['duration'] != null) {
        totalMinutes += (trip['duration'] as num).toInt();
      }
    }

    if (totalMinutes == 0) return "0 day";

    double totalDays = totalMinutes / (60 * 24);

    // Round to nearest 0.5
    double roundedDays = (totalDays * 2).round() / 2;

    // If less than 1 day but greater than 0 → show 0.5 day
    if (roundedDays < 1) {
      return "0.5 day";
    }

    // Singular for exactly 1
    if (roundedDays == 1) {
      return "1 day";
    }

    // Plural for more than 1
    return "${roundedDays.toStringAsFixed(1).replaceAll('.0', '')} days";
  }
  // static String calculateTimeOnline(List<dynamic> trips) {
  //   int totalMinutes = 0;

  //   for (var trip in trips) {
  //     if (trip['duration'] != null) {
  //       totalMinutes += (trip['duration'] as num).toInt();
  //     }
  //   }

  //   double totalDays = totalMinutes / (60 * 24);

  //   // Round to nearest half day (0.5)
  //   double roundedDays = (totalDays * 2).round() / 2;

  //   // Minimum should be 0.5 if below 1 day but greater than 0
  //   if (roundedDays < 1 && totalMinutes > 0) {
  //     roundedDays = 0.5;
  //   }

  //   if (roundedDays == 1) {
  //     return "1 day";
  //   } else {
  //     return "${roundedDays.toStringAsFixed(1)} days";
  //   }
  // }

  // static String calculateTimeOnline(List<dynamic> trips) {
  //   int totalMinutes = 0;

  //   for (var trip in trips) {
  //     if (trip['duration'] != null) {
  //       totalMinutes += (trip['duration'] as num).toInt();
  //     }
  //   }

  //   double totalHours = totalMinutes / 60;

  //   // If less than 1 day → show only minutes
  //   if (totalHours < 24) {
  //     return "${totalMinutes}m";
  //   }
  //   // If 1 day or more → show only days
  //   else {
  //     double days = totalHours / 24;

  //     // Whole number days
  //     if (days % 1 == 0) {
  //       int wholeDays = days.toInt();
  //       return "$wholeDays day${wholeDays > 1 ? 's' : ''}";
  //     }
  //     // Round to nearest half day
  //     else {
  //       double roundedDays = (days * 2).round() / 2;
  //       return "${roundedDays.toStringAsFixed(1)} days";
  //     }
  //   }
  // }

  // static String calculateTimeOnline(List<dynamic> trips) {
  //     int totalMinutes = 0;

  //     for (var trip in trips) {
  //       if (trip['duration'] != null) {
  //         totalMinutes += (trip['duration'] as num).toInt();
  //       }
  //     }

  //     double totalHours = totalMinutes / 60; // Convert to hours with decimal

  //     // Check if it's less than a day
  //     if (totalHours < 24) {
  //       int hours = totalMinutes ~/ 60;
  //       int minutes = totalMinutes % 60;

  //       if (hours == 0) {
  //         return "${minutes}m";
  //       } else if (minutes == 0) {
  //         return "${hours}h";
  //       } else {
  //         return "${hours}h ${minutes}m";
  //       }
  //     }
  //     // For days calculation
  //     else {
  //       double days = totalHours / 24;

  //       // Check if it's a half day (ends with .5)
  //       if (days % 1 == 0.5 || (days * 10) % 10 == 5) {
  //         return "${days.toStringAsFixed(1)} days";
  //       }
  //       // Check if it's a whole number
  //       else if (days % 1 == 0) {
  //         int wholeDays = days.toInt();
  //         return "$wholeDays day${wholeDays > 1 ? 's' : ''}";
  //       }
  //       // For other decimal values, round to nearest half
  //       else {
  //         double roundedDays = (days * 2).round() / 2;
  //         return "${roundedDays.toStringAsFixed(1)} days";
  //       }
  //     }
  //   }

  // static String calculateTimeOnline(List<dynamic> trips) {
  //   int totalMinutes = 0;

  //   for (var trip in trips) {
  //     if (trip['duration'] != null) {
  //       totalMinutes += (trip['duration'] as num).toInt();
  //     }
  //   }

  //   int hours = totalMinutes ~/ 60; // Total hours (including multiple days)
  //   int minutes = totalMinutes % 60;

  //   return "${hours}h ${minutes}m";
  // }

  // Get formatted date based on period
  static String getFormattedDate(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'today':
        return _formatDate(now);
      case 'weekly':
        return 'Weekly Report';
      case 'monthly':
        return 'Monthly Report';
      default:
        return '';
    }
  }

  static String _formatDate(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
