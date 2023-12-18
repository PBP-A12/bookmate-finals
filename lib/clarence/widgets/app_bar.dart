import 'package:bookmate/ester/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmate/globals.dart' as globals;

// import 'package:bookmate/ester/screens/home.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}
class _AppBarWidgetState extends State<StatefulWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // const fgColor = Colors.white;
    // const bgColor = Color(0xFFC44B6A);
    // const textStyle = TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.bold,
    //   color: fgColor,
    // );
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
            child: appLogo,
            padding: EdgeInsets.only(top: 20 ),
            alignment: Alignment.centerLeft,
          ),
          actions: [
            IconButton(icon: Icon(Icons.logout,
            color: Colors.black,),
              onPressed: () async {
                final response = await request.logout("${globals.domain}/auth/logout-flutter/");
                if (response['status']) {
                String username = response['username'];
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage())
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Goodbye, ${username}! See you soon! 👋')));
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout failed')));
                }
              },
            ),
          ],
          automaticallyImplyLeading: false, // remove back button
        );
  }
}
