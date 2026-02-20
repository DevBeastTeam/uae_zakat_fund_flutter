import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/cash_notes.dart';
import 'package:zakat_fund/model/project_data.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/task_details.dart';
import 'package:zakat_fund/model/task_receipt.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/tasks_repo.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/collection_receipt_dialog.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class AddCashViewModel extends GetxController with GenericMixin {
  final formKey = GlobalKey<FormState>();
  final updateDonationFormKey = GlobalKey<FormState>();

  final noOfNotes = TextEditingController();
  final noOfNotesNode = FocusNode();

  final taskRepo = TaskRepoImpl();
  final genericRepo = GenericRepoImpl();

  final RxList<File> imagesList = <File>[].obs;
  final RxList<CashNotes> cashNotes = <CashNotes>[].obs;
  final RxList<ProjectData> selectedProjects = <ProjectData>[].obs;

  final RxBool isFullRefund = false.obs;
  final RxBool showMismatchError = false.obs;
  final RxInt totalDonationAmount = 0.obs;
  final Rxn<String> selectedProject = Rxn<String>();

  bool isCash = false;
  late int taskId;
  late TaskDetails taskDetails;
  late List<KeyboardActionsItem> keyboardActionsItem;

  List<String> images = [];
  List cashData = [];
  List<String> projects = [];
  List<Detail> allProjects = [];

  final List<int> amountList = [1, 5, 10, 20, 50, 100, 500, 1000];

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    var data = Get.arguments;
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: noOfNotesNode, displayArrows: false),
    ];
    taskDetails = data["details"];
    allProjects = data["projects"];
    taskId = data["taskId"];
    isCash = taskDetails.requestType == "Cash";
    _initCashData();
    projects = allProjects
        .map((project) =>
            Utils.isArabic ? project.projectNameArabic : project.projectName)
        .toList();
  }

  _initCashData() {
    cashData = [
      {"key": "requestId", "value": "$taskId"},
      {
        "key": "requestorName",
        "value": Utils.isArabic
            ? taskDetails.requesterNameAr
            : taskDetails.requesterName
      },
      {
        "key": "requestDate",
        "value": Utils.dateFormat1.format(taskDetails.createdDate)
      },
      {"key": "collectionTime", "value": taskDetails.collectionTime},
      {
        "key": "requestType",
        "value":
            Utils.isArabic ? taskDetails.requestTypeAr : taskDetails.requestType
      },
      {
        "key": "paymentAmount",
        "value": "${taskDetails.totalAmount.toInt()} ${"currency".tr}"
      },
    ];
  }

  addImageFromGallery() async {
    List<XFile> images = await Utils.pickMultipleImages();
    if (images.isNotEmpty) {
      List<File> files = images.map((file) => File(file.path)).toList();
      imagesList.addAll(files);
    }
  }

  addImageFromCamera() async {
    XFile? image = await Utils.imgFromCamera();
    if (image != null) {
      imagesList.add(File(image.path));
    }
  }

  mediaDialog() {
    Get.dialog(Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "uploadImage".tr,
                  maxLines: 1,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                ),
                GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.highlight_remove_outlined,
                      color: AppColors.secondaryPrimaryBlackColor,
                    ))
              ],
            ),
            16.verticalSpace,
            ListTile(
                leading: SvgPicture.asset(AppResources.galleryIcon),
                title: Text(
                  "image".tr,
                  style: AppTextStyle.secondaryDarkGrey16spTextStyle1,
                ),
                onTap: () {
                  Get.back();
                  addImageFromGallery();
                },
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(vertical: -4)),
            ListTile(
              leading: SvgPicture.asset(AppResources.camerasIcon),
              title: Text("camera".tr,
                  style: AppTextStyle.secondaryDarkGrey16spTextStyle1),
              onTap: () {
                Get.back();
                addImageFromCamera();
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -4),
            ),
            16.verticalSpace,
            elevatedButton(text: "cancel", onPressed: () => Get.back())
          ],
        ),
      ),
    ));
  }

  int getTotalAmount() =>
      cashNotes.fold(0, (sum, proj) => sum! + proj.totalAmount) ?? 0;

  addCashNotesDialog(int cash) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "addCashNotes".tr,
                        style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.highlight_remove_outlined,
                        color: AppColors.secondaryPrimaryBlackColor,
                        size: 30,
                      )),
                ],
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Chip(
                      label: Text("$cash ${"currency".tr}"),
                      labelStyle: AppTextStyle.btnBackground12spTextStyle,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      backgroundColor: AppColors.lightBtnBackColor,
                      side: BorderSide(color: AppColors.btnBackgroundColor),
                    ),
                    16.verticalSpace,
                    Form(
                      key: formKey,
                      child: KeyboardActions(
                        autoScroll: false,
                        config: Utils.buildConfig(
                            Get.context!, keyboardActionsItem),
                        child: LabelTextField(
                          controller: noOfNotes,
                          label: "enterNotes",
                          hint: "enterNotes",
                          checkValidation: true,
                          focusNode: noOfNotesNode,
                          keyboardType: TextInputType.number,
                          isRequired: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enterNumberOfNotes".tr;
                            }
                            return null;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]'),
                            ),
                            FilteringTextInputFormatter.deny(
                              RegExp(
                                  r'^0+'), //users can't type 0 at 1st position
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    elevatedButton(
                      text: "save",
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        int notes = int.parse(noOfNotes.text);
                        int totalAmount = notes * cash;

                        var existingNote = cashNotes.firstWhere(
                          (note) => note.amount == cash,
                          orElse: () =>
                              CashNotes(notes: 0, amount: 0, totalAmount: 0),
                        );

                        if (existingNote.amount != 0) {
                          existingNote.notes = notes;
                          existingNote.totalAmount = totalAmount;
                        } else {
                          cashNotes.add(CashNotes(
                              notes: notes,
                              amount: cash,
                              totalAmount: totalAmount));
                        }
                        cashNotes.refresh();
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    )).then((_) {
      Future.delayed(Duration(seconds: 1)).then((_) {
        noOfNotes.clear();
      });
    });
  }

  Future uploadPicture() async {
    if (isCash && cashNotes.isEmpty) {
      Utils.showGlobalSnackBar(message: "pleaseAddCashNotes".tr);
      return;
    }

    if (imagesList.isEmpty) {
      Utils.showGlobalSnackBar(message: "pleaseUploadImage".tr);
      return;
    }
    if (isCash && getTotalAmount() != taskDetails.totalAmount) {
      updateDonationsDialog();
      return;
    }
    sendForAuth();
  }

  sendForAuth() async {
    Utils.showLoadingDialog();
    for (int i = 0; i < imagesList.length; i++) {
      final file = imagesList[i];
      final result = await uploadImage(filePath: file.path);
      if (result != null) {
        images.add(result);
        if (i == imagesList.length - 1) {
          await taskCollection();
        }
      } else {
        Utils.hideLoadingDialog();
        break;
      }
    }
  }

  taskCollection() async {
    bool isAmountUpdated =
        isCash && getTotalAmount() != taskDetails.totalAmount;
    List<ProjectData> projectAmountDetails = selectedProjects
        .map((project) => ProjectData(
            projectId: project.projectId,
            amount: int.parse(project.controller!.text)))
        .toList();
    var body = {
      "taskId": taskId,
      if (isCash) "details": jsonEncode(_mapCashNotes()),
      "imagePath": images.join(", "),
      "isAmountUpdated": isAmountUpdated,
      if (isAmountUpdated)
        "projectAmountDetails":
            projectAmountDetails.map((e) => e.cashCollectionToJson()).toList()
    };
    ApiResponse apiResponse =
        await taskRepo.taskCollection(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      _showReceipt(isAmountUpdated);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _showReceipt(bool isAmountUpdated) {
    int amount = 0;
    if (isCash && isAmountUpdated) {
      final updatedValue = "${getTotalAmount()} ${"currency".tr}";
      final paymentItem = cashData.firstWhere(
        (item) => item["key"] == "paymentAmount",
        orElse: () => {},
      );

      if (paymentItem.isNotEmpty) {
        paymentItem["value"] = updatedValue;
      }
      amount = getTotalAmount();
    } else {
      amount = taskDetails.totalAmount.toInt();
    }

    TaskReceipt details = TaskReceipt(
        paymentType: isCash
            ? "Cash Payment Receipt / إيصال الدفع النقدي "
            : "Cheque Payment Receipt / إيصال دفع الشيك",
        donorName:
            "${taskDetails.requesterName} / ${taskDetails.requesterNameAr}",
        address: taskDetails.collectionPoint,
        requestId: taskDetails.id.toString(),
        date: Utils.dateFormat1.format(taskDetails.collectionDate),
        collectionTime: taskDetails.collectionTime,
        amount: amount.toString());
    receiptDialog(
        isCash: isCash,
        imagesList: images,
        cashData: cashData,
        details: details,
        cashNotes: cashNotes,
        totalAmount: amount);
  }

  List<Map<String, dynamic>> _mapCashNotes() {
    return cashNotes
        .map((note) => {
              "notes": note.notes,
              "amount": note.amount,
              "totalAmount": note.totalAmount,
            })
        .toList();
  }

  updateDonationsDialog() {
    selectedProjects.value = allProjects
        .map((project) => ProjectData(
            name: Utils.isArabic
                ? project.projectNameArabic
                : project.projectName,
            projectId: project.projectId,
            focusNode: FocusNode(),
            controller:
                TextEditingController(text: project.amount.toInt().toString()),
            amount: project.amount.toInt()))
        .toList();
    String name = Utils.isArabic
        ? allProjects[0].projectNameArabic
        : allProjects[0].projectName;
    selectedProject.value = name;
    _calculateDonationAmount();
    int amount = 0;
    bool additionalAmount = false;
    if (getTotalAmount() > taskDetails.totalAmount) {
      amount = (getTotalAmount() - taskDetails.totalAmount).toInt();
      additionalAmount = true;
    } else {
      amount = getTotalAmount();
    }
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Form(
            key: updateDonationFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildBottomSheetHeader(
                    text: additionalAmount
                        ? "allocateAdditionalDonation".tr
                        : "confirmDonationAdjustment".tr),
                8.verticalSpace,
                additionalAmount
                    ? RichText(
                        text: TextSpan(
                            text: "extraDonationAmount".tr,
                            style: AppTextStyle
                                .secondaryPrimaryBlack14spTextStyle
                                .copyWith(fontFamily: 'Alexandria'),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " $amount ${"currency".tr} ",
                                  style: AppTextStyle.lightBrown14spTextStyle6
                                      .copyWith(fontFamily: 'Alexandria')),
                              TextSpan(
                                text: "allocateExtraAmount".tr,
                                style: AppTextStyle
                                    .secondaryPrimaryBlack14spTextStyle
                                    .copyWith(fontFamily: 'Alexandria'),
                              ),
                            ]),
                      )
                    : RichText(
                        text: TextSpan(
                            text: "cashCollectionUpdatedByAgent".tr,
                            style: AppTextStyle
                                .secondaryPrimaryBlack14spTextStyle
                                .copyWith(fontFamily: 'Alexandria'),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      " ${taskDetails.totalAmount.toInt()} ${"currency".tr}",
                                  style: AppTextStyle.lightBrown14spTextStyle6
                                      .copyWith(fontFamily: 'Alexandria')),
                              TextSpan(
                                text: "youDonating".tr,
                                style: AppTextStyle
                                    .secondaryPrimaryBlack14spTextStyle
                                    .copyWith(fontFamily: 'Alexandria'),
                              ),
                              TextSpan(
                                  text: " $amount ${"currency".tr}",
                                  style: AppTextStyle.lightBrown14spTextStyle6
                                      .copyWith(fontFamily: 'Alexandria')),
                              TextSpan(
                                text: "confirmAdjustment".tr,
                                style: AppTextStyle
                                    .secondaryPrimaryBlack14spTextStyle
                                    .copyWith(fontFamily: 'Alexandria'),
                              ),
                            ]),
                      ),
                10.verticalSpace,
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelDropDown(
                          items: projects,
                          selectedValue: selectedProject.value,
                          hint: "chooseAnOption",
                          isRequired: true,
                          onChanged: (value) {
                            selectedProject.value = value;
                            Detail project = allProjects.firstWhere((proj) {
                              String name = Utils.isArabic
                                  ? proj.projectNameArabic
                                  : proj.projectName;
                              return name == selectedProject.value;
                            });
                            ProjectData? projectData =
                                selectedProjects.firstWhereOrNull((element) =>
                                    element.projectId == project.projectId);

                            if (projectData == null) {
                              selectedProjects.add(ProjectData(
                                  name: selectedProject.value,
                                  projectId: project.projectId,
                                  focusNode: FocusNode(),
                                  controller: TextEditingController(
                                      text: project.amount.toInt().toString()),
                                  amount: project.amount.toInt()));

                              _calculateDonationAmount();
                            }
                          },
                          label: 'selectProject',
                        ),
                        8.verticalSpace,
                        Obx(() => Wrap(
                            runSpacing: 8.h,
                            spacing: 8.w,
                            alignment: WrapAlignment.start,
                            children: List.generate(
                                selectedProjects.length,
                                (index) => RawChip(
                                      onDeleted: () {
                                        selectedProjects.removeAt(index);
                                        _calculateDonationAmount();
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      label: Text(
                                        selectedProjects[index].name!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      labelStyle:
                                          AppTextStyle.btnText14spTextStyle1,
                                      deleteIcon: const Icon(
                                          CupertinoIcons.clear_circled),
                                      deleteIconColor: AppColors.btnTextColor,
                                      side: BorderSide(
                                          color: AppColors.darkBrownColor,
                                          width: 1.w),
                                      backgroundColor:
                                          AppColors.chipBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                    )).toList())),
                        8.verticalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              selectedProjects.length,
                              (index) => KeyboardActions(
                                    autoScroll: false,
                                    config: Utils.buildConfig(Get.context!, [
                                      KeyboardActionsItem(
                                          focusNode: selectedProjects[index]
                                              .focusNode!,
                                          displayArrows: false),
                                    ]),
                                    child: LabelTextField(
                                      controller:
                                          selectedProjects[index].controller!,
                                      focusNode:
                                          selectedProjects[index].focusNode!,
                                      hint: "enterTopUpAmount",
                                      label: 'amountFor'.tr +
                                          selectedProjects[index].name!,
                                      checkValidation: true,
                                      isRequired: true,
                                      onChanged: (_) {
                                        _calculateDonationAmount();
                                      },
                                      validator: (val) {
                                        if (val.toString().trim().isEmpty) {
                                          return "${"amount".tr} ${"isRequired".tr}";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'),
                                        ),
                                        FilteringTextInputFormatter.deny(
                                          RegExp(
                                              r'^0+'), //users can't type 0 at 1st position
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                        ),
                        8.verticalSpace,
                      ],
                    )),
                Text(
                  "summary".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border:
                          Border.all(color: AppColors.secondaryLightGreyColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => buildSummaryRow(
                            "totalAmount",
                            "${"currency".tr} ${totalDonationAmount.value}",
                          )),
                      buildSummaryRow(
                        "totalDonation",
                        "${"currency".tr} ${getTotalAmount()}",
                      ),
                    ],
                  ),
                ),
                Obx(() => showMismatchError.value
                    ? Text(
                        "donationAmountMismatch".tr,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      )
                    : SizedBox.shrink()),
                8.verticalSpace,
                elevatedButton(
                    text: "confirm",
                    onPressed: () {
                      if (!updateDonationFormKey.currentState!.validate()) {
                        return;
                      }
                      if (totalDonationAmount.value != getTotalAmount()) {
                        return;
                      }
                      Get.back();
                      sendForAuth();
                    }),
                8.verticalSpace,
                elevatedButton(
                  text: "cancel",
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: AppColors.lightGreyColor,
                ),
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ));
  }

  _calculateDonationAmount() {
    totalDonationAmount.value = selectedProjects.fold(0, (sum, project) {
          int amount = project.controller!.text.isEmpty
              ? 0
              : int.parse(project.controller!.text);
          return sum! + amount;
        }) ??
        0;
    showMismatchError.value = totalDonationAmount.value != getTotalAmount();
  }

  Row buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.tr, style: AppTextStyle.primaryDarkGrey12spTextStyle1),
        Text(value, style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1),
      ],
    );
  }

  String getTitle() {
    return isCash ? "addCashNotes" : "bankChequeDetails";
  }

  deleteNotes(int index) {
    cashNotes.removeAt(index);
    getTotalAmount();
    cashNotes.refresh();
  }

  editNotes(int index) {
    noOfNotes.text = cashNotes[index].notes.toString();
    addCashNotesDialog(cashNotes[index].amount);
  }

  @override
  void onClose() {
    noOfNotes.dispose();
    noOfNotesNode.dispose();

    imagesList.close();
    cashNotes.close();
    selectedProjects.close();
    isFullRefund.close();
    showMismatchError.close();
    totalDonationAmount.close();
    selectedProject.close();

    super.onClose();
  }
}
