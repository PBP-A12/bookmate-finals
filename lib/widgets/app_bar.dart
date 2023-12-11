import 'package:flutter/material.dart';

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
      fit: BoxFit.contain,
      height: 72,
    );


    return 
        AppBar(
          title: appLogo,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false, // remove back button
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_alert),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Next page'),
                      ),
                      body: const Center(
                        child: Text(
                          'This is the next page',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        );
  }
}
