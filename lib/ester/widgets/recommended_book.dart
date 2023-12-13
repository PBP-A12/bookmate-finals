import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookmate/ester/models/book.dart';

class RecommendedBook extends StatefulWidget {
  const RecommendedBook({Key? key}) : super(key: key);

  @override
  State<RecommendedBook> createState() => _RecommendedBookState();
}

class _RecommendedBookState extends State<RecommendedBook> {
  Future<Book> fetchBook() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse("http://127.0.0.1:8000/api/books/random/");
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
    return Container(
      height: 400.00,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      ),
      child: FutureBuilder(
        future: fetchBook(),
        builder: (BuildContext context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(
                  snapshot.data!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Text(snapshot.data!.author),
                Text(snapshot.data!.subjects.join(", ")),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
