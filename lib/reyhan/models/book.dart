// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  int id;
  List<String> subjects;
  String title;
  String author;
  int year;

  Book({
    required this.id,
    required this.subjects,
    required this.title,
    required this.author,
    required this.year,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        subjects: List<String>.from(json["subjects"].map((x) => x)),
        title: json["title"],
        author: json["author"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
        "title": title,
        "author": author,
        "year": year,
      };
}
