import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/notification_preference.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/password_security_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class PasswordSecurityScreen extends GetView<PasswordSecurityViewModel> {
  const PasswordSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "passwordSecurity"),
      body: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      children: [
        if (showChangePasswordBox.isNotEmpty)
          ListTile(
            title: Text(
              "changePassword".tr,
              style: AppTextStyle.secondaryBlack16spTextStyle1,
            ),
            onTap: () => Get.toNamed(AppRoutes.changePasswordScreen),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            trailing: Transform.flip(
                flipX: Utils.isArabic ? true : false,
                child: Image.asset(AppResources.arrowRight)),
          ),
        Obx(() => Column(
              children: List.generate(controller.options.length, (index) {
                NotificationPreference preference = controller.options[index];
                return SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  title: Text(
                    preference.title.tr,
                    style: AppTextStyle.secondaryBlack16spTextStyle1,
                  ),
                  activeColor: themeViewModel.color,
                  value: preference.enable,
                  onChanged: (val) => controller.enableDisable(val, preference),
                );
              }).toList(),
            )),
      ],
    );
  }
}
