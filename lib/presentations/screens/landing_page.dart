import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/user_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedUserType;
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.setUser(
        userCredential.user!,
        userType: _selectedUserType ?? 'athlete',
      );

      if (userProvider.user!.userType?.toLowerCase() !=
          _selectedUserType?.toLowerCase()) {
        await userProvider.clearUser();
        throw FirebaseAuthException(
          code: 'user-type-mismatch',
          message: 'This account is not registered as $_selectedUserType',
        );
      }

      // 5. Navigate based on user type
      if (_selectedUserType == 'Athlete') {
        Navigator.pushReplacementNamed(context, '/splash');
      } else if (_selectedUserType == 'Organization') {
        Navigator.pushReplacementNamed(context, '/organization');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to AthleteVerse'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) return 'Password too short';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedUserType,
                    items: const [
                      DropdownMenuItem(
                        value: 'Athlete',
                        child: Text('Athlete'),
                      ),
                      DropdownMenuItem(
                        value: 'Organization',
                        child: Text('Organization'),
                      ),
                      DropdownMenuItem(value: 'Coach', child: Text('Coach')),
                    ],
                    onChanged:
                        (value) => setState(() => _selectedUserType = value),
                    decoration: const InputDecoration(
                      labelText: 'User Type',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) => value == null ? 'Select user type' : null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
