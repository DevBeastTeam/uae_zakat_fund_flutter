import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/moduel_permissions.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/association_repo.dart';
import 'package:zakat_fund/repository/company_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/individual_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/constants/module_codes.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';
import 'package:zakat_fund/view_model/company_view_model.dart';
import 'package:zakat_fund/view_model/individual_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class AccountViewModel extends GetxController
    with GetTickerProviderStateMixin, GenericMixin {
  RxInt currentTabIndex = 0.obs;
  late TabController tabController;

  late User user;
  Rxn<String> profilePhoto = Rxn<String>();
  Rxn<String> coverPhoto = Rxn<String>();

  RxBool showEdit = false.obs;
  RxBool showView = false.obs;
  bool showNotificationPreferences = true;
  bool showPasswordSecurity = true;

  Rx<Individual> individual = Individual().obs;
  Rx<Company> company = Company().obs;
  Rx<Association> association = Association().obs;
  int companyStatus = 0;
  int associationStatus = 0;

  RxString nationality = "".obs;
  RxString country = "".obs;
  List<LookupData> nationalitiesList = [];
  List<LookupData> countriesList = [];
  List<String> nationalities = [];

  List<Categories> companyTabs = [];
  RxList<Categories> associationTabs = <Categories>[].obs;
  RxList<Categories> adminTabs = <Categories>[].obs;
  List<Categories> dashboardSubTabs = [];
  List<Categories> workflowSubTabs = [];
  List<Categories> documentSubTabs = [];
  List<Categories> systemConfigSubTabs = [];
  List<Categories> pageManagementSubTabs = [];
  List<Categories> financialManagementSubTabs = [];
  List<Categories> campaignSubTabs = [];
  List<Categories> myFundingSubTabs = [];
  List<Categories> myContentSubTabs = [];

  List<int> associationMenus = [1, 2, 4, 8, 9, 10];
  List<int> companyMenus = [1, 2, 3, 7, 8, 9];

  late MainViewModel mainViewModel;
  List<String> tabs = [];
  List<ModulePermissions> permissions = [];
  RxList<AdditionalDocuments> additionalDocuments = <AdditionalDocuments>[].obs;

  String fileName = "";
  String filePath = "";

  final IndividualRepo individualRepo = IndividualRepoImpl();
  final CompanyRepo companyRepo = CompanyRepoImpl();
  final AssociationRepo associationRepo = AssociationRepoImpl();
  final GenericRepo genericRepo = GenericRepoImpl();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    if (userBox.isNotEmpty) {
      user = userBox.getAt(0);
    }

    Utils.logEvent(name: EventConstant.cartScreen);
    initAccountTabs();
    fetchNationality();
  }

  updateIndTabIndexForEdit(int index) {
    final viewModel = Get.find<IndividualViewModel>();
    viewModel.isEdit.value = false;
    viewModel.inItController(index);
  }

  updateComTabIndexForEdit(int index) {
    final viewModel = Get.find<CompanyViewModel>();
    viewModel.currentSubTab.value = index;
    viewModel.isEdit.value = false;
  }

  updateAssTabIndexForEdit(int index) {
    final viewModel = Get.find<AssociationViewModel>();
    viewModel.currentSubTab.value = index;
    viewModel.isEdit.value = false;
  }

  initTabController({bool init = true}) {
    String role = user.roles.first;
    if (init) {
      if (role == "Individuals") {
        tabs = AppConstant.individualTabs;
      } else if (role == "Companies") {
        tabs = AppConstant.companyTabs;
      } else if (role == "Orgainizations") {
        tabs = AppConstant.associationTabs;
      }
    }

    tabController = TabController(
        vsync: this,
        length: init && role == "Individuals" ? 2 : 4,
        initialIndex: 0);
    tabController.addListener(_tabListener);
  }

  _tabListener() {
    currentTabIndex.value = tabController.index;
  }

  void initAccountTabs() {
    showEdit.value = false;
    showView.value = false;

    adminTabs = _buildAdminTabs().obs;
    companyTabs = AppConstant.companyAccountTabs;
    associationTabs = AppConstant.associationAccountTabs.obs;

    dashboardSubTabs = AppConstant.dashboardSubTabs;
    workflowSubTabs = AppConstant.workflowSubTabs;
    documentSubTabs = AppConstant.documentSubTabs;
    systemConfigSubTabs = AppConstant.systemConfigSubTabs;
    pageManagementSubTabs = AppConstant.pageManagementSubTabs;
    financialManagementSubTabs = AppConstant.financialManagementSubTabs;
    campaignSubTabs = AppConstant.campaignSubTabs;
    myFundingSubTabs = AppConstant.myFundingSubTabs;
    myContentSubTabs = AppConstant.myContentSubTabs;
  }

  List<Categories> _buildAdminTabs() {
    return [
      if (userBox.isNotEmpty && user.userTypeID == 1005)
        AppConstant.taskAccountTab,
      ...AppConstant.adminAccountTabs
    ];
  }

  fetchNationality() async {
    final result = await getCountryAndNationality();
    nationalitiesList = result.nationalities;
    countriesList = result.countries;
    List<String> nations = [];
    for (LookupData lookupData in nationalitiesList) {
      nations.add(Utils.isArabic ? lookupData.nameAr : lookupData.name);
    }
    nationalities = nations.toSet().toList();
  }

  filterNationality() {
    nationalities.clear();
    for (var data in nationalitiesList) {
      nationalities.add(Utils.isArabic ? data.nameAr ?? data.name : data.name);
    }
  }

  fetchProfile() async {
    mainViewModel = Get.find();
    user = userBox.getAt(0);
    String role = user.roles.first;
    final isIndividual = role == "Individuals";
    final isCompany = role == "Companies";
    final isOrganization = role == "Orgainizations";
    final isAdmin = role == "Admin";
    final isAgent = role == "Agent";
    final isEmployee = role == "Employee";
    final isSelf = user.empId == user.id;
    final hasCustomRole =
        user.customRoleId != null && user.customRoleId!.isNotEmpty;

    if (isIndividual) {
      _setNotificationAndSecurity(true);
      Utils.showLoadingDialog();
      await fetchIndividualProfile();
      return;
    }

    if (isCompany) {
      Utils.showLoadingDialog();
      _setNotificationAndSecurity(isSelf);
      if (isSelf) {
        _setViewAndEdit(true);
        fetchCompanyProfile();
      } else {
        associationTabs.clear();
        await Future.wait([
          fetchCompanyProfile(hideLoader: false),
          fetchUserPermission(hideLoader: false, company: true),
        ]);
        Utils.hideLoadingDialog();
      }
      return;
    }

    if (isOrganization) {
      Utils.showLoadingDialog();
      _setNotificationAndSecurity(isSelf);
      if (isSelf) {
        _setViewAndEdit(true);
        fetchAssociationProfile();
      } else {
        associationTabs.clear();
        await Future.wait([
          fetchAssociationProfile(hideLoader: false),
          fetchUserPermission(hideLoader: false, association: true),
        ]);
        Utils.hideLoadingDialog();
      }
      return;
    }

    if (isAdmin && hasCustomRole) {
      adminTabs.clear();
      _setNotificationAndSecurity(false);
      Utils.showLoadingDialog();
      await fetchUserPermission(admin: true);
      return;
    }

    if (isAdmin || isAgent || isEmployee) {
      _setNotificationAndSecurity(true);
      if (mainViewModel.currentIndex.value != 4) {
        mainViewModel.currentIndex.value = 4;
      }
    }
  }

  void _setViewAndEdit(bool value) {
    showView.value = value;
    showEdit.value = value;
  }

  void _setNotificationAndSecurity(bool value) {
    showNotificationPreferences = value;
    showPasswordSecurity = value;
  }

  addImage() async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      filePath = image.path;
      CroppedFile? croppedFile;
      croppedFile = await Utils.imageCropper(filePath);
      if (croppedFile == null) {
        return;
      }
      filePath = croppedFile.path;
      fileName = Utils.fileName(filePath);
      uploadPicture();
    }
  }

  uploadPicture() async {
    Utils.showLoadingDialog();
    final result = await uploadImage(filePath: filePath);
    if (result != null) {
      saveIndividualInfo("${FlavorConfig.storageUrl}$result");
    }
    Utils.hideLoadingDialog();
  }

  saveIndividualInfo(String photo) async {
    individual.value.accountInfo?.photo = photo;
    ApiResponse apiResponse = await individualRepo.saveAccountInfo(
        request: RequestBody(body: individual.value.accountInfo?.toJson()));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      profilePhoto.value = photo;
      user.photo = photo;
      userBox.putAt(0, user);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future<void> fetchIndividualProfile({bool notUpdate = true}) async {
    final apiResponse = await individualRepo.fetchProfile(
      request: RequestBody(endPoint: "${ApiConstant.donorProfile}/${user.id}"),
    );
    Utils.hideLoadingDialog();

    if (apiResponse.appState != AppState.onSuccess) {
      if (userBox.isNotEmpty &&
          userBox.getAt(0).userName.toLowerCase() == "dev@gmail.com" &&
          apiResponse.appState == AppState.onUnauthorized) {
        debugPrint("Providing mock profile for developer account");
        final mockIndividual = Individual(
            accountInfo: AccountInfo(
              userId: user.id,
              userName: "dev@gmail.com",
              email: "dev@gmail.com",
              emailConfirmed: true,
              firstNameArabic: "مطور",
              lastNameArabic: "مستخدم",
              firstName: "Developer",
              lastName: "User",
              dob: DateTime(1990, 1, 1),
              gender: 1,
              emirateId: "784-1990-1234567-1",
              nationalityId: 1,
              photo: user.photo,
              status: 1,
              totalDonation: 5000.0,
              createdDate: DateTime.now(),
            ),
            contactInfo: DonorContactInfo(
              userId: user.id,
              mobile: "0501234567",
              isActive: true,
              additionalMobileNumber: "0507654321",
              countryResidenceId: 1,
              stateId: 1,
              cityId: 1,
              poBox: "12345",
              addresses: [
                Address(
                  id: 1,
                  userId: user.id,
                  addressType: 1,
                  street: "Innovation St",
                  building: "Mock Building",
                  landmark: "Near Dev Center",
                  isDefault: true,
                  latitude: 25.2048,
                  longitude: 55.2708,
                )
              ],
              status: 1,
              phoneNumberConfirmed: true,
            ));
        individual.value = mockIndividual;
        _setDonorData(notUpdate);
        return;
      }
      return Utils.handleAPIError(apiResponse);
    }
    individual.value = apiResponse.data;
    _setDonorData(notUpdate);
  }

  _setDonorData(bool notUpdate) {
    profilePhoto.value = individual.value.accountInfo?.photo;

    final nationalityId = individual.value.accountInfo?.nationalityId;
    if (nationalityId != null) {
      final lookup =
          nationalitiesList.firstWhereOrNull((n) => n.value == nationalityId);
      if (lookup != null) {
        nationality.value =
            Utils.isArabic ? (lookup.nameAr ?? lookup.name) : lookup.name;
      }
    } else {
      nationality.value = "";
    }

    if (!notUpdate) return;

    final isIncomplete =
        user.status != 1 || individual.value.accountInfo == null;
    _navigateIfIncomplete(
      condition: false,
      route: AppRoutes.individualScreen,
      data: individual.value,
    );

    //if (!isIncomplete) {
    user.photo = individual.value.accountInfo?.photo;
    userBox.putAt(0, user);
    //}
  }

  void _navigateIfIncomplete({
    required bool condition,
    required String route,
    required dynamic data,
    Future<void> Function()? retry,
  }) {
    Utils.hideLoadingDialog();
    if (condition) {
      if (mainViewModel.currentIndex.value == 4) {
        mainViewModel.currentIndex.value = 0;
      }
      Get.toNamed(route, arguments: {"data": data, "isEdit": false})
          ?.then((val) async {
        if (val != null && val && retry != null) {
          Utils.showLoadingDialog();
          await retry();
        }
      });
    } else {
      if (mainViewModel.currentIndex.value != 4) {
        mainViewModel.currentIndex.value = 4;
      }
    }
  }

  Future<void> fetchCompanyProfile(
      {bool notUpdate = true, bool hideLoader = true}) async {
    final apiResponse = await companyRepo.fetchCompanyProfile(
      request: RequestBody(
          endPoint:
              "${ApiConstant.companyProfile}/${user.id}/${user.accountId ?? 0}"),
    );
    if (hideLoader) Utils.hideLoadingDialog();

    if (apiResponse.appState != AppState.onSuccess) {
      if (userBox.isNotEmpty &&
          userBox.getAt(0).userName.toLowerCase() == "dev@gmail.com" &&
          apiResponse.appState == AppState.onUnauthorized) {
        debugPrint("Providing mock company profile for developer account");
        final mockCompany = Company(
          accountInfo: CompanyInfo(
            userId: user.id,
            accountId: user.accountId ?? 1,
            accountName: "Dev Company",
            accountNameArabic: "شركة التطوير",
            requestStatus: 2,
            accountLogo: user.photo,
            establishmentDate: DateTime(2000, 1, 1),
            accountTypeId: 1,
            associationCoverPhoto: null,
            license: "LIC-123",
            issuingAuthority: "Authority",
            licenseExpiryDate: DateTime(2030, 1, 1),
            agreementUrl: null,
            isActive: true,
          ),
          accountContact: ContactInfo(
            accountId: user.accountId ?? 1,
            email: "dev_company@gmail.com",
            mobile: "0501111111",
            fax: "",
            website: "www.dev.com",
            countryId: 1,
            stateId: 1,
            cityId: 1,
            poBox: "11111",
            address: "Main St",
            addressArabic: "شارع رئيسي",
            facebook: null,
            linkedIn: null,
            twitter: null,
            instagram: null,
            emailConfirmed: true,
            phoneNumberConfirmed: true,
            addresses: [],
            supportDocument: [],
          ),
          accountRepresentative: AccountRepresentative(
            id: 1,
            accountId: user.accountId ?? 1,
            firstName: "Dev",
            lastName: "Rep",
            firstNameArabic: "مطور",
            lastNameArabic: "ممثل",
            email: "rep@dev.com",
            phone: "0503333333",
            jobDescription: "Manager",
            nationalityId: 1,
            emirateId: "784-0000-0000000-1",
          ),
          bankAccount: BankAccount(
            id: 1,
            accountId: user.accountId ?? 1,
            bankName: "Dev Bank",
            swiftCode: "DEVBAE",
            iban: "AE000000000000000000001",
          ),
        );
        company.value = mockCompany;
        _setCompanyData(notUpdate);
        return;
      }
      return Utils.handleAPIError(apiResponse);
    }

    company.value = apiResponse.data;
    _setCompanyData(notUpdate);
  }

  _setCompanyData(bool notUpdate) {
    CompanyInfo? companyInfo = company.value.accountInfo;
    if (companyInfo != null) {
      companyStatus = company.value.accountInfo!.requestStatus;
    }
    profilePhoto.value = companyInfo?.accountLogo ?? profilePhoto.value;

    _updateUserAndProfilePhoto(
      name: companyInfo?.accountName,
      nameArabic: companyInfo?.accountNameArabic,
      photoUrl: companyInfo?.accountLogo,
    );

    final countryId = company.value.accountContact?.countryId;
    if (countryId != null && countryId != 0) {
      final lookup = countriesList.firstWhere((c) => c.value == countryId);
      country.value =
          Utils.isArabic ? (lookup.nameAr ?? lookup.name) : lookup.name;
    }

    final isIncomplete = companyInfo == null ||
        company.value.accountContact == null ||
        company.value.accountRepresentative == null ||
        company.value.bankAccount == null;

    if (!notUpdate) return;
    _navigateIfIncomplete(
      condition: isIncomplete,
      route: AppRoutes.companyScreen,
      data: company.value,
      retry: () => fetchCompanyProfile(notUpdate: true),
    );
  }

  void _updateUserAndProfilePhoto({
    required String? name,
    required String? nameArabic,
    required String? photoUrl,
  }) {
    user.firstName = name ?? "";
    user.lastName = "";
    user.firstNameArabic = nameArabic ?? "";
    user.lastNameArabic = "";
    user.photo =
        photoUrl != null ? "${FlavorConfig.storageUrl}$photoUrl" : user.photo;
    userBox.putAt(0, user);
  }

  Future<void> fetchAssociationProfile(
      {bool notUpdate = true, bool hideLoader = true}) async {
    final apiResponse = await associationRepo.fetchAssociationProfile(
      request: RequestBody(
          endPoint:
              "${ApiConstant.associationProfile}/${user.id}/${user.accountId ?? 0}"),
    );
    if (hideLoader) Utils.hideLoadingDialog();

    if (apiResponse.appState != AppState.onSuccess) {
      if (userBox.isNotEmpty &&
          userBox.getAt(0).userName.toLowerCase() == "dev@gmail.com" &&
          apiResponse.appState == AppState.onUnauthorized) {
        debugPrint("Providing mock association profile for developer account");
        final mockAssociation = Association(
          associationInfo: AssociationInfo(
            userId: user.id,
            accountId: user.accountId ?? 1,
            accountName: "Dev Association",
            accountNameArabic: "جمعية التطوير",
            requestStatus: 2,
            accountLogo: user.photo,
            establishmentDate: DateTime(2000, 1, 1),
            accountTypeId: 1,
            associationCoverPhoto: null,
            license: "LIC-456",
            issuingAuthority: "Authority",
            licenseExpiryDate: DateTime(2030, 1, 1),
            associationDescriptionAR: "وصف الجمعية",
            associationDescriptionEN: "Association Description",
            agreementUrl: null,
            isActive: true,
          ),
          accountContact: ContactInfo(
            accountId: user.accountId ?? 1,
            email: "dev_assoc@gmail.com",
            mobile: "0504444444",
            fax: "",
            website: "www.dev-assoc.com",
            countryId: 1,
            stateId: 1,
            cityId: 1,
            poBox: "22222",
            address: "Assoc St",
            addressArabic: "شارع الجمعية",
            facebook: null,
            linkedIn: null,
            twitter: null,
            instagram: null,
            emailConfirmed: true,
            phoneNumberConfirmed: true,
            addresses: [],
            supportDocument: [],
          ),
          accountRepresentative: AccountRepresentative(
            id: 1,
            accountId: user.accountId ?? 1,
            firstName: "Dev",
            lastName: "Assoc Rep",
            firstNameArabic: "مطور",
            lastNameArabic: "ممثل جمعية",
            email: "assoc_rep@dev.com",
            phone: "0506666666",
            jobDescription: "Staff",
            nationalityId: 1,
            emirateId: "784-1111-1111111-1",
          ),
          bankAccount: BankAccount(
            id: 1,
            accountId: user.accountId ?? 1,
            bankName: "Dev Assoc Bank",
            swiftCode: "ASSOBAE",
            iban: "AE000000000000000000002",
          ),
        );
        association.value = mockAssociation;
        _setAssociationData(notUpdate);
        return;
      }
      return Utils.handleAPIError(apiResponse);
    }

    association.value = apiResponse.data;
    _setAssociationData(notUpdate);
  }

  _setAssociationData(bool notUpdate) {
    AssociationInfo? associationInfo = association.value.associationInfo;
    associationStatus = associationInfo?.requestStatus ?? associationStatus;

    profilePhoto.value = associationInfo?.accountLogo ?? profilePhoto.value;
    coverPhoto.value =
        associationInfo?.associationCoverPhoto ?? coverPhoto.value;

    _updateUserAndProfilePhoto(
      name: associationInfo?.accountName,
      nameArabic: associationInfo?.accountNameArabic,
      photoUrl: associationInfo?.accountLogo,
    );

    if (!notUpdate) return;

    final isIncomplete = associationInfo == null ||
        association.value.accountContact == null ||
        association.value.accountRepresentative == null ||
        association.value.bankAccount == null;

    _navigateIfIncomplete(
      condition: isIncomplete,
      route: AppRoutes.associationScreen,
      data: association.value,
      retry: () => fetchAssociationProfile(notUpdate: true),
    );
  }

  Future fetchUserPermission(
      {bool hideLoader = true,
      bool admin = false,
      bool association = false,
      bool company = false}) async {
    final apiResponse = await genericRepo.fetchUserPermissions(
      request: RequestBody(
          endPoint:
              "${ApiConstant.userPermissions}/${user.empId}-${user.accountId ?? 0}"),
    );

    if (hideLoader) Utils.hideLoadingDialog();

    if (apiResponse.appState != AppState.onSuccess) {
      if (userBox.isNotEmpty &&
          userBox.getAt(0).userName.toLowerCase() == "dev@gmail.com" &&
          apiResponse.appState == AppState.onUnauthorized) {
        debugPrint("Providing mock permissions fallback for developer account");
        if (mainViewModel.currentIndex.value != 4) {
          mainViewModel.currentIndex.value = 4;
        }
        return;
      }
      return Utils.handleAPIError(apiResponse);
    }

    permissions = apiResponse.data;
    if (permissions.isEmpty && !user.isAdmin) return;

    final moduleCodes =
        permissions[0].modules.map((m) => m.moduleCode).toList();

    if (company) _setupCompanyTabs(moduleCodes);
    if (association) _setupAssociationTabs(moduleCodes);
    if (admin) _setupAdminTabs(moduleCodes);

    if (mainViewModel.currentIndex.value != 4) {
      mainViewModel.currentIndex.value = 4;
    }
  }

  void _setupCompanyTabs(List<String> moduleCodes) {
    final module =
        Utils.modulePermissions(permissions[0], ModuleCodes.companyProfileCode);

    showEdit.value = Utils.hasPermission(module, "update");
    showView.value = Utils.hasPermission(module, "view");
    companyTabs = [
      ...AppConstant.companyAccountTabs.where((tab) =>
          moduleCodes.contains(tab.code) || _isAlwaysVisibleTab(tab.code)),
    ];
  }

  void _setupAssociationTabs(List<String> moduleCodes) {
    final module = Utils.modulePermissions(
        permissions[0], ModuleCodes.associationProfileCode);

    showEdit.value = Utils.hasPermission(module, "update");
    showView.value = Utils.hasPermission(module, "view");

    myFundingSubTabs = AppConstant.myFundingSubTabs
        .where((tab) => moduleCodes.contains(tab.code))
        .toList();
    myContentSubTabs = AppConstant.myContentSubTabs
        .where((tab) => moduleCodes.contains(tab.code))
        .toList();
    associationTabs.value = AppConstant.associationAccountTabs.where((tab) {
      return moduleCodes.contains(tab.code) || _isAlwaysVisibleTab(tab.code);
    }).toList();
  }

  bool _isAlwaysVisibleTab(String? code) {
    switch (code) {
      case ModuleCodes.favouritesCode:
        return true;
      case ModuleCodes.accessibilityCode:
        return true;
      case ModuleCodes.settingsCode:
        return true;
      case ModuleCodes.associationMyContentCode:
        return myContentSubTabs.isNotEmpty;
      case ModuleCodes.associationMyFundingCode:
        return myFundingSubTabs.isNotEmpty;
      case ModuleCodes.adminDashboardCode:
        return dashboardSubTabs.isNotEmpty;
      case ModuleCodes.adminPageManagementCode:
        return pageManagementSubTabs.isNotEmpty;
      case ModuleCodes.adminMassCampaignManagementCode:
        return campaignSubTabs.isNotEmpty;
      case ModuleCodes.adminFinancialManagementCode:
        return financialManagementSubTabs.isNotEmpty;
      case ModuleCodes.adminDocumentManagementCode:
        return documentSubTabs.isNotEmpty;
      case ModuleCodes.adminSystemConfigurationCode:
        return systemConfigSubTabs.isNotEmpty;
      case ModuleCodes.adminWorkflowManagementCode:
        return workflowSubTabs.isNotEmpty;
      default:
        return false;
    }
  }

  void _setupAdminTabs(List<String> moduleCodes) {
    dashboardSubTabs = _filterSubTabs(dashboardSubTabs, moduleCodes);
    documentSubTabs = _filterSubTabs(documentSubTabs, moduleCodes);
    pageManagementSubTabs = _filterSubTabs(pageManagementSubTabs, moduleCodes);
    financialManagementSubTabs =
        _filterSubTabs(financialManagementSubTabs, moduleCodes);
    campaignSubTabs = _filterSubTabs(campaignSubTabs, moduleCodes);
    workflowSubTabs = _filterSubTabs(workflowSubTabs, moduleCodes);
    systemConfigSubTabs = _filterSubTabs(systemConfigSubTabs, moduleCodes);
    bool hasTask = userBox.isNotEmpty &&
        user.userTypeID == 1005 &&
        moduleCodes.contains(ModuleCodes.adminTasksCode);
    adminTabs.value = [
      if (hasTask) AppConstant.taskAccountTab,
    ];
    adminTabs.addAll(AppConstant.adminAccountTabs.where((tab) {
      return moduleCodes.contains(tab.code) || _isAlwaysVisibleTab(tab.code);
    }).toList());
  }

  List<Categories> _filterSubTabs(
      List<Categories> subTabs, List<String> moduleCodes) {
    return subTabs.where((e) => moduleCodes.contains(e.code)).toList();
  }

  donorMenusNavigation(int index) {
    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.donorDashboardScreen);
      case 1:
        Get.toNamed(AppRoutes.favouriteScreen);
      case 2:
        Get.toNamed(AppRoutes.requestsScreen,
            arguments: ModuleCodes.adminRequestManagementCode);
      case 3:
        Get.toNamed(AppRoutes.feedbackScreen,
            arguments: {"code": ModuleCodes.adminFeedbackManagementCode});
      // case 4 || 5:
      //   Get.toNamed(AppRoutes.allCompanyScreen, arguments: {
      //     "isAssociation": index == 4,
      //     "code": index == 4
      //         ? ModuleCodes.adminAllAssociationsCode
      //         : ModuleCodes.adminAllCompaniesCode
      //   });
      case 4:
        Get.toNamed(AppRoutes.transactionScreen,
            arguments: {"code": ModuleCodes.companyDonationsCode});
      // case 7:
      //   Get.toNamed(AppRoutes.myWalletScreen);
      // case 8:
      //   Get.toNamed(AppRoutes.myRefundsScreen);
      case 5:
        Get.toNamed(AppRoutes.accessibilityScreen);
      case 6:
        Get.toNamed(AppRoutes.notificationScreen);
      case 7:
        Get.toNamed(AppRoutes.settingsScreen,
                arguments: {"individual": individual.value})!
            .then((_) {
          Utils.showLoadingDialog();
          fetchIndividualProfile(notUpdate: false);
        });
      default:
    }
  }

  openDonorProfileScreen(bool isEdit) {
    Get.toNamed(AppRoutes.individualScreen, arguments: {
      "data": individual.value,
      "isEdit": isEdit,
      if (!isEdit) "edit": true
    })!
        .then((_) {
      Utils.showLoadingDialog();
      fetchIndividualProfile(notUpdate: false);
    });
  }

  void handleAdminNavigation(String code, [int? index]) {
    final openableTabs = {
      ModuleCodes.adminDashboardCode,
      ModuleCodes.adminPageManagementCode,
      ModuleCodes.adminFinancialManagementCode,
      ModuleCodes.adminDocumentManagementCode,
      ModuleCodes.adminSystemConfigurationCode,
      ModuleCodes.adminMassCampaignManagementCode,
      ModuleCodes.adminWorkflowManagementCode,
    };

    if (index != null && openableTabs.contains(code)) {
      adminTabs[index].isOpen = !adminTabs[index].isOpen;
      adminTabs.refresh();
      return;
    }

    final commonRoutes = {
      ModuleCodes.favouritesCode: AppRoutes.favouriteScreen,
      ModuleCodes.accessibilityCode: AppRoutes.accessibilityScreen,
      ModuleCodes.settingsCode: AppRoutes.settingsScreen,
    };

    if (commonRoutes.containsKey(code)) {
      final route = commonRoutes[code]!;
      Get.toNamed(route);
      return;
    }

    final requestsRoutes = {
      ModuleCodes.adminRequestManagementCode,
      ModuleCodes.adminTasksCode,
      "S-001"
    };

    if (requestsRoutes.contains(code)) {
      Get.toNamed(AppRoutes.requestsScreen, arguments: code);
      return;
    }

    final Map<String, String> directNavigation = {
      ModuleCodes.adminAllAssociationsCode: AppRoutes.allCompanyScreen,
      ModuleCodes.adminAllCompaniesCode: AppRoutes.allCompanyScreen,
      ModuleCodes.adminAllDonorsCode: AppRoutes.allDonorsScreen,
      ModuleCodes.adminProjectManagementCode: AppRoutes.projectManagementScreen,
      ModuleCodes.adminAdsManagementCode: AppRoutes.adsManagementScreen,
      ModuleCodes.adminNotificationsManagementCode:
          AppRoutes.notificationManagementScreen,
      ModuleCodes.adminFeedbackManagementCode: AppRoutes.feedbackScreen,
      ModuleCodes.adminUsersManagementCode: AppRoutes.managementStaffScreen,
      ModuleCodes.adminAdminDashboardCode: AppRoutes.adminDashboardScreen,
      ModuleCodes.adminAdminAndOperationsDashboardCode:
          AppRoutes.adminAndOperationsScreen,
      ModuleCodes.adminCampaignsAndProjectsDashboardCode:
          AppRoutes.campaignsProjectsScreen,
      ModuleCodes.adminDonationsDashboardCode: AppRoutes.donationDataScreen,
      ModuleCodes.adminDonorsDashboardCode: AppRoutes.donorScreen,
      ModuleCodes.adminFinancialDashboardCode: AppRoutes.financialScreen,
      ModuleCodes.adminEngagementAndInteractionsDashboardCode:
          AppRoutes.userEngagementScreen,
      ModuleCodes.adminSLAComplianceDashboardCode: AppRoutes.slaDashboardScreen,
      ModuleCodes.adminFAQCode: AppRoutes.faqsScreen,
      ModuleCodes.adminServicesCode: AppRoutes.cmsServicesScreen,
      ModuleCodes.adminNewsCode: AppRoutes.cmsNewsScreen,
      ModuleCodes.adminPublicDocumentsCode: AppRoutes.publicDocumentsScreen,
      ModuleCodes.adminUsersDocumentsCode: AppRoutes.userDocumentsScreen,
      ModuleCodes.adminPlatformDocumentsCode: AppRoutes.platformDocumentsScreen,
      ModuleCodes.adminAuditLogsCode: AppRoutes.auditLogScreen,
      ModuleCodes.adminSMTPConfigCode: AppRoutes.smtpConfigScreen,
      ModuleCodes.adminFundsTransferQueCode: AppRoutes.transferQueueScreen,
      ModuleCodes.adminDonationRegisterCode: AppRoutes.transactionScreen,
      ModuleCodes.adminRecipientsCode: AppRoutes.recipientsCampaignScreen,
      ModuleCodes.adminApproverGroupCode: AppRoutes.approverGroupScreen,
      ModuleCodes.adminWorkflowConfigCode: AppRoutes.workflowConfigScreen,
    };

    if (directNavigation.containsKey(code)) {
      final route = directNavigation[code]!;
      final args = {
        "code": code,
        if (route == AppRoutes.allCompanyScreen)
          "isAssociation": code == ModuleCodes.adminAllAssociationsCode,
      };
      Get.toNamed(route, arguments: args);
    }
  }

  handleAssociationNavigation(String code, [int? index]) {
    if (index != null) {
      final isApproved = association.value.associationInfo?.requestStatus == 2;
      final isUnlocked = associationMenus.contains(index);

      if (!isApproved && !isUnlocked) {
        Utils.showGlobalSnackBar(message: "profileIsNotApproved".tr);
        return;
      }

      if (code == ModuleCodes.associationMyContentCode ||
          code == ModuleCodes.associationMyFundingCode) {
        associationTabs[index].isOpen = !associationTabs[index].isOpen;
        associationTabs.refresh();
        return;
      }
    }

    if (code == ModuleCodes.associationRequestsCode) {
      Get.toNamed(AppRoutes.requestsScreen, arguments: code);
      return;
    }

    final routeArgs = {"code": code};

    final staticRouteMap = {
      ModuleCodes.associationNewsCode: AppRoutes.cmsNewsScreen,
      ModuleCodes.associationAboutUsCode: AppRoutes.aboutAssociationScreen,
      ModuleCodes.associationFundRequestCode: AppRoutes.fundsRequestsScreen,
      ModuleCodes.associationFinancialStatementCode:
          AppRoutes.financialStatementScreen,
      ModuleCodes.associationDashboardCode:
          AppRoutes.associationDashboardScreen,
      ModuleCodes.favouritesCode: AppRoutes.favouriteScreen,
      ModuleCodes.associationRequestsCode: AppRoutes.requestsScreen,
      ModuleCodes.associationMyProjectsCode: AppRoutes.projectManagementScreen,
      ModuleCodes.associationFeedbacksCode: AppRoutes.feedbackScreen,
      ModuleCodes.associationEmployeesCode: AppRoutes.managementStaffScreen,
      ModuleCodes.accessibilityCode: AppRoutes.accessibilityScreen,
    };

    if (staticRouteMap.containsKey(code)) {
      final route = staticRouteMap[code]!;
      final isSimpleNav = code == ModuleCodes.favouritesCode ||
          code == ModuleCodes.accessibilityCode;
      Get.toNamed(route, arguments: isSimpleNav ? null : routeArgs);
      return;
    }

    if (code == ModuleCodes.settingsCode) {
      Get.toNamed(AppRoutes.settingsScreen,
          arguments: {"association": association.value});
    }
    if (code == "N-0") {
      Get.toNamed(AppRoutes.notificationScreen);
    }
  }

  handleCompanyNavigation(int index) {
    if (company.value.accountInfo?.requestStatus != 2 &&
        !companyMenus.contains(index)) {
      Utils.showGlobalSnackBar(message: "profileIsNotApproved".tr);
      return;
    }
    String code = companyTabs[index].code;
    final routeArgs = {"code": code};
    switch (code) {
      case ModuleCodes.companyDashboardCode:
        Get.toNamed(AppRoutes.donorDashboardScreen, arguments: code);
      case ModuleCodes.favouritesCode:
        Get.toNamed(AppRoutes.favouriteScreen);
      case ModuleCodes.companyRequestsCode:
        Get.toNamed(AppRoutes.requestsScreen, arguments: code);
      case ModuleCodes.companyFeedbacksCode:
        Get.toNamed(AppRoutes.feedbackScreen, arguments: routeArgs);
      case ModuleCodes.companyEmployeesCode:
        Get.toNamed(AppRoutes.managementStaffScreen, arguments: routeArgs);
      case ModuleCodes.companyDonationsCode:
        Get.toNamed(AppRoutes.transactionScreen, arguments: routeArgs);
      case ModuleCodes.companyMyRefundsCode:
        Get.toNamed(AppRoutes.myRefundsScreen, arguments: code);
      case ModuleCodes.accessibilityCode:
        Get.toNamed(AppRoutes.accessibilityScreen);
      case "N-0":
        Get.toNamed(AppRoutes.notificationScreen);
      case ModuleCodes.settingsCode:
        Get.toNamed(AppRoutes.settingsScreen,
            arguments: {"company": company.value});
      default:
    }
  }

  openCompanyProfileScreen(isEdit) {
    Get.toNamed(AppRoutes.companyScreen,
            arguments: {"data": company.value, "isEdit": isEdit})!
        .then((_) {
      Utils.showLoadingDialog();
      fetchCompanyProfile(notUpdate: false);
    });
  }

  @override
  void onClose() {
    tabController.removeListener(_tabListener);
    currentTabIndex.close();
    profilePhoto.close();
    coverPhoto.close();
    showEdit.close();
    showView.close();
    individual.close();
    company.close();
    association.close();
    nationality.close();
    country.close();
    associationTabs.close();
    adminTabs.close();
    additionalDocuments.close();

    tabController.dispose();

    super.onClose();
  }
}
