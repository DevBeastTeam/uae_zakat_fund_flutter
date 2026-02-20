import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/project_data.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/sahem_bank.dart';
import 'package:zakat_fund/model/smtp_config.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/company_repo.dart';
import 'package:zakat_fund/repository/fund_request_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/individual_repo.dart';
import 'package:zakat_fund/repository/payment_repo.dart';
import 'package:zakat_fund/repository/smtp_config_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/donor/individual/add_address_screen.dart';
import 'package:zakat_fund/view/web_view/web_view_screen.dart';
import 'package:zakat_fund/view_model/address_view_model.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/view_model/web_view_model.dart';

class PaymentMethodViewModel extends GetxController
    with GetTickerProviderStateMixin, GenericMixin {
  final bool isCart;
  late final TabController tabController;

  List<Categories> tabs = [];

  List<Categories> offlinePayTabs = [];

  final repo = PaymentRepoImpl();
  final genericRepo = GenericRepoImpl();
  final individualRepo = IndividualRepoImpl();
  final companyRepo = CompanyRepoImpl();
  final smtpRepo = SmtpConfigRepoImpl();
  final fundRepo = FundRequestRepoImpl();

  final Rxn<String> selectedCashCollectionTiming = Rxn<String>();
  final Rxn<String> selectedChequeCollectionTiming = Rxn<String>();
  final RxInt currentTabIndex = 0.obs;
  final RxInt offlinePayTabIndex = 0.obs;
  final RxBool showWalletDashboard = true.obs;
  final RxInt walletBalance = 0.obs;
  final Rxn<LookupData> selectedBankCheck = Rxn<LookupData>();
  final Rxn<String> selectedBankTransfer = Rxn<String>();
  final Rxn<File> chequeFile = Rxn<File>();
  final Rxn<File> depositFile = Rxn<File>();
  final RxList<Address> addresses = <Address>[].obs;
  RxList<LookupData> banksList = <LookupData>[].obs;
  List<SahemBank> sahemBanksList = [];
  RxList<String> sahemBanks = <String>[].obs;

  final chequeNumberController = TextEditingController();
  final amountController = TextEditingController();
  final chequePhotoController = TextEditingController();
  final chequeDateController = TextEditingController();
  final chequeCollectionDateController = TextEditingController();
  final topUpAmount = TextEditingController();
  final topUpCardNumber = TextEditingController();
  final topUpCardHolderName = TextEditingController();
  final topUpExpiryDate = TextEditingController();
  final topUpCardCvc = TextEditingController();
  final transferAmountController = TextEditingController();
  final transferDateController = TextEditingController();
  final transferEmailController = TextEditingController();
  final transferPhoneController = TextEditingController();
  final transferPayerNameController = TextEditingController();
  final bankReceiptController = TextEditingController();
  final cashAmountController = TextEditingController();
  final cashCollectionDateController = TextEditingController();
  final accountHolderController = TextEditingController();
  final ibanNumberController = TextEditingController();

  final cashFormKey = GlobalKey<FormState>();
  final bankFormKey = GlobalKey<FormState>();
  final depositFormKey = GlobalKey<FormState>();

  final dpfNameController = TextEditingController();
  final dplNameController = TextEditingController();
  final dpPhoneController = TextEditingController();
  final dpEmailController = TextEditingController();

  final dpFormKey = GlobalKey<FormState>();

  final dateFormat = DateFormat("MM/yy");
  late int amount;
  late String chequeImage;
  bool isInit = false;
  RxBool isLoading = true.obs;
  bool showWallet = false;
  bool showOnlinePayment = false;
  bool showOfflinePayment = false;
  bool showCreditCard = false;
  bool showApplePay = false;
  bool showGooglePay = false;
  bool showCash = false;
  bool showDeposit = false;
  bool showBank = false;

  DateTime? pickedEstablishment;
  DateTime? pickedExpiry;
  DateTime? pickedChequeDate;
  DateTime? pickedChequeCollectionDate;
  DateTime? pickedCashDate;
  DateTime? picked;
  RxInt selectedAddress = 0.obs;
  late Individual individual;
  late Company company;

  final paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  PaymentMethodViewModel(this.isCart);

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.paymentScreen);
    if (userBox.isNotEmpty) {
      User user = userBox.getAt(0);
      transferEmailController.text = user.email ?? "";
      transferPhoneController.text = user.mobile ?? "";
      transferPayerNameController.text = Utils.isArabic
          ? "${user.firstNameArabic ?? ""} ${user.lastNameArabic ?? ""}"
          : "${user.firstName ?? ""} ${user.lastName ?? ""}";
    }
    amount = isCart
        ? Get.find<CartViewModel>().totalAmount.value
        : Get.find<MainViewModel>().getTotalAmount();
    String formattedAmount = "$amount ${"currency".tr}";
    cashAmountController.text = formattedAmount;
    amountController.text = formattedAmount;
    transferAmountController.text = formattedAmount;
    try {
      Utils.showLoadingDialog();
      await Future.wait([
        fetchBanks(),
        fetchSahemBanks(),
        if (userBox.isNotEmpty) ...[
          fetchWalletBalance(),
          fetchAddresses(),
        ],
        fetchPaymentMethods()
      ]);
    } finally {
      Utils.hideLoadingDialog();
    }
    if (tabs.isEmpty) initTabController();
    isLoading.value = false;
  }

  void _tabChangeListener() {
    if (currentTabIndex.value == tabController.index) return;
    currentTabIndex.value = tabController.index;
    if (showWallet && tabs[currentTabIndex.value].name == "myWallet") {
      showWalletDashboard.value = true;
      fetchWalletBalance(topUp: true);
    }
  }

  void handleCreditCardTap() {
    // createPayment();
    return;
    Utils.logEvent(name: EventConstant.creditCardPaymentMethodSelected);
    Get.delete<WebViewModel>();
    final String url = _buildPaymentUrl();
    Get.put(WebViewModel(title: "creditDebitCard".tr, url: url));
    Navigator.push(
      Get.context!,
      MaterialPageRoute(builder: (_) => const WebViewScreen()),
    ).then((_) => Get.delete<WebViewModel>());
  }

  String _buildPaymentUrl() {
    final bool isGuest = userBox.isEmpty;
    final bool isQuickDonate = !isCart;
    final String langCode = Utils.isArabic ? "ar" : "en";

    if (isGuest) {
      final guestId = uuidBox.getAt(0);
      return '${FlavorConfig.baseUrl.replaceAll("/api", "")}${ApiConstant.creditDebitPayment}'
          '?userId=0&isQuickDonate=$isQuickDonate&isGuest=true'
          '&GuestId=$guestId&AccountID=0&Role=Guest&langCode=$langCode';
    } else {
      final user = userBox.getAt(0);
      return '${FlavorConfig.baseUrl.replaceAll("/api", "")}${ApiConstant.creditDebitPayment}'
          '?token=${user.bearerToken}&userId=${user.empId}&AccountID=${user.accountId ?? 0}'
          '&Role=${user.roles[0]}&isQuickDonate=$isQuickDonate&langCode=$langCode';
    }
  }

  datePickerDialog(
      {bool collection = false,
      bool transfer = false,
      bool chequeDate = false,
      bool cash = false}) async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      fieldHintText: "dd/mm/yyyy",
      context: Get.context!,
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      initialDate: DateTime(dateTime.year, dateTime.month, dateTime.day + 1),
      firstDate: DateTime(dateTime.year, dateTime.month, dateTime.day + 1),
      lastDate: DateTime(dateTime.year + 50),
    );
    String date = Utils.dateFormat1.format(picked!);
    if (collection) {
      pickedChequeCollectionDate = picked;
      chequeCollectionDateController.text = date;
    } else if (transfer) {
      pickedExpiry = picked;
      transferDateController.text = date;
    } else if (cash) {
      pickedCashDate = picked;
      cashCollectionDateController.text = date;
    } else if (chequeDate) {
      pickedChequeDate = picked;
      chequeDateController.text = date;
    }
  }

  dobPickerDialog() async {
    picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      fieldHintText: "dd/mm/yyyy",
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      String date = Utils.dateFormat1.format(picked!);
      pickedExpiry = picked;
      transferDateController.text = date;
    }
  }

  addFile({bool bankReceipt = false}) async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      final imageFile = File(image.path);
      if (bankReceipt) {
        depositFile.value = imageFile;
        bankReceiptController.text = Utils.fileName(image.path);
      } else {
        chequeFile.value = imageFile;
        chequePhotoController.text = Utils.fileName(image.path);
      }
      await uploadPicture();
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
    if (getUser.roles[0] == "Individuals") {
      updateDonorAddress();
    } else if (getUser.roles[0] == "Companies") {
      updateCompanyAddress();
    }
  }

  openReceiptScreen() {
    if (userBox.isEmpty) {
      Get.toNamed(AppRoutes.logInScreen);
      return;
    }
    if (!validateFormAndAddress()) return;
    payOfflinePayment();
  }

  bool validateFormAndAddress() {
    bool isValid = false;
    switch (offlinePayTabIndex.value) {
      case 0:
        isValid = cashFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = bankFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = depositFormKey.currentState?.validate() ?? false;
        break;
    }

    if (!isValid) {
      return false;
    }
    if (addresses.isEmpty && offlinePayTabIndex.value != 2) {
      Utils.showGlobalSnackBar(message: "${"address".tr} ${"isRequired".tr}");
      return false;
    }
    return true;
  }

  payOfflinePayment() async {
    final Address? collectionPoint = _getCollectionPoint();
    final User user = userBox.getAt(0);
    final int userId = user.empId!;
    final int? bankId = _getBankIdIfNeeded();

    final List<Map<String, dynamic>> projectList = _getProjectList();
    final Map<String, dynamic> body = _buildPaymentBody(
      tabIndex: offlinePayTabIndex.value,
      collectionPoint: collectionPoint,
      bankId: bankId,
      userId: userId,
      projectList: projectList,
    );
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await repo.offlinePayment(request: RequestBody(body: body));
    if (apiResponse.appState == AppState.onSuccess) {
      fetchTransactionDetails(apiResponse.data);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.hideLoadingDialog();
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  Address? _getCollectionPoint() {
    final defaultAddress = addresses[selectedAddress.value];
    return offlinePayTabIndex.value != 2
        ? defaultAddress ?? addresses.first
        : defaultAddress;
  }

  int? _getBankIdIfNeeded() {
    if (offlinePayTabIndex.value == 0) return null;
    int bankId = 0;
    if (offlinePayTabIndex.value == 1) {
      bankId = selectedBankCheck.value!.value;
    } else {
      final selectedBankName = selectedBankTransfer.value;
      SahemBank? bank = sahemBanksList.firstWhereOrNull((bank) {
        final bankName = Utils.isArabic ? bank.bankNameArabic : bank.bankName;
        return bankName == selectedBankName;
      });
      if (bank != null) {
        bankId = bank.id;
      }
    }
    return bankId;
  }

  List<Map<String, dynamic>> _getProjectList() {
    if (isCart || currentTabIndex.value != 2) return [];
    return Get.find<MainViewModel>()
        .selectedProjectsList
        .map((proj) =>
            ProjectData(projectId: proj.projectId!, amount: proj.price)
                .toJson())
        .toList();
  }

  Map<String, dynamic> _buildPaymentBody({
    required int tabIndex,
    required Address? collectionPoint,
    required int? bankId,
    required int userId,
    required List<Map<String, dynamic>> projectList,
  }) {
    final address =
        "${collectionPoint?.street} ${collectionPoint?.building} ${collectionPoint?.landmark}";

    late final Map<String, dynamic> body;

    switch (tabIndex) {
      case 0:
        Utils.logEvent(name: EventConstant.cashPaymentMethodSelected);
        body = {
          "payment":
              cashAmountController.text.replaceAll(" ${"currency".tr}", ""),
          "collectionDate": pickedCashDate.toString(),
          "collectionTime": selectedCashCollectionTiming.value,
          "collectionPoint": address,
        };
        break;

      case 1:
        Utils.logEvent(name: EventConstant.chequePaymentMethodSelected);
        body = {
          "payment": amountController.text.replaceAll(" ${"currency".tr}", ""),
          "collectionDate": pickedChequeCollectionDate.toString(),
          "collectionTime": selectedChequeCollectionTiming.value,
          "collectionPoint": address,
          "bankId": bankId,
          "chequeNo": chequeNumberController.text,
          "chequePhoto": chequeImage,
          "chequeDate": pickedChequeDate.toString(),
        };
        break;

      default:
        Utils.logEvent(name: EventConstant.depositPaymentMethodSelected);
        body = {
          "payment":
              transferAmountController.text.replaceAll(" ${"currency".tr}", ""),
          "bankId": bankId,
          "chequePhoto": chequeImage,
          "chequeDate": pickedExpiry.toString(),
          "emailAddress": transferEmailController.text,
          "phoneNumber": transferPhoneController.text,
          "payersName": transferPayerNameController.text,
          "chequeNo": chequeNumberController.text,
        };
    }

    return {
      ...body,
      "paymentType": tabIndex + 2,
      "userId": userId,
      if (projectList.isNotEmpty) "projectList": projectList,
    };
  }

  fetchTransactionDetails(int id, {bool fromWallet = false}) async {
    final result = await getTransactionDetails({"transactionId": id});
    Utils.hideLoadingDialog();
    if (result != null) {
      if (isCart) {
        Get.find<CartViewModel>()
          ..cart.clear()
          ..cartCount.value = 0;
      } else {
        Get.back();
      }
      ReceiptDetails details = result;
      Get.toNamed(
        AppRoutes.paymentReceiptScreen,
        arguments: {
          "transactionDetails": details,
          "type": fromWallet ? -1 : offlinePayTabIndex.value,
        },
      );
    }
  }

  Future uploadPicture() async {
    String filePath = "";
    if (offlinePayTabIndex.value == 1) {
      filePath = chequeFile.value!.path;
    } else {
      filePath = depositFile.value!.path;
    }
    Utils.showLoadingDialog();
    final result = await uploadImage(filePath: filePath);
    Utils.hideLoadingDialog();
    if (result != null) {
      chequeImage = result;
    }
  }

  Future fetchBanks() async {
    final result = await getAllBanks();
    if (result.isNotEmpty) {
      banksList.value = result;
    }
  }

  Future fetchSahemBanks() async {
    ApiResponse apiResponse =
        await fundRepo.fetchSahemBank(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      sahemBanksList = apiResponse.data;
      sahemBanks.value = sahemBanksList.map((bank) => bank.bankName).toList();
      sahemBanks.refresh();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  String? url;
  String? sessionID;
  Future createPayment() async {
    final bool isGuest = userBox.isEmpty;
    final bool isQuickDonate = !isCart;
    final String langCode = Utils.isArabic ? "ar" : "en";
    int userId = 0;
    String? guestId;
    if (isGuest) {
      guestId = uuidBox.getAt(0);
    } else {
      final user = userBox.getAt(0);
      userId = user.empId;
    }

    Utils.showLoadingDialog();
    ApiResponse apiResponse = await genericRepo.createDubaiPayment(
        request: RequestBody(body: {
      "userId": userId,
      "guestId": guestId,
      "isGuest": isGuest,
      // "isQuickDonate": isQuickDonate,
      "isMobile": false
    }));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel data = apiResponse.data;
      if (data.paymentUri == null) {
        Utils.showGlobalSnackBar(
            message: 'Something went wrong try again later');
        return;
      }
      url = data.paymentUri!;
      sessionID = data.sessionId;
      openPaymentPage();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  openPaymentPage() {
    Utils.logEvent(name: EventConstant.creditCardPaymentMethodSelected);
    Get.delete<WebViewModel>();
    Get.put(
        WebViewModel(title: "dubaiPay".tr, url: url!, sessionId: sessionID));
    Navigator.push(
      Get.context!,
      MaterialPageRoute(builder: (_) => const WebViewScreen()),
    ).then((_) => Get.delete<WebViewModel>());
  }

  Future addGuestUser() async {
    if (url != null) {
      openPaymentPage();
      return;
    }
    if (userBox.isNotEmpty) {
      createPayment();
      return;
    }
    Utils.showLoadingDialog();
    String guestId = uuidBox.getAt(0);
    ApiResponse apiResponse = await genericRepo.adduestUserDP(
        request: RequestBody(body: {
      "FirstName": dpfNameController.text,
      "LastName": dplNameController.text,
      "MobileNo": dpPhoneController.text,
      "Email": dpEmailController.text,
      "GuestId": guestId
    }));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      createPayment();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  Future fetchWalletBalance({bool topUp = false}) async {
    if (userBox.isEmpty) {
      return;
    }
    if (topUp) Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.fetchWalletBalance(
        request: RequestBody(
            endPoint:
                "${ApiConstant.walletBalance}/${userBox.getAt(0).empId}"));
    if (topUp) Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      walletBalance.value = apiResponse.data.toInt();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  payViaWallet() async {
    if (userBox.isEmpty) {
      Get.toNamed(AppRoutes.logInScreen);
      return;
    }
    if (walletBalance < amount) {
      showWalletDashboard.value = false;
      return;
    }
    Utils.logEvent(name: EventConstant.walletPaymentMethodSelected);
    Utils.showLoadingDialog();
    final body = _buildWalletPaymentBody();
    ApiResponse apiResponse =
        await repo.payViaWallet(request: RequestBody(body: body));

    if (apiResponse.appState == AppState.onSuccess) {
      fetchTransactionDetails(int.parse(apiResponse.data), fromWallet: true);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.hideLoadingDialog();
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  Map<String, dynamic> _buildWalletPaymentBody() {
    final userId = userBox.getAt(0).empId!;
    if (isCart) {
      return {
        "userId": userId,
        "isQuickDonate": false,
      };
    }
    final projectList = Get.find<MainViewModel>()
        .selectedProjectsList
        .map((proj) =>
            ProjectData(projectId: proj.projectId!, amount: proj.price)
                .toJson())
        .toList();

    return {
      "userId": userId,
      "isQuickDonate": true,
      "projectList": projectList,
    };
  }

  topUpWallet() {
    if (userBox.isEmpty) {
      Get.toNamed(AppRoutes.logInScreen);
      return;
    }
    Get.delete<WebViewModel>();
    User user = userBox.getAt(0);
    String url =
        '${FlavorConfig.baseUrl.replaceAll("/api", "")}${ApiConstant.walletPayment}?token=${user.bearerToken}&userId=${user.empId}&langCode=${Utils.isArabic ? "ar" : "en"}';
    Get.put(WebViewModel(
      title: "topUpWalletHeading".tr,
      url: url,
    ));
    Navigator.push(Get.context!,
        MaterialPageRoute(builder: (BuildContext context) {
      return const WebViewScreen();
    })).then((val) async {
      Get.delete<WebViewModel>();
      if (val != null && val) {
        showWalletDashboard.value = true;
        await fetchWalletBalance(topUp: true);
      }
    });
  }

  updateOfflinePaymentTabs(int index) => offlinePayTabIndex.value = index;

  onChangeDepositBank(LookupData? value) => selectedBankCheck.value = value;

  onChangeCashCollectionTiming(String? value) =>
      selectedCashCollectionTiming.value = value!;

  onChangeChequeCollectionTiming(String? value) =>
      selectedChequeCollectionTiming.value = value!;

  onChangeChequeBank(String? value) {
    selectedBankTransfer.value = value;
    SahemBank? bank = sahemBanksList.firstWhereOrNull((bank) {
      final bankName = Utils.isArabic ? bank.bankNameArabic : bank.bankName;
      return bankName == value;
    });
    if (bank != null) {
      accountHolderController.text = Utils.isArabic
          ? bank.accountHolderNameArabic
          : bank.accountHolderName;
      ibanNumberController.text = bank.iban;
    }
  }

  editAddress(int index, Address address) async {
    Get.delete<AddressViewModel>();
    Get.put(AddressViewModel());
    final result = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (_) => AddAddressScreen(address: address),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      addresses[index] = result;
      addresses.refresh();
      if (getUser.roles[0] == "Individuals") {
        updateDonorAddress();
      } else if (getUser.roles[0] == "Companies") {
        updateCompanyAddress();
      }
    }
  }

  removeAddress(int index) {
    addresses.removeAt(index);
    addresses.refresh();
    if (addresses.isEmpty) {
      selectedAddress.value = 3;
    } else {
      selectedAddress.value = 0;
    }
    if (getUser.roles[0] == "Individuals") {
      updateDonorAddress();
    } else if (getUser.roles[0] == "Companies") {
      updateCompanyAddress();
    }
  }

  addNewAddress() async {
    if (userBox.isEmpty) {
      Get.toNamed(AppRoutes.logInScreen);
      return;
    }
    Get.delete<AddressViewModel>();
    Get.put(AddressViewModel());
    final result = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (_) => const AddAddressScreen(),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      if (addresses.isEmpty) {
        selectedAddress.value = 0;
      }
      addresses.add(result);

      if (getUser.roles[0] == "Individuals") {
        updateDonorAddress();
      } else if (getUser.roles[0] == "Companies") {
        updateCompanyAddress();
      }
    }
  }

  updateDonorAddress() async {
    try {
      individual.contactInfo!.addresses = List.from(addresses);
      DonorContactInfo contactInfo = individual.contactInfo!;
      AccountInfo accountInfo = individual.accountInfo!;
      Utils.showLoadingDialog();
      var body = {
        "accountInfo": accountInfo.toJson(),
        "accountContact": contactInfo.toJson()
      };
      ApiResponse apiResponse = await individualRepo.updateDonorProfile(
          request: RequestBody(
              body: jsonEncode(body), queryParameters: {"userId": getUser.id}));
      Utils.hideLoadingDialog();
    } catch (_) {
      Utils.hideLoadingDialog();
    }
  }

  updateCompanyAddress() async {
    try {
      company.accountContact!.addresses = List.from(addresses);
      CompanyInfo accountInfo = company.accountInfo!;
      ContactInfo accountContact = company.accountContact!;
      AccountRepresentative accountRepresentative =
          company.accountRepresentative!;
      BankAccount bankAccount = company.bankAccount!;
      Utils.showLoadingDialog();
      var queryParameters = {
        "resubmitForApproval": false,
      };
      var body = {
        "accountInfo": accountInfo.toJson(),
        "accountContact": accountContact.toJson(),
        "accountRepresentative": accountRepresentative.toJson(),
        "bankAccount": bankAccount.toJson()
      };
      ApiResponse apiResponse = await companyRepo.updateCompany(
          request: RequestBody(
              endPoint:
                  "${ApiConstant.updateCompany}/${getUser.id}/${getUser.accountId}",
              body: jsonEncode(body),
              queryParameters: queryParameters));
      Utils.hideLoadingDialog();
    } catch (e) {
      Utils.hideLoadingDialog();
    }
  }

  Future fetchAddresses() async {
    if (getUser.roles[0] == "Individuals") {
      await fetchDonorProfile();
    } else if (getUser.roles[0] == "Companies") {
      await fetchCompanyProfile();
    }
    Address? address =
        addresses.firstWhereOrNull((address) => address.isDefault);
    if (address != null) {
      selectedAddress.value = addresses.indexOf(address);
    }
  }

  User get getUser => userBox.getAt(0);

  Future fetchCompanyProfile() async {
    try {
      ApiResponse apiResponse = await companyRepo.fetchCompanyProfile(
          request: RequestBody(
              endPoint:
                  "${ApiConstant.companyProfile}/${getUser.id}/${getUser.accountId ?? 0}"));
      if (apiResponse.appState == AppState.onSuccess) {
        company = apiResponse.data;
        if (company.accountContact != null) {
          Address address = company.accountContact!.addresses
              .firstWhere((address) => address.isDefault);
          selectedAddress.value =
              company.accountContact!.addresses.indexOf(address);
          addresses.value = company.accountContact!.addresses
              .map((address) => Address(
                    id: address.id,
                    addressType: address.addressType,
                    street: address.street,
                    building: address.building,
                    landmark: address.landmark,
                    isDefault: address.isDefault,
                    latitude: address.latitude,
                    longitude: address.longitude,
                  ))
              .toList();
        }
      } else {
        Utils.handleAPIError(apiResponse);
      }
    } catch (_) {}
  }

  Future fetchDonorProfile() async {
    try {
      ApiResponse apiResponse = await individualRepo.fetchProfile(
          request: RequestBody(
              endPoint: "${ApiConstant.donorProfile}/${getUser.id}"));
      if (apiResponse.appState == AppState.onSuccess) {
        individual = apiResponse.data;
        if (individual.contactInfo != null) {
          addresses.value = individual.contactInfo!.addresses
              .map((address) => Address(
                    id: address.id,
                    addressType: address.addressType,
                    street: address.street,
                    building: address.building,
                    landmark: address.landmark,
                    isDefault: address.isDefault,
                    latitude: address.latitude,
                    longitude: address.longitude,
                  ))
              .toList();
        }
      } else {
        Utils.handleAPIError(apiResponse);
      }
    } catch (_) {}
  }

  Future fetchPaymentMethods() async {
    ApiResponse apiResponse =
        await smtpRepo.getContactUs(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      List<SmtpConfig> contactUs = apiResponse.data;
      for (SmtpConfig config in contactUs) {
        bool show = config.value.toLowerCase() == "yes";
        String key = config.key;
        if (key == "MyWallet") {
          showWallet = show;
        } else if (key == "CreditDebitCard") {
          showCreditCard = show;
        } else if (key == "ApplePay") {
          showApplePay = show;
        } else if (key == "GooglePay") {
          showGooglePay = show;
        } else if (key == "Cash") {
          showCash = show;
        } else if (key == "BankCheque") {
          showBank = show;
        } else if (key == "Deposit") {
          showDeposit = show;
        }
      }
      if (showCreditCard ||
          showApplePay && Platform.isIOS ||
          showGooglePay && Platform.isAndroid) {
        showOnlinePayment = true;
      }
      if (showCash || showBank || showDeposit) {
        showOfflinePayment = true;
      }
      tabs = [
        if (showWallet)
          Categories(name: "myWallet", icon: AppResources.myWalletIcon),
        if (showOnlinePayment)
          Categories(name: "onlinePayment", icon: AppResources.onlinePayIcon),
        if (showOfflinePayment)
          Categories(name: "offlinePayment", icon: AppResources.offlinePayIcon),
      ];
      offlinePayTabs = [
        if (showCash) Categories(name: "cash", icon: AppResources.cashIcon),
        if (showBank)
          Categories(name: "bankCheque", icon: AppResources.bankChequeIcon),
        if (showDeposit)
          Categories(name: "deposit", icon: AppResources.bankTransferIcon),
      ];
      initTabController();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  initTabController() {
    tabController =
        TabController(vsync: this, length: tabs.length, initialIndex: 0);
    tabController.addListener(_tabChangeListener);
  }

  onAddressSelection(int index) => selectedAddress.value = index;

  @override
  void onClose() {
    tabController.removeListener(_tabChangeListener);
    tabController.dispose();

    chequeNumberController.dispose();
    amountController.dispose();
    chequePhotoController.dispose();
    chequeDateController.dispose();
    chequeCollectionDateController.dispose();
    topUpAmount.dispose();
    topUpCardNumber.dispose();
    topUpCardHolderName.dispose();
    topUpExpiryDate.dispose();
    topUpCardCvc.dispose();
    transferAmountController.dispose();
    transferDateController.dispose();
    transferEmailController.dispose();
    transferPhoneController.dispose();
    transferPayerNameController.dispose();
    bankReceiptController.dispose();
    cashAmountController.dispose();
    cashCollectionDateController.dispose();
    accountHolderController.dispose();
    ibanNumberController.dispose();

    currentTabIndex.close();
    offlinePayTabIndex.close();
    showWalletDashboard.close();
    walletBalance.close();
    selectedBankCheck.close();
    selectedBankTransfer.close();
    chequeFile.close();
    depositFile.close();
    addresses.close();
    sahemBanks.close();
    banksList.close();
    selectedCashCollectionTiming.close();
    selectedChequeCollectionTiming.close();
    super.onClose();
  }
}
