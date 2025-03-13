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
import 'package:flutter_application_7/UIappgame/ProfileEditPage/ProfileEditPage.dart';
import 'package:flutter_application_7/login/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({Key? key}) : super(key: key);
  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [
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
    {
      'title': 'MatchingGame',
      'image': 'assets/images/icon_matching.webp',
      'route': (context) => matching(),
    },
    {
      'title': 'WordGame',
      'image': 'assets/images/icon_wordgame.webp',
      'route': (context) => wordgame(),
    },
    {
      'title': 'WordGuess',
      'image': 'assets/images/icon_wordguess.webp',
      'route': (context) => wordgu(),
    },
    {
      'title': 'Xo',
      'image': 'assets/images/icon_XOgame.webp',
      'route': (context) => xo(),
    },
  ];
  List<Map<String, dynamic>> filteredItems = []; // รายการกรองตามการค้นหา
  List<String> recentSearches = []; //การค้นหาล่าสุด
  bool _isSearchFocused = false; // ติดตามว่าช่องค้นหากำลังได้รับโฟกัสหรือไม่

  @override
  void initState() {
    super.initState();
    filteredItems = [...allItems];
    _fetchUserName();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = [...allItems];
      } else {
        filteredItems =
            List<Map<String, dynamic>>.from(allItems)
                .where(
                  (item) =>
                      item['title'].toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _navigateToPage(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(context, MaterialPageRoute(builder: item['route']));
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
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileEditPage()),
            ).then((_) {
              // เมื่อกลับมาจากหน้า edit ให้ rebuild หน้า homepage
              setState(() {});
            });
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 143, 136, 136),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 243, 241, 241),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: const Color.fromARGB(255, 44, 31, 31),
                          size: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 29, 24, 24),
                      ),
                      onChanged: (value) {
                        //ส่งข้อความที่กรอกไปให้_filterItems
                        _filterItems(value);
                      },
                      onTap: () {
                        setState(() {
                          _isSearchFocused = true;
                        });
                      },
                    ),
                  ),
                ),
                if (_isSearchFocused)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _filterItems('');
                        _isSearchFocused = false;
                      });
                    },
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child:
                _searchController.text.isEmpty
                    ? _buildRecentSearches() //ถ้าช่องค้นหาว่าง
                    : _buildSearchResults(), //มีข้อความในช่องค้นหา → แสดงผลลัพธ์การค้นหา
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text('ค้นหาล่าสุด', style: TextStyle(color: Colors.white)),
              InkWell(
                onTap: () {
                  setState(() {
                    recentSearches.clear();
                  });
                },
                child: const Text(
                  'ล้างทั้งหมด',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              final gameItem = allItems.firstWhere(
                (item) => item['title'] == recentSearches[index],
                orElse: () => allItems[0],
              );
              return ListTile(
                title: Text(
                  recentSearches[index],
                  style: TextStyle(color: Colors.white),
                ),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(gameItem['image']),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {
                    setState(() {
                      recentSearches.removeAt(index);
                    });
                  },
                ),
                onTap: () {
                  _navigateToPage(context, gameItem);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(item['image'])),
          title: Text(item['title'], style: TextStyle(color: Colors.white)),
          onTap: () {
            if (!recentSearches.contains(filteredItems[index]['title'])) {
              //ค่า filteredItems[index] (ไอเท็มที่ถูกกรองจากการค้นหา) ยังไม่มีใน recentSearches
              setState(() {
                recentSearches.insert(
                  0,
                  filteredItems[index]['title'],
                ); //เพิ่มค่าใหม่(filteredItems[index])เข้าไป(index 0)ของ recentSearchesเพื่อให้รายการที่เพิ่งค้นหาถูกแสดงเป็นรายการแรก(ล่าสุด)
                if (recentSearches.length > 10) {
                  recentSearches.removeLast();
                }
              });
            }
            _navigateToPage(context, item);
          },
        );
      },
    );
  }
}
