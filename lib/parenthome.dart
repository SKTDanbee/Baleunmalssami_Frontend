import 'package:flutter/material.dart';
import 'parentreport.dart';
import 'parentsettings.dart';

class ParentHomePage extends StatefulWidget {
  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ParentHomePageContent(),
    ParentReportPage(),
    ParentSettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF7B1B),  // 선택 시 주황
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
              'assets/images/settings.png',
              color: _selectedIndex == 2 ? const Color(0xFFFF7B1B) : const Color(0xFFBDBDBD),
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

class ParentHomePageContent extends StatelessWidget {
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
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '자녀1의 언어습관은?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '이번주는 저번주에 비해 욕설 사용량이 3% 감소했어요!',
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

