import 'package:bookmate/screens/dashboardbuku.dart';
import 'package:bookmate/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
                    )),
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
                    builder: (context) => HomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text('Match'),
            // Bagian redirection ke MATCH
            // onTap: () {
            //   Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const (),
            //       ));
            // },
          ),
          ListTile(
            leading: const Icon(Icons.library_add_outlined),
            title: const Text('Book Review'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDashboard(),
                  ));
            },
            // Bagian redirection ke BOOK REVIEW
            // onTap: () {
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ShopFormPage()),
            // );
            // },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('Book Request'),
            // Bagian redirection ke BOOK REQUEST
            // onTap: () {
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ShopFormPage()),
            // );
            // },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            // Bagian redirection ke PROFILE
            // onTap: () {
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ShopFormPage()),
            // );
            // },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
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
