import 'package:flutter/material.dart';

class ParentSettingsPage extends StatefulWidget {
  @override
  _ParentSettingsPageState createState() => _ParentSettingsPageState();
}

class _ParentSettingsPageState extends State<ParentSettingsPage> {
  bool _pushNotification = true;
  bool _sound = false;
  bool _vibration = false;
  bool _child1 = true;
  bool _child2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '  알림 설정',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF777777),
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              margin: EdgeInsets.zero,  // 카드의 기본 margin 제거
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(  // 카드 내부에 패딩 추가
                padding: const EdgeInsets.all(10.0),  // 패딩을 추가하여 여백 확보
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('푸시 알림'),
                      value: _pushNotification,
                      activeColor: const Color(0xFFFF7B1B),  // 스위치가 ON 상태일 때 색상 지정
                      onChanged: (bool value) {
                        setState(() {
                          _pushNotification = value;
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Color(0xFFBDBDBD),
                        thickness: 1,
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('소리'),
                      value: _sound,
                      activeColor: const Color(0xFFFF7B1B),  // 스위치가 ON 상태일 때 색상 지정
                      onChanged: (bool value) {
                        setState(() {
                          _sound = value;
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Color(0xFFBDBDBD),
                        thickness: 1,
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('진동'),
                      value: _vibration,
                      activeColor: const Color(0xFFFF7B1B),  // 스위치가 ON 상태일 때 색상 지정
                      onChanged: (bool value) {
                        setState(() {
                          _vibration = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '  자녀 관리',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF777777),
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              margin: EdgeInsets.zero,  // 카드의 기본 margin 제거
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(  // 카드 내부에 패딩 추가
                padding: const EdgeInsets.all(10.0),  // 패딩을 추가하여 여백 확보
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('자녀1'),
                      value: _child1,
                      activeColor: const Color(0xFFFF7B1B),  // 스위치가 ON 상태일 때 색상 지정
                      onChanged: (bool value) {
                        setState(() {
                          _child1 = value;
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Color(0xFFBDBDBD),
                        thickness: 1,
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('자녀2'),
                      value: _child2,
                      activeColor: const Color(0xFFFF7B1B),  // 스위치가 ON 상태일 때 색상 지정
                      onChanged: (bool value) {
                        setState(() {
                          _child2 = value;
                        });
                      },
                    ),
                  ],
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
