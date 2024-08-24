import 'package:flutter/material.dart';
import 'report.dart';
import 'friends.dart';
import 'settings.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio _dio = Dio();
  int? abuseCounts;
  int _selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final String url = 'https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/reports/'; // 여기에 실제 데이터베이스 URL을 입력하세요.

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {

          abuseCounts = data[0]['abuse_count'];

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
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
      isLoading ? Center(child: CircularProgressIndicator()) : HomePageContent(abuseCounts: abuseCounts),
      ReportPage(),
      FriendsPage(),
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
            label: '랭킹',
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
    );
  }
}

class HomePageContent extends StatelessWidget {
  final int? abuseCounts;

  HomePageContent({required this.abuseCounts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '홈',
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '오늘 나의 언어습관은?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '오늘의 욕설 사용량: ${abuseCounts ?? '로딩 중'} 회',
                          style: TextStyle(color: Color(0xFF333333)),
                        ),
                      ],
                    ),
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
