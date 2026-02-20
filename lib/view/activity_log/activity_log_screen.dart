import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/audit_logs.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/activity_log_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class ActivityLogScreen extends GetView<ActivityLogViewModel> {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "activityLog"),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return Obx(()=>ListView.separated(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemBuilder: (_, int index) {
        AuditLogs log = controller.activityLogs[index];
        return _buildItem(log);
      },
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemCount: controller.activityLogs.length,
    ));
  }

  Column _buildItem(AuditLogs log) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
        Utils.isArabic?log.commentsAr:log.comments,
          style: AppTextStyle.secondaryBlack12spTextStyle1,
        ),
        8.verticalSpace,
        Text(controller.dateFormatAMPM.format(log.createdDate),
            style: AppTextStyle.grey12spTextStyle)
      ]);
  }
}
