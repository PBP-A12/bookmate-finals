import 'dart:convert';
import 'package:bookmate/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class MatchPage extends StatefulWidget {
  MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String name = '';
  String interest = '';
  String bio = '';
  String matchingId = '';

  // @override
  // void initState() {
  //   super.initState();
  //   getMatch();
  // }

  Future<void> getMatch(request) async {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/match/get_match_flutter/'),
      headers: request.headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          name = data['name'];
          interest = data['interest_subject'];
          bio = data['bio'];
          matchingId = data['matching_id'];
        });
      } else {
        // Handle errors
        print('Failed to load data');
      }
    
  }

  // Future<void> acceptRecommendation(request) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://127.0.0.1:8000/match/accept_flutter/$matchingId/'),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       // Recommendation accepted successfully
  //       print('Recommendation accepted');
  //       // Add any other logic or UI updates you need here
  //       getMatch(request); // Optionally, refresh the match data after acceptance
  //     } else {
  //       // Handle errors
  //       print('Failed to accept recommendation');
  //     }
  //   } catch (error) {
  //     // Handle errors
  //     print('Error: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  getMatch(request);
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Page'),
      ),
      endDrawer: const RightDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RefreshIndicator(
              child: 
              Column(
                children: [
            Text('Name: $name'),
            Text('Interest: $interest'),
            Text('Bio: $bio'),

                ],
              ),
              onRefresh: () async {
                print(request);
                name = name;
                interest = interest;
                bio= bio;
              }),
            ElevatedButton(
              onPressed: () async {
                getMatch(request);
              },  
              child: Text('Swipe Kiri'),
            ),
            ElevatedButton(
              onPressed: () async{
                final response = await request.postJson("http://127.0.0.1:8000/match/accept_flutter/",
                jsonEncode(
                  <String, String>{
                    'name': name,
                    'interest': interest,
                    'bio': bio,
                    'matching_id' : matchingId,
                  } 
                ));
                print(response);
              },
              child: Text('Accept Recommendation / Swipe Kanan'),
            ),

          ],
        ),
      ),
    );
  }
}