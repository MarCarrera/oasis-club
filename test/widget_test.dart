import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clubfutbol/main.dart';

void main() {
  testWidgets('Login form validation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyAppABH());

    // Verify that the email and password fields are present.
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);

    // Verify that the button is present and initially disabled.
    final loginButton = find.widgetWithText(ElevatedButton, 'Entrar');
    expect(loginButton, findsOneWidget);

    // Enter text into the email and password fields.
    await tester.enterText(
        find.byKey(const Key('emailField')), 'test@example.com');
    await tester.enterText(
        find.byKey(const Key('passwordField')), 'password123');
    await tester.pump();

    // Tap the login button.
    await tester.tap(loginButton);
    await tester.pump();

    // Verify that the login was successful by checking for the success message.
    expect(find.text('Login exitoso para test@example.com'), findsOneWidget);
  });
}
