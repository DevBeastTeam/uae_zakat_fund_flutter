import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/bottom_bar/account/individual/individual_profile_screen.dart';
import 'package:zakat_fund/view/donor/individual/account_info_screen.dart';
import 'package:zakat_fund/view/donor/individual/contact_info_screen.dart';
import 'package:zakat_fund/view_model/individual_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/please_note_container.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class IndividualScreen extends GetView<IndividualViewModel> {
  const IndividualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "accountInformation"),
      body: _buildBody(),
    );
  }

  Obx _buildBody() {
    return Obx(() => controller.isEdit.value
        ? const IndividualProfileScreen()
        : buildAccountInfo());
  }

  Widget buildAccountInfo() {
    return Column(
      children: [
        Obx(() => controller.accountStatus.value != 1
            ? pleaseNoteContainer(
                title: "pleaseNote", message: "pleaseNoteDetails")
            : 8.verticalSpace),
        Obx(() => tabBarWidget(
              controller.subTabController,
              AppConstant.individualTabs,
              controller.currentSubTabIndex.value,
            )),
        Flexible(
          child: KeyboardDismissOnTap(
            child: KeyboardActions(
              autoScroll: false,
              config: Utils.buildConfig(
                  Get.context!, controller.keyboardActionsItem),
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Obx(() => controller.currentSubTabIndex.value == 0
                    ? const AccountInfoScreen()
                    : const ContactInfoScreen()),
              ),
            ),
          ),
        )
      ],
    );
  }
}
