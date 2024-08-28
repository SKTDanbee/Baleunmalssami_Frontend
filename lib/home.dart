import 'package:flutter/material.dart';
import 'report.dart';
import 'friends.dart';
import 'settings.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  final Dio dio;
  final String myId;

  const HomePage({required this.dio, required this.myId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? abuseCounts;
  int? abuseCounts_last;
  String? reportDate;
  int _selectedIndex = 0;
  bool isLoading = true; // 로딩창!!!

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    const String url = 'https://3cb4-180-134-170-106.ngrok-free.app/reports/type2/';

    try {
      final response = await widget.dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {
          abuseCounts = data[0]['abuse_count'];
          abuseCounts_last = data[1]['abuse_count'];
          reportDate = data[0]['report_date'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load reports: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : HomePageContent(
        abuseCounts: abuseCounts,
        abuseCounts_last: abuseCounts_last,
        reportDate: reportDate,
        dio: widget.dio,
        myId: widget.myId, // myId 전달
      ),
      ReportPage(index: 0, dio: widget.dio, myId: widget.myId),
      FriendsPage(dio: widget.dio, myId: widget.myId),
      SettingsPage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF7B1B), // 선택 시 주황
        unselectedItemColor: const Color(0xFFBDBDBD), // 미선택 시 회색
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              color: _selectedIndex == 0
                  ? const Color(0xFFFF7B1B)
                  : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/report.png',
              color: _selectedIndex == 1
                  ? const Color(0xFFFF7B1B)
                  : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '레포트',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/friends.png',
              color: _selectedIndex == 2
                  ? const Color(0xFFFF7B1B)
                  : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '랭킹',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/settings.png',
              color: _selectedIndex == 3
                  ? const Color(0xFFFF7B1B)
                  : const Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final int? abuseCounts;
  final int? abuseCounts_last;
  final String? reportDate;
  final Dio dio;
  final String myId;

  HomePageContent({
    required this.abuseCounts,
    required this.abuseCounts_last,
    required this.reportDate,
    required this.dio,
    required this.myId, // myId 전달
  });

  @override
  Widget build(BuildContext context) {
    int score = abuseCounts != null ? 100 - abuseCounts! : 0;
    int ratio = (abuseCounts_last != null && abuseCounts_last! != 0)
        ? ((abuseCounts_last! - abuseCounts!) / abuseCounts_last! * 100).round()
        : 0;
    double progress = score / 100;
    String date = reportDate != null ? reportDate! : "0000-00-00";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '홈',
          style: TextStyle(
              color: Color(0xFF333333), fontWeight: FontWeight.bold),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '나의 언어습관은?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '이번주 욕설 사용량: ${abuseCounts ?? '로딩 중'} 회',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF777777),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: CircularProgressIndicator(
                                    value: progress, // abuseCounts 기반으로 업데이트
                                    strokeWidth: 15,
                                    valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFF7B1B)),
                                    backgroundColor: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                Text(
                                  '$score점',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '이번주는 저번주에 비해 욕설 사용량이 $ratio% 감소했어요!',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportPage(
                            index: 0,
                            dio: dio,
                            myId: myId, // myId 전달
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 110, // 버튼의 높이를 동일하게 설정
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '주간 레포트\n확인하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Text(
                                '$date', // reportDate를 사용한 부분 수정
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendsPage(
                            dio: dio,
                            myId: myId, // myId 전달
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const SizedBox(
                        height: 110, // 버튼의 높이를 동일하게 설정
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '나의 바른말\n랭킹 확인하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // 지난 레포트 보기 페이지로 이동하는 로직

                },
                child: const Text(
                  '레포트 갱신하기 >',
                  style: TextStyle(
                    color: Color(0xFF777777),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}

