import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

class SecurePaymentTitleWidget extends StatelessWidget {
  const SecurePaymentTitleWidget({
    this.padding,
    this.bgColor,
    super.key,
  });

  final EdgeInsetsGeometry? padding;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_rounded,
                color: AppColors.accentBrownColor,
                size: 24,
              ),
              SizedBox(height: 4.h),
              Text(
                // "securePaymentMessage".tr,
                "paymentSecureMessage".tr,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
