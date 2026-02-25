import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/faq_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cms_faq_view_model.dart';

class FaqViewModel extends GetxController with GetTickerProviderStateMixin {
  final FaqRepo faqRepo = FaqRepoImpl();

  final RxList<FaqCategory> faqs = <FaqCategory>[].obs;
  final RxList<FaQs> subFaqs = <FaQs>[].obs;
  final TextEditingController searchController = TextEditingController();

  final RxInt currentTabIndex = 0.obs;

  List<FaQs> allFaqs = [];
  final List<String> tabs = ["all".tr];
  List<String> englishCats = [];
  List<String> arabicCats = [];

  late final TabController tabController;
  late final String currentLocal;

  int preIndex = -1;
  bool isPreview = false;

  @override
  onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.faqsScreen);
    isPreview = Get.arguments ?? false;
    currentLocal = Get.locale!.languageCode;
    if (isPreview) {
      _loadPreviewData();
    } else {
      _loadFaqDataFromAPI();
    }
  }

  _loadPreviewData() {
    final cmsController = Get.find<CMSFaqViewModel>();
    faqs.value = List.from(cmsController.categories);
    englishCats.addAll(cmsController.englishCats);
    arabicCats.addAll(cmsController.arabicCats);
    tabs.addAll(Utils.isArabic ? arabicCats : englishCats);
    allFaqs.addAll(cmsController.previewFAQs);
    subFaqs.value = List.from(allFaqs);
    preIndex = subFaqs.length - 1;
    _initTabController();
  }

  Future<void> _loadFaqDataFromAPI() async {
    try{
      Utils.showLoadingDialog();
      await _fetchFaqCategories();
      await _fetchFaqItems();
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  Future _fetchFaqCategories() async {
    ApiResponse apiResponse = await faqRepo.fetchFAQCategories(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      faqs.value = apiResponse.data;
      tabs.addAll(faqs.map((cat) => Utils.isArabic ? cat.titleArabic : cat.title));
      _initTabController();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  void _initTabController() {
    tabController = TabController(vsync: this, length: faqs.length + 1, initialIndex: 0);
    tabController.addListener(_tabListener);
  }

  _tabListener(){
      currentTabIndex.value = tabController.index;
      if (preIndex != -1) {
        subFaqs[preIndex].isExpanded = false;
        preIndex = -1;
      }
      filterFAQ();
  }

  void filterFAQ() {
    final query = searchController.text.toLowerCase().trim();

    if (currentTabIndex.value == 0) {
      subFaqs.value = query.isEmpty
          ? List.from(allFaqs)
          : allFaqs.where((faq) => _matchesQuery(faq, query)).toList();
    } else {
      final selectedCategoryId = _getCurrentCategoryId();
      subFaqs.value = allFaqs.where((faq) {
        final matchCategory = faq.categoryId == selectedCategoryId;
        final matchSearch = query.isEmpty || _matchesQuery(faq, query);
        return matchCategory && matchSearch;
      }).toList();
    }
  }

  bool _matchesQuery(FaQs faq, String query) {
    final question = Utils.isArabic ? faq.questionArabic : faq.question;
    return question.toLowerCase().contains(query);
  }

  int _getCurrentCategoryId() {
    final categoryName = tabs[currentTabIndex.value];
    final match = faqs.firstWhere(
          (faq) => (Utils.isArabic ? faq.titleArabic : faq.title) == categoryName,
      orElse: () => FaqCategory(categoryId: -1, title: '', titleArabic: ''),
    );
    return match.categoryId;
  }

  Future _fetchFaqItems() async {
    ApiResponse apiResponse = await faqRepo.fetchFAQs(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      allFaqs.addAll(apiResponse.data.where((faq) => faq.requestStatus == 2),);
      subFaqs.value = List.from(allFaqs);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }


  handlePopScope() {
    if (isPreview) {
      Get.updateLocale(Locale(currentLocal));
    }
    Future.microtask(() {
      Get.back();
    });
    return Future.value(false);
  }

  void toggleLanguage() {
    tabs.clear();
    final isArabic = Utils.isArabic;
    final baseTab = isArabic ? "All" : "الجميع";
    final categories = isArabic ? englishCats : arabicCats;
    tabs.add(baseTab);
    tabs.addAll(categories);
    Get.updateLocale(Locale(isArabic ? "en" : "ar"));
  }

  onExpansionCallback(int index, bool isExpanded) {
    if (preIndex != -1) {
      subFaqs[preIndex].isExpanded = false;
    }
    preIndex = index;
    subFaqs[index].isExpanded = isExpanded;
    subFaqs.refresh();
  }

  goToBack() {
    Get.updateLocale(Locale(currentLocal));
    Future.microtask(() => Get.back());
  }

  @override
  void onClose() {
    searchController.dispose();
    tabController.removeListener(_tabListener);
    tabController.dispose();

    faqs.close();
    subFaqs.close();
    currentTabIndex.close();
    super.onClose();
  }

}
