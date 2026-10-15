import 'package:flutter/material.dart';

/// Exercise 2: Input Widgets Demo
///
/// Goal: Build interactive UI that lets users control values using:
/// 1. StatefulWidget named InputControlsDemo
/// 2. Slider (e.g., rating 0 to 100)
/// 3. Switch (e.g., active status toggle)
/// 4. RadioListTile group (e.g., genre selection: Action, Comedy)
/// 5. DatePicker triggered via a button
/// 6. Display all updated state values on screen
void main() {
  runApp(const InputControlsApp());
}

/// Standalone MaterialApp wrapper so this exercise can run independently in DartPad,
/// VS Code, or Android Studio.
class InputControlsApp extends StatelessWidget {
  const InputControlsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 2 – Input Controls',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InputControlsDemo(),
    );
  }
}

/// A StatefulWidget that maintains state for Slider, Switch, Radio buttons, and DatePicker.
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // State 1: Slider value (default 50.0)
  double _sliderValue = 50.0;

  // State 2: Switch boolean state (default false)
  bool _isMovieActive = false;

  // State 3: Selected genre for Radio buttons (default null / 'None')
  String? _selectedGenre;

  // State 4: Selected Date from showDatePicker (default null)
  DateTime? _selectedDate;

  /// Function to display Flutter's built-in DatePicker modal dialog
  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    // Only update state if the user selected a valid date and the widget is still mounted
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 – Input Controls Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Slider (Rating)
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _sliderValue,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              label: _sliderValue.round().toString(),
              onChanged: (double newValue) {
                // Calling setState triggers a rebuild of the widget with the new value
                setState(() {
                  _sliderValue = newValue;
                });
              },
            ),
            Text(
              'Current value: ${_sliderValue.toInt()}',
              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
            ),
            const SizedBox(height: 24.0),

            // Section 2: Switch (Active Status)
            const Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Is movie active?',
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                ),
                Switch(
                  value: _isMovieActive,
                  onChanged: (bool value) {
                    setState(() {
                      _isMovieActive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Section 3: RadioListTile Group (Genre Selection)
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Action'),
              value: 'Action',
              // ignore: deprecated_member_use
              groupValue: _selectedGenre,
              // ignore: deprecated_member_use
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Comedy'),
              value: 'Comedy',
              // ignore: deprecated_member_use
              groupValue: _selectedGenre,
              // ignore: deprecated_member_use
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            Text(
              'Selected genre: ${_selectedGenre ?? "None"}',
              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
            ),
            const SizedBox(height: 28.0),

            // Section 4: DatePicker trigger button & display
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: () => _pickDate(context),
                child: Text(
                  _selectedDate == null
                      ? 'Open Date Picker'
                      : 'Picked: ${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
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
