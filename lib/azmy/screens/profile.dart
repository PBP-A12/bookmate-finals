// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookmate/globals.dart' as globals;

import 'package:bookmate/azmy/models/profile.dart';
import 'package:bookmate/provider.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfileDashboard extends StatefulWidget {
  final int? id;
  final bool header;

  const ProfileDashboard({super.key, required this.id, required this.header});

  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  int? id;
  late bool header;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    header = widget.header;
  }

  void refreshData() {
    setState(() {});
  }

  Future<ChoosenUser> fetchUser() async {
    var url = Uri.parse('${globals.domain}/user/user_flutter/$id');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    return ChoosenUser.fromJson(data);
  }

  Future<List<User>> fetchMatched() async {
    var url = Uri.parse('${globals.domain}/user/get_matched/$id');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<User> listMatched = [];
    for (var d in data) {
      if (d != null) {
        listMatched.add(User.fromJson(d));
      }
    }

    return listMatched;
  }

  Future<List<Review>> fetchReviews() async {
    var url = Uri.parse('${globals.domain}/user/get_reviews/$id');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Review> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }

    return listReview;
  }

  @override
  Widget build(BuildContext context) {
    Color? bgColor = const Color(0xFFB6536B);
    LoginUser? loggedInUser = Provider.of<UserProvider>(context).user;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: (header)? AppBar(
          title: const Text('Profile', style : TextStyle( color: Color.fromARGB(255, 255, 255, 255))),
          backgroundColor: bgColor,
        ) : null,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: fetchUser(),
                builder: (context, AsyncSnapshot<ChoosenUser> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Container();
                  } else {
                    var userData = snapshot.data!;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: bgColor,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${userData.user[0].fields.username}, ${userData.profile[0].fields.age}",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userData.profile[0].fields.bio.toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (loggedInUser?.id == userData.user[0].pk)
                          ElevatedButton(
                            onPressed: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditModal(
                                    refreshCallback: refreshData,
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: bgColor,
                            ),
                            child: const Text('Edit Profile',
                                style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: bgColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      tabs: const [
                        Tab(
                          text: 'Matched',
                        ),
                        Tab(
                          text: 'Reviews',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                  future: fetchMatched(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.data.length == 0) {
                                      return Container(
                                          margin: const EdgeInsets.only(
                                              top:
                                                  16.0), // Adjust the values as needed
                                          child: const Text(
                                              "No matched user yet."));
                                    } else {
                                      var userData = snapshot.data!;
                                      return Expanded(
                                          child: ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                top: 4.0,
                                                bottom:
                                                    4.0), // Adjust the values as needed
                                            child: ListTile(
                                              leading: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: bgColor,
                                                ),
                                              ),
                                              title: Text(userData[index]
                                                  .user
                                                  .fields
                                                  .username),
                                              trailing: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileDashboard(
                                                              id: userData[index].pk, header: true),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFFB6536B),
                                                ),
                                                child: const Text('See Profile',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          );
                                        },
                                      ));
                                    }
                                  })
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                  future: fetchReviews(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.data.length == 0) {
                                      return Container(
                                          margin: const EdgeInsets.only(
                                              top:
                                                  16.0), // Adjust the values as needed
                                          child: const Text("No Review Yet."));
                                    } else {
                                      var userData = snapshot.data!;
                                      return Expanded(
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                                              child:ListTile(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: bgColor, width: 1),
                                                  borderRadius: BorderRadius.circular(5),
                                                ), 
                                                title: Text(userData[index]
                                                    .book
                                                    .fields
                                                    .title),
                                                subtitle: Text(
                                                    'Review: ${userData[index].fields.review}'), // Add the review here
                                              ));
                                          },
                                        ),
                                      );
                                    }
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditModal extends StatefulWidget {
  final Function refreshCallback;

  const EditModal({required this.refreshCallback, super.key});

  @override
  State<EditModal> createState() => _EditModalState();
}

class _EditModalState extends State<EditModal> {
  final _formKey = GlobalKey<FormState>();
  int _age = 0;
  String _bio = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    LoginUser? loggedInUser = Provider.of<UserProvider>(context).user;
    int? loggedInUserId = loggedInUser?.id;

    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Adjust the size of the column
            children: [
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Age",
                    labelText: "Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _age = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Age cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Age must be a number!";
                    }
                    if (int.tryParse(value)! <= 0) {
                      return "Enter a valid age!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Bio",
                    labelText: "Bio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _bio = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Bio cannot be empty!";
                    }
                    if (value.length > 150) {
                      return 'Bio cannot be longer than 150 characters';
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFFB6536B)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "${globals.domain}/user/edit_profile_flutter/$loggedInUserId",
                          jsonEncode(<String, String>{
                            'age': _age.toString(),
                            'bio': _bio,
                          }),
                        );

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile successfully saved!"),
                            ),
                          );

                          widget.refreshCallback();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("There was an error, please try again."),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
