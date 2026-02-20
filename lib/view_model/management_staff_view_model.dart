import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as dateformat;
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/management_staff.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/emp_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/association/management_staff/add_employee_screen.dart';
import 'package:zakat_fund/view_model/add_emp_view_model.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class ManagementStaffViewModel extends ModulePermissionsViewModel with GenericMixin {
  RxList<ManagementStaff> employees = <ManagementStaff>[].obs;
  RxList<LookupData> jobList = <LookupData>[].obs;
  RxList<LookupData> sahemRolesList = <LookupData>[].obs;

  final repo = EmpRepoImpl();

  final searchController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  Rxn<LookupData> selectedJob = Rxn<LookupData>();
  Rxn<LookupData> selectedRole = Rxn<LookupData>();
  Rxn<String> selectedStatus = Rxn<String>();
  Rxn<String> selectedActive = Rxn<String>();
  DateTimeRange? selectedDateRange;

  int currentPage = 1;
  int totalRecords = 0;
  int pageSize = 10;
  final scrollController = ScrollController();

  final f = dateformat.DateFormat("dd MMM yyyy");
  late DateTime currentDate;
  late DateTimeRange dateTimeRange;

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
              ? EventConstant.usersManagementScreen
              : EventConstant.myEmployeesScreen);
      scrollController.addListener(_scrollListener);
      try{
        Utils.showLoadingDialog();
        await fetchJobTitles();
        if (canView) await Future.wait([fetchEmployees(), fetchSahemRoles()]);
      }finally{
        Utils.hideLoadingDialog();
      }
    });
  }

  _scrollListener() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (employees.length == totalRecords) {
          return;
        }
        currentPage++;
        Utils.showLoadingDialog();
        await fetchEmployees();
        Utils.hideLoadingDialog();
      }
  }

  LookupData? getRole(int id) =>
      sahemRolesList.firstWhereOrNull((role) => role.value == id);

  Future fetchJobTitles() async {
    final result = await getLookUpData(endPoint: ApiConstant.jobTitle);
    jobList.value = result;
  }

  Future fetchSahemRoles() async {
    int id = 0;
    if (user.isAdmin) {
      id = 1;
    } else if (user.roles[0] == "Orgainizations") {
      id = 2;
    } else if (user.roles[0] == "Companies") {
      id = 3;
    }
    final result = await getLookUpData(endPoint: "${ApiConstant.sahemRoles}$id");
    sahemRolesList.value = result;
  }

  disableEmployee(int index) async {
    Utils.showLoadingDialog();
    bool status = user.isAdmin
        ? !employees[index].isActive
        : !employees[index].isDisabled;
    var body = {
      "id": employees[index].id,
      if (!user.isAdmin) "isDisabled": status,
      if (user.isAdmin) "isActive": status,
    };
    ApiResponse apiResponse = await repo.disableEmployee(
        request: RequestBody(
            body: body,
            endPoint: user.isAdmin
                ? ApiConstant.enableDisableSahemUser
                : ApiConstant.disableEmployee));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (user.isAdmin) {
        employees[index].isActive = status;
      } else {
        employees[index].isDisabled = status;
      }

      employees.refresh();
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  deleteEmployee(int index) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteEmployee(
        request: RequestBody(
            endPoint: "${ApiConstant.deleteEmployee}/${employees[index].id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      employees.removeAt(index);
      employees.refresh();
      Utils.showGlobalSnackBar(message: "deletedSuccessfully".tr);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchEmployees({bool clear = false}) async {
    if (clear) {
      Utils.showLoadingDialog();
      currentPage = 1;
    }

    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (!user.isAdmin) "id": user.accountId,
      if (emailController.text.isNotEmpty) "email": emailController.text,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedRole.value != null) "role": selectedRole.value!.value,
      if (selectedJob.value != null) "jobTitle": selectedJob.value!.value,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedActive.value != null && !user.isAdmin)
        "isDisabled": selectedActive.value == "disable",
      if (selectedActive.value != null && user.isAdmin)
        "isDisabled": selectedActive.value == "enable",
      if (selectedDateRange != null) ...{
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      },
    };
    String endPoint =
        user.isAdmin ? ApiConstant.sahemUsers : ApiConstant.allEmployees;
    ApiResponse apiResponse = await repo.fetchEmployees(
        request:
            RequestBody(endPoint: endPoint, queryParameters: queryParameters));
    if (clear) {
      Utils.hideLoadingDialog();
    }
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      List<ManagementStaff> employeesData = List<ManagementStaff>.from(
          baseApiModel.data.map((x) => ManagementStaff.fromJson(x)));
      if (clear) {
        employees.value = employeesData;
      } else {
        employees.addAll(employeesData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  verifyEmail({required int id}) async {
    Utils.showLoadingDialog();
    var body = {"id": id};
    ApiResponse apiResponse =
        await repo.verifyEmail(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  verifyPhone({required int id}) async {
    Utils.showLoadingDialog();
    var body = {"id": id};
    ApiResponse apiResponse =
        await repo.verifyPhone(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  filterBottomSheet() {
    Get.bottomSheet(
        SingleChildScrollView(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetHeader(),
              if (!user.isAdmin)
                LabelTextField(
                  controller: emailController,
                  label: "email",
                ),
              if (!user.isAdmin) 16.verticalSpace,
              if (!user.isAdmin)
                Obx(() => LabelDropDown2(
                      items: sahemRolesList.value,
                      selectedValue: selectedRole.value,
                      hint: "chooseAnOption",
                      onChanged: (value) => selectedRole.value = value,
                      label: 'role',
                    )),
              if (!user.isAdmin) 16.verticalSpace,
              Obx(() => LabelDropDown2(
                    items: jobList.value,
                    selectedValue: selectedJob.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedJob.value = value,
                    label: 'jobTitle',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.employeeStatus,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedStatus.value = value,
                    label: 'status',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.enableDisAbleStatus,
                    selectedValue: selectedActive.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedActive.value = value,
                    label: 'enableDisable',
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
                  onClear: () => clearAllFilters(),
                  onApply: () {
                    Get.back();
                    fetchEmployees(clear: true);
                  })
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  int userTypeIntoInt(String type) {
    if (type == "donor") {
      return 5;
    } else if (type == "company") {
      return 4;
    } else {
      return 3;
    }
  }

  clearAllFilters() {
    Get.back();
    emailController.clear();
    dateController.clear();
    selectedRole.value = null;
    selectedJob.value = null;
    selectedStatus.value = null;
    selectedActive.value = null;
    selectedDateRange = null;
    pageSize = 10;
    fetchEmployees(clear: true);
  }

  detailsBottomSheet(ManagementStaff emp) {
    String role = "";
    LookupData? data = getRole(user.isAdmin ? emp.roleId : emp.customRoleId);
    if (data != null) {
      role = Utils.isArabic ? data.nameAr : data.name;
    }
    Get.bottomSheet(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "details".tr,
                      style: AppTextStyle.secondaryPrimaryBlack20spTextStyle3,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.highlight_remove_outlined,
                        color: AppColors.secondaryPrimaryBlackColor,
                      ))
                ],
              ),
              detailItem(label: 'id', value: emp.id.toString()),
              detailItem(
                  label: 'name',
                  value: Utils.isArabic
                      ? "${emp.firstNameArabic} ${emp.lastNameArabic}"
                      : "${emp.firstName} ${emp.lastName}"),
              detailItem(label: 'email', value: emp.email),
              detailItem(label: 'mobile', value: emp.phone),
              detailItem(label: 'role', value: role.tr),
              detailItem(label: 'jobTitle', value: Utils.findLookupName(jobList,emp.jobDescription).tr),
              detailItem(
                  label: 'createdDate',
                  value: Utils.dateFormat1.format(emp.createdDate!)),
              16.verticalSpace,
            ],
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  Padding detailItem({required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label.tr,
              style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
            ),
          ),
          16.horizontalSpace,
          Flexible(
            child: Text(
              value,
              textAlign: Utils.isArabic ? TextAlign.start : TextAlign.end,
              textDirection: TextDirection.ltr,
              style: AppTextStyle.secondaryDarkGrey16spTextStyle,
            ),
          ),
        ],
      ),
    );
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

  exportEmployees() {
    String url ="";
    String fileName = "";
    if (user.isAdmin) {
      url = "${ApiConstant.exportAdminEmployees}$currentPage&pageSize=$pageSize";
      fileName = "Employees.csv";
    }else{
      url = "${ApiConstant.exportEmployees}$currentPage&pageSize=$pageSize&id=${user.accountId}";
      fileName = "Users.csv";
    }
    Utils.downloadFile(url: url, isExport: true, filename: fileName);
  }

  onEmpMenuSelected(String value, ManagementStaff emp) {
    if (value == "edit") {
      openAddEmp(emp);
    } else {
      detailsBottomSheet(emp);
    }
  }

  openAddEmp(ManagementStaff? emp) async {
    Get.delete<AddEmpViewModel>();
    final result = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(emp),
        fullscreenDialog: true,
      ),
    );
    if (result != null && result) {
      if (emp != null) {
        pageSize = employees.length;
      }
      if (canView) fetchEmployees(clear: true);
    }
  }

  String getTitle() => user.isAdmin ? "usersManagement" : "managementAndStaff";

  @override
  void onClose() {
    searchController.dispose();
    emailController.dispose();
    dateController.dispose();

    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    employees.close();
    jobList.close();
    sahemRolesList.close();
    selectedJob.close();
    selectedRole.close();
    selectedStatus.close();
    selectedActive.close();
    super.onClose();
  }

}
