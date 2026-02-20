import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/feedback_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class AddFeedbackViewModel extends GetxController with GenericMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  final attachmentController = TextEditingController();
  RxBool isSelected = false.obs;
  final detailsNode = FocusNode();
  final phoneNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  final selectedType = Rxn<String>();
  final repo = FeedbackRepoImpl();
  final genericRepo = GenericRepoImpl();

  late final User user;
  late final List<KeyboardActionsItem> keyboardActionsItem;

  String? attachment;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.addNewFeedbackScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: phoneNode, displayArrows: false),
      KeyboardActionsItem(focusNode: detailsNode, displayArrows: false),
    ];
    if (!isUserLoggedIn) return;

    user = userBox.getAt(0);
    final fullName = Utils.isArabic
        ? '${user.firstNameArabic} ${user.lastNameArabic}'
        : '${user.firstName} ${user.lastName}';

    nameController.text = fullName.trim();
    emailController.text = user.email ?? "";
    phoneController.text = user.mobile ?? "";
  }

  bool get isUserLoggedIn => userBox.isNotEmpty;

  Future<void> submitFeedback() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Utils.showLoadingDialog();
    final Map<String, dynamic> body = {
      "feedbackUserType": isUserLoggedIn ? 2 : 1,
      "nameEN": nameController.text,
      "email": emailController.text,
      "feedbackType": Utils.feedbackTypeIntoInt(selectedType.value!),
      "mobile": phoneController.text,
      "titleEN": titleController.text,
      "detailEN": detailsController.text,
      "attachment": attachment,
    };

    if (isUserLoggedIn) {
      body["nameAR"] = "${user.firstNameArabic} ${user.lastNameArabic}";
    }
    final apiResponse =
        await repo.submitFeedback(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future<void> addFile() async {
    final PlatformFile? file = await Utils.pickFile();
    if (file == null) return;
    Utils.showLoadingDialog();
    final result = await uploadImage(filePath: file.path!);
    Utils.hideLoadingDialog();
    if(result!=null){
      attachmentController.text = result;
      attachment = result;
    }
  }

  void onChangeFeedbackType(String value) => selectedType.value = value;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    titleController.dispose();
    detailsController.dispose();
    attachmentController.dispose();

    phoneNode.dispose();
    detailsNode.dispose();

    selectedType.close();

    super.onClose();
  }

}
