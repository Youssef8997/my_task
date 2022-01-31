import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class insight extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding:EdgeInsets.all(20),
    child: LineChart(
      LineChartData(
          maxX: 10,
          minX: 0,
          minY:0,
          maxY:6,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(4,0)
              ]
            )
          ])



      ),
  );

}
