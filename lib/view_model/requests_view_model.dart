import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/requests_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/constants/module_codes.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class RequestsViewModel extends GetxController {
  final dateFormat = DateFormat("dd MMM yyyy");

  final searchController = TextEditingController();
  final requestDateController = TextEditingController();
  final scrollController = ScrollController();

  final Rxn<String> selectedUserType = Rxn<String>();
  final Rxn<String> selectedStatus = Rxn<String>();
  final Rxn<String> selectedPriority = Rxn<String>();
  final Rxn<String> selectedRequestType = Rxn<String>();
  final Rxn<String> selectedResource = Rxn<String>();

  List<String> resources = [];
  List<String> requestTypes = [];
  List<String> statuses = AppConstant.donorRequestStatuses;

  int currentPage = 1;
  int pageSize = 10;
  int totalRecords = 0;

  RxList<Requests> requests = <Requests>[].obs;
  List<Requests> allRequests = [];
  RxList<StatsData> stats = [
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

  final repo = RequestsRepoImpl();
  late User user;
  bool isTasks = false;
  DateTime? pickedExpiry;

  final accountViewModel = Get.find<AccountViewModel>();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    String code = Get.arguments;
    user = userBox.getAt(0);
    Utils.logEvent(
        name: user.isAdmin
            ? EventConstant.requestsManagementScreen
            : EventConstant.myRequestsScreen);
    _initRequestTypes();
    scrollController.addListener(_scrollListener);
    if (user.userTypeID == 1005 && code == ModuleCodes.adminTasksCode) {
      isTasks = true;
      fetchTasks();
    } else {
      fetchAllRequests();
    }
  }

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isTasks || requests.length == totalRecords) return;
      currentPage++;
      fetchAllRequests();
    }
  }

  void _initRequestTypes() {
    switch (user.roles.first) {
      case "Individuals":
        requestTypes = AppConstant.donorRequestTypes;
        break;
      case "Companies":
        requestTypes = AppConstant.companyRequestTypes;
        break;
      case "Orgainizations":
        requestTypes = AppConstant.associationRequestTypes;
        statuses = AppConstant.statuses;
        break;
      default:
        requestTypes = AppConstant.adminRequestTypes;
    }
  }

  fetchAllRequests({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) currentPage = 1;
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      "isMobile": true,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (pickedExpiry != null)
        "requestDate": Utils.newDateFormat.format(pickedExpiry!),
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedPriority.value != null)
        "priority": Utils.priorityIntoInt(selectedPriority.value!),
      if (selectedRequestType.value != null)
        "requestType":
            TranslationService().keys['en']![selectedRequestType.value]!,
    };
    ApiResponse apiResponse = user.isAdmin
        ? await repo.fetchAllUserRequests(
            request: RequestBody(queryParameters: queryParameters))
        : await repo.fetchRequests(
            request: RequestBody(
                endPoint: "${ApiConstant.requests}/${user.id}",
                queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats statsData = baseApiModel.stats;
      _updateStats(statsData);
      List<Requests> requestData = List<Requests>.from(
          baseApiModel.data.map((x) => Requests.fromJson(x)));
      if (clear) {
        requests.value = requestData;
      } else {
        requests.addAll(requestData);
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

  fetchTasks({bool fromUpdate = false}) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.fetchTasks(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allRequests = apiResponse.data;
      requests.value = List.from(allRequests);
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
              LabelTextField(
                controller: requestDateController,
                label: "requestDate",
                isDate: true,
                readOnly: true,
                onTap: () => datePickerDialog(),
              ),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: statuses,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedStatus.value = value,
                    label: 'status',
                  )),
              if (user.isAdmin) 16.verticalSpace,
              if (user.isAdmin)
                Obx(() => LabelDropDown(
                      items: AppConstant.priorities,
                      selectedValue: selectedPriority.value,
                      hint: "chooseAnOption",
                      onChanged: (value) => selectedPriority.value = value,
                      label: 'priority',
                    )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: requestTypes,
                    selectedValue: selectedRequestType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedRequestType.value = value,
                    label: 'requestType',
                  )),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearFilter(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    fetchAllRequests(clear: true);
                  }),
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
    selectedUserType.value = null;
    selectedRequestType.value = null;
    selectedPriority.value = null;
    selectedStatus.value = null;
    selectedResource.value = null;
    requestDateController.clear();
    pickedExpiry = null;
    pageSize = 10;
    fetchAllRequests(clear: true);
  }

  datePickerDialog() async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: dateTime,
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      firstDate: DateTime(1950),
      fieldHintText: "dd/mm/yyyy",
      lastDate: dateTime,
    );
    String date = Utils.dateFormat1.format(picked!);
    pickedExpiry = picked;
    requestDateController.text = date;
  }

  approveRejectRequest(
      {bool isAccepted = true,
      bool isRejected = false,
      required Requests request,
      String? message,
      String? rejectionReason,
      String? rejectNote,
      String? rejectDocument,
      int? accountId}) async {
    var body = {
      "requestId": request.id,
      if (accountId != null) "accountId": accountId,
      if (request.requestType != "Refund") "entityId": request.entityId,
      if (request.requestType == "Refund") "sessionId": request.sessionId,
      "requestType": request.requestType,
      "requestStatus": isRejected
          ? 3
          : isAccepted
              ? 2
              : 7,
      if (!isAccepted) "rejectNote": rejectNote,
      if (rejectionReason != null)
        "rejectReason": TranslationService().keys['en']![rejectionReason]!,
      if (!isAccepted && rejectDocument != null)
        "rejectDocument": rejectDocument
    };
    ApiResponse apiResponse =
        await repo.requestApproval(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (isAccepted) {
        Utils.successDialog(message: message).then((_) {
          Get.back(result: true);
        });
      } else {
        Get.back();
        Get.back(result: true);
        if (isRejected) {
          Utils.showGlobalSnackBar(message: "requestRejectedSuccessfully".tr);
          return;
        } else if (!isAccepted) {
          Utils.showGlobalSnackBar(message: "requestReturnedSuccessfully".tr);
          return;
        }

        Utils.showGlobalSnackBar(message: apiResponse.data ?? "");
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future<void> openPreviewScreen(Requests request) async {
    String? code = moduleCode(request.requestType);
    final String type = request.requestType;
    final arguments = {"request": request, "isAdmin": false, "code": code};

    if ({"Feedback", "Feedback Response", "Feedback Response Update"}
        .contains(type)) {
      previewScreen(AppRoutes.feedbackPreviewScreen, arguments: {
        if (!isTasks) ...arguments,
        "fromTasks": isTasks,
        "id": request.entityId
      });
      return;
    }

    if (type.contains("Update")) {
      previewScreen(AppRoutes.auditDetailsScreen, arguments: arguments);
      return;
    }

    if ({"Banner", "Popup"}.contains(type)) {
      previewScreen(AppRoutes.adScreen,
          arguments: {...arguments, "title": type});
      return;
    }

    if (type == "Association") {
      previewScreen(AppRoutes.associationPreviewScreen,
          arguments: {...arguments, "isAssociation": true});
      return;
    }

    if (type == "Company") {
      previewScreen(AppRoutes.associationPreviewScreen,
          arguments: {...arguments, "isAssociation": false});
      return;
    }

    if ({"Bank Cheque", "Deposit", "Cash"}.contains(type)) {
      final screen = isTasks
          ? AppRoutes.collectionScreen
          : AppRoutes.transactionRequestScreen;
      previewScreen(screen, arguments: arguments);
      return;
    }

    final routeMap = <String, String>{
      "Static Page": AppRoutes.staticPageScreen,
      "Project": AppRoutes.projectPreviewScreen,
      "About Us": AppRoutes.aboutUsScreen,
      "News": AppRoutes.newsPreviewScreen,
      "Service": AppRoutes.servicePreviewScreen,
      "Campaign": AppRoutes.campaignScreen,
      "Survey": AppRoutes.surveyScreen,
      "Refund": AppRoutes.refundPreviewScreen,
      "FAQ": AppRoutes.faqPreviewScreen,
      "Fund Transfer": AppRoutes.fundsRequestPreviewScreen,
      "Notifications": AppRoutes.notificationsPreviewScreen,
    };

    final route = routeMap[type];
    if (route != null) {
      previewScreen(route, arguments: arguments);
    } else {
      print("Unknown request type: $type");
    }
  }

  previewScreen(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments)?.then((result) {
      if (result != null && result) {
        if (isTasks) {
          fetchTasks(fromUpdate: true);
        } else {
          if (user.isAdmin) {
            pageSize = requests.length;
          }
          fetchAllRequests(clear: true);
        }
      }
    });
  }

  exportRequests() {
    final url = user.isAdmin
        ? ApiConstant.exportUserRequests
        : "${ApiConstant.exportMyRequest}${user.id}&pageNumber=1&pageSize=1000";
    final filename = user.isAdmin ? "User_Requests.csv" : "My_Requests.csv";
    Utils.downloadFile(url: url, isExport: true, filename: filename);
  }

  onPopUpMenuSelected(String item, Requests request) {
    if (item == "view") {
      openPreviewScreen(request);
    } else if (item == "confirm") {
      Get.toNamed(AppRoutes.authTaskScreen, arguments: request)?.then((value) {
        if (value != null && value) {
          pageSize = requests.length;
          fetchAllRequests(clear: true);
        }
      });
    }
  }

  bool showView(String type) {
    bool show = true;
    if (accountViewModel.permissions.isNotEmpty) {
      String? code = moduleCode(type);
      if (code != null) {
        List<String> permissions =
            Utils.modulePermissions(accountViewModel.permissions[0], code);
        show = Utils.hasPermission(permissions, "view");
      }
    }
    return show;
  }

  viewRejectionReturnFile(String file) {
    if (Utils.isImageFile(file)) {
      Get.toNamed(AppRoutes.photoViewScreen, arguments: file);
      return;
    }
    Utils.openUrl("${FlavorConfig.storageUrl}$file");
  }

  String? moduleCode(String type) {
    String requestType = Utils.toCamelCase(type);
    return ModuleCodes.requestTypeCodeMap['${requestType}RequestType'];
  }

  @override
  void onClose() {
    searchController.dispose();
    requestDateController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    selectedUserType.close();
    selectedStatus.close();
    selectedPriority.close();
    selectedRequestType.close();
    selectedResource.close();
    requests.close();
    stats.close();
    super.onClose();
  }
}
