import 'package:flutter/material.dart';
import 'package:zakat_fund/utils/utils.dart';

String arEnText({
  required BuildContext context,
  required String ar,
  required String en,
}) {
  return Utils.isArabic ? ar : en;
}
