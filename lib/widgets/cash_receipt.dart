import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Column cashReceipt(var data) {
  return Column(
    children: List.generate(
        data.length,
        (dataIndex) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data[dataIndex]["key"].toString().tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                      ),
                    ),
                    16.horizontalSpace,
                    Flexible(
                      child: Text(
                        data[dataIndex]["value"],
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
              ],
            )).toList(),
  );
}
