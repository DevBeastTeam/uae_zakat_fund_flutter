import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';

class CampaignsViewModel extends GetxController {
  final homeViewModel = Get.find<HomeViewModel>();

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  RxList<ProjectElements> projects = <ProjectElements>[].obs;
  RxList<LookupData> categoriesList = <LookupData>[].obs;
  Rx<LookupData> selectedCategory =
      LookupData(name: "All", value: 0, nameAr: "الجميع").obs;

  @override
  void onInit() {
    super.onInit();
    categoriesList.assignAll(homeViewModel.projCategoriesList);
    projects.assignAll(homeViewModel.projects);
  }

  Future<void> fetchProjects({bool search = false, bool clear = false}) async {
    await homeViewModel.fetchProjects(search: search, clear: clear);
    projects.assignAll(homeViewModel.projects);
  }

  Future<void> refreshData() async {
    await homeViewModel.refreshData();
    projects.assignAll(homeViewModel.projects);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
