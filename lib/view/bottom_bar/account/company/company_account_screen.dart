import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/widgets/account_info.dart';
import 'package:zakat_fund/widgets/account_list_tile.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class CompanyAccountScreen extends GetView<AccountViewModel> {
  const CompanyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          _buildImage(),
          8.verticalSpace,
          _buildCompanyName(),
          16.verticalSpace,
          _buildAboutSection(),
          16.verticalSpace,
          _buildAccountTabs(),
          130.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildAccountTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: List.generate(
                controller.companyTabs.length,
                (index) => accountMenuWidget(
                    tab: controller.companyTabs[index],
                    onTap: () => controller.handleCompanyNavigation(index)))
            .toList(),
      ),
    );
  }

  Widget _buildCompanyName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() {
        final name = Utils.isArabic
            ? controller.company.value.accountInfo?.accountNameArabic
            : controller.company.value.accountInfo?.accountName;
        return Text(
          name ?? "",
          textAlign: TextAlign.center,
          style: AppTextStyle.primaryDarkBrown24spTextStyle,
        );
      }),
    );
  }

  Obx _buildImage() =>
      Obx(() => circleImage(controller.profilePhoto.value, onPressed: () {}));

  Widget _buildAboutSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightWhiteColor,
        border: Border(
          bottom: BorderSide(width: 1.h, color: AppColors.lightGrey),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Expanded(
                flex: Utils.isArabic ? 3 : 2,
                child: _buildAboutLabels(),
              ),
              Expanded(
                flex: 4,
                child: _buildAboutValues(),
              ),
            ],
          ),
          16.verticalSpace,
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAboutLabels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAccountTitle("email"),
        4.verticalSpace,
        buildAccountTitle("mobile".tr),
        4.verticalSpace,
        buildAccountTitle("website".tr),
        4.verticalSpace,
        buildAccountTitle("country".tr),
        4.verticalSpace,
        buildAccountTitle("poBox".tr),
      ],
    );
  }

  Widget _buildAboutValues() {
    return Obx(() {
      final ContactInfo? contact = controller.company.value.accountContact;
      final String country = controller.country.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _valueWithLTR(contact?.email),
          4.verticalSpace,
          _valueWithLTR(contact?.mobile),
          4.verticalSpace,
          _valueWithLTR(contact?.website),
          4.verticalSpace,
          buildAccountValue(country),
          4.verticalSpace,
          buildAccountValue(contact?.poBox ?? ""),
        ],
      );
    });
  }

  Widget _valueWithLTR(String? value) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: buildAccountValue(value ?? ""),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      if (controller.showEdit.value || controller.showView.value) {
        return Row(
          children: [
            if (controller.showEdit.value)
              Expanded(
                child: elevatedButton(
                  text: "edit",
                  onPressed: () => controller.openCompanyProfileScreen(false),
                ),
              ),
            if (controller.showEdit.value && controller.showView.value)
              10.horizontalSpace,
            if (controller.showView.value)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.openCompanyProfileScreen(true),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(Get.width, 48.h),
                    side:
                        BorderSide(width: 2.w, color: AppColors.darkBrownColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    "view".tr,
                    style: AppTextStyle.darkBrown16spTextStyle,
                  ),
                ),
              ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
