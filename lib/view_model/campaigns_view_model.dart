import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';

class CampaignsViewModel extends GetxController with GenericMixin {
  final categoryIndex = 0.obs;
  final projects = <ProjectElements>[].obs;
  final selectedAssociation = Rxn<String>();

  final searchController = TextEditingController();
  final searchAssociationController = TextEditingController();
  final scrollController = ScrollController();
  final homeViewModel = Get.find<HomeViewModel>();
  final cartViewModel = Get.find<CartViewModel>();

  RxList<LookupData> categoriesList = <LookupData>[].obs;
  List<String> associationsNames = [];
  int currentPage = 1;
  int totalRecords = 0;
  Rx<LookupData> selectedCategory = LookupData(name: "All", value: 0, nameAr: "الجميع").obs;




  @override
  Future<void> onInit() async {
    Utils.logEvent(name: EventConstant.campaignsScreen);
    scrollController.addListener(_scrollListener);
    await _initializeData();
    super.onInit();
  }

  Future<void> _initializeData() async {
    await _handleLoading(() async {
      categoriesList.addAll(homeViewModel.projCategoriesList);
      _populateAssociationNames();
      await fetchProjects(clear: true);
    });
  }

  void _scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        projects.length < totalRecords) {
      currentPage++;
      await _handleLoading(fetchProjects);
    }
  }

  void _populateAssociationNames() {
    final names = <String>["all".tr];
    names.addAll(homeViewModel.associations.map(
      (a) => Utils.isArabic ? a.accountNameArabic : a.accountName,
    ));
    associationsNames = names.toSet().toList();
    selectedAssociation.refresh();
  }

  Future<void> refreshData() async {
    await fetchProjects(clear: true);
  }

  Future<void> fetchProjects({bool search = false, bool clear = false}) async {
    if (clear) {
      currentPage = 1;
    }

    final queryParameters = _buildQueryParameters();
    final result = await getProjectListPaginated(queryParameters);
    if(result!=null){
      _handleProjectResponse(result, clear: clear);
    }
  }

  Map<String, dynamic> _buildQueryParameters() {
    final int categoryId = selectedCategory.value.value;
    final int accountId = _getSelectedAccountId();
    return {
      "pageNumber": currentPage,
      "pageSize": 10,
      if (accountId != 0) "accountId": accountId,
      if (categoryId != 0) "categoryId": categoryId,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      "isPublished": true,
    };
  }

  int _getSelectedAccountId() {
    final selected = selectedAssociation.value;
    if (selected != null && selected != "all".tr) {
      try {
        return homeViewModel.allAssociations
            .firstWhere((a) => a.accountName == selected)
            .accountId;
      } catch (_) {
        return 0;
      }
    }
    return 0;
  }

  void _handleProjectResponse(BaseApiModel response, {required bool clear}) {
    totalRecords = response.totalRecords;
    final newProjects = List<ProjectElements>.from(
      response.data.map((x) => ProjectElements.fromJson(x)),
    );

    if (clear) {
      projects.value = newProjects;
    } else {
      projects.addAll(newProjects);
    }
  }

  Future<void> _handleLoading(Future<void> Function() task) async {
    Utils.showLoadingDialog();
    try {
      await task();
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  Future<void> onTapCategory(int index) async {
    if (index == categoryIndex.value) return;
    categoryIndex.value = index;
    await _handleLoading(() => fetchProjects(clear: true));
  }

  @override
  void onClose() {
    searchController.dispose();
    searchAssociationController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    categoryIndex.close();
    projects.close();
    selectedAssociation.close();

    super.onClose();
  }

}
