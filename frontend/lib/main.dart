import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/theme.dart'; // ✅ ADD THIS

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Easible',

      // ✅ USE CENTRALIZED THEME
      theme: AppTheme.lightTheme,

      routerConfig: router,
    );
  }
}
