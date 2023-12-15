import 'package:bookmate/widgets/app_bar.dart';
import 'package:bookmate/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
    @override
    Widget build(BuildContext context) {
        return Scaffold(
      appBar: 
      PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBarWidget(),
      ),
      // AppBar(
      //   title: const Text(
      //     'Bookmate',
      //   ),
      //   backgroundColor: Colors.indigo,
      //   foregroundColor: Colors.white,
      // ),
      // Masukkan drawer sebagai parameter nilai drawer dari widget Scaffold
      // endDrawer: const RightDrawer(),
      bottomNavigationBar: NavBar(),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              // const Padding(
              //   padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              //   // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
              //   child: Text(
              //     // 'Game Inventory', // Text yang menandakan toko
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                
              ),
            ],
          ),
        ),
      ),
    );
    }
}
