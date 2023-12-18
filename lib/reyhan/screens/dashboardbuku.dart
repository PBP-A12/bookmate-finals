import 'package:bookmate/reyhan/models/book_review.dart';
import 'package:bookmate/reyhan/screens/review.dart';
import 'package:flutter/material.dart';
import 'package:bookmate/reyhan/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookmate/globals.dart' as globals;

class BookDashboard extends StatefulWidget {
  const BookDashboard({Key? key}) : super(key: key);

  @override
  State<BookDashboard> createState() => _BookDashboardState();
}

class _BookDashboardState extends State<BookDashboard> {
  Future<List<Book>> fetchProduct(String judul) async {
    var url;
    if (judul == "") {
      url = Uri.parse('${globals.domain}/api/books/');
    } else {
      url = Uri.parse('${globals.domain}/review/search-flutter/$judul/');
    }
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    // print(response.body);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Book.fromJson(d));
      }
    }
    return listProduct;
  }

  Future<List<Review>> fetchReview(int id) async {
    var url = Uri.parse('${globals.domain}/review/get-review/$id/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Review> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    return listReview;
  }

  String judul = "";

  @override
  Widget build(BuildContext context) {
    Future<List<Review>> listReview;
    return ListView(children: [
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
      SingleChildScrollView(
        child: FutureBuilder(
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
                return GridView.builder(
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
                            "Genre: ${snapshot.data![index].subjects.join(',')}",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC44B6A),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                            onPressed: () {
                              print(
                                  'Add Review clicked: ${snapshot.data![index].title}');
                              listReview = fetchReview(snapshot.data![index].id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailReviewPage(
                                    book: snapshot.data![index],                                  
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Add Review',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          },
        )),
    ]);
  }
}
