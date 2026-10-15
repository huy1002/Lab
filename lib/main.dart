import 'package:flutter/material.dart';

import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_theme_demo.dart';
import 'common_ui_fixes_demo.dart';

void main() {
  runApp(const Lab4App());
}

/// Root Application Widget for Lab 4 – Flutter UI Fundamentals.
/// Provides centralized ThemeMode management and navigation to all 5 lab exercises.
class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  // Global theme mode toggle (supports Exercise 4 theme requirement)
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 – Flutter UI Fundamentals',
      themeMode: _themeMode,

      // Light Theme configuration
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E60CE),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7FA),
          foregroundColor: Colors.black87,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),

      // Dark Theme configuration
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121218),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E60CE),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      home: Lab4HomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// The Lab 4 Master Hub screen matching Image 1 from the assignment.
class Lab4HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const Lab4HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    // List of exercises with destination widgets
    final List<Map<String, dynamic>> exercises = [
      {
        'title': 'Exercise 1 – Core Widgets Demo',
        'subtitle': 'Text, Image, Icon, Card, ListTile',
        'builder': (context) => const CoreWidgetsDemo(),
      },
      {
        'title': 'Exercise 2 – Input Controls Demo',
        'subtitle': 'Slider, Switch, RadioListTile, DatePicker',
        'builder': (context) => const InputControlsDemo(),
      },
      {
        'title': 'Exercise 3 – Layout Demo',
        'subtitle': 'Column, Row, Padding, ListView',
        'builder': (context) => const LayoutDemo(),
      },
      {
        'title': 'Exercise 4 – App Structure & Theme',
        'subtitle': 'Scaffold, AppBar, FAB & Dark Mode',
        'builder': (context) => AppStructureThemeDemo(
          isDarkMode: isDarkMode,
          onToggleTheme: onToggleTheme,
        ),
      },
      {
        'title': 'Exercise 5 – Common UI Fixes',
        'subtitle': 'Expanded, ScrollView, setState, BuildContext',
        'builder': (context) => const CommonUIFixesDemo(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundamentals'),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        itemCount: exercises.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
        itemBuilder: (context, index) {
          final item = exercises[index];
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => item['builder'](ctx) as Widget,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            item['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
