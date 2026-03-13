import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    filter: _DebugOnlyFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void v(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) _logger.t(message, error: error);
  }

  static void d(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) _logger.d(message, error: error);
  }

  static void i(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) _logger.i(message, error: error);
  }

  static void w(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) _logger.w(message, error: error);
  }

  static void e(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void wtf(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

class _DebugOnlyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}
