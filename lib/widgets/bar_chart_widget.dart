import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  final Color leftBarColor = AppColors.lightBrownColor2;
  final Color rightBarColor = AppColors.lightYellowColor1;
  final Color avgColor = AppColors.redColor;

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;


  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 40, 9);
    final barGroup2 = makeGroupData(1, 50, 18);
    final barGroup3 = makeGroupData(2, 19,5);
    final barGroup4 = makeGroupData(3, 29, 16);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: BarChart(
        BarChartData(
          maxY: 60,
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 50.h,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 1,
                getTitlesWidget: leftTitles,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: showingBarGroups,
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 10) {
      text = '10';
    } else if (value == 20) {
      text = '20';
    } else if (value == 30) {
      text = '30';
    } else if (value == 40) {
      text = '40';
    } else if (value == 50) {
      text = '50';
    } else if (value == 60) {
      text = '60';
    } else {
      return Container();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: AppTextStyle.darkerGrey10TextStyle),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      'guestDonor',
      'registeredDonor',
      'company',
      'association'
    ];

    final Widget text = Text(
      titles[value.toInt()].tr,
      textAlign: TextAlign.center,
      style: AppTextStyle.darkerGrey12spTextStyle,
    );

    return SideTitleWidget(
      meta: meta,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: 10.w,

        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: 10.w,
        ),
      ],
    );
  }
}
