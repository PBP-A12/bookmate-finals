import 'package:bookmate/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bookmate/ester/widgets/recommended_book.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;
  String username = "asteriskzie";

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        SizedBox(
          height: 200.00,
          child: Center(child: Text("Halo $username!")),
        ),
        RecommendedBook(),        
      ],
    );
  }
}
