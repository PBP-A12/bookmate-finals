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
          padding: const EdgeInsets.all(16.00),
          child: const Center(
              child: Image(image: AssetImage('assets/images/app-logo.png'), width: 196.0, height: 120.0)),
        ),
      ),
    );
  }
}
