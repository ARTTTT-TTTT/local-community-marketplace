import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/services/firebase_auth_service.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String _status = 'Testing Firebase connection...';
  bool _isLoading = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      // Test Firebase initialization
      await Firebase.initializeApp();

      // Test Firebase Auth instance
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      setState(() {
        _status =
            'Firebase ✅ Connected Successfully!\n\n'
            'Current User: ${currentUser?.email ?? 'Not signed in'}\n'
            'Auth State: ${currentUser != null ? 'Authenticated' : 'Not authenticated'}\n\n'
            'Ready to test authentication!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status =
            'Firebase ❌ Connection Failed!\n\n'
            'Error: ${e.toString()}\n\n'
            'Please check your firebase_options.dart configuration.';
        _isLoading = false;
      });
    }
  }

  Future<void> _testSignUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuthService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _showMessage('Sign up successful! Check your email for verification.');
      _testFirebaseConnection(); // Refresh status
    } catch (e) {
      _showMessage('Sign up failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuthService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _showMessage('Sign in successful!');
      _testFirebaseConnection(); // Refresh status
    } catch (e) {
      _showMessage('Sign in failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testSignOut() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseAuthService.signOut();
      _showMessage('Sign out successful!');
      _testFirebaseConnection(); // Refresh status
    } catch (e) {
      _showMessage('Sign out failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _status,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),

            if (!_isLoading) ...[
              const Text(
                'Test Authentication:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Email field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Test Email',
                  hintText: 'test@example.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              // Password field
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Test Password',
                  hintText: 'Enter password (min 6 chars)',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testSignUp,
                      child: const Text('Test Sign Up'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testSignIn,
                      child: const Text('Test Sign In'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _testSignOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Test Sign Out'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _testFirebaseConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Refresh Status'),
                ),
              ),
            ] else ...[
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
