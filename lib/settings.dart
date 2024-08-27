import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                '  기타',
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
                padding: const EdgeInsets.all(10.0),  // 원하는 패딩 값 설정
                child: ListTile(
                    title: const Text(
                      '오작동 비속어 신고하기',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    onTap: (){
                      dialog();
                    }
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
            '오작동 비속어 신고하기',
            style: TextStyle(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 10),
                TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '내용을 입력해주세요',
                  ),
                  maxLines: 5, // You can adjust the maxLines according to your needs
                ),
              ],
            ),
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
          ],
        );
      },
    );
  }

}
