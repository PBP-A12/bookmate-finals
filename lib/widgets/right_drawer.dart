import 'package:bookmate/ester/screens/home.dart';
import 'package:flutter/material.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
            color: Colors.indigo,
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
            leading: Icon(Icons.list_alt_rounded),
            title: Text('Match'),
            // Bagian redirection ke MATCH
            // onTap: () {
            //   Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const (),
            //       ));
            // },
          ),
          const ListTile(
            leading: Icon(Icons.library_add_outlined),
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
            leading: Icon(Icons.book_outlined),
            title: Text('Book Request'),
            // Bagian redirection ke BOOK REQUEST
            // onTap: () {
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ShopFormPage()),
            // );
            // },
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