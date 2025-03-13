import 'package:flutter_application_7/login/forgotPasswordPage.dart';
import './registPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_7/UIappgame/Homepage/homepage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Logout อัตโนมัติทุกครั้งที่เปิดแอป
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const loginPage(),
    );
  }
}

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    checkUserLoginStatus();
  }

  // ✅ เช็คว่า User Login ค้างอยู่หรือไม่
  void checkUserLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // ✅ ถ้าล็อกอินแล้วให้ไปหน้า Homepage แทนการ sign out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UIappgame()),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // ✅ เพิ่ม timeout เพื่อป้องกันการค้าง
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw FirebaseAuthException(
                code: "timeout",
                message: "การเข้าสู่ระบบใช้เวลานานเกินไป",
              );
            },
          );

      if (mounted) {
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 200));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UIappgame()),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("Google Sign-In Error: $e");
    }
  }

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context);

      // ✅ ใช้ pushAndRemoveUntil เพื่อล้าง stack ของหน้าเก่า
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UIappgame()),
        (route) => false, // เอาหน้าเก่าทั้งหมดออก
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print("Login Error: ${e.code}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'THUNG TUM2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 170),
                const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.mail, color: Colors.white),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) return 'กรุณากรอก email';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock, color: Colors.white),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) return 'กรุณากรอกรหัสผ่าน';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const forgotPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUserIn();
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: signInWithGoogle,
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.mail_outline, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.facebook, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.apple, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const registPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 170),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
