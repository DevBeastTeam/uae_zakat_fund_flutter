import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class UaeLinkScreen extends StatelessWidget {
  const UaeLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeading(),
            if (!Utils.isArabic) 20.verticalSpace,
            _buildSubHeading(),
            20.verticalSpace,
            _buildChoiceBtn(),
            20.verticalSpace,
            _buildMessage(),
            4.verticalSpace,
            _buildSubMessage(),
            4.verticalSpace,
            Text("uaeLinkNote".tr,
                style: AppTextStyle.newGreyColor14spTextStyle),
            const Spacer(),
            // buildAlreadyHaveAccount(),
            // 16.verticalSpace,
            // buildFooter(),
          ],
        ),
      ),
    );
  }

  Row _buildSubMessage() {
    return Row(
            children: [
              Text("*", style: AppTextStyle.newGreyColor32spTextStyle),
              8.horizontalSpace,
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: 'uaeLinkSubHeading2'.tr,
                      style: AppTextStyle.newGreyColor14spTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text: "uaeLinkHeading2".tr,
                            style: AppTextStyle.lightBrown14spTextStyle2),
                        TextSpan(
                            text: "uaeLinkSubHeading1.1".tr,
                            style: AppTextStyle.lightBrown14spTextStyle2),
                        TextSpan(
                            text: "uaeLinkSubHeading2.1".tr,
                            style: AppTextStyle.newGreyColor14spTextStyle),
                      ]),
                ),
              ),
            ],
          );
  }

  Row _buildMessage() {
    return Row(
            children: [
              Text("*", style: AppTextStyle.newGreyColor32spTextStyle),
              8.horizontalSpace,
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: 'uaeLinkSubHeading1'.tr,
                      style: AppTextStyle.newGreyColor14spTextStyle
                          .copyWith(fontFamily: 'Roboto'),
                      children: <TextSpan>[
                        TextSpan(
                            text: "uaeLinkHeading2".tr,
                            style: AppTextStyle.lightBrown14spTextStyle2
                                .copyWith(fontFamily: 'Roboto')),
                        TextSpan(
                            text: "uaeLinkSubHeading1.1".tr,
                            style: AppTextStyle.lightBrown14spTextStyle2
                                .copyWith(fontFamily: 'Roboto')),
                        TextSpan(
                            text: ".".tr,
                            style: AppTextStyle.newGreyColor14spTextStyle
                                .copyWith(fontFamily: 'Roboto')),
                      ]),
                ),
              ),
            ],
          );
  }

  Row _buildChoiceBtn() {
    return Row(
            children: [
              Expanded(
                  child: elevatedButton(
                text: "no",
                txtColor: AppColors.primaryDarkBlackColor,
                backgroundColor: AppColors.lightGreyColor,
                onPressed: () {
                  Get.find<LogInViewModel>().saveUaeUser();
                },
              )),
              16.horizontalSpace,
              Expanded(
                  child: elevatedButton(
                text: "yes",
                onPressed: () {
                  Get.toNamed(AppRoutes.uaeLoginScreen);
                },
              )),
            ],
          );
  }

  RichText _buildSubHeading() {
    return RichText(
            text: TextSpan(
                text: 'haveAccount'.tr,
                style: AppTextStyle.secondaryPrimaryBlack26spTextStyle
                    .copyWith(fontFamily: 'Alexandria'),
                children: <TextSpan>[
                  TextSpan(
                      text: "uaeLinkHeading2".tr,
                      style: AppTextStyle.lightBrown24spTextStyle
                          .copyWith(fontFamily: 'Alexandria')),
                  TextSpan(
                      text: "questionMark".tr,
                      style: AppTextStyle.secondaryPrimaryBlack26spTextStyle
                          .copyWith(fontFamily: 'Alexandria'))
                ]),
          );
  }

  RichText _buildHeading() {
    return RichText(
            text: TextSpan(
                text: 'uaeLinkHeading1'.tr,
                style: AppTextStyle.darkerGrey24spTextStyle
                    .copyWith(fontFamily: 'Alexandria'),
                children: <TextSpan>[
                  TextSpan(
                      text: "uaeLinkHeading2".tr,
                      style: AppTextStyle.lightBrown24spTextStyle
                          .copyWith(fontFamily: 'Alexandria')),
                  TextSpan(
                      text: "uaeLinkHeading3".tr,
                      style: AppTextStyle.darkerGrey24spTextStyle
                          .copyWith(fontFamily: 'Alexandria'))
                ]),
          );
  }
}
