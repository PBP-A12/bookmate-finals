import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookmate/reyhan/models/book.dart';
import 'package:bookmate/globals.dart' as globals;
import 'package:bookmate/reyhan/screens/review.dart';

class RecommendedBookCard extends StatefulWidget {
  const RecommendedBookCard({Key? key}) : super(key: key);

  @override
  State<RecommendedBookCard> createState() => _RecommendedBookCardState();
}

class _RecommendedBookCardState extends State<RecommendedBookCard> {
  Future<Book> fetchBook() async {
    var url = Uri.parse("${globals.domain}/api/books/random/");
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Book
    Book result = Book.fromJson(data);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchBook(),
        builder: (BuildContext context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.hasData) {
            return Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailReviewPage(
                            book: snapshot.data!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        // decoration: BoxDecoration(color: Colors.amber),
                        padding: const EdgeInsets.all(8.00),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(snapshot.data!.author,
                                  textAlign: TextAlign.center),
                              // Text(snapshot.data!.subjects.join(", ")),
                            ],
                          ),
                        ))));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
