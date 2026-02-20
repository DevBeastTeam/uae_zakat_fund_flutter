import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/management_staff.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/management_staff_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';

class ManagementStaffScreen extends GetView<ManagementStaffViewModel> {
  const ManagementStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildAddEmpBtn(),
          if (controller.canAdd) 16.verticalSpace,
          _buildExportFilterRow(),
          if (controller.canView) ...[
            10.verticalSpace,
            _buildSearchField(),
            10.verticalSpace,
            _buildListView(),
          ]
        ],
      ),
    );
  }

  Obx _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.employees.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => controller.user.isAdmin
              ? sahemUserItem(controller.employees[index], index)
              : employeeItem(controller.employees[index], index),
        ));
  }

  Widget _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.pageSize = 10;
          controller.fetchEmployees(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.pageSize = 10;
        controller.fetchEmployees(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.pageSize = 10;
          controller.fetchEmployees(clear: true);
        }
      },
    );
  }

  Widget _buildExportFilterRow() {
    if (!controller.canView && !controller.canExport) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (controller.canExport)
          Expanded(
            child: expandedChip(
              label: 'export',
              icon: AppResources.exportIcon,
              onPressed: () => controller.exportEmployees(),
            ),
          ),
        if (controller.canExport && controller.canView) 16.horizontalSpace,
        if (controller.canView)
          Expanded(
            child: expandedChip(
              label: 'filter',
              icon: AppResources.filterIcon,
              onPressed: () => controller.filterBottomSheet(),
            ),
          ),
      ],
    );
  }

  Widget _buildAddEmpBtn() {
    if (!controller.canAdd) {
      return SizedBox.shrink();
    }
    return addElevatedButton(
        onPressed: () => controller.openAddEmp(null), text: "addEmployee");
  }

  Container sahemUserItem(ManagementStaff emp, int index) {
    String status = Utils.employeeStatusIntoString(emp.status);
    String jobTitle = "";
    LookupData? lookupData = controller.jobList
        .firstWhereOrNull((cat) => cat.value.toString() == emp.jobDescription);
    jobTitle = Utils.isArabic ? lookupData?.nameAr : lookupData?.name;
    List<DashboardData> userDetails = [
      DashboardData(title: "id", value: emp.id.toString()),
      DashboardData(
          title: "name",
          value: Utils.isArabic
              ? "${emp.firstNameArabic} ${emp.lastNameArabic}"
              : "${emp.firstName} ${emp.lastName}"),
      DashboardData(title: "email", value: emp.email),
      DashboardData(title: "jobTitle", value: jobTitle),
      DashboardData(
          title: "createdDate",
          value: Utils.dateFormat1.format(emp.createdDate!)),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListViewHeader(status, emp),
          10.verticalSpace,
          const Divider(
            height: 0,
            color: AppColors.lightGrey,
          ),
          10.verticalSpace,
          Column(
            children: userDetails
                .map((data) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          65.horizontalSpace,
                          Flexible(
                            child: Utils.isArabic && data.title == "email"
                                ? Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: valueTextWidget(data.value),
                                  )
                                : valueTextWidget(data.value),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("enableDisable".tr,
                    style: AppTextStyle.primaryDarkGrey12spTextStyle1),
                CupertinoSwitchWidget(
                  value: emp.isActive,
                  onChanged: controller.canEdit
                      ? (val) {
                          controller.disableEmployee(index);
                        }
                      : null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListViewHeader(String status, ManagementStaff emp) {
    return listViewHeaderPopUpMenu(
        status: status,
        onSelected: (val) => controller.onEmpMenuSelected(val, emp),
        menuItems: [
          popupMenuItem(
              label: "view",
              icon: AppResources.eyeIcon,
              textStyle: AppTextStyle.darkBrown14spTextStyle),
          if (controller.canEdit)
            popupMenuItem(
                label: "edit",
                icon: AppResources.editIcon1,
                textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle),
        ]);
  }

  Text valueTextWidget(String value) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
    );
  }

  Container employeeItem(ManagementStaff emp, int index) {
    String status = Utils.employeeStatusIntoString(emp.status);
    bool enable = controller.canEdit && emp.phoneNumberConfirmed ||
        controller.canEdit && emp.emailConfirmed;
    List<DashboardData> details = [
      DashboardData(title: "id", value: emp.id.toString()),
      DashboardData(
          title: "name",
          value: Utils.isArabic
              ? "${emp.firstNameArabic} ${emp.lastNameArabic}"
              : "${emp.firstName} ${emp.lastName}"),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListViewHeader(status, emp),
          10.verticalSpace,
          const Divider(height: 0, color: AppColors.lightGrey),
          10.verticalSpace,
          _buildTextDetails(details),
          _buidlVerifyEmail(emp),
          _buildVerifySMS(emp),
          _buildEmpSwitchBtn(emp, enable, index)
        ],
      ),
    );
  }

  Padding _buildEmpSwitchBtn(ManagementStaff emp, bool enable, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("enableDisable".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          CupertinoSwitchWidget(
            value: !emp.isDisabled,
            onChanged:
                enable ? (val) => controller.disableEmployee(index) : null,
          ),
        ],
      ),
    );
  }

  Padding _buildVerifySMS(ManagementStaff emp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("verifySMS".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          emp.phoneNumberConfirmed
              ? verifiedChip()
              : GestureDetector(
                  onTap: () => controller.verifyPhone(id: emp.id),
                  child: SvgPicture.asset(AppResources.emailIcon))
        ],
      ),
    );
  }

  Padding _buidlVerifyEmail(ManagementStaff emp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("verifyEmail".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          emp.emailConfirmed
              ? verifiedChip()
              : GestureDetector(
                  onTap: () => controller.verifyEmail(id: emp.id),
                  child: SvgPicture.asset(AppResources.emailIcon))
        ],
      ),
    );
  }

  Column _buildTextDetails(List<DashboardData> details) {
    return Column(
      children: details
          .map((data) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.title.tr,
                        style: AppTextStyle.primaryDarkGrey12spTextStyle1),
                    65.horizontalSpace,
                    Flexible(
                      child: valueTextWidget(data.value),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget verifiedChip() => Chip(
        label: Text(
          "verified".tr,
          style: AppTextStyle.green12spTextStyle1,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide.none,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        backgroundColor: AppColors.lightGreen,
      );

  Divider divider() {
    return Divider(height: 1.h, color: AppColors.secondaryLightGreyColor);
  }
}
