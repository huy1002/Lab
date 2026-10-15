import 'package:flutter/material.dart';

/// Exercise 4: App Structure with Scaffold, AppBar, FAB & Theme
///
/// Goal: Practice building a complete screen structure.
/// Demonstrates:
/// 1. Scaffold layout structure (AppBar, Body, FloatingActionButton, SnackBar)
/// 2. Custom ThemeData (Light & Dark color palettes, typography, card shapes)
/// 3. Dynamic "Dark Mode" toggle using ThemeMode and setState()
void main() {
  runApp(const AppStructureThemeApp());
}

/// Standalone MaterialApp wrapper providing dynamic ThemeMode switching.
class AppStructureThemeApp extends StatefulWidget {
  const AppStructureThemeApp({super.key});

  @override
  State<AppStructureThemeApp> createState() => _AppStructureThemeAppState();
}

class _AppStructureThemeAppState extends State<AppStructureThemeApp> {
  // Theme state: controls whether the app renders in Light or Dark theme
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
      title: 'Exercise 4 – App Structure & Theme',
      // Current theme mode: Light or Dark
      themeMode: _themeMode,

      // 1. Customized Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),

      // 2. Customized Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),

      home: AppStructureThemeDemo(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// The Screen demonstrating complete Scaffold composition and Theme usage.
class AppStructureThemeDemo extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleTheme;

  const AppStructureThemeDemo({
    super.key,
    this.isDarkMode = false,
    this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // 1. AppBar: Top app header with title and action controls
      appBar: AppBar(
        title: const Text('Exercise 4 – App Structure & Theme'),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              onToggleTheme?.call();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isDarkMode
                        ? 'Switched to Light Mode'
                        : 'Switched to Dark Mode',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),

      // 2. Body: Main content area demonstrating ThemeData integration
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card showing current theme
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      size: 40,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDarkMode
                                ? 'Dark Theme Active'
                                : 'Light Theme Active',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Using ThemeData with Material 3 ColorScheme',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section: Scaffold Anatomy Explanation
            Text(
              'Scaffold Components',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildFeatureTile(
              context,
              icon: Icons.web_asset,
              title: 'AppBar',
              description: 'Provides navigation, title, and action icons at the top of the screen.',
            ),
            const SizedBox(height: 8),

            _buildFeatureTile(
              context,
              icon: Icons.dashboard_customize,
              title: 'Body',
              description: 'Houses the primary screen content, responsive to layout constraints.',
            ),
            const SizedBox(height: 8),

            _buildFeatureTile(
              context,
              icon: Icons.touch_app,
              title: 'FloatingActionButton (FAB)',
              description: 'Promotes the primary screen action, floating above the body.',
            ),
            const SizedBox(height: 8),

            _buildFeatureTile(
              context,
              icon: Icons.palette,
              title: 'ThemeData & themeMode',
              description: 'Applies consistent brand colors, typography, shapes, and dark mode.',
            ),
            const SizedBox(height: 24),

            // Interactive Toggle Switch
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: SwitchListTile(
                secondary: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: colorScheme.primary,
                ),
                title: const Text('Dark Mode Toggle'),
                subtitle: Text(
                  isDarkMode ? 'ThemeMode.dark' : 'ThemeMode.light',
                ),
                value: isDarkMode,
                onChanged: (val) {
                  onToggleTheme?.call();
                },
              ),
            ),
            const SizedBox(height: 80), // Padding to avoid FAB overlap
          ],
        ),
      ),

      // 3. FloatingActionButton: Primary screen interaction
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onToggleTheme?.call();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Theme toggled via FAB to ${isDarkMode ? "Light Mode" : "Dark Mode"}!',
              ),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () => onToggleTheme?.call(),
              ),
            ),
          );
        },
        icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        label: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
          child: Icon(icon, color: colorScheme.primary, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
