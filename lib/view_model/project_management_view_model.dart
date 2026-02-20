import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart' as response;
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/home_repo.dart';
import 'package:zakat_fund/repository/project_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ProjectManagementViewModel extends ModulePermissionsViewModel with GenericMixin {
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  final donorsController = TextEditingController();
  final startAmountController = TextEditingController();
  final endAmountController = TextEditingController();

  final donorsNode = FocusNode();
  final startAmountNode = FocusNode();
  final endAmountNode = FocusNode();

  int currentPage = 1;
  int pageSize = 10;
  int totalRecords = 0;
  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedRange;

  Rxn<String> selectedStatus = Rxn<String>();
  Rxn<LookupData> selectedAssociation = Rxn<LookupData>();

  // final genericRepo = GenericRepoImpl();
  final projectRepo = ProjectRepoImpl();
  final homeRepo = HomeRepoImpl();

  List<ProjectElements> allProjects = [];
  RxList<ProjectElements> projects = <ProjectElements>[].obs;
  List<Project> allAssociations = [];
  RxList<LookupData> associationList = <LookupData>[].obs;

  List<DashboardData> dashboardData = [
    DashboardData(title: "totalBeneficiaries", value: "0"),
    DashboardData(title: "totalProjects", value: "0"),
    DashboardData(title: "totalContributions", value: "AED 0"),
  ];

  RxList<StatsData> stats = <StatsData>[
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
  ].obs;

  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {

    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: startAmountNode),
      KeyboardActionsItem(focusNode: endAmountNode),
      KeyboardActionsItem(focusNode: donorsNode),
    ];
    Future.microtask(() async {
      isAdmin.value = user.isAdmin;
      currentDate = DateTime.now();
      dateTimeRange = DateTimeRange(
        start: currentDate.subtract(Duration(days: 1)),
        end: currentDate,
      );
      scrollController.addListener(_scrollListener);
      Utils.logEvent(name: user.isAdmin ? EventConstant.projectManagementScreen : EventConstant.myProjectsScreen);

      if (canView) {
        Utils.showLoadingDialog();
        await Future.wait([
          fetchProjects(showLoader: false),
          if (user.isAdmin) fetchAssociations()
        ]);
        Utils.hideLoadingDialog();
      }
    });
  }

  Future fetchProjects({bool clear = false, bool showLoader = true}) async {
    if (showLoader) Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (selectedAssociation.value != null) "accountId": selectedAssociation.value!.value,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedRange != null) ...{
        "startDate": Utils.newDateFormat.format(selectedRange!.start),
        "endDate": Utils.newDateFormat.format(selectedRange!.end),
      },
      if (startAmountController.text.isNotEmpty) "startAmount": startAmountController.text,
      if (endAmountController.text.isNotEmpty) "endAmount": endAmountController.text,
      if (donorsController.text.isNotEmpty) "noOfDonors": donorsController.text,
      if (selectedStatus.value != null) "status": Utils.statusIntoInt(selectedStatus.value!),
    };
    if(user.isAdmin){
      final result = await getProjectListPaginated(queryParameters);
      if (showLoader) Utils.hideLoadingDialog();
      if(result!=null){
        _setProjectsData(result,clear);
      }
    }else{
      response.ApiResponse apiResponse = await projectRepo.associationAllProjectsPaginated(
          request: RequestBody(
              endPoint:
              "${ApiConstant.associationProjectsPaginated}/${user.accountId}",
              queryParameters: queryParameters));
      if (showLoader) Utils.hideLoadingDialog();
      if (apiResponse.appState == AppState.onSuccess) {
        _setProjectsData(apiResponse.data,clear);
      } else {
        Utils.handleAPIError(apiResponse);
      }
    }
  }

  _setProjectsData(BaseApiModel baseApiModel,bool clear){
    totalRecords = baseApiModel.totalRecords;
    List<ProjectElements> projectsData = List<ProjectElements>.from(
        baseApiModel.data.map((x) => ProjectElements.fromJson(x)));
    clear ? projects.value = projectsData : projects.addAll(projectsData);
    _updateDashboardStats(baseApiModel);
  }

  void _updateDashboardStats(BaseApiModel model) {
    if (user.isAdmin) {
      final statsData = model.projectsStats;
      dashboardData[0].value = "${statsData.totalBeneficiaries}";
      dashboardData[1].value = "${statsData.activeProjects}";
      dashboardData[2].value = "${"currency".tr} ${Utils.getCurrency(statsData.totalDonations.toInt())}";
      stats[0].value = statsData.totalProjects.toString();
      stats[1].value = statsData.accepted.toString();
      stats[2].value = statsData.pending.toString();
      stats[3].value = statsData.returned.toString();
      stats[4].value = statsData.rejected.toString();
      stats.refresh();
    } else {
      final statsData = model.stats;
      dashboardData[0].value = "${statsData.totalBeneficiaries}";
      dashboardData[1].value = "$totalRecords";
      dashboardData[2].value = "${"currency".tr} ${Utils.getCurrency(statsData.overAllReceivedDonations)}";
      projects.refresh();
    }


  }

  filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
        KeyboardDismissOnTap(
          child: KeyboardActions(
            config: Utils.buildConfig(Get.context!, keyboardActionsItem),
            autoScroll: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildBottomSheetHeader(),
                  if (user.isAdmin)
                    Obx(() => LabelDropDown2(
                          items: associationList.value,
                          selectedValue: selectedAssociation.value,
                          onChanged: (value) =>
                              selectedAssociation.value = value,
                          label: 'association',
                          hint: 'chooseAnOption',
                        )),
                  if (user.isAdmin) 16.verticalSpace,
                  LabelTextField(
                    controller: dateController,
                    label: "date",
                    isDate: true,
                    readOnly: true,
                    hint: "${"startDate".tr} - ${"endDate".tr}",
                    onTap: () => dateRangePicker(),
                  ),
                  16.verticalSpace,
                  textFieldLabel(label: 'totalDonation'),
                  4.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: LabelTextField(
                          controller: startAmountController,
                          hint: "startAmount",
                          label: '',
                          focusNode: startAmountNode,
                          showLabel: false,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: LabelTextField(
                          controller: endAmountController,
                          label: '',
                          showLabel: false,
                          focusNode: endAmountNode,
                          keyboardType: TextInputType.number,
                          hint: "endAmount",
                          inputFormatters: InputFormatters.amountFormatter,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  LabelTextField(
                    controller: donorsController,
                    label: "noOfDonors",
                    focusNode: donorsNode,
                    keyboardType: TextInputType.number,
                  ),
                  16.verticalSpace,
                  Obx(() => LabelDropDown(
                        items: user.isAdmin
                            ? AppConstant.statuses
                            : AppConstant.statusesWithDraft,
                        selectedValue: selectedStatus.value,
                        hint: "chooseAnOption",
                        onChanged: (value) {
                          selectedStatus.value = value;
                        },
                        label: 'status',
                      )),
                  20.verticalSpace,
                  buildBottomSheetButtons(
                      onClear: () => clearFilter(),
                      onApply: () {
                        Get.back();
                        pageSize = 10;
                        fetchProjects(clear: true);
                      })
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    dateController.clear();
    selectedRange = null;
    donorsController.clear();
    startAmountController.clear();
    endAmountController.clear();
    selectedStatus.value = null;
    selectedAssociation.value = null;
    pageSize = 10;
    fetchProjects(clear: true);
  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedRange, dateTimeRange, DateTime(currentDate.year + 50));
    if (newDateRange != null) {
      selectedRange = newDateRange;
      dateController.text =
          "${Utils.dateFormat1.format(selectedRange!.start)} - ${Utils.dateFormat1.format(selectedRange!.end)}";
    } else {
      dateController.clear();
      selectedRange = null;
    }
  }

  enableDisable(ProjectElements projectDetails) async {
    Utils.showLoadingDialog();
    projectDetails.isPublished = !projectDetails.isPublished;
    var body = {
      "id": projectDetails.projectId,
      "isActive": projectDetails.isPublished
    };
    ApiResponse apiResponse = await projectRepo.enableDisableProject(
        request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: projectDetails.isPublished ? "projectActivatedSuccessfully".tr : "projectDeactivatedSuccessfully".tr);
      projects.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchAssociations() async {
    ApiResponse apiResponse =
        await homeRepo.fetchAssociations(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      allAssociations = apiResponse.data;
      associationList.value = allAssociations
          .map((association) => LookupData(
              nameAr: association.accountNameArabic,
              name: association.accountName,
              value: association.accountId))
          .toList();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  exportProjects() {
    String url = "",fileName = "";
    if(user.isAdmin){
      url = ApiConstant.exportAllProjects;
      fileName = "All_Projects.csv";
    }else{
      url = "${ApiConstant.exportAssociationProjects}${user.accountId}?pageNumber=$currentPage&pageSize=$pageSize";
      fileName = "Projects.csv";
    }
    Utils.downloadFile(url: url, isExport: true, filename: fileName);
  }

  onPopUpMenuSelected(String value, ProjectElements project) {
    if (value == "view") {
      Get.toNamed(AppRoutes.projectDetailsScreen,
          arguments: {"project": project, "isPreview": true});
    } else {
      Get.toNamed(AppRoutes.createProjectScreen, arguments: project)!
          .then((val) {
        if (val != null && val) {
          if (canView) {
            pageSize = projects.length;
            fetchProjects(clear: true);
          }
        }
      });
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (projects.length == totalRecords) {
        return;
      }
      currentPage++;
      fetchProjects();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    searchController.dispose();
    dateController.dispose();
    donorsController.dispose();
    startAmountController.dispose();
    endAmountController.dispose();

    donorsNode.dispose();
    startAmountNode.dispose();
    endAmountNode.dispose();

    selectedStatus.close();
    selectedAssociation.close();
    projects.close();
    associationList.close();
    stats.close();
    super.onClose();
  }

}
