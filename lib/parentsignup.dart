import 'dart:convert';
import 'package:flutter/material.dart';
import 'parenthome.dart';
import 'package:http/http.dart' as http;

class ParentSignUpPage extends StatefulWidget {
  @override
  _ParentSignUpPageState createState() => _ParentSignUpPageState();
}

class _ParentSignUpPageState extends State<ParentSignUpPage> {
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAllChecked = false;
  bool _isAgreement1Checked = false;
  bool _isAgreement2Checked = false;

  @override
  Widget build(BuildContext context) {
    bool isButtonActive = _isAgreement1Checked && _isAgreement2Checked;

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              '이메일',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: '이메일을 입력해주세요.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '이름',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '이름을 입력해주세요.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '비밀번호',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: '비밀번호를 입력해주세요.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: true, // 비밀번호는 가려진 텍스트로 입력
            ),
            const SizedBox(height: 20),
            const Text(
              '인증번호',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _verificationCodeController,
              decoration: const InputDecoration(
                hintText: '인증번호를 입력해주세요.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('전체 약관 동의'),
              value: _isAllChecked,
              activeColor: const Color(0xFFFF7B1B),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  _isAllChecked = value!;
                  _isAgreement1Checked = value;
                  _isAgreement2Checked = value;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('약관1'),
              value: _isAgreement1Checked,
              activeColor: const Color(0xFFFF7B1B),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  _isAgreement1Checked = value!;
                  _isAllChecked = _isAgreement1Checked && _isAgreement2Checked;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('약관2'),
              value: _isAgreement2Checked,
              activeColor: const Color(0xFFFF7B1B),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  _isAgreement2Checked = value!;
                  _isAllChecked = _isAgreement1Checked && _isAgreement2Checked;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonActive ? const Color(0xFFFF7B1B) : const Color(0xFFBDBDBD),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: isButtonActive ? _parentSignUp : null,
              child: const Text(
                '가입하기',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
  }

  void _parentSignUp() async {
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;
    String verificationCode = _verificationCodeController.text;

    // 인증번호 확인 API
    await verifyCode(verificationCode);
    await registerUser(email, name, password);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ParentHomePage()),
    );
  }

  var code;

  Future<bool> verifyCode(String verificationCode) async {
    // 백엔드와 통신 - 인증번호 확인
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // 서버 연결 되면 승인
      return true;
    } else {
      // 서버 연결 실패
      throw Exception('오류가 발생했습니다. 다시 시도해주십시오.');
    }
  }
}

// 데이터베이스 연결
Future<bool> registerUser(String email, String name, String password) async {
  const String apiUrl = "http"; //url 입력

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "id": email,
      "password": password,
      "name": name,
    }),
  );

  if (response.statusCode == 200) {
    return true; // 성공
  } else {
    return false; // 실패
  }
}