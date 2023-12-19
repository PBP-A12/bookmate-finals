import 'package:bookmate/ester/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmate/globals.dart' as globals;

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}
class _AppBarWidgetState extends State<AppBarWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Image appLogo = Image.asset(
      "assets/images/app-logo.png",
      fit: BoxFit.fitHeight,
      height: 70,
    );
    final request = context.watch<CookieRequest>();
    return 
        AppBar(
          toolbarHeight: 100,
          title: Container(
            padding: const EdgeInsets.only(top: 20 ),
            alignment: Alignment.centerLeft,
            child: appLogo,
          ),
          actions: [
            IconButton(icon: const Icon(Icons.logout,
            color: Colors.black,),
              onPressed: () async {
                final response = await request.logout("${globals.domain}/auth/logout-flutter/");
                if (!context.mounted) return; 
                if (response['status']) {
                String username = response['username'];
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Goodbye, $username! See you soon! 👋')));
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout failed')));
                }
              },
            ),
          ],
          automaticallyImplyLeading: false, // remove back button
        );
  }
}
