import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/module_codes.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/widgets/account_list_tile.dart';
import 'package:zakat_fund/widgets/profile_view_widget.dart';

class AssociationAccountScreen extends GetView<AccountViewModel> {
  const AssociationAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderImage(),
          10.verticalSpace,
          _buildAccountTabs(),
          130.verticalSpace,
        ],
      ),
    );
  }

  Obx _buildHeaderImage() {
    return Obx(() => associationHeader(
        controller, controller.showEdit.value, controller.showView.value,
        showLess: true));
  }

  Widget _buildAccountTabs() {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Column(
            children: List.generate(controller.associationTabs.length, (index) {
              final tab = controller.associationTabs[index];

              return Column(
                children: [
                  accountMenuWidget(
                    tab: tab,
                    onTap: () =>
                        controller.handleAssociationNavigation(tab.code, index),
                  ),
                  if (tab.isOpen &&
                      tab.code == ModuleCodes.associationMyContentCode)
                    _buildSubTabs(controller.myContentSubTabs),
                  if (tab.isOpen &&
                      tab.code == ModuleCodes.associationMyFundingCode)
                    _buildSubTabs(controller.myFundingSubTabs),
                ],
              );
            }),
          ),
        ));
  }

  Widget _buildSubTabs(List<Categories> subTabs) {
    return Column(
      children: List.generate(subTabs.length, (index) {
        final subTab = subTabs[index];
        return accountMenuWidget(
          tab: subTab,
          subTab: true,
          onTap: () => controller.handleAssociationNavigation(subTab.code),
        );
      }),
    );
  }
}
