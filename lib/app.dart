import 'package:flutter/material.dart';
import 'screens/username_screen.dart';

class LoRaLinkApp extends StatelessWidget {
  const LoRaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoRaLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const UsernameScreen(),
    );
  }
}
