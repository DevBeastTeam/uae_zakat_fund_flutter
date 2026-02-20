import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/add_cash_view_model.dart';
import 'package:zakat_fund/widgets/cash_receipt.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AddCashScreen extends GetView<AddCashViewModel> {
  const AddCashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      bottomNavigationBar: _buildBottomActions(),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCashDetails(),
          if (controller.isCash) ...[16.verticalSpace, _buildCashNotesGrid()],
          16.verticalSpace,
          _buildUploadImageBtn(),
          16.verticalSpace,
          _buildImagesListView(),
          _buildSummaryContainer(),
        ],
      ),
    );
  }

  Obx _buildSummaryContainer() {
    return Obx(() => controller.cashNotes.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(top: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.grayColor),
            child: Column(children: [
              ..._buildCashNotesData(),
              _buildTotalAmountRow(),
            ]),
          )
        : SizedBox.shrink());
  }

  Row _buildTotalAmountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('total'.tr, style: AppTextStyle.secondaryBlack18spTextStyle2),
        Text('${controller.getTotalAmount()} ${"currency".tr}',
            style: AppTextStyle.secondaryBlack18spTextStyle2),
      ],
    );
  }

  List<Widget> _buildCashNotesData() {
    return List.generate(
        controller.cashNotes.length,
        (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                          '${controller.cashNotes[index].notes}x${controller.cashNotes[index].amount}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.secondaryBlack16spTextStyle2),
                    ),
                    2.horizontalSpace,
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                                '${controller.cashNotes[index].totalAmount} ${"currency".tr}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppTextStyle.secondaryBlack16spTextStyle2),
                          ),
                          8.horizontalSpace,
                          GestureDetector(
                            onTap: ()=>controller.deleteNotes(index),
                            child: Image.asset(
                              AppResources.deleteIcon,
                              width: 16.w,
                              height: 16.h,
                            ),
                          ),
                          8.horizontalSpace,
                          GestureDetector(
                            onTap: ()=>controller.editNotes(index),
                            child: Image.asset(
                              AppResources.editIcon,
                              width: 16.w,
                              height: 16.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                8.verticalSpace
              ],
            ));
  }

  Obx _buildImagesListView() {
    return Obx(() => controller.imagesList.isNotEmpty
        ? SizedBox(
            height: 160.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        controller.imagesList[index],
                        width: 200.w,
                        height: 160.h,
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () => controller.imagesList.removeAt(index),
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            color: AppColors.lightRedColor,
                            borderRadius: BorderRadius.circular(6.r)),
                        child: Image.asset(
                          AppResources.deleteIcon,
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              itemCount: controller.imagesList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  16.horizontalSpace,
            ),
          )
        : SizedBox.shrink());
  }

  OutlinedButton _buildUploadImageBtn() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
          side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h)),
      onPressed: () => controller.mediaDialog(),
      label: Text(
        "uploadImage".tr,
        maxLines: 1,
        style: AppTextStyle.primaryDarkBrown16spTextStyle1,
      ),
      icon: SvgPicture.asset(
        AppResources.uploadIcon,
        width: 24.w,
        height: 24.h,
      ),
    );
  }

  GridView _buildCashNotesGrid() {
    return GridView(
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 180.w / 50.h),
      children: controller.amountList
          .map((amount) => GestureDetector(
                onTap: () => controller.addCashNotesDialog(amount),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "$amount ${"currency".tr}",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.secondaryBlack12spTextStyle1,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Container _buildCashDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: cashReceipt(controller.cashData),
    );
  }

  Padding _buildBottomActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: elevatedButton(
          text: "sendForAuthentication",
          onPressed: () => controller.uploadPicture()),
    );
  }
}
