import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/my_refund.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/my_refunds_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/status_chip.dart';

class MyRefundsScreen extends GetView<MyRefundsViewModel> {
  const MyRefundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "myRefunds"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: searchAddContainer(
        child: _buildListView(),
        noContainer: true,
        controller: controller.searchController,
        onChanged: (val) {
          if (val.trim().isEmpty) {
            controller.fetchMyRefunds(clear: true);
          }
        },
        onClear: () {
          controller.searchController.clear();
          controller.fetchMyRefunds(clear: true);
        },
        onSubmitted: (val) {
          if (val.trim().isNotEmpty) {
            controller.fetchMyRefunds(clear: true);
          }
        },
        onFilterPressed: () => controller.filterBottomSheet(),
      ),
    );
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          itemCount: controller.myRefunds.length,
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            MyRefund refund = controller.myRefunds[index];
            return myRefundItem(refund);
          },
        ));
  }

  Widget myRefundItem(MyRefund refund) {
    String status = Utils.statusIntoString(refund.requestStatus);
    List<DashboardData> data = [
      DashboardData(title: "requestId", value: "${refund.id}"),
      DashboardData(
          title: "projectName",
          value:
              Utils.isArabic ? refund.projectNameArabic : refund.projectName),
      DashboardData(
          title: "requestDate",
          value: Utils.dateFormat1.format(refund.createdDate)),
      DashboardData(
          title: "refundAmount",
          value: "${"currency".tr} ${refund.refundAmount.toInt()}"),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: statusChip(status),
          ),
          10.verticalSpace,
          const Divider(height: 0, color: AppColors.lightGrey),
          10.verticalSpace,
          Column(
            children: List.generate(
                data.length,
                (dataIndex) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data[dataIndex].title.toString().tr,
                              style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                            ),
                            30.horizontalSpace,
                            Flexible(
                              child: Text(
                                data[dataIndex].value.toString(),
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
        ],
      ),
    );
  }
}
