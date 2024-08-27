import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'managefriend.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  Dio _dio = Dio();
  List<Map<String, dynamic>> friends = [];
  int? myAbuseCount;
  String? myName;  // 예시로 내 이름을 지정, 실제 이름은 사용자에 따라 달라짐
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFriendsData();
  }

  Future<void> fetchFriendsData() async {
    final String myUrl = 'https://your-api-url/reports/';  // reports API 엔드포인트
    final String reportsUrl = 'https://your-api-url/reports/';  // reports API 엔드포인트
    final String friendsUrl = 'https://your-api-url/friends/';  // friends API 엔드포인트

    try {
      // reports 테이블의 0번 인덱스 데이터를 가져옴 (자신의 abuseCount)
      final myResponse = await _dio.get(myUrl);
      if (myResponse.statusCode == 200) {
        myName = myResponse.data[0]['name'];
      } else {
        throw Exception('Failed to load report data');
      }

      // reports 테이블의 0번 인덱스 데이터를 가져옴 (자신의 abuseCount)
      final reportsResponse = await _dio.get(reportsUrl);
      if (reportsResponse.statusCode == 200) {
        myAbuseCount = reportsResponse.data[0]['abuse_count'];
      } else {
        throw Exception('Failed to load report data');
      }

      // friends 테이블의 데이터를 가져옴
      final friendsResponse = await _dio.get(friendsUrl);
      if (friendsResponse.statusCode == 200) {
        friends = List<Map<String, dynamic>>.from(friendsResponse.data);

        // 자신의 데이터를 friends 리스트에 추가
        friends.add({
          "name": myName,
          "abuse_count": myAbuseCount,
        });

        // abuseCount가 작은 순서대로 친구들을 정렬
        friends.sort((a, b) => a['abuse_count'].compareTo(b['abuse_count']));

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load friends data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '바른말 랭킹',
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
          : Column(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '지금 나는? ${friends.indexWhere((friend) => friend['name'] == myName) + 1}위',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      '이번주 욕설 사용량 : ${myAbuseCount ?? 0}회',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageFriendPage()
                      ),
                    );
                  },
                  child: const Text(
                    '친구 관리하기',
                    style: TextStyle(
                      color: Color(0xFF777777),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Color(0xFFF5F5F5)), // 구분선 추가
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: friends[index]['name'] == myName
                              ? const Color(0xFFFF7B1B)
                              : const Color(0xFF333333),
                        ),
                      ),
                      title: Text(
                        friends[index]['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                      subtitle: Text(
                        '주 욕설 사용량 : ${friends[index]['abuse_count']}회',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
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
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
