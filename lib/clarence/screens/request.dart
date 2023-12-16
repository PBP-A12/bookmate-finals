import 'dart:convert';
import 'package:bookmate/clarence/models/book_request.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:bookmate/globals.dart' as globals;

// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestPage> {
  var current = "user";
  Future<List<BookRequest>>? _future;
  Future<List<BookRequest>> fetchAllRequest(
      CookieRequest request, String sort) async {
    if (sort == "date requested") {
      sort = "date_requested";
    }
    final response = await http.get(
      Uri.parse('${globals.domain}/request/get-all-request-json/?sortby=$sort'),
      // Uri.parse('http://10.0.2.2:8000/request/get-all-request-json/?sortby=$sort'),
      headers: request.headers,
    );
    // Perform error handling for the response
    if (response.statusCode == 200) {
      // Decode the response body
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data.length == 0) {
        return [
          BookRequest(
              id: 0,
              subjects: ["N/A"],
              member: "N/A",
              title: "N/A",
              author: "N/A",
              year: 0,
              language: "N/A",
              dateRequested: DateTime.now())
        ]; // Return an empty list when no requests have been made
      } else {
        // Convert the JSON data to a list of Product objects
        List<BookRequest> allRequestList = [];
        for (var d in data) {
          if (allRequestList.isEmpty) {
            return [
              BookRequest(
                  id: 0,
                  subjects: ["N/A"],
                  member: "N/A",
                  title: "N/A",
                  author: "N/A",
                  year: 0,
                  language: "N/A",
                  dateRequested: DateTime.now())
            ]; // Return an empty list when no requests have been made
          }
          if (d != null) {
            allRequestList.add(BookRequest.fromJson(d));
          }
        }
        if (sort == "title") {
          allRequestList.sort((a, b) => b.title.compareTo(a.title));
        } else if (sort == "author") {
          allRequestList.sort((a, b) => b.author.compareTo(a.author));
        } else if (sort == "year") {
          allRequestList.sort((a, b) => b.year.compareTo(a.year));
        } else if (sort == "subjects") {
          allRequestList
              .sort((a, b) => b.subjects.join().compareTo(a.subjects.join()));
        } else if (sort == "date requested") {
          allRequestList
              .sort((a, b) => b.dateRequested.compareTo(a.dateRequested));
        }
        return allRequestList;
      }
    } else {
      return [
        BookRequest(
            id: 0,
            subjects: ["N/A"],
            member: "N/A",
            title: "N/A",
            author: "N/A",
            year: 0,
            language: "N/A",
            dateRequested: DateTime.now())
      ]; // Return an empty list when no requests have been made

      // throw Exception('Failed to fetch products');
    }
  }

  Future<List<BookRequest>> fetchUserRequest(
      CookieRequest request, String sort) async {
    if (sort == "date requested") {
      sort = "date_requested";
    }
    final response = await http.get(
      Uri.parse(
          '${globals.domain}/request/get-request-json-user-flutter/?sortby=$sort'),
      // Uri.parse('http://10.0.2.2:8000/request/get-request-json-user-flutter/?sortby=$sort'),
      headers: request.headers,
    );
    // Perform error handling for the response
    if (response.statusCode == 200) {
      // Decode the response body
      // print(response.body);
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      if (data.length == 0) {
        return [
          BookRequest(
              id: 0,
              subjects: ["N/A"],
              member: "N/A",
              title: "N/A",
              author: "N/A",
              year: 0,
              language: "N/A",
              dateRequested: DateTime.now())
        ]; // Return an empty list when no requests have been made
      } else {
        // Convert the JSON data to a list of Product objects
        List<BookRequest> userRequestList = [];
        for (var d in data) {
          if (d != null) {
            userRequestList.add(BookRequest.fromJson(d));
          }
        }
        // print(user_request_list);
        if (sort == "title") {
          userRequestList.sort((a, b) => a.title.compareTo(b.title));
          // print(userRequestList.toString());
        } else if (sort == "author") {
          userRequestList.sort((a, b) => a.author.compareTo(b.author));
          // print(userRequestList[0].id);
        } else if (sort == "year") {
          userRequestList.sort((a, b) => a.year.compareTo(b.year));
        } else if (sort == "subjects") {
          userRequestList
              .sort((a, b) => a.subjects.join().compareTo(b.subjects.join()));
        } else if (sort == "date requested") {
          userRequestList
              .sort((a, b) => a.dateRequested.compareTo(b.dateRequested));
        }
        return userRequestList;
      }
    } else {
      return [
        BookRequest(
            id: 0,
            subjects: ["N/A"],
            member: "N/A",
            title: "N/A",
            author: "N/A",
            year: 0,
            language: "N/A",
            dateRequested: DateTime.now())
      ]; // Return an empty list when no requests have been made
    }
  }

  Future<List<String>> fetchSubjects(CookieRequest request) async {
    final response = await http.get(
      Uri.parse('${globals.domain}/request/get-subjects-json'),
      // Uri.parse('http://10.0.2.2:8000/request/get-subjects-json'),
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

  String sortBy = "title";
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final _formKey = GlobalKey<FormState>();
    // final logo = SvgPicture.asset(
    //   "assets/img/logo.svg",
    //   width: 200,
    //   height: 200,
    // );
    List<String> _selectedSubjects = [];
    List<String> _title = [];
    List<String> _author = [];
    List<int> _year = [];
    List<String> _language = [];
    Future<List<String>> _subjects_list = fetchSubjects(request);
    const List<String> sort = <String>[
      "Sort By",
      "Title",
      "Author",
      "Year",
      "Subjects",
      "Date Requested"
    ];
    String dropdownValue = sort.first;
    _future = fetchUserRequest(request, "title");
    // PreferredSizeWidget appBar = AppBarWidget();
    return Scaffold(
      //我不懂这是什么
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(kToolbarHeight),
      //   child: AppBarWidget(),
      // ),
      //  AppBar(
      //   title:
      //   Text('Requests',
      //    style: GoogleFonts.lato( textStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 30)),
      //    ),
      //   centerTitle: true,
      //   backgroundColor: Color(0xFFC44B6A)),
      // bottomNavigationBar: NavBar(),
      // BottomAppBar(
      //   // color: Color(0xFFC44B6A),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       IconButton(
      //         icon: Icon(Icons.home, color: Colors.white),
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/home');
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.search, color: Colors.white),
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/search');
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.book, color: Colors.white),
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/mybooks');
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.person, color: Colors.white),
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/profile');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: Container(
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Title'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a title';
                                            } else {
                                              _title.add(value);
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Author'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter an author';
                                            } else {
                                              _author.add(value);
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Year'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a year';
                                            } else if (int.tryParse(value) ==
                                                null) {
                                              return 'Please enter a valid year';
                                            } else {
                                              _year.add(int.parse(value));
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Language'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a language';
                                            } else {
                                              _language.add(value);
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: FutureBuilder<List<String>>(
                                          future: _subjects_list,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<String>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              List<dynamic> dataSource =
                                                  snapshot.data!
                                                      .map((e) => {
                                                            'display': e,
                                                            'value': e
                                                          })
                                                      .toList()
                                                      .cast<dynamic>();
                                              return MultiSelectFormField(
                                                autovalidate: AutovalidateMode
                                                    .onUserInteraction,
                                                chipLabelStyle:
                                                    const TextStyle(), // Add an identifier and provide a valid TextStyle
                                                dataSource: dataSource,
                                                textField: 'display',
                                                valueField: 'value',
                                                title: const Text('Subjects'),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please select one or more subject(s)';
                                                  }
                                                  return null;
                                                },
                                                okButtonLabel: 'OK',
                                                cancelButtonLabel: 'CANCEL',
                                                initialValue: _selectedSubjects,
                                                hintWidget: const Text(
                                                    'Please choose one or more'),
                                                onSaved: (newValue) {
                                                  // print(newValue);
                                                  if (newValue == null) return;
                                                  setState(() {
                                                    _selectedSubjects = newValue
                                                        .cast<String>()
                                                        .toList();
                                                  });
                                                  // print(_selectedSubjects);
                                                },
                                                // ...
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
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
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // If the form is valid, display a Snackbar.
                                              final response = await request.postJson(
                                                  "${globals.domain}/request/requesting-flutter/",
                                                  //"http://10.0.2.2:8000/request/requesting-flutter/",
                                                  jsonEncode(<String, List>{
                                                    'title': _title,
                                                    'author': _author,
                                                    'year': _year,
                                                    'language': _language,
                                                    'subjects':
                                                        _selectedSubjects,
                                                  }));
                                              if (response['status'] ==
                                                  'success') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Request has been saved!"),
                                                ));
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Book has been requested!'),
                                                      content: Text(
                                                          "You Requested: \n" +
                                                              "Title = " +
                                                              _title[0] +
                                                              "\nAuthor = " +
                                                              _author[0] +
                                                              "\nYear = " +
                                                              _year[0]
                                                                  .toString() +
                                                              "\nLanguage = " +
                                                              _language[0] +
                                                              "\nSubjects = " +
                                                              _selectedSubjects
                                                                  .toString()),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            // Perform action
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            if (current ==
                                                                "user") {
                                                              _future =
                                                                  fetchUserRequest(
                                                                      request,
                                                                      "title");
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          super
                                                                              .widget));
                                                            } else {
                                                              _future =
                                                                  fetchAllRequest(
                                                                      request,
                                                                      "title");
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else if (response['status'] ==
                                                  'failed') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Request failed to be saved! Please try again.")));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Request failed to be saved! Please try again."),
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
                              ))
                        ],
                      ),
                    ));
          },
        ),
      ),
      // drawer: RightDrawer(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _future = fetchUserRequest(request, "title");
                      current = "user";
                      setState(() {});
                    },
                    child: Text('My Requests',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontFamily: "Poppins"))),
                  ),
                  SizedBox(width: 30.0),
                  GestureDetector(
                    onTap: () {
                      _future = fetchAllRequest(request, "title");
                      current = "all";
                      setState(() {});
                    },
                    child: Text('All Requests',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                decoration: TextDecoration.underline))
                        // TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)
                        ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownMenu<String>(
                      initialSelection: dropdownValue,
                      dropdownMenuEntries:
                          sort.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                      onSelected: (value) {
                        if (value == "Sort By") {
                          return;
                        }
                        if (current == "user") {
                          _future = fetchUserRequest(
                              request, value.toString().toLowerCase());
                        } else {
                          _future = fetchAllRequest(
                              request, value.toString().toLowerCase());
                        }
                        setState(() {
                          sortBy = value.toString().toLowerCase();
                          print(sortBy);
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: FutureBuilder<List<BookRequest>>(
                  future: _future,
                  builder: (context, snapshot) {
                    print(current);
                    print(sortBy);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else if (snapshot.hasData &&
                        current == "user" &&
                        snapshot.data![0].id != 0) {
                      if (sortBy == "title") {
                        snapshot.data!
                            .sort((a, b) => a.title.compareTo(b.title));
                      } else if (sortBy == "author") {
                        snapshot.data!
                            .sort((a, b) => a.author.compareTo(b.author));
                        print(snapshot.data![0].title);
                      } else if (sortBy == "year") {
                        snapshot.data!.sort((a, b) => a.year.compareTo(b.year));
                      } else if (sortBy == "subjects") {
                        snapshot.data!.sort((a, b) =>
                            a.subjects.join().compareTo(b.subjects.join()));
                      } else if (sortBy == "date requested") {
                        snapshot.data!.sort((a, b) =>
                            a.dateRequested.compareTo(b.dateRequested));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          print(snapshot.data![index].id);
                          String test =
                              snapshot.data![index].dateRequested.toString();
                          test = test.substring(0, test.length - 17);
                          return Card(
                            // color: Color(0xFFc44b6a),
                            child: ListTile(
                              title: Text(snapshot.data![index].title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Author: ${snapshot.data![index].author}",
                                      // , style: TextStyle(fontSize: 15, color: Colors.white)
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Poppins"))),
                                  Text("Year: ${snapshot.data![index].year}",
                                      // , style: TextStyle(fontSize: 15, color: Colors.white)
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Poppins"))),
                                  Text(
                                      "Language: ${snapshot.data![index].language}",
                                      // , style: TextStyle(fontSize: 15, color: Colors.white)
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Poppins"))),
                                  // Text("Subjects: ${snapshot.data![index].subjects.join(", ")}",
                                  // style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "Poppins"))
                                  // ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFFC44B6A)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color:
                                                        Color(0xFFC44B6A))))),
                                    onPressed: () async {
                                      await showDialog<void>(
                                        context: context,
                                        builder: (context) => Dialog.fullscreen(
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.black),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "Details",
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Title: ${snapshot.data![index].title}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      "Author: ${snapshot.data![index].author}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      "Year: ${snapshot.data![index].year}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      "Language: ${snapshot.data![index].language}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      "Subjects: ",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      "            -  ${snapshot.data![index].subjects.join("\n            -  ")}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      "Date Requested: ${test}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 70,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                      ),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xffC44B6A),
                                                        child: IconButton(
                                                          iconSize: 30,
                                                          icon: Icon(Icons.edit,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () async {
                                                            // TODO: Implement edit functionality
                                                            await showDialog<
                                                                    void>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                          title:
                                                                              Text('Edit Requested Book'),
                                                                          content:
                                                                              Stack(
                                                                            clipBehavior:
                                                                                Clip.none,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                  width: 500, // take up all available width
                                                                                  height: double.infinity,
                                                                                  child: Form(
                                                                                    key: _formKey,
                                                                                    child: SingleChildScrollView(
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
                                                                                                } else {
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
                                                                                                } else {
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
                                                                                                } else if (int.tryParse(value) == null) {
                                                                                                  return 'Please enter a valid year';
                                                                                                } else {
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
                                                                                                } else {
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
                                                                                                  List<dynamic> dataSource = snapshot.data!.map((e) => {'display': e, 'value': e}).toList().cast<dynamic>();
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
                                                                                                      "${globals.domain}/request/edit-request/",
                                                                                                      // "http://10.0.2.2:8000/request/edit-request/",
                                                                                                      jsonEncode(<String, List>{
                                                                                                        'title': _title,
                                                                                                        'author': _author,
                                                                                                        'year': _year,
                                                                                                        'language': _language,
                                                                                                        'subjects': _selectedSubjects,
                                                                                                      }));
                                                                                                  if (response['status'] == 'success') {
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                                      content: Text("Request has been saved!"),
                                                                                                    ));
                                                                                                    Navigator.pop(context);
                                                                                                    showDialog(
                                                                                                      context: context,
                                                                                                      builder: (BuildContext context) {
                                                                                                        return AlertDialog(
                                                                                                          title: const Text('Book has been requested!'),
                                                                                                          content: Text("You Requested: \n" + "Title = " + _title[0] + "\nAuthor = " + _author[0] + "\nYear = " + _year[0].toString() + "\nLanguage = " + _language[0] + "\nSubjects = " + _selectedSubjects.toString()),
                                                                                                          actions: [
                                                                                                            TextButton(
                                                                                                              child: const Text('OK'),
                                                                                                              onPressed: () {
                                                                                                                // Perform action
                                                                                                                Navigator.of(context).pop();
                                                                                                                if (current == "user") {
                                                                                                                  _future = fetchUserRequest(request, "title");
                                                                                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget));
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
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request failed to be saved! Please try again.")));
                                                                                                  } else {
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                                      content: Text("Request failed to be saved! Please try again."),
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
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ));
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 30.0),
                                                    Container(
                                                      width: 70,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                      ),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xffC44B6A),
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white),
                                                          iconSize: 30,
                                                          onPressed: () {
                                                            // TODO: Implement edit functionality
                                                            final response = request
                                                                .postJson(
                                                                    "${globals.domain}/request/delete-request/",
                                                                    // "http://10.0.2.2:8000/request/delete-request/",
                                                                    jsonEncode(<String,
                                                                        String>{
                                                                      'id': snapshot
                                                                          .data![
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                    }));
                                                            _future =
                                                                fetchUserRequest(
                                                                    request,
                                                                    "title");
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("View Details",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasData &&
                        current == "all" &&
                        snapshot.data![0].id != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String test =
                              snapshot.data![index].dateRequested.toString();
                          test = test.substring(0, test.length - 17);
                          return Card(
                            // color: Color(0xFFc44b6a),
                            child: ListTile(
                              title: Text(snapshot.data![index].title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Author: ${snapshot.data![index].author}"
                                      // , style: TextStyle(fontSize: 15, color: Colors.white)
                                      ),
                                  Text("Year: ${snapshot.data![index].year}"
                                      // , style: TextStyle(fontSize: 15, color: Colors.white)
                                      ),
                                  Text(
                                      "Language: ${snapshot.data![index].language}"
                                      // , style: TextStyle(fontSize: 15, color: Colors.white)
                                      ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Date Requested:\n ${test}",
                                    //  style: TextStyle(color: Colors.white)
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