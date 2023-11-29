// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  String title;
  String author;
  int year;

  Review({
    required this.title,
    required this.author,
    required this.year,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        title: json["title"],
        author: json["author"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "year": year,
      };
}
