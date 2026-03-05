import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/profile_text_widget.dart';
import 'package:zakat_fund/widgets/profile_view_widget.dart';
import 'package:zakat_fund/widgets/tabbar_widget_v2.dart';

class AssociationProfileScreen extends GetView<AccountViewModel> {
  const AssociationProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.currentTabIndex.value = 0;
    controller.tabController.animateTo(0);
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderImage(),
          16.verticalSpace,
          _buildTabBar(),
          16.verticalSpace,
          _buildContentCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return associationHeader(controller, false, false, showLess: true);
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
  Widget _buildContentCard() {
    return Obx(() {
      final isOwner = controller.association.value.associationInfo?.userId ==
          controller.user.id;
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: _buildTabContent(),
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
                    .updateAssTabIndexForEdit(controller.currentTabIndex.value),
              ),
            ),
          ],
          16.verticalSpace,
        ],
      );
    });
  }

  Widget _buildTabContent() {
    return Obx(() {
      final index = controller.currentTabIndex.value;
      switch (index) {
        case 0:
          return _buildAssociationInfoContent();
        case 1:
          return _buildContactInfoContent();
        case 2:
          return _buildRepresentativeInfoContent();
        case 3:
        default:
          return _buildBankInfoContent();
      }
    });
  }

  // ── Association info tab content ──────────────────────────────────────────
  Widget _buildAssociationInfoContent() {
    final viewModel = Get.find<AssociationViewModel>();
    AssociationInfo? associationInfo =
        controller.association.value.associationInfo;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        profileTextWidget(
            label: "associationNameInEnglish",
            value: associationInfo?.accountName ?? ''),
        profileTextWidget(
            label: "associationNameInArabic",
            value: associationInfo?.accountNameArabic ?? ''),
        profileTextWidget(
            label: "associationDescInEnglish",
            value: associationInfo?.associationDescriptionEN ?? ''),
        profileTextWidget(
            label: "associationDescInArabic",
            value: associationInfo?.associationDescriptionAR ?? ''),
        profileTextWidget(
            label: "dateOfEstablishment",
            value: associationInfo?.establishmentDate != null
                ? Utils.dateFormat1.format(associationInfo!.establishmentDate!)
                : ""),
        profileTextWidget(label: "associationType", value: type),
        profileTextWidget(
            label: "licenseExpiryDate",
            value: associationInfo?.licenseExpiryDate != null
                ? Utils.dateFormat1.format(associationInfo!.licenseExpiryDate!)
                : ""),
        profileTextWidget(label: "licensingAuthority", value: authority),
        profileAttachWidget(
            label: "associationLicense", value: associationInfo?.license ?? ''),
        if (associationInfo?.agreementUrl != null)
          profileAttachWidget(
              label: "agreement",
              value: "agreements/${associationInfo!.agreementUrl!}"),
        if (viewModel.additionalDocuments.isNotEmpty)
          profileAdditionDocWidget(viewModel.additionalDocuments),
      ],
    );
  }

  // ── Contact info tab content ──────────────────────────────────────────────
  Widget _buildContactInfoContent() {
    final viewModel = Get.find<AssociationViewModel>();
    final contactInfo = controller.association.value.accountContact;
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
        profileTextWidget(label: 'email', value: contactInfo?.email ?? ''),
        profileTextWidget(label: 'mobile', value: contactInfo?.mobile ?? ''),
        profileTextWidget(label: 'fax', value: contactInfo?.fax ?? ''),
        profileTextWidget(label: 'website', value: contactInfo?.website ?? ''),
        profileTextWidget(label: 'country', value: country),
        if (emirateData != null)
          profileTextWidget(label: 'emirate', value: emirate),
        profileTextWidget(label: 'city', value: city),
        profileTextWidget(label: 'poBox', value: contactInfo?.poBox ?? ''),
        profileTextWidget(label: 'address', value: contactInfo?.address ?? ''),
        profileTextWidget(
            label: 'addressInArabic', value: contactInfo?.addressArabic ?? ''),
        if (contactInfo?.facebook != null && contactInfo!.facebook!.isNotEmpty)
          profileTextWidget(label: 'facebook', value: contactInfo.facebook!),
        if (contactInfo?.linkedIn != null && contactInfo!.linkedIn!.isNotEmpty)
          profileTextWidget(label: 'linkedIn', value: contactInfo.linkedIn!),
        if (contactInfo?.twitter != null && contactInfo!.twitter!.isNotEmpty)
          profileTextWidget(label: 'twitter', value: contactInfo.twitter!),
        if (contactInfo?.instagram != null &&
            contactInfo!.instagram!.isNotEmpty)
          profileTextWidget(label: 'instagram', value: contactInfo.instagram!),
      ],
    );
  }

  // ── Representative info tab content ───────────────────────────────────────
  Widget _buildRepresentativeInfoContent() {
    final viewModel = Get.find<AssociationViewModel>();
    final representative = controller.association.value.accountRepresentative;
    final nationalityData = viewModel.selectedNationality.value;
    final nationality = nationalityData != null
        ? (Utils.isArabic ? nationalityData.nameAr : nationalityData.name)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        profileTextWidget(
            label: 'firstNameInEnglish',
            value: representative?.firstName ?? ''),
        profileTextWidget(
            label: 'lastNameInEnglish', value: representative?.lastName ?? ''),
        profileTextWidget(
            label: 'firstNameInArabic',
            value: representative?.firstNameArabic ?? ''),
        profileTextWidget(
            label: 'lastNameInArabic',
            value: representative?.lastNameArabic ?? ''),
        profileTextWidget(label: 'email', value: representative?.email ?? ''),
        profileTextWidget(label: 'mobile', value: representative?.phone ?? ''),
        profileTextWidget(
            label: 'jobDescription',
            value: representative?.jobDescription ?? ''),
        profileTextWidget(label: 'nationality', value: nationality),
        profileTextWidget(
            label: 'uaeId', value: representative?.emirateId ?? ''),
      ],
    );
  }

  // ── Bank info tab content ─────────────────────────────────────────────────
  Widget _buildBankInfoContent() {
    final bankAccount = controller.association.value.bankAccount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        profileTextWidget(
            label: 'bankName', value: bankAccount?.bankName ?? ''),
        profileTextWidget(
            label: 'swiftCode', value: bankAccount?.swiftCode ?? ''),
        profileTextWidget(label: 'ibanNumber', value: bankAccount?.iban ?? ''),
      ],
    );
  }
}
