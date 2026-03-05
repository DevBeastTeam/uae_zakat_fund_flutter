import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/stats_data.dart';

Widget statsContainer({required StatsData stats}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
          color: stats.backgroundColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
              color: stats.titleStyle.color ?? stats.backgroundColor,
              width: 1.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stats.title.tr,
            style: stats.titleStyle,
          ),
          Text(
            stats.value,
            style: stats.valueStyle,
          ),
        ],
      ),
    ),
  );
}
