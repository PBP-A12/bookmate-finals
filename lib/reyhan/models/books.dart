// To parse this JSON data, do
//
//     final books = booksFromJson(jsonString);

import 'dart:convert';

List<Books> booksFromJson(String str) =>
    List<Books>.from(json.decode(str).map((x) => Books.fromJson(x)));

String booksToJson(List<Books> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Books {
  int id;
  List<String> subjects;
  String title;
  String author;
  int year;

  Books({
    required this.id,
    required this.subjects,
    required this.title,
    required this.author,
    required this.year,
  });

  factory Books.fromJson(Map<String, dynamic> json) => Books(
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
