import 'package:flutter/material.dart';
import 'parenthome.dart';
import 'parentcyberreport.dart';  // 이전 레포트를 클릭했을 때 열리는 페이지
import 'settings.dart';  // 설정 페이지
import 'package:dio/dio.dart';

class ParentCyberReportListPage extends StatefulWidget {
  @override
  _ParentCyberReportListPageState createState() => _ParentCyberReportListPageState();
}

class _ParentCyberReportListPageState extends State<ParentCyberReportListPage> {
  int _selectedIndex = 1;  // 레포트 탭이 기본 선택

  Dio _dio = Dio();
  List<String> dateList = [];
  List<String> cyberdegree = [];
  bool isLoading = false; //로딩창!!!

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final String url = 'https://6ccc-203-236-8-208.ngrok-free.app/reports/'; // 모든 레코드를 가져오는 API 엔드포인트

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {
          dateList.clear();
          cyberdegree.clear();

          cyberdegree.add('높음');
          cyberdegree.add('중간');
          cyberdegree.add('중간');
          cyberdegree.add('낮음');
          cyberdegree.add('낮음');
          cyberdegree.add('낮음');
          cyberdegree.add('낮음');

          for (var report in data) {
            dateList.add(report['report_date']);
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
        title: Text(
          '자녀1의 사이버 폭력 레포트',
          style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                    builder: (context) => ReportPage(
                      week: dateList[index],
                      usage: '${cyberdegree[index]}',
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
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333)),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '위험도: ${cyberdegree[index]}',
                        style: TextStyle(
                          fontSize: 14,
                          color: cyberdegree[index] == '높음'
                              ? Colors.red
                              : cyberdegree[index] == '중간'
                              ? Color(0xFFFF7B1B)
                              : Color(0xFF777777),
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
        selectedItemColor: Color(0xFFFF7B1B),
        unselectedItemColor: Color(0xFFBDBDBD),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              color: _selectedIndex == 0 ? Color(0xFFFF7B1B) : Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/report.png',
              color: _selectedIndex == 1 ? Color(0xFFFF7B1B) : Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '레포트',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/settings.png',
              color: _selectedIndex == 2 ? Color(0xFFFF7B1B) : Color(0xFFBDBDBD),
              width: 24,
              height: 24,
            ),
            label: '설정',
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),
    );
  }
}

class ReportPage extends StatelessWidget {
  final String week;
  final String usage;

  ReportPage({required this.week, required this.usage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$week',
          style: TextStyle(color: Color(0xFF333333)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '$week의 레포트 페이지입니다.\n$usage',
          style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Color(0xFFF5F5F5),
    );
  }
}
