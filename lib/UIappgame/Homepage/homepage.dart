import 'package:flutter/material.dart';
import 'package:flutter_application_7/UIappgame/Games/Gamepage.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/minecraft.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/roblox.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/valorant.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/xo.dart';
import 'package:flutter_application_7/UIappgame/Games/Recentlyadded/eldenring.dart';
import 'package:flutter_application_7/UIappgame/MyLibrary/Mylibrarypage.dart';
import 'package:flutter_application_7/UIappgame/ProfileEditPage/ProfileEditPage.dart';
import 'package:flutter_application_7/UIappgame/Search/Searchpage.dart';
import 'package:flutter_application_7/login/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UIappgame extends StatefulWidget {
  const UIappgame({super.key});

  @override
  State<UIappgame> createState() => _UIappgameState();
}

class _UIappgameState extends State<UIappgame> {
  @override
  Widget build(BuildContext context) {
    return const Homepage(); // ✅ โหลด Homepage ตรงๆ ไม่ต้องมี MaterialApp ซ้อน
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
    final List<Map<String, dynamic>> games = [
      {
        'title': 'Roblox',
        'image': 'assets/images/roblox1.png',
        'route': (context) => Roblox(),
      },
      {
        'title': 'MineCraft',
        'image': 'assets/images/minecraft1.jpg',
        'route': (context) => Minecraft(),
      },
      {
        'title': 'Valorant',
        'image': 'assets/images/valorant1.jpg',
        'route': (context) => Valorant(),
      },
    ];
    final List<Map<String, dynamic>> billboard = [
      {
        'title': 'Elden Ring',
        'image': 'assets/images/elden-ring1.jpg',
        'route': (context) => Eldenring(),
      },
      {
        'title': 'XO',
        'image': 'assets/images/icon_XOgame.webp',
        'route': (context) => xo(),
      },
      // เพิ่มเกมอื่นๆ ตามต้องการ
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

      //-App Barrrrrrrrrr-//
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: billboard.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: billboard[index]['route']),
                      );
                    },
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(176, 236, 232, 232),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              billboard[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      const Color.fromARGB(255, 0, 0, 0),
                                      const Color.fromARGB(0, 0, 0, 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                    'Popular on THUNG TUM2',
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
                        MaterialPageRoute(builder: (context) => Gamepage()),
                      );
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: games[index]['route']),
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
                          games[index]['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      //bottomNavigationBar: BottomNavigationBar
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
