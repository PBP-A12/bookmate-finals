import 'package:flutter/material.dart';
import 'package:bookmate/screens/login.dart';
import 'package:bookmate/screens/register.dart';
import 'package:bookmate/ester/widgets/primary_button.dart';
import 'package:bookmate/ester/widgets/secondary_button.dart';
// import 'package:bookmate/theme.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container (
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/app-logo.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                child: const Column(children: [
                  Text("BookMate", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xFFC44B6A))),
                  Text("Temukan cinta di halaman buku anda", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: const Color(0xFFC44B6A))),
                ]),
              ),
              Column( // center this 
                children: [
                  PrimaryButton(text: "Login", onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                  ),
                  SecondaryButton(text: 'Register', onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    },
                  ),

                  //   onPressed: () {
                  //     Navigator.pushNamed(context, '/login');
                  //   },
                  //   child: const Text('Login'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, '/register');
                  //   },
                  //   child: const Text('Register'),
                  // ),
                ],
              )
            ],
        )));
  }
}
