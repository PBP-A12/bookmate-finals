import 'dart:convert';

class Book {
  Book({
    required this.id, 
    required this.title, 
    required this.author, 
    required this.subjects
  });

  int id;
  String title;
  String author;
  List<String> subjects;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        subjects: List<String>.from(json['subjects'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'subjects': List<dynamic>.from(subjects.map((x) => x)),
      };
}

Book bookFromJson(String str) => Book.fromJson(json.decode(str));
String bookToJson(Book data) => json.encode(data.toJson());
