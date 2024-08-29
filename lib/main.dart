import 'package:flutter/material.dart';
import 'signup.dart'; // 학생 회원가입 페이지
import 'parentsignup.dart'; // 보호자 회원가입 페이지
import 'home.dart';
import 'parenthome.dart';
import 'login.dart';
import 'parentlogin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '바른말싸미',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사용자 선택", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFFFF7B1B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // 학생 회원가입 페이지
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF7B1B),
                padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 15),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text("학생용", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParentLoginPage()), // 보호자 회원가입 페이지
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF7B1B),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text("학부모용", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
