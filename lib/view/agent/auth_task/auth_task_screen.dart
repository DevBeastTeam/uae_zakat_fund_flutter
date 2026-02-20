import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/authenticate_task_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/cash_receipt.dart';
import 'package:zakat_fund/widgets/collection_receipt_dialog.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AuthTaskScreen extends GetView<AuthenticateTaskViewModel> {
  const AuthTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "authenticateRequest"),
      bottomNavigationBar: _buildBottomAction(),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskDetails(),
              16.verticalSpace,
              __buildHeading(),
              8.verticalSpace,
              _buildImagesListView(),
              16.verticalSpace,
              _buildCashNotesDetails(),
            ],
          )),
    );
  }

  Obx _buildCashNotesDetails() {
    return Obx(() => controller.cashNotes.isNotEmpty
        ? buildCashNotesContainer(
            cashNotes: controller.cashNotes,
            totalAmount: controller.taskCollectionDetails.totalAmount.toInt())
        : SizedBox.shrink());
  }

  Obx _buildImagesListView() {
    return Obx(() => controller.imagesList.isNotEmpty
        ? SizedBox(
            height: 158.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.photoViewScreen, arguments: controller.imagesList[index]),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedImage(
                      image: controller.imagesList[index],
                      width: 187.w,
                      height: 158.h,
                    )),
              ),
              itemCount: controller.imagesList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  16.horizontalSpace,
            ),
          )
        : SizedBox.shrink());
  }

  Text __buildHeading() {
    return Text(
      controller.getHeading().tr,
      style: AppTextStyle.darkGrey12spTextStyle1,
    );
  }

  Container _buildTaskDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: cashReceipt(controller.cashData),
    );
  }

  Padding _buildBottomAction() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: elevatedButton(
          text: "yesIAuthenticate",
          onPressed: () => controller.authenticateRequest()),
    );
  }
}
