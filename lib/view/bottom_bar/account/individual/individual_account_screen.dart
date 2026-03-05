import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/widgets/account_info.dart';
import 'package:zakat_fund/widgets/account_list_tile.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class IndividualAccountScreen extends GetView<AccountViewModel> {
  const IndividualAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      children: [
        _buildProfileCard(),
        16.verticalSpace,
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: _buildMenusList(),
        ),
        110.verticalSpace,
      ],
    );
  }

  Column _buildMenusList() {
    return Column(
      children: List.generate(
          AppConstant.individualAccountTabs.length,
          (index) => accountMenuWidget(
              tab: AppConstant.individualAccountTabs[index],
              onTap: () => controller.donorMenusNavigation(index))).toList(),
    );
  }

  // Obx _buildImageView() {
  //   return Obx(() => circleImage(controller.profilePhoto.value,
  //       profile: true,
  //       onPressed: () => controller.addImage(),
  //       width: 55.0,
  //       height: 55.0,
  //       showAdd: true));
  // }

  Widget _buildProfileCard() {
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
                // _buildImageView(),
                Obx(() => circleImage(controller.profilePhoto.value,
                    profile: true,
                    onPressed: () => controller.addImage(),
                    width: 55.0,
                    height: 55.0,
                    showAdd: true)),
                12.horizontalSpace,
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Utils.isArabic ? controller.individual.value.accountInfo?.firstNameArabic ?? "" : controller.individual.value.accountInfo?.firstName ?? ""} ${Utils.isArabic ? controller.individual.value.accountInfo?.lastNameArabic ?? "" : controller.individual.value.accountInfo?.lastName ?? ""}",
                          style:
                              AppTextStyle.secondaryPrimaryBlack16spTextStyle2,
                        ),
                        Text(
                          "${controller.individual.value.accountInfo?.email ?? ""}",
                          style: AppTextStyle.darkGreyOne12spTextStyle2,
                        ),
                      ],
                    )),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  flex: Utils.isArabic ? 3 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAccountTitle("mobile".tr),
                      4.verticalSpace,
                      buildAccountTitle("gender".tr),
                      4.verticalSpace,
                      buildAccountTitle("nationality".tr),
                      4.verticalSpace,
                      buildAccountTitle("emirateId".tr),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Directionality(
                              textDirection: TextDirection.ltr,
                              child: buildAccountValue(
                                  "${controller.individual.value.contactInfo?.mobile ?? ""}")),
                          4.verticalSpace,
                          buildAccountValue(Utils.genderIntToString(
                              controller.individual.value.accountInfo?.gender)),
                          4.verticalSpace,
                          buildAccountValue(controller.nationality.value),
                          4.verticalSpace,
                          buildAccountValue(
                              "${controller.individual.value.accountInfo?.emirateId ?? ""}"),
                        ],
                      )),
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                    child: elevatedButton(
                  text: "edit",
                  onPressed: () => controller.openDonorProfileScreen(false),
                )),
                10.horizontalSpace,
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.openDonorProfileScreen(true),
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
}
