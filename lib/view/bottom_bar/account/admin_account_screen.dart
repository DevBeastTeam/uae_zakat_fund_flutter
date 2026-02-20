import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/module_codes.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/widgets/account_list_tile.dart';
import 'package:zakat_fund/widgets/footer.dart';

class AdminAccountScreen extends GetView<AccountViewModel> {
  const AdminAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAccountTabs(),
            8.verticalSpace,
            Divider(height: 1.h, color: AppColors.lightGrey),
            buildFooter(),
            130.verticalSpace,
          ],
        ),
      ),
    );
  }

  Obx _buildAccountTabs() {
    return Obx(() => Column(
          children: List.generate(
            controller.adminTabs.length,
            (index) {
              final tab = controller.adminTabs[index];
              return Column(
                children: [
                  accountMenuWidget(
                    tab: tab,
                    onTap: () =>
                        controller.handleAdminNavigation(tab.code, index),
                  ),
                  if (tab.isOpen) _buildSubMenuSection(tab.code, index),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildSubMenuSection(String code, int index) {
    List<Categories> subTabs = [];
    switch (code) {
      case ModuleCodes.adminDashboardCode:
        subTabs = controller.dashboardSubTabs;
        break;
      case ModuleCodes.adminPageManagementCode:
        subTabs = controller.pageManagementSubTabs;
        break;
      case ModuleCodes.adminDocumentManagementCode:
        subTabs = controller.documentSubTabs;
        break;
      case ModuleCodes.adminSystemConfigurationCode:
        subTabs = controller.systemConfigSubTabs;
        break;
      case ModuleCodes.adminFinancialManagementCode:
        subTabs = controller.financialManagementSubTabs;
        break;
      case ModuleCodes.adminMassCampaignManagementCode:
        subTabs = controller.campaignSubTabs;
        break;
      case ModuleCodes.adminWorkflowManagementCode:
        subTabs = controller.workflowSubTabs;
        break;
    }

    return Column(
      children: subTabs.map((tab) {
        return accountMenuWidget(
          tab: tab,
          subTab: true,
          onTap: () => controller.handleAdminNavigation(tab.code),
        );
      }).toList(),
    );
  }
}
