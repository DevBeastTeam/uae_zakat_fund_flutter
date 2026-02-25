import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/donor_demographic.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

class GenderBarChart extends StatelessWidget {
  final List<String> bottomBarData;
  final bool ratings;
  final double angle;
  final List<DonorDemographic> leftBarData;
  final Function(int val)? onBarClick;
  const GenderBarChart({super.key, required this.bottomBarData, required this.leftBarData, this.onBarClick,this.ratings=false,this.angle=0});

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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AspectRatio(
              aspectRatio: 1.6,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                        bottom: BorderSide(color: Color(0xff808080), width: 0.5)),
                  ),
                  barTouchData: BarTouchData(enabled: false,touchCallback: (event, response) {
                    if (event is FlTapUpEvent && response != null && response.spot != null) {
                      final index = response.spot!.touchedBarGroupIndex;
                      if(onBarClick!=null)onBarClick!(index);
                    }
                  },),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) => Text(
                            value.toInt().toString(),
                            style: AppTextStyle.secondaryGrey10spTextStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Transform.rotate(
                            angle: angle,
                            child: Container(
                              // color: Colors.red,
                              margin: EdgeInsets.only(top: 13),
                              child: Text(bottomBarData[value.toInt()],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.secondaryGrey8spTextStyle),
                            ),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                      show: true, drawHorizontalLine: true, drawVerticalLine: false),
                  barGroups: List.generate(leftBarData.length, (index)=>_buildBarGroup(index, leftBarData[index].male.toDouble(), leftBarData[index].female.toDouble())),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double male, double female) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: male,
          color: ratings?AppColors.lightBrownColor2:AppColors.maleColor,
          width: bottomBarData.length<=3?20.w:null,
          borderRadius: BorderRadius.zero,
        ),
        BarChartRodData(
          toY: female,
          width: bottomBarData.length<=3?20.w:null,
          borderRadius: BorderRadius.zero,
          color: ratings?AppColors.lightYellowColor1:AppColors.femaleColor,
        ),

      ],
    );
  }
}
