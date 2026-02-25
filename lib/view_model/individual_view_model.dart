import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/individual_repo.dart';
import 'package:zakat_fund/repository/otp_verification_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view/donor/individual/add_address_screen.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/address_view_model.dart';
import 'package:zakat_fund/widgets/update_email_popup.dart';
import 'package:zakat_fund/widgets/verfy_otp_dialog.dart';

class IndividualViewModel extends GetxController
    with GetTickerProviderStateMixin, GenericMixin {
  final accountViewModel = Get.find<AccountViewModel>();
  final donorRepo = IndividualRepoImpl();
  final otpRepo = OtpVerificationRepoImpl();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final fNameArabicController = TextEditingController();
  final lNameArabicController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final uaeIDController = TextEditingController();
  final nationalityController = TextEditingController();
  final profileImageController = TextEditingController();
  final primaryMobileController = TextEditingController();
  final secondaryMobileController = TextEditingController();
  final poBoxController = TextEditingController();

  final emirateIdNode = FocusNode();
  final primaryPhoneNode = FocusNode();
  final secondaryPhoneNode = FocusNode();
  final userNameNode = FocusNode();
  final fNameArabicNode = FocusNode();
  final lNameArabicNode = FocusNode();
  final fNameNode = FocusNode();
  final lNameNode = FocusNode();
  final genderNode = FocusNode();
  final nationalityNode = FocusNode();
  final countryNode = FocusNode();
  final emirateNode = FocusNode();
  final cityNode = FocusNode();

  final isUAE = false.obs;
  final isEdit = false.obs;
  final isEmailVerified = false.obs;
  final isPhoneVerified = false.obs;
  final showAdditionalDocuments = true.obs;
  final setAsDefault = 1.obs;
  final currentSubTabIndex = 0.obs;
  final accountStatus = 1.obs;

  final nationalitiesList = <LookupData>[].obs;
  final countriesList = <LookupData>[].obs;
  final emiratesList = <LookupData>[].obs;
  final citiesList = <LookupData>[].obs;
  final addresses = <Address>[].obs;
  final additionalDocuments = <AdditionalDocuments>[].obs;

  final selectedGender = Rxn<LookupData>();
  final selectedNationality = Rxn<LookupData>();
  final selectedCountry = Rxn<LookupData>();
  final selectedEmirate = Rxn<LookupData>();
  final selectedCity = Rxn<LookupData>();

  TabController? subTabController;
  late User user;
  late int userId;
  late AccountInfo accountInfo;
  late DonorContactInfo contactInfo;
  Individual? individual;
  DateTime? picked;
  XFile? imageFile;
  String? photo;
  var data;

  final List<LookupData> genders = [
    LookupData(name: "male".tr, nameAr: "male".tr, value: 1),
    LookupData(name: "female".tr, nameAr: "female".tr, value: 2),
  ];

  var accountFormKey = GlobalKey<FormState>();
  var contactFormKey = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: emirateIdNode, displayArrows: false),
      KeyboardActionsItem(focusNode: primaryPhoneNode),
      KeyboardActionsItem(focusNode: secondaryPhoneNode, displayArrows: false),
    ];
    user = userBox.getAt(0);

    if (user.status != 1 || Get.arguments["edit"] != null) {
      inItController(0);
    }
    isEdit.value = Get.arguments["isEdit"] ?? false;
    userId = user.id;
    individual = Get.arguments["data"];
    if (isEdit.value) {
      Utils.logEvent(
          name: user.isAdmin
              ? EventConstant.donorProfileScreen
              : EventConstant.myDonorProfileScreen);
    } else {
      Utils.logEvent(name: EventConstant.updatedDonorProfileScreen);
    }
    try {
      Utils.showLoadingDialog();
      await Future.wait([fetchNationality(), fetchAdditionalDocuments()]);
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  validateTextFields() {
    if (Utils.isEmpty(userNameController.text)) {
      Utils.scrollToTextField(userNameNode);
      return;
    }
    if (Utils.isEmpty(fNameController.text)) {
      Utils.scrollToTextField(fNameNode);
      return;
    }
    if (Utils.isEmpty(lNameController.text)) {
      Utils.scrollToTextField(lNameNode);
      return;
    }
    if (Utils.isEmpty(fNameArabicController.text)) {
      Utils.scrollToTextField(fNameArabicNode);
      return;
    }
    if (Utils.isEmpty(lNameArabicController.text)) {
      Utils.scrollToTextField(lNameArabicNode);
      return;
    }

    if (selectedGender.value == null) {
      Utils.scrollToTextField(genderNode);
      return;
    }
    if (selectedNationality.value == null) {
      Utils.scrollToTextField(nationalityNode);
      return;
    }
  }

  onChangeEmail(String? value) {
    if (individual?.accountInfo?.email == value) {
      isEmailVerified.value = true;
    } else {
      isEmailVerified.value = false;
    }
  }

  inItController(int index) {
    subTabController =
        TabController(vsync: this, length: 2, initialIndex: index);
    currentSubTabIndex.value = index;
    subTabController?.addListener(_subTabListener);
  }

  _subTabListener() {
    currentSubTabIndex.value = subTabController!.index;
    scrollToTop();
  }

  void scrollToTop() {
    scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  addFile() async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      CroppedFile? file = await Utils.imageCropper(image.path);
      if (file != null) {
        imageFile = XFile(file.path);
        uploadPicture();
      }
    }
  }

  setAsDefaultAddress(int index) {
    Address? address =
        addresses.firstWhereOrNull((element) => element.isDefault == true);
    if (address != null) {
      int index = addresses.indexOf(address);
      addresses[index].isDefault = false;
    }
    addresses[index].isDefault = true;
    addresses.refresh();
  }

  Future fetchAdditionalDocuments() async {
    final result = await getAdditionalDocuments(
        endPoint: "${ApiConstant.additionalDocuments}/4/$userId/4");
    additionalDocuments.value = result;
  }

  Future saveAdditionalDocuments() async {
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
      "accountId": 0,
      "userId": userId,
      "documentAssociatedId": 4,
      "projectId": 0
    };
    await addAdditionalDocuments(body: body);
  }

  uploadPicture() async {
    Utils.showLoadingDialog();
    final result = await uploadImage(filePath: imageFile!.path);
    Utils.hideLoadingDialog();
    if (result != null) {
      profileImageController.text = result;
      photo = "${FlavorConfig.storageUrl}$result";
    }
  }

  Future fetchNationality() async {
    final result = await getCountryAndNationality();
    countriesList.value = result.countries;
    nationalitiesList.value = result.nationalities;
    fetchProfile();
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
            (emirate) => emirate.value == contactInfo.stateId);
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

  fetchCities({bool fromApi = false}) async {
    if (!fromApi) Utils.showLoadingDialog();
    int id = selectedEmirate.value!.value;
    citiesList.clear();
    selectedCity.value = null;
    final result = await getLookUpData(endPoint: "${ApiConstant.cities}/$id");
    if (result.isNotEmpty) {
      citiesList.value = result;
      if (fromApi) {
        LookupData? city = citiesList
            .firstWhereOrNull((city) => city.value == contactInfo.cityId);
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
        LookupData? city = citiesList
            .firstWhereOrNull((city) => city.value == contactInfo.cityId);
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
    if (individual != null) {
      accountInfo = individual!.accountInfo!;

      accountStatus.value = user.status ?? 0;
      userNameController.text = accountInfo.userName;
      emailController.text = accountInfo.email;
      fNameArabicController.text = accountInfo.firstNameArabic;
      lNameArabicController.text = accountInfo.lastNameArabic;
      fNameController.text = accountInfo.firstName;
      isEmailVerified.value = accountInfo.emailConfirmed;
      lNameController.text = accountInfo.lastName;
      if (accountInfo.dob != null) {
        dobController.text = Utils.dateFormat1.format(accountInfo.dob!);
      }
      uaeIDController.text = accountInfo.emirateId;
      if (accountInfo.photo != null) {
        photo = accountInfo.photo;
        profileImageController.text = photo!;
      }
      if (accountInfo.gender != null) {
        selectedGender.value = genders
            .firstWhereOrNull((gender) => gender.value == accountInfo.gender);
      }
      if (accountInfo.nationalityId != null) {
        LookupData? nationality = nationalitiesList.firstWhereOrNull(
            (nationality) => nationality.value == accountInfo.nationalityId);
        selectedNationality.value = nationality;
        if (nationality != null) {
          accountViewModel.nationality.value = Utils.isArabic
              ? nationality.nameAr ?? nationality.name
              : nationality.name;
        }
      }
      contactInfo = individual!.contactInfo!;
      primaryMobileController.text = contactInfo.mobile;
      secondaryMobileController.text = contactInfo.additionalMobileNumber;
      poBoxController.text = contactInfo.poBox;
      isPhoneVerified.value = contactInfo.phoneNumberConfirmed;
      addresses.value = contactInfo.addresses;
      if (contactInfo.countryResidenceId != null) {
        LookupData? country = countriesList.firstWhereOrNull((nationality) =>
            nationality.value == contactInfo.countryResidenceId);
        if (country != null) {
          selectedCountry.value = country;
          accountViewModel.country.value =
              Utils.isArabic ? country.nameAr ?? country.name : country.name;
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

  saveContactInfo() async {
    final isValid = contactFormKey.currentState!.validate();
    if (!isValid) {
      if (Utils.isEmpty(primaryMobileController.text)) {
        Utils.scrollToTextField(primaryPhoneNode);
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
    if (!Validator.validatePhone(primaryMobileController.text)) {
      Utils.showGlobalSnackBar(
          message: "${"mobileNumberPrimary".tr} ${"isInvalid".tr}");
      return;
    }

    if (primaryMobileController.text == secondaryMobileController.text) {
      Utils.showGlobalSnackBar(message: "mobileNotSame".tr);
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
    contactFormKey.currentState!.save();
    if(!isEmailVerified.value){
      Utils.showGlobalSnackBar(message: "verifyYourEmail".tr);
      return;
    }
    final User? switchAccountUser = switchAccountBox.isNotEmpty?switchAccountBox.getAt(0):null;
    if(switchAccountUser!=null&&switchAccountUser.roles.length>1&&emailController.text!=user.email){
      updateEmailAddressPopUp(onConfirm: () {
        Get.back();
        saveDonorData();
      });
    }else{
      saveDonorData();
    }

  }

  saveDonorData() async {
    Utils.showLoadingDialog();
    int countryResidenceId = selectedCountry.value!.value;
    int? stateId;
    if (isUAE.value) {
      stateId = selectedEmirate.value!.value;
    }

    int cityId = selectedCity.value!.value;

    if (additionalDocuments.isNotEmpty) await saveAdditionalDocuments();
    late int nationalityId;
    if (selectedNationality.value != null) {
      nationalityId = selectedNationality.value!.value;
    }

    late DateTime dateOfBirth;
    if (picked != null) {
      dateOfBirth = picked!;
    } else if (accountInfo.dob != null) {
      dateOfBirth = accountInfo.dob!;
    }

    var accountInfoBody = {
      "userId": userId,
      "userName": userNameController.text,
      "email": emailController.text,
      "firstNameArabic": fNameArabicController.text,
      "lastNameArabic": lNameArabicController.text,
      "firstName": fNameController.text,
      "lastName": lNameController.text,
      if (dobController.text.isNotEmpty) "dob": dateOfBirth.toString(),
      if (selectedGender.value != null) "gender": selectedGender.value!.value,
      if (uaeIDController.text.isNotEmpty) "emirateId": uaeIDController.text,
      if (selectedNationality.value != null) "nationalityId": nationalityId,
      if (photo != null) "photo": photo
    };

    var accountContactBody = {
      "userId": userId,
      "mobile": primaryMobileController.text,
      "additionalMobileNumber": secondaryMobileController.text,
      "countryResidenceId": countryResidenceId,
      if (isUAE.value) "stateId": stateId,
      "cityId": cityId,
      if (poBoxController.text.isNotEmpty) "poBox": poBoxController.text,
      "addresses": addresses.toJson()
    };

    var body = {
      "accountInfo": accountInfoBody,
      "accountContact": accountContactBody
    };
    ApiResponse apiResponse = await donorRepo.updateDonorProfile(
        request: RequestBody(body: body, queryParameters: {"userId": userId}));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      user.firstNameArabic = accountInfoBody["firstNameArabic"];
      user.lastNameArabic = accountInfoBody["lastNameArabic"];
      user.firstName = accountInfoBody["firstName"];
      user.lastName = accountInfoBody["lastName"];
      if (photo != null) user.photo = accountInfoBody["photo"];
      accountStatus.value = 1;
      user.status = 1;
      userBox.putAt(0, user);
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  dobPickerDialog() async {
    DateTime dateTime = DateTime.now();
    picked = await showDatePicker(
      context: Get.context!,
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      initialDate: DateTime(dateTime.year - 18),
      firstDate: DateTime(1950),
      fieldHintText: "dd/mm/yyyy",
      lastDate: DateTime(dateTime.year - 18),
    );
    if (picked != null) {
      dobController.text = Utils.dateFormat1.format(picked!);
    }
  }

  navigateToContactInfo() {
    final isValid = accountFormKey.currentState!.validate();
    if (!isValid) {
      validateTextFields();
      return;
    }
    if (selectedGender.value == null) {
      Utils.showGlobalSnackBar(message: "${"gender".tr} ${"isRequired".tr}");
      return;
    }
    String uaeID = uaeIDController.text;
    if (uaeID.isNotEmpty) {
      if (!Validator.validateEmirateId(uaeID)) {
        Utils.showGlobalSnackBar(message: "invalidEmirateId".tr);
        return;
      }
    }
    if (selectedNationality.value == null) {
      Utils.showGlobalSnackBar(
          message: "${"nationality".tr} ${"isRequired".tr}");
      return;
    }
    if(!isEmailVerified.value){
      Utils.showGlobalSnackBar(message: "verifyYourEmail".tr);
      scrollToTop();
      return;
    }
    currentSubTabIndex.value = 1;
    subTabController?.animateTo(1);
    scrollToTop();
  }

  sendOTP(String userName,{bool isEmail=false}) async {
    if (userName.trim().isEmpty) {
      return;
    }
    Utils.showLoadingDialog();
    var body = {"userName": userName, "userId": userId};
    final result = await generateOTPForUser(body);
    Utils.hideLoadingDialog();
    if (result != null) {
      Utils.showFrontEndSnackBar(message: result);
      verifyOtpDialog(
          userName: userName,
          onVerify: (otpCode) {
            if(Get.isSnackbarOpen){
              return;
            }
            validateOtp(userName: accountInfo.userName, otp: otpCode,isEmail:isEmail);
          });
    }
  }

  validateOtp({required String userName, required String otp,required bool isEmail}) async {
    Utils.showLoadingDialog();
    var body = {"userName": userName, "otp": otp};
    ApiResponse apiResponse =
        await otpRepo.validateOTP(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (isEmail) {
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

  onChangeCountry(LookupData? value) {
    if (selectedCountry.value?.value == value?.value) {
      return;
    }
    selectedCountry.value = value;
    checkUAE();
    fetchEmirates();
  }

  onChangeEmirate(LookupData value) {
    if (selectedEmirate.value == value) {
      return;
    }
    selectedEmirate.value = value;
    fetchCities();
  }

  editAddress(int index) async {
    Get.delete<AddressViewModel>();
    Get.put(AddressViewModel());
    final result = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(address: addresses[index]),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      addresses[index] = result;
      addresses.refresh();
    }
  }

  addNewAddress() async {
    Get.delete<AddressViewModel>();
    Get.put(AddressViewModel());
    final result = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => const AddAddressScreen(),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      addresses.add(result);
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    emailController.dispose();
    fNameArabicController.dispose();
    lNameArabicController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    dobController.dispose();
    genderController.dispose();
    uaeIDController.dispose();
    nationalityController.dispose();
    profileImageController.dispose();
    primaryMobileController.dispose();
    secondaryMobileController.dispose();
    poBoxController.dispose();

    emirateIdNode.dispose();
    primaryPhoneNode.dispose();
    secondaryPhoneNode.dispose();
    userNameNode.dispose();
    fNameArabicNode.dispose();
    lNameArabicNode.dispose();
    fNameNode.dispose();
    lNameNode.dispose();
    genderNode.dispose();
    nationalityNode.dispose();
    countryNode.dispose();
    emirateNode.dispose();
    cityNode.dispose();

    scrollController.dispose();

    subTabController?.removeListener(_subTabListener);
    subTabController?.dispose();

    isUAE.close();
    currentSubTabIndex.close();
    selectedGender.close();
    nationalitiesList.close();
    selectedNationality.close();
    isEdit.close();
    showAdditionalDocuments.close();
    additionalDocuments.close();
    isEmailVerified.close();
    isPhoneVerified.close();
    countriesList.close();
    emiratesList.close();
    citiesList.close();
    selectedCountry.close();
    selectedEmirate.close();
    selectedCity.close();
    setAsDefault.close();
    addresses.close();
    super.onClose();
  }
}
