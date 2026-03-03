import 'package:flutter/material.dart';

class DashboardData {
  String title, value;
  String? icon;
  Color? backColor;
  Color? labelColor;
  TextStyle? style;
  double? valueInDouble;

  DashboardData({
    required this.title,
    required this.value,
    this.icon,
    this.style,
    this.backColor,
    this.labelColor,
    this.valueInDouble,
  });
}
