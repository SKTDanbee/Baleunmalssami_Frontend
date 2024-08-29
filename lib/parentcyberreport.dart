import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'parentcyberreportlist.dart';

class ParentCyberReportPage extends StatefulWidget {
  final int index;
  final Dio dio;
  final String myId;

  ParentCyberReportPage({required this.index, required this.dio, required this.myId});

  @override
  _ParentCyberReportPageState createState() => _ParentCyberReportPageState();
}

class _ParentCyberReportPageState extends State<ParentCyberReportPage> {
  String? reportDate;
  String? reportContent;
  bool isLoading = false; // 로딩창!!

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
          for (var i = 0; i < data.length; i++) {
            if (i == widget.index) {
              // 첫 번째 투플의 report_date와 report_content 저장
              reportDate = data[i]['report_date'];
              reportContent = data[i]['report'];
            }
          }

          isLoading = false;
        });
      } else {
        throw Exception('레포트를 불러오지 못했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('레포트를 불러오지 못했습니다.: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '사이버폭력 레포트',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, // 화면 너비를 꽉 채우도록 설정
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '사이버 폭력 레포트',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          reportDate ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          reportContent ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // 지난 레포트 보기 페이지로 이동하는 로직
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentCyberReportListPage(
                          dio: widget.dio, // dio 객체 전달
                          myId: widget.myId, // myId 전달
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    '지난 사이버 폭력 레포트 보기 >',
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
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
