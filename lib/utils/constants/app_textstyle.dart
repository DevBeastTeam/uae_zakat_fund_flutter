import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

abstract class AppTextStyle {
  static TextStyle buttonTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.btnTextColor,
  );

  static TextStyle button20spTextStyle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.btnTextColor,
  );

  static TextStyle lightGrey10spTextStyle = TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.lightGreyColor);

  static TextStyle darkGrey10spTextStyle = TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.darkGreyColor);

  static TextStyle secondaryBlack10spTextStyle = TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryBlackColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle black16spTextStyle = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle black18spTextStyle = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w600,
      fontSize: 18.sp);

  static TextStyle black16spTextStyle2 = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle black12spTextStyle = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle darkBrown16spTextStyle = TextStyle(
      color: AppColors.darkBrownColor,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkBrown16spTextStyle1 = TextStyle(
      color: AppColors.darkBrownColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle darkGreen16spTextStyle = TextStyle(
      color: AppColors.darkGreenColor,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkGreen16spTextStyle1 = TextStyle(
      color: AppColors.darkGreenColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle darkGrey12spTextStyle = TextStyle(
      color: AppColors.darkGreyColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500);

  static TextStyle darkGrey12spTextStyle1 = TextStyle(
      color: AppColors.darkGreyColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400);

  static TextStyle darkBrown18spTextStyle = TextStyle(
    color: AppColors.darkBrownColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle darkBrown13spTextStyle = TextStyle(
    color: AppColors.darkBrownColor,
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle primaryDarkBrown24spTextStyle = TextStyle(
    color: AppColors.primaryDarkBrownColor,
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle primaryDarkBrown24spTextStyle1 = TextStyle(
    color: AppColors.primaryDarkBrownColor,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle primaryDarkBrown24spTextStyle2 = TextStyle(
    color: AppColors.primaryDarkBrownColor,
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle darkBrown18spTextStyle1 = TextStyle(
    color: AppColors.darkBrownColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle darkBrown12spTextStyle = TextStyle(
    color: AppColors.darkBrownColor,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
  );

  static TextStyle darkBrown14spTextStyle = TextStyle(
      color: AppColors.darkBrownColor,
      overflow: TextOverflow.ellipsis,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500);

  static TextStyle darkRed14spTextStyle = TextStyle(
      color: AppColors.darkRedColor,
      overflow: TextOverflow.ellipsis,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500);

  static TextStyle darkGreen14spTextStyle = TextStyle(
      color: AppColors.darkGreenColor,
      overflow: TextOverflow.ellipsis,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500);

  static TextStyle greyDark14spTextStyle = TextStyle(
      color: AppColors.greyDarkColor,
      overflow: TextOverflow.ellipsis,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500);

  static TextStyle greyDark14spTextStyle1 = TextStyle(
      color: AppColors.greyDarkColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400);

  static TextStyle darkBrown14spTextStyle1 = TextStyle(
      color: AppColors.darkBrownColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryBlack12spTextStyle = TextStyle(
      fontFamily: "Inter",
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle secondaryBlack12spTextStyle1 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp);

  static TextStyle btnText16spTextStyle = TextStyle(
      fontFamily: "Inter",
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle btnText12spTextStyle = TextStyle(
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w700,
      fontSize: 12.sp);

  static TextStyle btnText12spTextStyle1 = TextStyle(
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp);

  static TextStyle btnText16spTextStyle1 = TextStyle(
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle primaryDarkBrown16spTextStyle = TextStyle(
      fontFamily: "Inter",
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle primaryDarkBrown16spTextStyle1 = TextStyle(
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle primaryDarkBrown64spTextStyle2 = TextStyle(
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w500,
      fontSize: 64.sp);

  static TextStyle primaryDarkBrown64spTextStyle3 = TextStyle(
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w400,
      fontSize: 24.sp);

  static TextStyle secondaryBlack14spTextStyle = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp);

  static TextStyle secondaryBlack18spTextStyle = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontFamily: "Inter",
      fontWeight: FontWeight.w500,
      fontSize: 18.sp);

  static TextStyle secondaryBlack18spTextStyle1 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w400,
      fontSize: 18.sp);

  static TextStyle secondaryBlack18spTextStyle2 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w500,
      fontSize: 18.sp);

  static TextStyle secondaryBlack18spTextStyle3 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w600,
      fontSize: 18.sp);

  static TextStyle secondaryDarkGrey12spTextStyle = TextStyle(
      color: AppColors.secondaryDarkGreyColor,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle secondaryDarkGrey16spTextStyle = TextStyle(
      color: AppColors.secondaryDarkGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 16.sp);

  static TextStyle secondaryDarkGrey14spTextStyle = TextStyle(
      color: AppColors.secondaryDarkGreyColor,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp);

  static TextStyle lightGrey12spTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      color: AppColors.lightGreyColor);

  static TextStyle accentBrown12spTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      color: AppColors.accentBrownColor);

  static TextStyle accentBrown14spTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.sp,
      color: AppColors.accentBrownColor);

  static TextStyle lightGrey18spTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18.sp,
      color: AppColors.lightGreyColor);

  static TextStyle darkGreyOne12spTextStyle1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.darkGrey1,
  );

  static TextStyle darkGreyOne14spTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: AppColors.darkGrey1,
  );

  static TextStyle darkGreyOne14spTextStyle3 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.darkGrey1,
  );

  static TextStyle darkGreyOne12spTextStyle2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: AppColors.darkGrey1,
  );

  static TextStyle lightGrey16spTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.sp,
      color: AppColors.lightGreyColor);

  static TextStyle primaryDarkBlack14spTextStyle = TextStyle(
      color: AppColors.primaryDarkBlackColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkBlack10spTextStyle = TextStyle(
      color: AppColors.primaryDarkBlackColor,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkBlack12spTextStyle = TextStyle(
      color: AppColors.primaryDarkBlackColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkBlack16spTextStyle = TextStyle(
      color: AppColors.primaryDarkBlackColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkBlack16spTextStyle1 = TextStyle(
      color: AppColors.primaryDarkBlackColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600);

  static TextStyle primaryDarkBlack14spTextStyle1 = TextStyle(
      color: AppColors.primaryDarkBlackColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400);

  static TextStyle primaryDarkBlack36spTextStyle = TextStyle(
      color: AppColors.primaryDarkBlackColor,
      fontSize: 36.sp,
      fontWeight: FontWeight.w500);

  static TextStyle primaryBlack14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.primaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle primaryBlack16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.primaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle primaryDarkBrown14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkBrown18spTextStyle = TextStyle(
      fontSize: 18.sp,
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle black14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500);

  static TextStyle black20spTextStyle = TextStyle(
      fontSize: 20.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w600);

  static TextStyle accentBlue14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.accentBlueColor,
      fontWeight: FontWeight.w400);

  static TextStyle black24spTextStyle = TextStyle(
      fontSize: 24.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w700);

  static TextStyle blackColor16spTextStyle = TextStyle(
    fontSize: 16.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
  );

  static TextStyle blackColor16spTextStyle1 = TextStyle(
    fontSize: 16.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
  );

  static TextStyle black14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w400);

  static TextStyle blue14spTextStyle = TextStyle(
      fontSize: 14.sp, color: AppColors.blueColor, fontWeight: FontWeight.w400);

  static TextStyle darkBrown20spTextStyle = TextStyle(
      fontFamily: "Inter",
      color: AppColors.darkBrownColor,
      fontWeight: FontWeight.w500,
      fontSize: 20.sp);

  static TextStyle darkBrown28spTextStyle = TextStyle(
      color: AppColors.darkBrownColor,
      fontWeight: FontWeight.w700,
      fontSize: 28.sp);

  static TextStyle textFieldHintStyle = TextStyle(
    color: AppColors.darkGreyColor,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
  );

  static TextStyle secondaryDarkBrown36spTextStyle = TextStyle(
      fontSize: 36.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w600);

  static TextStyle darkGreyColor14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle btnText18spTextStyle = TextStyle(
      fontSize: 18.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w500);

  static TextStyle btnText12spTextStyle2 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w500);

  static TextStyle btnText24spTextStyle = TextStyle(
      fontSize: 24.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w600);

  static TextStyle btnText24spTextStyle2 = TextStyle(
      fontSize: 24.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w700);

  static TextStyle btnText24spTextStyle1 = TextStyle(
      fontSize: 20.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w700);

  static TextStyle btnText14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w400);

  static TextStyle btnText14spTextStyle2 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w500);

  static TextStyle white16spTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static TextStyle white32spTextStyle = TextStyle(
    fontSize: 32.sp,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle white16spTextStyle1 = TextStyle(
    fontSize: 16.sp,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static TextStyle white16spTextStyle2 = TextStyle(
    fontSize: 16.sp,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static TextStyle white24spTextStyle = TextStyle(
    fontSize: 24.sp,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static TextStyle white26spTextStyle = TextStyle(
    fontSize: 26.sp,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  static TextStyle white20spTextStyle = TextStyle(
    fontSize: 20.sp,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static TextStyle white18spTextStyle = TextStyle(
    fontSize: 18.sp,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static TextStyle white14spTextStyle = TextStyle(
    fontSize: 14.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static TextStyle white14spTextStyle1 = TextStyle(
    fontSize: 14.sp,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static TextStyle white18spTextStyle1 = TextStyle(
    fontSize: 18.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static TextStyle white18spTextStyle2 = TextStyle(
    fontSize: 18.sp,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static TextStyle darkBlack14spTextStyle = TextStyle(
      fontSize: 14.sp,
      fontFamily: 'Inter',
      color: AppColors.darkBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle darkBlack14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle darkBlack18spTextStyle = TextStyle(
      fontSize: 18.sp,
      color: AppColors.darkBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle darkerGrey14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkerGrey14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w500);

  static TextStyle darkerGrey12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkerGrey16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkerGrey16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w500);

  static TextStyle darkerGrey24spTextStyle = TextStyle(
      fontSize: 24.sp,
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w600);

  static TextStyle lightBrown24spTextStyle = TextStyle(
      fontSize: 24.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w600);

  static TextStyle lightBrown20spTextStyle = TextStyle(
      fontSize: 20.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle lightBrown14spTextStyle2 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkBrown14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkBrown14spTextStyle2 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.primaryDarkBrownColor,
      fontWeight: FontWeight.w400);

  static TextStyle primaryDarkGrey14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle primaryDarkGrey14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkGrey14spTextStyle2 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w700);

  static TextStyle primaryDarkGrey18spTextStyle = TextStyle(
      fontSize: 18.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle primaryDarkGrey12spTextStyle1 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle lightBlue12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.lightBlueColor,
      fontWeight: FontWeight.w500);

  static TextStyle primaryDarkGrey12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w500);

  static TextStyle lightGreen12spTextStyle = TextStyle(
      fontSize: 20.sp,
      color: AppColors.lightGreenColor,
      fontWeight: FontWeight.w500);

  static TextStyle darkGrey114spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w400);

  static TextStyle primaryDarkGrey16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w600);

  static TextStyle primaryDarkGrey16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.primaryDarkGreyColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w400);

  static TextStyle lightBlack16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.lightBlack,
      fontWeight: FontWeight.w600);

  static TextStyle lightBlack13spTextStyle = TextStyle(
      fontSize: 13.sp,
      color: AppColors.lightBlack,
      fontWeight: FontWeight.w700);

  static TextStyle lightBlack13spTextStyle1 = TextStyle(
      fontSize: 10.sp,
      color: AppColors.lightBlack,
      fontWeight: FontWeight.w400);

  static TextStyle lightBlack14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.lightBlack,
      fontWeight: FontWeight.w400);

  static TextStyle black13spTextStyle = TextStyle(
    fontSize: 13.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
  );

  static TextStyle lightBlack16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.lightBlack,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack13spTextStyle = TextStyle(
      fontSize: 13.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w700);

  static TextStyle secondaryPrimaryBlack13spTextStyle1 = TextStyle(
      fontSize: 13.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack13spTextStyle2 = TextStyle(
      fontSize: 13.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle lightBrownColor16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w600);

  static TextStyle lightBrownColor40spTextStyle = TextStyle(
      fontSize: 40.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack32spTextStyle = TextStyle(
      fontSize: 32.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack32spTextStyle1 = TextStyle(
      fontSize: 32.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack20spTextStyle1 = TextStyle(
      fontSize: 20.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryPrimaryBlack20spTextStyle3 = TextStyle(
      fontSize: 20.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack20spTextStyle2 = TextStyle(
      fontSize: 20.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack16spTextStyle2 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryPrimaryBlack16spTextStyle3 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack18spTextStyle = TextStyle(
      fontSize: 18.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack18spTextStyle1 = TextStyle(
      fontSize: 18.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkerGreen14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkerGreenColor,
      fontWeight: FontWeight.w600);

  static TextStyle darkerGreen14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkerGreenColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryBtnBackground14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.secondaryBtnBackgroundColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryBtnBackground12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.secondaryBtnBackgroundColor,
      fontWeight: FontWeight.w500);

  static TextStyle btnBackground12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.btnBackgroundColor,
      fontWeight: FontWeight.w600);

  static TextStyle btnBackground14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.btnBackgroundColor,
      fontWeight: FontWeight.w600);

  static TextStyle btnBackground16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.btnBackgroundColor,
      fontWeight: FontWeight.w600);

  static TextStyle btnBackground16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.btnBackgroundColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack8spTextStyle = TextStyle(
      fontSize: 8.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack12spTextStyle1 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle lightBrown14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w700);

  static TextStyle lightBrown14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle lightBrown14spTextStyle3 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkBrown20spTextStyle1 = TextStyle(
      fontSize: 20.sp,
      color: AppColors.darkBrownColor,
      fontWeight: FontWeight.w600);

  static TextStyle darkBrown12spTextStyle1 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.darkBrownColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkBrown12spTextStyle2 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.darkBrownColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack26spTextStyle1 = TextStyle(
      fontSize: 26.sp,
      height: 0,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w700);

  static TextStyle secondaryPrimaryBlack26spTextStyle = TextStyle(
      fontSize: 26.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle newGreyColor14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.newGreyColor,
      fontWeight: FontWeight.w500);

  static TextStyle newGreyColor12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.newGreyColor,
      fontWeight: FontWeight.w700);

  static TextStyle newGreyColor12spTextStyle1 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.newGreyColor,
      fontWeight: FontWeight.w600);

  static TextStyle newGreyColor32spTextStyle = TextStyle(
      fontSize: 32.sp,
      color: AppColors.newGreyColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack14spTextStyle1 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack14spTextStyle2 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryPrimaryBlack24spTextStyle = TextStyle(
      fontSize: 24.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack24spTextStyle1 = TextStyle(
      fontSize: 24.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack20spTextStyle = TextStyle(
      fontSize: 20.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack20spTextStyle4 = TextStyle(
      fontSize: 20.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.bold);

  static TextStyle btnText14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.btnTextColor,
      fontWeight: FontWeight.w600);

  static TextStyle red12spTextStyle = TextStyle(
      fontSize: 12.sp, color: AppColors.redColor, fontWeight: FontWeight.w400);

  static TextStyle red14spTextStyle2 = TextStyle(
      fontSize: 14.sp, color: AppColors.redColor, fontWeight: FontWeight.w500);

  static TextStyle red16spTextStyle = TextStyle(
      fontSize: 16.sp, color: AppColors.redColor, fontWeight: FontWeight.w500);

  static TextStyle red14spTextStyle = TextStyle(
      fontSize: 14.sp, color: AppColors.redColor, fontWeight: FontWeight.w700);

  static TextStyle red14spTextStyle1 = TextStyle(
      fontSize: 14.sp, color: AppColors.redColor, fontWeight: FontWeight.w400);

  static TextStyle green12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.greenColor,
      fontWeight: FontWeight.w400);

  static TextStyle green12spTextStyle1 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.greenColor,
      fontWeight: FontWeight.w500);

  static TextStyle generic12spTextStyle =
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500);

  static TextStyle green14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.greenColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkGrey14spTextStyle = TextStyle(
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle secondaryLightGrey14spTextStyle = TextStyle(
      color: AppColors.secondaryLightGreyColor1,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle darkerGreyColor14spTextStyle = TextStyle(
      color: AppColors.darkerGreyColor,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp);

  static TextStyle darkGrey20spTextStyle = TextStyle(
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w700,
      fontSize: 20.sp);

  static TextStyle darkGrey16spTextStyle1 = TextStyle(
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkGrey16spTextStyle = TextStyle(
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 16.sp);

  static TextStyle darkGrey13spTextStyle = TextStyle(
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 13.sp);

  static TextStyle secondaryBlack14spTextStyle1 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle secondaryBlack24spTextStyle1 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w500,
      fontSize: 24.sp);

  static TextStyle secondaryBlack14spTextStyle2 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w700,
      fontSize: 14.sp);

  static TextStyle secondaryBlack14spTextStyle3 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp);

  static TextStyle secondaryBlack16spTextStyle = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w700,
      fontSize: 16.sp);

  static TextStyle darkPink16spTextStyle = TextStyle(
      color: AppColors.darkPinkColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkOrange16spTextStyle = TextStyle(
      color: AppColors.darkOrangeColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkGreenColor16spTextStyle = TextStyle(
      color: AppColors.darkGreenColor1,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkGreenColor16spTextStyle1 = TextStyle(
      color: AppColors.darkGreenColor2,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkBlue16spTextStyle = TextStyle(
      color: AppColors.darkBlueColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkGreenColor16spTextStyle2 = TextStyle(
      color: AppColors.darkGreenColor3,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkGreenColor12spTextStyle = TextStyle(
      color: AppColors.darkGreenColor3,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle darkGreenColor12spTextStyle1 = TextStyle(
      color: AppColors.darkGreenColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle darkBlue20spTextStyle = TextStyle(
      color: AppColors.darkBlueColor,
      fontWeight: FontWeight.w600,
      fontSize: 20.sp);

  static TextStyle darkPurple16spTextStyle = TextStyle(
      color: AppColors.darkPurpleColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkRed16spTextStyle = TextStyle(
      color: AppColors.darkRedColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkRed12spTextStyle = TextStyle(
      color: AppColors.darkRedColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle darkPurple20spTextStyle = TextStyle(
      color: AppColors.darkPurpleColor,
      fontWeight: FontWeight.w600,
      fontSize: 20.sp);

  static TextStyle secondaryBlack16spTextStyle1 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle secondaryBlack16spTextStyle2 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w400,
      fontSize: 16.sp);

  static TextStyle secondaryBlack16spTextStyle3 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle tealGreyColor16spTextStyle = TextStyle(
    color: AppColors.tealGreyColor,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
  );

  static TextStyle tealGreyColor8spTextStyle = TextStyle(
    color: AppColors.tealGreyColor,
    fontWeight: FontWeight.w500,
    fontSize: 8.sp,
  );

  static TextStyle newColor14spTextStyle = TextStyle(
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle darkGreyOne18spTextStyle = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w600,
      fontSize: 18.sp);

  static TextStyle darkGreyOne14spTextStyle4 = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle darkGreyOne14spTextStyle1 = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp);

  static TextStyle darkGreyOne14spTextStyle2 = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle grey14spTextStyle = TextStyle(
      color: AppColors.grey, fontWeight: FontWeight.w500, fontSize: 14.sp);

  static TextStyle darkGreyOne16spTextStyle = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w400,
      fontSize: 16.sp);

  static TextStyle darkGreyOne12spTextStyle = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle darkGreyOne16spTextStyle2 = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkGreyOne12spTextStyle3 = TextStyle(
      color: AppColors.darkGreyColor1,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp);

  static TextStyle lightBrownColor12spTextStyle = TextStyle(
      color: AppColors.lightBrownColor,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp);

  static TextStyle secondaryBlack12spTextStyle2 = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle lightYellowColor12spTextStyle = TextStyle(
      color: AppColors.lightYellowColor1,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle secondaryLightBlue12spTextStyle = TextStyle(
      color: AppColors.secondaryLightBlueColor,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle lightBrownColor12spTextStyle1 = TextStyle(
      color: AppColors.lightBrownColor2,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle lightBrownColor16spTextStyle2 = TextStyle(
      color: AppColors.lightBrownColor2,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle darkBlue12spTextStyle = TextStyle(
      color: AppColors.darkBlueColor,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle greyDark12spTextStyle = TextStyle(
      color: AppColors.greyDarkColor,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  static TextStyle greyDark12spTextStyle1 = TextStyle(
      color: AppColors.greyDarkColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle secondaryGrey10spTextStyle = TextStyle(
      color: AppColors.secondaryGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 10.sp);

  static TextStyle lightBrown16spTextStyle = TextStyle(
      color: AppColors.lightBrownColor2,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle lightBrown14spTextStyle4 = TextStyle(
      color: AppColors.lightBrownColor2,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp);

  static TextStyle lightBrown14spTextStyle5 = TextStyle(
      color: AppColors.lightBrownColor2,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp);

  static TextStyle darkerGrey10TextStyle = TextStyle(
      color: AppColors.darkerGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 10.sp);

  static TextStyle darkGrey13TextStyle = TextStyle(
      color: AppColors.darkGreyColor,
      fontWeight: FontWeight.w600,
      fontSize: 13.sp);

  static TextStyle secondaryPrimaryBlack13TextStyle = TextStyle(
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w500,
      fontSize: 13.sp);

  static TextStyle btnBackground12spTextStyle1 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.btnBackgroundColor,
      fontWeight: FontWeight.w400);

  static TextStyle lightBrown12spTextStyle2 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.lightBrownColor1,
      fontWeight: FontWeight.w400);

  static TextStyle lightBrown16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.lightBrownColor1,
      fontWeight: FontWeight.w600);

  static TextStyle highBack12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.highBackColor,
      fontWeight: FontWeight.w400);

  static TextStyle highBack16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.highBackColor,
      fontWeight: FontWeight.w600);

  static TextStyle highBack16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.highBackColor,
      fontWeight: FontWeight.w500);

  static TextStyle grey12spTextStyle = TextStyle(
    fontSize: 12.sp,
    color: AppColors.grey,
    fontWeight: FontWeight.w500,
  );

  static TextStyle lightBlackColor12TextStyle = TextStyle(
    fontSize: 12.sp,
    color: AppColors.lightBlackColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle lightBlackColor12TextStyle2 = TextStyle(
    fontSize: 12.sp,
    color: AppColors.lightBlackColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle lightBlackColor12TextStyle1 = TextStyle(
    fontSize: 12.sp,
    color: AppColors.lightBlackColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle lightBlackColor20TextStyle = TextStyle(
    fontSize: 20.sp,
    color: AppColors.lightBlackColor,
    fontWeight: FontWeight.w600,
  );

  static TextStyle secondaryGrey12spTextStyle = TextStyle(
      color: AppColors.secondaryGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle secondaryGrey10spTextStyle1 = TextStyle(
      color: AppColors.secondaryGreyColor,
      fontWeight: FontWeight.w500,
      fontSize: 10.sp);

  static TextStyle greyDark8spTextStyle = TextStyle(
      color: AppColors.greyDarkColor,
      fontSize: 8.sp,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryBlack10spTextStyle1 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryBlackColor,
  );

  static TextStyle secondaryGrey6spTextStyle = TextStyle(
      color: AppColors.secondaryGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 6.sp);

  static TextStyle secondaryGrey8spTextStyle = TextStyle(
      color: AppColors.secondaryGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 8.sp);

  static TextStyle black12spTextStyle1 = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp);

  static TextStyle blackColor10spTextStyle = TextStyle(
    fontSize: 10.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
  );

  static TextStyle darkPinkColor12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.darkPinkColor,
      fontWeight: FontWeight.w400);

  static TextStyle darkGreen12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.darkGreenColor1,
      fontWeight: FontWeight.w400);

  static TextStyle darkPink16spTextStyle1 = TextStyle(
      color: AppColors.darkPinkColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle darkGreenColor16spTextStyle5 = TextStyle(
      color: AppColors.darkGreenColor1,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle darkOrange12spTextStyle = TextStyle(
      color: AppColors.darkOrangeColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle darkOrange16spTextStyle1 = TextStyle(
      color: AppColors.darkOrangeColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle darkPurple12spTextStyle = TextStyle(
      color: AppColors.darkPurpleColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle darkPurple12spTextStyle3 = TextStyle(
      color: AppColors.darkOrangeColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle darkPurple16spTextStyle1 = TextStyle(
      color: AppColors.darkPurpleColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp);

  static TextStyle white12spTextStyle = TextStyle(
      fontFamily: "Inter",
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp);

  static TextStyle secondaryBlack20spTextStyle = TextStyle(
      color: AppColors.secondaryBlackColor,
      fontWeight: FontWeight.w600,
      fontSize: 20.sp);

  static TextStyle lightBrown14spTextStyle6 = TextStyle(
      color: AppColors.lightBrownColor2,
      fontWeight: FontWeight.w700,
      fontSize: 14.sp);

  static TextStyle secondaryDarkGrey16spTextStyle1 = TextStyle(
      color: AppColors.secondaryDarkGreyColor,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp);

  static TextStyle secondaryDarkBrown18spTextStyle = TextStyle(
      fontSize: 18.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryPrimaryBlack40spTextStyle = TextStyle(
      fontSize: 40.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryPrimaryBlack12spTextStyle2 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.w600);

  static TextStyle secondaryPrimaryBlack32spTextStyle2 = TextStyle(
      fontSize: 32.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      height: 0,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryPrimaryBlack48spTextStyle = TextStyle(
      fontSize: 48.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      height: 0,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryPrimaryBlack18spTextStyle2 = TextStyle(
      fontSize: 18.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      height: 0,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryPrimaryBlack24spTextStyle2 = TextStyle(
      fontSize: 22.sp,
      color: AppColors.secondaryPrimaryBlackColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryDarkBrownColor40spTextStyle = TextStyle(
      fontSize: 40.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryDarkBrownColor16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryDarkBrownColor16spTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryDarkBrownColor12spTextStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryDarkBrownColor12spTextStyle1 = TextStyle(
      fontSize: 12.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle lightGrey116spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.lightGrey1,
      fontWeight: FontWeight.w400);

  static TextStyle bottomBarTextColor16spTextStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.bottomBarTextColor,
      fontWeight: FontWeight.w400);

  static TextStyle bottomBarTextColor20spTextStyle = TextStyle(
      fontSize: 20.sp,
      color: AppColors.bottomBarTextColor,
      fontWeight: FontWeight.w600);

  static TextStyle bottomBarTextColor18spTextStyle = TextStyle(
      fontSize: 18.sp,
      color: AppColors.bottomBarTextColor,
      fontWeight: FontWeight.w700);

  static TextStyle secondaryDarkBrownColor8spTextStyle = TextStyle(
      fontSize: 8.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w400);

  static TextStyle secondaryDarkBrownColor14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w500);
  static TextStyle themeTextColor14spTextStyle = TextStyle(
      fontSize: 14.sp,
      color: themeViewModel.color,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryDarkBrownColor10spTextStyle = TextStyle(
      fontSize: 10.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w500);

  static TextStyle secondaryDarkBrownColor20spTextStyle = TextStyle(
      fontSize: 20.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryDarkBrownColor26spTextStyle = TextStyle(
      fontSize: 26.sp,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.bold);

  static TextStyle secondaryDarkBrownColor32spTextStyle = TextStyle(
      fontSize: 32.sp,
      height: 0,
      color: AppColors.secondaryDarkBrownColor,
      fontWeight: FontWeight.w600);

  static TextStyle greyColor10spTextStyle = TextStyle(
      fontSize: 10.sp, color: AppColors.greyColor, fontWeight: FontWeight.w400);

  static TextStyle greyColor14spTextStyle = TextStyle(
      fontSize: 14.sp, color: AppColors.greyColor, fontWeight: FontWeight.w400);

  static TextStyle darkGreyOne16spTextStyle1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: AppColors.darkGrey1,
  );

  static TextStyle urgentText12spTextStyle1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.urgentText,
  );

  static TextStyle warningBackColor12spTextStyle1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.warningBackColor,
  );

  static TextStyle lightGray12spTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.lightGray,
  );
}
