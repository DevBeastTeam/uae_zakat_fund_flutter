import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart' as response;
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';

class AdditionalDocWidget extends StatelessWidget {
  final AdditionalDocuments document;

  const AdditionalDocWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final isArabic = Utils.isArabic;
    final documentName =
        isArabic ? document.documentNameAr : document.documentName;
    final showEndDate =
        document.endDate != null && document.endDate!.isNotEmpty;
    final endDate = isArabic ? document.endDateAr! : document.endDate!;
    final startDate = isArabic ? document.startDateAr! : document.startDate!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        LabelTextField(
          label: documentName,
          isRequired: document.isRequired,
          checkValidation: document.isRequired,
          readOnly: true,
          onAddFile: () async {
            PlatformFile? file = await Utils.pickFile(
                allowedExtensions:
                    document.allowedFileTypes.toLowerCase().split(","));
            if (file != null) uploadDoc(file, document);
          },
          controller: document.fileController,
        ),
        6.verticalSpace,
        fileInstructWidget(
            hint: "supportedFormats", formats: document.allowedFileTypes),
        if (document.requiresDate) ...[
          16.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabelTextField(
                  controller: document.startDateController,
                  readOnly: true,
                  isRequired: document.isRequired,
                  checkValidation: document.isRequired,
                  onTap: () => datePickerDialog(document: document),
                  label: startDate,
                  isDate: true,
                ),
              ),
              if (showEndDate) ...[
                8.horizontalSpace,
                Expanded(
                  child: LabelTextField(
                    controller: document.endDateController,
                    readOnly: true,
                    isRequired: document.isRequired,
                    checkValidation: document.isRequired,
                    onTap: () =>
                        datePickerDialog(document: document, isExpiry: true),
                    label: endDate,
                    isDate: true,
                  ),
                )
              ],
            ],
          )
        ],
      ],
    );
  }

  uploadDoc(PlatformFile file, AdditionalDocuments document) async {
    Utils.showLoadingDialog();
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path!,
          filename: Utils.fileName(file.path!)),
    });
    response.ApiResponse apiResponse = await GenericRepoImpl().uploadFile(
        request: RequestBody(formData: formData, isFormDataRequest: true));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel response = apiResponse.data;
      document.fileController.text = response.fileName;
      document.selectedFileName = response.fileName;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  datePickerDialog(
      {bool isExpiry = false, required AdditionalDocuments document}) async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      fieldHintText: "dd/mm/yyyy",
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      context: Get.context!,
      initialDate: dateTime,
      firstDate: DateTime(1950),
      lastDate: DateTime(dateTime.year + 50),
    );
    String date = Utils.dateFormat1.format(picked!);
    String dateF = Utils.dateFormat2.format(picked);
    if (isExpiry) {
      document.endDateController.text = date;
      document.endDateValue = dateF;
    } else {
      document.startDateController.text = date;
      document.startDateValue = dateF;
    }
  }
}
