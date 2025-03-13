import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileData {
  static String userName = '';
  static String description = '';
  static String gender = ''; // ค่าเริ่มต้น
}

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedGender = 'ชาย';

  @override
  void initState() {
    super.initState();

    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((doc) {
            if (doc.exists) {
              setState(() {
                _nameController.text = doc['userName'] ?? '';
                _descriptionController.text = doc['description'] ?? '';
                _selectedGender = doc['gender'] ?? 'ชาย';
              });
            }
          })
          .catchError((error) {
            print("เกิดข้อผิดพลาดในการโหลดข้อมูลโปรไฟล์: $error");
          });
    }
  }

  void _saveProfile() async {
    if (user == null) return;

    final userProfileRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid);

    try {
      String newUserName = _nameController.text; // เก็บค่าที่แก้ไข

      await userProfileRef.set({
        'userName': newUserName,
        'description': _descriptionController.text,
        'gender': _selectedGender,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[600],
          content: Text(
            'บันทึกข้อมูลเรียบร้อยแล้ว!',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.pop(context, newUserName); // ส่งค่ากลับไปให้ HomePage
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[600],
          content: Text(
            'เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(144, 58, 57, 57),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                  'https://yt3.googleusercontent.com/rzBsht2_AMDcJd8p2yLFAHzGsC9vNJFPywxL5kYHhzEha_5PcCWkxQlVkI2jROdBAh-9XNZXwQ=s900-c-k-c0x00ffffff-no-rj',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              decoration: InputDecoration(
                labelText: 'ชื่อ',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Sarabun',
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              decoration: InputDecoration(
                labelText: 'คำอธิบายตัวเอง',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Sarabun',
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: _selectedGender,
              dropdownColor: Colors.black, // เปลี่ยนสีพื้นหลังของ Dropdown
              style: TextStyle(
                fontSize: 20,
                color: Colors.white, // สีของตัวเลือกที่เลือกแล้ว
              ),
              decoration: InputDecoration(
                labelText: 'เพศ',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Sarabun',
                ),
                border: OutlineInputBorder(),
              ),
              items:
                  ['ชาย', 'หญิง', 'ไม่ระบุ']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.green[600],
                ),
                onPressed: () {
                  _saveProfile();
                },
                child: Text(
                  'บันทึก',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
