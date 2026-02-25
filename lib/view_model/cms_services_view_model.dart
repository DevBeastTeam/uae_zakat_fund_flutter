import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/services_repo.dart';
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

class CMSServicesViewModel extends ModulePermissionsViewModel with GenericMixin {
  int pageSize = 10;
  final scrollController = ScrollController();
  int currentPage = 1;
  int totalRecords = 0;

  final searchController = TextEditingController();
  final dateController = TextEditingController();

  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  final selectedCat = Rxn<LookupData>();
  final selectedStatus = Rxn<String>();

  RxList<StatsData> stats = [
    StatsData(
        title: "total",
        value: "0",
        titleStyle: AppTextStyle.btnBackground12spTextStyle1,
        valueStyle: AppTextStyle.btnBackground16spTextStyle,
        backgroundColor: AppColors.btnBackgroundColor),
    StatsData(
        title: "approved",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: AppColors.darkGreenColor),
    StatsData(
        title: "pending",
        value: "0",
        titleStyle: AppTextStyle.lightBrown12spTextStyle2,
        valueStyle: AppTextStyle.lightBrown16spTextStyle1,
        backgroundColor: AppColors.lightBrownColor1),
    StatsData(
        title: "returned",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor),
    StatsData(
        title: "rejected",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor)
  ].obs;

  final services = <OurServices>[].obs;

  final categoriesList = <LookupData>[].obs;

  final repo = ServicesRepoImpl();

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.cmsServicesScreen);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    scrollController.addListener(_scrollListener);
    try{
      Utils.showLoadingDialog();
      await fetchCategories();
      if (canView) await fetchServices();
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  _scrollListener() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (services.length == totalRecords) {
          return;
        }
        Utils.showLoadingDialog();
        currentPage++;
        await fetchServices();
        Utils.hideLoadingDialog();
      }
  }



  Future fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.serviceCategories);
    categoriesList.value = result;
  }

  Future fetchServices({bool clear = false}) async {
    if (clear) {
      Utils.showLoadingDialog();
      currentPage = 1;
    }
    int catId = 0;
    if (selectedCat.value != null) {
      catId = selectedCat.value!.value;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedCat.value != null) "serviceCategory": catId,
      if (selectedDateRange != null)
        "fromDateOfCreation":
            Utils.newDateFormat.format(selectedDateRange!.start),
      if (selectedDateRange != null)
        "toDateOfCreation": Utils.newDateFormat.format(selectedDateRange!.end),
    };
    ApiResponse apiResponse = await repo.fetchCMSServices(
        request: RequestBody(queryParameters: queryParameters));
    if (clear) {
      Utils.hideLoadingDialog();
    }
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats newsStats = baseApiModel.stats;
      _updateStats(newsStats);
      List<OurServices> servicesData = List<OurServices>.from(
          baseApiModel.data.map((x) => OurServices.fromJson(x)));
      if (clear) {
        services.value = servicesData;
      } else {
        services.addAll(servicesData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _updateStats(Stats statsData) {
    stats[0].value = statsData.total.toString();
    stats[1].value = statsData.accepted.toString();
    stats[2].value = statsData.pending.toString();
    stats[3].value = statsData.returned.toString();
    stats[4].value = statsData.rejected.toString();
    stats.refresh();
  }

  addNewService({OurServices? service}) {
    Get.toNamed(AppRoutes.addServiceScreen, arguments: service)?.then((val) {
      if (val != null && val) {
        if (canView) fetchServices(clear: true);
      }
    });
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
                controller: dateController,
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearAll(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    fetchServices(clear: true);
                  })
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearAll() {
    Get.back();
    searchController.clear();
    dateController.clear();
    selectedDateRange = null;
    selectedStatus.value = null;
    selectedCat.value = null;
    pageSize = 10;
    fetchServices(clear: true);
  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateController.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    } else {
      dateController.clear();
      selectedDateRange = null;
    }
  }

  updateStatus(OurServices service) async {
    Utils.showLoadingDialog();
    var body = {
      "isActive": !service.isActive,
      "id": service.id,
    };
    ApiResponse apiResponse =
        await repo.activeDeActiveService(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      service.isActive = !service.isActive;
      services.refresh();
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  exportServices() {
    Utils.downloadFile(
        url: ApiConstant.exportServices,
        isExport: true,
        filename: "Services.csv");
  }

  onMenuSelected(String item, OurServices service) {
    if (item == "edit") {
      addNewService(service: service);
    } else {
      Get.toNamed(AppRoutes.serviceDetails,
          arguments: {"service": service, "showPreview": true});
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    searchController.dispose();
    dateController.dispose();
    scrollController.dispose();

    selectedCat.close();
    selectedStatus.close();
    stats.close();
    services.close();
    categoriesList.close();

    super.onClose();
  }

}
