import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/feedbacks.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/feedback_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class FeedbackPreviewViewModel extends ModulePermissionsViewModel {
  late int id;

  final formKey = GlobalKey<FormState>();
  final repo = FeedbackRepoImpl();

  final feedbackIdController = TextEditingController();
  final userTypeController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final feedbackTypeController = TextEditingController();
  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  final rootCauseController = TextEditingController();
  final catController = TextEditingController();
  final solutionProvidedController = TextEditingController();
  final responseController = TextEditingController();

  final rootCauseNode = FocusNode();
  final solutionProvidedNode = FocusNode();
  final responseNode = FocusNode();

  final RxBool showResponse = false.obs;
  final RxBool readOnly = false.obs;
  final Rxn feedback = Rxn<Feedbacks>();
  final Rxn<String> selectedCategory = Rxn<String>();
  final List<String> categories = ["valid", "spam"];
  late List<KeyboardActionsItem> keyboardActionsItem;

  bool fromTasks = false;
  bool isRequest = false;

  var data;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: rootCauseNode),
      KeyboardActionsItem(focusNode: solutionProvidedNode),
      KeyboardActionsItem(focusNode: responseNode),
    ];
    Future.microtask((){
      data = Get.arguments;
      fromTasks = data["fromTasks"] ?? false;
      if (data != null && data["request"] != null) {
        isRequest = !fromTasks;
        id = request!.entityId;
        readOnly.value = true;
      } else {
        id = data["id"];
      }
      if (fromTasks) {
        readOnly.value = false;
      }
      fetchFeedbackDetails();
    });
  }

  fetchFeedbackDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.feedbackDetails(
        request: RequestBody(endPoint: "${ApiConstant.feedbackDetails}/$id"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      feedback.value = apiResponse.data;

      if (user.isAdmin && isRequest) {
        isAdmin.value = request?.status == 0 || request?.status == 1;
      } else {
        final status = feedback.value?.requestStatus ?? 0;
        if ([0, 2, 3].contains(status)) {
          isAdmin.value = false;
        } else {
          isAdmin.value = fromTasks || user.isAdmin;
        }
      }

      final f = feedback.value!;
      feedbackIdController.text = f.id.toString();
      userTypeController.text = Utils.feedbackUserTypeIntoString(f.feedbackUserType);

      nameController.text = Utils.isArabic
          ? (f.nameAr.isEmpty || f.nameAr == "string" ? f.nameEn : f.nameAr)
          : f.nameEn;

      emailController.text = f.email;
      mobileController.text = f.mobile;
      feedbackTypeController.text = Utils.feedbackTypeIntoString(f.feedbackType);
      titleController.text = f.titleEn;
      detailsController.text = f.detailEn;
      rootCauseController.text = f.rootCause;
      solutionProvidedController.text = f.solutionProvided;
      responseController.text = f.response;

      if (f.categorization != 0) {
        selectedCategory.value = f.categorization == 1 ? "valid" : "spam";
        catController.text = selectedCategory.value!.tr;
      }


      final isOwner = f.userId == user.id;

      if (isOwner && f.requestStatus == 2) {
        showResponse.value = true;
        readOnly.value = true;
      } else if (!isOwner && [0, 2, 3].contains(f.requestStatus)) {
        showResponse.value = true;
        readOnly.value = true;
      } else if (!isOwner && ![2, 3].contains(f.requestStatus)) {
        showResponse.value = true;
        readOnly.value = false;
      } else {
        showResponse.value = true;
        readOnly.value = true;
      }
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  submitFeedbackResponse() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.showLoadingDialog();
    var body = {
      "id": feedback.value.id,
      "feedbackUserType": feedback.value.feedbackUserType,
      "nameEN": feedback.value.nameEn,
      "nameAR": feedback.value.nameAr,
      "email": feedback.value.email,
      "feedbackType": feedback.value.feedbackType,
      "mobile": feedback.value.mobile,
      "titleEN": feedback.value.titleEn,
      "titleAR": feedback.value.titleAr,
      "detailEN": feedback.value.detailEn,
      "detailAR": feedback.value.detailAr,
      "categorization": selectedCategory.value == "valid" ? 1 : 3,
      if (selectedCategory.value != "spam") ...{
        "rootCause": rootCauseController.text,
        "solutionProvided": solutionProvidedController.text,
        "response": responseController.text
      },
      "createdBy": feedback.value.userId,
    };
    ApiResponse apiResponse = await repo.submitFeedbackResponse(
        request: RequestBody(
            endPoint: "${ApiConstant.submitFeedbackResponse}/${user.id}",
            body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "responseSubmittedSuccessfully".tr);
      Get.back(result: true);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    feedbackIdController.dispose();
    userTypeController.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    feedbackTypeController.dispose();
    titleController.dispose();
    detailsController.dispose();
    rootCauseController.dispose();
    catController.dispose();
    solutionProvidedController.dispose();
    responseController.dispose();

    rootCauseNode.dispose();
    solutionProvidedNode.dispose();
    responseNode.dispose();

    showResponse.close();
    readOnly.close();
    feedback.close();
    selectedCategory.close();

    super.onClose();
  }

}
