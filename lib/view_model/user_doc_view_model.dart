import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/public_documents.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/user_doc_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class UserDocumentsViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final dateController = TextEditingController();

  final Rxn selectedEntityType = Rxn<String>();
  final Rxn selectedEntityId = Rxn<String>();
  final Rxn selectedEUploadedBy = Rxn<String>();
  final Rxn selectedEntityName = Rxn<String>();

  final RxList<PublicDocuments> userDocuments = <PublicDocuments>[].obs;
  List<PublicDocuments> allDocuments = [];

  List<String> uploadedByList = [];
  List<String> entityNameList = [];
  List<String> entityIdList = [];

  final UserDocRepoImpl repo = UserDocRepoImpl();

  DateTime? pickedExpiry;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.userDocumentsScreen);
    if (canView) fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    Utils.showLoadingDialog();
    final ApiResponse apiResponse =
        await repo.fetchUserDocuments(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allDocuments = apiResponse.data;
      userDocuments.assignAll(allDocuments);
      entityIdList = allDocuments.map((doc) => doc.id.toString()).toList();
      entityNameList = allDocuments
          .map((doc) => Utils.isArabic
              ? doc.accountNameAr.toString()
              : doc.accountName.toString())
          .toSet()
          .toList();
      uploadedByList = allDocuments
          .map((doc) => Utils.isArabic ? doc.userNameAr : doc.userName)
          .toSet()
          .toList();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void filterDocuments() {
    final String? date =
        dateController.text.isNotEmpty ? dateController.text : null;
    final String? entityName = selectedEntityName.value;
    final String? uploadedBy = selectedEUploadedBy.value;
    final String? id = selectedEntityId.value;

    userDocuments.assignAll(allDocuments.where((data) {
      String currentEntityName =
          Utils.isArabic ? data.accountNameAr : data.accountName;
      String currentUploaded = Utils.isArabic ? data.userNameAr : data.userName;
      final bool matchesEntityName =
          entityName == null || currentEntityName == entityName;
      final bool matchesUploadedBy =
          uploadedBy == null || currentUploaded == uploadedBy;
      final bool matchesType = selectedEntityType.value == null ||
          data.documentAssociatedWith ==
              Utils.entityTypesIntoInt(selectedEntityType.value);
      final bool matchesEntityId = id == null || data.id == int.parse(id);
      final bool matchesDate =
          date == null || Utils.dateFormat1.format(data.uploadedDate) == date;

      return matchesType &&
          matchesDate &&
          matchesEntityId &&
          matchesEntityName &&
          matchesUploadedBy;
    }).toList());
  }

  void viewFile(String fileName) {
    final String url = "${FlavorConfig.storageUrl}$fileName";
    Utils.openUrl(url);
  }

  void filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildBottomSheetHeader(),
            Obx(() => LabelDropDown(
                  items: uploadedByList,
                  selectedValue: selectedEUploadedBy.value,
                  hint: "chooseAnOption",
                  onChanged: (value) => selectedEUploadedBy.value = value,
                  label: 'uploadedBy',
                )),
            16.verticalSpace,
            Obx(() => LabelDropDown(
                  items: entityIdList,
                  selectedValue: selectedEntityId.value,
                  hint: "chooseAnOption",
                  onChanged: (value) => selectedEntityId.value = value,
                  label: 'entityId',
                )),
            16.verticalSpace,
            Obx(() => LabelDropDown(
                  items: entityNameList,
                  selectedValue: selectedEntityName.value,
                  hint: "chooseAnOption",
                  onChanged: (value) => selectedEntityName.value = value,
                  label: 'entityName',
                )),
            16.verticalSpace,
            Obx(() => LabelDropDown(
                  items: AppConstant.userDocEntityTypes,
                  selectedValue: selectedEntityType.value,
                  hint: "chooseAnOption",
                  onChanged: (value) => selectedEntityType.value = value,
                  label: 'entityType',
                )),
            16.verticalSpace,
            LabelTextField(
              controller: dateController,
              label: "uploadDate",
              isDate: true,
              readOnly: true,
              onTap: datePickerDialog,
            ),
            20.verticalSpace,
            buildBottomSheetButtons(
                onClear: () => clearAllFilters(),
                onApply: () {
                  Get.back();
                  filterDocuments();
                }),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
    );
  }

  void clearAllFilters() {
    Get.back();
    selectedEntityType.value = null;
    selectedEntityId.value = null;
    selectedEUploadedBy.value = null;
    selectedEntityName.value = null;
    dateController.clear();
    userDocuments.assignAll(allDocuments);
  }

  Future<void> datePickerDialog() async {
    final DateTime now = DateTime.now();
    DateTime? selectedDateTime = await Utils.datePickerDialog(
      initialDate: now,
      lastDate: now,
      firstDate: DateTime(1950),
    );
    pickedExpiry = selectedDateTime;
    dateController.text = Utils.dateFormat1.format(selectedDateTime!);
  }

  void filterDocumentsById() {
    final String? id =
        searchController.text.trim().isNotEmpty ? searchController.text : null;

    userDocuments.assignAll(allDocuments.where((data) {
      return id == null || data.id.toString().startsWith(id);
    }).toList());
  }

  exportDocuments() {
    Utils.downloadFile(
        url: "${ApiConstant.exportFile}UserDocuments",
        isExport: true,
        filename: "Users_Documents.csv");
  }

  onMenuSelected(String item, String? url) {
    if (item == "view") {
      if (Utils.isImageFile(url.toString())) {
        Get.toNamed(AppRoutes.photoViewScreen, arguments: url.toString());
        return;
      }
      viewFile(url ?? "");
    } else {
      Utils.downloadFile(url: url ?? "");
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    dateController.dispose();

    selectedEntityType.close();
    selectedEntityId.close();
    selectedEUploadedBy.close();
    selectedEntityName.close();
    userDocuments.close();
    super.onClose();
  }
}
