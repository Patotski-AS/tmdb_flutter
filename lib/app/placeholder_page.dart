import 'package:flutter/material.dart';

/// Temporary screen used until a feature route is implemented.
class PlaceholderPage extends StatelessWidget {
  /// Creates a scaffold titled [title], with [id] when the route has one.
  const new({required this.title, super.key, this.id});

  /// Screen name shown in the app bar and body.
  final String title;

  /// Route id, when the path contains one.
  final String? id;

  @override
  Widget build(BuildContext context) {
    final routeId = id;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (routeId != null) ...[
              const SizedBox(height: 8),
              Text(routeId),
            ],
          ],
        ),
      ),
    );
  }
}
