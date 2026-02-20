import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/platform_documents.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/platform_doc_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';

class PlatformDocumentsScreen extends GetView<PlatformDocViewModel> {
  const PlatformDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "platformDocuments"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          if (controller.canAdd) ...[
            _buildAddCodumentBtn(),
            10.verticalSpace,
          ],
          _buildExportFilterRow(),
          if (controller.canExport || controller.canView) 10.verticalSpace,
          if (controller.canView) ...[
            _buildSearchField(),
            16.verticalSpace,
            _buildListView()
          ]
        ],
      ),
    );
  }

  Obx _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.platformDocuments.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) =>
              documentsItem(controller.platformDocuments[index]),
        ));
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) => controller.filterDocumentsById(),
    );
  }

  Widget _buildAddCodumentBtn() {
    return addElevatedButton(
      onPressed: () {
        controller.addDocument();
      },
      text: "addNewDocument",
      icon: AppResources.uploadDocumentIcon,
    );
  }

  Container documentsItem(PlatformDocuments document) {
    List<DashboardData> projectDetails = [
      DashboardData(title: "id", value: document.id.toString()),
      DashboardData(
          title: "name",
          value:
              Utils.isArabic ? document.documentNameAr : document.documentName),
      DashboardData(title: "type", value: document.allowedFileTypes),
      DashboardData(
          title: "associatedForm",
          value:
              Utils.entityTypesIntoString(document.documentAssociatedWith).tr),
      DashboardData(
          title: "required", value: document.isRequired ? "yes".tr : "no".tr),
      DashboardData(
          title: "requiresDates",
          value: document.requiresDate
              ? "${Utils.isArabic ? document.startDateAr : document.startDate}${Utils.isArabic ? document.endDateAr : document.endDate}"
              : "no".tr),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.canEdit || controller.canDelete) ...[
            Align(
              alignment:
                  Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: popupMenuButton(
                    onSelected: (value) =>
                        controller.onMenuSelected(value, document),
                    menuItems: [
                      if (controller.canEdit)
                        popupMenuItem(
                            label: "edit",
                            icon: AppResources.editIcon1,
                            textStyle: AppTextStyle
                                .secondaryPrimaryBlack14spTextStyle),
                      if (controller.canDelete)
                        popupMenuItem(
                            label: "delete",
                            icon: AppResources.removeIcon,
                            textStyle: AppTextStyle.red14spTextStyle1),
                    ]),
              ),
            ),
            10.verticalSpace,
            const Divider(height: 0, color: AppColors.lightGrey)
          ],
          10.verticalSpace,
          Column(
            children: projectDetails
                .map((data) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          16.horizontalSpace,
                          Flexible(
                            child: Text(data.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle
                                    .secondaryPrimaryBlack12spTextStyle1),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          _buildSwitchBtn(document)
        ],
      ),
    );
  }

  Padding _buildSwitchBtn(PlatformDocuments document) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("enableDisable".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          CupertinoSwitchWidget(
            value: document.isActive,
            onChanged: controller.canEdit
                ? (_) => controller.updateStatus(document)
                : null,
          ),
        ],
      ),
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
              onPressed: () => controller.exportDocuments(),
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
}
