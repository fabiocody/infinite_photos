import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_photos/router.dart';

void main() {
  runApp(const ProviderScope(child: InfinitePhotosApp()));
}

class InfinitePhotosApp extends StatelessWidget {
  const InfinitePhotosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Infinite photos',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
