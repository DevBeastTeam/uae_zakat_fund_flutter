import 'package:flutter/material.dart';

class StatsData {
  String title, value;
  TextStyle titleStyle, valueStyle;
  Color backgroundColor;

  StatsData({
    required this.title,
    required this.value,
    required this.titleStyle,
    required this.valueStyle,
    required this.backgroundColor,
  });
}
