import 'dart:convert';

import 'package:bookmate/models/book_request.dart';
import 'package:bookmate/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class RequestPage extends StatefulWidget {
    const RequestPage({Key? key}) : super(key: key);

    @override
    _RequestsPageState createState() => _RequestsPageState();
}
class _RequestsPageState extends State<RequestPage> {
Future<List<BookRequest>>? _future;
  Future<List<BookRequest>> fetchAllRequest(CookieRequest request) async {
    final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/request/get-requests_json'),
    headers: request.headers,
    );
    // Perform error handling for the response
      if (response.statusCode == 200) {
        // Decode the response body
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        // Convert the JSON data to a list of Product objects
        List<BookRequest> my_request_list = [];
        for (var d in data) {
          if (d != null) {
            my_request_list.add(BookRequest.fromJson(d));
          }
        }
        return my_request_list;
      } else {
        throw Exception('Failed to fetch products');
      }
  }
  Future<List<BookRequest>> fetchUserRequest(CookieRequest request) async {
    final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/request/get-request_json_user'),
    headers: request.headers,
    );
    // Perform error handling for the response
      if (response.statusCode == 200) {
        // Decode the response body
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        // Convert the JSON data to a list of Product objects
        List<BookRequest> user_request_list = [];
        for (var d in data) {
          if (d != null) {
            print(d.toString()+ " ini d");
            user_request_list.add(BookRequest.fromJson(d));
          }
        }
        // print(user_request_list);
        return user_request_list;
      } else {
        throw Exception('Failed to fetch products');
      }
  }

 @override
  Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Inventory List'),
      ),
      endDrawer: const RightDrawer(),
      body: FutureBuilder(
        future: fetchUserRequest(request),
        
        builder: (context, AsyncSnapshot snapshot){
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(24), // adjust padding as needed
              foregroundColor: const Color(0xff59A5D8),
            ),
            onPressed: () {
              // handle button press
            },
            child: const Icon(Icons.add), // use the 'add' icon
          );
          print(request);
          // return Container();
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'No Games Found',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                ],
              );
            } else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromARGB(255,0,145,255),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Column 1
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data![index].title, 
                                  style: const TextStyle(fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                                  Text('Author: ${snapshot.data![index].author}', style: const TextStyle(fontSize: 18)),
                                  Text('Year: ${snapshot.data![index].year}', style: const TextStyle(fontSize: 18)),
                                  Text('Genre: ${snapshot.data![index].subjects}', style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                            // Column 2
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                                    ),
                                    child: Text('Edit', style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      // Navigate to the edit page or perform the edit operation
                                    },
                                  ),
                                  SizedBox(width: 10),
                                   // Add some space between the buttons
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                    ),
                                    child: Text('Delete', style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      // Perform the delete operation
                                    },
                                  ),
                                  SizedBox(width: 10), // Add some space between the buttons
                                  ElevatedButton(
                                    child: Text('View Details'),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => ProductDetailPage(product: snapshot.data![index]),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

            }
          }
        }
        )
    );
  }
  }

