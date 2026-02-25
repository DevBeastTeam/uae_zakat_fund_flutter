import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/association/association_info_screen.dart';
import 'package:zakat_fund/view/bottom_bar/account/association/association_profile_screen.dart';
import 'package:zakat_fund/view/company/bank_account_screen.dart';
import 'package:zakat_fund/view/company/company_representative_screen.dart';
import 'package:zakat_fund/view/company/contact_info_screen.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/please_note_container.dart';
import 'package:zakat_fund/widgets/request_submitted.dart';
import 'package:zakat_fund/widgets/welcome_note_container.dart';

class AssociationScreen extends GetView<AssociationViewModel> {
  const AssociationScreen({super.key});

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
        ? const AssociationProfileScreen()
        : _buildAccountInfo());
  }

  Widget _buildAccountInfo() {
    return Obx(() {
      if (controller.isRequestSubmitted.value) {
        return buildRequestSubmitted();
      }

      return KeyboardDismissOnTap(
        child: KeyboardActions(
          autoScroll: false,
          config: Utils.buildConfig(Get.context!, controller.keyboardActionsItem),
          child: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              children: [
                _buildWelcomeMessage(),
                if (controller.user.status != 1) _buildNoteContainer(),
                _buildStepperView(),
                16.verticalSpace,
                _buildTabView(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() {
        switch (controller.currentSubTab.value) {
          case 0:
            return const AssociationInfoScreen();
          case 1:
            return ContactInfoScreen(controller, isAssociation: true);
          case 2:
            return CompanyRepresentativeScreen(controller);
          case 3:
            return BankAccountScreen(controller);
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  Obx _buildStepperView() {
    return Obx(() => Column(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              margin: EdgeInsets.only(top: 16.h),
              decoration: BoxDecoration(
                color: themeViewModel.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightBtnBackgroundColor,
                  width: 6.w,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "${controller.currentSubTab.value + 1}",
                style: AppTextStyle.primaryDarkBrown16spTextStyle1,
              ),
            ),
            4.verticalSpace,
            Text(
              AppConstant.associationTabs[controller.currentSubTab.value].tr,
              style: AppTextStyle.primaryDarkBrown16spTextStyle1,
            ),
          ],
        ));
  }

  Widget _buildNoteContainer() =>
      pleaseNoteContainer(title: "pleaseNote", message: "pleaseNoteDetails");

  Obx _buildWelcomeMessage() {
    return Obx(() => controller.showWelcome.value
        ? welcomeNoteContainer()
        : const SizedBox.shrink());
  }
}
