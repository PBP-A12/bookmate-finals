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
  List<dynamic> interest = [];
  String bio = '';
  String matchingId = '';
  String userId = '';
  String picture = '';


Future<void> getMatch(CookieRequest request) async {
    final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/match/get_match_flutter'),
    headers: request.headers,
    );
    // Perform error handling for the response
      if (response.statusCode == 200) {
        // Decode the response body
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        name = data['name'];
        interest = data['interest_subject'];
        bio = data['bio'];
        matchingId = data['matching_id'].toString();
        userId = data['id'].toString();
        picture = data["picture"];
      } else {
        throw Exception('Failed to fetch subjects');
      }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match'),
      ),
      drawer: const RightDrawer(),
      body: Center(
        child: FutureBuilder<void>(
          future: getMatch(request),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12.0),  // Tambahkan jarak vertikal di sini
                          // Placeholder untuk gambar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  picture, // URL gambar random
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),  // Tambahkan jarak vertikal di sini
                          Text(
                            bio,
                            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Color.fromARGB(255, 80, 80, 80)),
                          ),
                          const SizedBox(height: 16.0),  // Tambahkan jarak vertikal di sini
                          const Text('Interest: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),),
                          RichText(
                            textAlign: TextAlign.center,

                            text: TextSpan(
                              children: 
                              List.generate(interest.length, (index) {
                                SizedBox(height: 10,);
                                return WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10,right: 10, bottom: 5),
                                      decoration: BoxDecoration(
                                        color:  const Color(0xFFB6536B),
                                        // border: Border.all(color: Colors.pink),
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        interest[index].toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              ),
                              
                            ),
                          ),

                          const SizedBox(height: 12.0),  // Tambahkan jarak vertikal di sini
                          
                        ],
                      ),
                    ),
                  ),
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
                                  getMatch(request);
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
                                  final response = await request.post("http://10.0.2.2:8000/match/accept-flutter/",
                                  jsonEncode(<String, String>{
                                    "name" : name,
                                    "bio" : bio,
                                    "matching_id" : matchingId,
                                    'id' : userId,
                                }));
                                // print(response['status']);
                                if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                    content: Text("Explore Your Favorite Books Together!"),
                                    ));
                                }
                                  getMatch(request);
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
              );
            }
          },
        ),
      ),
    );
  }
}




