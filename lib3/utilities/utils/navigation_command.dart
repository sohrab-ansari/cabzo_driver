

// models/navigation_command.dart
class NavigationCommand {
  final String route;
  final Map<String, dynamic>? arguments;
  final bool clearAll;

  NavigationCommand({
    required this.route,
    this.arguments,
    this.clearAll = false,
  });
}