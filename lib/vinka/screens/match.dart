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
        child: currentIndex < cards.length
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
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft, // Add this line
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                      children: [
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
                        const SizedBox(height: 16.0),
                        Text(
                          cards[currentIndex]['name'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          cards[currentIndex]['bio'],
                          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Color.fromARGB(255, 80, 80, 80)),
                        ),
                        const SizedBox(height: 16.0),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
              )
            : const Text('No matches available'),
    );
  }
}




