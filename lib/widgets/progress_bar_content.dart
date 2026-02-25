import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

class ProgressBarContent extends StatelessWidget {
  final bool isDonation;
  final ProjectElements? project;

   ProgressBarContent({super.key, this.isDonation = false, this.project});
  final _formatter =  intl.NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4.r)),
            child: LinearProgressIndicator(
              minHeight: 4.h,
              color: AppColors.darkBrownColor,
              backgroundColor: AppColors.lightGrey1,
              value: project != null
                  ? project!.percentOfCompletion != null
                      ? project!.percentOfCompletion / 100
                      : 0
                  : 0,
            )),
        10.verticalSpace,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("collected".tr,
                    style:
                        AppTextStyle.secondaryDarkBrownColor16spTextStyle1),
                4.verticalSpace,
                Text(
                    project != null
                        ? "${project!.totalDonations != null ? _formatter.format(project!.totalDonations!) : 0} ${"currency".tr}"
                        : "10K AED",
                    textDirection: TextDirection.ltr,
                    style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("remaining".tr,
                    style:
                        AppTextStyle.secondaryDarkBrownColor16spTextStyle1),
                4.verticalSpace,
                if (project!.projectAmountObjective != null &&
                    project!.projectAmountObjective != "")
                  Text(
                      project != null
                          ? "${project!.remainingAmount == null ? _formatter.format(project!.projectAmountObjective) : project!.remainingAmount.toString().startsWith("-") ? "0" : _formatter.format(project!.remainingAmount)} ${"currency".tr}"
                          : "12K AED",
                      textDirection: TextDirection.ltr,
                      style:
                          AppTextStyle.secondaryPrimaryBlack16spTextStyle1),
              ],
            )
          ],
        ),
      ],
    );
  }
}
