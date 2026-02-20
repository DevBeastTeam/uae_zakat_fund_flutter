import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/news_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class CMSNewsViewModel extends ModulePermissionsViewModel with GenericMixin {
  final searchController = TextEditingController();
  final creationDate = TextEditingController();
  final scrollController = ScrollController();
  final repo = NewsRepoImpl();

  int pageSize = 10;
  int currentPage = 1;
  int totalRecords = 0;

  late DateTimeRange dateTimeRange;
  late DateTime currentDate;
  DateTimeRange? selectedDateRange;

  RxList<LookupData> categoriesList = <LookupData>[].obs;
  Rxn<String> selectedStatus = Rxn<String>();
  Rxn<LookupData> selectedCat = Rxn<LookupData>();

  RxList<News> news = <News>[].obs;
  RxList<StatsData> stats = <StatsData>[].obs;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.cmsNewsScreen);
    _initializeDateRange();
    scrollController.addListener(_scrollListener);
    try{
      Utils.showLoadingDialog();
      await fetchCategories();
      if (canView) {
        await fetchNewsData();
      }
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  void _initializeDateRange() {
    stats.value = [
      StatsData(
        title: "total",
        value: "0",
        titleStyle: AppTextStyle.btnBackground12spTextStyle1,
        valueStyle: AppTextStyle.btnBackground16spTextStyle,
        backgroundColor: AppColors.btnBackgroundColor,
      ),
      StatsData(
        title: "approved",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: AppColors.darkGreenColor,
      ),
      StatsData(
        title: "pending",
        value: "0",
        titleStyle: AppTextStyle.lightBrown12spTextStyle2,
        valueStyle: AppTextStyle.lightBrown16spTextStyle1,
        backgroundColor: AppColors.lightBrownColor1,
      ),
      StatsData(
        title: "returned",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor,
      ),
      StatsData(
        title: "rejected",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor,
      )
    ];
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
  }

  _scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        news.length < totalRecords) {
      Utils.showLoadingDialog();
      currentPage++;
      await fetchNewsData();
      Utils.hideLoadingDialog();
    }
  }

  Future<void> fetchNewsData({bool clear = false}) async {
    user.isAdmin
        ? await fetchNews(clear: clear)
        : await fetchAssociationNews(clear: clear);
  }

  Future<void> fetchNews({bool clear = false}) async {
    await _fetchNews(apiCall: repo.fetchAllNewsPaginated, clear: clear);
  }

  Future<void> fetchAssociationNews({bool clear = false}) async {
    await _fetchNews(apiCall: repo.associationNewsPaginated, clear: clear);
  }

  Future<void> _fetchNews(
      {required Future<ApiResponse<dynamic>> Function(
              {required RequestBody request})
          apiCall,
      bool clear = false}) async {
    if (clear) {
      Utils.showLoadingDialog();
      currentPage = 1;
    }

    Map<String, dynamic> queryParameters = {
      if (!user.isAdmin) "id": user.accountId,
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedCat.value != null) "newsCategory": _getCategoryId(),
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedDateRange != null)
        "fromDateOfCreation":
            Utils.newDateFormat.format(selectedDateRange!.start),
      if (selectedDateRange != null)
        "toDateOfCreation": Utils.newDateFormat.format(selectedDateRange!.end),
    };

    ApiResponse apiResponse =
        await apiCall(request: RequestBody(queryParameters: queryParameters));

    if (clear) Utils.hideLoadingDialog();

    if (apiResponse.appState == AppState.onSuccess) {
      _updateNewsData(apiResponse.data, clear);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  int _getCategoryId() {
    return selectedCat.value!.value;
  }

  void _updateNewsData(BaseApiModel baseApiModel, bool clear) {
    totalRecords = baseApiModel.totalRecords;
    _updateStats(baseApiModel.stats);

    List<News> newsData =
        List<News>.from(baseApiModel.data.map((x) => News.fromJson(x)));
    if (clear) {
      news.value = newsData;
    } else {
      news.addAll(newsData);
    }
  }

  void _updateStats(Stats newsStats) {
    stats[0].value = newsStats.total.toString();
    stats[1].value = newsStats.accepted.toString();
    stats[2].value = newsStats.pending.toString();
    stats[3].value = newsStats.returned.toString();
    stats[4].value = newsStats.rejected.toString();
    stats.refresh();
  }

  Future<void> fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.newsCategories);
    categoriesList.value = result;
  }

  filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
        Padding(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetHeader(),
              Obx(() => LabelDropDown2(
                    items: categoriesList.value,
                    selectedValue: selectedCat.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedCat.value = value;
                    },
                    label: 'category',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.statusesWithDraft,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                    label: 'status',
                  )),
              16.verticalSpace,
              LabelTextField(
                label: "creationDate",
                onTap: () => dateRangePicker(),
                readOnly: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                isDate: true,
                controller: creationDate,
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearAll(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    user.isAdmin
                        ? fetchNews(clear: true)
                        : fetchAssociationNews(clear: true);
                  }),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  void clearAll() {
    Get.back();
    searchController.clear();
    creationDate.clear();
    selectedDateRange = null;
    selectedStatus.value = null;
    selectedCat.value = null;
    pageSize = 10;
    fetchNewsData(clear: true);
  }

  addNewNews({News? news}) {
    Get.toNamed(AppRoutes.addNewsScreen, arguments: news)?.then((val) {
      if (val != null && val) {
        if (canView) {
          fetchNewsData(clear: true);
        }
      }
    });
  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      creationDate.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    } else {
      creationDate.clear();
      selectedDateRange = null;
    }
  }

  enableDisable(News newsData) async {
    Utils.showLoadingDialog();
    newsData.isActive = !newsData.isActive;
    var body = {"id": newsData.id, "isActive": newsData.isActive};
    ApiResponse apiResponse =
        await repo.enableDisableNews(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message: newsData.isActive
              ? "newsActivatedSuccessfully".tr
              : "newsDeactivatedSuccessfully".tr);
      news.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  exportNews() {
    Utils.downloadFile(
        url: user.isAdmin
            ? ApiConstant.exportNews
            : "${ApiConstant.exportAssociationNews}${user.accountId}",
        isExport: true,
        filename: user.isAdmin ? "News.csv" : "Association_News.csv");
  }

  onPopUpMenuSelected(String value, News news) {
    if (value == "edit") {
      addNewNews(news: news);
    } else {
      Get.toNamed(AppRoutes.newsDetailScreen, arguments: {
        "preview": true,
        "allNews": false,
        "news": news,
        "id": news.id
      });
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    searchController.dispose();
    creationDate.dispose();
    scrollController.dispose();

    categoriesList.close();
    selectedCat.close();
    selectedStatus.close();
    news.close();
    stats.close();
    super.onClose();
  }
}
