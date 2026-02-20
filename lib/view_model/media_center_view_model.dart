import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/news_archive.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/news_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class MediaCenterViewModel extends GetxController with GetTickerProviderStateMixin, GenericMixin {

  final repo = NewsRepoImpl();

  final RxBool haveArchiveNews = false.obs;
  final RxInt currentTabIndex = 0.obs;
  final RxList<News> latestNews = <News>[].obs;
  final RxList<News> archiveNews = <News>[].obs;
  final RxList<SelectedCategories> archiveCategories = <SelectedCategories>[].obs;

  final List<SelectedCategories> copyCats = [];
  List<News> allNews = [];
  List<LookupData> categoriesList = [];
  final List<String> tabs = ["all".tr];

  int currentPage = 1;
  int pageSize = 10;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController archiveSearchController = TextEditingController();
  final TextEditingController dateRange = TextEditingController();

  final dateFormat = DateFormat('dd MMMM yyyy', Get.locale?.languageCode);
  late TabController tabController;
  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;
  late User user;
  late NewsArchive newsArchive;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.mediaCenterScreen);
    scrollController.addListener(_scrollListener);
    initTabController();
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    if (userBox.isNotEmpty) {
      user = userBox.getAt(0);
    }
    try{
      Utils.showLoadingDialog();
      await fetchCategories();
      await Future.wait([fetchLatestNews(), fetchArchiveNews()]);
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  _tabListener(){
      currentTabIndex.value = tabController.index;
      filterLatestNews();
  }

  initTabController(){
    tabController = TabController(vsync: this, length: tabs.length, initialIndex: 0);
    tabController.addListener(_tabListener);
  }

  _scrollListener() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !haveArchiveNews.value) {
        if (archiveNews.length == newsArchive.totalRecords) return;
        Utils.showLoadingDialog();
        currentPage++;
        await fetchArchiveNews();
        Utils.hideLoadingDialog();
      }
  }

  Future fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.newsCategories);
    if(result.isNotEmpty){
      categoriesList = result;
      for (LookupData data in categoriesList) {
            String catName = Utils.isArabic ? data.nameAr:data.name;
            tabs.add(catName);
            archiveCategories.add(SelectedCategories(catName: catName, id: data.value));
            copyCats.add(SelectedCategories(catName: catName, id: data.value));
          }
      initTabController();
    }
  }

  Future fetchLatestNews() async {
    allNews.clear();
    ApiResponse apiResponse = await repo.latestNews(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      allNews =
          apiResponse.data.where((news) => news.requestStatus == 2).toList();
      latestNews.value = List.from(allNews);
      if (searchController.text.isNotEmpty) filterLatestNews();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  Future fetchArchiveNews({bool clear = false}) async {
    if (clear) {
      currentPage = 1;
      pageSize = archiveNews.length;
    }
    List<int> selectedCategories = archiveCategories
        .where((cat) => cat.isSelected)
        .map((cat) => cat.id)
        .toList();
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (archiveSearchController.text.isNotEmpty)
        "searchText": archiveSearchController.text,
      if (selectedCategories.isNotEmpty)
        "categoryId": selectedCategories.toString(),
      if (selectedDateRange != null) ...{
        "fromDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "todate": Utils.newDateFormat.format(selectedDateRange!.end)
      },
    };
    ApiResponse apiResponse = await repo.fetchArchiveNews(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      newsArchive = apiResponse.data;
      List<News> news = newsArchive.news;
      if (!haveArchiveNews.value && news.isNotEmpty) {
        haveArchiveNews.value = true;
      }
      if (clear) {
        archiveNews.value = news;
      } else {
        archiveNews.addAll(news);
      }
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  addToFavorite(News news, bool isArchive) async {
    var body = {
      "newsId": news.id,
      "userId": user.empId,
      "isFavorite": !news.isFavorite
    };
    final result = await addNewsToFavourite(body: body);
    if(result){
      news.isFavorite = !news.isFavorite;
      isArchive ? archiveNews.refresh() : latestNews.refresh();
    }
  }

  void filterLatestNews() {
    final query = searchController.text.toLowerCase().trim();

    if (currentTabIndex.value == 0) {
      latestNews.value = query.isEmpty ? List.from(allNews)
          : allNews.where((n) => _matchesSearch(n, query)).toList();
    } else {
      final selectedCatId = _getSelectedCategoryId();
      latestNews.value = allNews.where((n) {
        final matchesCat = n.newsCategoryId == selectedCatId;
        final matchesQuery = query.isEmpty || _matchesSearch(n, query);
        return matchesCat && matchesQuery;
      }).toList();
    }
  }

  bool _matchesSearch(News news, String query) {
    final title = Utils.isArabic ? news.titleAr : news.titleEn;
    return title.toLowerCase().contains(query);
  }

  int _getSelectedCategoryId() {
    final tabName = tabs[currentTabIndex.value];
    return categoriesList.firstWhere((cat) => (Utils.isArabic ? cat.nameAr ?? cat.name : cat.name) == tabName,).value;
  }

  filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
        SingleChildScrollView(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              40.verticalSpace,
              buildBottomSheetHeader(),
              Text("categories".tr, style: AppTextStyle.darkGrey14spTextStyle),
              ...List.generate(
                  archiveCategories.length,
                  (index) => ListTileTheme(
                        horizontalTitleGap: 4.w,
                        child: Obx(() => CheckboxListTile(
                              value: archiveCategories[index].isSelected,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) {
                                archiveCategories[index].isSelected = val!;
                                archiveCategories.refresh();
                              },
                              title: Text(archiveCategories[index].catName),
                              // contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              side: BorderSide(color: AppColors.darkGreyColor),
                              activeColor: AppColors.lightBrownColor,
                              controlAffinity: ListTileControlAffinity.leading,
                              checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r)),
                            )),
                      )),
              LabelTextField(
                label: "dateRange",
                onTap: () => datePicker(),
                readOnly: true,
                isBackWhite: true,
                controller: dateRange,
                hint: "${"startDate".tr} - ${"endDate".tr}",
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearFilters(),
                  onApply: () {
                    Get.back();
                    filterArchiveNews();
                  }),
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRange.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    } else {
      dateRange.clear();
      selectedDateRange = null;
    }
  }

  searchArchiveNews() async {
    currentPage = 1;
    Utils.showLoadingDialog();
    archiveNews.clear();
    await fetchArchiveNews();
    Utils.hideLoadingDialog();
  }

  filterArchiveNews() {
    archiveSearchController.clear();
    searchArchiveNews();
  }

  clearFilters() {
    Get.back();
    selectedDateRange = null;
    pageSize = 10;
    currentPage = 1;
    dateRange.clear();
    selectedDateRange = null;
    archiveCategories.value = List.from(copyCats);
    filterArchiveNews();
  }

  openNewsDetailsScreen(id, isArchive) {
    Get.toNamed(AppRoutes.newsDetailScreen,
        arguments: {"id": id, "allNews": true})?.then((val) async {
      Utils.showLoadingDialog();
      await (isArchive ? fetchArchiveNews(clear: true) : fetchLatestNews());
      if (val != null) {
        Future.delayed(const Duration(seconds: 1)).then((_) {
          Utils.hideLoadingDialog();
          openNewsDetailsScreen(val, isArchive);
        });
      } else {
        Utils.hideLoadingDialog();
      }
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    searchController.dispose();
    archiveSearchController.dispose();
    dateRange.dispose();

    tabController.removeListener(_tabListener);
    tabController.dispose();

    haveArchiveNews.close();
    currentTabIndex.close();
    latestNews.close();
    archiveNews.close();
    archiveCategories.close();

    super.onClose();
  }

}
