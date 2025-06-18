import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = Uri.parse('http://10.0.2.2:5005/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailC.text.trim(),
          'password': _passC.text,
        }),
      );
      if (response.statusCode == 200) {
        // You can parse and save token here if needed!
        // final data = jsonDecode(response.body);
        // e.g. data['token'] and data['user']
        // For now, just go to next screen or show success
        setState(() {
          _loading = false;
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Success!'),
            content: const Text('You have logged in successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/payment');
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        final msg = jsonDecode(response.body)['detail'] ?? 'Login failed.';
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
              'assets/robot_login.json',
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
                      "Welcome Back 🤖",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email_rounded, color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 26),
                    AnimatedButton(
                      text: "Login",
                      loading: _loading,
                      onPressed: _login,
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        "Don't have an account? Register",
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