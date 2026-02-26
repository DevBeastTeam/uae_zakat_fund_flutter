import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/services_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class OurServiceViewModel extends GetxController
    with GetTickerProviderStateMixin, GenericMixin {
  final ServicesRepoImpl repo = ServicesRepoImpl();

  final RxInt selectedService = 0.obs;
  final RxInt currentTabIndex = 0.obs;
  final RxList<OurServices> services = <OurServices>[].obs;
  final List<OurServices> allServices = [];
  RxList<LookupData> categoriesList =
      <LookupData>[LookupData(name: "All", value: 0, nameAr: "الجميع")].obs;
  Rx<LookupData> selectedCategory =
      LookupData(name: "All", value: 0, nameAr: "الجميع").obs;

  final TextEditingController searchController = TextEditingController();

  late final TabController tabController;
  late final User user;

  final List<String> tabs = ["all".tr];

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.ourServicesScreen);
    if (userBox.isNotEmpty) {
      user = userBox.getAt(0);
    }
    try {
      Utils.showLoadingDialog();
      await _fetchCategories();
      await _fetchAllServices();
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  Future _fetchAllServices() async {
    allServices.clear();
    ApiResponse apiResponse =
        await repo.fetchAllServices(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      final List<OurServices> validServices = apiResponse.data
          .where((service) => service.requestStatus == 2)
          .toList();
      allServices.addAll(validServices);
      services.assignAll(validServices);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  Future _fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.serviceCategories);
    if (result.isNotEmpty) {
      categoriesList.addAll(result);
      categoriesList.refresh();
      _initializeCategories();
    }
  }

  void _initializeCategories() {
    tabs.addAll(categoriesList.map(
      (cat) => Utils.isArabic ? cat.nameAr ?? cat.name ?? '' : cat.name ?? '',
    ));
    tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: 0,
    );
    tabController.addListener(_tabListener);
  }

  _tabListener() {
    currentTabIndex.value = tabController.index;
    filterServices();
  }

  updateCategory(LookupData category) {
    selectedCategory.value = category;
    selectedCategory.refresh();
    if (category.value == 0) {
      services.value = List.from(allServices);
      return;
    }
    services.value = allServices
        .where((service) =>
            service.serviceCategoryId == selectedCategory.value.value)
        .toList();
  }

  Future<void> addToFavorite(int index) async {
    final service = services[index];
    final body = {
      "serviceId": service.id,
      "userId": user.empId,
      "isFavorite": !service.isFavorite,
    };
    final result = await addServiceToFavourite(body: body);
    if (result) {
      service.isFavorite = !service.isFavorite;
      services.refresh();
    }
  }

  void filterServices() {
    final query = searchController.text.trim().toLowerCase();
    final isAllTab = currentTabIndex.value == 0;
    final List<OurServices> sourceList =
        isAllTab ? allServices : _servicesByCategory();

    if (query.isEmpty) {
      services.assignAll(sourceList);
    } else {
      services.assignAll(
        sourceList.where((service) {
          final title = Utils.isArabic ? service.titleAr : service.titleEn;
          return title.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  List<OurServices> _servicesByCategory() {
    final selectedTab = tabs[currentTabIndex.value];
    final category = categoriesList.firstWhereOrNull((cat) {
      final name = Utils.isArabic ? cat.nameAr : cat.name;
      return name == selectedTab;
    });

    if (category == null) return [];

    return allServices
        .where((service) => service.serviceCategoryId == category.value)
        .toList();
  }

  openServiceDetailsScreen(OurServices service) {
    Get.toNamed(AppRoutes.serviceDetails, arguments: {"service": service});
  }

  shareService(int id) {
    Utils.logEvent(name: EventConstant.shareServiceClick);
    Utils.sharePlainText(
      "${FlavorConfig.webSiteUrl}service/$id",
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    tabController.removeListener(_tabListener);
    tabController.dispose();
    services.close();
    selectedService.close();
    currentTabIndex.close();
    super.onClose();
  }
}
