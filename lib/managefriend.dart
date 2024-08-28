import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'home.dart';
import 'report.dart';  // report.dart 파일로 직접 연결
import 'friends.dart';  // 친구 페이지
import 'settings.dart';  // 설정 페이지

class ManageFriendPage extends StatefulWidget {
  final Dio dio;

  ManageFriendPage({required this.dio});
  @override
  _ManageFriendPageState createState() => _ManageFriendPageState();
}

class _ManageFriendPageState extends State<ManageFriendPage> {
  int _selectedIndex = 2;
  final TextEditingController _emailController = TextEditingController();
  Dio _dio = Dio();

  List<String> friendRequests = ['김현동', '김호준', '배성욱', '옥지원'];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFriendRequests();
  }

  Future<void> fetchFriendRequests() async {
    const String url = 'https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/'; // 실제 백엔드 API 엔드포인트로 변경하세요.

    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        // 실제 데이터에 맞게 수정
        setState(() {
          friendRequests = List<String>.from(response.data['friend_requests']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load friend requests');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error: $e');
    }
  }

  Future<void> handleFriendRequest(String friend, bool isAccepted) async {
    const String url = 'https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/'; // 실제 백엔드 API 엔드포인트로 변경하세요.

    try {
      final response = await _dio.post(url, data: {
        'friend': friend,
        'accepted': isAccepted,
      });

      if (response.statusCode == 200) {
        setState(() {
          friendRequests.remove(friend);
        });
        throw Exception('${isAccepted ? 'Accepted' : 'Declined'} friend request from $friend');
      } else {
        throw Exception('Failed to handle friend request');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addFriend() async {
    final String email = _emailController.text;
    _emailController.clear();
    const String url = 'https://example.com/api/add_friend'; // 실제 백엔드 API 엔드포인트로 변경하세요.

    if (email.isEmpty) {
      return;
    }

    try {
      final response = await _dio.post(url, data: {'email': email});

      if (response.statusCode == 200) {
        throw Exception('Friend request sent to $email');
      } else {
        throw Exception('Failed to add friend');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(dio: _dio)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportPage(index: 0, dio: _dio)),
        );
        break;
      case 2:
        //
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '친구 관리',
          style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // 그림자의 위치 조정
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '친구 추가',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: '이메일을 입력해주세요.',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addFriend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7B1B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text(
                        '친구 추가',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '       친구 요청',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: friendRequests.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          friendRequests[index],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                handleFriendRequest(friendRequests[index], true);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7B1B),
                                minimumSize: const Size(75, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                '수락',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                            TextButton(
                              onPressed: () {
                                handleFriendRequest(friendRequests[index], false);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(75, 45),
                                side: const BorderSide(
                                  width: 1.5,
                                  color: Color(0xFF999999),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                '거절',
                                style: TextStyle(fontSize: 18, color: Color(0xFF999999)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          color: Color(0xFFBDBDBD),
                          thickness: 1,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF7B1B),
        unselectedItemColor: const Color(0xFFBDBDBD),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              color: _selectedIndex == 0 ? const Color(0xFFFF7B1B) : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/report.png',
              color: _selectedIndex == 1 ? const Color(0xFFFF7B1B) : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '레포트',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/friends.png',
              color: _selectedIndex == 2 ? const Color(0xFFFF7B1B) : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '친구',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/settings.png',
              color: _selectedIndex == 3 ? const Color(0xFFFF7B1B) : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '설정',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
