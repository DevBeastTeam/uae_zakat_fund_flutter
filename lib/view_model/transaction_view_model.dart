import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/donor_dashboard_data.dart';
import 'package:zakat_fund/model/project_data.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/model/transactions.dart';
import 'package:zakat_fund/repository/transaction_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/pdf_helper.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/radio_list_tile.dart';
import 'package:zakat_fund/widgets/transaction_details_bottom_sheet.dart';

class TransactionViewModel extends ModulePermissionsViewModel
    with GenericMixin {
  final formKey = GlobalKey<FormState>();
  final certificateFormKey = GlobalKey<FormState>();

  RxList<Transactions> transactions = <Transactions>[].obs;

  final idController = TextEditingController();
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final scrollController = ScrollController();

  final transactionRepo = TransactionRepoImpl();

  Rxn<String> selectedStatus = Rxn<String>();
  Rxn<String> selectedMethod = Rxn<String>();
  Rxn<String> selectedProject = Rxn<String>();

  List<String> projects = [];
  RxList<ProjectData> selectedProjects = <ProjectData>[].obs;

  RxBool isPartialRefund = true.obs;
  RxBool isFullRefund = false.obs;
  RxInt refundTotalAmount = 0.obs;

  int currentPage = 1;
  int totalRecords = 0;

  late ReceiptDetails details;

  late DateTimeRange dateTimeRange;
  late DateTime currentDate;
  DateTimeRange? selectedDateRange;
  RxList<DashboardData> dashboardData = [
    DashboardData(title: "totalBeneficiaries", value: "0"),
    DashboardData(title: "totalProjects", value: "0"),
    DashboardData(title: "totalContributions", value: "AED 0"),
  ].obs;

  RxList<StatsData> stats = [
    StatsData(
      title: "total",
      value: "0",
      titleStyle: AppTextStyle.btnBackground12spTextStyle1,
      valueStyle: AppTextStyle.btnBackground16spTextStyle,
      backgroundColor: AppColors.btnBackgroundColor,
    ),
    StatsData(
      title: "accepted",
      value: "0",
      titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
      valueStyle: AppTextStyle.darkGreen16spTextStyle1,
      backgroundColor: AppColors.darkGreenColor,
    ),
    StatsData(
      title: "completed",
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
    ),
    StatsData(
      title: "pendingForCollection",
      value: "0",
      titleStyle: AppTextStyle.lightBrown12spTextStyle2,
      valueStyle: AppTextStyle.lightBrown16spTextStyle1,
      backgroundColor: AppColors.lightBrownColor1,
    ),
  ].obs;

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
    scrollController.addListener(_scrollListener);
    Future.microtask(() async {
      Utils.logEvent(
          name: user.isAdmin
              ? EventConstant.donationsScreen
              : EventConstant.myDonationsScreen);
      if (canView) {
        try {
          Utils.showLoadingDialog();
          await Future.wait(
              [fetchTransactions(showDialog: false), fetchDashboardData()]);
        } finally {
          Utils.hideLoadingDialog();
        }
      }
    });
  }

  _scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        transactions.length < totalRecords) {
      currentPage++;
      await fetchTransactions();
    }
  }

  Future fetchTransactions({bool clear = false, bool showDialog = true}) async {
    if (showDialog) Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": 10,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedMethod.value != null)
        "method": Utils.paymentMethodIntoInt(selectedMethod.value!),
      if (selectedDateRange != null) ...{
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      }
    };
    ApiResponse apiResponse = await transactionRepo.userDonations(
        request: RequestBody(queryParameters: queryParameters));
    if (showDialog) Utils.hideLoadingDialog();

    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats donationStats = baseApiModel.stats;
      _updateStats(donationStats);
      List<Transactions> transactionData = List<Transactions>.from(
          baseApiModel.data.map((x) => Transactions.fromJson(x)));
      if (clear) {
        transactions.value = transactionData;
      } else {
        transactions.addAll(transactionData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  addDummyTransaction() {
    final dummy = Transactions(
      id: 99999 + transactions.length,
      requestStatus: 2,
      userId: user.id,
      amount: 100.0,
      associationId: 0,
      status: "Accepted",
      sessionId: "dummy_session_${DateTime.now().millisecondsSinceEpoch}",
      createdDate: DateTime.now(),
      createdBy: "dev",
      totalAmount: 100.0,
      zfTransactionId: "DUMMY-${1000 + transactions.length}",
      paymentType: 1, // Cash
      collectionDate: null,
      collectionTime: null,
      collectionPoint: null,
      bankId: null,
      chequeNo: null,
      chequePhoto: null,
      chequeDate: null,
      firstName: user.firstName,
      lastName: user.lastName,
      emailAddress: user.email,
      phoneNumber: "123456789",
      payersName: "${user.firstName} ${user.lastName}",
      isRefundApplied: false,
    );
    transactions.insert(0, dummy);
    totalRecords++;
    stats[0].value = (int.parse(stats[0].value) + 1).toString();
    stats[1].value = (int.parse(stats[1].value) + 1).toString();
    Utils.showGlobalSnackBar(message: "Dummy receipt added successfully");
  }

  _updateStats(Stats donationStats) {
    stats[0].value = donationStats.total.toString();
    stats[1].value = donationStats.accepted.toString();
    stats[2].value = donationStats.completed.toString();
    stats[3].value = donationStats.pending.toString();
    stats[4].value = donationStats.returned.toString();
    stats[5].value = donationStats.rejected.toString();
    stats[6].value = donationStats.pendingForCollection.toString();
  }

  Future fetchDashboardData() async {
    ApiResponse apiResponse =
        await transactionRepo.donorDashboardData(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      DonorDashboardData donorDashboardData = apiResponse.data;
      _updateSummaryData(donorDashboardData);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _updateSummaryData(DonorDashboardData donorDashboardData) {
    dashboardData[0].value = "${donorDashboardData.totalBeneficiaries}";
    dashboardData[1].value = "${donorDashboardData.numberOfProjectDonated}";
    dashboardData[2].value =
        "${"currency".tr} ${donorDashboardData.totalContribution.toInt()}";
    dashboardData.refresh();
  }

  refundRequest() async {
    Utils.showLoadingDialog();
    String sessionId = details.projects[0].sessionId!;
    var body = {
      "requestType": "Refund",
      "refundType": isFullRefund.value ? 1 : 2,
      "projectDetailJson":
          isFullRefund.value ? "" : jsonEncode(_buildProjectJson()),
      "sessionId": sessionId,
    };
    ApiResponse apiResponse =
        await transactionRepo.refundRequest(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    Get.back();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Utils.showGlobalSnackBar(message: apiResponse.data);
      _updateTransactionRefundStatus(sessionId);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  List<Map<String, dynamic>> _buildProjectJson() {
    return selectedProjects
        .map((project) => {
              "Id": project.projectId,
              "Amount": int.parse(project.controller!.text)
            })
        .toList();
  }

  void _updateTransactionRefundStatus(String sessionId) {
    transactions
        .firstWhereOrNull((transaction) => transaction.sessionId == sessionId)
        ?.isRefundApplied = true;
    transactions.refresh();
  }

  fetchTransactionDetails(Transactions transaction,
      {bool isRefund = false,
      bool isReceipt = false,
      bool isPreview = false}) async {
    Utils.showLoadingDialog();
    var queryParameters = {
      if (transaction.paymentType == 1 || transaction.paymentType == 6)
        "sessionId": transaction.sessionId,
      if (transaction.paymentType != 1 && transaction.paymentType != 6)
        "transactionId": transaction.id,
    };
    final result = await getTransactionDetails(queryParameters);
    if (result != null) {
      details = result;
      if (isReceipt) {
        bool isCompany = user.roles[0] == "Companies";
        PDFHelper.generateDonationReceiptPdf(details, isCompany,
            isPreview: isPreview);
        return;
      }
      Utils.hideLoadingDialog();
      if (details.isRefunded && isRefund && transaction.requestStatus != 7) {
        Utils.showGlobalSnackBar(message: "refundRequestApplied".tr);
        return;
      }
      projects = details.projects.map((project) {
        return Utils.isArabic ? project.projectNameArabic : project.projectName;
      }).toList();
      isRefund ? refundAmountDialog(details) : detailsBottomSheet(details);
    } else {
      Utils.hideLoadingDialog();
    }
  }

  refundAmountDialog(ReceiptDetails transaction) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: !Utils.isArabic ? 16.w : 0,
                      right: Utils.isArabic ? 16.w : 0),
                  child: buildBottomSheetHeader(text: "requestARefund"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Flexible(
                          child: Obx(() => radioListTile(
                                0,
                                0,
                                "partialRefund",
                                isPartialRefund.value ? 0 : 1,
                                onChanged: (index) {
                                  isPartialRefund.value = true;
                                  isFullRefund.value = false;
                                },
                                isNew: true,
                              ))),
                      Flexible(
                          child: Obx(() => radioListTile(
                                0,
                                0,
                                "fullRefund",
                                isFullRefund.value ? 0 : 1,
                                onChanged: (index) {
                                  isFullRefund.value = true;
                                  isPartialRefund.value = false;
                                },
                                isNew: true,
                              ))),
                    ],
                  ),
                ),
                8.verticalSpace,
                Obx(() => isPartialRefund.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelDropDown(
                              items: projects,
                              selectedValue: selectedProject.value,
                              hint: "chooseAnOption",
                              isRequired: true,
                              onChanged: (value) {
                                selectedProject.value = value;
                                Detail project =
                                    details.projects.firstWhere((proj) {
                                  String name = Utils.isArabic
                                      ? proj.projectNameArabic
                                      : proj.projectName;
                                  return name == selectedProject.value;
                                });
                                ProjectData? projectData = selectedProjects
                                    .firstWhereOrNull((element) =>
                                        element.projectId == project.id);

                                if (projectData == null) {
                                  selectedProjects.add(ProjectData(
                                      name: selectedProject.value,
                                      projectId: project.id,
                                      focusNode: FocusNode(),
                                      controller: TextEditingController(
                                          text: project.amount
                                              .toInt()
                                              .toString()),
                                      amount: project.amount.toInt()));

                                  _calculateAmount();
                                }
                              },
                              label: 'selectProject',
                            ),
                            8.verticalSpace,
                            Obx(() => Wrap(
                                runSpacing: 8.h,
                                spacing: 8.w,
                                alignment: WrapAlignment.start,
                                children: List.generate(
                                    selectedProjects.length,
                                    (index) => RawChip(
                                          onDeleted: () {
                                            selectedProjects.removeAt(index);
                                            _calculateAmount();
                                          },
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          label: Text(
                                            selectedProjects[index].name!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          labelStyle: AppTextStyle
                                              .btnText14spTextStyle1,
                                          deleteIcon: const Icon(
                                              CupertinoIcons.clear_circled),
                                          deleteIconColor:
                                              AppColors.btnTextColor,
                                          side: BorderSide(
                                              color: AppColors.darkBrownColor,
                                              width: 1.w),
                                          backgroundColor:
                                              AppColors.chipBackgroundColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r)),
                                        )).toList())),
                            8.verticalSpace,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                  selectedProjects.length,
                                  (index) => KeyboardActions(
                                        autoScroll: false,
                                        config:
                                            Utils.buildConfig(Get.context!, [
                                          KeyboardActionsItem(
                                              focusNode: selectedProjects[index]
                                                  .focusNode!,
                                              displayArrows: false),
                                        ]),
                                        child: LabelTextField(
                                          controller: selectedProjects[index]
                                              .controller!,
                                          focusNode: selectedProjects[index]
                                              .focusNode!,
                                          hint: "enterTopUpAmount",
                                          label: 'refundAmountFor'.tr +
                                              selectedProjects[index].name!,
                                          checkValidation: true,
                                          isRequired: true,
                                          onChanged: (_) {
                                            _calculateAmount();
                                          },
                                          validator: (val) {
                                            if (val
                                                .toString()
                                                .trim()
                                                .isNotEmpty) {
                                              int amount =
                                                  int.parse(val.toString());
                                              if (amount >
                                                  selectedProjects[index]
                                                      .amount) {
                                                return "${"refundAmount".tr} ${"isInvalid".tr}";
                                              }
                                            } else {
                                              return "${"refundAmount".tr} ${"isRequired".tr}";
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                            FilteringTextInputFormatter.deny(
                                              RegExp(
                                                  r'^0+'), //users can't type 0 at 1st position
                                            ),
                                          ],
                                        ),
                                      )).toList(),
                            ),
                            8.verticalSpace,
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "summary".tr,
                    style: AppTextStyle.secondaryPrimaryBlack18spTextStyle1,
                  ),
                ),
                8.verticalSpace,
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border:
                          Border.all(color: AppColors.secondaryLightGreyColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSummaryRow(
                        "totalDonation",
                        "${"currency".tr} ${transaction.totalAmount}",
                      ),
                      8.verticalSpace,
                      Obx(() => isFullRefund.value
                          ? Column(
                              children: [
                                buildSummaryRow(
                                  "refundAmount",
                                  "${"currency".tr} ${transaction.totalAmount}",
                                ),
                                8.verticalSpace,
                              ],
                            )
                          : const SizedBox.shrink()),
                      Obx(() => isPartialRefund.value
                          ? Column(
                              children: [
                                buildSummaryRow(
                                  "refundAmount",
                                  "${"currency".tr} ${refundTotalAmount.value}",
                                ),
                                8.verticalSpace,
                              ],
                            )
                          : const SizedBox.shrink()),
                      buildSummaryRow(
                        "donationId",
                        transaction.transactionId,
                      ),
                      8.verticalSpace,
                      buildSummaryRow(
                        "refundDate",
                        Utils.dateFormat1.format(DateTime.now()),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: elevatedButton(
                      text: "submit",
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        refundRequest();
                      }),
                ),
                8.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: elevatedButton(
                    text: "cancel",
                    onPressed: () {
                      Get.back();
                    },
                    backgroundColor: AppColors.lightGreyColor,
                  ),
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    )).then((_) {
      _resetRefundSelection();
    });
  }

  void _resetRefundSelection() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      isPartialRefund.value = true;
      isFullRefund.value = false;
      projects.clear();
      refundTotalAmount.value = 0;
      selectedProject.value = null;
      selectedProjects.clear();
    });
  }

  _calculateAmount() {
    refundTotalAmount.value = selectedProjects.fold(0, (sum, project) {
          int amount = project.controller!.text.isEmpty
              ? 0
              : int.parse(project.controller!.text);
          return sum! + amount;
        }) ??
        0;
  }

  Row buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.tr,
          style: AppTextStyle.primaryDarkGrey12spTextStyle1,
        ),
        Text(
          value,
          style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
        ),
      ],
    );
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
                    items: AppConstant.donationStatuses,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                    label: 'status',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.paymentMethods,
                    selectedValue: selectedMethod.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedMethod.value = value;
                    },
                    label: 'method',
                  )),
              16.verticalSpace,
              LabelTextField(
                label: "creationDate",
                onTap: () => dateRangePicker(),
                readOnly: true,
                isDate: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                controller: dateController,
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => _clearFilter(),
                  onApply: () {
                    Get.back();
                    fetchTransactions(clear: true);
                  })
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  _clearFilter() {
    Get.back();
    idController.clear();
    dateController.clear();
    selectedStatus.value = null;
    selectedMethod.value = null;
    selectedDateRange = null;
    fetchTransactions(clear: true);
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

  datePickerDialog(controller) async {
    final DateTime now = DateTime.now();
    DateTime? selectedDateTime = await Utils.datePickerDialog(
      initialDate: now,
      lastDate: now,
      firstDate: DateTime(1950),
    );
    controller.text = Utils.dateFormat1.format(selectedDateTime!);
  }

  taxCertificateDialog() async {
    startDateController.clear();
    endDateController.clear();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: SizedBox(
          width: Get.width,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Form(
              key: certificateFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "downloadTaxCertificate".tr,
                          style:
                              AppTextStyle.secondaryPrimaryBlack18spTextStyle,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.highlight_remove_outlined,
                            color: AppColors.secondaryPrimaryBlackColor),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  LabelTextField(
                    controller: startDateController,
                    label: "startDate",
                    isDate: true,
                    checkValidation: true,
                    readOnly: true,
                    onTap: () => datePickerDialog(startDateController),
                  ),
                  16.verticalSpace,
                  LabelTextField(
                    controller: endDateController,
                    label: "endDate",
                    isDate: true,
                    checkValidation: true,
                    readOnly: true,
                    onTap: () => datePickerDialog(endDateController),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: elevatedButton(
                            text: "view",
                            onPressed: () {
                              _downloadTaxCertificate(isPreview: true);
                            }),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: elevatedButton(
                            text: "download",
                            onPressed: () {
                              _downloadTaxCertificate();
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  _downloadTaxCertificate({bool isPreview = false}) async {
    if (!certificateFormKey.currentState!.validate()) {
      return;
    }
    Get.back();
    Utils.showLoadingDialog();
    String startDate = startDateController.text;
    String endDate = endDateController.text;
    final formattedStartDate = _formatDate(startDate);
    final formattedEndDate = _formatDate(endDate);
    bool isCompany = user.roles[0] == "Companies";
    var body = {
      "startDate": formattedStartDate,
      "endDate": formattedEndDate,
      if (isCompany) "accountId": user.accountId
    };
    ApiResponse apiResponse = await transactionRepo.downloadTaxCertificate(
        request: RequestBody(body: body));
    if (apiResponse.appState == AppState.onSuccess) {
      String taxPeriod = "$startDate${" - "}$endDate";
      PDFHelper.generateTaxCertificatePdf(
          details: apiResponse.data,
          date: taxPeriod,
          isCompany: isCompany,
          isPreview: isPreview);
    } else {
      Utils.hideLoadingDialog();
      Utils.handleAPIError(apiResponse);
    }
  }

  String _formatDate(String date) {
    final parsedDate = Utils.dateFormat1.parse(date);
    return Utils.newDateFormat.format(parsedDate);
  }

  onPopupMenuSelected(String item, Transactions transaction) {
    if (item == "receipt") {
      fetchTransactionDetails(transaction, isReceipt: true);
    } else if (item == "view") {
      fetchTransactionDetails(transaction);
    } else if (item == "refund") {
      fetchTransactionDetails(transaction, isRefund: true);
    }
  }

  exportDonations() {
    String url = "", fileName = "";
    if (user.isAdmin) {
      url = "${ApiConstant.exportAllDonations}$currentPage&pageSize=10";
      fileName = "All_Donations.csv";
    } else {
      url = "${ApiConstant.exportDonorDonations}$currentPage&pageSize=10";
      fileName = "My_Donations.csv";
    }
    Utils.downloadFile(url: url, isExport: true, filename: fileName);
  }

  String getTitle() => user.isAdmin ? "donations" : "contributionLog";

  @override
  void onClose() {
    idController.dispose();
    searchController.dispose();
    dateController.dispose();
    startDateController.dispose();
    endDateController.dispose();

    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    selectedStatus.close();
    selectedMethod.close();
    selectedProject.close();
    selectedProjects.close();
    isPartialRefund.close();
    isFullRefund.close();
    refundTotalAmount.close();
    dashboardData.close();
    stats.close();
    super.onClose();
  }
}
