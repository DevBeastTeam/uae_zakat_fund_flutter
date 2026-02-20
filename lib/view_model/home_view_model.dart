import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart' as response;
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/ads.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/static_page.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/home_repo.dart';
import 'package:zakat_fund/repository/news_repo.dart';
import 'package:zakat_fund/repository/reminders_repo.dart';
import 'package:zakat_fund/repository/services_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/guest_reminder_dialog.dart';
import 'package:zakat_fund/widgets/pop_up.dart';

class HomeViewModel extends GetxController with GenericMixin {
  final homeRepo = HomeRepoImpl();
  final genericRepo = GenericRepoImpl();
  final reminderRepo = RemindersRepoImpl();

  final mainViewModel = Get.find<MainViewModel>();
  final cartViewModel = Get.find<CartViewModel>();

  final searchController = TextEditingController();
  final associateController = TextEditingController();
  final searchAssociation = TextEditingController();
  final searchAssociationController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final phoneFocusNode = FocusNode();
  late List<KeyboardActionsItem> keyboardActionsItem;

  final carouselController = CarouselSliderController();
  RxInt campaignIndex = 0.obs;
  RxInt categoryIndex = 0.obs;
  RxInt newsIndex = 0.obs;
  RxInt projectIndex = 0.obs;
  RxInt associationIndex = 0.obs;
  RxBool isAgree = false.obs;
  RxBool isClicked = false.obs;

  Rxn<String> selectedAssociation = Rxn<String>();
  Rxn<String> selectedNotificationFrequency = Rxn<String>();

  List<String> associationsNames = ["all".tr];
  List<Project> allAssociations = [];

  RxList<LookupData> categoriesList =
      <LookupData>[LookupData(name: "All", value: 0, nameAr: "الجميع")].obs;
  RxList<LookupData> associationCatsList =
      <LookupData>[LookupData(name: "All", value: 0, nameAr: "الجميع")].obs;
  RxList<LookupData> servicesCategoriesList =
      <LookupData>[LookupData(name: "All", value: 0, nameAr: "الجميع")].obs;
  RxList<LookupData> projCategoriesList = <LookupData>[].obs;
  RxList<LookupData> allCategoriesList = <LookupData>[].obs;
  RxList<LookupData> selectedCategories = <LookupData>[].obs;
  Rx<LookupData> selectedNewsCat =
      LookupData(name: "All", value: 0, nameAr: "الجميع").obs;
  Rx<LookupData> selectedServiceCat =
      LookupData(name: "All", value: 0, nameAr: "الجميع").obs;
  Rx<LookupData> selectedAssociationCat =
      LookupData(name: "All", value: 0, nameAr: "الجميع").obs;

  Rx<LookupData> homeSelectedAssociationCat =
      LookupData(name: "All", value: 0, nameAr: "الجميع").obs;

  Rx<LookupData> homeSelectedProjectCat =
      LookupData(name: "All", value: 0, nameAr: "الجميع").obs;

  List<Ads> ads = [];
  RxList<ProjectElements> projects = <ProjectElements>[].obs;
  RxList<ProjectElements> featuredProjects = <ProjectElements>[].obs;

  RxList<Project> associations = <Project>[].obs;
  RxList<Project> associationsList = <Project>[].obs;
  final RxList<News> latestNews = <News>[].obs;
  List<News> allNews = [];
  final ServicesRepoImpl serviceRepo = ServicesRepoImpl();

  final repo = NewsRepoImpl();
  final List<String> tabs = [];
  final RxList<SelectedCategories> archiveCategories =
      <SelectedCategories>[].obs;
  final RxList<OurServices> services = <OurServices>[].obs;
  List<OurServices> allServices = [];

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: phoneFocusNode, displayArrows: false)
    ];
    Utils.logEvent(name: EventConstant.homeScreen);
    updateData(init: true);
    Utils.subscribeTopics();
    super.onInit();
  }

  void onCategoryTap(int index) async {
    if (index == categoryIndex.value) return;
    categoryIndex.value = index;
    try {
      Utils.showLoadingDialog();
      await fetchProjects(search: true);
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  Future _fetchAllServices() async {
    ApiResponse apiResponse =
        await serviceRepo.fetchAllServices(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      final List<OurServices> validServices = apiResponse.data
          .where((service) => service.requestStatus == 2)
          .toList();
      services.assignAll(validServices);
      allServices = List.from(services);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  void removeCategory(int index) {
    allCategoriesList.add(selectedCategories[index]);
    selectedCategories.removeAt(index);
    _refreshCategories();
  }

  void addCategory(int index) {
    selectedCategories.add(allCategoriesList[index]);
    allCategoriesList.removeAt(index);
    _refreshCategories();
  }

  void _refreshCategories() {
    selectedCategories.refresh();
    allCategoriesList.refresh();
  }

  void updateCampaignIndicator(int index) => campaignIndex.value = index;

  void updateProjectIndicator(int index) => projectIndex.value = index;

  void updateAssociationIndicator(int index) => associationIndex.value = index;

  Future<void> updateData({bool init = false, bool clearData = false}) async {
    if (clearData) _resetIndices();
    try {
      Utils.showLoadingDialog();
      if (init) await fetchStaticPages(1);
      await Future.wait([
        if (init) fetchStaticPages(2),
        if (init && userBox.isNotEmpty) addDevice(),
        fetchCategoriesTypes(),
        fetchProjects(),
        fetchFeaturedProject(),
        fetchAssociations(),
        fetchAds(),
        fetchLatestNews(),
        fetchCategories(),
        _fetchCategories(),
        _fetchAssociationsCategories(),
        _fetchAllServices(),
      ]);
      if (!clearData) cartViewModel.fetchCart(showLoading: false);
    } finally {
      Utils.hideLoadingDialog();
    }
    if (ads.isNotEmpty) _openAdPopUp();
  }

  Future<void> refreshData() async {
    _resetIndices();
    associateController.clear();
    selectedAssociation.value = null;
    try {
      Utils.showLoadingDialog();
      await Future.wait([
        fetchProjects(),
        fetchFeaturedProject(),
        fetchAssociations(),
        fetchLatestNews(),
      ]);
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  Future fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.newsCategories);
    if (result.isNotEmpty) {
      categoriesList.addAll(result);
    }
  }

  Future _fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.serviceCategories);
    if (result.isNotEmpty) {
      servicesCategoriesList.addAll(result);
    }
  }

  Future _fetchAssociationsCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.associationType);
    if (result.isNotEmpty) {
      associationCatsList.addAll(result);
    }
  }

  void filterLatestNews(LookupData category) {
    selectedNewsCat.value = category;
    if (category.value == 0) {
      latestNews.value = List.from(allNews);
    } else {
      final selectedCatId = selectedNewsCat.value.value;
      latestNews.value = allNews.where((n) {
        final matchesCat = n.newsCategoryId == selectedCatId;
        return matchesCat;
      }).toList();
    }

    latestNews.refresh();
  }

  filterServices(LookupData category) {
    selectedServiceCat.value = category;
    if (category.value == 0) {
      services.value = List.from(allServices);
    } else {
      services.value = allServices.where((n) {
        final matchesCat = n.serviceCategoryId == category.value;
        return matchesCat;
      }).toList();
    }
  }

  bool _matchesSearch(News news, String query) {
    final title = Utils.isArabic ? news.titleAr : news.titleEn;
    return title.toLowerCase().contains(query);
  }

  void _resetIndices() {
    categoryIndex.value = 0;
    projectIndex.value = 0;
    campaignIndex.value = 0;
  }

  filterAssociations(LookupData category) {
    selectedAssociationCat.value = category;
    if (category.value == 0) {
      associationsList.value = List.from(allAssociations);
    } else {
      associationsList.value = allAssociations
          .where((association) => association.accountTypeID == category.value)
          .toList();
    }
    associations.refresh();
  }

  filterHomeAssociations(LookupData category) {
    homeSelectedAssociationCat.value = category;
    if (category.value == 0) {
      associations.value = List.from(allAssociations);
    } else {
      associations.value = allAssociations
          .where((association) => association.accountTypeID == category.value)
          .toList();
    }
    associations.refresh();
  }

  filterProjects(LookupData category) async {
    try {
      projects.clear();
      homeSelectedProjectCat.value = category;
      Utils.showLoadingDialog();
      await fetchProjects();
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  _openAdPopUp() {
    Navigator.of(
      Get.context!,
    )
        .push(
      PageRouteBuilder(
        opaque: false,
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => PopUpDialog(
          ads: ads[0],
        ),
      ),
    )
        .then((_) {
      ads.remove(ads[0]);
      if (ads.isNotEmpty) _openAdPopUp();
    });
  }

  Future<void> fetchStaticPages(int id) async {
    if (id == 1) mainViewModel.addMenuPages();
    final response = await homeRepo.fetchStaticPages(
        request: RequestBody(endPoint: "${ApiConstant.staticPages}/$id"));
    if (response.appState == AppState.onSuccess) {
      mainViewModel.menu.addAll(
        response.data.where((page) =>
            (page.pageSection == 1 || page.pageSection == 2) &&
            page.isPageActive &&
            page.requestStatus == 2 &&
            ((Utils.isArabic && page.pageTitleAR?.isNotEmpty == true) ||
                (!Utils.isArabic && page.pageTitleEN?.isNotEmpty == true))),
      );
    }
    if (id == 1) {
      mainViewModel.menu.add(StaticPage(pageTitleEN: "addFeedback"));
    }
  }

  Future fetchLatestNews() async {
    allNews.clear();
    ApiResponse apiResponse = await repo.latestNews(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      allNews =
          apiResponse.data.where((news) => news.requestStatus == 2).toList();
      latestNews.value = List.from(allNews);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  Future<void> fetchCategoriesTypes() async {
    final result = await getLookUpData(endPoint: ApiConstant.projectCategories);
    projCategoriesList.value = [
      LookupData(name: "All", value: 0, nameAr: "الجميع"),
      ...result,
    ];
    allCategoriesList
      ..clear()
      ..addAll(result);
  }

  Future<void> fetchProjects({bool search = false, bool clear = false}) async {
    final int categoryId = homeSelectedProjectCat.value.value;
    final int accountId = _getSelectedAccountId();
    final Map<String, dynamic> queryParameters = {
      "pageNumber": 1,
      "pageSize": 10,
      if (accountId != 0) "accountId": accountId,
      if (categoryId != 0) "categoryId": categoryId,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      "isPublished": true,
    };
    final result = await getProjectListPaginated(queryParameters);
    if (result != null) {
      final BaseApiModel response = result;
      final List<ProjectElements> fetchedProjects = List<ProjectElements>.from(
        response.data.map((x) => ProjectElements.fromJson(x)),
      );

      projects.value = fetchedProjects;
    }
  }

  int _getSelectedCategoryId() {
    if (categoryIndex.value != 0 &&
        categoryIndex.value < categoriesList.length) {
      return categoriesList[categoryIndex.value].value;
    }
    return 0;
  }

  int _getSelectedAccountId() {
    final selected = selectedAssociation.value;
    if (selected != null && selected != "all".tr) {
      return allAssociations
              .firstWhereOrNull((assoc) => assoc.accountName == selected)
              ?.accountId ??
          0;
    }
    return 0;
  }

  Future<void> fetchAds() async {
    try {
      final apiResponse = await homeRepo.fetchAds(request: RequestBody());
      if (apiResponse.appState == AppState.onSuccess) {
        final List<Ads> fetchedAds = _filterValidAds(apiResponse.data);
        ads.addAll(fetchedAds);
      } else if (apiResponse.appState == AppState.onFailure) {
        Utils.showGlobalSnackBar(
            message: apiResponse.message ?? 'Failed to load ads.');
      }
    } catch (_) {}
  }

  List<Ads> _filterValidAds(List<Ads> rawAds) {
    final now = DateTime.now();
    return rawAds
        .whereType<Ads>()
        .where((ad) =>
            ad.requestStatus == 2 &&
            ad.adType == 2 &&
            ad.publicScheduleTime != null &&
            ad.expiryDate != null &&
            ad.publicScheduleTime!.isBefore(now) &&
            ad.expiryDate!.isAfter(now))
        .toList();
  }



  Future addDevice({bool isLogout = false}) async {
    User user = userBox.getAt(0);
    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (_) {}
    debugPrint("FCM TOKEN==$token");
    var body = {
      "userId": user.id,
      "deviceId": token,
      "deviceName": Utils.deviceName,
      "deviceOS": Platform.isAndroid ? "Android" : "IOS",
      "isLogout": isLogout
    };
    response.ApiResponse apiResponse =
        await genericRepo.addDevice(request: RequestBody(body: body));
    if (apiResponse.appState == AppState.onSuccess) {
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchFeaturedProject() async {
    try {
      final List<ProjectElements> projects = await getFeaturedProjects();
      featuredProjects.value = projects;
    } on Exception catch (e) {
      Utils.showGlobalSnackBar(message: e.toString());
    }
  }

  Future<void> fetchAssociations() async {
    final apiResponse =
        await homeRepo.fetchAssociations(request: RequestBody());

    if (apiResponse.appState == AppState.onSuccess) {
      final List<Project> fetchedAssociations = apiResponse.data;

      allAssociations = fetchedAssociations;
      associations.value = List.from(fetchedAssociations);
      associationsList.value = List.from(fetchedAssociations);

      final List<String> associationNames = [
        "all".tr,
        ...fetchedAssociations.map((association) => Utils.isArabic
            ? association.accountNameArabic
            : association.accountName),
      ];

      associationsNames = associationNames.toSet().toList();
      selectedAssociation.refresh();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(
          message: apiResponse.message ?? 'Failed to fetch associations.');
    }
  }

  void filterAssociation() {
    final query = searchAssociation.text.trim().toLowerCase();
    if (query.isEmpty) {
      associationsList.assignAll(allAssociations);
      return;
    }

    final filtered = allAssociations.where((assoc) {
      final name = Utils.isArabic ? assoc.accountNameArabic : assoc.accountName;
      return name.toLowerCase().contains(query);
    }).toList();
    associationsList.assignAll(filtered);
  }

  remindMe(int projectId) {
    Utils.logEvent(name: EventConstant.remindMeScreen);
    if (userBox.isEmpty) {
      resetData();
      guestRemindMeDialog();
    } else {
      Get.toNamed(AppRoutes.addDonationReminderScreen,
          arguments: {"projectId": projectId});
    }
  }

  void resetData() {
    emailController.clear();
    phoneController.clear();

    selectedNotificationFrequency.value = null;
    selectedCategories.clear();
    isAgree.value = false;
    final filteredCategories = categoriesList.where(
      (cat) => cat.name.toLowerCase() != "all".tr.toLowerCase(),
    );
    allCategoriesList.value = filteredCategories.toList();
  }

  Future<void> addReminder() async {
    isClicked.value = true;
    final formIsValid = formKey.currentState?.validate() ?? false;
    final hasSelectedCategories = selectedCategories.isNotEmpty;
    if (!formIsValid || !hasSelectedCategories) return;
    Utils.showLoadingDialog();
    final List<int> selectedCategoryIds =
        selectedCategories.map((cat) => cat.value).toList();
    final body = {
      "email": emailController.text.trim(),
      "phoneNumber": phoneController.text.trim(),
      "projectAlertFrequency": Utils.notificationFrequencyIntoInt(
        selectedNotificationFrequency.value!,
      ),
      "selectedProjectCategories": jsonEncode(selectedCategoryIds),
      "notificationMethods": "[1,2]",
    };
    final apiResponse =
        await reminderRepo.addGuestReminder(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Get.back();
      Utils.showGlobalSnackBar(message: "alertAddedSuccessfully".tr);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    associateController.dispose();
    searchAssociation.dispose();
    searchAssociationController.dispose();
    emailController.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();

    campaignIndex.close();
    categoryIndex.close();
    projectIndex.close();
    associationIndex.close();
    isAgree.close();
    isClicked.close();
    selectedAssociation.close();
    selectedNotificationFrequency.close();
    categoriesList.close();
    allCategoriesList.close();
    selectedCategories.close();
    projects.close();
    featuredProjects.close();
    associations.close();
    associationsList.close();
    super.onClose();
  }
}
