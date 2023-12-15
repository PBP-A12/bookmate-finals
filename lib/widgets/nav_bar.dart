import 'package:bookmate/main.dart';
import 'package:bookmate/screens/home.dart';
import 'package:bookmate/screens/request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:bookmate/ester/screens/home.dart';



class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);
    currentPageIndex = navigationProvider.getCurrentIndex();
    // const fgColor = Colors.white;
    // const bgColor = Color(0xFFC44B6A);
    // const textStyle = TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.bold,
    //   color: fgColor,
    // );

    return 
        NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              print(index);
              // currentPageIndex = index;
              navigationProvider.setIndex(index);
              currentPageIndex = navigationProvider.getCurrentIndex();
              if (index == 0){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
              }
              else if (index == 1){
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => Match(),
              //     ));
              }
              else if (index == 2){
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => HomePage(),
              //     ));
              }
              else if (index == 3){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestPage(),
                  ));
              }
              else if (index == 4){
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => HomePage(),
              //     ));
              }
            });
          },
          indicatorColor: Color(0xFFC44B6A),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Colors.white,),
              label: 'Home',

            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline_sharp),
              selectedIcon: Icon(Icons.favorite, color: Colors.white,),
              label: 'Match',
            ),
            NavigationDestination(
                icon: Icon(Icons.rate_review_outlined),
              selectedIcon: Icon(Icons.rate_review, color: Colors.white,),
              label: 'Review',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book, color: Colors.white,),
              label: 'Request',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: Colors.white,),
              label: 'Profile',
            ),
          ],
          
        );
        // body: <Widget>[
        //   // const HomePage(),
        //   Container(
        //     alignment: Alignment.center,
        //     child: const Text(
        //       'Match',
        //       style: TextStyle(fontSize: 24),
        //     ),
        //   ),
        //   Container(
        //     alignment: Alignment.center,
        //     child: const Text(
        //       'Review',
        //       style: TextStyle(fontSize: 24),
        //     ),
        //   ),
        //   Container(
        //     alignment: Alignment.center,
        //     child: const Text(
        //       'Request',
        //       style: TextStyle(fontSize: 24),
        //     ),
        //   ),
        //   Container(
        //     alignment: Alignment.center,
        //     child: const Text(
        //       'Profile',
        //       style: TextStyle(fontSize: 24),
        //     ),
        //   ),
        // ][currentPageIndex]);
  }
}
