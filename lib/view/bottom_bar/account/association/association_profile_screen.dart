import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/profile_text_widget.dart';
import 'package:zakat_fund/widgets/profile_view_widget.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class AssociationProfileScreen extends GetView<AccountViewModel> {
  const AssociationProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.currentTabIndex.value = 0;
    controller.tabController.animateTo(0);
    return SingleChildScrollView(
      child: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAssociationPic(),
        16.verticalSpace,
        _buildTabBar(),
        _buildTabView()
      ],
    );
  }

  Obx _buildTabView() {
    return Obx(() => controller.currentTabIndex.value == 0
        ? associationInfo()
        : controller.currentTabIndex.value == 1
            ? genericInfo(false, controller.associationStatus)
            : controller.currentTabIndex.value == 2
                ? representativeInfo(false, controller.associationStatus)
                : bankInfo(false, controller.associationStatus));
  }

  Obx _buildTabBar() {
    return Obx(() => tabBarWidget(controller.tabController, controller.tabs,
        controller.currentTabIndex.value));
  }

  Widget _buildAssociationPic() {
    return associationHeader(
      controller,
      // controller.associationStatus,
      false, false,
    );
  }

  Widget associationInfo() {
    final viewModel = Get.find<AssociationViewModel>();
    AssociationInfo? associationInfo =
        controller.association.value.associationInfo!;
    LookupData? associationTypeData = viewModel.selectedAssociationType.value;
    LookupData? authorityData = viewModel.selectedLicensingAuthority.value;
    String type = "", authority = "";
    if (associationTypeData != null) {
      type = Utils.isArabic
          ? associationTypeData.nameAr
          : associationTypeData.name;
    }
    if (authorityData != null) {
      authority = Utils.isArabic ? authorityData.nameAr : authorityData.name;
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileTextWidget(
              label: "associationNameInEnglish",
              value: associationInfo.accountName),
          profileTextWidget(
              label: "associationNameInArabic",
              value: associationInfo.accountNameArabic),
          profileTextWidget(
              label: "associationDescInEnglish",
              value: associationInfo.associationDescriptionEN!),
          profileTextWidget(
              label: "associationDescInArabic",
              value: associationInfo.associationDescriptionAR!),
          profileTextWidget(
              label: "dateOfEstablishment",
              value: associationInfo.establishmentDate != null
                  ? Utils.dateFormat1.format(controller
                      .association.value.associationInfo!.establishmentDate!)
                  : ""),
          profileTextWidget(label: "associationType", value: type),
          profileTextWidget(
              label: "licenseExpiryDate",
              value: associationInfo.licenseExpiryDate != null
                  ? Utils.dateFormat1.format(controller
                      .association.value.associationInfo!.licenseExpiryDate!)
                  : ""),
          profileTextWidget(label: "licensingAuthority", value: authority),
          profileAttachWidget(
              label: "associationLicense", value: associationInfo.license!),
          if (associationInfo.agreementUrl != null)
            profileAttachWidget(
                label: "Agreement",
                value: "agreements/${associationInfo.agreementUrl!}"),
          if (viewModel.additionalDocuments.isNotEmpty)
            profileAdditionDocWidget(viewModel.additionalDocuments),
          if (controller.association.value.associationInfo!.userId == controller.user.id)
            elevatedButton(
                text: "editInformation",
                onPressed: () => controller.updateAssTabIndexForEdit(0)),
        ],
      ),
    );
  }
}
