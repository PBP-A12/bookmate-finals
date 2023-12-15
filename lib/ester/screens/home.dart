import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bookmate/ester/widgets/recommended_book.dart';

class DummyBook extends StatelessWidget {
  const DummyBook({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Dummy Book Page"),
      ),
      body: const Text("This is the page for book review"),
    );
  }
}

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
                return Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DummyBook()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          // decoration: BoxDecoration(color: Colors.amber),
                          padding: const EdgeInsets.all(8.00),
                          child: const Center(child: RecommendedBook()),
                        )));
              },
            );
          }).toList(),
        ));
  }
}
