import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> friends = [
      {"rank": "1", "name": "손서희", "usage": "주 욕설 사용량 : 2회"},
      {"rank": "2", "name": "김호준", "usage": "주 욕설 사용량 : 6회"},
      {"rank": "3", "name": "배성욱", "usage": "주 욕설 사용량 : 15회"},
      {"rank": "4", "name": "옥지원", "usage": "월 욕설 사용량 : 24회"},
      {"rank": "5", "name": "김현동", "usage": "월 욕설 사용량 : 25회"},
      {"rank": "6", "name": "김철수", "usage": "월 욕설 사용량 : 42회"},
      {"rank": "7", "name": "이영희", "usage": "월 욕설 사용량 : 49회"},
      {"rank": "8", "name": "홍길동", "usage": "월 욕설 사용량 : 55회"},
      {"rank": "9", "name": "이효민", "usage": "월 욕설 사용량 : 80회"},
    ];

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
      body: Column(
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '지금 나는? 5위',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      '이번주 욕설 사용량 : 25회',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // 친구 관리 페이지로 이동하는 로직 (아직 구현되지 않음)
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
                        friends[index]['rank']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: index == 4 ? const Color(0xFFFF7B1B) : const Color(0xFF333333),
                        ),
                      ),
                      title: Text(
                        friends[index]['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                      subtitle: Text(
                        friends[index]['usage']!,
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
