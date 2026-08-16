import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class LoRaLinkApp extends StatelessWidget {
  const LoRaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuChat',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),

      home: const SplashScreen(),
    );
  }
}
