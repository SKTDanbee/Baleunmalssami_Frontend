import 'package:flutter/material.dart';
import 'parenthome.dart';
import 'parentcyberreport.dart';  // 이전 레포트를 클릭했을 때 열리는 페이지
import 'settings.dart';  // 설정 페이지
import 'package:dio/dio.dart';

class ParentCyberReportListPage extends StatefulWidget {
  final Dio dio;
  final String myId;

  ParentCyberReportListPage({required this.dio, required this.myId});

  @override
  _ParentCyberReportListPageState createState() => _ParentCyberReportListPageState();
}

class _ParentCyberReportListPageState extends State<ParentCyberReportListPage> {
  int _selectedIndex = 1;  // 레포트 탭이 기본 선택

  List<String> dateList = [];
  List<String> cyberdegree = ['낮음', '낮음', '높음', '중간', '중간', '낮음', '중간'];
  bool isLoading = true; //로딩창!!!

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    const String url = 'https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/reports/type3/'; // 모든 레코드를 가져오는 API 엔드포인트

    try {
      final response = await widget.dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {
          dateList.clear();
          //cyberdegree.clear();

          for (var report in data) {
            dateList.add(report['report_date']);
            //cyberdegree.add(report['report_degree']);
          }

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

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ParentHomePage(dio: widget.dio, myId: widget.myId)),
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
          '사이버 폭력 레포트',
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
                    builder: (context) => ParentCyberReportPage(
                      index: index,
                      dio: widget.dio,
                      myId: widget.myId,
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
                        '위험도: ${cyberdegree[index]}',
                        style: TextStyle(
                          fontSize: 14,
                          color: cyberdegree[index] == '높음'
                              ? Colors.red
                              : cyberdegree[index] == '중간'
                              ? const Color(0xFFFF7B1B)
                              : const Color(0xFF777777),
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
