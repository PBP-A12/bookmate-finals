import 'package:flutter/material.dart';
import 'package:bookmate/ester/screens/login.dart';
import 'package:bookmate/ester/screens/register.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 200,
                width: 200,
                child: Column(children: [
                  Image(image: AssetImage('assets/images/app-logo.png')),
                  // Text("Temukan Cinta di Halaman Buku Anda!",
                  //   textAlign:TextAlign.center,
                  //   style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFC44B6A))
                  // ),
                ]),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 12.00), 
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                child: const Text('Register'),
              ),
            ],
          )),
    );
  }
}
