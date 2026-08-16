import 'dart:async';

import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF42A5F5),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons.chat_rounded,
                        size: 58,
                        color: Color(0xFF1565C0),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "SuChat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Private communication, anywhere.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 45),

              const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Starting SuChat...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}