import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/my_refund.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/refunds_repo.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class MyRefundsViewModel extends GetxController {
  final RxList<MyRefund> myRefunds = <MyRefund>[].obs;
  final RefundsRepoImpl repo = RefundsRepoImpl();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController creationDate = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final Rxn<String> selectedStatus = Rxn<String>();
  DateTimeRange? selectedDateRange;
  late final DateTimeRange dateTimeRange;
  late final DateTime currentDate;

  int currentPage = 1;
  int totalRecords = 0;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.myRefundsScreen);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    scrollController.addListener(_scrollController);
    fetchMyRefunds();
  }

  _scrollController() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (myRefunds.length == totalRecords) {
          return;
        }
        currentPage++;
        fetchMyRefunds();
      }
  }

  Future fetchMyRefunds({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": 10,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedDateRange != null) ...{
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      }
    };
    ApiResponse apiResponse = await repo.fetchMyRefunds(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      List<MyRefund> adsData = List<MyRefund>.from(
          baseApiModel.data.map((x) => MyRefund.fromJson(x)));
      if (clear) {
        myRefunds.value = adsData;
      } else {
        myRefunds.addAll(adsData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
        SingleChildScrollView(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
          child: Column(
            children: [
              buildBottomSheetHeader(),
              Obx(() => LabelDropDown(
                    items: AppConstant.statuses,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedStatus.value = value,
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
                  onApply: () {
                    Get.back();
                    fetchMyRefunds(clear: true);
                  },
                  onClear: () => clearFilter()),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    creationDate.clear();
    selectedStatus.value = null;
    selectedDateRange = null;
    fetchMyRefunds(clear: true);
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

  @override
  void onClose() {
    scrollController.removeListener(_scrollController);
    scrollController.dispose();
    searchController.dispose();
    creationDate.dispose();

    myRefunds.close();
    selectedStatus.close();
    super.onClose();
  }
}
