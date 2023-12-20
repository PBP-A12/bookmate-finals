import 'dart:convert';
import 'package:bookmate/reyhan/models/book_review.dart';
import 'package:bookmate/globals.dart' as globals;
import 'package:http/http.dart' as http;

Future<List<Review>> fetchReview(int id) async {
  // print("manggil id ini $id");
  var url = Uri.parse('${globals.domain}/review/get-review/$id/');
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
