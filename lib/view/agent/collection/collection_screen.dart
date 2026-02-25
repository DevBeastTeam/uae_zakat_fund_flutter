import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/collection_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/receipt_project_widgets.dart';
import 'package:zakat_fund/widgets/status_chip.dart';

class CollectionScreen extends GetView<CollectionViewModel> {
  const CollectionScreen({super.key});

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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "orderDetails".tr,
                    style: AppTextStyle.black16spTextStyle2,
                  ),
                  statusChip(
                      Utils.priorityIntoString(controller.request.priority))
                ],
              ),
              20.verticalSpace,
              Text(
                "requestingDetails".tr,
                style: AppTextStyle.black12spTextStyle,
              ),
              16.verticalSpace,
              _buildRequestingDetails(),
              16.verticalSpace,
              buildDivider(),
              16.verticalSpace,
              Text(
                "projectDetails".tr,
                style: AppTextStyle.black12spTextStyle,
              ),
              16.verticalSpace,
              buildProjectDetails(),
              16.verticalSpace,
              Text(
                "collectionDetails".tr,
                style: AppTextStyle.black12spTextStyle,
              ),
              16.verticalSpace,
              _buildCollectionDetails(),
              Text(
                "collectionPoint".tr,
                style: AppTextStyle.primaryDarkGrey12spTextStyle1,
              ),
              8.verticalSpace,
              if (controller.taskDetails.value != null)
                Text(
                  controller.taskDetails.value?.collectionPoint,
                  style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                ),
              20.verticalSpace,
              _buildBottomAction()
            ],
          )),
    );
  }

  Column _buildCollectionDetails() {
    return Column(
      children: List.generate(
          controller.collectionDetails.length,
          (index) => Column(
                children: [
                  buildRequestingDetails(
                      key: controller.collectionDetails[index]["key"],
                      value: controller.collectionDetails[index]["value"]),
                  8.verticalSpace,
                ],
              )),
    );
  }

  Column _buildRequestingDetails() {
    return Column(
      children: List.generate(
          controller.requestingDetails.length,
          (index) => Column(
                children: [
                  buildRequestingDetails(
                      key: controller.requestingDetails[index]["key"],
                      value: controller.requestingDetails[index]["value"]
                          .toString()),
                  if (index != controller.requestingDetails.length - 1)
                    8.verticalSpace,
                ],
              )),
    );
  }

  Obx _buildBottomAction() {
    return Obx(() => controller.showAcceptReject.value
        ? acceptRejectBottomBar(
            onAccept: () => controller.collectionDialog(),
            onReturn: null,
            onReject: () => controller.rejectionDialog(),
            btnText: controller.isCash ? "collectCash" : "collectCheque")
        : SizedBox.shrink());
  }

  Widget buildProjectDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "projectName".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1,
            ),
            Text(
              "amount".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1,
            ),
          ],
        ),
        10.verticalSpace,
        buildDivider(),
        if (controller.taskDetails.value != null)
          Column(
            children: List.generate(
                controller.taskDetails.value!.projects.length, (index) {
              Detail project = controller.taskDetails.value!.projects[index];
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: buildProjectLabels(
                        title: Utils.isArabic
                            ? project.projectNameArabic
                            : project.projectName,
                        value: '${"currency".tr} ${project.amount}'),
                  ),
                  if (index != 2) buildDivider(),
                ],
              );
            }),
          ),
        8.verticalSpace,
        Divider(
          color: AppColors.primaryDarkBlackColor,
          height: 0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: buildProjectLabels(
              title: "totalAmount",
              value:
                  '${"currency".tr} ${controller.taskDetails.value?.totalAmount ?? 0}'),
        ),
        Divider(
          color: AppColors.primaryDarkBlackColor,
          height: 0,
        ),
      ],
    );
  }

  Row buildRequestingDetails({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key.tr,
          style: AppTextStyle.primaryDarkGrey12spTextStyle1,
        ),
        60.horizontalSpace,
        Flexible(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              value,
              style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
            ),
          ),
        ),
      ],
    );
  }
}
