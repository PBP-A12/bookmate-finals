// To parse this JSON data, do
//
//     final bookRequest = bookRequestFromJson(jsonString);

import 'dart:convert';

List<BookRequest> bookRequestFromJson(String str) => List<BookRequest>.from(json.decode(str).map((x) => BookRequest.fromJson(x)));

String bookRequestToJson(List<BookRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookRequest {
    int id;
    List<String> subjects;
    String member;
    String title;
    String author;
    int year;
    String language;
    DateTime dateRequested;

    BookRequest({
        required this.id,
        required this.subjects,
        required this.member,
        required this.title,
        required this.author,
        required this.year,
        required this.language,
        required this.dateRequested,
    });

    factory BookRequest.fromJson(Map<String, dynamic> json) => BookRequest(
        id: json["id"],
        subjects: List<String>.from(json["subjects"].map((x) => x)),
        member: json["member"],
        title: json["title"],
        author: json["author"],
        year: json["year"],
        language: json["language"],
        dateRequested: DateTime.parse(json["date_requested"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
        "member": member,
        "title": title,
        "author": author,
        "year": year,
        "language": language,
        "date_requested": dateRequested.toIso8601String(),
    };
}
