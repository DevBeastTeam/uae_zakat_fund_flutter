import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/widgets/stats_widget.dart';

Widget buildStatsRow(int startIndex,List<StatsData> stats) {
  return Row(
    children: List.generate(
      3, (i) {
        final statIndex = startIndex + i;
        if (statIndex >= stats.length) return const Spacer();
        return Expanded(
          child: Row(
            children: [
              statsContainer(stats: stats[statIndex]),
              if (i < 2) 8.horizontalSpace,
            ],
          ),
        );
      },
    ),
  );
}