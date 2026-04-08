import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const EasibleApp());
}

class EasibleApp extends StatelessWidget {
  const EasibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
