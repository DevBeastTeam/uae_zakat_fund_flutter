import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> monthsList;
  final bool isTime;
  const LineChartWidget(
      {super.key,
      this.spots = const [],
      this.monthsList = const [],
      this.isTime = false});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        child: SizedBox(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.lightGrey,
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) => Text(
                Utils.getCurrency(value.toInt()),
                style: AppTextStyle.secondaryGrey10spTextStyle,
                textAlign: TextAlign.left),
            reservedSize: Utils.isArabic?50:35,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: monthsList.isNotEmpty,
            reservedSize: isTime?50:16,
            getTitlesWidget: (value, meta) {
              return Transform.rotate(
                angle: isTime?0:-0.5,
                child: Text(monthsList[value.toInt()],
                    textAlign: TextAlign.center,
                    textDirection: isTime?TextDirection.ltr:null,
                    style: AppTextStyle.secondaryGrey10spTextStyle),
              );
            },
            interval: 1,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border:
            Border(bottom: BorderSide(color: AppColors.lightGrey, width: 0.5)),
      ),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: Colors.grey[800],
          tooltipBorderRadius: BorderRadius.circular(10.r),
          getTooltipColor: (LineBarSpot touchedSpot) =>
              isTime ? AppColors.lightBlueColor3 : AppColors.lightBrownColor2,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipPadding: const EdgeInsets.all(8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toInt()}',
                AppTextStyle.secondaryGrey10spTextStyle
                    .copyWith(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          gradient: LinearGradient(
            colors: isTime
                ? [AppColors.lightBlueColor3, AppColors.lightBlueColor3]
                : [AppColors.lightBrownColor2, AppColors.lightBrownColor2],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          color: isTime ? Colors.blue : null,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isTime
                  ? [
                      AppColors.lightBlueColor3.withOpacity(0.30),
                      AppColors.lightBlueColor3.withOpacity(0.05),
                    ]
                  : [
                      AppColors.lightBrownColor2.withOpacity(0.15),
                      AppColors.lightBrownColor2.withOpacity(0.0),
                    ],
              stops: [0.0, 0.9],
            ),
          ),
        ),
      ],
      minX: 0,
      minY: 0,
        // maxY: _getMaxY(spots)
    );
  }

  double _getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    final max = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return max + (max * 0.1); // Add 10% padding
  }

}
