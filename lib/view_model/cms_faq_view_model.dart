import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/faq_paginated.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/faq_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class CMSFaqViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final titleInEnglishController = TextEditingController();
  final titleInArabicController = TextEditingController();
  final answerInEnglishController = TextEditingController();
  final answerInArabicController = TextEditingController();
  final publishDateTime = TextEditingController();
  final creationDate = TextEditingController();

  final titleInEnglishNode = FocusNode();
  final titleInArabicNode = FocusNode();
  final answerInEnglishNode = FocusNode();
  final answerInArabicNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final scrollController = ScrollController();

  final selectedStatus = Rxn<String>();
  final selectedCat = Rxn<String>();
  final selectedCategory = Rxn<String>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTimeRange? selectedDateRange;
  late DateTime currentDate;
  late DateTimeRange dateTimeRange;

  int currentPage = 1;
  int pageSize = 10;

  final FaqRepo faqRepo = FaqRepoImpl();
  final GenericRepo genericRepo = GenericRepoImpl();

  late FaqPaginated faqPaginated;
  FaQs? preFAQ;
  List<FaqCategory> categories = [];
  RxList<FaQs> faqs = <FaQs>[].obs;
  List<FaQs> previewFAQs = [];
  List<String> englishCats = [];
  List<String> arabicCats = [];

  late List<KeyboardActionsItem> keyboardActionsItem;

  RxList<StatsData> stats = [
    StatsData(
        title: "total",
        value: "0",
        titleStyle: AppTextStyle.btnBackground12spTextStyle1,
        valueStyle: AppTextStyle.btnBackground16spTextStyle,
        backgroundColor: AppColors.btnBackgroundColor),
    StatsData(
        title: "approved",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: AppColors.darkGreenColor),
    StatsData(
        title: "pending",
        value: "0",
        titleStyle: AppTextStyle.lightBrown12spTextStyle2,
        valueStyle: AppTextStyle.lightBrown16spTextStyle1,
        backgroundColor: AppColors.lightBrownColor1),
    StatsData(
        title: "returned",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor),
    StatsData(
        title: "rejected",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor)
  ].obs;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.cmsFAQsScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: answerInEnglishNode),
      KeyboardActionsItem(focusNode: answerInArabicNode),
    ];

    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    try {
      Utils.showLoadingDialog();
      await fetchFAQCategories();
      if (canView) await fetchFaqs();
    } finally {
      Utils.hideLoadingDialog();
    }
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (faqs.length == faqPaginated.totalRecords) {
        return;
      }
      Utils.showLoadingDialog();
      currentPage++;
      await fetchFaqs();
      Utils.hideLoadingDialog();
    }
  }

  Future fetchFAQCategories() async {
    ApiResponse apiResponse =
        await faqRepo.fetchFAQCategories(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      categories = apiResponse.data;
      englishCats = categories.map((cat) => cat.title).toList();
      arabicCats = categories.map((cat) => cat.titleArabic).toList();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchFaqs({bool clear = false}) async {
    if (clear) {
      Utils.showLoadingDialog();
      currentPage = 1;
    }

    int catId = 0;
    if (selectedCat.value != null) {
      catId = categories.firstWhere((cat) {
        String catName = Utils.isArabic ? cat.titleArabic : cat.title;
        return catName == selectedCat.value;
      }).categoryId;
    }

    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedCat.value != null) "faqCategory": catId,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedDateRange != null) ...{
        "fromDateOfCreation":
            Utils.newDateFormat.format(selectedDateRange!.start),
        "toDateOfCreation": Utils.newDateFormat.format(selectedDateRange!.end)
      },
    };
    ApiResponse apiResponse = await faqRepo.fetchFAQPaginated(
        request: RequestBody(queryParameters: queryParameters));
    if (clear) {
      Utils.hideLoadingDialog();
    }
    if (apiResponse.appState == AppState.onSuccess) {
      faqPaginated = apiResponse.data;
      _updateStats(faqPaginated.stats);
      if (clear) {
        faqs.value = faqPaginated.faqs;
      } else {
        faqs.addAll(faqPaginated.faqs);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _updateStats(FAQStats statsData) {
    stats[0].value = statsData.total.toString();
    stats[1].value = statsData.accepted.toString();
    stats[2].value = statsData.pending.toString();
    stats[3].value = statsData.returned.toString();
    stats[4].value = statsData.rejected.toString();
    stats.refresh();
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
                    items: Utils.isArabic ? arabicCats : englishCats,
                    selectedValue: selectedCat.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedCat.value = value;
                    },
                    label: 'category',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.statusesWithDraft,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                    label: 'status',
                  )),
              16.verticalSpace,
              LabelTextField(
                label: "creationDate",
                onTap: () => dateRangePicker(),
                readOnly: true,
                isDate: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                controller: creationDate,
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearAll(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    fetchFaqs(clear: true);
                  })
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearAll() {
    Get.back();
    searchController.clear();
    creationDate.clear();
    selectedDateRange = null;
    selectedCat.value = null;
    selectedStatus.value = null;
    pageSize = 10;
    fetchFaqs(clear: true);
  }

  Future deleteFAQ(FaQs faq) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await faqRepo.deleteFAQ(
        request: RequestBody(endPoint: "${ApiConstant.deleteFAQ}/${faq.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      faqs.remove(faq);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  showPreview() {
    if (titleInEnglishController.text.trim().isEmpty) {
      Utils.showGlobalSnackBar(
          message: "${"titleInEnglish".tr} ${"isRequired".tr}");
      Utils.scrollToTextField(titleInEnglishNode);
      return;
    }

    if (titleInArabicController.text.trim().isEmpty) {
      Utils.showGlobalSnackBar(
          message: "${"titleInArabic".tr} ${"isRequired".tr}");
      Utils.scrollToTextField(titleInArabicNode);
      return;
    }
    previewFAQs = List.from(faqs);
    int categoryId = 0;
    FaqCategory? cat = categories.firstWhereOrNull((cat) {
      String name = Utils.isArabic ? cat.titleArabic : cat.title;
      return name == selectedCategory.value;
    });
    if (cat != null) {
      categoryId = cat.categoryId;
    }
    FaQs faq = FaQs(
        question: titleInEnglishController.text,
        questionArabic: titleInArabicController.text,
        answer: answerInEnglishController.text,
        answerArabic: answerInArabicController.text,
        isExpanded: true,
        createdDate: DateTime.now(),
        isActive: false,
        id: preFAQ != null ? preFAQ!.id : 0,
        requestStatus: 0,
        categoryId: categoryId);
    if (!Get.arguments) {
      previewFAQs.add(faq);
    } else {
      int index = previewFAQs.indexWhere((model) => model.id == preFAQ?.id);
      previewFAQs[index] = faq;
    }
    Get.toNamed(AppRoutes.faqScreen, arguments: true)?.then((_) {
      previewFAQs.clear();
    });
  }

  Future addFAQ({required bool update, bool saveAsDraft = false}) async {
    if (saveAsDraft) {
      if (titleInEnglishController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInEnglishNode);
        return;
      }

      if (titleInArabicController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInArabicNode);
        return;
      }
    } else {
      if (!formKey.currentState!.validate()) {
        return;
      }
    }
    Utils.showLoadingDialog();
    FaqCategory? category = categories.firstWhereOrNull((cat) {
      String categoryName = Utils.isArabic ? cat.titleArabic : cat.title;
      return categoryName == selectedCategory.value;
    });
    String? publishDate;
    if (publishDateTime.text.isNotEmpty) {
      DateTime parsedDate = Utils.dateTimeFormat.parse(publishDateTime.text);
      publishDate = Utils.outputFormat.format(parsedDate.toUtc());
    }
    var body = {
      if (update && preFAQ?.requestStatus != 8) "id": preFAQ?.id,
      "categoryId": category?.categoryId,
      "question": titleInEnglishController.text,
      "questionArabic": titleInArabicController.text,
      "answer": answerInEnglishController.text,
      "answerArabic": answerInArabicController.text,
      if (publishDate != null) "publishDate": publishDate,
    };

    if (saveAsDraft) {
      _saveAsDraft(body, update);
    } else {
      _submitFAQ(body, update);
    }
  }

  _submitFAQ(body, bool update) async {
    Map<String, dynamic>? queryParameters;
    if (preFAQ != null && preFAQ?.requestStatus == 8) {
      queryParameters = {
        "draftId": preFAQ?.id,
      };

      ApiResponse apiResponse1 = await genericRepo.updateDraft(
          request: RequestBody(queryParameters: queryParameters));
      if (apiResponse1.appState != AppState.onSuccess) {
        Utils.hideLoadingDialog();
        Utils.handleAPIError(apiResponse1);
        return;
      }
    }

    if (preFAQ != null) {
      queryParameters = {
        "resubmitForApproval": preFAQ?.requestStatus == 7,
      };
    }
    ApiResponse apiResponse = preFAQ == null || preFAQ?.requestStatus == 8
        ? await faqRepo.addFAQ(request: RequestBody(body: body))
        : await faqRepo.updateFAQ(
            request: RequestBody(
                body: body,
                endPoint: "${ApiConstant.updateFAQ}/${preFAQ!.id}",
                queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      if (update) {
        pageSize = faqs.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _saveAsDraft(body, bool update) async {
    Map<String, dynamic>? queryParameters;
    if (preFAQ != null) {
      queryParameters = {
        "draftId": preFAQ?.id,
      };
    }
    var draftBody = {
      "userId": user.id,
      "accountId": 0,
      "draftType": 8,
      "draftJson": jsonEncode(body),
      if (preFAQ != null) "draftId": preFAQ?.id
    };
    ApiResponse apiResponse = await genericRepo.saveAsDraft(
        request:
            RequestBody(body: draftBody, queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
      if (update) {
        pageSize = faqs.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  addNewFAQ({FaQs? faq}) {
    preFAQ = faq;
    if (faq != null) {
      setData();
    }
    Utils.logEvent(
        name: faq != null
            ? EventConstant.updateFAQScreen
            : EventConstant.addNewFAQScreen);
    Get.toNamed(AppRoutes.addFaqScreen, arguments: faq != null)
        ?.then((val) async {
      titleInEnglishController.clear();
      titleInArabicController.clear();
      selectedCategory.value = null;
      answerInEnglishController.clear();
      answerInArabicController.clear();
      selectedDate = null;
      selectedTime = null;
      if (val != null && val) {
        if (canView) {
          Utils.showLoadingDialog();
          await fetchFaqs(clear: true);
          Utils.hideLoadingDialog();
        }
      }
    });
  }

  setData() {
    titleInEnglishController.text = preFAQ!.question;
    titleInArabicController.text = preFAQ!.questionArabic;
    answerInEnglishController.text = preFAQ!.answer;
    answerInArabicController.text = preFAQ!.answerArabic;
    FaqCategory? category = categories
        .firstWhereOrNull((cat) => cat.categoryId == preFAQ!.categoryId);
    if (category != null) {
      selectedCategory.value =
          Utils.isArabic ? category.titleArabic : category.title;
    }
    if (preFAQ?.publishDate != null) {
      publishDateTime.text =
          Utils.dateTimeFormat.format(preFAQ!.publishDate!.toLocal());
    }
  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      creationDate.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    } else {
      creationDate.clear();
      selectedDateRange = null;
    }
  }

  dateTimePicker() async {
    final DateTime now = DateTime.now();
    DateTime? selectedDateTime = await Utils.datePickerDialog(
      initialDate: now,
      lastDate: DateTime(now.year + 10),
      firstDate: now,
    );
    selectedDate = selectedDateTime;
    TimeOfDay? time = await Utils.timePickerDialog();
    if (time != null) {
      selectedTime = time;
      publishDateTime.text = Utils.formatDateAndTime(selectedDateTime!, time);
    }
  }

  enableDisable(FaQs faq) async {
    Utils.showLoadingDialog();
    faq.isActive = !faq.isActive;
    var body = {"id": faq.id, "isActive": faq.isActive};
    ApiResponse apiResponse =
        await faqRepo.enableDisableFAQ(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message: faq.isActive
              ? "faqActivatedSuccessfully".tr
              : "faqDeactivatedSuccessfully".tr);
      faqs.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  exportFAQs() {
    Utils.downloadFile(
        url: ApiConstant.exportFAQs, isExport: true, filename: "FAQs.csv");
  }

  onMenuSelected(String item, FaQs faq) {
    if (item == "delete") {
      deleteFAQ(faq);
    } else if (item == "edit") {
      addNewFAQ(faq: faq);
    } else {
      previewFAQs = List.from(faqs);
      Get.toNamed(AppRoutes.faqScreen, arguments: true)?.then((_) {
        previewFAQs.clear();
      });
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    searchController.dispose();
    titleInEnglishController.dispose();
    titleInArabicController.dispose();
    answerInEnglishController.dispose();
    answerInArabicController.dispose();
    publishDateTime.dispose();
    creationDate.dispose();

    titleInEnglishNode.dispose();
    titleInArabicNode.dispose();
    answerInEnglishNode.dispose();
    answerInArabicNode.dispose();
    scrollController.dispose();

    selectedStatus.close();
    selectedCat.close();
    selectedCategory.close();
    faqs.close();
    stats.close();

    super.onClose();
  }
}
