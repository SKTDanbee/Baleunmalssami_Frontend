import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Dio _dio = Dio();
  List<int> abuseWeek = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final String url = 'https://b4b6-203-236-8-208.ngrok-free.app/reports/'; // 모든 레코드를 가져오는 API 엔드포인트

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {
          abuseWeek.clear();

          for (var i = 0; i < data.length; i++) {
            abuseWeek.add(data[i]['abuse_count']);
          }

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }

    setState(() {
      abuseWeek = abuseWeek.reversed.toList();  // 최신의 주간 데이터가 마지막에 오도록 순서를 뒤집습니다.
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '통계',
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: abuseWeek.isNotEmpty
                      ? (abuseWeek.reduce((a, b) => a > b ? a : b) + 10)
                      .toDouble()
                      : 70, // abuseWeek 리스트에서 최대 값을 기반으로 설정
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 10, // y축 값이 10
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('${value.toInt()}');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('6주 전');
                            case 1:
                              return const Text('5주 전');
                            case 2:
                              return const Text('4주 전');
                            case 3:
                              return const Text('3주 전');
                            case 4:
                              return const Text('2주 전');
                            case 5:
                              return const Text('지난주');
                            case 6:
                              return const Text('이번주');
                            default:
                              return const Text('');
                          }
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: abuseWeek
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: const Color(0xFFFF7B1B),
                        ),
                      ],
                    ),
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    const Text(
                      '이번 주 사용률',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: 0.1, // 실제 값으로 대체 가능
                              strokeWidth: 10,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFF7B1B)),
                              backgroundColor: Color(0xFFBDBDBD),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '10%', // 실제 값으로 대체 가능
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Text(
                                '총 사용량 : ${abuseWeek.isNotEmpty ? abuseWeek[0] : 0} 회',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ],
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
}
