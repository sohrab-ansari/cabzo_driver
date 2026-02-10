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

      final url =
          "${ApiPath.baseUri}/driver/earningReport?period=$period";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['data'] ?? {};
      } else {
        throw Exception(
            'Failed to load earnings report: ${response.statusCode}');
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

  // Calculate total time online (for today)
  static String calculateTimeOnline(List<dynamic> trips) {
    int totalMinutes = 0;
    for (var trip in trips) {
      if (trip['duration'] != null) {
        totalMinutes += (trip['duration'] as num).toInt();
      }
    }
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return "${hours}h ${minutes}m";
  }

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
      'Sunday'
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
      'December'
    ];
    return "${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
