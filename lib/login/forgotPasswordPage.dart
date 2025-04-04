import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotPasswordPage extends StatefulWidget {
  const forgotPasswordPage({super.key});

  @override
  State<forgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<forgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Center(
          child: Text(
            'Example Firebase',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [Icon(Icons.help, color: Colors.white)],
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your email to get a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your email',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value!.isEmpty) return 'กรุณากรอก email';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  passwordReset();
                },
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
