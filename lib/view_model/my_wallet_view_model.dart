import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/my_wallet.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/wallet_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/web_view/web_view_screen.dart';
import 'package:zakat_fund/view_model/web_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class MyWalletViewModel extends GetxController {
  final searchController = TextEditingController();
  final idController = TextEditingController();
  final dateController = TextEditingController();

  List<WalletTopupDetail> topUpDetails = [];

  final Rx<MyWallet> myWallet =
      MyWallet(availableBalance: 0, walletTopupDetail: []).obs;

  final DashboardData availableBalance = DashboardData(
    title: "availableBalance",
    value: "${"currency".tr} 0",
    icon: AppResources.availableBalanceIcon,
    backColor: AppColors.lightGreenColor1,
    style: AppTextStyle.darkGreenColor16spTextStyle,
  );

  final WalletRepoImpl repo = WalletRepoImpl();

  late final int userId;

  DateTime? pickedExpiry;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.myWalletScreen);
    User user = userBox.getAt(0);
    userId = user.id;
    fetchMyWalletDetails();
  }

  fetchMyWalletDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.fetchMyWalletDetails(
        request: RequestBody(queryParameters: {"userId": userId}));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      myWallet.value = apiResponse.data;
      topUpDetails = List.from(myWallet.value.walletTopupDetail);
      availableBalance.value =
          "${"currency".tr} ${myWallet.value.availableBalance.toInt()}";
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  topUpWallet() {
    Get.delete<WebViewModel>();
    User user = userBox.getAt(0);
    String url =
        '${FlavorConfig.baseUrl.replaceAll("/api", "")}${ApiConstant.walletPayment}?token=${user.bearerToken}&userId=${user.id}&langCode=${Utils.isArabic ? "ar" : "en"}';
    Get.put(WebViewModel(title: "topUpWalletHeading".tr, url: url));
    Navigator.push(Get.context!,
        MaterialPageRoute(builder: (BuildContext context) {
      return const WebViewScreen();
    })).then((val) async {
      Get.delete<WebViewModel>();
      if (val != null && val) {
        fetchMyWalletDetails();
      }
    });
  }

  void filterWalletById() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      myWallet.value.walletTopupDetail = List.from(topUpDetails);
    } else {
      final filtered = topUpDetails.where((item) {
        return item.transactionId.toLowerCase().contains(query);
      }).toList();
      myWallet.value.walletTopupDetail = filtered;
    }
    myWallet.refresh();
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
              LabelTextField(
                controller: idController,
                label: "transactionId",
              ),
              16.verticalSpace,
              LabelTextField(
                controller: dateController,
                label: "requestDate",
                isDate: true,
                readOnly: true,
                onTap: () => datePickerDialog(),
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearFilter(),
                  onApply: () {
                    Get.back();
                    filterWalletHistory();
                  }),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    idController.clear();
    dateController.clear();
    myWallet.value.walletTopupDetail = List.from(topUpDetails);
    myWallet.refresh();
  }

  datePickerDialog() async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: dateTime,
      firstDate: DateTime(1950),
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      fieldHintText: "dd/mm/yyyy",
      lastDate: dateTime,
    );
    String date = Utils.dateFormat1.format(picked!);
    pickedExpiry = picked;
    dateController.text = date;
  }

  void filterWalletHistory() {
    final idQuery = idController.text.trim().toLowerCase();
    final dateQuery = dateController.text.trim();

    final isIdFilterActive = idQuery.isNotEmpty;
    final isDateFilterActive = dateQuery.isNotEmpty;

    final filteredList = topUpDetails.where((item) {
      final matchesId = !isIdFilterActive ||
          item.transactionId.toLowerCase().contains(idQuery);
      final matchesDate = !isDateFilterActive ||
          Utils.dateFormat1.format(item.date) == dateQuery;
      return matchesId && matchesDate;
    }).toList();

    myWallet.value.walletTopupDetail = filteredList;
    myWallet.refresh();
  }

  onPopupMenuSelected(String item, String id) {
    Utils.openUrl(
        "${FlavorConfig.baseUrl.replaceAll("/api", "")}WalletTransactions/$id.pdf");
  }

  @override
  void onClose() {
    searchController.dispose();
    idController.dispose();
    dateController.dispose();

    myWallet.close();
    super.onClose();
  }
}
