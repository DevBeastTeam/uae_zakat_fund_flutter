import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Text buildAccountValue(String value) => Text(
      value.tr,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.darkerGreyColor14spTextStyle,
    );

Text buildAccountTitle(String title) => Text(
      title.tr,
      style: AppTextStyle.grey14spTextStyle,
    );
