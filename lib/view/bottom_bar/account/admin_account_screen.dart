import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/module_codes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/widgets/account_info.dart';
import 'package:zakat_fund/widgets/account_list_tile.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
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
            16.verticalSpace,
            _buildProfileCard(),
            16.verticalSpace,
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

  Widget _buildProfileCard() {
    final user = controller.user;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              children: [
                Obx(() => circleImage(
                    controller.profilePhoto.value ?? user.photo,
                    profile: true,
                    onPressed: () => controller.addImage(),
                    width: 55.0,
                    height: 55.0,
                    showAdd: true)),
                12.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${Utils.isArabic ? user.firstNameArabic ?? "" : user.firstName ?? ""} ${Utils.isArabic ? user.lastNameArabic ?? "" : user.lastName ?? ""}",
                      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle2,
                    ),
                    Text(
                      "${user.email ?? user.userName}",
                      style: AppTextStyle.darkGreyOne12spTextStyle2,
                    ),
                  ],
                ),
              ],
            ),
            16.verticalSpace,
            _buildInfoRow("mobile".tr, "${user.mobile ?? ""}"),
            4.verticalSpace,
            // _buildInfoRow("gender".tr, "${user.gender ?? ""}"),
            // 4.verticalSpace,
            // _buildInfoRow("nationality".tr, "${user.nationality ?? ""}"),
            // 4.verticalSpace,
            // _buildInfoRow("emirateId".tr, "${user.empId ?? ""}"),
            // 16.verticalSpace,
            Row(
              children: [
                Expanded(
                    child: elevatedButton(
                  text: "edit",
                  onPressed: () {},
                )),
                10.horizontalSpace,
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        fixedSize:
                            WidgetStatePropertyAll(Size(Get.width, 45.h)),
                        elevation: const WidgetStatePropertyAll(0),
                        side: WidgetStatePropertyAll(BorderSide(
                            width: 2.w, color: AppColors.darkBrownColor)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)))),
                    child: Text(
                      "view".tr,
                      style: AppTextStyle.darkBrown16spTextStyle,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: Utils.isArabic ? 3 : 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAccountTitle(label),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAccountValue(value),
            ],
          ),
        ),
      ],
    );
  }
}
