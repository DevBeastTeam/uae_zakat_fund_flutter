import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/association_repo.dart';
import 'package:zakat_fund/repository/company_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class AssociationPreviewViewModel extends ModulePermissionsViewModel
    with GenericMixin {
  final associationNameInEnglish = TextEditingController();
  final associationNameInArabic = TextEditingController();
  final associationDescInEnglish = TextEditingController();
  final associationDescInArabic = TextEditingController();
  final dateOfEstablishment = TextEditingController();
  final associationType = TextEditingController();
  final licensingAuthority = TextEditingController();
  final licenseExpiryDate = TextEditingController();
  final associationCoverPhoto = TextEditingController();

  final contactEmail = TextEditingController();
  final contactPhone = TextEditingController();
  final contactFax = TextEditingController();
  final contactWeb = TextEditingController();
  final contactCountry = TextEditingController();
  final contactEmirate = TextEditingController();
  final contactCity = TextEditingController();
  final contactPoBox = TextEditingController();
  final contactAddressArabic = TextEditingController();
  final contactAddressEnglish = TextEditingController();
  final contactInstagram = TextEditingController();
  final contactTwitter = TextEditingController();
  final contactFacebook = TextEditingController();
  final contactLinkedIn = TextEditingController();

  final representativeFNameArabic = TextEditingController();
  final representativeLNameArabic = TextEditingController();
  final representativeFNameEnglish = TextEditingController();
  final representativeLNameEnglish = TextEditingController();
  final representativeEmail = TextEditingController();
  final representativePhone = TextEditingController();
  final representativeJob = TextEditingController();
  final representativeNationality = TextEditingController();
  final representativeEmirateId = TextEditingController();

  final bankName = TextEditingController();
  final swiftCode = TextEditingController();
  final ibanNumber = TextEditingController();

  final companyNameInEnglish = TextEditingController();
  final companyNameInArabic = TextEditingController();
  final companyDateOfEstablishment = TextEditingController();
  final companyField = TextEditingController();
  final companyIssuingAuthority = TextEditingController();
  final companyIssuingDate = TextEditingController();

  final createdByController = TextEditingController();
  final modifiedByController = TextEditingController();
  final createdAtController = TextEditingController();
  final modifiedAtController = TextEditingController();

  RxBool showMetaDataInfo = true.obs;
  RxBool showAssociationInfo = true.obs;
  RxBool showContactInfo = true.obs;
  RxBool showRepresentativeInfo = true.obs;
  RxBool showBankInfo = true.obs;
  RxBool showAdditionalDocuments = true.obs;

  bool isAssociation = false;
  final associationRepo = AssociationRepoImpl();
  final companyRepo = CompanyRepoImpl();

  Rxn<Association> association = Rxn<Association>();
  Rxn<Company> company = Rxn<Company>();

  var data;
  RxList<AdditionalDocuments> additionalDocuments = <AdditionalDocuments>[].obs;
  RxString fDocument = "".obs;
  RxString sDocument = "".obs;

  final genericRepo = GenericRepoImpl();
  ContactInfo? accountContact;
  AccountRepresentative? accountRepresentative;
  BankAccount? bankAccount;
  RxList<Address> addresses = <Address>[].obs;

  RxInt accountId = 0.obs;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    data = Get.arguments;
    isAssociation = data["isAssociation"];
    Future.microtask(() async {
      try{
        Utils.showLoadingDialog();
        if (isAssociation) {
          await fetchAssociationProfile();
          await Future.wait([
            fetchAssociationTypes(),
            fetchAuthorities(),
            fetchAdditionalDocuments()
          ]);
        } else {
          await fetchCompanyProfile();
          await Future.wait([
            fetchCompanyFields(),
            fetchAuthorities(),
            fetchAdditionalDocuments()
          ]);
        }
      }finally{
        Utils.hideLoadingDialog();
      }
      await Future.wait([
        fetchNationality(),
        fetchBanks(),
        fetchJobTitles(),
        if (request == null) fetchMetaData()
      ]);
    });
  }

  Future fetchAdditionalDocuments() async {
    int entityId = isAssociation ? 1 : 2;
    String endPoint =
        "${ApiConstant.additionalDocuments}/$entityId/$accountId/$entityId";
    final result = await getAdditionalDocuments(endPoint: endPoint);
    additionalDocuments.value = result;
  }

  Future fetchAssociationProfile() async {
    if (request == null) {
      association.value = data["data"];
      setAssociationData();
      return;
    }
    String endPoint = "${ApiConstant.associationProfile}/${request?.entityId}/${request?.accountID}";
    ApiResponse apiResponse = await associationRepo.fetchAssociationProfile(request: RequestBody(endPoint: endPoint));
    if (apiResponse.appState == AppState.onSuccess) {
      association.value = apiResponse.data;
      setAssociationData();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  fetchCompanyProfile() async {
    if (request == null) {
      company.value = data["data"];
      setCompanyData();
      return;
    }
    String endPoint = "${ApiConstant.companyProfile}/${request?.entityId}/${request?.accountID}";
    ApiResponse apiResponse = await companyRepo.fetchCompanyProfile(request: RequestBody(endPoint: endPoint));
    if (apiResponse.appState == AppState.onSuccess) {
      company.value = apiResponse.data;
      setCompanyData();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchAssociationTypes() async {
    final result = await getLookUpData(endPoint: ApiConstant.associationType);
    final id = association.value?.associationInfo?.accountTypeId;
    if (id != null) {
      associationType.text = Utils.findLookupName(result, id);
    }
  }

  Future fetchCompanyFields() async {
    final result = await getLookUpData(endPoint: ApiConstant.companyTypes);
    final id = company.value?.accountInfo?.accountTypeId;
    if (id != null) {
      companyField.text = Utils.findLookupName(result, id);
    }
  }

  Future fetchAuthorities() async {
    final result = await getLookUpData(endPoint: ApiConstant.issuingAuthorities);
    final id = isAssociation
        ? association.value?.associationInfo?.issuingAuthority
        : company.value?.accountInfo?.issuingAuthority;

    if (id != null) {
      final name = Utils.findLookupName(result, id);
      isAssociation
          ? licensingAuthority.text = name
          : companyIssuingAuthority.text = name;
    }
  }

  fetchEmirates(bool uae) async {
    if (!uae) return fetchCitiesByCountry();

    final countryId = accountContact?.countryId;
    final stateId = accountContact?.stateId;

    if (countryId == null || stateId == null) return;

    final result = await getLookUpData(endPoint: "${ApiConstant.emirates}$countryId");
    if (result.isNotEmpty) {
      contactEmirate.text = Utils.findLookupName(result, stateId);
      await fetchCities();
    }


  }

  fetchCitiesByCountry({bool fromApi = false}) async {
    final countryId = accountContact?.countryId;
    final cityId = accountContact?.cityId;
    if (countryId == null || cityId == null) return;

    final result = await getLookUpData(endPoint: "${ApiConstant.citiesByCountry}/$countryId");
    if (result.isNotEmpty) {
      contactCity.text = Utils.findLookupName(result, cityId);
    }
  }

  fetchCities({bool fromApi = false}) async {
    final stateId = accountContact?.stateId;
    final cityId = accountContact?.cityId;
    if (stateId == null || cityId == null) return;

    final result = await getLookUpData(endPoint: "${ApiConstant.cities}/$stateId");
    if (result.isNotEmpty) {
      contactCity.text = Utils.findLookupName(result, cityId);
    }
  }

  Future fetchJobTitles() async {
    final jobId = accountRepresentative?.jobDescription;
    if (jobId == null) return;

    final result = await getLookUpData(endPoint: ApiConstant.jobTitle);
    if (result.isNotEmpty) {
      representativeJob.text = Utils.findLookupName(result, jobId);
    }
  }

  Future fetchBanks() async {
    final bankId = bankAccount?.bankName;
    if (bankId == null) return;

    final result = await getAllBanks();
    if (result.isNotEmpty) {
      bankName.text = Utils.findLookupName(result, bankId);
    }
  }

  Future fetchNationality() async {
    final result = await getCountryAndNationality();
    if(result.nationalities.isNotEmpty){
      final nationalId = accountRepresentative!.nationalityId!;
      representativeNationality.text = Utils.findLookupName(result.nationalities, nationalId);
    }
    if(result.countries.isNotEmpty){
      LookupData? countryData = result.countries.firstWhereOrNull((authority) =>
      authority.value == int.parse(accountContact!.countryId.toString()));
      if (countryData != null) {
        contactCountry.text = Utils.isArabic
            ? countryData.nameAr ?? countryData.name
            : countryData.name;
      }
      if (countryData?.code.toLowerCase() == "ae") {
        fetchEmirates(true);
      } else {
        fetchEmirates(false);
      }
    }
  }

  Future fetchMetaData() async {
    Map<String, dynamic> queryParams = {
      "entityType": isAssociation ? "Association" : "Company",
      "pageNumber": 1,
      "pageSize": 10
    };
    String endPoint = "${ApiConstant.auditLogByEntityId}/$accountId";
    final result = await getAuditLogByEntityId(queryParams: queryParams, endPoint: endPoint);
    if(result!=null){
      createdByController.text =
      Utils.isArabic ? result.createdByAr : result.createdBy;
      modifiedByController.text =
      Utils.isArabic ? result.modifiedByAr : result.modifiedBy;
      if (result.createdDate != null) {
        createdAtController.text = Utils.dateTimeFormat.format(result.createdDate!);
      }
      if (result.modifiedDate != null) {
        createdAtController.text = Utils.dateTimeFormat.format(result.modifiedDate!);
      }
    }
  }

  String getTitle() {
    if (request != null) {
      return isAssociation ? "associationPreview" : "companyPreview";
    }
    return isAssociation ? "associationInformation" : "companyInformation";
  }

  onBankInfoTap() => showBankInfo.value = !showBankInfo.value;

  onRepresentativeInfoTap() =>
      showRepresentativeInfo.value = !showRepresentativeInfo.value;

  onContactInfoTap() => showContactInfo.value = !showContactInfo.value;

  onAssociationInfoTap() =>
      showAssociationInfo.value = !showAssociationInfo.value;

  onMetaDataTap() => showMetaDataInfo.value = !showMetaDataInfo.value;

  void setAssociationData() {
    _setAdminState();
    final associationInfo = association.value?.associationInfo;
    accountContact = association.value?.accountContact;
    accountRepresentative = association.value?.accountRepresentative;
    bankAccount = association.value?.bankAccount;

    if (associationInfo != null) {
      accountId.value = associationInfo.accountId;
      associationNameInEnglish.text = associationInfo.accountName;
      associationNameInArabic.text = associationInfo.accountNameArabic;
      associationDescInEnglish.text =
          associationInfo.associationDescriptionEN ?? '';
      associationDescInArabic.text =
          associationInfo.associationDescriptionAR ?? '';
      dateOfEstablishment.text =
          Utils.dateFormat1.format(associationInfo.establishmentDate!);
      associationType.text = associationInfo.accountTypeId.toString();
      licenseExpiryDate.text =
          Utils.dateFormat1.format(associationInfo.licenseExpiryDate!);
    }

    _setContactFields();
    _setRepresentativeFields();
    _setBankAccountFields();
  }

  void setCompanyData() {
    _setAdminState();
    final companyInfo = company.value?.accountInfo;
    accountContact = company.value?.accountContact;
    accountRepresentative = company.value?.accountRepresentative;
    bankAccount = company.value?.bankAccount;

    if (companyInfo != null) {
      accountId.value = companyInfo.accountId ?? 0;
      companyNameInEnglish.text = companyInfo.accountName;
      companyNameInArabic.text = companyInfo.accountNameArabic;
      companyDateOfEstablishment.text =
          Utils.dateFormat1.format(companyInfo.establishmentDate!);
      companyIssuingAuthority.text = companyInfo.issuingAuthority ?? '';
      companyIssuingDate.text =
          Utils.dateFormat1.format(companyInfo.licenseExpiryDate!);
    }

    _setContactFields(includeAddresses: true);
    _setRepresentativeFields();
    _setBankAccountFields();
  }

  void _setAdminState() {
    isAdmin.value = (request?.status == 1 && user.isAdmin);
  }

  void _setContactFields({bool includeAddresses = false}) {
    if (accountContact == null) return;

    contactEmail.text = accountContact?.email ?? '';
    contactPhone.text = accountContact?.mobile ?? '';
    contactFax.text = accountContact?.fax ?? '';
    contactWeb.text = accountContact?.website ?? '';
    contactPoBox.text = accountContact?.poBox ?? '';
    contactAddressEnglish.text = accountContact?.address ?? '';
    contactAddressArabic.text = accountContact?.addressArabic ?? '';
    contactInstagram.text = accountContact?.instagram ?? '';
    contactTwitter.text = accountContact?.twitter ?? '';
    contactFacebook.text = accountContact?.facebook ?? '';
    contactLinkedIn.text = accountContact?.linkedIn ?? '';

    if (accountContact!.supportDocument.isNotEmpty) {
      fDocument.value = accountContact!.supportDocument[0].documentFileName;
      if (accountContact!.supportDocument.length == 2) {
        sDocument.value = accountContact!.supportDocument[1].documentFileName;
      }
    }

    if (includeAddresses) {
      addresses.value = accountContact!.addresses;
    }
  }

  void _setRepresentativeFields() {
    if (accountRepresentative == null) return;

    representativeFNameEnglish.text = accountRepresentative?.firstName ?? '';
    representativeLNameEnglish.text = accountRepresentative?.lastName ?? '';
    representativeFNameArabic.text =
        accountRepresentative?.firstNameArabic ?? '';
    representativeLNameArabic.text =
        accountRepresentative?.lastNameArabic ?? '';
    representativeEmail.text = accountRepresentative?.email ?? '';
    representativePhone.text = accountRepresentative?.phone ?? '';
    representativeEmirateId.text = accountRepresentative!.emirateId.toString();
  }

  void _setBankAccountFields() {
    if (bankAccount == null) return;

    swiftCode.text = bankAccount?.swiftCode ?? '';
    ibanNumber.text = bankAccount?.iban ?? '';
  }

  @override
  void onClose() {
    associationNameInEnglish.dispose();
    associationNameInArabic.dispose();
    associationDescInEnglish.dispose();
    associationDescInArabic.dispose();
    dateOfEstablishment.dispose();
    associationType.dispose();
    licensingAuthority.dispose();
    licenseExpiryDate.dispose();
    associationCoverPhoto.dispose();

    contactEmail.dispose();
    contactPhone.dispose();
    contactFax.dispose();
    contactWeb.dispose();
    contactCountry.dispose();
    contactEmirate.dispose();
    contactCity.dispose();
    contactPoBox.dispose();
    contactAddressArabic.dispose();
    contactAddressEnglish.dispose();
    contactInstagram.dispose();
    contactTwitter.dispose();
    contactFacebook.dispose();
    contactLinkedIn.dispose();

    representativeFNameArabic.dispose();
    representativeLNameArabic.dispose();
    representativeFNameEnglish.dispose();
    representativeLNameEnglish.dispose();
    representativeEmail.dispose();
    representativePhone.dispose();
    representativeJob.dispose();
    representativeNationality.dispose();
    representativeEmirateId.dispose();

    bankName.dispose();
    swiftCode.dispose();
    ibanNumber.dispose();

    companyNameInEnglish.dispose();
    companyNameInArabic.dispose();
    companyDateOfEstablishment.dispose();
    companyField.dispose();
    companyIssuingAuthority.dispose();
    companyIssuingDate.dispose();

    createdByController.dispose();
    modifiedByController.dispose();
    createdAtController.dispose();
    modifiedAtController.dispose();

    showMetaDataInfo.close();
    showAssociationInfo.close();
    showContactInfo.close();
    showRepresentativeInfo.close();
    showBankInfo.close();
    showAdditionalDocuments.close();
    association.close();
    company.close();
    additionalDocuments.close();
    fDocument.close();
    sDocument.close();
    addresses.close();
    accountId.close();

    super.onClose();
  }
}
