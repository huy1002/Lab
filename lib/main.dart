import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
/// Self-contained to run in DartPad, Android Studio, and VS Code.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form with Validation & Good UX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
      home: const SignupScreen(),
    );
  }
}

/// Password strength levels for bonus indicator
enum PasswordStrength { none, weak, medium, strong }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ===========================================================================
  // LAB 7.1 & 7.2: GlobalKey for FormState and Text Controllers
  // ===========================================================================
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ===========================================================================
  // LAB 7.3: Focus Nodes for Keyboard & Focus Management
  // ===========================================================================
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // ===========================================================================
  // UI & UX State Variables
  // ===========================================================================
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isCheckingEmail = false; // Lab 7.4: Async validation state
  bool _agreeToTerms = false; // Bonus: Terms & conditions checkbox
  bool _termsError = false;

  PasswordStrength _passwordStrength = PasswordStrength.none;

  @override
  void initState() {
    super.initState();
    // Listen to password changes to calculate password strength in real time
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes to avoid memory leaks
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  // ===========================================================================
  // LAB 7.2: Standalone Validation Functions
  // ===========================================================================

  /// Validates Full Name (Required, minimum 2 characters)
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates Email (Required, format check with @ and .)
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    // Check required @ and . symbols
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Email must contain both @ and . characters';
    }
    // Standard email pattern check
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address (e.g., alex@example.com)';
    }
    return null;
  }

  /// Validates Password (Required, >= 8 chars, >= 1 digit)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit (0-9)';
    }
    return null;
  }

  /// Validates Confirm Password (Required, must match Password)
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ===========================================================================
  // Bonus: Password Strength Evaluation
  // ===========================================================================
  void _updatePasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      if (_passwordStrength != PasswordStrength.none) {
        setState(() => _passwordStrength = PasswordStrength.none);
      }
      return;
    }

    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    PasswordStrength newStrength;
    if (score <= 1) {
      newStrength = PasswordStrength.weak;
    } else if (score == 2 || score == 3) {
      newStrength = PasswordStrength.medium;
    } else {
      newStrength = PasswordStrength.strong;
    }

    if (newStrength != _passwordStrength) {
      setState(() => _passwordStrength = newStrength);
    }
  }

  // ===========================================================================
  // LAB 7.1, 7.3, & 7.4: Submit Handler & Async Validation
  // ===========================================================================
  Future<void> _submitForm() async {
    // LAB 7.3: Dismiss keyboard when initiating submission
    FocusScope.of(context).unfocus();

    // Check Terms and Conditions
    if (!_agreeToTerms) {
      setState(() => _termsError = true);
    } else {
      setState(() => _termsError = false);
    }

    // Step 1: Validate synchronous form inputs
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || !_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Save fields
    _formKey.currentState!.save();

    // Step 2 (Lab 7.4): Perform Asynchronous Email Check
    setState(() {
      _isCheckingEmail = true;
    });

    // Simulate backend network latency (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final emailInput = _emailController.text.trim().toLowerCase();

    // Check if email starts with "taken" (simulated duplicate email check)
    if (emailInput.startsWith('taken')) {
      setState(() {
        _isCheckingEmail = false;
      });

      // Show error feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The email "$emailInput" is already taken. Please try another.',
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );

      // Re-focus the email field for good UX
      _emailFocusNode.requestFocus();
      return;
    }

    // Success: Email available, form is completely valid
    setState(() {
      _isCheckingEmail = false;
    });

    // Show success dialog
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 54,
          ),
          title: const Text(
            'Registration Successful!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your account has been created with the following details:',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.person,
                'Full Name',
                _fullNameController.text.trim(),
              ),
              const SizedBox(height: 6),
              _buildDetailRow(
                Icons.email,
                'Email',
                _emailController.text.trim(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Email is verified & available.',
                        style: TextStyle(color: Colors.green, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _resetForm();
              },
              child: const Text('Register Another Account'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _agreeToTerms = false;
      _termsError = false;
      _passwordStrength = PasswordStrength.none;
    });
  }

  // ===========================================================================
  // Build Methods
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    // LAB 7.3: GestureDetector wraps entire screen to dismiss keyboard on tap outside
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset Form',
              onPressed: _isCheckingEmail ? null : _resetForm,
            ),
          ],
        ),
        // LAB 7.3: SingleChildScrollView avoids bottom overflow when keyboard opens
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                // LAB 7.2: Live feedback as the user types
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card / Welcome text
                    Card(
                      elevation: 0,
                      color: Colors.indigo.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.indigo,
                              child: Icon(
                                Icons.person_add_alt_1,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create New Account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Fill in the fields below to register',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // =========================================================
                    // 1. FULL NAME FIELD
                    // =========================================================
                    TextFormField(
                      key: const Key('full_name_field'),
                      controller: _fullNameController,
                      focusNode: _fullNameFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'e.g., Jane Doe',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: _validateFullName,
                      onFieldSubmitted: (_) {
                        // Focus moving: Name -> Email
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),

                    // =========================================================
                    // 2. EMAIL FIELD (With Async note)
                    // =========================================================
                    TextFormField(
                      key: const Key('email_field'),
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Email Address *',
                        hintText: 'e.g., jane@example.com',
                        prefixIcon: Icon(Icons.email_outlined),
                        helperText:
                            'Tip: Emails starting with "taken" will simulate already taken.',
                        helperMaxLines: 2,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      onFieldSubmitted: (_) {
                        // Focus moving: Email -> Password
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),

                    // =========================================================
                    // 3. PASSWORD FIELD (With strength indicator & show/hide)
                    // =========================================================
                    TextFormField(
                      key: const Key('password_field'),
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password *',
                        hintText: 'At least 8 chars & 1 digit',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: _validatePassword,
                      onFieldSubmitted: (_) {
                        // Focus moving: Password -> Confirm Password
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocusNode);
                      },
                    ),
                    const SizedBox(height: 8),

                    // Bonus: Password strength indicator bar
                    _buildPasswordStrengthIndicator(),

                    const SizedBox(height: 16),

                    // =========================================================
                    // 4. CONFIRM PASSWORD FIELD (With show/hide & Done action)
                    // =========================================================
                    TextFormField(
                      key: const Key('confirm_password_field'),
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password *',
                        hintText: 'Re-enter your password',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          tooltip: _obscureConfirmPassword
                              ? 'Show password'
                              : 'Hide password',
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      validator: _validateConfirmPassword,
                      onFieldSubmitted: (_) {
                        // Last field: Trigger submission
                        if (!_isCheckingEmail) {
                          _submitForm();
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // =========================================================
                    // Bonus: Terms & Conditions Checkbox
                    // =========================================================
                    Row(
                      children: [
                        Checkbox(
                          key: const Key('terms_checkbox'),
                          value: _agreeToTerms,
                          onChanged: (val) {
                            setState(() {
                              _agreeToTerms = val ?? false;
                              if (_agreeToTerms) _termsError = false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreeToTerms = !_agreeToTerms;
                                if (_agreeToTerms) _termsError = false;
                              });
                            },
                            child: const Text(
                              'I agree to the Terms & Conditions and Privacy Policy *',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_termsError)
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0, bottom: 8.0),
                        child: Text(
                          'You must accept the Terms & Conditions to register.',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // =========================================================
                    // SUBMIT BUTTON (With loading indicator for Lab 7.4)
                    // =========================================================
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        key: const Key('submit_button'),
                        onPressed: _isCheckingEmail ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.indigo.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isCheckingEmail
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Checking email...',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Bonus: Password Strength Visual Indicator Widget
  // ===========================================================================
  Widget _buildPasswordStrengthIndicator() {
    if (_passwordStrength == PasswordStrength.none) {
      return const SizedBox.shrink();
    }

    Color barColor;
    String strengthText;
    double progress;

    switch (_passwordStrength) {
      case PasswordStrength.weak:
        barColor = Colors.red;
        strengthText = 'Weak (add numbers, letters, symbols)';
        progress = 0.33;
        break;
      case PasswordStrength.medium:
        barColor = Colors.orange;
        strengthText = 'Medium (good password)';
        progress = 0.66;
        break;
      case PasswordStrength.strong:
        barColor = Colors.green;
        strengthText = 'Strong (excellent!)';
        progress = 1.0;
        break;
      case PasswordStrength.none:
        barColor = Colors.transparent;
        strengthText = '';
        progress = 0.0;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Strength: $strengthText',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: barColor,
            ),
          ),
        ],
      ),
    );
  }
}
