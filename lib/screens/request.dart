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
  List<String> _title = [];
  List<String> _author = [];
  List<int> _year = [];
  List<String> _language = [];
  Future<List<String>> _subjects_list = fetchSubjects(request);
  // String no_request = "No one has requested a book yet! :)";
  _future = fetchUserRequest(request, "title");
  return Scaffold(
    appBar: AppBar(
      title: Text('Book Requests'),
      centerTitle: true,
      backgroundColor: Color(0xFFC44B6A)),
      floatingActionButton: 
      Container(
        width: 70, // Increase the width to make it bigger
        height: 70, // Increase the height to make it bigger
        child: FloatingActionButton(
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: 40),
          backgroundColor: Color(0xFFC44B6A),
                onPressed: () async {
                  await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Request new Book'),
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
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
                                              _title.add(value);
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
                                              _author.add(value);
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
                                              _year.add(int.parse(value));
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
                                              _language.add(value);
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
                                                jsonEncode(<String, List>{
                                                  'title': _title,
                                                  'author': _author,
                                                  'year': _year,
                                                  'language': _language,
                                                  'subjects': _selectedSubjects,
                                                }));
                                                if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                    content: Text("Request has been saved!"),
                                                    ));
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text('Book has been requested!'),
                                                          content: 
                                                            Text("You Requested: \n" + "Title = "+ _title[0] + "\nAuthor = " + _author[0] + "\nYear = " + _year[0].toString() + "\nLanguage = " + _language[0] + "\nSubjects = " + _selectedSubjects.toString()),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text('OK'),
                                                              onPressed: () {
                                                                // Perform action
                                                                Navigator.of(context).pop();
                                                                if (current == "user") {
                                                                  _future = fetchUserRequest(request, "title");
                                                                  Navigator.pushReplacement(
                                                                    context, 
                                                                    MaterialPageRoute(builder: (BuildContext context) => super.widget));
                                                                } else {
                                                                  _future = fetchAllRequest(request, "title");
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

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
                // backgroundColor: Colors.transparent,
                // const Text('Add New Request'),
              ),
      ),
    drawer: RightDrawer(),
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
                    if (_future == null){

                    };
                    current = "user";
                    setState(() {});
                  },
                  child: Text('My Requests', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                ),
                SizedBox(width: 100.0),
                GestureDetector(
                  onTap: () {
                    _future = fetchAllRequest(request, "title");
                    current = "all";
                    setState(() {});
                  },
                  child: Text('All Requests', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
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
                      String test = snapshot.data![index].dateRequested.toString();
                      test = test.substring(0, test.length-17);
                        return Card(
                          // color: Color(0xFFc44b6a),
                          child: ListTile(
                              
                                title: Text(snapshot.data![index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Author: ${snapshot.data![index].author}"
                                    // , style: TextStyle(fontSize: 15, color: Colors.white)
                                    ),
                                    Text("Year: ${snapshot.data![index].year}"
                                    // , style: TextStyle(fontSize: 15, color: Colors.white)
                                    ),
                                    Text("Language: ${snapshot.data![index].language}"
                                    // , style: TextStyle(fontSize: 15, color: Colors.white)
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    Text("Date Requested: ${test}",
                                    //  style: TextStyle(color: Colors.white)
                                     ),
                                        SizedBox(width: 10.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child:
                                        CircleAvatar(
                                          backgroundColor: Color(0xffC44B6A),
                                          child: IconButton(
                                            icon: Icon(Icons.edit, color: Colors.white),
                                            onPressed: () {
                                              // TODO: Implement edit functionality
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: 
                                        CircleAvatar(
                                          backgroundColor: Color(0xffC44B6A),
                                          child: IconButton(
                                            icon: Icon(Icons.delete, color: Colors.white),
                                            onPressed: () {
                                              // TODO: Implement edit functionality
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                            );
                      },
                    );
                  } else {
                    return Text('No Requests Found');
                  }
                },
              ),
            ),
            // Container(
            //   alignment: Alignment.bottomRight,
            //   padding: EdgeInsets.all(20.0),
            //   color: Colors.transparent,
            //   // child: Container(),
            //   child: 
              // RawMaterialButton(
              //   onPressed: () {},
               
            // ),
          ],
        ),
      ),
    ),
  );
}
}
