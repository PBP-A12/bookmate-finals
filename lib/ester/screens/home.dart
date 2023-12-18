import 'package:bookmate/reyhan/models/book.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bookmate/ester/widgets/recommended_book_card.dart';
import 'package:bookmate/reyhan/screens/review.dart';

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
  var data = [];
  final borderRadius = BorderRadius.circular(24);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blue,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return const RecommendedBookCard();
              },
            );
          }).toList(),
        ));
  }
}