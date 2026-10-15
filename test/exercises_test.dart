import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_flutter_ui/core_widgets_demo.dart';
import 'package:lab4_flutter_ui/input_controls_demo.dart';
import 'package:lab4_flutter_ui/layout_demo.dart';
import 'package:lab4_flutter_ui/app_structure_theme_demo.dart';
import 'package:lab4_flutter_ui/common_ui_fixes_demo.dart';

void main() {
  testWidgets('Exercise 1: CoreWidgetsDemo renders headline, icon, and card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoreWidgetsApp());

    expect(find.text('Welcome to Flutter UI'), findsOneWidget);
    expect(find.byIcon(Icons.movie), findsOneWidget);
    expect(find.text('Movie Item'), findsOneWidget);
    expect(
      find.text('This is a sample ListTile inside a Card.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'Exercise 2: InputControlsDemo renders slider, switch, and radios',
    (WidgetTester tester) async {
      await tester.pumpWidget(const InputControlsApp());

      expect(find.text('Rating (Slider)'), findsOneWidget);
      expect(find.text('Current value: 50'), findsOneWidget);
      expect(find.text('Active (Switch)'), findsOneWidget);
      expect(find.text('Is movie active?'), findsOneWidget);
      expect(find.text('Genre (RadioListTile)'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Comedy'), findsOneWidget);
      expect(find.text('Open Date Picker'), findsOneWidget);
    },
  );

  testWidgets('Exercise 3: LayoutDemo renders headline and movie cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LayoutApp());

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Avatar'), findsOneWidget);
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('Interstellar'), findsOneWidget);
    expect(find.text('Joker'), findsOneWidget);
  });

  testWidgets('Exercise 4: AppStructureThemeDemo renders Scaffold & FAB', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AppStructureThemeApp());

    expect(find.text('Exercise 4 – App Structure & Theme'), findsOneWidget);
    expect(find.text('Scaffold Components'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Exercise 5: CommonUIFixesDemo renders Task 1 items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CommonUIFixesApp());

    expect(
      find.text('Correct ListView inside Column using Expanded'),
      findsOneWidget,
    );
    expect(find.text('Movie A'), findsOneWidget);
    expect(find.text('Movie B'), findsOneWidget);
    expect(find.text('Movie C'), findsOneWidget);
    expect(find.text('Movie D'), findsOneWidget);
  });
}
