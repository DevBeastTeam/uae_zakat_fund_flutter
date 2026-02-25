import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/model/transfer_queue.dart';
import 'package:zakat_fund/repository/transfer_queue_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class TransferQueueViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final startAmountController = TextEditingController();
  final endAmountController = TextEditingController();
  final scrollController = ScrollController();

  final repo = TransferQueueRepoImpl();

  final RxnString selectedStatus = RxnString();
  final RxList<Queue> transferQueueList = <Queue>[].obs;
  final RxList<StatsData> stats = <StatsData>[].obs;

  int totalRecords = 0;
  int currentPage = 1;
  late List<KeyboardActionsItem> keyboardActionsItem;

  final startAmountNode = FocusNode();
  final endAmountNode = FocusNode();

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.fundTransferQueueScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: startAmountNode, displayArrows: false),
      KeyboardActionsItem(focusNode: endAmountNode, displayArrows: false),
    ];
    scrollController.addListener(_scrollListener);
    _initializeStats();

    if (canView) {
      fetchFundTransferQueue();
    }
  }

  Future<void> _scrollListener() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          transferQueueList.length < totalRecords) {
        await fetchFundTransferQueue();
      }
  }

  fetchFundTransferQueue({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    final queryParameters = {
      "pageNumber": currentPage,
      "pageSize": 10,
      if (searchController.text.isNotEmpty) "Query": searchController.text,
      if (selectedStatus.value != null)
        "Status": Utils.statusIntoInt(selectedStatus.value!),
      if (startAmountController.text.isNotEmpty)
        "startAmount": startAmountController.text,
      if (endAmountController.text.isNotEmpty)
        "endAmount": endAmountController.text,
    };

    final apiResponse = await repo.fetchFundTransferQueue(
      request: RequestBody(queryParameters: queryParameters),
    );
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      TransferQueue baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.total;
      _updateStats(baseApiModel);
      if (clear) {
        transferQueueList.value = baseApiModel.queues;
      } else {
        transferQueueList.addAll(baseApiModel.queues);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _initializeStats() {
    stats.value = [
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
        title: "pending",
        value: "0",
        titleStyle: AppTextStyle.lightBrown12spTextStyle2,
        valueStyle: AppTextStyle.lightBrown16spTextStyle1,
        backgroundColor: AppColors.lightBrownColor1,
      ),
      StatsData(
        title: "rejected",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor,
      )
    ];
  }

  void _updateStats(TransferQueue data) {
    stats[0].value = data.total.toString();
    stats[1].value = data.accepted.toString();
    stats[2].value = data.pending.toString();
    stats[3].value = data.rejected.toString();
    stats.refresh();
  }

  void filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
      KeyboardActions(
        config: Utils.buildConfig(Get.context!, keyboardActionsItem),
        autoScroll: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w)
              .copyWith(bottom: 20.h, top: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetHeader(),
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
              Obx(() => LabelDropDown(
                    items: AppConstant.statuses,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedStatus.value = value,
                    label: 'status',
                  )),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearAll(),
                  onApply: () {
                    Get.back();
                    fetchFundTransferQueue(clear: true);
                  }),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
    );
  }

  void clearAll() {
    Get.back();
    searchController.clear();
    startAmountController.clear();
    endAmountController.clear();
    selectedStatus.value = null;
    fetchFundTransferQueue(clear: true);
  }

  exportFundTransferQueue(){
    Utils.downloadFile(
        url: ApiConstant.exportFundTransferQueue,
        isExport: true,
        filename: "Fund_Transfer_Queue.csv");
  }

  @override
  void onClose() {
    searchController.dispose();
    startAmountController.dispose();
    endAmountController.dispose();
    startAmountNode.dispose();
    endAmountNode.dispose();

    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    selectedStatus.close();
    transferQueueList.close();
    stats.close();
    super.onClose();
  }

}
