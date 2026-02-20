import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/settings_view_model.dart';
import 'package:zakat_fund/widgets/account_list_tile.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class SettingsScreen extends GetView<SettingsViewModel> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "settings"),
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      children: [
        if (userBox.isNotEmpty) _buildUserInfo(),
        Divider(height: 1.h, color: AppColors.lightGrey),
        8.verticalSpace,
        Column(
          children: List.generate(
                  controller.settingTabs.length,
                  (index) => accountMenuWidget(
                      tab: controller.settingTabs[index],
                      onTap: () => controller.navigateToScreen(controller.settingTabs[index].code)))
              .toList(),
        ),
        8.verticalSpace,
        Divider(height: 1.h, color: AppColors.lightGrey),
      ],
    );
  }


  Widget _buildUserInfo() {
    final hasLogo = controller.logo.isNotEmpty;
    final hasName = controller.name.value.isNotEmpty;

    return Column(
      children: [
        if (hasLogo) ...[
          16.verticalSpace,
          circleImage(
            controller.logo,
            onPressed: () {},
            profile: controller.individual != null,
          ),
        ],
        if (hasName)
          Obx(() => Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              controller.name.value,
              textAlign: TextAlign.center,
              style: AppTextStyle.primaryDarkBrown24spTextStyle,
            ),
          )),
      ],
    );
  }

}
