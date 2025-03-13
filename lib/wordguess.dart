import 'package:flutter/material.dart';

class homewordguess extends StatelessWidget {
  const homewordguess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/wordguess_main.webp",
            ), // รูปพื้นหลัง
            fit: BoxFit.cover, // ปรับขนาดให้เต็มหน้าจอ
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 300), // จัดให้อยู่ชิดซ้าย
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    143,
                    233,
                    233,
                    233,
                  ), // ✅ เปลี่ยนสีพื้นหลังเป็นสีแดง
                  borderRadius: BorderRadius.circular(10), // ✅ ทำให้ขอบโค้งมน
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 32,
                  ),
                  onPressed:
                      () => Navigator.pop(context), // กลับไปหน้าเลือกด่าน
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ), // เพิ่มระยะห่างภายใน
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7), // สีพื้นหลังดำโปร่งแสง
                  borderRadius: BorderRadius.circular(10), // ขอบโค้งมน
                ),
                child: const Text(
                  "เลือกหมวดหมู่",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // สีตัวอักษร
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              const SizedBox(height: 100), // ✅ เพิ่มระยะห่างด้านล่าง
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // มุมโค้งของปุ่ม
                    side: const BorderSide(
                      color: Colors.black, // ✅ สีกรอบ
                      width: 1, // ✅ ความหนาของกรอบ
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuessGame(category: 'สัตว์'),
                    ),
                  );
                },
                child: const Text(
                  'ทายชื่อสัตว์',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // มุมโค้งของปุ่ม
                    side: const BorderSide(
                      color: Colors.black, // ✅ สีกรอบ
                      width: 1, // ✅ ความหนาของกรอบ
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const GuessGame(category: 'ผักผลไม้'),
                    ),
                  );
                },
                child: const Text(
                  'ทายชื่อผักผลไม้',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // มุมโค้งของปุ่ม
                    side: const BorderSide(
                      color: Colors.black, // ✅ สีกรอบ
                      width: 1, // ✅ ความหนาของกรอบ
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuessGame(category: 'อาชีพ'),
                    ),
                  );
                },
                child: const Text(
                  'ทายชื่ออาชีพ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GuessGame extends StatefulWidget {
  final String category;
  const GuessGame({super.key, required this.category});

  @override
  _GuessGameState createState() => _GuessGameState();
}

class _GuessGameState extends State<GuessGame> {
  int level = 0;
  late List<Map<String, String>> questions;
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category == 'สัตว์') {
      questions = [
        {'image': 'assets/images/animal1.webp', 'answer': 'สิงโต'},
        {'image': 'assets/images/animal2.jpg', 'answer': 'ช้าง'},
        {'image': 'assets/images/animal3.jpg', 'answer': 'ม้า'},
        {'image': 'assets/images/animal4.jpg', 'answer': 'สุนัข'},
        {'image': 'assets/images/animal5.jpg', 'answer': 'แมว'},
      ];
    } else if (widget.category == 'ผักผลไม้') {
      questions = [
        {'image': 'assets/images/fruit1.jpg', 'answer': 'มะม่วง'},
        {'image': 'assets/images/fruit2.png', 'answer': 'กล้วย'},
        {'image': 'assets/images/fruit3.jpg', 'answer': 'ส้ม'},
        {'image': 'assets/images/fruit4.jpg', 'answer': 'แตงโม'},
        {'image': 'assets/images/fruit5.png', 'answer': 'องุ่น'},
      ];
    } else {
      questions = [
        {'image': 'assets/images/job1.jpg', 'answer': 'หมอ'},
        {'image': 'assets/images/job2.webp', 'answer': 'ครู'},
        {'image': 'assets/images/job3.png', 'answer': 'ตำรวจ'},
        {'image': 'assets/images/job4.jpg', 'answer': 'ทหาร'},
        {'image': 'assets/images/job5.png', 'answer': 'วิศวกร'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wordguess_game.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50), // ระยะห่างจากขอบบนของจอ
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "ด่านที่ ${level + 1}", // แสดงด่านที่ X
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sarabun',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  questions[level]['image']!,
                  width: 300,
                  height: 300,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(185, 98, 235, 223),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'พิมพ์คำตอบที่นี่',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Sarabun',
                  ),
                ),
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (answerController.text == questions[level]['answer']) {
                  if (level < questions.length - 1) {
                    setState(() {
                      level++;
                      answerController.clear();
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: const Color.fromARGB(
                              255,
                              67,
                              172,
                              221,
                            ),
                            title: const Text('🎉🎉คุณชนะแล้ว!🎉🎉'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    193,
                                    233,
                                    59,
                                    59,
                                  ),
                                ),
                                child: const Text(
                                  '🔙กลับหน้าหลัก',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(190, 82, 219, 40),
              ),
              child: const Text(
                '✅ตรวจคำตอบ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(193, 233, 59, 59),
              ),
              child: const Text(
                '🔙กลับหน้าหลัก',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
