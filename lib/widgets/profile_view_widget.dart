import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';
import 'package:zakat_fund/view_model/company_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/profile_text_widget.dart';

Widget genericInfo(bool isCompany, int status) {
  final account = Get.find<AccountViewModel>();
  dynamic viewModel = isCompany
      ? Get.find<CompanyViewModel>()
      : Get.find<AssociationViewModel>();
  ContactInfo? accountContact = isCompany
      ? account.company.value.accountContact
      : account.association.value.accountContact;
  LookupData? countryData = viewModel.selectedCountry.value;
  LookupData? emirateData = viewModel.selectedEmirate.value;
  LookupData? cityData = viewModel.selectedCity.value;
  String country = "", emirate = "", city = "";
  if (countryData != null) {
    country = Utils.isArabic ? countryData.nameAr : countryData.name;
  }
  if (emirateData != null) {
    emirate = Utils.isArabic ? emirateData.nameAr : emirateData.name;
  }
  if (cityData != null) {
    city = Utils.isArabic ? cityData.nameAr : cityData.name;
  }
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileTextWidget(label: "email", value: accountContact?.email),
        profileTextWidget(label: "phoneNumber", value: accountContact?.mobile),
        profileTextWidget(label: "fax", value: accountContact?.fax),
        profileTextWidget(label: "website", value: accountContact?.website),
        profileTextWidget(label: "country", value: country),
        if (viewModel.selectedEmirate.value != null)
          profileTextWidget(label: "emirate", value: emirate),
        profileTextWidget(label: "city", value: city),
        profileTextWidget(label: "poBox", value: accountContact?.poBox),
        if (!isCompany) ...[
          profileTextWidget(
              label: "addressInEnglish", value: accountContact?.address),
          profileTextWidget(
              label: "addressInArabic", value: accountContact?.addressArabic)
        ],
        if (accountContact!.supportDocument.isNotEmpty)
          profileAttachWidget(
              label: "firstSupportDocument",
              value: accountContact.supportDocument[0].documentFileName),
        if (accountContact.supportDocument.length == 2)
          profileAttachWidget(
              label: "secondSupportDocument",
              value: accountContact.supportDocument[1].documentFileName),
        if (isCompany) ..._buildAddressListView(accountContact),
        if (canEdit(isCompany, account))
          elevatedButton(
              text: "editInformation",
              onPressed: () => isCompany
                  ? account.updateComTabIndexForEdit(1)
                  : account.updateAssTabIndexForEdit(1)),
      ],
    ),
  );
}

bool canEdit(bool isCompany, AccountViewModel account) {
  final userId = account.user.id;
  return isCompany
      ? account.company.value.accountInfo?.userId == userId
      : account.association.value.associationInfo?.userId == userId;
}

List<Widget> _buildAddressListView(ContactInfo accountContact) {
  return [
    Text(
      "address".tr,
      style: AppTextStyle.primaryDarkGrey14spTextStyle1,
    ),
    8.verticalSpace,
    Column(
        children: List.generate(
            accountContact.addresses.length,
            (index) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 50.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${index == 0 ? "address1".tr : "address2".tr} ${accountContact.addresses[index].isDefault ? "primary".tr : ""}",
                        style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                      ),
                      10.verticalSpace,
                      Text(accountContact.addresses[index].street,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(accountContact.addresses[index].building,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(accountContact.addresses[index].landmark,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                    ],
                  ),
                )))
  ];
}

Widget representativeInfo(bool isCompany, int status) {
  final account = Get.find<AccountViewModel>();
  dynamic viewModel = isCompany
      ? Get.find<CompanyViewModel>()
      : Get.find<AssociationViewModel>();
  AccountRepresentative? accountRepresentative = isCompany
      ? account.company.value.accountRepresentative
      : account.association.value.accountRepresentative;
  LookupData? nationalityData = viewModel.selectedNationality.value;
  LookupData? jobData = viewModel.selectedJob.value;
  String nationality = "", job = "";
  if (nationalityData != null) {
    nationality =
        Utils.isArabic ? nationalityData.nameAr : nationalityData.name;
  }
  if (jobData != null) {
    job = Utils.isArabic ? jobData.nameAr : jobData.name;
  }
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileTextWidget(
            label: "firstNameInEnglish",
            value: accountRepresentative?.firstName ?? ""),
        profileTextWidget(
            label: "lastNameInEnglish",
            value: accountRepresentative?.lastName ?? ""),
        profileTextWidget(
            label: "firstNameInArabic",
            value: accountRepresentative?.firstNameArabic ?? ""),
        profileTextWidget(
            label: "lastNameInArabic",
            value: accountRepresentative?.lastNameArabic ?? ""),
        profileTextWidget(
            label: "email", value: accountRepresentative?.email ?? ""),
        profileTextWidget(
            label: "phoneNumber", value: accountRepresentative?.phone ?? ""),
        profileTextWidget(label: "nationality", value: nationality),
        profileTextWidget(label: "jobTitle", value: job),
        profileTextWidget(
            label: "emirateIdNumber",
            value: accountRepresentative?.emirateId ?? ""),
        if (canEdit(isCompany, account))
          elevatedButton(
              text: "editInformation",
              onPressed: () => isCompany
                  ? account.updateComTabIndexForEdit(2)
                  : account.updateAssTabIndexForEdit(2)),
      ],
    ),
  );
}

Widget bankInfo(bool isCompany, int status) {
  final account = Get.find<AccountViewModel>();
  dynamic viewModel = isCompany
      ? Get.find<CompanyViewModel>()
      : Get.find<AssociationViewModel>();
  BankAccount? bankAccount = isCompany
      ? account.company.value.bankAccount
      : account.association.value.bankAccount;
  LookupData? bankData = viewModel.selectedBank.value;
  String bankName = "";
  if (bankData != null) {
    bankName = Utils.isArabic ? bankData.nameAr : bankData.name;
  }

  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileTextWidget(label: "bankName", value: bankName),
        profileTextWidget(
            label: "ibanNumber",
            value: bankAccount == null ? "" : bankAccount.iban),
        profileTextWidget(
            label: "swiftCode",
            value: bankAccount == null ? "" : bankAccount.swiftCode),
        if (canEdit(isCompany, account))
          elevatedButton(
              text: "editInformation",
              onPressed: () => isCompany
                  ? account.updateComTabIndexForEdit(3)
                  : account.updateAssTabIndexForEdit(3)),
      ],
    ),
  );
}

Widget associationHeader(controller, bool showEdit, bool showView,
    {bool showLess = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 275.h,
        child: Stack(
          // clipBehavior: Clip.none,
          children: [
            Obx(() => controller.coverPhoto.value != null
                ? CachedImage(
                    image: controller.coverPhoto.value,
                    height: 200.h,
                    width: Get.width,
                  )
                : Image.asset(
                    AppResources.placeholder,
                    height: 200.h,
                    fit: BoxFit.cover,
                    width: Get.width,
                  )),
            Positioned(
              top: 150.h,
              left: 16,
              child: Obx(() =>
                  circleImage(controller.profilePhoto.value, onPressed: () {})),
            ),
          ],
        ),
      ),
      // 55.verticalSpace,
      Obx(() => controller.association.value.associationInfo != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.isArabic
                        ? controller.association.value.associationInfo!
                                .accountNameArabic ??
                            ""
                        : controller
                            .association.value.associationInfo!.accountName,
                    style: AppTextStyle.primaryDarkBrown24spTextStyle
                        .copyWith(height: 0),
                  ),
                  8.verticalSpace,
                  Text(
                    Utils.isArabic
                        ? controller.association.value.associationInfo!
                            .associationDescriptionAR!
                        : controller.association.value.associationInfo!
                            .associationDescriptionEN!,
                    style: AppTextStyle.darkGrey14spTextStyle,
                    maxLines: showLess ? 3 : null,
                    overflow: showLess ? TextOverflow.ellipsis : null,
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      if (controller
                              .association.value.accountContact!.facebook !=
                          null)
                        buildIconButton(
                          isLink: true,
                          icon: AppResources.facebookLink,
                          onPressed: () {
                            Utils.openUrl(controller
                                .association.value.accountContact!.facebook!);
                          },
                        ),
                      if (controller
                              .association.value.accountContact!.instagram !=
                          null)
                        buildIconButton(
                          isLink: true,
                          icon: AppResources.instagramLink,
                          onPressed: () {
                            Utils.openUrl(controller
                                .association.value.accountContact!.instagram!);
                          },
                        ),
                      if (controller
                              .association.value.accountContact!.linkedIn !=
                          null)
                        buildIconButton(
                          isLink: true,
                          icon: AppResources.linkedinLink,
                          onPressed: () {
                            Utils.openUrl(controller
                                .association.value.accountContact!.linkedIn!);
                          },
                        ),
                      if (controller
                              .association.value.accountContact!.twitter !=
                          null)
                        buildIconButton(
                          isLink: true,
                          icon: AppResources.twitterLink,
                          onPressed: () {
                            Utils.openUrl(controller
                                .association.value.accountContact!.twitter!);
                          },
                        ),
                    ],
                  ),
                  8.verticalSpace,
                  if (showEdit || showView)
                    Row(
                      children: [
                        if (showEdit)
                          Expanded(
                              child: elevatedButton(
                            text: "edit",
                            onPressed: () => openAssociationScreen(controller, false),
                          )),
                        if (showEdit && showView) 10.horizontalSpace,
                        if (showView)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  openAssociationScreen(controller, true),
                              style: ButtonStyle(
                                  fixedSize: WidgetStatePropertyAll(
                                      Size(Get.width, 48.h)),
                                  elevation: const WidgetStatePropertyAll(0),
                                  side: WidgetStatePropertyAll(BorderSide(
                                      width: 2.w,
                                      color: AppColors.darkBrownColor)),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.r)))),
                              child: Text(
                                "view".tr,
                                style: AppTextStyle.darkBrown16spTextStyle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (showEdit || showView) 16.verticalSpace,
                ],
              ),
            )
          : const SizedBox.shrink()),
      // 16.verticalSpace,
    ],
  );
}

openAssociationScreen(controller, isEdit) {
  Get.toNamed(AppRoutes.associationScreen, arguments: {"data": controller.association.value, "isEdit": isEdit})!
      .then((_) {
    Utils.showLoadingDialog();
    controller.fetchAssociationProfile(notUpdate: false);
  });
}
