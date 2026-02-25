import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/association_fund_requests.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/funds_trequest_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class FundsRequestsViewModel extends GetxController {
  final amount = TextEditingController();
  final amountNode = FocusNode();
  var formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  final repo = FundsRequestRepoImpl();

  RxList<AssociationFundRequest> requests = <AssociationFundRequest>[].obs;
  late List<KeyboardActionsItem> keyboardActionsItem;
  RxList<DashboardData> summaryList = [
    DashboardData(title: "overallReceivedDonation", value: "0"),
    DashboardData(title: "totalTransferredAmount", value: "0"),
    DashboardData(title: "totalRequestedFundAmount", value: "0"),
    DashboardData(title: "availableBalance", value: "0")
  ].obs;

  late int id;
  int currentPage = 1;
  int totalRecords = 0;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.fundsTransferRequestScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: amountNode, displayArrows: false),
    ];
    scrollController.addListener(_scrollListener);
    User user = userBox.getAt(0);
    id = user.accountId!;
    fetchProjects();
  }

  _scrollListener(){
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (requests.length == totalRecords) {
          return;
        }
        currentPage++;
        fetchProjects();
      }
  }

  Future submitFundsRequest() async {
    Utils.logEvent(name: EventConstant.submitFundTransferRequestCLick);
    Utils.showLoadingDialog();
    var body = {"associationId": id, "amount": amount.text};
    ApiResponse apiResponse = await repo.submitFundsRequest(request: RequestBody(body: body));
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "requestSentSuccessfully".tr);
      amount.clear();
      currentPage = 1;
      fetchProjects(showDialog: false);
    } else {
      Utils.hideLoadingDialog();
      Utils.handleAPIError(apiResponse);
    }
  }

  fetchProjects({bool showDialog = true}) async {
    if (showDialog) Utils.showLoadingDialog();
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": 10,
    };
    ApiResponse apiResponse = await repo.associationFundRequests(
        request: RequestBody(
            endPoint: "${ApiConstant.associationFundRequests}/$id",
            queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats stats = baseApiModel.stats;
      _updateSummaryData(stats);
      if (!showDialog) {
        requests.clear();
      }
      requests.addAll(List<AssociationFundRequest>.from(baseApiModel.data
          .map((data) => AssociationFundRequest.fromJson(data))));
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _updateSummaryData(Stats stats) {
    summaryList[0].value = "${stats.overAllReceivedDonations}";
    summaryList[1].value = "${stats.totalTransferredAmount}";
    summaryList[2].value = "${stats.totalRequestedFundAmount}";
    summaryList[3].value = "${stats.availableAmount}";
    summaryList.refresh();
  }

  transferDialog() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppResources.tickSquareIcon),
              16.verticalSpace,
              Text("areYouSure".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle2),
              16.verticalSpace,
              RichText(
                text: TextSpan(
                    text: "transferRequestMessage1".tr,
                    style: AppTextStyle.secondaryPrimaryBlack14spTextStyle
                        .copyWith(fontFamily: 'Alexandria'),
                    children: <TextSpan>[
                      TextSpan(
                          text: "${amount.text} ${"currency".tr}",
                          style: AppTextStyle.lightBrown14spTextStyle4
                              .copyWith(fontFamily: 'Alexandria')),
                      TextSpan(
                          text: "transferRequestMessage2".tr,
                          style: AppTextStyle.secondaryPrimaryBlack14spTextStyle
                              .copyWith(fontFamily: 'Alexandria'))
                    ]),
              ),
              20.verticalSpace,
              RichText(
                text: TextSpan(
                    text: "${"donationAmount".tr}: ",
                    style: AppTextStyle.darkerGrey16spTextStyle1
                        .copyWith(fontFamily: 'Alexandria'),
                    children: <TextSpan>[
                      TextSpan(
                          text: "${amount.text} ${"currency".tr}",
                          style: AppTextStyle.secondaryBlack16spTextStyle1
                              .copyWith(fontFamily: 'Alexandria')),
                    ]),
              ),
              20.verticalSpace,
              elevatedButton(
                  text: "confirm",
                  onPressed: () {
                    Get.back();
                    submitFundsRequest();
                  }),
              16.verticalSpace,
              elevatedButton(
                  text: "cancel",
                  onPressed: () => Get.back(),
                  backgroundColor: AppColors.lightGreyColor),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.r)),
    )).then((_) {});
  }

  @override
  void onClose() {
    amount.dispose();
    amountNode.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    requests.close();
    summaryList.close();
    super.onClose();
  }

}
