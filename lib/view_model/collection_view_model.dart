import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/tasks_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class CollectionViewModel extends GetxController {

  late Requests request;
  late User user;
  final taskRepo = TaskRepoImpl();

  final formKey = GlobalKey<FormState>();
  final codeFormKey = GlobalKey<FormState>();

  final rejectionNotes = TextEditingController();
  final uniqueCodeController = TextEditingController();

  final RxBool showAcceptReject = false.obs;
  final Rxn<ReceiptDetails> taskDetails = Rxn<ReceiptDetails>();

  bool isCash = false;
  bool isAgent = false;

  List requestingDetails = [
    {"key": "requestId", "value": ""},
    {"key": "requestorName", "value": ""},
    {"key": "requestDate", "value": ""},
    {"key": "requestType", "value": ""},
    {"key": "status", "value": ""},
  ];

  List collectionDetails = [
    {"key": "collectionDate", "value": ""},
    {"key": "collectionTime", "value": ""},
  ];

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    user = userBox.getAt(0);
    if (user.roles[0] == "Agent" || user.roles[0] == "Employee") {
      isAgent = true;
    }
    request = Get.arguments["request"];
    isCash = request.requestType == "Cash";
    fetchTransactionDetails();
  }

  Future fetchTransactionDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await taskRepo.taskDetails(request: RequestBody(endPoint: "${ApiConstant.taskDetails}/${request.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      taskDetails.value = apiResponse.data;
      _setTransactionDetails();
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  _setTransactionDetails(){
    showAcceptReject.value = [1, 5].contains(taskDetails.value!.taskStatus);

    requestingDetails = [
      {"key": "requestId", "value": request.id},
      {
        "key": "requestorName",
        "value":
        Utils.isArabic ? request.requesterNameAr : request.requesterName
      },
      {
        "key": "requestDate",
        "value": Utils.dateFormat1.format(taskDetails.value!.createdDate)
      },
      {
        "key": "requestType",
        "value": Utils.isArabic ? request.requestTypeAr : request.requestType
      },
      {
        "key": "status",
        "value": Utils.taskStatusIntoString(taskDetails.value!.taskStatus).tr
      },
    ];
    collectionDetails = [
      {
        "key": "collectionDate",
        "value": Utils.dateFormat1.format(taskDetails.value!.collectionDate)
      },
      {"key": "collectionTime", "value": taskDetails.value?.collectionTime},
    ];
    taskDetails.refresh();
  }

  collectionDialog() {
    _showDialog(
      title: "collectionQROrCode",
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: elevatedButton(text: "scanQrCode", onPressed:()=> scanQrDialog()),
        ),
        16.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: elevatedButton(text: "addUniqueCode", onPressed:()=> uniqueDialogDialog()),
        ),
      ],
    );
  }

  scanQrDialog() {
    Get.back();
    final imageUrl = "${FlavorConfig.baseUrl.replaceAll("api/", "")}TransactionsQR/${taskDetails.value!.transactionId}.png";

    _showDialog(
      title: "scanQrCode",
      actions: [
        CachedImage(
          image: imageUrl,
          width: 100.w,
          height: 100.h,
          profile: true,
          showPlaceHolder: true,
        ),
        16.verticalSpace,
        elevatedButton(text: "scanQrCode", onPressed:()=> scanQRCode()),
      ],
    );
  }

  scanQRCode(){
    Get.back();
    Get.toNamed(AppRoutes.qrScannerScreen)?.then((result) {
      if (result != null) fetchTaskDetails(result);
    });
  }

  uniqueDialogDialog() {
    Get.back();
    _showDialog(
      title: "enterUniqueCode",
      actions: [
        Form(
          key: codeFormKey,
          child: LabelTextField(
            controller: uniqueCodeController,
            label: "enterUniqueCode",
            isRequired: true,
            checkValidation: true,
            hint: "enterUniqueCode",
          ),
        ),
        16.verticalSpace,
        elevatedButton(text: "proceed", onPressed:()=> proceedWithUniqueCode()),
      ],
    ).then((_) => Future.delayed(Duration(seconds: 1), () {
      uniqueCodeController.clear();
    }));
  }

  proceedWithUniqueCode(){
    if (!codeFormKey.currentState!.validate()) {
      return;
    }
    Get.back();
    fetchTaskDetails(uniqueCodeController.text);
  }

  rejectionDialog() {
    _showDialog(
      title: "notes",
      actions: [
        Form(
          key: formKey,
          child: LabelTextField(
            controller: rejectionNotes,
            isRequired: true,
            checkValidation: true,
            label: "addNote",
            maxLines: 4,
          ),
        ),
        16.verticalSpace,
        elevatedButton(text: "send", onPressed:()=> sendRejectionDetails()),
      ],
    ).then((_) => Future.delayed(Duration(seconds: 1), () {
      rejectionNotes.clear();
    }));
  }

  sendRejectionDetails(){
    if (!formKey.currentState!.validate()) return;
    Get.back();
    rejectTask();
  }

  rejectTask() async {
    Utils.showLoadingDialog();
    var body = {"taskId": request.id, "rejectionNote": rejectionNotes.text};
    ApiResponse apiResponse =
        await taskRepo.rejectTask(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Get.back(result: true);
      Utils.showGlobalSnackBar(message: apiResponse.data);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  fetchTaskDetails(String code) async {
    Utils.showLoadingDialog();
    var queryParameters = {
      "uniqueCode": code,
      "userRequestId": request.userRequestId
    };
    ApiResponse apiResponse = await taskRepo.taskDetailsByCode(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Get.toNamed(AppRoutes.addCashScreen, arguments: {
        "taskId": request.id,
        "details": apiResponse.data,
        "projects": taskDetails.value?.projects
      })!.then((value) {
        if (value != null && value) {
          Get.back(result: true);
        }
      });
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  String getTitle() => isCash ? "cashCollection" : "bankChequeCollection";

  Future<void> _showDialog({
    required String title,
    required List<Widget> actions,
  }) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                13.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          title.tr,
                          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.highlight_remove_outlined,
                        color: AppColors.secondaryPrimaryBlackColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: actions,
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  @override
  void onClose() {
    rejectionNotes.dispose();
    uniqueCodeController.dispose();

    showAcceptReject.close();
    taskDetails.close();

    super.onClose();
  }

}
