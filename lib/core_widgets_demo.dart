import 'package:flutter/material.dart';

/// Exercise 1: Core Widgets Demo
///
/// Goal: Build a simple UI demonstrating essential Flutter display widgets:
/// 1. Headline Text ("Welcome to Flutter UI")
/// 2. Material Icon (e.g., Icons.movie)
/// 3. Network Image (Image.network)
/// 4. Card containing a ListTile
void main() {
  runApp(const CoreWidgetsApp());
}

/// Standalone MaterialApp wrapper so this exercise can run independently in DartPad,
/// VS Code, or Android Studio.
class CoreWidgetsApp extends StatelessWidget {
  const CoreWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 1 – Core Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CoreWidgetsDemo(),
    );
  }
}

/// The core widget demonstration screen.
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  // Sample image URL (aerial highway interchange matching the lab reference screenshot)
  static const String sampleImageUrl =
      'https://images.unsplash.com/photo-1545459720-aac8509eb02c?q=80&w=800&auto=format&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Scaffold provides the top-level visual structure with an AppBar.
      appBar: AppBar(title: const Text('Exercise 1 – Core Widgets Demo')),
      body: SingleChildScrollView(
        // SingleChildScrollView ensures no overflow occurs on smaller devices.
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget 1: Headline Text
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24.0),

            // Widget 2: Material Icon
            // Centered movie icon with Material design styling
            Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  Icons.movie,
                  size: 72.0,
                  color: Color(0xFF2196F3), // Vibrant blue matching screenshot
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Widget 3: Image.network
            // Demonstrates displaying an image fetched over the network
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                sampleImageUrl,
                width: double.infinity,
                height: 190.0,
                fit: BoxFit.cover,
                // loadingBuilder provides visual feedback while the image loads
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 190.0,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                // errorBuilder gracefully falls back if network is offline
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 190.0,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Sample Network Image (Offline Fallback)',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // Widget 4: Card containing a ListTile
            // Provides elevation and structured information presentation
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.star,
                    color: Color(0xFF4A5568),
                    size: 28.0,
                  ),
                  title: Text(
                    'Movie Item',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    'This is a sample ListTile inside a Card.',
                    style: TextStyle(color: Colors.black54, fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
