import 'dart:convert';
import 'package:bookmate/reyhan/models/book.dart';
import 'package:bookmate/reyhan/models/book_review.dart';
import 'package:bookmate/reyhan/screens/dashboardbuku.dart';
import 'package:bookmate/ester/screens/home.dart';
import 'package:bookmate/reyhan/screens/review.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmate/globals.dart' as globals;

class AddReview extends StatefulWidget {
  final Book book;
  // final Future<List<Review>> review;
  const AddReview({Key? key, required this.book})
      : super(key: key);

  @override
  State<AddReview> createState() => _AddReview();
}

class _AddReview extends State<AddReview> {
  final _formKey = GlobalKey<FormState>();
  String _review = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Your Review 💓',
          ),
        ),
        backgroundColor: Color(0xFFC44B6A),
        foregroundColor: Colors.white,
      ),
     
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Tambah Review",
                    labelText: "Tambah Review",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _review = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Back and Save Buttons Side by Side
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: const Text(
                  //     'Back',
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Color(0xFFC44B6A)),
                    ),
                  ),
                  SizedBox(width: 16), // Adjust the distance between buttons
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFC44B6A)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "${globals.domain}/review/add-review-flutter/",
                          jsonEncode(<String, String>{
                            'id': widget.book.id.toString(),
                            'review': _review,
                          }),
                        );
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Produk baru berhasil disimpan!"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailReviewPage(
                                book: widget.book,                                
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Terdapat kesalahan, silakan coba lagi.",
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
