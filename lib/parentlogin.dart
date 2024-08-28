import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'parenthome.dart';

class ParentLoginPage extends StatefulWidget {
  @override
  _ParentLoginPageState createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Dio _dio = Dio();
  CookieJar cookieJar = CookieJar();

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(CookieManager(cookieJar)); // 쿠키 관리 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7B1B),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _parentlogin,
              child: const Text(
                '시작하기',
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

  void _parentlogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // 로그인 시도
    const String url = 'https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/parent';

    try {
      final response = await _dio.post(
          url,
          data: {
        'id': email, //id 바꿔봐야
        'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // Form URL Encoded 설정
        ),
      );

      if (response.statusCode == 200) {
          // 로그인 성공
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ParentHomePage(dio: _dio, myId: email)),
          );
        } else {
          // 로그인 실패 시 처리
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인 실패: 잘못된 이메일 또는 비밀번호입니다.')),
          );
        }
    //   }
    } catch (e) {
      // 서버 오류 또는 네트워크 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패: 서버와 연결할 수 없습니다.')),
      );
    }
  }
}