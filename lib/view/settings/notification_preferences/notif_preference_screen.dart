import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/notification_preference.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/notif_pref_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class NotificationPreferenceScreen extends GetView<NotificationPreferenceViewModel> {
  const NotificationPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "notificationsPreferences"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() => Column(
          children: List.generate(controller.preferences.length, (index) {
            NotificationPreference preference = controller.preferences[index];
            return SwitchListTile.adaptive(
              title: Text(
                preference.title.tr,
                style: AppTextStyle.secondaryBlack16spTextStyle1,
              ),
              activeTrackColor: Color(0xff35C759),
              thumbColor: WidgetStatePropertyAll(Colors.white),
              inactiveTrackColor: Color(0xffE9E9EA),
              trackOutlineColor: WidgetStatePropertyAll(Colors.white),
              subtitle: Text(
                preference.subTitle.tr,
                style: AppTextStyle.lightBlack13spTextStyle1,
              ),
              value: preference.enable,
              isThreeLine: true,
              onChanged: (val) => controller.savePreferences(index, val),
            );
          }).toList(),
        ));
  }
}
