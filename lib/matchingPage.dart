import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class homematching extends StatelessWidget {
  const homematching({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/matching.png"), // รูปพื้นหลัง
            fit: BoxFit.cover, // ปรับขนาดให้เต็มหน้าจอ
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //ปุ่มย้อนกลับ
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

              //ข้อความแสดงคำว่าเลือกด่าน
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
                  "เลือกด่าน",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // สีตัวอักษร
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              const SizedBox(height: 100), // ✅ เพิ่มระยะห่างด้านล่าง
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ), // สีพื้นหลัง
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // มุมโค้งของปุ่ม
                    side: const BorderSide(
                      color: Colors.black, // ✅ สีกรอบ
                      width: 1, // ✅ ความหนาของกรอบ
                    ),
                  ),
                ),
                onPressed: () => _startGame(context, 1),
                child: const Text(
                  "ด่านที่ 1 (2x3)",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), // สีตัวอักษร
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              const SizedBox(height: 100), // ปรับความห่างระหว่างปุ่ม
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ), // สีพื้นหลัง
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // มุมโค้งของปุ่ม
                    side: const BorderSide(
                      color: Colors.black, // ✅ สีกรอบ
                      width: 1, // ✅ ความหนาของกรอบ
                    ),
                  ),
                ),
                onPressed: () => _startGame(context, 2),
                child: const Text(
                  "ด่านที่ 2 (3x4)",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), // สีตัวอักษร
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              const SizedBox(height: 100), // ปรับความห่างระหว่างปุ่ม
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ), // สีพื้นหลัง
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // มุมโค้งของปุ่ม
                    side: const BorderSide(
                      color: Colors.black, // ✅ สีกรอบ
                      width: 1, // ✅ ความหนาของกรอบ
                    ),
                  ),
                ),
                onPressed: () => _startGame(context, 3),
                child: const Text(
                  "ด่านที่ 3 (4x4)",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), // สีตัวอักษร
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

  void _startGame(BuildContext context, int level) {
    //คำสั่งให้เริ่มเกมตามlevel ที่กำหนด
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MemoryGame(level: level)),
    );
  }
}

class MemoryGame extends StatefulWidget {
  final int level;

  const MemoryGame({super.key, required this.level});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<String> images;
  late List<bool> revealed;
  int? firstIndex;
  int? secondIndex;
  bool canTap = true;
  bool isWin = false;

  late int rows;
  late int cols;
  late int totalPairs;

  @override
  void initState() {
    super.initState();
    _setupLevel();
    _initializeGame();
  }

  void _setupLevel() {
    //กำขนาดของแต่ละด่าน
    switch (widget.level) {
      case 1:
        rows = 3;
        cols = 2;
        totalPairs = 6;
        break;
      case 2:
        rows = 4;
        cols = 3;
        totalPairs = 12;
        break;
      case 3:
        rows = 4;
        cols = 4;
        totalPairs = 16;
        break;
    }
  }

  void _initializeGame() {
    List<String> allImages = [
      '🍎',
      '🍌',
      '🍇',
      '🍉',
      '🍓',
      '🍒',
      '🍍',
      '🥝',
      '🥑',
      '🥥',
    ];
    images =
        (allImages
              .sublist(0, totalPairs ~/ 2)
              .expand((e) => [e, e]) // ทำให้ภาพซ้ำกัน 2 ครั้ง
              .toList())
          ..shuffle(Random());

    revealed = List.filled(totalPairs, false);
    firstIndex = null;
    secondIndex = null;
    canTap = true;
    isWin = false;
  }

  void onCardTap(int index) {
    if (!canTap || revealed[index] || firstIndex == index) return;

    setState(() {
      if (firstIndex == null) {
        firstIndex = index;
      } else if (secondIndex == null) {
        secondIndex = index;
        canTap = false;

        if (images[firstIndex!] == images[secondIndex!]) {
          revealed[firstIndex!] = true;
          revealed[secondIndex!] = true;
          firstIndex = null;
          secondIndex = null;
          canTap = true;

          if (revealed.every((element) => element)) {
            isWin = true;
          }
        } else {
          Timer(const Duration(seconds: 1), () {
            setState(() {
              firstIndex = null;
              secondIndex = null;
              canTap = true;
            });
          });
        }
      }
    });
  }

  void restartGame() {
    setState(() {
      _initializeGame();
    });
  }

  void nextLevel() {
    if (widget.level < 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MemoryGame(level: widget.level + 1),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/matching.png"), // ✅ รูปพื้นหลัง
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50), // ✅ เพิ่มระยะห่างจากขอบจอ
            // ✅ ปุ่มย้อนกลับ + ข้อความ "ด่านที่ X" + ปุ่ม Refresh
            Column(
              children: [
                // ✅ ปุ่มย้อนกลับ
                Container(
                  margin: const EdgeInsets.only(
                    right: 300,
                  ), // จัดให้อยู่ชิดซ้าย
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

                // ✅ ข้อความ "ด่านที่ X" + ปุ่ม Refresh พร้อมพื้นหลัง
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40), // ระยะขอบ
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(
                      0.7,
                    ), // ✅ พื้นหลังดำโปร่งแสง
                    borderRadius: BorderRadius.circular(10), // ✅ ขอบโค้งมน
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween, // จัดให้อยู่ฝั่งซ้าย-ขวา
                    children: [
                      Text(
                        "ด่านที่ ${widget.level}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // สีตัวอักษร
                          fontFamily: 'Sarabun',
                        ),
                      ),

                      // ✅ ปุ่ม Refresh
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: restartGame,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20), // ✅ เพิ่มระยะห่าง
            // ✅ แสดงข้อความชนะเกม พร้อมพื้นหลัง
            if (isWin)
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(
                    0.8,
                  ), // ✅ พื้นหลังเขียวโปร่งแสง
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      "🎉 คุณชนะแล้ว! 🎉",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // ✅ สีตัวอักษร
                        fontFamily: 'Sarabun',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: nextLevel,
                      child: Text(
                        widget.level < 3 ? "เล่นด่านต่อไป" : "กลับไปเลือกด่าน",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(
                            255,
                            0,
                            0,
                            0,
                          ), // ✅ สีตัวอักษร
                          fontFamily: 'Sarabun',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20), // ✅ เพิ่มระยะห่าง
            // ✅ เกม Memory
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: totalPairs,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onCardTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            revealed[index] ||
                                    firstIndex == index ||
                                    secondIndex == index
                                ? const Color.fromARGB(255, 241, 140, 233)
                                : const Color.fromARGB(255, 197, 211, 134),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          revealed[index] ||
                                  firstIndex == index ||
                                  secondIndex == index
                              ? images[index]
                              : "❓",
                          style: const TextStyle(fontSize: 32),
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
    );
  }
}
