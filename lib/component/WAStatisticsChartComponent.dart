import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/utils/WAColors.dart';

class WAStatisticsChartComponent extends StatefulWidget {
  static String tag = '/WAStatisticsChartComponent';

  const WAStatisticsChartComponent({super.key});

  @override
  WAStatisticsChartComponentState createState() => WAStatisticsChartComponentState();
}

class WAStatisticsChartComponentState extends State<WAStatisticsChartComponent> {
  final Color leftBarColor = WAPrimaryColor;
  final Color rightBarColor = Colors.red;
  late final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
      child: BarChart(
        BarChartData(
          maxY: 20,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      (() {
                        switch (value.toInt()) {
                          case 0:
                            return 'Mn';
                          case 1:
                            return 'Te';
                          case 2:
                            return 'Wd';
                          case 3:
                            return 'Tu';
                          case 4:
                            return 'Fr';
                          case 5:
                            return 'St';
                          case 6:
                            return 'Sn';
                          default:
                            return '';
                        }
                      })(),
                    ),
                  );
                },
              )
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 14,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      (() {
                        if (value == 0) {
                          return '100k';
                        } else if (value == 10) {
                          return '20k';
                        } else if (value == 19) {
                          return '25k';
                        } else if (value == 5) {
                          return '14k';
                        } else {
                          return '';
                        }
                      })(),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: showingBarGroups,
        ),
      ).center(),
    ).paddingAll(16).center();
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
