import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'managefriend.dart';

class FriendsPage extends StatefulWidget {
  final Dio dio;
  final String myId;

  FriendsPage({required this.dio, required this.myId});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String, dynamic>> friends = [];
  int? myAbuseCount;
  String? myName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFriendsData();
  }

  Future<void> fetchFriendsData() async {
    const String friendsUrl = 'https://3cb4-180-134-170-106.ngrok-free.app/friend_ranking/';

    try {
      final friendsResponse = await widget.dio.get(friendsUrl);
      if (friendsResponse.statusCode == 200) {
        final data = Map<String, dynamic>.from(friendsResponse.data);
        final latestDate = data.keys.first;
        friends = List<Map<String, dynamic>>.from(data[latestDate]);

        final myData = friends.firstWhere((friend) => friend['child_id'] == widget.myId);
        myAbuseCount = myData['abuse_count'];
        myName = widget.myId;

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('친구 데이터를 불러오지 못했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 로딩 오류: $e')),
      );
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
                  offset: const Offset(0, 3),
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
                      '지금 나는? ${friends.indexWhere((friend) => friend['child_id'] == myName) + 1}위',
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
                        builder: (context) => ManageFriendPage(dio: widget.dio, myId: widget.myId),
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
          const Divider(thickness: 1, color: Color(0xFFF5F5F5)),
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
                          color: friends[index]['child_id'] == myName
                              ? const Color(0xFFFF7B1B)
                              : const Color(0xFF333333),
                        ),
                      ),
                      title: Text(
                        friends[index]['child_id'],
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
