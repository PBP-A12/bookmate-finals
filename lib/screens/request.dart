import 'dart:convert';
import 'dart:math';

import 'package:bookmate/models/book_request.dart';
import 'package:bookmate/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
class RequestPage extends StatefulWidget {
    const RequestPage({Key? key}) : super(key: key);

    @override
    _RequestsPageState createState() => _RequestsPageState();
}
class _RequestsPageState extends State<RequestPage> {
  var current = "user";
Future<List<BookRequest>>? _future;
  Future<List<BookRequest>> fetchAllRequest(CookieRequest request, String sort) async {
    final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/request/get-all-request-json/?sortby=$sort'),
    headers: request.headers,
    );
    // Perform error handling for the response
      if (response.statusCode == 200) {
        // Decode the response body
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // Convert the JSON data to a list of Product objects
        List<BookRequest> myRequestList = [];
        for (var d in data) {
          if (d != null) {
            myRequestList.add(BookRequest.fromJson(d));
          }
        }
        return myRequestList;
      } else {
        throw Exception('Failed to fetch products');
      }
  }
  Future<List<BookRequest>> fetchUserRequest(CookieRequest request, String sort) async {
    final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/request/get-request-json-user/?sortby=$sort'),
    headers: request.headers,
    );
    // Perform error handling for the response
      if (response.statusCode == 200) {
        // Decode the response body
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // Convert the JSON data to a list of Product objects
        List<BookRequest> userRequestList = [];
        for (var d in data) {
          if (d != null) {
            userRequestList.add(BookRequest.fromJson(d));
          }
        }
        // print(user_request_list);
        return userRequestList;
      } else {
        throw Exception('Failed to fetch products');
      }
  }
  Future<List<String>> fetchSubjects(CookieRequest request) async {
    final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/request/get-subjects-json'),
    headers: request.headers,
    );
    // Perform error handling for the response
      if (response.statusCode == 200) {
        // Decode the response body
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // print(data);r
        List<String> subjectsList = [];
        for (var d in data) {
          if (d != null) {
            String name = d['fields']['name'];
            subjectsList.add(name);
          }
        }
        return subjectsList;
      } else {
        throw Exception('Failed to fetch subjects');
      }
  }

@override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  final _formKey = GlobalKey<FormState>();
  List<String> _selectedSubjects = [];
  String _title = "";
  String _author = "";
  int _year = 0;
  String _language = "";
  Future<List<String>> _subjects_list = fetchSubjects(request);
  return Scaffold(
    appBar: AppBar(
      title: Text('Book Requests'),
    ),
    endDrawer: RightDrawer(),
    body: RefreshIndicator(
      onRefresh: () async {
        if (current == "user") {
          _future = fetchUserRequest(request, "title");
        } else {
          _future = fetchAllRequest(request, "title");
        }
        setState(() {});
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            //  Container(
            //   child: 
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _future = fetchUserRequest(request, "title");
                    current = "user";
                    setState(() {});
                  },
                  child: Text('My Requests', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 100.0),
                GestureDetector(
                  onTap: () {
                    _future = fetchAllRequest(request, "title");
                    current = "all";
                    setState(() {});
                  },
                  child: Text('All Requests', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton(
                    hint: Text('Sort by'),
                    value: null,
                    onChanged: (newValue) {
                      if (current == "user") {
                        _future = fetchUserRequest(request, newValue.toString());
                      } else {
                        _future = fetchAllRequest(request, newValue.toString());
                      }
                      setState(() {});
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text('Title'),
                        value: 'title',
                      ),
                      DropdownMenuItem(
                        child: Text('Author'),
                        value: 'author',
                      ),
                      DropdownMenuItem(
                        child: Text('Year'),
                        value: 'year',
                      ),
                      DropdownMenuItem(
                        child: Text('Subjects'),
                        value: 'subjects',
                      ),
                      DropdownMenuItem(
                        child: Text('Date Requested'),
                        value: 'date_requested',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<List<BookRequest>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].title),
                            subtitle: Text(snapshot.data![index].author),
                            trailing: Text(snapshot.data![index].dateRequested.toString()),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () async {
                  await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Request new Book'),
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                // Positioned(
                                //   width: double.infinity, // take up all available width
                                //   top: -40,
                                //   child: InkResponse(
                                //     onTap: () {
                                //       Navigator.of(context).pop();
                                //     },
                                //     // child: const CircleAvatar(
                                //     //   backgroundColor: Colors.red,
                                //     //   child: Icon(Icons.close),
                                //     // ),
                                //   ),
                                // ),
                                Container(
                                width: 500, // take up all available width
                                height: double.infinity,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Title'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a title';
                                            }
                                            else {
                                              _title = value;
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Author'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter an author';
                                            }
                                            else {
                                              _author = value;
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Year'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a year';
                                            }
                                            else if (int.tryParse(value) == null) {
                                              return 'Please enter a valid year';
                                            }
                                            else {
                                              _year = int.parse(value);
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Language'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a language';
                                            }
                                            else {
                                              _language = value;
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: FutureBuilder<List<String>>(
                                          future: _subjects_list,
                                          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                                            if (snapshot.hasData) {
                                              List<dynamic> dataSource = snapshot.data!
                                                  .map((e) => {'display': e, 'value': e})
                                                  .toList()
                                                  .cast<dynamic>();
                                              return MultiSelectFormField(
                                                autovalidate: AutovalidateMode.onUserInteraction,
                                                chipLabelStyle: const TextStyle(), // Add an identifier and provide a valid TextStyle
                                                dataSource: dataSource,
                                                textField: 'display',
                                                valueField: 'value',
                                                title: const Text('Subjects'),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Please select one or more subject(s)';
                                                  }
                                                  return null;
                                                },
                                                okButtonLabel: 'OK',
                                                cancelButtonLabel: 'CANCEL',
                                                initialValue: _selectedSubjects,
                                                hintWidget: const Text('Please choose one or more'),
                                                onSaved: (newValue) {
                                                  // print(newValue);
                                                  if (newValue == null) return;
                                                  setState(() {
                                                    _selectedSubjects = newValue.cast<String>().toList();

                                                  });
                                                  // print(_selectedSubjects);
                                                },
                                                // ...
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: ElevatedButton(
                                          child: const Text('Submit'),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              // If the form is valid, display a Snackbar.
                                              final response = await request.postJson(
                                                "http://127.0.0.1:8000/request/requesting-flutter/",
                                                jsonEncode(<String, String>{
                                                  'title': _title,
                                                  'author': _author,
                                                  'year': _year.toString(),
                                                  'language': _language,
                                                  'subjects': _selectedSubjects.toString(),
                                                }));
                                                if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                    content: Text("Request has been saved!"),
                                                    ));
                                                } else if (response['status'] == 'failed') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                        content:
                                                            Text("Request failed to be saved! Please try again.")));
                                                } else {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                        content:
                                                            Text("Request failed to be saved! Please try again."),
                                                    ));
                                                }
                                              _formKey.currentState!.reset();
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                )
                              ],
                            ),
                          ));
                },
                child: Icon(Icons.add),
                // const Text('Add New Request'),
              ),

            )
          ],
        ),
      ),
    ),
  );
}
}
