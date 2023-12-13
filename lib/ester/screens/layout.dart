import 'package:flutter/material.dart';
import 'package:bookmate/ester/screens/home.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    const fgColor = Colors.white;
    const bgColor = Color(0xFFC44B6A);
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: fgColor,
    );
    Image appLogo = Image.asset(
      "assets/images/app-logo.png",
      fit: BoxFit.contain,
      height: 72,
    );

    return Scaffold(
        // appBar: AppBar(
        //   title: appLogo,
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   automaticallyImplyLeading: false, // remove back button
        //   actions: <Widget>[
        //     IconButton(
        //       icon: const Icon(Icons.add_alert),
        //       tooltip: 'Show Snackbar',
        //       onPressed: () {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //             const SnackBar(content: Text('This is a snackbar')));
        //       },
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.navigate_next),
        //       tooltip: 'Go to the next page',
        //       onPressed: () {
        //         Navigator.push(context, MaterialPageRoute<void>(
        //           builder: (BuildContext context) {
        //             return Scaffold(
        //               appBar: AppBar(
        //                 title: const Text('Next page'),
        //               ),
        //               body: const Center(
        //                 child: Text(
        //                   'This is the next page',
        //                   style: TextStyle(fontSize: 24),
        //                 ),
        //               ),
        //             );
        //           },
        //         ));
        //       },
        //     ),
        //   ],
        // ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_rounded),
              selectedIcon: Icon(Icons.list_alt_rounded),
              label: 'Match',
            ),
            NavigationDestination(
              icon: Icon(Icons.library_add_outlined),
              selectedIcon: Icon(Icons.library_add_outlined),
              label: 'Review',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book_outlined),
              label: 'Request',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: <Widget>[
          const HomePage(),
          // TODO: Add other pages here
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Match',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Review',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Request',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Profile',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ][currentPageIndex]);
  }
}
