import 'package:bookmate/ester/screens/landing.dart';
import 'package:bookmate/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

final ThemeData myTheme = ThemeData(
  primaryColor: const Color(0xFFC44B6A), // Replace with your hex code
  useMaterial3: true,
  // other theme properties...
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            },
      child: MaterialApp(
        title: 'BookMate',
        theme: myTheme,
        home: const LandingPage(),
      ),
    );
  }
}

