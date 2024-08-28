import 'dart:convert';
import 'package:flutter/material.dart';
import 'parentlogin.dart';
import 'package:http/http.dart' as http;

class ParentSignUpPage extends StatefulWidget {
  @override
  _ParentSignUpPageState createState() => _ParentSignUpPageState();
}

class _ParentSignUpPageState extends State<ParentSignUpPage> {
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _phoneController = TextEditingController();
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
              '전화번호',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('이용약관 동의(필수)'),
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
                ),
                TextButton(
                  onPressed: () {
                    dialog1();
                  },
                  child: const Text(
                    '자세히 보기',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('개인정보 동의(필수)'),
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
                ),
                TextButton(
                  onPressed: () {
                    dialog2();
                  },
                  child: const Text(
                    '자세히 보기',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
              ],
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
    String phone = _phoneController.text;
    String code = _verificationCodeController.text;

    // 인증번호 확인 API
    await registerUserParents(email, name, password, phone, code);
    await registerUser2(email);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ParentLoginPage()),
    );
  }

  // 데이터베이스 연결
  Future<bool> registerUserParents(String email, String name, String password, String phone, String code) async {
    const String apiUrl = "https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/parents/"; //url 입력

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "id": email,
        "password": password,
        "name": name,
        "phone_number": phone,
        "verification_code": code,
      }),
    );

    if (response.statusCode == 200) {
      return true; // 성공
    } else {
      return false; // 실패
    }
  }

  Future<bool> registerUser2(String email) async {
    const String apiUrl2 = "https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/children/";

    final response = await http.post(
      Uri.parse(apiUrl2),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "parent_id": email,
      }),
    );

    if (response.statusCode == 200) {
      return true; // 성공
    } else {
      return false; // 실패
    }
  }

  void dialog1() async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '이용약관 동의',
            style: TextStyle(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  '제1조(목적)'
                      '\n\n이 약관은 업체 회사(전자상거래 사업자)가 운영하는 업체 사이버 몰(이하 “몰”이라 한다)에서 제공하는 인터넷 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리․의무 및 책임사항을 규정함을 목적으로 합니다.'
                      '\n※「PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다.」',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(color: Color(0xFFFF7B1B)),
              ),
              onPressed: () {
                String userInput = _textFieldController.text;
                // Here you can handle the user's input, for example:
                // Send it to the server, save it, etc.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void dialog2() async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '개인정보 동의',
            style: TextStyle(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  '개인정보처리방침\n\n[차례]\n1. 총칙\n2. 개인정보 수집에 대한 동의\n3. 개인정보의 수집 및 이용목적'
                      '\n4. 수집하는 개인정보 항목\n5. 개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항\n6. 목적 외 사용 및 제3자에 대한 제공'
                      '\n7. 개인정보의 열람 및 정정\n8. 개인정보 수집, 이용, 제공에 대한 동의철회\n9. 개인정보의 보유 및 이용기간\n10. 개인정보의 파기절차 및 방법'
                      '\n11. 아동의 개인정보 보호\n12. 개인정보 보호를 위한 기술적 대책\n13. 개인정보의 위탁처리'
                      '\n14. 의겸수렴 및 불만처리\n15. 부 칙(시행일) ',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(color: Color(0xFFFF7B1B)),
              ),
              onPressed: () {
                String userInput = _textFieldController.text;
                // Here you can handle the user's input, for example:
                // Send it to the server, save it, etc.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}