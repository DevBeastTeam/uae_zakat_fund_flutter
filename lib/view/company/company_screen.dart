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
import 'package:zakat_fund/view/bottom_bar/account/company/company_profile_screen.dart';
import 'package:zakat_fund/view/company/bank_account_screen.dart';
import 'package:zakat_fund/view/company/company_info_screen.dart';
import 'package:zakat_fund/view/company/company_representative_screen.dart';
import 'package:zakat_fund/view/company/contact_info_screen.dart';
import 'package:zakat_fund/view_model/company_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/please_note_container.dart';
import 'package:zakat_fund/widgets/request_submitted.dart';

class CompanyScreen extends GetView<CompanyViewModel> {
  const CompanyScreen({super.key});

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
        ? const CompanyProfileScreen()
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
                if (controller.user.status == 0) _buildNote(),
                _buildStepper(),
                16.verticalSpace,
                _buildTabView(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNote() =>
      pleaseNoteContainer(title: "pleaseNote", message: "pleaseNoteDetails");

  Widget _buildTabView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() {
        final index = controller.currentSubTab.value;
        switch (index) {
          case 0:
            return const CompanyInfoScreen();
          case 1:
            return ContactInfoScreen(controller, isAssociation: false);
          case 2:
            return CompanyRepresentativeScreen(controller);
          case 3:
            return BankAccountScreen(controller);
          default:
            return const SizedBox();
        }
      }),
    );
  }

  Obx _buildStepper() {
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
              AppConstant.companyTabs[controller.currentSubTab.value].tr,
              style: AppTextStyle.primaryDarkBrown16spTextStyle1,
            ),
          ],
        ));
  }
}
