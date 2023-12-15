import 'dart:convert';
import 'package:bookmate/reyhan/models/book_review.dart';
import 'package:bookmate/globals.dart' as globals;

Future<List<Review>> fetchReview(int id) async {
  print("manggil id ini $id");
  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
  var url = Uri.parse('${globals.domain}/review/get-review/$id/');
  var http;
  var response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  // melakukan decode response menjadi bentuk json
  var data = jsonDecode(utf8.decode(response.bodyBytes));

  // melakukan konversi data json menjadi object Review
  List<Review> list_review = [];
  for (var d in data) {
    print(d);
    if (d != null) {
      list_review.add(Review.fromJson(d));
    }
  }
  return list_review;
}
