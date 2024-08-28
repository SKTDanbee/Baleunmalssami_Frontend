import 'package:flutter/material.dart';
import 'parenthome.dart';
import 'parentreport.dart';  // 이전 레포트를 클릭했을 때 열리는 페이지
import 'settings.dart';  // 설정 페이지
import 'package:dio/dio.dart';

class ParentReportListPage extends StatefulWidget {
  @override
  _ParentReportListPageState createState() => _ParentReportListPageState();
}

class _ParentReportListPageState extends State<ParentReportListPage> {
  int _selectedIndex = 1;  // 레포트 탭이 기본 선택

  Dio _dio = Dio();
  List<String> dateList = [];
  List<int> abuseWeek = [];
  bool isLoading = false; //로딩창!!!

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    const String url = 'https://3cb4-180-134-170-106.ngrok-free.app/reports/type1/'; // 모든 레코드를 가져오는 API 엔드포인트

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {
          dateList.clear();
          abuseWeek.clear();

          for (var report in data) {
            dateList.add(report['report_date']);
            abuseWeek.add(report['abuse_count']);
          }

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

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ParentHomePage()),
        );
        break;
      case 1:
      // 리포트 페이지 연결 수정 필요
        break;
      case 2:
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
          '자녀1의 레포트',
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
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dateList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParentReportPage(
                      index: index,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateList[index],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '주 욕설 사용량: ${abuseWeek[index]}회',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
              'assets/images/settings.png',
              color: _selectedIndex == 2 ? const Color(0xFFFF7B1B) : const Color(0xFFBDBDBD),
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

