import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/cash_notes.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/model/task_collection_details.dart';
import 'package:zakat_fund/model/task_receipt.dart';
import 'package:zakat_fund/repository/tasks_repo.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/collection_receipt_dialog.dart';

class AuthenticateTaskViewModel extends GetxController {
  late Requests requests;
  late TaskCollectionDetails taskCollectionDetails;

  final repo = TaskRepoImpl();

  final RxList<CashNotes> cashNotes = <CashNotes>[].obs;
  final RxList cashData = [
    {"key": "requestId", "value": ""},
    {"key": "requestorName", "value": ""},
    {"key": "requestDate", "value": ""},
    {"key": "collectionTime", "value": ""},
    {"key": "requestType", "value": ""},
    {"key": "paymentAmount", "value": ""},
  ].obs;
  final RxList<String> imagesList = <String>[].obs;

  bool isCash = false;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    requests = Get.arguments;
    isCash = requests.requestType == "Cash";
    fetchRequestDetails();
  }

  fetchRequestDetails() async {
    Utils.showLoadingDialog();
    var queryParameters = {"userRequestId": requests.id};
    ApiResponse apiResponse = await repo.fetchTaskCollectionDetails(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {

      taskCollectionDetails = apiResponse.data;
      cashData.value = _buildCashData(taskCollectionDetails);
      imagesList.value = taskCollectionDetails.imagePath.split(',');

      if (isCash) {
        cashNotes.value = taskCollectionDetails.noteDetail;
      }

    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  List<Map<String, String>> _buildCashData(TaskCollectionDetails details) {
    return [
      {"key": "requestId", "value": "${details.id}"},
      {
        "key": "requestorName",
        "value": Utils.isArabic ? details.requesterNameAr : details.requesterName,
      },
      {
        "key": "requestDate",
        "value": Utils.dateFormat1.format(details.createdDate),
      },
      {"key": "collectionTime", "value": details.collectionTime},
      {
        "key": "requestType",
        "value": Utils.isArabic ? details.requestTypeAr : details.requestType,
      },
      {
        "key": "paymentAmount",
        "value": "${details.totalAmount.toInt()} ${"currency".tr}",
      },
    ];
  }

  authenticateRequest() async {
    Utils.showLoadingDialog();
    var body = {"userRequestId": requests.id};
    ApiResponse apiResponse =
        await repo.authenticateTaskRequest(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      _showReceipt();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _showReceipt(){
    TaskReceipt details = TaskReceipt(
        paymentType: isCash
            ? "Cash Payment Receipt / إيصال الدفع النقدي "
            : "Cheque Payment Receipt / إيصال دفع الشيك",
        donorName:
        "${taskCollectionDetails.requesterName} / ${taskCollectionDetails.requesterNameAr}",
        address: taskCollectionDetails.collectionPoint,
        requestId: taskCollectionDetails.id.toString(),
        date: Utils.dateFormat1.format(taskCollectionDetails.collectionDate),
        collectionTime: taskCollectionDetails.collectionTime,
        amount: taskCollectionDetails.totalAmount.toInt().toString());
    receiptDialog(
        isCash: isCash,
        imagesList: imagesList,
        cashData: cashData,
        details: details,
        cashNotes: cashNotes,
        totalAmount: taskCollectionDetails.totalAmount.toInt());
  }

  String getHeading() => isCash ? "imageOfCashToRider" : "imageOfChequeToRider";

  @override
  void onClose() {
    cashNotes.close();
    cashData.close();
    imagesList.close();

    super.onClose();
  }

}
