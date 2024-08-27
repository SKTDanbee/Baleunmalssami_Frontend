import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
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
              '보호자 전화번호',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: '전화번호를 입력해주세요.',
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
              onPressed: isButtonActive ? _signUp : null,
              child: const Text(
                '가입하기',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7B1B),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _send,
              child: const Text(
                '보내기',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
  }

  Future<void> _send() async {
    try {
      const String filePath = 'assets/texts.txt';
      const String url = 'https://danbeegptreport-c4cfbdage7hkd8bv.koreacentral-01.azurewebsites.net/generate-report/';

      // assets 폴더에서 파일 읽기
      final ByteData byteData = await rootBundle.load(filePath);
      final fileBytes = byteData.buffer.asUint8List();

      // MultipartRequest를 사용하여 파일을 전송
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: 'texts.txt'));

      // 요청 보내기
      final response = await request.send();

      // 응답 본문 확인
      final responseBody = await response.stream.bytesToString();
      throw Exception('Response Text: $responseBody');
      //print('Response Text: $responseBody');

    } catch (e) {
      throw Exception('Error occurred: $e');
      //print('Error occurred: $e');
    }
  }

  void _signUp() async {
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;
    String phone = _phoneController.text;

    // 백엔드 통신
    await registerUser(email, name, password, phone);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

// 데이터베이스 연결
 Future<bool> registerUser(String email, String name, String password, String phone) async {
   const String apiUrl = "https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/children/";

   final response = await http.post(
     Uri.parse(apiUrl),
     headers: <String, String>{
       'Content-Type': 'application/json; charset=UTF-8',
     },
     body: jsonEncode({
       "id": email,
       "password": password,
       "name": name,
       "parent_phone_number": phone,
     }),
   );

   if (response.statusCode == 200) {
     return true; // 성공
   } else {
     return false; // 실패
   }
 }
}
