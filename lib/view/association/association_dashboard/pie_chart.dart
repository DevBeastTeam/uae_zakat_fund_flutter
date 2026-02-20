import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

class DonutChart extends StatelessWidget {
  final List<DashboardData> data;
  final double radius,centerSpaceRadius;
  const DonutChart({super.key, required this.data,this.radius=45,this.centerSpaceRadius=45});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: PieChart(
        PieChartData(
          sections: List.generate(data.length, (index)=>PieChartSectionData(
            color: data[index].backColor,
            value: data[index].valueInDouble,
            showTitle: false,
            radius: radius.r,
          )),
          centerSpaceRadius: centerSpaceRadius.r,
          sectionsSpace: 0,
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final String percentage;

  const Indicator({super.key,
    required this.color,
    required this.text,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        8.horizontalSpace,
        Flexible(
          child: RichText(
            text: TextSpan(
                text: "${text.tr} ",
                style: AppTextStyle.greyDark12spTextStyle1.copyWith(fontFamily: 'Alexandria'),
                children: <TextSpan>[
                  TextSpan(
                      text: percentage.tr,
                      style: AppTextStyle.secondaryBlack12spTextStyle.copyWith(fontFamily: 'Alexandria'))
                ]),
          ),
        ),
      ],
    );
  }
}
