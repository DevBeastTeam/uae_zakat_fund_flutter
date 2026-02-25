import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';

class RequestRejectViewModel extends GetxController with GenericMixin{

  late final String title;
  late final Requests request;
  bool isRejected = false;

  final formKey = GlobalKey<FormState>();
  final notesController = TextEditingController();
  final notesNode = FocusNode();

  final RxnString selectedReason = RxnString();

  RxList<PlatformFile> documents = <PlatformFile>[].obs;
  List<String> uploadedFileNames = [];
  List<String> files = [];

  late List<KeyboardActionsItem> keyboardActionsItem;



  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: notesNode,displayArrows: false),
    ];
    var data = Get.arguments;
    title = data["title"];
    request = data["request"];
    isRejected = data["isRejected"]??false;
  }

  pickDocuments() async {
    Utils.hideKeyboard();
    List<PlatformFile> files = await Utils.pickMultipleFiles();
    documents.addAll(files);
    documents.refresh();
  }

  rejectRequest() async {
    Utils.showLoadingDialog();
    if (documents.isNotEmpty) {
      for (PlatformFile file in documents) {
        await uploadPicture(path: file.path!);
      }
    }
    Get.find<RequestsViewModel>().approveRejectRequest(
        request: request,
        isAccepted: false,
        accountId: request.accountID,
        isRejected: isRejected,
        rejectionReason: selectedReason.value,
        rejectNote: notesController.text,
        rejectDocument: files.isNotEmpty?files.join(","):null);
  }

  Future uploadPicture({required String path}) async {
    final result = await uploadImage(filePath: path);
    if(result!=null){
      files.add(result);
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    notesNode.dispose();

    selectedReason.close();
    documents.close();
    super.onClose();
  }

}
