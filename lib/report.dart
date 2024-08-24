import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'reportlist.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Dio _dio = Dio();
  String? reportDate;
  String? reportContent;
  List<int> abuseWeek = [];
  bool isLoading = true;

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
          abuseWeek.clear();

          for (var i = 0; i < data.length; i++) {
            abuseWeek.add(data[i]['abuse_count']);
            if (i == 0) {
              // 첫 번째 투플의 report_date와 report_content 저장
              reportDate = data[i]['report_date'];
              reportContent = data[i]['report'];
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
          '나의 레포트',
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
                        '이번주 욕설 사용량',
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
                      Container(
                        height: 200,
                        alignment: Alignment.center, // 그래프를 중앙에 정렬
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text('4주 전');
                                      case 1:
                                        return const Text('3주 전');
                                      case 2:
                                        return const Text('2주 전');
                                      case 3:
                                        return const Text('1주 전');
                                      case 4:
                                        return const Text('이번주');
                                      default:
                                        return const Text('');
                                    }
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,  // Y축 표시 설정
                                  reservedSize: 15,  // 텍스트가 깨지지 않도록 공간 확보
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 12, // 텍스트 크기 설정
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            minX: 0,
                            maxX: 4,
                            minY: 0,
                            maxY: abuseWeek.isNotEmpty
                                ? abuseWeek.reduce((a, b) => a > b ? a : b).toDouble() + 10 : 10,
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(5, (index) {
                                  int adjustedIndex = 4 - index;
                                  return FlSpot(
                                    index.toDouble(),
                                    abuseWeek.length > adjustedIndex
                                        ? abuseWeek[adjustedIndex].toDouble()
                                        : 0.0,
                                  );
                                }),
                                isCurved: false,
                                color: const Color(0xFFFF7B1B),
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '이번주에 내가 가장 많이 사용한 욕설은?\n',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                          builder: (context) => ReportListPage()),
                    );
                  },
                  child: const Text(
                    '지난 레포트 보기 >',
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
