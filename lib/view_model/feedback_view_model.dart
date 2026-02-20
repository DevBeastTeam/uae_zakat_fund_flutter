import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/feedbacks.dart';
import 'package:zakat_fund/model/management_staff.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/emp_repo.dart';
import 'package:zakat_fund/repository/feedback_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class FeedbackViewModel extends ModulePermissionsViewModel {
  final formKey = GlobalKey<FormState>();
  final feedbackIdController = TextEditingController();
  final dateController = TextEditingController();
  final searchController = TextEditingController();

  final Rxn<String> selectedStatus = Rxn<String>();
  final Rxn<String> selectedFeedbackType = Rxn<String>();
  final Rxn<String> selectedAssignTo = Rxn<String>();

  final RxList<Feedbacks> feedback = <Feedbacks>[].obs;
  final List<Feedbacks> allFeedbacks = [];
  List<String> assignees = [];
  final List<int> selectedFeedbacks = [];

  final RxList<StatsData> stats = <StatsData>[
    StatsData(
        title: "total",
        value: "0",
        titleStyle: AppTextStyle.btnBackground12spTextStyle1,
        valueStyle: AppTextStyle.btnBackground16spTextStyle,
        backgroundColor: AppColors.btnBackgroundColor),
    StatsData(
        title: "suggestion",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: AppColors.darkGreenColor),
    StatsData(
        title: "support",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: AppColors.darkGreenColor),
    StatsData(
        title: "complaint",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor),
  ].obs;

  late final DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  int totalRecords = 0;
  int pageSize = 10;

  final FeedbackRepoImpl repo = FeedbackRepoImpl();
  final EmpRepoImpl empRepo = EmpRepoImpl();
  List<SahemEmployees> employees = [];

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    Future.microtask(() async {
      Utils.logEvent(
          name: user.isAdmin
              ? EventConstant.feedbackManagementScreen
              : EventConstant.myFeedbacksScreen);
      scrollController.addListener(_scrollListener);
      await Future.wait([
        if (canView) fetchAllFeedbacks(),
        if (user.isAdmin) fetchEmployees(),
      ]);
    });
  }



  _scrollListener() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (user.isAdmin && canView) {
          if (feedback.length == totalRecords) {
            return;
          }
          currentPage++;
          fetchAllFeedbacks();
        }
      }
  }

  Future fetchAllFeedbacks({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedFeedbackType.value != null)
        "feedbackType": Utils.feedbackTypeIntoInt(selectedFeedbackType.value!),
      if (selectedDateRange != null) ...{
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      }
    };
    ApiResponse apiResponse = user.isAdmin
        ? await repo.allFeedbacksPaginated(
            request: RequestBody(queryParameters: queryParameters))
        : await repo.feedbackByUserIdPaginated(
            request: RequestBody(
                queryParameters: queryParameters,
                endPoint:
                    "${ApiConstant.feedbackByUserIdPaginated}${user.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats statsData = baseApiModel.stats;
      _updateStats(statsData);
      List<Feedbacks> associationsData = List<Feedbacks>.from(
          baseApiModel.data.map((x) => Feedbacks.fromJson(x)));
      if (clear) {
        feedback.value = associationsData;
      } else {
        feedback.addAll(associationsData);
      }
      feedback.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _updateStats(Stats statsData) {
    stats[0].value = statsData.total.toString();
    stats[1].value = statsData.suggestions.toString();
    stats[2].value = statsData.support.toString();
    stats[3].value = statsData.complaints.toString();
    stats.refresh();
  }

  assignDialog({int? id}) {
    if (id == null) {
      Utils.hideKeyboard();
      if (selectedFeedbacks.isEmpty) {
        Utils.showGlobalSnackBar(message: "pleaseSelectFeedbacks".tr);
        return;
      }
    }
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "assignFeedback".tr,
                      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.highlight_remove_outlined,
                        color: AppColors.secondaryPrimaryBlackColor,
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppResources.infoIcon),
                    10.verticalSpace,
                    Text(
                      id == null ? "assignBulkFeedback".tr : "areYouSure".tr,
                      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                    ),
                    10.verticalSpace,
                    Text(
                      id == null
                          ? "sureAssignBulk".tr
                          : "assignSelectedFeedback".tr,
                      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
                    ),
                    10.verticalSpace,
                    Obx(() => Form(
                          key: formKey,
                          child: LabelDropDown(
                            items: assignees,
                            selectedValue: selectedAssignTo.value,
                            hint: "chooseAnOption",
                            isRequired: true,
                            isBackWhite: true,
                            onChanged: (value) {
                              selectedAssignTo.value = value;
                            },
                            label: 'assignTo',
                          ),
                        )),
                    16.verticalSpace,
                    elevatedButton(
                        text: "assign",
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (id == null) {
                            Utils.logEvent(name: EventConstant.assignBulkClick);
                          }
                          Get.back();
                          assignFeedback(id: id);
                        }),
                    8.verticalSpace,
                    elevatedButton(
                      text: "cancel",
                      onPressed: () {
                        Get.back();
                      },
                      backgroundColor: AppColors.lightGreyColor,
                    ),
                    16.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    )).then((_) {
      Future.delayed(Duration(seconds: 1)).then((_) {
        selectedAssignTo.value = null;
      });
    });
  }

  Future fetchEmployees() async {
    ApiResponse apiResponse =
        await empRepo.fetchSahemEmployees(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      employees = apiResponse.data;
      assignees = employees
          .map((emp) => Utils.isArabic
              ? "${emp.firstNameArabic} ${emp.lastNameArabic} (${emp.id})"
              : "${emp.firstName} ${emp.lastName} (${emp.id})")
          .toList();
    } else {
      Utils.handleAPIError(apiResponse);
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
                    items: AppConstant.feedbackTypes,
                    selectedValue: selectedFeedbackType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedFeedbackType.value = value;
                    },
                    label: 'feedbackType',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.statuses,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                    label: 'status',
                  )),
              16.verticalSpace,
              LabelTextField(
                controller: dateController,
                label: "creationDate",
                isDate: true,
                readOnly: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                onTap: () => dateRangePicker(),
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                onClear: () => clearFilter(),
                onApply: () {
                  Get.back();
                  fetchAllFeedbacks(clear: true);
                },
              ),
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    selectedFeedbackType.value = null;
    dateController.clear();
    selectedStatus.value = null;
    selectedDateRange = null;
    fetchAllFeedbacks(clear: true);
  }

  deleteFeedback(int index) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteFeedback(
        request: RequestBody(
            endPoint: "${ApiConstant.deleteFeedback}/${feedback[index].id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      feedback.removeAt(index);
      feedback.refresh();
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  assignFeedback({int? id}) async {
    Utils.showLoadingDialog();
    var body = [];
    if (id != null) {
      body = [id];
    } else {
      body = selectedFeedbacks;
    }
    int userId = int.parse(Utils.employeeId(selectedAssignTo.value!));
    ApiResponse apiResponse = await repo.assignFeedback(request: RequestBody(endPoint: "${ApiConstant.assignFeedback}/$userId", body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  dateRangePicker({bool cDate = false}) async {
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

  addNewFeedbackScreen() {
    Get.toNamed(AppRoutes.addFeedbackScreen)?.then((val) {
      if (val != null && val) {
        pageSize = 10;
        if (canView) {
          fetchAllFeedbacks(clear: true);
        }
      }
    });
  }

  exportFeedbacks() {
    Utils.downloadFile(
      url: user.isAdmin
          ? ApiConstant.exportFeedbacks
          : ApiConstant.exportUserFeedbacks,
      isExport: true,
      filename: user.isAdmin ? "Feedbacks.csv" : "Feedbacks_List.csv",
    );
  }

  oncCheckboxChanged(bool val, Feedbacks feedbacks) {
    feedbacks.selected = val;
    feedback.refresh();
    if (val) {
      selectedFeedbacks.add(feedbacks.id);
    } else {
      selectedFeedbacks.remove(feedbacks.id);
    }
  }

  onPopupMenuSelected(String item, int id) {
    if (item == "view") {
      Get.toNamed(AppRoutes.feedbackPreviewScreen, arguments: {
        "id": id,
        "isAdmin": false,
      })?.then((val) {
        if (val != null && val) {
          pageSize = feedback.length;
          fetchAllFeedbacks(clear: true);
        }
      });
    } else {
      assignDialog(id: id);
    }
  }

  @override
  void onClose() {
    feedbackIdController.dispose();
    dateController.dispose();
    searchController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    feedback.close();
    selectedStatus.close();
    selectedFeedbackType.close();
    selectedAssignTo.close();
    stats.close();

    super.onClose();
  }

}
