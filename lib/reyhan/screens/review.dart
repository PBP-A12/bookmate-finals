import 'dart:convert';

import 'package:bookmate/reyhan/models/book_review.dart';
import 'package:bookmate/reyhan/screens/addreview.dart';
import 'package:flutter/material.dart';
import 'package:bookmate/reyhan/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:bookmate/globals.dart' as globals;

class DetailReviewPage extends StatefulWidget {
  final Book book;
  const DetailReviewPage({Key? key, required this.book}) : super(key: key);

  @override
  State<DetailReviewPage> createState() => _DetailReviewPage();
}

class _DetailReviewPage extends State<DetailReviewPage> {
  Future<List<Review>> fetchReview(int id) async {
    var url = Uri.parse('${globals.domain}/review/get-review/$id/');
    // var http;
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Review
    List<Review> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    return listReview;
  }

  Future<List<Review>>? _review;
  int id = 0;
  @override
  Widget build(BuildContext context) {
    id = widget.book.id;
    _review = fetchReview(id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Detail'),
        backgroundColor: const Color(0xFFC44B6A),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _review = fetchReview(id);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Book Title
              Center(
                child: Text(
                  widget.book.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0), // Add some spacing

              // Add Review Button
              ElevatedButton(
                onPressed: () {
                  // Add functionality to navigate to the "Add Review" screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddReview(
                        book: widget.book,
                      ),
                    ),
                  ).then((value) => setState(() {
                        _review = fetchReview(id);
                      }));
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFC44B6A), // Pink background color
                ),
                child: const Text(
                  'Add Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20.0), // Add some spacing

              // User Reviews
              FutureBuilder(
                future: _review,
                builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Create rows for user reviews
                    List<Widget> rows = [];
                    for (int i = 0; i < snapshot.data!.length; i += 2) {
                      List<Widget> reviewsInRow = [];
                      for (int j = i;
                          j < i + 2 && j < snapshot.data!.length;
                          j++) {
                        var review = snapshot.data![j];
                        reviewsInRow.add(
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: Colors.white, // Pure white background
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.black, // Black border
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black, blurRadius: 2.0),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    "${review.review}",
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${review.reviewerAccountUsername}",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      rows.add(Row(children: reviewsInRow));
                    }

                    return Column(
                      children: rows,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
