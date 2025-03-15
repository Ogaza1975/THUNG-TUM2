import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_7/UIappgame/Games/Mostpopular/wordga.dart';

class homewordgame extends StatefulWidget {
  const homewordgame({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homewordgame> {
  int? savedLevel;

  @override
  void initState() {
    super.initState();
    _loadSavedLevel();
  }

  Future<void> _loadSavedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedLevel = prefs.getInt('level') ?? 1;
    });
  }

  void _startNewGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', 1);
    setState(() {
      savedLevel = 1;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LevelSelectionwordgame(level: 1),
      ),
    );
  }

  void _continueGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelSelectionwordgame(level: savedLevel!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ตรวจจับปุ่มย้อนกลับของอุปกรณ์
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const wordgame()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/word.png"), // รูปพื้นหลัง
              fit: BoxFit.cover, // ปรับขนาดให้เต็มหน้าจอ
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 300),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(143, 233, 233, 233),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 32,
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt(
                        'level',
                        1,
                      ); // ตั้งค่า savedLevel เป็น 1
                      setState(() {
                        savedLevel = 1;
                      });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const wordgame(),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _startNewGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    side: const BorderSide(
                      color: Colors.black, // ✅ สีกรอบ
                      width: 1, // ✅ ความหนาของกรอบ
                    ),
                  ),
                  child: const Text(
                    'เริ่มเกมใหม่',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (savedLevel != null && savedLevel! > 1)
                  ElevatedButton(
                    onPressed: _continueGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      side: const BorderSide(
                        color: Colors.black, // ✅ สีกรอบ
                        width: 1, // ✅ ความหนาของกรอบ
                      ),
                    ),
                    child: const Text(
                      'เล่นต่อจากด่านเดิม',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LevelSelectionwordgame extends StatefulWidget {
  final int level;
  const LevelSelectionwordgame({super.key, required this.level});

  @override
  _LevelSelectionwordgameState createState() => _LevelSelectionwordgameState();
}

class _LevelSelectionwordgameState extends State<LevelSelectionwordgame> {
  late String shuffledWord;
  late String correctWord;
  TextEditingController controller = TextEditingController();

  final List<String> wordList = [
    'CAT',
    'DOG',
    'SUN',
    'MOON',
    'STAR',
    'APPLE',
    'MOUSE',
    'TIGER',
    'HOUSE',
    'CANDLE',
    'FIRE',
    'PLANT',
    'RIVER',
    'MOUNTAIN',
    'BOTTLE',
  ];

  @override
  void initState() {
    super.initState();
    _generateWord();
  }

  void _generateWord() {
    int length = 3 + ((widget.level - 1) ~/ 2).clamp(0, 5);
    List<String> filteredWords =
        wordList.where((word) => word.length == length).toList();

    correctWord =
        filteredWords.isNotEmpty
            ? filteredWords[Random().nextInt(filteredWords.length)]
            : 'SUN';

    shuffledWord = String.fromCharCodes(correctWord.runes.toList()..shuffle());
    setState(() {});
  }

  void _checkAnswer() async {
    if (controller.text.toUpperCase() == correctWord) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('level', widget.level + 1);
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(
                255,
                255,
                255,
                255,
              ), // ✅ เปลี่ยนสีพื้นหลังของกล่องแจ้งเตือน
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // ✅ ทำให้มุมมน
                side: const BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0), // ✅ เปลี่ยนสีกรอบ
                  width: 2, // ✅ กำหนดความหนาของกรอบ
                ),
              ),
              title: const Text(
                '🎉🎉ถูกต้อง!🎉🎉',
                textAlign: TextAlign.center, // ✅ จัดให้อยู่ตรงกลาง
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sarabun',
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              content: const Text(
                'คุณต้องการเล่นต่อหรือไม่?',
                textAlign: TextAlign.center, // ✅ จัดให้อยู่ตรงกลาง
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                LevelSelectionwordgame(level: widget.level + 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // เปลี่ยนสีพื้นหลังของปุ่ม "ไปด่านถัดไป"
                  ),
                  child: const Text(
                    'ไปด่านถัดไป',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sarabun',
                    ), // เปลี่ยนสีตัวอักษร
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const homewordgame(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // เปลี่ยนสีพื้นหลังของปุ่ม "กลับไปหน้าหลัก"
                  ),
                  child: const Text(
                    'กลับไปหน้าหลัก',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sarabun',
                    ), // เปลี่ยนสีตัวอักษร
                  ),
                ),
              ],
            ),
      );
    }
  }

  void _goBackHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const homewordgame()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const wordgame()),
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/word.png"), // รูปพื้นหลัง
              fit: BoxFit.cover, // ปรับขนาดให้เต็มหน้าจอ
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // เพิ่มระยะห่างด้านบน
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40), // ระยะขอบ
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      195,
                      0,
                      0,
                      0,
                    ).withOpacity(0.7), // ✅ พื้นหลังดำโปร่งแสง
                    borderRadius: BorderRadius.circular(10), // ✅ ขอบโค้งมน
                  ),
                  child: Text(
                    'ด่านที่ ${widget.level}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 250), // เว้นระยะก่อนแสดงคำสุ่ม
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 218, 203, 63),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(
                          text: 'ตัวอักษรที่ได้: ', // ไม่มีระยะห่าง
                          style: TextStyle(
                            letterSpacing: 0,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                        TextSpan(
                          text: shuffledWord
                              .split('')
                              .join(' '), // ใส่ช่องว่างระหว่างตัวอักษร
                          style: const TextStyle(
                            letterSpacing: 2,
                          ), // ปรับระยะห่างระหว่างตัวอักษร
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      184,
                      181,
                      228,
                      224,
                    ), // สีพื้นหลังของช่องกรอก
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none, // เอาเส้นขอบออก
                      hintText: 'พิมพ์คำตอบที่นี่',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Sarabun',
                      ), // เปลี่ยนสีข้อความ
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(190, 82, 219, 40),
                      ),
                      child: const Text(
                        '✅ตรวจสอบคำตอบ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _goBackHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(193, 233, 59, 59),
                      ),
                      child: const Text(
                        '🔙กลับไปหน้าหลัก',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
