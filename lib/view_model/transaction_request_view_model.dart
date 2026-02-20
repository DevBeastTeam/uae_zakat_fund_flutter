import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/management_staff.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/emp_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class TransactionRequestViewModel extends ModulePermissionsViewModel with GenericMixin{
  final formKey = GlobalKey<FormState>();

  final RxBool showTransactionInfo = true.obs;
  final RxBool showCollectionInfo = true.obs;

  final Rxn<String> photo = Rxn<String>();
  final Rxn<String> selectedPriority = Rxn<String>();
  final Rxn<String> selectedAgent = Rxn<String>();

  List<ManagementStaff> agents = [];
  List<String> agentsList = [];

  final requestId = TextEditingController();
  final agentEmail = TextEditingController();
  final requestDate = TextEditingController();
  final requestName = TextEditingController();
  final requestTypeController = TextEditingController();
  final paymentAmount = TextEditingController();
  final paymentDate = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final payersName = TextEditingController();
  final address = TextEditingController();
  final collectionDate = TextEditingController();
  final chequeDate = TextEditingController();
  final collectionTime = TextEditingController();
  final bankName = TextEditingController();
  final chequeNumber = TextEditingController();
  final bankAccount = TextEditingController();
  final ibanNumber = TextEditingController();
  final branchType = TextEditingController();
  final branchCode = TextEditingController();

  late final ReceiptDetails details;

  final genericRepo = GenericRepoImpl();
  final empRepo = EmpRepoImpl();

  late String rejectionMessage;
  late String successMessage;
  late String requestType;


  @override
  onInit() {
    _fetchInitialData();
    super.onInit();
  }


 _fetchInitialData()  {
    Future.microtask(() async {
      requestType = request!.requestType;
      try{
        Utils.showLoadingDialog();
        await Future.wait([
          _fetchTransactionDetails(),
          if (user.isAdmin&&request?.status!=4&&user.isAdmin&&request?.status!=9) _fetchEmployees(),
        ]);
      }finally{
        Utils.hideLoadingDialog();
      }
    });

  }


  Future _fetchEmployees() async {
    Map<String, dynamic>? queryParameters = {"requestId":request?.id};
    final ApiResponse apiResponse = await empRepo.fetchSuperAgents(request: RequestBody(queryParameters:queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      agents.assignAll(apiResponse.data);
      agentsList.assignAll(agents.map((emp) =>
      Utils.isArabic ? "${emp.firstNameArabic} ${emp.lastNameArabic} (${emp.id})"
          : "${emp.firstName} ${emp.lastName} (${emp.id})").toSet());
    }else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }

  }

  Future _fetchBanks(int id) async {
    final result = await getAllBanks();
    if(result.isNotEmpty){
      bankName.text = Utils.findLookupName(result, id);
    }
  }

  Future _fetchTransactionDetails() async {
    final result = await getTransactionDetails({"transactionId": request!.entityId});
    if(result!=null){
      details = result;
      isAdmin.value = (request!.status == 1 || request!.status == 9|| request!.status == 7) && user.isAdmin;
      _setTransactionData();
    }
  }

  void _setTransactionData() {
    switch (requestType) {
      case "Cash":
        rejectionMessage = "cashCollectionRejection";
        successMessage = "cashCollectionAccepted";
        _populateCashRequestData();
        break;
      case "Deposit":
        rejectionMessage = "depositCollectionRejection";
        successMessage = "depositCollectionAccepted";
        _populateDepositRequestData();
        break;
      case "Bank Cheque":
        rejectionMessage = "bankChequeCollectionRejection";
        successMessage = "bankChequeCollectionAccepted";
        _populateBankChequeData();
        break;
    }
  }

  void _populateCashRequestData() {
    requestId.text = request!.id.toString();
    requestDate.text = Utils.dateFormat1.format(details.createdDate);
    requestName.text = Utils.isArabic ? request!.requesterNameAr : request!.requesterName;
    requestTypeController.text = Utils.isArabic ? request!.requestTypeAr : requestType;
    paymentAmount.text = details.totalAmount.toInt().toString();
    address.text = details.collectionPoint;
    collectionDate.text = Utils.dateFormat1.format(details.collectionDate);
    collectionTime.text = details.collectionTime;
  }

  void _populateDepositRequestData() {
    chequeNumber.text = details.chequeNo ?? "";
    paymentAmount.text = details.totalAmount.toInt().toString();
    paymentDate.text = Utils.dateFormat1.format(details.chequeDate);
    email.text = details.email ?? "";
    phoneNumber.text = details.phoneNumber ?? "";
    payersName.text = Utils.isArabic ? details.donorNameAr : details.donorName;
    photo.value = details.chequePhoto ?? "";
    _fetchBanks(details.bankId);
  }

  void _populateBankChequeData() {
    chequeNumber.text = details.chequeNo.toString();
    paymentAmount.text = details.totalAmount.toInt().toString();
    address.text = details.collectionPoint;
    chequeDate.text = Utils.dateFormat1.format(details.chequeDate);
    collectionDate.text = Utils.dateFormat1.format(details.collectionDate);
    collectionTime.text = details.collectionTime;
    photo.value = details.chequePhoto ?? "";
    _fetchBanks(details.bankId);
  }

  assignDialog() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildBottomSheetHeader(text: "assignTaskToAgent"),
                Obx(() => LabelDropDown(
                  items: agentsList,
                  selectedValue: selectedAgent.value,
                  hint: "chooseAnOption",
                  isRequired: true,
                  onChanged: (value) {
                    selectedAgent.value = value;
                    int agentId = int.parse(Utils.employeeId(selectedAgent.value!));
                    String email = agents.firstWhere((emp)=>emp.id==agentId).email;
                    agentEmail.text = email;
                  },
                  label: 'employeeName',
                )),
                10.verticalSpace,
                LabelTextField(
                  controller: agentEmail,
                  label: "email",
                  readOnly: true,
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: TextEditingController(
                      text: Utils.isArabic
                          ? request?.requestTypeAr
                          : requestType),
                  label: "requestType",
                  readOnly: true,
                  isRequired: true,
                  checkValidation: true,
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: TextEditingController(
                      text: Utils.dateFormat1
                          .format(details.collectionDate)),
                  label: "collectionDate",
                  isArabicDirection: true,
                  readOnly: true,
                  isRequired: true,
                  checkValidation: true,
                ),
                10.verticalSpace,
                Obx(() => LabelDropDown(
                  items: AppConstant.priorities,
                  selectedValue: selectedPriority.value,
                  hint: "chooseAnOption",
                  isRequired: true,
                  onChanged: (value) => selectedPriority.value = value,
                  label: 'priority',
                )),
                16.verticalSpace,
                elevatedButton(
                    text: "assignTask",
                    onPressed: () => assignTaskToAgent()),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    )).then((_) {
      _resetDialogData();
    });
  }

  _resetDialogData(){
    Future.delayed(Duration(seconds: 1)).then((_) {
      selectedAgent.value = null;
      selectedPriority.value = null;
      agentEmail.clear();
    });
  }

  assignTaskToAgent() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Get.back();
    Utils.showLoadingDialog();
    int agentId = int.parse(Utils.employeeId(selectedAgent.value!));
    var body = {
      "userRequestId": request?.id,
      "assignedTo": agentId,
      "taskType": requestType,
      "tasksPriority": Utils.priorityIntoInt(selectedPriority.value!)
    };
    ApiResponse apiResponse = await genericRepo.assignTask(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back(result: true);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  onTapDepositTransactionInformation()=>showTransactionInfo.value = !showTransactionInfo.value;

  onTapBankChequeInformation()=>showTransactionInfo.value = !showTransactionInfo.value;

  onTapCollectionPointInformation()=>showCollectionInfo.value = !showCollectionInfo.value;

  @override
  void onClose() {
    requestId.dispose();
    agentEmail.dispose();
    requestDate.dispose();
    requestName.dispose();
    requestTypeController.dispose();
    paymentAmount.dispose();
    paymentDate.dispose();
    email.dispose();
    phoneNumber.dispose();
    payersName.dispose();
    address.dispose();
    collectionDate.dispose();
    chequeDate.dispose();
    collectionTime.dispose();
    bankName.dispose();
    chequeNumber.dispose();
    bankAccount.dispose();
    ibanNumber.dispose();
    branchType.dispose();
    branchCode.dispose();

    showTransactionInfo.close();
    showCollectionInfo.close();
    photo.close();
    selectedPriority.close();
    selectedAgent.close();
    super.onClose();
  }

}