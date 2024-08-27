import 'package:flutter/material.dart';

class ParentSettingsPage extends StatefulWidget {
  @override
  _ParentSettingsPageState createState() => _ParentSettingsPageState();
}

class _ParentSettingsPageState extends State<ParentSettingsPage> {
  bool _pushNotification = true;
  bool _sound = false;
  bool _vibration = false;

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
                    ListTile(
                      title: const Text('자녀1'),
                      trailing: TextButton(
                        onPressed: () {
                          // '연결 해제' 버튼 클릭 시 실행될 코드 작성
                          dialog();
                        },
                        child: const Text(
                          '연결 해제',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF777777),
                            decoration: TextDecoration.underline, // 밑줄 추가
                          ),
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
                    ListTile(
                      title: const Text('자녀2'),
                      trailing: TextButton(
                        onPressed: () {
                          // '연결 해제' 버튼 클릭 시 실행될 코드 작성
                          dialog();
                        },
                        child: const Text(
                          '연결 해제',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF777777),
                            decoration: TextDecoration.underline, // 밑줄 추가
                          ),
                        ),
                      ),
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
  void dialog() async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '연결을 해제하시겠습니까?',
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(color: Color(0xFFFF7B1B)),
              ),
              onPressed: () {
                String userInput = _textFieldController.text;
                // Here you can handle the user's input, for example:
                // Send it to the server, save it, etc.
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '취소',
                style: TextStyle(color: Color(0xFF555555)),
              ),
              onPressed: () {
                String userInput = _textFieldController.text;
                // Here you can handle the user's input, for example:
                // Send it to the server, save it, etc.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
