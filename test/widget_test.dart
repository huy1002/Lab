import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab7/main.dart';

void main() {
  testWidgets('Signup form initial render check', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Sign Up'), findsWidgets);
    expect(find.text('Create New Account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byKey(const Key('submit_button')), findsOneWidget);
    expect(find.byKey(const Key('terms_checkbox')), findsOneWidget);
  });

  testWidgets('Validation errors appear on empty submit',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap submit button with empty form
    final submitButton = find.byKey(const Key('submit_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verify error messages
    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
    expect(find.text('You must accept the Terms & Conditions to register.'),
        findsOneWidget);
  });

  testWidgets('Email validation tests (@ and . check)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final emailField = find.byKey(const Key('email_field'));

    // Enter email missing dot
    await tester.enterText(emailField, 'test@example');
    await tester.pumpAndSettle();
    expect(
      find.text('Email must contain both @ and . characters'),
      findsOneWidget,
    );

    // Enter valid email
    await tester.enterText(emailField, 'test@example.com');
    await tester.pumpAndSettle();
    expect(
      find.text('Email must contain both @ and . characters'),
      findsNothing,
    );
  });

  testWidgets('Password strength & confirm match validation tests',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final passwordField = find.byKey(const Key('password_field'));
    final confirmPasswordField =
        find.byKey(const Key('confirm_password_field'));

    // Short password (< 8 chars)
    await tester.enterText(passwordField, 'Pass1');
    await tester.pumpAndSettle();
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);

    // Password without digit
    await tester.enterText(passwordField, 'PasswordNoDigit');
    await tester.pumpAndSettle();
    expect(
      find.text('Password must contain at least 1 digit (0-9)'),
      findsOneWidget,
    );

    // Valid password
    await tester.enterText(passwordField, 'SecurePass123!');
    await tester.pumpAndSettle();
    expect(
      find.text('Password must be at least 8 characters'),
      findsNothing,
    );
    expect(
      find.text('Password must contain at least 1 digit (0-9)'),
      findsNothing,
    );

    // Mismatched confirm password
    await tester.enterText(confirmPasswordField, 'WrongPass123!');
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);

    // Matching confirm password
    await tester.enterText(confirmPasswordField, 'SecurePass123!');
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsNothing);
  });

  testWidgets('Async validation detects taken email',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final nameField = find.byKey(const Key('full_name_field'));
    final emailField = find.byKey(const Key('email_field'));
    final passwordField = find.byKey(const Key('password_field'));
    final confirmPasswordField =
        find.byKey(const Key('confirm_password_field'));

    await tester.enterText(nameField, 'Alice Smith');
    await tester.enterText(emailField, 'taken@example.com');
    await tester.enterText(passwordField, 'Secret1234');
    await tester.enterText(confirmPasswordField, 'Secret1234');

    // Accept terms
    final checkbox = find.byKey(const Key('terms_checkbox'));
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Submit form
    final submitButton = find.byKey(const Key('submit_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);

    // Advance 1 second - should be in loading state
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Checking email...'), findsOneWidget);

    // Advance remaining async delay
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Should show taken email SnackBar
    expect(
      find.text(
        'The email "taken@example.com" is already taken. Please try another.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Complete valid flow shows success dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final nameField = find.byKey(const Key('full_name_field'));
    final emailField = find.byKey(const Key('email_field'));
    final passwordField = find.byKey(const Key('password_field'));
    final confirmPasswordField =
        find.byKey(const Key('confirm_password_field'));

    await tester.enterText(nameField, 'Bob Builder');
    await tester.enterText(emailField, 'bob@builder.com');
    await tester.enterText(passwordField, 'StrongPass2026!');
    await tester.enterText(confirmPasswordField, 'StrongPass2026!');

    // Accept terms
    final checkbox = find.byKey(const Key('terms_checkbox'));
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Tap submit
    final submitButton = find.byKey(const Key('submit_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);

    // Advance loading and async delay
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Checking email...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify success dialog
    expect(find.text('Registration Successful!'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Bob Builder'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('bob@builder.com'),
      ),
      findsOneWidget,
    );
  });
}
