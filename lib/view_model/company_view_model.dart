import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/individual.dart' as address;
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/company_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/otp_verification_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/widgets/update_email_popup.dart';
import 'package:zakat_fund/widgets/verfy_otp_dialog.dart';

class CompanyViewModel extends GetxController
    with GetTickerProviderStateMixin, GenericMixin {
  late int userId;
  int status = 1;
  int? accountId;
  var companyInfoFormKey = GlobalKey<FormState>();
  RxList<LookupData> companyFieldList = <LookupData>[].obs;
  Rxn<LookupData> selectedCompanyField = Rxn<LookupData>();
  RxList<LookupData> issuingAuthorityList = <LookupData>[].obs;
  Rxn<LookupData> selectedIssuingAuthority = Rxn<LookupData>();
  RxBool isEdit = false.obs;
  bool showSaveAsDraft = false;
  final companyNameArabicController = TextEditingController();
  final companyNameEnglishController = TextEditingController();
  final dateOfEstablishmentController = TextEditingController();
  final licenseExpiryDateController = TextEditingController();
  final companyLogoController = TextEditingController();
  final companyLicenseController = TextEditingController();
  RxBool showAdditionalDocuments = true.obs;
  RxList<AdditionalDocuments> additionalDocuments = <AdditionalDocuments>[].obs;

  final companyNameArabicNode = FocusNode();
  final companyNameEnglishNode = FocusNode();
  final companyFieldNode = FocusNode();
  final dateOfEstablishmentNode = FocusNode();
  final companyLogoNode = FocusNode();
  final companyLicenseNode = FocusNode();
  final companyIssuingAuthorityNode = FocusNode();
  final licenseDateNode = FocusNode();

  RxInt currentSubTab = 0.obs;
  var contactInfoFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final faxController = TextEditingController();
  final websiteController = TextEditingController();
  final poBoxController = TextEditingController();
  final fDocumentController = TextEditingController();
  final sDocumentController = TextEditingController();

  final emailNode = FocusNode();
  final websiteNode = FocusNode();
  final countryNode = FocusNode();
  final emirateNode = FocusNode();
  final cityNode = FocusNode();

  RxList<LookupData> countriesList = <LookupData>[].obs;
  Rxn<LookupData> selectedCountry = Rxn<LookupData>();
  RxList<LookupData> emiratesList = <LookupData>[].obs;
  Rxn<LookupData> selectedEmirate = Rxn<LookupData>();
  Rxn<LookupData> selectedCity = Rxn<LookupData>();
  RxList<LookupData> citiesList = <LookupData>[].obs;
  RxList<address.Address> addresses = <address.Address>[].obs;

  var representativeFormKey = GlobalKey<FormState>();

  final fNameInArabicController = TextEditingController();
  final lNameInArabicController = TextEditingController();
  final fNameInEnglishController = TextEditingController();
  final lNameInEnglishController = TextEditingController();
  final representativePhoneNumberController = TextEditingController();
  final representativeEmailController = TextEditingController();
  final emirateIdController = TextEditingController();

  final fNameInArabicNode = FocusNode();
  final lNameInArabicNode = FocusNode();
  final fNameInEnglishNode = FocusNode();
  final lNameInEnglishNode = FocusNode();
  final representativeEmailNode = FocusNode();
  final nationalityNode = FocusNode();
  final jobTitleNode = FocusNode();

  RxList<LookupData> nationalitiesList = <LookupData>[].obs;
  Rxn<LookupData> selectedNationality = Rxn<LookupData>();

  var bankFormKey = GlobalKey<FormState>();
  RxList<LookupData> banksList = <LookupData>[].obs;
  Rxn<LookupData> selectedBank = Rxn<LookupData>();
  final swiftCodeController = TextEditingController();
  final ibanNumberController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxBool isRequestSubmitted = false.obs;
  final genericRepo = GenericRepoImpl();
  final companyRepo = CompanyRepoImpl();
  XFile? logoFile;
  PlatformFile? licenseFile, fDocumentFile, sDocumentFile;
  String? logoPhoto, licensePhoto, fDocumentPhoto, sDocumentPhoto;
  CompanyInfo? companyInfo;
  ContactInfo? accountContactInfo;
  AccountRepresentative? accountRepresentativeInfo;
  BankAccount? bankAccountInfo;
  late User user;
  RxBool isUAE = false.obs;
  Company? company;
  RxList<LookupData> jobList = <LookupData>[].obs;
  Rxn<LookupData> selectedJob = Rxn<LookupData>();
  bool fromAdd = false;
  late List<KeyboardActionsItem> keyboardActionsItem;
  final phoneNumberNode = FocusNode();
  final faxNode = FocusNode();
  final representativePhoneNumberNode = FocusNode();
  final emirateIdNode = FocusNode();
  final ibanNode = FocusNode();

  RxBool isEmailVerified = false.obs;
  RxBool isPhoneVerified = false.obs;
  OtpVerificationRepo otpRepo = OtpVerificationRepoImpl();

  @override
  void onInit() async {
    var data = Get.arguments;
    fromAdd = data["fromAdd"] ?? false;
    isEdit.value = data["isEdit"];
    company = data["data"];
    user = userBox.getAt(0);
    if (isEdit.value) {
      Utils.logEvent(
          name: user.isAdmin
              ? EventConstant.companyProfileScreen
              : EventConstant.myCompanyProfileScreen);
    } else {
      Utils.logEvent(name: EventConstant.updatedCompanyProfileScreen);
    }
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: phoneNumberNode),
      KeyboardActionsItem(focusNode: faxNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: representativePhoneNumberNode, displayArrows: false),
      KeyboardActionsItem(focusNode: emirateIdNode, displayArrows: false),
      KeyboardActionsItem(focusNode: ibanNode),
    ];
    if (company == null ||
        company?.accountInfo == null ||
        company?.accountInfo?.requestStatus == 8) {
      showSaveAsDraft = true;
    }
    Utils.showLoadingDialog();

    userId = user.id;
    if (!fromAdd) {
      accountId = user.accountId;
      representativeEmailController.text = user.email ?? "";
      emailController.text = user.email ?? "";
    }
    if (fromAdd) {
      emailController.text = user.email;
      phoneNumberController.text = user.mobile ?? "";
      fNameInEnglishController.text = user.firstName;
      lNameInEnglishController.text = user.lastName;
      fNameInArabicController.text = user.firstNameArabic;
      lNameInArabicController.text = user.lastNameArabic;
      representativeEmailController.text = user.email;
      representativePhoneNumberController.text = user.mobile;
    }
    await Future.wait([fetchCompanyFields(), fetchAuthorities()]);
    fetchProfile();
    super.onInit();
  }

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
  }

  Future fetchCompanyFields() async {
    final result = await getLookUpData(endPoint: ApiConstant.companyTypes);
    if (result.isNotEmpty) {
      companyFieldList.value = result;
    }
  }

  Future fetchAdditionalDocuments() async {
    final result = await getAdditionalDocuments(
        endPoint: "${ApiConstant.additionalDocuments}/2/${accountId ?? 0}/2");
    if (result.isNotEmpty) {
      additionalDocuments.value = result;
    }
  }

  Future fetchAuthorities({bool fromApi = false}) async {
    final result =
        await getLookUpData(endPoint: ApiConstant.issuingAuthorities);
    if (result.isNotEmpty) {
      issuingAuthorityList.value = result;
    }
  }

  submitCompany({bool saveAsDraft = false}) async {
    Utils.showLoadingDialog();
    int? bankId;
    if (selectedBank.value != null) {
      bankId = selectedBank.value!.value;
    }

    int? nationalityId;
    if (selectedNationality.value != null) {
      nationalityId = selectedNationality.value!.value;
    }
    int? jobId;
    if (selectedJob.value != null) {
      jobId = selectedJob.value!.value;
    }
    DateTime? dateOfEstablishment, dateOfExpiry;
    if (pickedEstablishment != null) {
      dateOfEstablishment = pickedEstablishment!;
    } else if (companyInfo?.establishmentDate != null) {
      dateOfEstablishment = companyInfo!.establishmentDate?.toUtc();
    }
    if (pickedExpiry != null) {
      dateOfExpiry = pickedExpiry!;
    } else if (companyInfo?.licenseExpiryDate != null) {
      dateOfExpiry = companyInfo!.licenseExpiryDate?.toUtc();
    }

    int? authorityId;
    if (selectedIssuingAuthority.value != null) {
      authorityId = selectedIssuingAuthority.value!.value;
    }

    int? companyId;
    if (selectedCompanyField.value != null) {
      companyId = selectedCompanyField.value!.value;
    }

    int? countryResidenceId;
    if (selectedCountry.value != null) {
      countryResidenceId = selectedCountry.value!.value;
    }
    int? stateId;
    if (isUAE.value && selectedEmirate.value != null) {
      stateId = selectedEmirate.value!.value;
    }
    int? cityId;
    if (selectedCity.value != null) {
      cityId = selectedCity.value!.value;
    }

    var accountInfo = {
      "accountID": accountId ?? 0,
      "userId": user.id,
      "accountName": companyNameEnglishController.text,
      "accountNameArabic": companyNameArabicController.text,
      "establishmentDate": dateOfEstablishment != null
          ? dateOfEstablishment.toString().replaceAll("Z", "")
          : "",
      if (companyId != null) "accountTypeID": companyId,
      "accountLogo": logoPhoto,
      "license": licensePhoto,
      "issuingAuthority": authorityId != null ? authorityId.toString() : "",
      "licenseExpiryDate": dateOfExpiry != null
          ? dateOfExpiry.toString().replaceAll("Z", "")
          : "",
      "isPublish": true,
      "requestStatus": 1,
      if (companyInfo != null) "agreementUrl": companyInfo?.agreementUrl,
    };

    int firstDocumentID = 0, secondDocumentID = 0;
    if (accountContactInfo != null &&
        accountContactInfo!.supportDocument.isNotEmpty) {
      if (accountContactInfo!.supportDocument.length == 1) {
        firstDocumentID = accountContactInfo!.supportDocument[0].id;
      }
      if (accountContactInfo!.supportDocument.length > 1) {
        secondDocumentID = accountContactInfo!.supportDocument[1].id;
      }
    }

    var accountContact = {
      "accountID": accountId ?? 0,
      "email": emailController.text,
      "mobile": phoneNumberController.text,
      "fax": faxController.text,
      "website": websiteController.text,
      "countryId": countryResidenceId ?? "",
      "stateId": stateId ?? "",
      "cityId": cityId ?? "",
      "poBox": poBoxController.text,
      "addresses": addresses.toJson(),
      "supportDocument": [
        {
          "id": firstDocumentID,
          "documentName": "Support Document",
          "documentFileName": fDocumentPhoto ?? "",
          "accountID": accountId ?? 0
        },
        {
          "id": secondDocumentID,
          "documentName": "Support Document",
          "documentFileName": sDocumentPhoto ?? "",
          "accountID": accountId ?? 0
        }
      ],
      "isPublish": true
    };
    int? accountRepresentativeId;
    if (accountRepresentativeInfo != null) {
      accountRepresentativeId = accountRepresentativeInfo?.id;
    }
    var accountRepresentative = {
      "id": accountRepresentativeId,
      "accountID": accountId ?? 0,
      "firstName": fNameInEnglishController.text,
      "lastName": lNameInEnglishController.text,
      "firstNameArabic": fNameInArabicController.text,
      "lastNameArabic": lNameInArabicController.text,
      "email": representativeEmailController.text,
      "phone": representativePhoneNumberController.text,
      "jobDescription": jobId ?? "",
      "nationalityId": nationalityId ?? "",
      "emirateId": emirateIdController.text,
      "isPublish": true
    };

    int bankAccountId = 0;
    if (bankAccountInfo != null) {
      bankAccountId = bankAccountInfo?.id;
    }
    var bankAccount = {
      "id": bankAccountId,
      "accountID": accountId ?? 0,
      "bankName": bankId,
      "swiftCode": swiftCodeController.text,
      "iban": ibanNumberController.text,
      "isPublish": true,
    };

    var body = {
      "accountInfo": accountInfo,
      "accountContact": accountContact,
      "accountRepresentative": accountRepresentative,
      "bankAccount": bankAccount
    };
    log(jsonEncode(body));
    Map<String, dynamic>? queryParameters;
    if (saveAsDraft) {
      if (accountId != null) {
        queryParameters = {
          "draftId": accountId,
        };
      }
      var draftBody = {
        "userId": user.id,
        "accountId": accountId ?? 0,
        "draftType": 3,
        "draftJson": jsonEncode(body),
        if (accountId != null) "draftId": accountId
      };
      ApiResponse apiResponse = await genericRepo.saveAsDraft(
          request:
              RequestBody(body: draftBody, queryParameters: queryParameters));
      Utils.hideLoadingDialog();
      if (apiResponse.appState == AppState.onSuccess) {
        accountId = apiResponse.data;
        if (additionalDocuments.isNotEmpty) {
          await saveAdditionalDocuments(saveAsDraft);
        }
        Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
      } else {
        Utils.handleAPIError(apiResponse);
      }
    } else {
      if (accountId != null && status == 8) {
        queryParameters = {
          "draftId": accountId,
        };

        ApiResponse apiResponse1 = await genericRepo.updateDraft(
            request: RequestBody(queryParameters: queryParameters));
        if (apiResponse1.appState != AppState.onSuccess) {
          Utils.hideLoadingDialog();
          Utils.handleAPIError(apiResponse1);
          return;
        }
      }

      if (accountId != null) {
        queryParameters = {
          "resubmitForApproval": status == 7,
        };
      }
      ApiResponse apiResponse = accountId == null || status == 8
          ? await companyRepo.addCompany(request: RequestBody(body: body))
          : await companyRepo.updateCompany(
              request: RequestBody(
                  body: body,
                  queryParameters: queryParameters,
                  endPoint:
                      "${ApiConstant.updateCompany}/${user.id}/$accountId"));
      if (apiResponse.appState == AppState.onSuccess) {
        if (accountId == null || status == 8) {
          accountId = apiResponse.data;
          if (!fromAdd) {
            user.accountId = accountId;
            userBox.putAt(0, user);
          }
        }
        if (additionalDocuments.isNotEmpty) {
          await saveAdditionalDocuments(saveAsDraft);
        }
        user.status = 1;
        userBox.putAt(0, user);
        isRequestSubmitted.value = true;
        Utils.hideLoadingDialog();
      } else if (apiResponse.appState == AppState.onFailure) {
        Utils.hideLoadingDialog();
        Utils.showGlobalSnackBar(message: apiResponse.message!);
      } else if (apiResponse.appState == AppState.onUnauthorized) {
        Utils.logInAgain();
      }
    }
  }

  submitRequest({bool saveAsDraft = false}) async {
    if (!saveAsDraft) {
      final isValid = bankFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      if (selectedBank.value == null) {
        Utils.showGlobalSnackBar(
            message: "${"bankName".tr} ${"isRequired".tr}");
        return;
      }
      final User? switchAccountUser =
          switchAccountBox.isNotEmpty ? switchAccountBox.getAt(0) : null;
      if (switchAccountUser != null &&
          switchAccountUser.roles.length > 1 &&
          emailController.text != user.email) {
        updateEmailAddressPopUp(onConfirm: () {
          Get.back();
          submitCompany();
        });
      } else {
        submitCompany();
      }
    } else {
      if (selectedBank.value == null) {
        Utils.showGlobalSnackBar(
            message: "${"bankName".tr} ${"isRequired".tr}");
        return;
      }
      submitCompany(saveAsDraft: true);
    }
  }

  saveCompanyRepresentative({bool saveAsDraft = false}) async {
    if (!saveAsDraft) {
      final isValid = representativeFormKey.currentState!.validate();
      if (!isValid) {
        if (Utils.isEmpty(fNameInEnglishController.text)) {
          Utils.scrollToTextField(fNameInEnglishNode);
          return;
        }
        if (Utils.isEmpty(lNameInEnglishController.text)) {
          Utils.scrollToTextField(lNameInEnglishNode);
          return;
        }
        if (Utils.isEmpty(fNameInArabicController.text)) {
          Utils.scrollToTextField(fNameInArabicNode);
          return;
        }
        if (Utils.isEmpty(lNameInArabicController.text)) {
          Utils.scrollToTextField(lNameInArabicNode);
          return;
        }

        if (Utils.isEmpty(representativeEmailController.text)) {
          Utils.scrollToTextField(representativeEmailNode);
          return;
        }
        if (Utils.isEmpty(representativePhoneNumberController.text)) {
          Utils.scrollToTextField(representativePhoneNumberNode);
          return;
        }
        if (selectedNationality.value == null) {
          Utils.scrollToTextField(nationalityNode);
          return;
        }
        if (selectedJob.value == null) {
          Utils.scrollToTextField(jobTitleNode);
          return;
        }
        if (Utils.isEmpty(emirateIdController.text)) {
          Utils.scrollToTextField(emirateIdNode);
          return;
        }
        return;
      }
      if (!Validator.validateEmail(representativeEmailController.text)) {
        Utils.showGlobalSnackBar(message: "invalidEmail".tr);
        return;
      }
      if (!Validator.validatePhone(representativePhoneNumberController.text)) {
        Utils.showGlobalSnackBar(message: "invalidPhone".tr);
        return;
      }
      if (selectedNationality.value == null) {
        Utils.showGlobalSnackBar(
            message: "${"nationality".tr} ${"isRequired".tr}");
        return;
      }
      if (selectedJob.value == null) {
        Utils.showGlobalSnackBar(
            message: "${"jobTitle".tr} ${"isRequired".tr}");
        return;
      }
      if (!Validator.validateEmirateId(emirateIdController.text)) {
        Utils.showGlobalSnackBar(message: "invalidEmirateId".tr);
        return;
      }
      currentSubTab.value = 3;
      scrollToTop();
    } else {
      if (fNameInEnglishController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"firstNameInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(fNameInEnglishNode);
        return;
      }
      if (lNameInEnglishController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"lastNameInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(lNameInEnglishNode);
        return;
      }
      if (fNameInArabicController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"firstNameInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(fNameInArabicNode);
        return;
      }
      if (lNameInArabicController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"lastNameInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(lNameInArabicNode);
        return;
      }
      submitCompany(saveAsDraft: saveAsDraft);
    }
  }

  Future fetchNationality() async {
    final result = await getCountryAndNationality();
    if (result.nationalities.isNotEmpty) {
      nationalitiesList.value = result.nationalities;
      if (accountRepresentativeInfo != null &&
          accountRepresentativeInfo!.nationalityId != null) {
        LookupData? nationality = nationalitiesList.firstWhereOrNull(
            (nationality) =>
                nationality.value == accountRepresentativeInfo!.nationalityId);
        if (nationality != null) {
          selectedNationality.value = nationality;
        }
      }
    }
    if (result.countries.isNotEmpty) {
      countriesList.value = result.countries;
      if (accountContactInfo != null && accountContactInfo!.countryId != 0) {
        LookupData? country = countriesList.firstWhereOrNull((nationality) =>
            nationality.value == accountContactInfo!.countryId);
        if (country != null) {
          selectedCountry.value = country;
          if (country.code.toLowerCase() == "ae") {
            isUAE.value = true;
          } else {
            isUAE.value = false;
          }
          fetchEmirates(fromApi: true);
        }
      }
    }
  }

  Future fetchBanks() async {
    final result = await getAllBanks();
    if (result.isNotEmpty) {
      banksList.value = result;
      if (bankAccountInfo != null && bankAccountInfo!.bankName != null) {
        LookupData? bank = banksList.firstWhereOrNull((bank) =>
            bank.value == int.parse(bankAccountInfo!.bankName.toString()));
        if (bank != null) {
          selectedBank.value = bank;
        }
      }
    }
  }

  saveContactInfo({bool saveAsDraft = false}) async {
    if (!saveAsDraft) {
      final isValid = contactInfoFormKey.currentState!.validate();
      if (!isValid) {
        if (Utils.isEmpty(emailController.text)) {
          Utils.scrollToTextField(emailNode);
          return;
        }
        if (Utils.isEmpty(phoneNumberController.text)) {
          Utils.scrollToTextField(phoneNumberNode);
          return;
        }
        if (Utils.isEmpty(websiteController.text)) {
          Utils.scrollToTextField(websiteNode);
          return;
        }
        if (selectedCountry.value == null) {
          Utils.scrollToTextField(countryNode);
          return;
        }
        if (selectedEmirate.value == null) {
          Utils.scrollToTextField(emirateNode);
          return;
        }
        if (selectedCity.value == null) {
          Utils.scrollToTextField(cityNode);
          return;
        }
        return;
      }
      if (!Validator.validateEmail(emailController.text)) {
        Utils.showGlobalSnackBar(message: "invalidEmail".tr);
        return;
      }
      if (!Validator.validatePhone(phoneNumberController.text)) {
        Utils.showGlobalSnackBar(message: "invalidPhone".tr);
        return;
      }

      if (faxController.text.trim().isNotEmpty &&
          !Validator.validateFax(faxController.text)) {
        Utils.showGlobalSnackBar(message: "${"fax".tr} ${"isInvalid".tr}");
        return;
      }

      if (!Validator.isLink(websiteController.text)) {
        Utils.showGlobalSnackBar(message: "${"website".tr} ${"isInvalid".tr}");
        return;
      }

      if (selectedCountry.value == null) {
        Utils.showGlobalSnackBar(message: "${"country".tr} ${"isRequired".tr}");
        return;
      }
      if (selectedEmirate.value == null && isUAE.value) {
        Utils.showGlobalSnackBar(message: "${"emirate".tr} ${"isRequired".tr}");
        return;
      }
      if (selectedCity.value == null) {
        Utils.showGlobalSnackBar(message: "${"city".tr} ${"isRequired".tr}");
        return;
      }
      currentSubTab.value = 2;
      scrollToTop();
    } else {
      if (emailController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(message: "${"email".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(emailNode);
        return;
      }
      if (!Validator.validateEmail(emailController.text)) {
        Utils.showGlobalSnackBar(message: "invalidEmail".tr);
        Utils.scrollToTextField(emailNode);
        return;
      }
      submitCompany(saveAsDraft: saveAsDraft);
    }
  }

  checkUAE() {
    String code = selectedCountry.value!.code;
    if (code.toLowerCase() == "ae") {
      isUAE.value = true;
    } else {
      isUAE.value = false;
    }
  }

  fetchEmirates({bool fromApi = false}) async {
    if (!isUAE.value) {
      fetchCitiesByCountry(fromApi: fromApi);
      return;
    }
    if (!fromApi) Utils.showLoadingDialog();
    selectedEmirate.value = null;
    selectedCity.value = null;
    emiratesList.clear();
    citiesList.clear();
    LookupData country = selectedCountry.value!;
    final result = await getLookUpData(
        endPoint: "${ApiConstant.emirates}${country.value}");
    if (result.isNotEmpty) {
      emiratesList.value = result;
      if (fromApi) {
        LookupData? emirate = emiratesList.firstWhereOrNull(
            (emirate) => emirate.value == accountContactInfo!.stateId);
        if (emirate != null) {
          selectedEmirate.value = emirate;
          fetchCities(fromApi: fromApi);
        }
      } else {
        Utils.hideLoadingDialog();
      }
    } else {
      if (!fromApi) Utils.hideLoadingDialog();
    }
  }

  fetchCitiesByCountry({bool fromApi = false}) async {
    if (!fromApi) Utils.showLoadingDialog();
    int id = selectedCountry.value!.value;
    citiesList.clear();
    selectedCity.value = null;
    selectedEmirate.value = null;

    final result =
        await getLookUpData(endPoint: "${ApiConstant.citiesByCountry}/$id");
    if (result.isNotEmpty) {
      citiesList.value = result;
      if (fromApi) {
        LookupData? city = citiesList.firstWhereOrNull(
            (city) => city.value == accountContactInfo!.cityId);
        if (city != null) {
          selectedCity.value = city;
        }
      } else {
        Utils.hideLoadingDialog();
      }
    } else {
      if (!fromApi) Utils.hideLoadingDialog();
    }
  }

  fetchCities({bool fromApi = false}) async {
    if (!fromApi) Utils.showLoadingDialog();
    int id = selectedEmirate.value!.value;
    citiesList.clear();
    selectedCity.value = null;

    final result = await getLookUpData(endPoint: "${ApiConstant.cities}/$id");
    if (result.isNotEmpty) {
      citiesList.value = result;
      if (fromApi) {
        LookupData? city = citiesList.firstWhereOrNull(
            (city) => city.value == accountContactInfo!.cityId);
        if (city != null) {
          selectedCity.value = city;
        }
      } else {
        Utils.hideLoadingDialog();
      }
    } else {
      if (!fromApi) Utils.hideLoadingDialog();
    }
  }

  fetchProfile() async {
    if (company != null) {
      companyInfo = company?.accountInfo;
      if (companyInfo != null) {
        status = companyInfo!.requestStatus;

        if (status != 8) {
          user.accountId = companyInfo?.accountId ?? 0;
        }
        accountId = companyInfo?.accountId;

        companyNameArabicController.text = companyInfo!.accountNameArabic;
        companyNameEnglishController.text = companyInfo!.accountName;
        if (companyInfo!.accountTypeId != null) {
          try {
            LookupData? companyField = companyFieldList.firstWhereOrNull(
                (filed) => filed.value == companyInfo!.accountTypeId);
            if (companyField != null) {
              selectedCompanyField.value = companyField;
            }
          } catch (e) {}
        }
        if (companyInfo!.establishmentDate != null) {
          dateOfEstablishmentController.text =
              Utils.dateFormat1.format(companyInfo!.establishmentDate!);
        }
        if (companyInfo!.accountLogo != null) {
          logoPhoto = companyInfo!.accountLogo;
          companyLogoController.text = logoPhoto!;
        }
        if (companyInfo!.license != null) {
          licensePhoto = companyInfo!.license;
          companyLicenseController.text = licensePhoto!;
        }
        if (companyInfo!.issuingAuthority != null &&
            companyInfo!.issuingAuthority != "") {
          LookupData? authority = issuingAuthorityList.firstWhereOrNull(
              (authority) =>
                  authority.value ==
                  int.parse(companyInfo!.issuingAuthority!.toString()));
          if (authority != null) {
            selectedIssuingAuthority.value = authority;
          }
        }
        if (companyInfo!.licenseExpiryDate != null) {
          licenseExpiryDateController.text =
              Utils.dateFormat1.format(companyInfo!.licenseExpiryDate!);
        }
        accountContactInfo = company?.accountContact;
        if (accountContactInfo != null) {
          emailController.text = accountContactInfo!.email;
          phoneNumberController.text = accountContactInfo!.mobile;
          faxController.text = accountContactInfo!.fax;
          websiteController.text = accountContactInfo!.website;
          poBoxController.text = accountContactInfo!.poBox;
          addresses.value = accountContactInfo!.addresses;
          isEmailVerified.value = accountContactInfo!.emailConfirmed;
          isPhoneVerified.value = accountContactInfo!.phoneNumberConfirmed;
        }
        accountRepresentativeInfo = company?.accountRepresentative;
        if (accountRepresentativeInfo != null) {
          fNameInArabicController.text =
              accountRepresentativeInfo!.firstNameArabic;
          lNameInArabicController.text =
              accountRepresentativeInfo!.lastNameArabic;
          fNameInEnglishController.text = accountRepresentativeInfo!.firstName;
          lNameInEnglishController.text = accountRepresentativeInfo!.lastName;
          representativeEmailController.text = accountRepresentativeInfo!.email;
          representativePhoneNumberController.text =
              accountRepresentativeInfo!.phone;
          emirateIdController.text = accountRepresentativeInfo!.emirateId;
        }
        bankAccountInfo = company?.bankAccount;
        if (bankAccountInfo != null) {
          ibanNumberController.text = bankAccountInfo!.iban;
          swiftCodeController.text = bankAccountInfo!.swiftCode;
        }
      }
    }
    await Future.wait([
      fetchNationality(),
      fetchBanks(),
      fetchJobTitles(),
      fetchAdditionalDocuments()
    ]);
    Utils.hideLoadingDialog();
  }

  Future fetchJobTitles() async {
    final result = await getLookUpData(endPoint: ApiConstant.jobTitle);
    if (result.isNotEmpty) {
      jobList.value = result;
      if (accountRepresentativeInfo != null &&
          accountRepresentativeInfo!.jobDescription != null) {
        LookupData? job = jobList.firstWhereOrNull((nationality) =>
            nationality.value ==
            int.tryParse(accountRepresentativeInfo!.jobDescription.toString()));
        if (job != null) {
          selectedJob.value = job;
        }
      }
    }
  }

  Future saveAdditionalDocuments(bool saveAsDraft) async {
    List docList = [];
    docList = additionalDocuments
        .map((doc) => {
              "Id": doc.id,
              "path": doc.selectedFileName,
              "startDateValue":
                  doc.startDateController.text.replaceAll("/", "-"),
              "endDateValue": doc.endDateController.text.replaceAll("/", "-")
            })
        .toList();
    var body = {
      "docList": docList,
      "accountId": accountId ?? user.accountId,
      "userId": user.id,
      "documentAssociatedId": 2,
      "projectId": 0
    };
    await addAdditionalDocuments(body: body);
  }

  Future uploadPicture(
      {bool isLogo = false,
      bool license = false,
      bool fDocument = false,
      bool sDocument = false}) async {
    String filePath = "";
    if (isLogo) {
      filePath = logoFile!.path;
    } else if (license) {
      filePath = licenseFile!.path!;
    } else if (fDocument) {
      filePath = fDocumentFile!.path!;
    } else if (sDocument) {
      filePath = sDocumentFile!.path!;
    }
    final result = await uploadImage(filePath: filePath);
    if (result != null) {
      if (isLogo) {
        logoPhoto = result;
        companyLogoController.text = logoPhoto!;
      } else if (license) {
        licensePhoto = result;
        companyLicenseController.text = licensePhoto!;
      } else if (fDocument) {
        fDocumentPhoto = result;
        fDocumentController.text = fDocumentPhoto!;
      } else if (sDocument) {
        sDocumentPhoto = result;
        sDocumentController.text = sDocumentPhoto!;
      }
    }
  }

  saveCompanyInfo({bool saveAsDraft = false}) async {
    if (!saveAsDraft) {
      final isValid = companyInfoFormKey.currentState!.validate();
      if (!isValid) {
        if (Utils.isEmpty(companyNameEnglishController.text)) {
          Utils.scrollToTextField(companyNameEnglishNode);
          return;
        }
        if (Utils.isEmpty(companyNameArabicController.text)) {
          Utils.scrollToTextField(companyNameArabicNode);
          return;
        }
        if (selectedCompanyField.value == null) {
          Utils.scrollToTextField(companyFieldNode);
          return;
        }
        if (Utils.isEmpty(dateOfEstablishmentController.text)) {
          Utils.scrollToTextField(dateOfEstablishmentNode);
          return;
        }
        if (Utils.isEmpty(companyLogoController.text)) {
          Utils.scrollToTextField(companyLogoNode);
          return;
        }
        if (Utils.isEmpty(companyLicenseController.text)) {
          Utils.scrollToTextField(companyLicenseNode);
          return;
        }
        if (selectedIssuingAuthority.value == null) {
          Utils.scrollToTextField(companyIssuingAuthorityNode);
          return;
        }
        if (Utils.isEmpty(licenseExpiryDateController.text)) {
          Utils.scrollToTextField(licenseDateNode);
          return;
        }
        return;
      }
      if (selectedCompanyField.value == null) {
        Utils.showGlobalSnackBar(
            message: "${"companyType".tr} ${"isRequired".tr}");
        return;
      }
      if (selectedIssuingAuthority.value == null) {
        Utils.showGlobalSnackBar(
            message: "${"issuingAuthority".tr} ${"isRequired".tr}");
        return;
      }
      if (licenseExpiryDateController.text.isNotEmpty) {
        DateTime dateOfExpiry =
            Utils.dateFormat1.parse(licenseExpiryDateController.text);
        if (dateOfExpiry.isBefore(DateTime.now())) {
          Utils.showGlobalSnackBar(message: "licenseExpiryDateMustFuture".tr);
          return;
        }
      }
      currentSubTab.value = 1;
      scrollToTop();
    } else {
      if (companyNameEnglishController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"companyNameInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(companyNameEnglishNode);
        return;
      }
      if (companyNameArabicController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"companyNameInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(companyNameArabicNode);
        return;
      }
      submitCompany(saveAsDraft: saveAsDraft);
    }
  }

  addLogo() async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      Utils.showLoadingDialog();
      logoFile = image;
      await uploadPicture(isLogo: true);
      Utils.hideLoadingDialog();
    }
  }

  addFile(
      {bool license = false, bool fDocument = false, sDocument = false}) async {
    PlatformFile? file = await Utils.pickFile();
    if (file != null) {
      Utils.showLoadingDialog();
      if (license) {
        licenseFile = file;
        await uploadPicture(license: true);
      } else if (fDocument) {
        fDocumentFile = file;
        await uploadPicture(fDocument: true);
      } else if (sDocument) {
        sDocumentFile = file;
        await uploadPicture(sDocument: true);
      }
      Utils.hideLoadingDialog();
    }
  }

  DateTime? pickedEstablishment;
  DateTime? pickedExpiry;

  datePickerDialog({bool isExpiry = false}) async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      fieldHintText: "dd/mm/yyyy",
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      context: Get.context!,
      initialDate: isExpiry
          ? DateTime(dateTime.year, dateTime.month, dateTime.day + 1)
          : dateTime,
      firstDate: isExpiry
          ? DateTime(dateTime.year, dateTime.month, dateTime.day + 1)
          : DateTime(1950),
      lastDate: isExpiry ? DateTime(dateTime.year + 50) : dateTime,
    );
    String date = Utils.dateFormat1.format(picked!);
    if (isExpiry) {
      pickedExpiry = picked;
      licenseExpiryDateController.text = date;
    } else {
      pickedEstablishment = picked;
      dateOfEstablishmentController.text = date;
    }
  }

  setAsDefaultAddress(int index) {
    address.Address? addresss =
        addresses.firstWhereOrNull((element) => element.isDefault == true);
    if (addresss != null) {
      int index = addresses.indexOf(addresss);
      addresses[index].isDefault = false;
    }
    addresses[index].isDefault = true;
    addresses.refresh();
  }

  sendOTP(String userName) async {
    if (userName.isEmpty) {
      return;
    }
    Utils.showLoadingDialog();
    var body = {"userName": userName, "userId": user.id};
    final result = await generateOTPForUser(body);
    Utils.hideLoadingDialog();
    if (result != null) {
      Utils.showFrontEndSnackBar(message: result);
      verifyOtpDialog(
          userName: userName,
          onVerify: (otpCode) {
            if (Get.isSnackbarOpen) {
              return;
            }
            if (userName.contains("@")) {
              userName = user.email;
            } else {
              userName = user.mobile;
            }
            validateOtp(userName: userName, otp: otpCode);
          });
    }
  }

  onChangeEmail(String? value) {
    if (accountContactInfo?.email == value) {
      isEmailVerified.value = true;
    } else {
      isEmailVerified.value = false;
    }
  }

  validateOtp({required String userName, required String otp}) async {
    Utils.showLoadingDialog();
    var body = {
      "userName": userName,
      "isAccountContact": true,
      "otp": otp,
      "entityType": 4,
      "isFromValidate": true
    };
    ApiResponse apiResponse =
        await otpRepo.validateOTP(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (userName.contains("@")) {
        isEmailVerified.value = true;
      } else {
        isPhoneVerified.value = true;
      }
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showFrontEndSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }
}
