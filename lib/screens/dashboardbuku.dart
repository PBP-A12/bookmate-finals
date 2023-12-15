import 'package:bookmate/models/book_review.dart';
import 'package:bookmate/screens/review.dart';
import 'package:bookmate/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bookmate/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookDashboard extends StatefulWidget {
  const BookDashboard({Key? key}) : super(key: key);

  @override
  _BookDashboardState createState() => _BookDashboardState();
}

class _BookDashboardState extends State<BookDashboard> {
  Future<List<Books>> fetchProduct(String judul) async {
    var url;
    if (judul == "") {
      url = Uri.parse('http://10.0.2.2:8000/api/books');
    } else {
      url = Uri.parse('http://10.0.2.2:8000/review/search-flutter/$judul/');
    }

    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    // print(response.body);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Books> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Books.fromJson(d));
      }
    }
    return list_product;
  }

  Future<List<Review>> fetchReview(int id) async {
    var url = Uri.parse('http://localhost:8000/review/get-review/$id/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Review> list_review = [];
    for (var d in data) {
      if (d != null) {
        list_review.add(Review.fromJson(d));
      }
    }
    return list_review;
  }

  String judul = "";

  @override
  Widget build(BuildContext context) {
    Future<List<Review>> list_review;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.7, // Adjust the width as needed
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (value) {
                  // Implement search functionality here
                  setState(() {
                    judul = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      drawer: RightDrawer(),
      body: FutureBuilder(
        future: fetchProduct(judul),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada data produk.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return SingleChildScrollView(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 4 : 1,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 0.0, // Set elevation to 0.0 to remove the shadow
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey.shade900, // Darker border
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${snapshot.data![index].title}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${snapshot.data![index].author}",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${snapshot.data![index].subjects}",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFC44B6A),
                              side: BorderSide(color: Colors.transparent),
                            ),
                            onPressed: () {
                              print(
                                  'Add Review clicked: ${snapshot.data![index].title}');
                              list_review =
                                  fetchReview(snapshot.data![index].id);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailReviewPage(
                                    book: snapshot.data![index],
                                    review: list_review,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Add Review',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
