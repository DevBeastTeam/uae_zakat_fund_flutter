import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/splash_view_model.dart';
import 'package:zakat_fund/widgets/language_btn.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class LanguageScreen extends GetView<SplashViewModel> {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "languages"),
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          20.verticalSpace,
          Obx(() => Row(
                children: [
                  buildButton(controller.selectedLanguage.value, true, 1,
                      onPressed: () => controller.selectLanguage(true, 1)),
                  16.horizontalSpace,
                  buildButton(controller.selectedLanguage.value, false, 2,
                      onPressed: () => controller.selectLanguage(false, 2)),
                ],
              )),
        ],
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "selectLanguage".tr,
          style: AppTextStyle.secondaryBlack16spTextStyle1,
        ),
        6.verticalSpace,
        Text(
          "languageSelectionMessage".tr,
          style: AppTextStyle.lightBlack14spTextStyle,
        ),
      ],
    );
  }
}
