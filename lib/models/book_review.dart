// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  int pk;
  String reviewerAccountUsername;
  int book;
  String review;

  Review({
    required this.pk,
    required this.reviewerAccountUsername,
    required this.book,
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        pk: json["pk"],
        reviewerAccountUsername: json["reviewer__account__username"],
        book: json["book"],
        review: json["review"],
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "reviewer__account__username": reviewerAccountUsername,
        "book": book,
        "review": review,
      };
}
