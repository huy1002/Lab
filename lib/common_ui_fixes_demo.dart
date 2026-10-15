import 'package:flutter/material.dart';

/// Exercise 5: Debug & Fix Common UI Errors
///
/// Goal: Understand common layout & state issues and fix them.
/// Covers all 4 tasks required by the lab:
/// 1. Fix ListView inside Column using Expanded (matches reference screenshot).
/// 2. Fix overflow in small screens using SingleChildScrollView.
/// 3. Fix state update issue by adding setState().
/// 4. Fix DatePicker build context errors by calling from valid widget tree.
void main() {
  runApp(const CommonUIFixesApp());
}

/// Standalone MaterialApp wrapper so this exercise can run independently in DartPad,
/// VS Code, or Android Studio.
class CommonUIFixesApp extends StatelessWidget {
  const CommonUIFixesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 5 – Common UI Fixes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CommonUIFixesDemo(),
    );
  }
}

class CommonUIFixesDemo extends StatefulWidget {
  const CommonUIFixesDemo({super.key});

  @override
  State<CommonUIFixesDemo> createState() => _CommonUIFixesDemoState();
}

class _CommonUIFixesDemoState extends State<CommonUIFixesDemo> {
  // Tab index to allow viewing all 4 required debug fixes:
  // 0: Task 1 - ListView inside Column using Expanded (Screenshot default)
  // 1: Task 2 - Overflow fix using SingleChildScrollView
  // 2: Task 3 - State update fix using setState()
  // 3: Task 4 - DatePicker BuildContext fix
  int _selectedTaskIndex = 0;

  // Task 3 demo state
  int _counter = 0;

  // Task 4 demo state
  DateTime? _pickedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Fixes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  _buildTabChip(0, 'Task 1: Expanded'),
                  _buildTabChip(1, 'Task 2: ScrollView'),
                  _buildTabChip(2, 'Task 3: setState'),
                  _buildTabChip(3, 'Task 4: BuildContext'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _buildCurrentTaskView(),
    );
  }

  Widget _buildTabChip(int index, String label) {
    final isSelected = _selectedTaskIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedTaskIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildCurrentTaskView() {
    switch (_selectedTaskIndex) {
      case 0:
        return _buildTask1ExpandedView();
      case 1:
        return _buildTask2ScrollView();
      case 2:
        return _buildTask3StateView();
      case 3:
        return _buildTask4ContextView();
      default:
        return _buildTask1ExpandedView();
    }
  }

  // ===========================================================================
  // TASK 1: Fix ListView inside Column using Expanded (Matches Image 5 directly)
  // ===========================================================================
  /// PROBLEM: A Column gives its children unbounded vertical constraints.
  /// A ListView tries to expand to infinity by default, resulting in:
  /// "Vertical viewport was given unbounded height".
  ///
  /// SOLUTION: Wrap the ListView with an Expanded (or Flexible) widget so
  /// Flutter assigns bounded height equal to the remaining vertical space.
  Widget _buildTask1ExpandedView() {
    final List<String> movies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Correct ListView inside Column using Expanded',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16.0),

          // ListView wrapped in Expanded to fix unbounded height error!
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                  leading: const Icon(
                    Icons.movie,
                    color: Color(0xFF3F4654), // Dark slate icon color
                    size: 26.0,
                  ),
                  title: Text(
                    movies[index],
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),

          // Explanatory note
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Fix applied: Expanded widget tells ListView to take up available height without causing infinite-height errors.',
                    style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TASK 2: Fix overflow in small screens using SingleChildScrollView
  // ===========================================================================
  /// PROBLEM: Placing many vertical widgets in a Column on smaller screens or
  /// with keyboard open causes yellow-and-black stripes:
  /// "A RenderFlex overflowed by XXX pixels".
  ///
  /// SOLUTION: Wrap the Column inside SingleChildScrollView so content can scroll.
  Widget _buildTask2ScrollView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fix Overflow with SingleChildScrollView',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'On smaller screens, vertically stacked widgets overflow the screen boundary. '
            'Wrapping the content in SingleChildScrollView enables smooth scrolling.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          // Multiple demonstration cards that would normally overflow small screens
          for (int i = 1; i <= 6; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                leading: CircleAvatar(child: Text('$i')),
                title: Text('Scrollable Section #$i'),
                subtitle: const Text(
                  'Safely displayed inside SingleChildScrollView',
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TASK 3: Fix state update issue by adding setState()
  // ===========================================================================
  /// PROBLEM: In a StatefulWidget, if you mutate a variable like `counter++`
  /// without calling `setState()`, the internal variable changes but Flutter
  /// does not trigger `build()`, so the UI appears frozen.
  ///
  /// SOLUTION: Wrap state mutations inside `setState(() { ... })`.
  Widget _buildTask3StateView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fix State Updates using setState()',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Flutter widgets only re-render when setState() notifies the framework that the internal state has changed.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Current Counter Value:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Fix: setState notifies Flutter to rebuild with the new value
                      setState(() {
                        _counter++;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Increment with setState()'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TASK 4: Fix DatePicker build context errors
  // ===========================================================================
  /// PROBLEM: Calling `showDatePicker(context: context, ...)` during initState(),
  /// before the widget is inserted into the tree, or across async gaps when the
  /// widget unmounted causes:
  /// "Looking up a deactivated widget's ancestor is unsafe" or context errors.
  ///
  /// SOLUTION:
  /// 1. Trigger pickers from user gestures (e.g. onPressed callbacks).
  /// 2. Use `Builder` or descendant BuildContext with an active Navigator.
  /// 3. Check `if (mounted)` after asynchronous operations before setState().
  Widget _buildTask4ContextView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fix DatePicker BuildContext Hierarchy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'showDatePicker requires a valid BuildContext associated with a Navigator ancestor in the active widget tree.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _pickedDate == null
                        ? 'No date selected yet.'
                        : 'Selected Date: ${_pickedDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Using Builder to guarantee a clean, descendant BuildContext
                  Builder(
                    builder: (BuildContext validContext) {
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Open Valid DatePicker'),
                        onPressed: () async {
                          // Fix: Call showDatePicker with validContext
                          final DateTime? date = await showDatePicker(
                            context: validContext,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );

                          // Fix: Verify widget is still mounted after async wait
                          if (date != null && mounted) {
                            setState(() {
                              _pickedDate = date;
                            });
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
