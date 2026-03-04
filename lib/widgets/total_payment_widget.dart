import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/constants/app_colors.dart';
import '../utils/constants/app_textstyle.dart';

class TotalPaymentWidget extends StatefulWidget {
  final int totalAmount;
  const TotalPaymentWidget({super.key, required this.totalAmount});

  @override
  State<TotalPaymentWidget> createState() => _TotalPaymentWidgetState();
}

class _TotalPaymentWidgetState extends State<TotalPaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          color: AppColors.grayColor,
          // color: const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("totalAmount".tr),
          Text(
            "${widget.totalAmount} ${"currency".tr}",
            style: AppTextStyle.secondaryBlack14spTextStyle,
          ),
        ],
      ),
    );
  }
}
