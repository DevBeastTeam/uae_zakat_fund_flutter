import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/individual_view_model.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/profile_text_widget.dart';
import 'package:zakat_fund/widgets/tabbar_widget_v2.dart';

class IndividualProfileScreen extends GetView<AccountViewModel> {
  const IndividualProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.currentTabIndex.value = 0;
    controller.tabController.animateTo(0);
    final viewModel = Get.find<IndividualViewModel>();
    return Column(
      children: [
        16.verticalSpace,
        _buildHeaderCard(),
        16.verticalSpace,
        _buildTabBar(),
        16.verticalSpace,
        Expanded(child: _buildContentCard(viewModel)),
      ],
    );
  }

  // ── Header card: avatar + name + email ──────────────────────────────────
  Widget _buildHeaderCard() {
    return Obx(() {
      final info = controller.individual.value.accountInfo;
      final firstName = Utils.isArabic
          ? (info?.firstNameArabic ?? '')
          : (info?.firstName ?? '');
      final lastName = Utils.isArabic
          ? (info?.lastNameArabic ?? '')
          : (info?.lastName ?? '');
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: [
            circleImage(
              controller.profilePhoto.value,
              profile: true,
              onPressed: () => controller.addImage(),
              // showAdd: info?.userId == controller.user.id,
              showAdd: false,
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName'.trim(),
                    style: AppTextStyle.secondaryPrimaryBlack16spTextStyle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    info?.email ?? '',
                    style: AppTextStyle.darkGreyOne12spTextStyle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── TabBarWidgetV2 ────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Obx(() => TabBarWidgetV2(
          tabs: controller.tabs,
          currentIndex: controller.currentTabIndex.value,
          onTabChanged: (index) {
            controller.tabController.animateTo(index);
            controller.currentTabIndex.value = index;
          },
        ));
  }

  // ── Scrollable content card ───────────────────────────────────────────────
  Widget _buildContentCard(IndividualViewModel viewModel) {
    return Obx(() {
      final isOwner =
          controller.individual.value.accountInfo?.userId == controller.user.id;
      return Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: controller.currentTabIndex.value == 0
                      ? _buildAccountInfoContent(viewModel)
                      : _buildContactInfoContent(viewModel),
                ),
              ),
            ),
          ),
          if (isOwner) ...[
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: elevatedButton(
                text: 'editInformation',
                onPressed: () => controller
                    .updateIndTabIndexForEdit(controller.currentTabIndex.value),
              ),
            ),
          ],
          16.verticalSpace,
        ],
      );
    });
  }

  // ── Account info tab content ──────────────────────────────────────────────
  Widget _buildAccountInfoContent(IndividualViewModel viewModel) {
    final accountInfo = controller.individual.value.accountInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        profileTextWidget(label: 'email', value: accountInfo?.email ?? ''),
        profileTextWidget(
            label: 'userName', value: accountInfo?.userName ?? ''),
        profileTextWidget(
            label: 'firstNameInEnglish', value: accountInfo?.firstName ?? ''),
        profileTextWidget(
            label: 'lastNameInEnglish', value: accountInfo?.lastName ?? ''),
        profileTextWidget(
            label: 'firstNameInArabic',
            value: accountInfo?.firstNameArabic ?? ''),
        profileTextWidget(
            label: 'lastNameInArabic',
            value: accountInfo?.lastNameArabic ?? ''),
        profileTextWidget(
            label: 'dob',
            value: accountInfo?.dob != null
                ? Utils.dateFormat1.format(accountInfo!.dob!)
                : ''),
        profileTextWidget(
            label: 'gender',
            value: accountInfo?.gender == null
                ? ''
                : accountInfo?.gender == 1
                    ? 'male'.tr
                    : 'female'.tr),
        profileTextWidget(label: 'uaeId', value: accountInfo?.emirateId ?? ''),
        profileTextWidget(
            label: 'nationality', value: controller.nationality.value),
        Obx(() => viewModel.additionalDocuments.isNotEmpty
            ? profileAdditionDocWidget(viewModel.additionalDocuments)
            : const SizedBox.shrink()),
      ],
    );
  }

  // ── Contact info tab content ──────────────────────────────────────────────
  Widget _buildContactInfoContent(IndividualViewModel viewModel) {
    final contactInfo = controller.individual.value.contactInfo;
    final countryData = viewModel.selectedCountry.value;
    final emirateData = viewModel.selectedEmirate.value;
    final cityData = viewModel.selectedCity.value;
    final country = countryData != null
        ? (Utils.isArabic ? countryData.nameAr : countryData.name)
        : '';
    final emirate = emirateData != null
        ? (Utils.isArabic ? emirateData.nameAr : emirateData.name)
        : '';
    final city = cityData != null
        ? (Utils.isArabic ? cityData.nameAr : cityData.name)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        profileTextWidget(
            label: 'mobileNumberPrimary', value: contactInfo?.mobile ?? ''),
        profileTextWidget(
            label: 'mobileNumberSecondary',
            value: contactInfo?.additionalMobileNumber ?? ''),
        profileTextWidget(label: 'country', value: country),
        if (emirateData != null)
          profileTextWidget(label: 'emirate', value: emirate),
        profileTextWidget(label: 'city', value: city),
        profileTextWidget(label: 'poBox', value: contactInfo?.poBox ?? ''),
        Text('address'.tr, style: AppTextStyle.primaryDarkGrey14spTextStyle1),
        8.verticalSpace,
        _buildAddresses(contactInfo),
      ],
    );
  }

  Widget _buildAddresses(DonorContactInfo? contactInfo) {
    if (contactInfo == null || contactInfo.addresses.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: List.generate(contactInfo.addresses.length, (i) {
        final addr = contactInfo.addresses[i];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: const Offset(0, 4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${i == 0 ? "address1".tr : "address2".tr} ${addr.isDefault ? "primary".tr : ""}',
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
              ),
              8.verticalSpace,
              Text(addr.street,
                  maxLines: 1,
                  style: AppTextStyle.secondaryPrimaryBlack14spTextStyle),
              Text(addr.building,
                  maxLines: 1,
                  style: AppTextStyle.secondaryPrimaryBlack14spTextStyle),
              Text(addr.landmark,
                  maxLines: 1,
                  style: AppTextStyle.secondaryPrimaryBlack14spTextStyle),
            ],
          ),
        );
      }),
    );
  }
}
