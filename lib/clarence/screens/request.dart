//我不懂这是什么
// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:bookmate/clarence/models/book_request.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:bookmate/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestPage> {
  Future<List<BookRequest>>? _future;
  Future<List<BookRequest>>? _futureAll;
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
        if (sort == "title") {
          userRequestList.sort((a, b) => a.title.compareTo(b.title));
        } else if (sort == "author") {
          userRequestList.sort((a, b) => a.author.compareTo(b.author));
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
  void refresh (request){
    setState(() {
      _future = fetchUserRequest(request, "title");
      _futureAll = fetchAllRequest(request, "title");
    });
  }
  String sortBy = "title";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final formKey = GlobalKey<FormState>();
    List<String> selectedSubjects = [];
    List<String> title = [];
    List<String> author = [];
    List<int> year = [];
    List<String> language = [];
    Future<List<String>> subjectsList = fetchSubjects(request);
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
    _futureAll = fetchAllRequest(request, "title");
    return Scaffold(
      floatingActionButton: Container(
        width: 70, // Increase the width to make it bigger
        height: 70, // Increase the height to make it bigger
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFFC44B6A),
          onPressed: () async {
            await showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('Request new Book',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                            ),
                          )),
                      content: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Container(
                              width: 500, // take up all available width
                              height: double.infinity,
                              child: Form(
                                key: formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Title'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a title';
                                            } else {
                                              title.add(value);
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Author'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter an author';
                                            } else {
                                              author.add(value);
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Year'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a year';
                                            } else if (int.tryParse(value) ==
                                                null) {
                                              return 'Please enter a valid year';
                                            } else {
                                              year.add(int.parse(value));
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Language'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a language';
                                            } else {
                                              language.add(value);
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: FutureBuilder<List<String>>(
                                          future: subjectsList,
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
                                                initialValue: selectedSubjects,
                                                hintWidget: const Text(
                                                    'Please choose one or more'),
                                                onSaved: (newValue) {
                                                  if (newValue == null) return;
                                                  setState(() {
                                                    selectedSubjects = newValue
                                                        .cast<String>()
                                                        .toList();
                                                  });
                                                },
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
                                          child: const Text('Submit',
                                          ),
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              // If the form is valid, display a Snackbar.
                                              final response = await request.postJson(
                                                  "${globals.domain}/request/requesting-flutter/",
                                                  //"http://10.0.2.2:8000/request/requesting-flutter/",
                                                  jsonEncode(<String, List>{
                                                    'title': title,
                                                    'author': author,
                                                    'year': year,
                                                    'language': language,
                                                    'subjects':
                                                        selectedSubjects,
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
                                                          "You Requested: \nTitle = ${title[0]}\nAuthor = ${author[0]}\nYear = ${year[0]}\nLanguage = ${language[0]}\nSubjects = $selectedSubjects"),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            // Perform action
                                                            Navigator.of(context).pop();
                                                              // _future =fetchUserRequest(request,"title");
                                                              // _futureAll = fetchAllRequest(request,"title");
                                                              refresh(request);
                                                              // RefreshIndicatorState().setState(() {
                                                                
                                                              // });
                                                            // Navigator.of(context).pop();
                                                              // Navigator.pushReplacement(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //       builder: (BuildContext context) => const RequestPage()
                                                              //       ));
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
                                              formKey.currentState!.reset();
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
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
      body: 
        DefaultTabController(
          length: 2,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.values[0],
                  indicator: BoxDecoration(
                    color: const Color(0xFFC44B6A),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                  ),
                  tabs: const [
                    Tab(
                      text: 'My Requests',
                    ),
                    Tab(
                      text: 'All Requests',
                    ),
                  ],
                ),
                
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.topRight,
                  child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.black),
                          onPressed: () {
                            refresh(request);
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownMenu<String>(
                          width: 170,
                          inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: const BorderSide(width: 1.0),
                            ),
                          ),
                          initialSelection: dropdownValue,
                          dropdownMenuEntries: sort.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                          onSelected: (value) {
                            if (value == "Sort By") {
                              return;
                            }
                            _future = fetchUserRequest(
                              request,
                              value.toString().toLowerCase(),
                            );
                            _future = fetchAllRequest(
                              request,
                              value.toString().toLowerCase(),
                            );
                            setState(() {
                              sortBy = value.toString().toLowerCase();
                              dropdownValue = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: TabBarView(
                    children: [
                    RefreshIndicator(
                      onRefresh: () async {
                          // _future = fetchUserRequest(request, "title");
                          refresh(request);
                      },
                      child:
                  FutureBuilder<List<BookRequest>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else if (snapshot.hasData &&
                          snapshot.data![0].id != 0) {
                        if (sortBy == "title") {
                          snapshot.data!
                              .sort((a, b) => a.title.compareTo(b.title));
                        } else if (sortBy == "author") {
                          snapshot.data!
                              .sort((a, b) => a.author.compareTo(b.author));
                        } else if (sortBy == "year") {
                          snapshot.data!.sort((a, b) => a.year.compareTo(b.year));
                        } else if (sortBy == "subjects") {
                          snapshot.data!.sort((a, b) =>
                              a.subjects.join().compareTo(b.subjects.join()));
                        } else if (sortBy == "date requested") {
                          snapshot.data!.sort((a, b) =>
                              a.dateRequested.compareTo(b.dateRequested));
                        }
                        return 
                        ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            String test =
                                snapshot.data![index].dateRequested.toString();
                            test = test.substring(0, test.length - 17);
                            return Card(
                              // color: Color(0xFFc44b6a),
                              child: ListTile(
                                title: Text(snapshot.data![index].title,
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins"))),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Author: ${snapshot.data![index].author}",
                                        // , style: TextStyle(fontSize: 15, color: Colors.white)
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins"))),
                                    Text("Year: ${snapshot.data![index].year}",
                                        // , style: TextStyle(fontSize: 15, color: Colors.white)
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins"))),
                                    Text(
                                        "Language: ${snapshot.data![index].language}",
                                        // , style: TextStyle(fontSize: 15, color: Colors.white)
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins"))),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xFFC44B6A)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Color(0xFFC44B6A))))),
                                      onPressed: () async {
                                        await showDialog<void>(
                                          context: context,
                                          builder: (context) => Dialog.fullscreen(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.close,
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
                                                      textStyle: const TextStyle(
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
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      "Author: ${snapshot.data![index].author}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      "Year: ${snapshot.data![index].year}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      "Language: ${snapshot.data![index].language}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      "Subjects: ",
                                                      style: GoogleFonts.lato(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      "            -  ${snapshot.data![index].subjects.join("\n            -  ")}",
                                                      style: GoogleFonts.lato(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      "Date Requested: $test",
                                                      style: GoogleFonts.lato(
                                                        textStyle: const TextStyle(
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
                                                          const Color(0xffC44B6A),
                                                      child: IconButton(
                                                        iconSize: 30,
                                                        icon: const Icon(Icons.edit,
                                                            color:
                                                                Colors.white),
                                                        onPressed: () async {
                                                          await showDialog<
                                                                  void>(
                                                              context:
                                                                  context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title:
                                                                            const Text('Edit Requested Book'),
                                                                        content:
                                                                            Stack(
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: <Widget>[
                                                                            Container(
                                                                                width: 500, // take up all available width
                                                                                height: double.infinity,
                                                                                child: Form(
                                                                                  key: formKey,
                                                                                  child: SingleChildScrollView(
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8),
                                                                                          child: TextFormField(
                                                                                            decoration: const InputDecoration(labelText: 'Title'),
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Please enter a title';
                                                                                              } else {
                                                                                                title.add(value);
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8),
                                                                                          child: TextFormField(
                                                                                            decoration: const InputDecoration(labelText: 'Author'),
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Please enter an author';
                                                                                              } else {
                                                                                                author.add(value);
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8),
                                                                                          child: TextFormField(
                                                                                            decoration: const InputDecoration(labelText: 'Year'),
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Please enter a year';
                                                                                              } else if (int.tryParse(value) == null) {
                                                                                                return 'Please enter a valid year';
                                                                                              } else {
                                                                                                year.add(int.parse(value));
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8),
                                                                                          child: TextFormField(
                                                                                            decoration: const InputDecoration(labelText: 'Language'),
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Please enter a language';
                                                                                              } else {
                                                                                                language.add(value);
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8),
                                                                                          child: FutureBuilder<List<String>>(
                                                                                            future: subjectsList,
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
                                                                                                  initialValue: selectedSubjects,
                                                                                                  hintWidget: const Text('Please choose one or more'),
                                                                                                  onSaved: (newValue) {
                                                                                                    if (newValue == null) return;
                                                                                                    setState(() {
                                                                                                      selectedSubjects = newValue.cast<String>().toList();
                                                                                                    });
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
                                                                                              if (formKey.currentState!.validate()) {
                                                                                                // If the form is valid, display a Snackbar.
                                                                                                final response = await request.postJson(
                                                                                                    "${globals.domain}/request/edit-request/",
                                                                                                    jsonEncode(<String, List>{
                                                                                                      'id': [snapshot.data![index].id.toString()],
                                                                                                      'title': title,
                                                                                                      'author': author,
                                                                                                      'year': year,
                                                                                                      'language': language,
                                                                                                      'subjects': selectedSubjects,
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
                                                                                                        content: Text("You Requested: \nTitle = ${title[0]}\nAuthor = ${author[0]}\nYear = ${year[0]}\nLanguage = ${language[0]}\nSubjects = $selectedSubjects"),
                                                                                                        actions: [
                                                                                                          TextButton(
                                                                                                            child: const Text('OK'),
                                                                                                            onPressed: () {
                                                                                                              // Perform action
                                                                                                              Navigator.of(context).pop();
                                                                                                              refresh(request);
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
                                                                                                formKey.currentState!.reset();
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
                                                    const SizedBox(width: 30.0),
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
                                                            const Color(0xffC44B6A),
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white),
                                                          iconSize: 30,
                                                          onPressed: () async {
                                                            final response = await request.postJson("${globals.domain}/request/delete-request/",jsonEncode(<String,String>{
                                                              'id': snapshot.data![index].id.toString(),
                                                              }));
                                                            if (response["status"] == 'success'){
                                                              refresh(request);
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request has been deleted!")));
                                                            }
                                                            else if (response["status"] == 'failed'){
                                                              String msg = response["message"];
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                                                            }
                                                            else{
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request failed to be deleted! Please try again.")));
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("View Details",
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      
                      } else {
                        return const Text('No Requests Found');
                      }
                    },
                  ),
                ),
                  RefreshIndicator(
                    onRefresh: () async {
                    refresh(request);
                    },
                    child: FutureBuilder<List<BookRequest>>(
                    future: _futureAll,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else if (snapshot.hasData &&
                          snapshot.data![0].id != 0) {
                            if (sortBy == "title") {
                          snapshot.data!
                              .sort((a, b) => a.title.compareTo(b.title));
                        } else if (sortBy == "author") {
                          snapshot.data!
                              .sort((a, b) => a.author.compareTo(b.author));
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
                            String test =
                                snapshot.data![index].dateRequested.toString();
                            test = test.substring(0, test.length - 17);
                            return Card(
                              // color: Color(0xFFc44b6a),
                              child: ListTile(
                                title: Text(snapshot.data![index].title,
                                    style: const TextStyle(
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
                                      "Date Requested:\n $test",
                                      //  style: TextStyle(color: Colors.white)
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                          } else {
                        return const Text('No Requests Found');
                      }
                    },
                  ),
                  ),
                    ],
                    ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
