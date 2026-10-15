import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_flutter_ui/main.dart';

void main() {
  testWidgets('Lab 4 home screen displays all 5 exercise navigation options', (
    WidgetTester tester,
  ) async {
    // Build Lab 4 application
    await tester.pumpWidget(const Lab4App());

    // Verify AppBar title is present
    expect(find.text('Lab 4 – Flutter UI Fundamentals'), findsOneWidget);

    // Verify all 5 exercises are listed
    expect(find.text('Exercise 1 – Core Widgets Demo'), findsOneWidget);
    expect(find.text('Exercise 2 – Input Controls Demo'), findsOneWidget);
    expect(find.text('Exercise 3 – Layout Demo'), findsOneWidget);
    expect(find.text('Exercise 4 – App Structure & Theme'), findsOneWidget);
    expect(find.text('Exercise 5 – Common UI Fixes'), findsOneWidget);
  });
}
