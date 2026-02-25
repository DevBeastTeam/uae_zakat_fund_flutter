import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/platform_documents.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user_preferences.dart';
import 'package:zakat_fund/repository/platform_doc_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';

class PlatformDocViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final docNameEnglishController = TextEditingController();
  final docNameArabicController = TextEditingController();
  final startDateEnglishController = TextEditingController();
  final startDateArabicController = TextEditingController();
  final endDateEnglishController = TextEditingController();
  final endDateArabicController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  Rxn selectedType = Rxn<String>();
  Rxn selectedForm = Rxn<String>();
  Rxn selectedStatus = Rxn<String>();
  Rxn selectedFileType = Rxn<String>();
  Rxn selectedAssociatedType = Rxn<String>();

  RxList<String> selectedTypes = <String>[].obs;

  RxList<PlatformDocuments> platformDocuments = <PlatformDocuments>[].obs;
  late RxList<UserPreferences> requireFields;

  List<PlatformDocuments> allDocuments = [];

  late PlatformDocuments document;

  final repo = PlatformDocRepoImpl();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.platformDocumentsScreen);
    initRequiredFields();
    if (canView) fetchDocuments();
  }

  initRequiredFields() {
    requireFields = <UserPreferences>[
      UserPreferences(name: 'required', selectedChoice: 1),
      UserPreferences(name: 'requiresDates', selectedChoice: 1),
      UserPreferences(
          name: 'dateType', choices: ["oneDate", "twoDate"], show: false),
    ].obs;
  }

  setData() {
    docNameEnglishController.text = document.documentName;
    docNameArabicController.text = document.documentNameAr;
    selectedAssociatedType.value =
        Utils.entityTypesIntoString(document.documentAssociatedWith);
    requireFields = <UserPreferences>[
      UserPreferences(
          name: 'required', selectedChoice: document.isRequired ? 0 : 1),
      UserPreferences(
          name: 'requiresDates', selectedChoice: document.requiresDate ? 0 : 1),
      UserPreferences(
          name: 'dateType',
          choices: ["oneDate", "twoDate"],
          show: document.requiresDate,
          selectedChoice: document.endDate.isEmpty ? 0 : 1),
    ].obs;
    startDateEnglishController.text = document.startDate;
    startDateArabicController.text = document.startDateAr;
    endDateEnglishController.text = document.endDate.replaceAll(", ", "");
    endDateArabicController.text = document.endDateAr.replaceAll(",", "");
    List<String> files = document.allowedFileTypes.split(",");
    selectedFileType.value = files[0];
    selectedTypes.value = List.from(files);
  }

  addDocument({PlatformDocuments? doc}) {
    if (doc != null) {
      document = doc;
      setData();
    }
    Utils.logEvent(
        name: doc != null
            ? EventConstant.updatePlatformDocumentScreen
            : EventConstant.addNewPlatformDocumentScreen);
    Get.toNamed(AppRoutes.addPlatformDoc, arguments: doc != null)?.then((val) {
      initRequiredFields();
      docNameEnglishController.clear();
      docNameArabicController.clear();
      selectedAssociatedType.value = null;
      startDateEnglishController.clear();
      startDateArabicController.clear();
      endDateEnglishController.clear();
      endDateArabicController.clear();
      selectedFileType.value = null;
      selectedTypes.clear();
      if (val != null && val) {
        if (canView) fetchDocuments();
      }
    });
  }

  fetchDocuments() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await repo.fetchPlatformDocuments(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allDocuments = apiResponse.data;
      platformDocuments.value = List.from(allDocuments);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  updateStatus(PlatformDocuments document) async {
    Utils.showLoadingDialog();
    var body = {
      "isDisabled": !document.isActive,
      "id": document.id,
    };
    ApiResponse apiResponse =
        await repo.updateDocumentStatus(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      document.isActive = !document.isActive;
      platformDocuments.refresh();
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  savePlatformDocument({bool update = false}) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.showLoadingDialog();
    var body = {
      "documentName": docNameEnglishController.text,
      "documentNameAr": docNameArabicController.text,
      "documentAssociatedWith":
          Utils.entityTypesIntoInt(selectedAssociatedType.value),
      "dateType": requireFields[2].selectedChoice == 0 ? "one" : "two",
      "isRequired": requireFields[0].selectedChoice == 0,
      "requiresDate": requireFields[1].selectedChoice == 0,
      if (requireFields[1].selectedChoice == 0)
        "startDate": startDateEnglishController.text,
      if (requireFields[1].selectedChoice == 0)
        "startDateAr": startDateArabicController.text,
      if (requireFields[2].selectedChoice == 1)
        "endDate": endDateEnglishController.text,
      if (requireFields[2].selectedChoice == 1)
        "endDateAr": endDateArabicController.text,
      "allowedFileTypes": selectedTypes.join(", ")
    };
    ApiResponse apiResponse = update
        ? await repo.updatePlatformDocument(
            request: RequestBody(
                body: body,
                endPoint:
                    "${ApiConstant.updatePlatformDocument}/${document.id}"))
        : await repo.savePlatformDocument(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Get.back(result: true);
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
        Padding(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetHeader(),
              Obx(() => LabelDropDown(
                    items: AppConstant.fileTypes,
                    selectedValue: selectedType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedType.value = value,
                    label: 'type',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.associatedUserTypes,
                    selectedValue: selectedForm.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedForm.value = value,
                    label: 'associatedForm',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.enableDisAbleStatus,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedStatus.value = value,
                    label: 'status',
                  )),
              20.verticalSpace,
              buildBottomSheetButtons(
                onClear: () => clearAllFilters(),
                onApply: () {
                  Get.back();
                  filterDocuments();
                },
              ),
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearAllFilters() {
    Get.back();
    selectedForm.value = null;
    selectedStatus.value = null;
    selectedType.value = null;
    platformDocuments.value = List.from(allDocuments);
  }

  filterDocumentsById() {
    String? id =
        searchController.text.trim().isNotEmpty ? searchController.text : null;
    List<PlatformDocuments> filterList = allDocuments.where((data) {
      bool matchesRequestId = searchController.text.trim().isEmpty ||
          data.id.toString().startsWith(id!);
      return matchesRequestId;
    }).toList();
    platformDocuments.value = filterList;
  }

  void filterDocuments() {
    List<PlatformDocuments> filterList = allDocuments.where((data) {
      bool matchesForm = selectedForm.value == null ||
          data.documentAssociatedWith ==
              Utils.entityTypesIntoInt(selectedForm.value);
      bool matchesStatus = selectedStatus.value == null ||
          data.isActive == (selectedStatus.value == "enable");
      bool matchesType = selectedType.value == null ||
          data.allowedFileTypes
              .contains(selectedType.value.toString().toUpperCase());
      return matchesForm && matchesStatus && matchesType;
    }).toList();

    platformDocuments.value = filterList;
  }

  deleteDocument(PlatformDocuments document) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deletePlatformDocument(
        request: RequestBody(
            endPoint: "${ApiConstant.deletePlatformDocument}/${document.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      platformDocuments.remove(document);
      platformDocuments.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  exportDocuments() {
    Utils.downloadFile(
        url: "${ApiConstant.exportFile}platformDocuments",
        isExport: true,
        filename: "Platform_Documents.csv");
  }

  onMenuSelected(String value, PlatformDocuments doc) {
    if (value == "edit") {
      addDocument(doc: doc);
    } else {
      deleteDocument(doc);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    docNameEnglishController.dispose();
    docNameArabicController.dispose();
    startDateEnglishController.dispose();
    startDateArabicController.dispose();
    endDateEnglishController.dispose();
    endDateArabicController.dispose();

    selectedType.close();
    selectedForm.close();
    selectedStatus.close();
    selectedFileType.close();
    selectedAssociatedType.close();
    selectedTypes.close();
    platformDocuments.close();
    requireFields.close();
    super.onClose();
  }
}
