import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class RequestsScreen extends GetView<RequestsViewModel> {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: myAppBar(title: controller.isTasks ? "tasks" : "requests1"),
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!controller.isTasks) ...[
            Obx(() => buildStatsRow(0,controller.stats)),
            10.verticalSpace,
            Obx(() => buildStatsRow(3,controller.stats)),
            16.verticalSpace,
            _buildExportFilterRow(),
            10.verticalSpace,
            _buildSearchField(),
            10.verticalSpace,
          ],
          buildListView(),
        ],
      ),
    );
  }

  Widget _buildExportFilterRow() {
    return Row(
      children: [
        Expanded(
          child: expandedChip(
            label: 'export',
            icon: AppResources.exportIcon,
            onPressed: () => controller.exportRequests(),
          ),
        ),
        16.horizontalSpace,
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

  Widget _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.pageSize = 10;
          controller.fetchAllRequests(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.pageSize = 10;
        controller.fetchAllRequests(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.pageSize = 10;
          controller.fetchAllRequests(clear: true);
        }
      },
    );
  }

  Widget buildListView() {
    return Obx(() => ListView.separated(
          itemCount: controller.requests.length,
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            Requests request = controller.requests[index];
            return _buildListItem(request);
          },
        ));
  }

  Container _buildListItem(Requests request) {
    final status = controller.isTasks
        ? (request.isClosed
            ? "closed".tr
            : Utils.taskStatusIntoString(request.status))
        : Utils.statusIntoString(request.status);
    String priority = Utils.priorityIntoString(request.priority);
    List<DashboardData> details = [
      DashboardData(title: "requestId", value: request.id.toString()),
      DashboardData(
          title: "requestorName",
          value:
              Utils.isArabic ? request.requesterNameAr : request.requesterName),
      DashboardData(
          title: "requestDate",
          value: controller.dateFormat.format(request.createdDate)),
      DashboardData(
          title: "requestType",
          value: Utils.isArabic ? request.requestTypeAr : request.requestType),
      if (request.slaStatus != null)
        DashboardData(
            title: "slaStatus",
            value: Utils.slAStatusIntoString(request.slaStatus!).tr),
      if (request.currentLevel != null)
        DashboardData(
            title: "currentLevel",
            value: "${"level".tr} ${request.currentLevel}"),
      if (request.elapsedTime != "")
        DashboardData(title: "elapsedTime", value: request.elapsedTime),
      DashboardData(title: "status", value: status.tr),
      if (request.rejectReason != null &&
          request.rejectReason != "" &&
          request.status == 3)
        DashboardData(
            title: "rejectionReason", value: request.rejectReason.toString()),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListViewHeader(priority, request),
          10.verticalSpace,
          const Divider(
            height: 0,
            color: AppColors.lightGrey,
          ),
          10.verticalSpace,
          _buildDetails(details),
          _buildRejectNotes(request),
        ],
      ),
    );
  }

  Widget _buildListViewHeader(String priority, Requests request) {
    return listViewHeaderPopUpMenu(
          status: priority,
          onSelected: (item)=>controller.onPopUpMenuSelected(item,request),
          menuItems: controller.isTasks||controller.showView(request.requestType)?[
            popupMenuItem(
                label: "view",
                icon: AppResources.eyeIcon,
                textStyle: AppTextStyle.darkBrown14spTextStyle),
            if (request.status == 6 &&
                !controller.isTasks &&
                !controller.user.isAdmin)
              popupMenuItem(
                  label: "confirm",
                  icon: AppResources.tickMarkIcon,
                  textStyle: AppTextStyle.darkGreen14spTextStyle,
                  iconColor: AppColors.darkGreenColor),
          ]:[],
        );
  }

  Widget _buildRejectNotes(Requests request) {
    if ((request.status == 3 || request.status == 7) &&
        request.rejectNote != null) {
      final documents = request.rejectionDocument?.split(',') ?? [];
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("notes".tr,
                style: AppTextStyle.secondaryPrimaryBlack14spTextStyle2),
            2.verticalSpace,
            Text(request.rejectNote!,
                style: AppTextStyle.primaryDarkGrey12spTextStyle1),
            if (documents.isNotEmpty && documents.first.isNotEmpty) ...[
              8.verticalSpace,
              ...documents.map(
                (doc) => Column(
                  children: [
                    GestureDetector(
                      onTap: () =>controller.viewRejectionReturnFile(doc),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppResources.documentIcon),
                          8.horizontalSpace,
                          Flexible(
                            child: Text(
                              doc,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.greyDark12spTextStyle,
                            ),
                          ),
                          16.horizontalSpace,
                          SvgPicture.asset(AppResources.downloadIcon),
                        ],
                      ),
                    ),
                    4.verticalSpace,
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Padding _buildDetails(List<DashboardData> details) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: List.generate(
            details.length,
            (dataIndex) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          details[dataIndex].title.tr,
                          style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                        ),
                        16.horizontalSpace,
                        Utils.isArabic &&
                                details[dataIndex].title == "requestDate"
                            ? Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  details[dataIndex].value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle
                                      .secondaryPrimaryBlack12spTextStyle1,
                                ),
                              )
                            : Flexible(
                                child: Text(
                                  details[dataIndex].value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle
                                      .secondaryPrimaryBlack12spTextStyle1,
                                ),
                              ),
                      ],
                    ),
                    4.verticalSpace,
                  ],
                )).toList(),
      ),
    );
  }
}
