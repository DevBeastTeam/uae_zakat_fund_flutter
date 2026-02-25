import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/public_documents.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/user_doc_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';

class UserDocumentsScreen extends GetView<UserDocumentsViewModel> {
  const UserDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "userDocuments"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
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
          itemCount: controller.userDocuments.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) =>
              documentsItem(controller.userDocuments[index]),
        ));
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) => controller.filterDocumentsById(),
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

  Container documentsItem(PublicDocuments document) {
    String uploadedBy = "";
    if (Utils.isArabic) {
      if (document.userNameAr.trim().isEmpty) {
        uploadedBy = document.accountNameAr;
      } else {
        uploadedBy = document.userNameAr;
      }
    } else {
      if (document.userName.trim().isEmpty) {
        uploadedBy = document.accountName;
      } else {
        uploadedBy = document.userName;
      }
    }
    List<DashboardData> projectDetails = [
      DashboardData(
          title: "name",
          value:
              Utils.isArabic ? document.documentNameAr : document.documentName),
      DashboardData(title: "uploadedBy", value: uploadedBy),
      DashboardData(title: "entityId", value: document.id.toString()),
      DashboardData(
          title: "entityName",
          value:
              Utils.isArabic ? document.accountNameAr : document.accountName),
      DashboardData(
          title: "entityType",
          value:
              Utils.entityTypesIntoString(document.documentAssociatedWith).tr),
      DashboardData(
          title: "updatedDate",
          value: Utils.dateFormat1.format(document.uploadedDate)),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
            Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: popupMenuButton(
                  onSelected: (value) =>
                      controller.onMenuSelected(value,document.url),
                  menuItems: [
                    popupMenuItem(
                        label: "view",
                        icon: AppResources.eyeIcon,
                        textStyle: AppTextStyle.darkBrown14spTextStyle),
                    popupMenuItem(
                        label: "download",
                        icon: AppResources.downloadIcon,
                        textStyle: AppTextStyle.darkBrown14spTextStyle)
                  ]),
            ),
          ),
          10.verticalSpace,
          const Divider(
            height: 0,
            color: AppColors.lightGrey,
          ),
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
                          data.title == "url"
                              ? GestureDetector(
                                  onTap: () {
                                    Utils.openUrl(data.value);
                                  },
                                  child: Text(
                                    "downloadLink".tr,
                                    style: AppTextStyle.lightBlue12spTextStyle
                                        .copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.lightBlueColor,
                                    ),
                                  ),
                                )
                              : Flexible(
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
        ],
      ),
    );
  }
}
