import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/company_view_model.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/profile_text_widget.dart';
import 'package:zakat_fund/widgets/profile_view_widget.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class CompanyProfileScreen extends GetView<AccountViewModel> {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.currentTabIndex.value = 0;
    controller.tabController.animateTo(0);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.verticalSpace,
          _buildImage(),
          16.verticalSpace,
          _buildTabBar(),
          _buildTabView()
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return Obx(() {
      final index = controller.currentTabIndex.value;
      switch (index) {
        case 0:
          return companyInfo();
        case 1:
          return genericInfo(true, controller.companyStatus);
        case 2:
          return representativeInfo(true, controller.companyStatus);
        case 3:
        default:
          return bankInfo(true, controller.companyStatus);
      }
    });
  }

  Obx _buildTabBar() {
    return Obx(() => tabBarWidget(controller.tabController, controller.tabs,
        controller.currentTabIndex.value));
  }

  Widget _buildImage() {
    return circleImage(controller.profilePhoto.value, onPressed: () {});
  }

  Widget companyInfo() {
    final viewModel = Get.find<CompanyViewModel>();
    CompanyInfo? accountInfo = controller.company.value.accountInfo!;
    LookupData? typeData = viewModel.selectedCompanyField.value;
    LookupData? authorityData = viewModel.selectedIssuingAuthority.value;
    String type = "", authority = "";
    if (typeData != null) {
      type = Utils.isArabic ? typeData.nameAr : typeData.name;
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
              label: "companyNameInEnglish", value: accountInfo.accountName),
          profileTextWidget(
              label: "companyNameInArabic",
              value: accountInfo.accountNameArabic),
          profileTextWidget(
              label: "dateOfEstablishment",
              value: accountInfo.establishmentDate != null
                  ? Utils.dateFormat1.format(
                      controller.company.value.accountInfo!.establishmentDate!)
                  : ""),
          profileTextWidget(label: "companyType", value: type),
          profileAttachWidget(
              label: "companyLicense", value: accountInfo.license!),
          profileTextWidget(label: "issuingAuthority", value: authority),
          profileTextWidget(
              label: "licenseExpiryDate",
              value: accountInfo.licenseExpiryDate != null
                  ? Utils.dateFormat1.format(
                      controller.company.value.accountInfo!.licenseExpiryDate!)
                  : ""),
          if (accountInfo.agreementUrl != null)
            profileAttachWidget(
                label: "agreement",
                value: "Agreements/${accountInfo.agreementUrl!}"),
          if (viewModel.additionalDocuments.isNotEmpty)
            profileAdditionDocWidget(viewModel.additionalDocuments),
          if (controller.company.value.accountInfo!.userId ==
              controller.user.id)
            elevatedButton(
                text: "editInformation",
                onPressed: () => controller.updateComTabIndexForEdit(0)),
        ],
      ),
    );
  }
}
