import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
    return MaterialApp(
      home: Scaffold(
        body: Container(
          // TODO: Add your splash screen UI components here
          padding: const EdgeInsets.all(16.00),
          child: const Center(
              child: Image(image: AssetImage('assets/images/app-logo.png'))),
        ),
      ),
    );
  }
}
