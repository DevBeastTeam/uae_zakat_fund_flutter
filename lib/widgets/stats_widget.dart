import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/stats_data.dart';

Widget statsContainer({required StatsData stats}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: stats.backgroundColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8.r)),
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