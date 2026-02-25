import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/association_about_us.dart';
import 'package:zakat_fund/model/association_conatct_us.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/about_association_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';

class AssociationDetailViewModel extends GetxController with GenericMixin {

  final _genericRepo = GenericRepoImpl();
  final _repo = AboutAssociationRepoImpl();
  final homeViewModel = Get.find<HomeViewModel>();

  final Rxn<Project> association = Rxn<Project>();
  final RxList<News> news = <News>[].obs;
  List<News> allNews = [];
  Rx<LookupData> selectedNewsCat = LookupData(name: "all".tr, value: 0,nameAr: "all".tr).obs;
  final RxList<ProjectElements> projects = <ProjectElements>[].obs;
  final RxList<ProjectElements> featuredProjects = <ProjectElements>[].obs;
  final RxList<AssociationAboutUs> aboutUs = <AssociationAboutUs>[].obs;
  final RxList<AssociationContactUs> contactUs = <AssociationContactUs>[].obs;
  final RxList<LookupData> categoriesList = <LookupData>[].obs;
  final RxInt projectIndex = 0.obs;
  final RxInt categoryIndex = 0.obs;
  final RxInt newsIndex = 0.obs;
  final RxInt campaignIndex = 0.obs;
  final RxInt projectsCount = 0.obs;

  final DateFormat dateFormat = DateFormat('dd MMMM yyyy', Get.locale?.languageCode);
  final CarouselSliderController carouselController = CarouselSliderController();
  final CarouselSliderController? newsCarouselController = CarouselSliderController();

  List<ProjectElements> allProjects = [];
  late final int _accountId;

  @override
  Future<void> onInit() async {
    super.onInit();
    Utils.logEvent(name: EventConstant.associationDetailsScreen);
    _accountId = Get.arguments;
    try{
      Utils.showLoadingDialog();
      await Future.wait([
        // _fetchAboutUs(),
        _fetchProjects(),
        _associationNews(),
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }
    categoriesList.value = List.from(homeViewModel.categoriesList);
  }

  void updateProjectIndicator(int index) => projectIndex.value = index;
  void updateCampaignIndicator(int index) => campaignIndex.value = index;
  void updateNewsIndicator(int index) => newsIndex.value = index;

  void filterProjects(int index) {
    categoryIndex.value = index;
    projectIndex.value = 0;

    final selectedCategoryId = homeViewModel.categoriesList[index].value.toString();

    if (selectedCategoryId == "0") {
      projects.assignAll(allProjects);
    } else {
      projects.assignAll(allProjects.where((project) {
        if (project.category == null) return false;
        final categories = project.category!.split(",");
        return categories.contains(selectedCategoryId);
      }));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(projects.isNotEmpty)carouselController.jumpToPage(0);
    });
  }

  void filterLatestNews(LookupData category) {
    selectedNewsCat.value = category;
    if(category.value==0){
      news.value = List.from(allNews);
    }else{
      final selectedCatId = selectedNewsCat.value.value;
      news.value = allNews.where((n) {
        final matchesCat = n.newsCategoryId == selectedCatId;
        return matchesCat;
      }).toList();
    }

    news.refresh();
  }


  Future _fetchProjects() async {
    final result = await getAssociationProjects(_accountId);
    if(result!=null){
      association.value = result;
      allProjects = association.value!.projects ;
      projectsCount.value = allProjects.length;
      // featuredProjects.value = association.value!.featuredProject;
      projects.value = List.from(allProjects);
    }
  }

  Future _fetchAboutUs() async {
    ApiResponse apiResponse = await _repo.associationAboutUs(
        request: RequestBody(
            endPoint:
            "${ApiConstant.associationAboutUs}/$_accountId"));

    if (apiResponse.appState == AppState.onSuccess) {
      aboutUs.value = apiResponse.data;
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  Future _associationNews() async {
    ApiResponse apiResponse = await _genericRepo.associationNews(
        request: RequestBody(
            endPoint:
            "${ApiConstant.associationNews}/$_accountId"));
    if (apiResponse.appState == AppState.onSuccess) {
      news.value = apiResponse.data;
      allNews = List.from(news);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  @override
  void onClose() {
    association.close();
    news.close();
    projects.close();
    featuredProjects.close();
    aboutUs.close();
    contactUs.close();
    projectIndex.close();
    categoryIndex.close();
    newsIndex.close();
    campaignIndex.close();
    projectsCount.close();

    super.onClose();
  }

}

