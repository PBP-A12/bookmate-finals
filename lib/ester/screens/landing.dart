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
              const Text("BookMate",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              const Text("Temukan cinta di halaman buku anda!"),
              ButtonBar( // center this 
                children: [
                  PrimaryButton(text: "Login", onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    },
                    child: const Text('Register',
                        style: TextStyle(
                          color: Colors.black,
                        )),
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
