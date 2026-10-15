import 'package:flutter/material.dart';

/// Exercise 3: Layout Basics Demo
///
/// Goal: Build a sectioned UI layout similar to a real app Home screen.
/// Demonstrates:
/// 1. Column to create vertical sections
/// 2. Spacing using Padding and SizedBox (consistent 8, 12, 16 px)
/// 3. ListView.builder showing movie titles/items
/// 4. Proper containment of ListView inside Column using Expanded
void main() {
  runApp(const LayoutApp());
}

/// Standalone MaterialApp wrapper so this exercise can run independently in DartPad,
/// VS Code, or Android Studio.
class LayoutApp extends StatelessWidget {
  const LayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 3 – Layout Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LayoutDemo(),
    );
  }
}

/// Movie model representing each item in the Now Playing list
class MovieItem {
  final String title;
  final String description;

  const MovieItem({required this.title, required this.description});

  /// Extracts the first character as the avatar initial
  String get initial => title.isNotEmpty ? title[0] : '?';
}

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  // Movie list matching the reference screenshot: Avatar, Inception, Interstellar, Joker
  static const List<MovieItem> movies = [
    MovieItem(title: 'Avatar', description: 'Sample description'),
    MovieItem(title: 'Inception', description: 'Sample description'),
    MovieItem(title: 'Interstellar', description: 'Sample description'),
    MovieItem(title: 'Joker', description: 'Sample description'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 – Layout Demo')),
      // Column arranges sections vertically
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Section Header ("Now Playing")
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Now Playing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Spacing with SizedBox (consistent 12px)
            const SizedBox(height: 8.0),

            // Section 2: ListView.builder inside Expanded
            // IMPORTANT CONCEPT: ListView inside a Column requires bounded height constraints.
            // Wrapping ListView.builder with Expanded allocates the remaining available height.
            Expanded(
              child: ListView.separated(
                itemCount: movies.length,
                // Consistent 12px spacing between cards
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12.0),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(
                            0xFFDDE3FF,
                          ), // Soft light-blue/lavender
                          child: Text(
                            movie.initial,
                            style: const TextStyle(
                              color: Color(0xFF2C3E8C),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Text(
                          movie.description,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
