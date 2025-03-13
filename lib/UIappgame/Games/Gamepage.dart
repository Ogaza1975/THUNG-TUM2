import 'package:flutter/material.dart';
import 'Mostpopular/lol.dart';
import 'Mostpopular/minecraft.dart';
import 'Mostpopular/roblox.dart';
import 'Mostpopular/valorant.dart';
import 'Mostpopular/match.dart';
import 'Mostpopular/wordga.dart';
import 'Mostpopular/wordgu.dart';
import 'Mostpopular/xo.dart';
import 'Recentlyadded/citizen.dart';
import 'Recentlyadded/eldenring.dart';
import 'Recentlyadded/notime.dart';
import 'Recentlyadded/sixnight.dart';
import 'package:flutter_application_7/UIappgame/Homepage/homepage.dart';
import 'package:flutter_application_7/UIappgame/MyLibrary/Mylibrarypage.dart';
import 'package:flutter_application_7/UIappgame/ProfileEditPage/ProfileEditPage.dart';
import 'package:flutter_application_7/UIappgame/Search/Searchpage.dart';
import 'package:flutter_application_7/login/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Gamepage extends StatefulWidget {
  const Gamepage({super.key});

  @override
  _GamepageState createState() => _GamepageState();
}

class _GamepageState extends State<Gamepage> {
  int _selectedIndex = 0; // สร้างตัวแปรเพื่อเก็บค่า index ของเมนูที่ถูกเลือก

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Searchpage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mylibrary()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Gamepage()),
      );
    }
  }

  final user = FirebaseAuth.instance.currentUser;
  String userName = "กำลังโหลด...";

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const loginPage()),
    );
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // ออกจากระบบ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const loginPage(),
        ), // กลับไปหน้า Login
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();
      setState(() {
        userName = doc.exists ? doc['userName'] ?? user!.email! : user!.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> Recentlyadded = [
      {
        'title': 'no time to relax',
        'image': 'assets/images/notime.png',
        'route': (context) => Notimetorelax(),
      },
      {
        'title': 'Citizen Sleeper 2: Starward Vector',
        'image': 'assets/images/citizen0.jpg',
        'route': (context) => Citizen(),
      },
      {
        'title': '69',
        'image': 'assets/images/69_1.jpg',
        'route': (context) => Sixnight(),
      },
      {
        'title': 'Elden Ring',
        'image': 'assets/images/elden-ring1.jpg',
        'route': (context) => Eldenring(),
      },
    ];
    final List<Map<String, dynamic>> Mostpopular = [
      {
        'title': 'matching',
        'image': 'assets/images/icon_matching.webp',
        'route': (context) => matching(),
      },
      {
        'title': 'wordgamet',
        'image': 'assets/images/icon_wordgame.webp',
        'route': (context) => wordgame(),
      },
      {
        'title': 'wordguess',
        'image': 'assets/images/icon_wordguess.webp',
        'route': (context) => wordgu(),
      },
      {
        'title': 'XOgame',
        'image': 'assets/images/icon_XOgame.webp',
        'route': (context) => xo(),
      },
      {
        'title': 'Valorant',
        'image': 'assets/images/valorant1.jpg',
        'route': (context) => Valorant(),
      },
      {
        'title': 'Roblox',
        'image': 'assets/images/roblox1.png',
        'route': (context) => Roblox(),
      },
      {
        'title': 'League of Legends',
        'image': 'assets/images/lol1.png',
        'route': (context) => Lol(),
      },
      {
        'title': 'MineCraft',
        'image': 'assets/images/minecraft1.jpg',
        'route': (context) => Minecraft(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: GestureDetector(
          onTap: () async {
            final updatedName = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileEditPage()),
            );

            if (updatedName != null && updatedName is String) {
              setState(() {
                userName = updatedName;
              });
            }
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 222, 229, 230),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://yt3.googleusercontent.com/rzBsht2_AMDcJd8p2yLFAHzGsC9vNJFPywxL5kYHhzEha_5PcCWkxQlVkI2jROdBAh-9XNZXwQ=s900-c-k-c0x00ffffff-no-rj',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$userName',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              signUserOut();
              _logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently added',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SeeAll(
                                games: [
                                  {
                                    'title':
                                        'Citizen Sleeper 2: Starward Vector',
                                    'image': 'assets/images/citizen0.jpg',
                                    'publisher': 'Fellow Traveller',
                                    'route': (context) => Citizen(),
                                  },
                                  {
                                    'title': 'No time to relax',
                                    'image': 'assets/images/notime.png',
                                    'publisher': 'Fellow Traveller',
                                    'route': (context) => Notimetorelax(),
                                  },
                                  {
                                    'title': '69',
                                    'image': 'assets/images/69_1.jpg',
                                    'publisher': 'Revenscourt Games',
                                    'route': (context) => Sixnight(),
                                  },
                                  {
                                    'title': 'Elden Ring',
                                    'image': 'assets/images/elden-ring1.jpg',
                                    'publisher':
                                        'FromSoftware, Inc., Bandai Namco Entertainment',
                                    'route': (context) => Eldenring(),
                                  },
                                ],
                              ),
                        ),
                      );
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Recentlyadded.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: Recentlyadded[index]['route'],
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          Recentlyadded[index]['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Most Popular',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SeeAll(
                                games: [
                                  {
                                    'title': 'matching',
                                    'image': 'assets/images/icon_matching.webp',
                                    'publisher': 'Riot Games',
                                    'route': (context) => matching(),
                                  },
                                  {
                                    'title': 'wordgame',
                                    'image': 'assets/images/icon_wordgame.webp',
                                    'publisher': 'Riot Games',
                                    'route': (context) => wordgame(),
                                  },
                                  {
                                    'title': 'wordguess',
                                    'image':
                                        'assets/images/icon_wordguess.webp',
                                    'publisher': 'Riot Games',
                                    'route': (context) => wordgu(),
                                  },
                                  {
                                    'title': 'XOgame',
                                    'image': 'assets/images/icon_XOgame.webp',
                                    'publisher': 'Riot Games',
                                    'route': (context) => xo(),
                                  },
                                  {
                                    'title': 'Varolant',
                                    'image': 'assets/images/valorant1.jpg',
                                    'publisher': 'Riot Games',
                                    'route': (context) => Valorant(),
                                  },
                                  {
                                    'title': 'Roblox',
                                    'image': 'assets/images/roblox1.png',
                                    'publisher': 'Roblox Corporation',
                                    'route': (context) => Roblox(),
                                  },
                                  {
                                    'title': 'League of Legends',
                                    'image': 'assets/images/lol1.png',
                                    'publisher': 'Riot Games',
                                    'route': (context) => Lol(),
                                  },
                                  {
                                    'title': 'Minecraft',
                                    'image': 'assets/images/minecraft1.jpg',
                                    'publisher': 'Mojang Studios',
                                    'route': (context) => Minecraft(),
                                  },
                                ],
                              ),
                        ),
                      );
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Mostpopular.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: Mostpopular[index]['route']),
                      );
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          Mostpopular[index]['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SeeAll(
                            games: [
                              {
                                'title': 'Varolant',
                                'image': 'assets/images/valorant1.jpg',
                                'publisher': 'Riot Games',
                                'route': (context) => Valorant(),
                              },
                              {
                                'title': 'Roblox',
                                'image': 'assets/images/roblox1.png',
                                'publisher': 'Roblox Corporation',
                                'route': (context) => Roblox(),
                              },
                              {
                                'title': 'League of Legends',
                                'image': 'assets/images/lol1.png',
                                'publisher': 'Riot Games',
                                'route': (context) => Lol(),
                              },
                              {
                                'title': 'Minecraft',
                                'image': 'assets/images/minecraft1.jpg',
                                'publisher': 'Mojang Studios',
                                'route': (context) => Minecraft(),
                              },
                              {
                                'title': 'Citizen Sleeper 2: Starward Vector',
                                'image': 'assets/images/citizen0.jpg',
                                'publisher': 'Fellow Traveller',
                                'route': (context) => Citizen(),
                              },
                              {
                                'title': 'No time to relax',
                                'image': 'assets/images/notime.png',
                                'publisher': 'Fellow Traveller',
                                'route': (context) => Notimetorelax(),
                              },
                              {
                                'title': '69',
                                'image': 'assets/images/69_1.jpg',
                                'publisher': 'Revenscourt Games',
                                'route': (context) => Sixnight(),
                              },
                              {
                                'title': 'Elden Ring',
                                'image': 'assets/images/elden-ring1.jpg',
                                'publisher':
                                    'FromSoftware, Inc., Bandai Namco Entertainment',
                                'route': (context) => Eldenring(),
                              },
                            ],
                          ),
                    ),
                  );
                },
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.apps, color: Colors.white, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'All games A-Z',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green[600],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dataset),
            label: 'My Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Games',
          ),
        ],
      ),
    );
  }
}

class SeeAll extends StatefulWidget {
  final List<Map<String, dynamic>> games;
  const SeeAll({Key? key, required this.games}) : super(key: key);
  @override
  _SeeAllState createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  bool _isGridview = true;
  late List<Map<String, dynamic>> sortedGames;

  @override
  void initState() {
    super.initState();
    sortedGames = List<Map<String, dynamic>>.from(widget.games);
    sortedGames.sort(
      (a, b) => a['title'].toString().toLowerCase().compareTo(
        b['title'].toString().toLowerCase(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridview ? Icons.list : Icons.grid_view,
            ), //GirdandList
            onPressed: () {
              setState(() {
                _isGridview = !_isGridview;
              });
            },
          ),
        ],
      ),
      body:
          _isGridview
              ? GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: sortedGames.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: sortedGames[index]['route']),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              sortedGames[index]['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          sortedGames[index]['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          sortedGames[index]['publisher'],
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              )
              : ListView.builder(
                itemCount: sortedGames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        sortedGames[index]['image'],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      sortedGames[index]['title'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      sortedGames[index]['publisher'],
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: sortedGames[index]['route']),
                      );
                    },
                  );
                },
              ),
    );
  }
}
