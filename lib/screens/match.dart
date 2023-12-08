import 'package:bookmate/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';


class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;

  @override
  void initState() {
    super.initState();
    List<User> users = [
      User(userName: "akniv.c", firstName: "Vinka", lastName: "Alrezky", bio: "🌙 out of sight, out of mind", imageUrl: _getRandomImageUrl()),
      User(userName: "lidwina.jv", firstName: "Lidwina", lastName: "Eurora", bio: "Finding magic in the little things ✨", imageUrl: _getRandomImageUrl()),
      User(userName: "caressa.py", firstName: "Caressa", lastName: "Putri", bio: "Lover of nature", imageUrl: _getRandomImageUrl()),
      User(userName: "tengku.js", firstName: "Tengku", lastName: "Laras", bio: "Enthusiast of music", imageUrl: _getRandomImageUrl()),
      // Tambahkan lebih banyak user...
    ];

    for (var user in users) {
      _swipeItems.add(SwipeItem(
        content: Content(user: user),
        likeAction: () {
          print("Liked ${user.firstName}");
        },
        nopeAction: () {
          print("Nope ${user.firstName}");
        },
        // Other actions...
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match"),
        backgroundColor: const Color(0xFFB6536B).withOpacity(0.9),
      ),
      drawer: RightDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: SwipeCards(
                    matchEngine: _matchEngine,
                    itemBuilder: (BuildContext context, int index) {
                      User user = _swipeItems[index].content.user;
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                user.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text('${user.firstName} ${user.lastName}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                  Text(user.userName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFB6536B))),
                                  Text(user.bio, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    onStackFinished: () {
                      print('Swipe stack finished');
                    },
                    itemChanged: (SwipeItem item, int index) {},
                    upSwipeAllowed: true,
                    fillSpace: true,
                  ),
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: const Color(0xFFB6536B),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.clear, color: Colors.black, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.visibility, color: Colors.black, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.black, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  String _getRandomImageUrl() {
    return 'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}';
  }
}

class Content {
  final User user;

  Content({required this.user});
}

class User {
  final String userName;
  final String firstName;
  final String lastName;
  final String bio;
  final String imageUrl;

  User({required this.userName, required this.firstName, required this.lastName, required this.bio, required this.imageUrl});
}


