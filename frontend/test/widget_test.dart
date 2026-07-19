import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/login_screen.dart';

void main() {
  testWidgets('login screen renders the EASIBLE experience', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to EASIBLE'), findsOneWidget);
    expect(
      find.text(
        'Sign in to access your citizen services and emergency support.',
      ),
      findsOneWidget,
    );
  });
}
