import 'package:flutter/material.dart';
import 'dart:math';

class homeXOGame extends StatelessWidget {
  const homeXOGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/XOgame.png"), // รูปพื้นหลัง
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
                  "เลือกจำนวนผู้เล่น",
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
                  backgroundColor: const Color.fromARGB(255, 252, 252, 252),
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
                      builder: (context) => XOGameScreen(isSinglePlayer: true),
                    ),
                  );
                },
                child: const Text(
                  'เล่นคนเดียว👤',
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
                      builder: (context) => XOGameScreen(isSinglePlayer: false),
                    ),
                  );
                },
                child: const Text(
                  'เล่นสองคน👥',
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

class XOGameScreen extends StatefulWidget {
  final bool isSinglePlayer;

  const XOGameScreen({Key? key, required this.isSinglePlayer})
    : super(key: key);

  @override
  _XOGameState createState() => _XOGameState();
}

class _XOGameState extends State<XOGameScreen> {
  late bool isOTurn;
  late List<String> board;

  @override
  void initState() {
    super.initState();
    isOTurn = true;
    board = List.filled(9, "", growable: false);
  }

  void resetBoard() {
    setState(() {
      board = List.filled(9, "", growable: false);
      isOTurn = true;
    });
  }

  void playerMove(int index) {
    if (board[index] == "" && !checkWinner()) {
      setState(() {
        board[index] = isOTurn ? "O" : "X";
        isOTurn = !isOTurn;
      });
      if (widget.isSinglePlayer && !isOTurn && !checkWinner()) {
        aiMove();
      }
      if (checkWinner()) {
        showResultDialog(board[index]);
      } else if (isDraw()) {
        showResultDialog(null);
      }
    }
  }

  void aiMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") availableMoves.add(i);
    }
    if (availableMoves.isNotEmpty) {
      int move = availableMoves[Random().nextInt(availableMoves.length)];
      setState(() {
        board[move] = "X";
        isOTurn = true;
      });
      if (checkWinner()) {
        showResultDialog("X");
      } else if (isDraw()) {
        showResultDialog(null);
      }
    }
  }

  bool checkWinner() {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var condition in winConditions) {
      String a = board[condition[0]];
      String b = board[condition[1]];
      String c = board[condition[2]];
      if (a != "" && a == b && a == c) {
        return true;
      }
    }
    return false;
  }

  bool isDraw() {
    return !board.contains("") && !checkWinner();
  }

  void showResultDialog(String? winner) {
    String message =
        winner == null ? "พวกคุณเสมอกัน" : "🎉🎉ฝั่ง $winner เป็นฝ่ายชนะ🎉🎉";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // มุมโค้งของปุ่ม
            side: const BorderSide(
              color: Colors.black, // ✅ สีกรอบ
              width: 1, // ✅ ความหนาของกรอบ
            ),
          ),
          title: const Text(
            "ผลการแข่งขัน",
            textAlign: TextAlign.center, // ทำให้ Title อยู่ตรงกลาง
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 20, // ปรับขนาดตัวอักษร
              fontWeight: FontWeight.bold, // ทำให้ตัวหนา (ถ้าต้องการ)
              color: const Color.fromARGB(
                255,
                115,
                216,
                33,
              ), // ปรับสีตัวอักษร (ถ้าต้องการ)
            ),
            textAlign: TextAlign.center, // ทำให้ข้อความเนื้อหาอยู่ตรงกลาง
          ),
          actions: [
            Center(
              // ใช้ Center เพื่อให้ปุ่มอยู่ตรงกลาง
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetBoard();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(193, 233, 59, 59),
                ),
                child: const Text(
                  'เริ่มเกมใหม่',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/XOgame.png"), // รูปพื้นหลัง
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
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.isSinglePlayer ? "เล่นคนเดียว" : "เล่นสองคน",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder:
                    (context, index) => GestureDetector(
                      onTap: () => playerMove(index),
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            board[index],
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
