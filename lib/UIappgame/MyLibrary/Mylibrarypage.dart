import 'package:flutter/material.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/lol.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/minecraft.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/roblox.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/valorant.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/match.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/wordga.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/wordgu.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/xo.dart';
import 'package:flutter_application_7/UIappgame/Games/Recentlyadded/citizen.dart';
import 'package:flutter_application_7/UIappgame/Games/Recentlyadded/eldenring.dart';
import 'package:flutter_application_7/UIappgame/Games/Recentlyadded/notime.dart';
import 'package:flutter_application_7/UIappgame/Games/Recentlyadded/sixnight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_7/login/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Mylibrary extends StatefulWidget {
  @override
  _MylibraryState createState() => _MylibraryState();
}

class _MylibraryState extends State<Mylibrary> {
  Map<String, Widget> favoriteGames = {
    'League of Legends': Lol(),
    'No Time to Relax': Notimetorelax(),
    'Citizen Sleeper 2: Starward Vecto': Citizen(),
    'Sixnight': Sixnight(),
    'Elden Ring': Eldenring(),
    'Valorant': Valorant(),
    'Roblox': Roblox(),
    'Minecraft': Minecraft(),
    'matching': matching(),
    'wordgame': wordgame(),
    'wordguess': wordgu(),
    'xo': xo(),
    // สามารถเพิ่มเกมอื่นได้ที่นี่ เช่น 'Another Game': AnotherGamePage(),
  };
  Map<String, String> gameImages = {
    'League of Legends': 'assets/images/lol1.png',
    'Minecraft': 'assets/images/minecraft1.jpg',
    'Roblox': 'assets/images/roblox1.png',
    'Valorant': 'assets/images/valorant1.jpg',
    'Elden Ring': 'assets/images/elden-ring1.jpg',
    'Citizen Sleeper 2: Starward Vecto': 'assets/images/citizen0.jpg',
    'Sixnight': 'assets/images/69_1.jpg',
    'No Time to Relax': 'assets/images/notime.png',
    'matching': 'assets/images/icon_matching.webp',
    'wordgame': 'assets/images/icon_wordgame.webp',
    'wordguess': 'assets/images/icon_wordguess.webp',
    'xo': 'assets/images/icon_XOgame.webp',
  };
  Map<String, String> gameDevelopers = {
    'League of Legends': 'Riot Games',
    'Minecraft': 'Mojang Studios',
    'Roblox': 'Roblox Corporation',
    'Valorant': 'Riot Games',
    'Elden Ring': 'FromSoftware',
    'Citizen Sleeper 2: Starward Vecto': 'Fellow Traveller',
    'Sixnight': 'Revenscourt Games',
    'No Time to Relax': 'Porcelain Fortress',
    'matching': 'Mark & Phai',
    'wordgame': 'Mark & Phai',
    'wordguess': 'Mark & Phai',
    'xo': 'Mark & Phai',
  };

  List<String> _favoriteKeys = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteKeys =
          favoriteGames.keys
              .where(
                (key) =>
                    prefs.getBool(
                      'favorite_${key.toLowerCase().replaceAll(" ", "_")}',
                    ) ??
                    false,
              )
              .toList();
    });
  }

  final user = FirebaseAuth.instance.currentUser;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 51, 42, 42),
      appBar: AppBar(
        title: Text('My Library'),
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
      body:
          _favoriteKeys.isNotEmpty
              ? ListView.builder(
                itemCount: _favoriteKeys.length,
                itemBuilder: (context, index) {
                  String gameTitle = _favoriteKeys[index];
                  return ListTile(
                    leading: Image.asset(
                      gameImages[gameTitle] ?? 'assets/images/elden-ring5.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      gameTitle,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      gameDevelopers[gameTitle] ?? 'Unknown Developer',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => favoriteGames[gameTitle]!,
                        ),
                      ).then((_) {
                        _loadFavoriteStatus(); // โหลดข้อมูลใหม่หลังจากกลับมา
                      });
                    },
                  );
                },
              )
              : Center(
                child: Text(
                  'No favorite games yet.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
    );
  }
}
