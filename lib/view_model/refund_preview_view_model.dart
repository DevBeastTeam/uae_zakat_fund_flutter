import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/refund_request_repo.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class RefundPreviewViewModel extends ModulePermissionsViewModel {

  final repo = RefundRequestRepoImpl();

  final requestId = TextEditingController();
  final requestDate = TextEditingController();
  final refundType = TextEditingController();
  final refundAmount = TextEditingController();
  final totalDonation = TextEditingController();
  final donorName = TextEditingController();
  final transactionId = TextEditingController();
  final project = TextEditingController();

  RxList<Detail> projects = <Detail>[].obs;


  @override
  void onInit() {
    Future.microtask(()=> refundRequestDetails());
    super.onInit();
  }

  refundRequestDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.refundRequestDetails(
        request: RequestBody(queryParameters: {"sessionId": request?.sessionId}));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      ReceiptDetails refundRequest = apiResponse.data;
      isAdmin.value = (request?.status == 1 && user.isAdmin);
      requestId.text = request!.id.toString();
      requestDate.text = Utils.dateFormat1.format(refundRequest.createdDate);
      refundType.text = refundRequest.projects[0].refundType == 1 ? "fullRefund".tr : "partialRefund".tr;
      totalDonation.text = refundRequest.totalAmount.toInt().toString();
      donorName.text = Utils.isArabic?request?.requesterNameAr ?? "":request!.requesterName;
      transactionId.text = refundRequest.transactionId??'';
      projects.value = refundRequest.projects;
      refundAmount.text = getTotalAmount().toString();
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  int getTotalAmount() {
    return projects.fold(0, (sum, proj) => sum! + proj.refundAmount!.toInt()) ?? 0;
  }

  @override
  void onClose() {
    requestId.dispose();
    requestDate.dispose();
    refundType.dispose();
    refundAmount.dispose();
    totalDonation.dispose();
    donorName.dispose();
    transactionId.dispose();
    project.dispose();

    projects.close();
    super.onClose();
  }

}
