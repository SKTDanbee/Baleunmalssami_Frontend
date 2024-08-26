import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'parentcyberreportlist.dart';

class ParentCyberReportPage extends StatefulWidget {
  @override
  _ParentCyberReportPageState createState() => _ParentCyberReportPageState();
}

class _ParentCyberReportPageState extends State<ParentCyberReportPage> {
  Dio _dio = Dio();
  String? reportDate;
  String? reportContent;
  bool isLoading = false; //로딩창!!

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final String url = 'https://ansim-app-f6abfdhmexe8ged3.koreacentral-01.azurewebsites.net/reports/'; // 모든 레코드를 가져오는 API 엔드포인트

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {
          for (var i = 0; i < data.length; i++) {
            if (i == 0) {
              // 첫 번째 투플의 report_date와 report_content 저장
              reportDate = data[i]['report_date'];
              reportContent = data[i]['report_cyber'];
            }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '자녀1의 사이버폭력 레포트',
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
              Card(
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
                        '사이버 폭력 주의',
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // 지난 레포트 보기 페이지로 이동하는 로직
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParentCyberReportListPage()),
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