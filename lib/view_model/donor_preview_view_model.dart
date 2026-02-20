import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class DonorPreviewViewModel extends GetxController with GenericMixin {
  RxBool showMetaDataInfo = true.obs;
  RxBool showDonorInfo = true.obs;
  RxBool showAdditionalDocuments = true.obs;
  RxBool showContactInfo = true.obs;

  final userNameController = TextEditingController();
  final firstNameInEnglishController = TextEditingController();
  final lastNameInEnglishController = TextEditingController();
  final firstNameInArabicController = TextEditingController();
  final lastNameInArabicController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final uaeIdController = TextEditingController();
  final nationalityController = TextEditingController();
  final mobileNumberPrimaryController = TextEditingController();
  final mobileNumberSecondaryController = TextEditingController();
  final countryController = TextEditingController();
  final emirateController = TextEditingController();
  final cityController = TextEditingController();
  final poBoxController = TextEditingController();

  final createdByController = TextEditingController();
  final modifiedByController = TextEditingController();
  final createdAtController = TextEditingController();
  final modifiedAtController = TextEditingController();
  RxList<AdditionalDocuments> additionalDocuments = <AdditionalDocuments>[].obs;

  late Individual donor;

  LookupData? country;
  LookupData? emirate;

  @override
  Future<void> onInit() async {
    donor = Get.arguments;
    setData();
    try {
      Utils.showLoadingDialog();
      await Future.wait([fetchAdditionalDocuments(), fetchNationality(), fetchMetaData()]);
    } finally {
      Utils.hideLoadingDialog();
    }
    super.onInit();
  }

  setData() {
    AccountInfo accountInfo = donor.accountInfo!;
    DonorContactInfo contactInfo = donor.contactInfo!;
    userNameController.text = accountInfo.userName;
    firstNameInEnglishController.text = accountInfo.firstName;
    lastNameInEnglishController.text = accountInfo.lastName;
    firstNameInArabicController.text = accountInfo.firstNameArabic;
    lastNameInArabicController.text = accountInfo.lastNameArabic;
    emailController.text = accountInfo.email;
    if (accountInfo.dob != null) {
      dobController.text = Utils.dateFormat1.format(accountInfo.dob!);
    }
    uaeIdController.text = accountInfo.emirateId;
    mobileNumberPrimaryController.text = contactInfo.mobile ?? "";
    mobileNumberSecondaryController.text =
        contactInfo.additionalMobileNumber ?? "";
    poBoxController.text = contactInfo.poBox ?? "";
  }

  Future fetchAdditionalDocuments() async {
    String endPoint =
        "${ApiConstant.additionalDocuments}/4/${donor.accountInfo!.userId}/4";
    final result = await getAdditionalDocuments(endPoint: endPoint);
    additionalDocuments.value = result;
  }

  Future fetchNationality() async {
    final result = await getCountryAndNationality();
    if (result.nationalities.isNotEmpty) {
      nationalityController.text = Utils.findLookupName(
          result.nationalities, donor.accountInfo!.nationalityId);
    }
    if (result.countries.isNotEmpty) {
      country = result.countries.firstWhereOrNull(
          (country) => country.value == donor.contactInfo!.countryResidenceId);
      if (country != null) {
        countryController.text =
            Utils.isArabic ? country!.nameAr : country!.name;
        bool isUAE = country!.code.toLowerCase() == "ae";
        await fetchEmirates(isUAE);
      }
    }
  }

  fetchEmirates(bool isUAE) async {
    if (!isUAE) {
      fetchCitiesByCountry();
      return;
    }
    final result = await getLookUpData(
        endPoint: "${ApiConstant.emirates}${country!.value}");
    if (result.isNotEmpty) {
      emirateController.text =
          Utils.findLookupName(result, donor.contactInfo!.stateId);
      emirate = result.firstWhereOrNull(
          (country) => country.value == donor.contactInfo!.stateId);
      await fetchCities();
    }
  }

  Future fetchCities() async {
    final result = await getLookUpData(
        endPoint: "${ApiConstant.cities}/${emirate!.value}");
    if (result.isNotEmpty) {
      cityController.text =
          Utils.findLookupName(result, donor.contactInfo!.cityId);
    }
  }

  Future fetchCitiesByCountry() async {
    final result = await getLookUpData(
        endPoint: "${ApiConstant.citiesByCountry}/${country!.value}");
    if (result.isNotEmpty) {
      cityController.text =
          Utils.findLookupName(result, donor.contactInfo!.cityId);
    }
  }

  Future fetchMetaData() async {
    Map<String, dynamic> queryParams = {
      "entityType": "User",
      "pageNumber": 1,
      "pageSize": 10
    };
    String endPoint =
        "${ApiConstant.auditLogByEntityId}/${donor.accountInfo!.userId}";
    final result = await getAuditLogByEntityId(
        queryParams: queryParams, endPoint: endPoint);
    if (result != null) {
      createdByController.text =
          Utils.isArabic ? result.createdByAr : result.createdBy;
      modifiedByController.text =
          Utils.isArabic ? result.modifiedByAr : result.modifiedBy;
      if (result.createdDate != null) {
        createdAtController.text =
            Utils.dateTimeFormat.format(result.createdDate!);
      }
      if (result.modifiedDate != null) {
        createdAtController.text =
            Utils.dateTimeFormat.format(result.modifiedDate!);
      }
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    firstNameInEnglishController.dispose();
    lastNameInEnglishController.dispose();
    firstNameInArabicController.dispose();
    lastNameInArabicController.dispose();
    emailController.dispose();
    dobController.dispose();
    uaeIdController.dispose();
    nationalityController.dispose();
    mobileNumberPrimaryController.dispose();
    mobileNumberSecondaryController.dispose();
    countryController.dispose();
    emirateController.dispose();
    cityController.dispose();
    poBoxController.dispose();
    createdByController.dispose();
    modifiedByController.dispose();
    createdAtController.dispose();
    modifiedAtController.dispose();

    showDonorInfo.close();
    showContactInfo.close();
    showAdditionalDocuments.close();
    showMetaDataInfo.close();
    additionalDocuments.close();
    super.onClose();
  }
}
