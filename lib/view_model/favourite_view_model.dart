import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/favourite_project.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/favourite_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';

class FavouriteViewModel extends GetxController with GetTickerProviderStateMixin, GenericMixin {
  final RxList<FavouriteProject> projects = <FavouriteProject>[].obs;
  final RxList<News> news = <News>[].obs;
  final RxList<OurServices> services = <OurServices>[].obs;

  final FavouriteRepoImpl repo = FavouriteRepoImpl();

  late TabController tabController;
  late TabController tabViewController;
  late User user;

  final List<String> tabs = ["projects", "news", "services"];
  final RxInt currentTabIndex = 0.obs;
  final dateFormat = DateFormat('dd MMMM yyyy', Get.locale?.languageCode);

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData()  {
    Utils.logEvent(name: EventConstant.myFavouritesScreen);
    user = userBox.getAt(0);
    _initTabControllers();
     _fetchAllFavourites();
  }

  void _initTabControllers() {
    tabController = TabController(vsync: this, length: tabs.length);
    tabViewController = TabController(vsync: this, length: tabs.length);
    tabController.addListener(_tabListener);
  }

  _tabListener(){
      currentTabIndex.value = tabController.index;
      tabViewController.animateTo(currentTabIndex.value);
  }

  _fetchAllFavourites() async {
    try{
      Utils.showLoadingDialog();
      await Future.wait([
        favoriteProjects(),
        favouriteNews(),
        favouriteServices(),
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }

  }

  Future favoriteProjects() async {
    ApiResponse apiResponse = await repo.favoriteProjects(
        request: RequestBody(
            endPoint: "${ApiConstant.favoriteProjects}/${user.empId}"));
    if (apiResponse.appState == AppState.onSuccess) {
      projects.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future favouriteNews() async {
    ApiResponse apiResponse = await repo.favouriteNews(
        request: RequestBody(
            endPoint: "${ApiConstant.favouriteNews}/${user.empId}"));
    if (apiResponse.appState == AppState.onSuccess) {
      news.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future favouriteServices() async {
    ApiResponse apiResponse = await repo.favouriteServices(
        request: RequestBody(
            endPoint: "${ApiConstant.favouriteServices}/${user.empId}"));
    if (apiResponse.appState == AppState.onSuccess) {
      services.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  addProjectFavorite(int index) async {
    int id = projects[index].projectId;
    var body = {"projectId": id, "userId": user.empId};
    final result = await addProjectToFavourite(body: body);
    if(result){
      projects.removeAt(index);
    }
  }

  addServiceFavorite(int index) async {
    int id = services[index].serviceId!;
    var body = {"serviceId": id, "userId": user.empId, "isFavorite": false};
    final result = await addServiceToFavourite(body:body);
    if(result){
      services.removeAt(index);
    }
  }

  addNewsFavorite(int index) async {
    int id = news[index].newsId!;
    var body = {"newsId": id, "userId": user.id, "isFavorite": false};
    final result = await addNewsToFavourite(body: body);
    if(result){
      news.removeAt(index);
    }
  }

  openProjectDetailsScreen(int id) {
    Get.toNamed(
      AppRoutes.projectDetailsScreen,
      arguments: {"projectId": id, "isPreview": false},
    )?.then((_) async {
      Utils.showLoadingDialog();
      await favoriteProjects();
      Utils.hideLoadingDialog();
    });
  }

  openNewsDetailsScreen(int id) {
    Get.toNamed(AppRoutes.newsDetailScreen,
        arguments: {"id": id, "allNews": false})?.then((val) async {
      Utils.showLoadingDialog();
      await favouriteNews();
      Utils.hideLoadingDialog();
    });
  }

  openServiceDetailsScreen(OurServices service) {
    Get.toNamed(AppRoutes.serviceDetails, arguments: {"service": service});
  }

  quickDonateFromFavourite(FavouriteProject project) {
    final cart = Get.find<CartViewModel>();
    cart.quickDonateDialog(project);
  }

  @override
  void onClose() {
    tabController.removeListener(_tabListener);
    tabController.dispose();
    tabViewController.dispose();

    projects.close();
    news.close();
    services.close();
    currentTabIndex.close();
    super.onClose();
  }

}
