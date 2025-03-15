import 'package:flutter/material.dart';
import 'package:flutter_application_7/UIappgame/ProfileEditPage/ProfileEditPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Minecraft extends StatefulWidget {
  @override
  _MinecraftState createState() => _MinecraftState();
}

class _MinecraftState extends State<Minecraft> {
  final PageController _pageController = PageController(viewportFraction: 0.55);

  final List<String> imagePaths = [
    'assets/images/minecraft2.jpg',
    'assets/images/minecraft3.jpg',
    'assets/images/minecraft4.jpg',
    'assets/images/minecraft5.jpg',
  ];
  bool _isDescriptionExpanded = false;
  bool _isDetailsSelected = true;
  bool _isFavorite = false;
  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _fetchUserName();
  }

  final user = FirebaseAuth.instance.currentUser;
  String userName = "กำลังโหลด...";
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

  Future<void> _loadFavoriteStatus() async {
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc('Minecraft'); // ใช้ชื่อเกมเป็นไอดีเอกสาร

    final doc = await docRef.get();
    setState(() {
      _isFavorite = doc.exists ? doc['isFavorite'] ?? false : false;
    });
  }

  Future<void> _toggleFavorite() async {
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc('Minecraft');

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      await docRef.set({'isFavorite': true});
    } else {
      await docRef.delete();
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game header with image, title, and install button
            Stack(
              children: [
                // Blurred background image
                // Container(
                //   height: 300,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     image: const DecorationImage(
                //       image: AssetImage('assets/images/cccccc.png'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                // Content overlay
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Game icon, title, price row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Game icon with Game Pass label
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/minecraft1.jpg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Title, subtitle, price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Minecraft',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Mojang Studios',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Platform icons
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_android,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Install button
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween, // จัดให้มีระยะห่างระหว่างปุ่ม
                        children: [
                          // ปุ่ม INSTALL TO
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'INSTALL TO',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16), // เพิ่มระยะห่างระหว่างปุ่ม
                          // ปุ่ม Favorite ❤️
                          IconButton(
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : Colors.white,
                              size: 30, // ปรับขนาดไอคอนให้ใหญ่ขึ้น
                            ),
                            onPressed: _toggleFavorite,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Age rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.black,
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'IARC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                                Text(
                                  '12+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '12+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Mild Swearing',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // More options button
                Positioned(
                  right: 16,
                  bottom: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            // Tabs (Details, Capabilities)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDetailsSelected = true;
                        });
                      },
                      child: _buildTab('Details', _isDetailsSelected),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDetailsSelected = false;
                        });
                      },
                      child: _buildTab('Capabilities', !_isDetailsSelected),
                    ),
                  ],
                ),
              ),
            ),
            // Here's the fix - use different widgets based on the selected tab
            _isDetailsSelected
                ? _buildDetailsSection()
                : _buildCapabilitiesSection(),

            // Game screenshots gallery
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Container(
          height: 3,
          width: 60,
          color: isSelected ? Colors.white : Colors.transparent,
        ),
      ],
    );
  }

  // Created a separate method for details content
  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Details info

        // Game screenshots gallery
        Container(
          height: 175,
          padding: EdgeInsets.zero, // ป้องกัน padding ด้านซ้าย
          child: PageView.builder(
            controller: _pageController,
            itemCount: imagePaths.length,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(), // เลื่อนแบบ snap ทีละรูป
            padEnds: false, // ทำให้รูปแรกชิดซ้าย
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imagePaths[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),

        // Game description
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Minecraft โลกแห่งการสร้างสรรค์ ที่ทุกสิ่งเป็นไปได้',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Text(
                'คุณเคยจินตนาการถึงโลกที่ทุกสิ่งสร้างขึ้นจาก "บล็อก" ไหม? โลกที่คุณสามารถขุดดิน สร้างบ้าน ต่อสู้กับสัตว์ประหลาด และผจญภัยในโลกกว้างได้อย่างอิสระ Minecraft คือเกมที่เปิดโอกาสให้คุณได้ทำทุกสิ่งเหล่านั้น และอื่น ๆ อีกมากมาย!',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _isDescriptionExpanded
                  ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'อิสระในการสร้างสรรค์',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'สร้างทุกสิ่งที่คุณต้องการ ไม่มีข้อจำกัดสำหรับจินตนาการของคุณ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'การผจญภัยที่น่าตื่นเต้น',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'สำรวจโลกกว้าง พบกับสิ่งมีชีวิตหลากหลายชนิด และต่อสู้กับสัตว์ประหลาด',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'เล่นได้หลากหลายรูปแบบ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'เล่นคนเดียวหรือเล่นกับเพื่อน ๆ ก็ได้ มีโหมดการเล่นให้เลือกมากมาย',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ความสนุกไม่รู้จบ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Minecraft เป็นเกมที่คุณสามารถเล่นได้เรื่อย ๆ ไม่มีวันเบื่อ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )
                  : const Text(''),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                },
                child: Text(
                  _isDescriptionExpanded ? 'Less' : 'More',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Added capabilities content
  Widget _buildCapabilitiesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Playable On',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Android',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Size',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '1.5 GB',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Capabilities',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildCapabilityChip('4K Ultra HD'),
                    _buildCapabilityChip('Single player'),
                    _buildCapabilityChip('Optimized for Android'),
                    _buildCapabilityChip('Mark1 achievements'),
                    _buildCapabilityChip('Mark1 presence'),
                    _buildCapabilityChip('Mark1 cloud saves'),
                    _buildCapabilityChip('Mark1 Play Anywhere'),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'System Requirements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRequirementsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for capability items

  // Helper method for capability chips
  Widget _buildCapabilityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildRequirementsSection() {
    final requirements = [
      {'title': 'OS', 'value': 'Android 13'},
      {'title': 'Architecture', 'value': 'ARM64'},
      {
        'title': 'Graphics',
        'value': 'Adreno GPU (or similar) compatible with Android 13',
      },
      {
        'title': 'Processor',
        'value': 'Requires an ARM64 processor and Android 13',
      },
      {'title': 'Memory', 'value': '4 GB RAM'},
      {'title': 'Video Memory', 'value': '4 GB available space'},
      {'title': 'Input', 'value': 'Touchscreen'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minimum',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...requirements.map(
          (req) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    req['title']!,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    req['value']!,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
