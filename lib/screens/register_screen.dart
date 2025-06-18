import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = Uri.parse('http://10.0.2.2:8000/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _nameC.text.trim(),
          'email': _emailC.text.trim(),
          'password': _passC.text,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Registration Success!'),
            content: const Text('You have registered successfully. You can now login.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        final msg = jsonDecode(response.body)['detail'] ?? 'Registration failed.';
        setState(() {
          _error = msg;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/robot_register.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Account 🤖",
                      style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Register to get started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 26),
                    TextField(
                      controller: _nameC,
                      decoration: const InputDecoration(
                        hintText: "Full Name",
                        prefixIcon: Icon(Icons.person, color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email_rounded, color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passC,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_rounded, color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 15)),
                      ),
                    const SizedBox(height: 22),
                    AnimatedButton(
                      text: "Register",
                      loading: _loading,
                      onPressed: _register,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}