import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/company_repo.dart';
import 'package:zakat_fund/repository/individual_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class AllDonorsViewModel extends ModulePermissionsViewModel {

  final searchController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final registrationDateController = TextEditingController();

  RxList<Individual> donors = <Individual>[].obs;
  RxnString selectedNationality = RxnString();
  RxnString selectedActiveStatus = RxnString();

  final repo = IndividualRepoImpl();
  final companyRepo = CompanyRepoImpl();
  final accountViewModel = Get.find<AccountViewModel>();

  int currentPage = 1;
  int totalRecords = 0;
  final scrollController = ScrollController();

  DateTimeRange? selectedDOBRange;
  DateTimeRange? selectedRDRange;
  late final DateTime currentDate;
  late final DateTimeRange dateTimeRange;

  final RxList<StatsData> stats = [
    StatsData(
      title: "total",
      value: "0",
      titleStyle: AppTextStyle.btnBackground12spTextStyle1,
      valueStyle: AppTextStyle.btnBackground16spTextStyle,
      backgroundColor: AppColors.btnBackgroundColor,
    ),
    StatsData(
      title: "active",
      value: "0",
      titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
      valueStyle: AppTextStyle.darkGreen16spTextStyle1,
      backgroundColor: AppColors.darkGreenColor,
    ),
    StatsData(
      title: "inactive",
      value: "0",
      titleStyle: AppTextStyle.highBack12spTextStyle,
      valueStyle: AppTextStyle.highBack16spTextStyle,
      backgroundColor: AppColors.highBackColor,
    )
  ].obs;


  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.allDonorsScreen);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    scrollController.addListener(_scrollListener);

    if (canView) fetchAllDonors();
  }

  _scrollListener(){
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (donors.length == totalRecords) {
          return;
        }
        currentPage++;
        fetchAllDonors();
      }
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
              Obx(() => LabelDropDown(
                    items: accountViewModel.nationalities,
                    selectedValue: selectedNationality.value,
                    hint: "chooseAnOption",
                    showSearch: true,
                    onChanged: (value) {
                      selectedNationality.value = value;
                    },
                    label: 'nationality',
                  )),
              16.verticalSpace,
              LabelTextField(
                label: "dob",
                onTap: () => datePicker(isDOB: true),
                readOnly: true,
                controller: dateOfBirthController,
                hint: "${"startDate".tr} - ${"endDate".tr}",
              ),
              16.verticalSpace,
              LabelTextField(
                label: "registrationDate",
                onTap: () => datePicker(),
                readOnly: true,
                controller: registrationDateController,
                hint: "${"startDate".tr} - ${"endDate".tr}",
              ),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.activeInActiveStatuses,
                    selectedValue: selectedActiveStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedActiveStatus.value = value;
                    },
                    label: '${"active".tr}/${"inactive".tr}',
                  )),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearAllFilters(),
                  onApply: () {
                    Get.back();
                    fetchAllDonors(clear: true);
                  })
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearAllFilters() {
    Get.back();
    selectedNationality.value = null;
    selectedActiveStatus.value = null;
    registrationDateController.clear();
    dateOfBirthController.clear();
    selectedDOBRange = null;
    selectedRDRange = null;
    fetchAllDonors(clear: true);
  }

  fetchAllDonors({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    int nationalityId = 0;
    if (selectedNationality.value != null) {
      nationalityId = accountViewModel.nationalitiesList.firstWhere((cat) {
        String catName = Utils.isArabic ? cat.nameAr : cat.name;
        return catName == selectedNationality.value;
      }).value;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": 10,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedDOBRange != null) ...{
        "DateOfBirthStart": Utils.newDateFormat.format(selectedDOBRange!.start),
        "DateOfBirthEnd": Utils.newDateFormat.format(selectedDOBRange!.end)
      },
      if (selectedRDRange != null) ...{
        "RegistrationDateStart": Utils.newDateFormat.format(selectedRDRange!.start),
        "RegistrationDateEnd": Utils.newDateFormat.format(selectedRDRange!.end)
      },
      if (selectedNationality.value != null) "nationalityId": nationalityId,
      if (selectedActiveStatus.value != null)"isActive": selectedActiveStatus.value == "active",
    };
    ApiResponse apiResponse = await repo.fetchAllDonors(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats donorStats = baseApiModel.stats;
      _updateStats(donorStats);
      List<Individual> individuals = List<Individual>.from(
          baseApiModel.data.map((x) => Individual.fromJson(x)));
      if (clear) {
        donors.value = individuals;
      } else {
        donors.addAll(individuals);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _updateStats(Stats donorStats) {
    stats[0].value = donorStats.total.toString();
    stats[1].value = donorStats.active.toString();
    stats[2].value = donorStats.inActive.toString();
    stats.refresh();
  }

  datePicker({bool isDOB = false}) async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        isDOB ? selectedDOBRange : selectedRDRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      if (isDOB) {
        selectedDOBRange = newDateRange;
        dateOfBirthController.text =
            "${Utils.dateFormat1.format(selectedDOBRange!.start)} - ${Utils.dateFormat1.format(selectedDOBRange!.end)}";
      } else {
        selectedRDRange = newDateRange;
        registrationDateController.text =
            "${Utils.dateFormat1.format(selectedRDRange!.start)} - ${Utils.dateFormat1.format(selectedRDRange!.end)}";
      }
    } else {
      if (isDOB) {
        dateOfBirthController.clear();
        selectedDOBRange = null;
      } else {
        registrationDateController.clear();
        selectedRDRange = null;
      }
    }
  }

  enableDisable(Individual donor) async {
    Utils.showLoadingDialog();
    donor.contactInfo!.isActive = !donor.contactInfo!.isActive;
    var body = {
      "id": donor.contactInfo!.userId,
      "isActive": donor.contactInfo!.isActive,
      "userType": "Donor"
    };
    ApiResponse apiResponse = await companyRepo.enableDisableCompany(
        request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message: donor.contactInfo!.isActive
              ? "userActivatedSuccessfully".tr
              : "userDeactivatedSuccessfully".tr);
      if (donor.contactInfo!.isActive) {
        stats[1].value = "${int.parse(stats[1].value) + 1}";
        stats[2].value = "${int.parse(stats[2].value) - 1}";
      } else {
        stats[2].value = "${int.parse(stats[2].value) + 1}";
        stats[1].value = "${int.parse(stats[1].value) - 1}";
      }
      if (selectedActiveStatus.value != null) {
        donors.remove(donor);
      }
      stats.refresh();
      donors.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  exportDonors() {
    Utils.downloadFile(
        url: "${ApiConstant.exportFile}${AppConstant.donor}",
        isExport: true,
        filename: "Donors.csv");
  }

  onMenuSelected(Individual donor) {
    Get.toNamed(AppRoutes.donorPreviewScreen, arguments: donor);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    searchController.dispose();
    dateOfBirthController.dispose();
    registrationDateController.dispose();
    scrollController.dispose();

    donors.close();
    selectedNationality.close();
    selectedActiveStatus.close();
    stats.close();

    super.onClose();
  }

}
