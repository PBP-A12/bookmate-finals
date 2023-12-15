import 'package:bookmate/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:bookmate/screens/match.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
            color: Color(0xFFB6536B), 
          ),
          child: Column(
            children: [
              Text(
                'Bookmate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Text("",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  )
                  ),
            ],
          ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Bagian redirection ke HOME
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
          ),
          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            // Bagian redirection ke PROFILE
            // onTap: () {
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ShopFormPage()),
            // );
            // },
          ),
          const ListTile(
            leading: Icon(Icons.reviews_outlined),
            title: Text('Book Review'),
            // Bagian redirection ke BOOK REVIEW
            // onTap: () {
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ShopFormPage()),
            // );
            // },
          ),
          const ListTile(
            leading: Icon(Icons.my_library_add_outlined),
            title: Text('Book Request'),
            // Bagian redirection ke BOOK REQUEST
            // onTap: () {
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ShopFormPage()),
            // );
            // },
          ),

          ListTile(
            leading: const Icon(Icons.diversity_1_outlined),
            title: const Text('Match'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchPage(), // Remove the 'const' keyword
                ),
              );
            },
          ),          
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            // Bagian redirection ke LoginPage
            // onTap: () async {
            //   final response = await request.logout(
            //     "http://:)/");
            //     String message = response["message"];
            //     if (response['status']) {
            //       String uname = response["username"];
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //         content: Text("$message Sampai jumpa, $uname."),
            //       ));
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(builder: (context) => const LoginPage()),
            //       );
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //         content: Text("$message"),
            //       ));
            //     }
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const LoginPage(),
            //           ));
            //     },
              )
        ],
      ),
    );
  }
}