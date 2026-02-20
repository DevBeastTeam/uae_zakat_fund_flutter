import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart' as response;
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/public_documents.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/public_doc_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';

class PublicDocumentsViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  final docNameEnglishController = TextEditingController();
  final nameController = TextEditingController();
  final docNameArabicController = TextEditingController();
  final documentController = TextEditingController();

  RxList<PublicDocuments> publicDocuments = <PublicDocuments>[].obs;
  List<PublicDocuments> allDocuments = [];
  List<String> types = [];

  Rxn selectedAddType = Rxn<String>();
  Rxn selectedStatus = Rxn<String>();

  var formKey = GlobalKey<FormState>();

  PlatformFile? documentFile;

  final repo = PublicDocRepoImpl();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.publicDocumentsScreen);
    if (canView) fetchDocuments();
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
              LabelTextField(
                controller: dateController,
                label: "uploadDate",
                isDate: true,
                readOnly: true,
                onTap: () => datePickerDialog(),
              ),
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
                  })
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
    nameController.clear();
    dateController.clear();
    selectedStatus.value = null;
    publicDocuments.value = List.from(allDocuments);
  }

  DateTime? pickedExpiry;

  datePickerDialog() async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: dateTime,
      firstDate: DateTime(1950),
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      fieldHintText: "dd/mm/yyyy",
      lastDate: dateTime,
    );
    String date = Utils.dateFormat1.format(picked!);
    pickedExpiry = picked;
    dateController.text = date;
  }

  uploadDocDialog({PublicDocuments? document}) {
    if (document != null) {
      docNameEnglishController.text = document.documentName;
      docNameArabicController.text = document.documentNameAr;
      documentController.text = document.url ?? "";
    }
    Utils.logEvent(name: EventConstant.addNewPublicDocumentScreen);
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "uploadDocument".tr,
                        style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                      ),
                    ),
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.highlight_remove_outlined,
                          color: AppColors.secondaryPrimaryBlackColor,
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: LabelTextField(
                    controller: docNameEnglishController,
                    label: "documentNameEnglish",
                    isRequired: true,
                    checkValidation: true,
                    hint: "enterDocumentName",
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: LabelTextField(
                    controller: docNameArabicController,
                    label: "documentNameArabic",
                    isRequired: true,
                    inputFormatters: InputFormatters.arabicNameFormatter,
                    checkValidation: true,
                    hint: "enterDocumentName",
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: LabelTextField(
                    label: 'document',
                    isRequired: true,
                    checkValidation: true,
                    readOnly: true,
                    onAddFile: () => chooseFile(),
                    controller: documentController,
                  ),
                ),
                6.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: fileInstructWidget(),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: elevatedButton(
                      text: document != null ? "update" : "save",
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        uploadDocument(document);
                      }),
                ),
                8.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: elevatedButton(
                    text: "cancel",
                    onPressed: () => Get.back(),
                    backgroundColor: AppColors.lightGreyColor,
                  ),
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    )).then((_) {
      Future.delayed(Duration(seconds: 1)).then((_) {
        docNameEnglishController.clear();
        docNameArabicController.clear();
        documentController.clear();
      });
    });
  }

  chooseFile() async {
    PlatformFile? file = await Utils.pickFile();
    if (file != null) {
      documentFile = file;
      documentController.text = Utils.fileName(file.path!);
    }
  }

  fetchDocuments({bool showLoader = true}) async {
    if (showLoader) Utils.showLoadingDialog();
    response.ApiResponse apiResponse =
        await repo.fetchPublicDocuments(request: RequestBody());
    if (!showLoader) Utils.hideLoadingDialog();
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allDocuments = apiResponse.data;
      publicDocuments.value = List.from(allDocuments);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  filterDocumentsById() {
    String? id =
        searchController.text.trim().isNotEmpty ? searchController.text : null;
    List<PublicDocuments> filterList = allDocuments.where((data) {
      bool matchesRequestId = searchController.text.trim().isEmpty ||
          data.id.toString().startsWith(id!);
      return matchesRequestId;
    }).toList();
    publicDocuments.value = filterList;
  }

  void filterDocuments() {
    String? date = dateController.text.isNotEmpty ? dateController.text : null;
    List<PublicDocuments> filterList = allDocuments.where((data) {
      bool matchesDate = Utils.dateFormat1.format(data.uploadedDate) == date;
      bool matchesStatus = selectedStatus.value == null ||
          data.isActive == (selectedStatus.value == "enable");
      return matchesDate && matchesStatus;
    }).toList();

    publicDocuments.value = filterList;
  }

  Future uploadDocument(PublicDocuments? document) async {
    Utils.showLoadingDialog();
    String path = "";
    String fileName = documentController.text;
    if (document != null) {
      File? file = await Utils.urlIntoFile(document.url ?? "", fileName);
      path = file!.path;
    } else {
      path = documentFile!.path!;
    }
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(path, filename: fileName),
      "DocumentName": docNameEnglishController.text,
      "DocumentNameAr": docNameArabicController.text,
      if (document != null) "id": document.id,
      "DocumentType": 2,
    });
    response.ApiResponse apiResponse = await repo.uploadPublicDocument(
        request: RequestBody(formData: formData, isFormDataRequest: true));
    if (apiResponse.appState == AppState.onSuccess) {
      if (canView) {
        fetchDocuments(showLoader: false);
      } else {
        Utils.hideLoadingDialog();
      }
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.hideLoadingDialog();
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  updateStatus(PublicDocuments document) async {
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
      publicDocuments.refresh();
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  deleteDocument(PublicDocuments document) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deletePublicDocument(
        request: RequestBody(
            endPoint: "${ApiConstant.deletePlatformDocument}/${document.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      allDocuments.remove(document);
      publicDocuments.remove(document);
      publicDocuments.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  exportDocuments() {
    Utils.downloadFile(
        url: "${ApiConstant.exportFile}publicDocuments",
        isExport: true,
        filename: "Public_Documents.csv");
  }

  onMenuSelected(String item, PublicDocuments document) {
    String file = document.url.toString();
    String url = "${FlavorConfig.storageUrl}$file";
    if (item == "edit") {
      uploadDocDialog(document: document);
    } else if (item == "copyLink") {
      Utils.copyToClipboard(url);
    } else if (item == "view") {
      if (Utils.isImageFile(file)) {
        Get.toNamed(AppRoutes.photoViewScreen, arguments: file);
        return;
      }
      Utils.openUrl(url);
    } else if (item == "download") {
      String extension = file.split('.').last.toLowerCase();
      String fileName = document.documentName.replaceAll(" ", "_");
      Utils.downloadFile(
          url: document.url ?? "", filename: "$fileName.$extension");
    } else {
      deleteDocument(document);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    dateController.dispose();
    docNameEnglishController.dispose();
    nameController.dispose();
    docNameArabicController.dispose();
    documentController.dispose();

    publicDocuments.close();
    selectedAddType.close();
    selectedStatus.close();
    super.onClose();
  }
}
