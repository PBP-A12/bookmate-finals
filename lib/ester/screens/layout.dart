import 'package:bookmate/azmy/models/profile.dart';
import 'package:bookmate/azmy/screens/profile.dart';
import 'package:bookmate/clarence/widgets/app_bar.dart';
import 'package:bookmate/provider.dart';
import 'package:bookmate/vinka/screens/match.dart';
import 'package:flutter/material.dart';
import 'package:bookmate/ester/screens/home.dart';
import 'package:bookmate/clarence/screens/request.dart';
import 'package:bookmate/reyhan/screens/dashboardbuku.dart';
import 'package:provider/provider.dart'; 

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    LoginUser? loggedInUser = Provider.of<UserProvider>(context).user;
    int? loggedInUserId = loggedInUser?.id;

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          currentPageIndex = 0;
        });
        return false;
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: AppBarWidget(),
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Color(0xFFC44B6A),
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline_sharp),
                selectedIcon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                label: 'Match',
              ),
              NavigationDestination(
                icon: Icon(Icons.rate_review_outlined),
                selectedIcon: Icon(
                  Icons.rate_review,
                  color: Colors.white,
                ),
                label: 'Review',
              ),
              NavigationDestination(
                icon: Icon(Icons.book_outlined),
                selectedIcon: Icon(
                  Icons.book,
                  color: Colors.white,
                ),
                label: 'Request',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: 'Profile',
              ),
            ],
          ),
          body: <Widget>[
            const HomePage(),
            MatchPage(),
            const BookDashboard(),
            const RequestPage(),
            ProfileDashboard(id: loggedInUserId)
          ][currentPageIndex]),
    );
  }
}
