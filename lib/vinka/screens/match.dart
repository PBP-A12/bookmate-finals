import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmate/globals.dart' as globals;

class MatchPage extends StatefulWidget {
  MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  int currentIndex = 0;

  List<Map<String, dynamic>> cards = [
    {'name': '', 'interest': [], 'bio': '', 'matchingId': '', 'userId': '', 'picture': ''},
    // Add more cards as needed
  ];

  Future<void> fetchNextCard(CookieRequest request) async {
    final response = await http.get(
      Uri.parse('${globals.domain}/match/get_match_flutter'),
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
    // Fetch the first card when the widget is initialized
    fetchNextCard(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          currentIndex < cards.length
              ? GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      // Swiped right
                      fetchNextCard(request);
                    } else if (details.primaryVelocity! < 0) {
                      // Swiped left
                      fetchNextCard(request);
                    }
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    margin: const EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.58,    
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
                        ],
                      ),
                    ),
                  ),
                )
              : const Text('No matches available'),
                const SizedBox(height: 5.0), // Add spacing between card and buttons
                  Container(
                    alignment: Alignment.center,
                    child: 
                    Column(children: [
                      ElevatedButton.icon(
                                onPressed: () {
                                },
                                icon: const Icon(
                                  Icons.person,
                                  color: Colors.white, // Warna ikon dalam tombol
                                ),
                                label: const Text(
                                  'See Profile',
                                  style: TextStyle(
                                    color: Colors.white, // Warna teks dalam tombol
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // Warna tombol untuk Swipe Kiri
                                ),
                              ),
                          Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  fetchNextCard(request);
                                  setState(() {
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_circle_left_outlined,
                                  color: Colors.white, // Warna ikon dalam tombol
                                ),
                                label: const Text(
                                  'Swipe Kiri',
                                  style: TextStyle(
                                    color: Colors.white, // Warna teks dalam tombol
                                  ),
                                ),      
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // Warna tombol untuk Swipe Kiri
                                ),
                              ),

                              ElevatedButton.icon(
                                onPressed: () async {
                                  final response = await request.post("${globals.domain}/match/accept-flutter/",
                                  jsonEncode(<String, String>{
                                    "name" : cards[currentIndex]['name'],
                                    "bio" : cards[currentIndex]['bio'],
                                    "matching_id" : cards[currentIndex]['matchingId'],
                                    'id' : cards[currentIndex]['userId'],
                                }));
                                // print(response['status']);
                                if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                    content: Text("Explore Your Favorite Books Together!"),
                                    ));
                                }
                                  fetchNextCard(request);
                                  setState(() {
                                  });
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.white, // Warna ikon dalam tombol
                                ),
                                label: const Text(
                                  'Swipe Kanan',
                                  style: TextStyle(
                                    color: Colors.white, // Warna teks dalam tombol
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB6536B), // Warna tombol untuk Swipe Kiri   
                                ),
                              ),
                            ],
                          ),
                    ]),
                    )
        ],
      ),
    );
  }
}
