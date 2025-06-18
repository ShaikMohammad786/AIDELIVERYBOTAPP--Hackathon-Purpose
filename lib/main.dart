


import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/accesscode_screen.dart';
import 'screens/bookdelivery_screen.dart';

void main() {
  runApp(const DeliveryRobotAuthApp());
}

class DeliveryRobotAuthApp extends StatelessWidget {
  const DeliveryRobotAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Delivery Robot Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF181A20),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/payment': (_) => const PaymentScreen(),
        '/accesscode': (_) => const AccessCodeScreen(),
        '/bookdelivery': (_) => const BookDeliveryScreen(),
      },
    );
  }
}