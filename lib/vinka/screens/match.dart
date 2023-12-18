import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmate/globals.dart' as globals;
import 'package:bookmate/vinka/screens/match_guide.dart';
import 'package:bookmate/azmy/screens/profile.dart';


class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage> {
  int currentIndex = 0;
  bool _showGuide = false;

  List<Map<String, dynamic>> cards = [
    {
      'name': '',
      'interest': [],
      'bio': '',
      'matchingId': '',
      'userId': '',
      'picture': ''
    },
    // Add more cards as needed
  ];

  Future<void> fetchNextCard(CookieRequest request) async {
    final response = await http.get(
      Uri.parse('${globals.domain}/match/get_match_flutter/'),
      headers: request.headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        cards.add({
          'name': data['name'],
          'interest': data['interest_subject'],
          'bio': data['bio'],
          'matchingId': data['matching_id'].toString(),
          'userId': data['id'].toString(),
          'picture': data['picture'],
        });
        currentIndex = cards.length - 1;
      });
    } else {
      throw Exception('Failed to fetch match');
    }
  }

  @override
  void initState() {
    super.initState();
    _showGuide = true;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    if (_showGuide) {
      return GuidePage(onStart: () async {
        setState(() => _showGuide = false);
        await fetchNextCard(request);
      });
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd, // Add this line
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  fetchNextCard(request);
                } /*else if (direction == DismissDirection.endToStart) {
                    fetchNextCard(request);
                  } */
                },
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  margin: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 27.0),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(cards[currentIndex]['picture']),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          cards[currentIndex]['name'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          cards[currentIndex]['bio'],
                          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Color.fromARGB(255, 80, 80, 80)),
                        ),
                        const SizedBox(height: 30.0),
                        const Text(
                          'Interest: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: List.generate(
                              cards[currentIndex]['interest'].length,
                              (index) {
                                return WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 4.0),
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFB6536B),
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        cards[currentIndex]['interest'][index].toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0), // Add spacing between card and buttons
                        Column(
                            children: [
                              const SizedBox(height: 5.0), 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileDashboard(id: int.parse(cards[currentIndex]['userId'])),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16, // Adjust the font size here
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    minimumSize: const Size(150, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Exciting Match Awaits!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                            content: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Are you ready to make a match with ${cards[currentIndex]['name']}?',
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.black, // Change the color to gray black
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  final response = await request.post("${globals.domain}/match/accept-flutter/",
                                                      jsonEncode(<String, String>{
                                                        "name": cards[currentIndex]['name'],
                                                        "bio": cards[currentIndex]['bio'],
                                                        "matching_id": cards[currentIndex]['matchingId'],
                                                        'id': cards[currentIndex]['userId'],
                                                      }));
                                                  if (response['status'] == 'success') {
                                                    scaffoldMessenger.showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Explore Your Favorite Books Together!"),
                                                      ),
                                                    );
                                                  }
                                                  fetchNextCard(request);
                                                  setState(() {});
                                                },
                                                child: const Text('Match'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Match',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, // Adjust the font size here
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB6536B),
                                      minimumSize: const Size(150, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
            
          ),
        );
      }

  }
}
