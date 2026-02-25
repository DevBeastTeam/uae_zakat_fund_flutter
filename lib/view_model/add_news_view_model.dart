import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/news_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cms_news_view_model.dart';

class AddNewsViewModel extends GetxController with GenericMixin {
  final scrollController = ScrollController();
  final titleInEnglish = TextEditingController();
  final titleInArabic = TextEditingController();
  final publishDateTime = TextEditingController();
  final authorNameInEnglish = TextEditingController();
  final authorNameInArabic = TextEditingController();
  final firstPic = TextEditingController();
  final secondPic = TextEditingController();
  final thumbnail = TextEditingController();

  final titleInEnglishNode = FocusNode();
  final titleInArabicNode = FocusNode();

  final shortDescEnglishController = HtmlEditorController();
  final shortDescArabicController = HtmlEditorController();
  final descEnglishController = HtmlEditorController();
  final descArabicController = HtmlEditorController();

  final formKey = GlobalKey<FormState>();

  final Rxn<LookupData> selectedCategory = Rxn<LookupData>();
  final RxBool shortDescEnglishEmpty = false.obs;
  final RxBool shortDescArabicEmpty = false.obs;
  final RxBool descEnglishEmpty = false.obs;
  final RxBool descArabicEmpty = false.obs;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late User user;
  News? news;

  final genericRepo = GenericRepoImpl();
  final repo = NewsRepoImpl();
  final newsViewModel = Get.find<CMSNewsViewModel>();

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    news = Get.arguments;
    user = userBox.getAt(0);
    if (news != null) {
      Utils.showLoadingDialog();
      setData();
    }
    Utils.logEvent(
        name: news != null
            ? EventConstant.updateNewsScreen
            : EventConstant.addNewNewsScreen);
  }

  setData() {
    titleInEnglish.text = news!.titleEn;
    titleInArabic.text = news!.titleAr;
    authorNameInEnglish.text = news!.authorNameEN;
    authorNameInArabic.text = news!.authorNameAR;
    firstPic.text = news!.firstPicture;
    secondPic.text = news!.secondPicture;
    thumbnail.text = news!.thumbNail;
    if (news!.newsCategoryId != 0) {
      LookupData category = newsViewModel.categoriesList
          .firstWhere((cat) => cat.value == news!.newsCategoryId);
      selectedCategory.value = category;
    }
    if (news!.publishDate != null) {
      publishDateTime.text = Utils.dateTimeFormat.format(news!.publishDate!);
    }

    Future.delayed(Duration(seconds: 3)).then((_) {
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );
      Utils.hideLoadingDialog();
    });
  }

  addImage(TextEditingController controller) async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      Utils.showLoadingDialog();
      final result = await uploadImage(filePath: image.path);
      Utils.hideLoadingDialog();
      controller.text = result ?? "";
    }
  }

  Future saveNews({bool saveAsDraft = false, bool isPreview = false}) async {
    String descriptionEN = await descEnglishController.getText();
    String descriptionAR = await descArabicController.getText();
    String descriptionShortEN = await shortDescEnglishController.getText();
    String descriptionShortAR = await shortDescArabicController.getText();
    String titleEN = titleInEnglish.text.trim();
    String titleAR = titleInArabic.text.trim();
    String publishTime = publishDateTime.text;
    String? publishDate;
    if (publishTime.isNotEmpty) {
      DateTime parsedDate = Utils.dateTimeFormat.parse(publishTime);
      publishDate = Utils.outputFormat.format(parsedDate.toUtc());
    }
    int? catId;
    if (selectedCategory.value != null) {
      catId = selectedCategory.value!.value;
    }
    if (!saveAsDraft && !isPreview) {
      if (descriptionShortEN.trim().isEmpty) {
        shortDescEnglishEmpty.value = true;
        return;
      } else {
        shortDescEnglishEmpty.value = false;
      }
      if (descriptionShortAR.trim().isEmpty) {
        shortDescArabicEmpty.value = true;
        return;
      } else {
        shortDescArabicEmpty.value = false;
      }
      if (descriptionEN.trim().isEmpty) {
        descEnglishEmpty.value = true;
        return;
      } else {
        descEnglishEmpty.value = false;
      }
      if (descriptionAR.trim().isEmpty) {
        descArabicEmpty.value = true;
        return;
      } else {
        descArabicEmpty.value = false;
      }
      if (!formKey.currentState!.validate()) {
        return;
      }
    } else {
      if (titleEN.isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInEnglishNode);
        return;
      }

      if (titleAR.isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInArabicNode);
        return;
      }
    }
    if (isPreview) {
      _navigateToPreview(
        titleEN,
        titleAR,
        descriptionEN,
        descriptionAR,
        descriptionShortEN,
        descriptionShortAR,
        publishTime.isNotEmpty
            ? Utils.dateTimeFormat.parse(publishDateTime.text)
            : null,
      );
      return;
    }

    Utils.showLoadingDialog();

    var body = {
      if (news != null && news?.requestStatus != 8) "id": news!.id,
      "titleEN": titleEN,
      "titleAR": titleAR,
      if (descriptionEN.trim().isNotEmpty) "descriptionEN": descriptionEN,
      if (descriptionEN.trim().isNotEmpty) "descriptionAR": descriptionAR,
      if (catId != null) "newsCategoryId": catId,
      if (authorNameInEnglish.text.trim().isNotEmpty)
        "authorNameEN": authorNameInEnglish.text,
      if (authorNameInArabic.text.trim().isNotEmpty)
        "authorNameAR": authorNameInArabic.text,
      if (publishDate != null) "publishDate": publishDate,
      if (user.accountId != null) "associationAccountId": user.accountId,
      if (descriptionShortEN.trim().isNotEmpty)
        "descriptionShortEN": descriptionShortEN,
      if (descriptionShortAR.trim().isNotEmpty)
        "descriptionShortAR": descriptionShortAR,
      if (firstPic.text.isNotEmpty) "firstPicture": firstPic.text,
      if (secondPic.text.isNotEmpty) "secondPicture": secondPic.text,
      if (thumbnail.text.isNotEmpty) "thumbNail": thumbnail.text
    };
    Map<String, dynamic>? queryParameters;
    if (saveAsDraft) {
      if (news != null) {
        queryParameters = {
          "draftId": news?.id,
        };
      }
      var draftBody = {
        "userId": user.id,
        "accountId": user.accountId,
        "draftType": user.isAdmin ? 7 : 5,
        "draftJson": jsonEncode(body),
        if (news != null) "draftId": news?.id
      };
      ApiResponse apiResponse = await genericRepo.saveAsDraft(
          request:
              RequestBody(body: draftBody, queryParameters: queryParameters));
      Utils.hideLoadingDialog();
      if (apiResponse.appState == AppState.onSuccess) {
        Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
        if (news != null) {
          newsViewModel.pageSize = newsViewModel.news.length;
        }
        Get.back(result: true);
      } else {
        Utils.handleAPIError(apiResponse);
      }
    } else {
      if (news != null && news?.requestStatus == 8) {
        queryParameters = {
          "draftId": news?.id,
        };

        ApiResponse apiResponse1 = await genericRepo.updateDraft(
            request: RequestBody(queryParameters: queryParameters));
        if (apiResponse1.appState != AppState.onSuccess) {
          Utils.hideLoadingDialog();
          Utils.handleAPIError(apiResponse1);
          return;
        }
      }

      if (news != null) {
        queryParameters = {
          "resubmitForApproval": news?.requestStatus == 7,
        };
      }
      ApiResponse apiResponse = news == null || news?.requestStatus == 8
          ? await repo.saveNews(request: RequestBody(body: body))
          : await repo.updateNews(
              request: RequestBody(
                  body: body,
                  endPoint: "${ApiConstant.updateNews}/${news!.id}",
                  queryParameters: queryParameters));
      Utils.hideLoadingDialog();
      if (apiResponse.appState == AppState.onSuccess) {
        Utils.showGlobalSnackBar(message: apiResponse.data);
        if (news != null) {
          newsViewModel.pageSize = newsViewModel.news.length;
        }
        Get.back(result: true);
      } else {
        Utils.handleAPIError(apiResponse);
      }
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
      String formattedDateTime =
          Utils.formatDateAndTime(selectedDateTime!, time);
      if (Utils.isDateAfter(formattedDateTime)) {
        selectedTime = time;
        publishDateTime.text = formattedDateTime;
      }
    }
  }

  onChangeCategory(LookupData value) => selectedCategory.value = value;

  void _navigateToPreview(
    String titleEN,
    String titleAR,
    String descEN,
    String descAR,
    String shortEN,
    String shortAR,
    DateTime? publishDate,
  ) {
    final previewNews = News(
      id: 0,
      newsId: 0,
      isActive: false,
      titleEn: titleEN,
      descriptionEn: descEN,
      titleAr: titleAR,
      isFavorite: false,
      descriptionAr: descAR,
      firstPicture: firstPic.text,
      secondPicture: secondPic.text,
      thumbNail: thumbnail.text,
      createdDate: DateTime.now(),
      newsCategoryId: 0,
      requestStatus: 1,
      associationId: user.accountId ?? 0,
      rejectNote: "",
      rejectionDocument: "",
      authorNameEN: authorNameInEnglish.text,
      authorNameAR: authorNameInArabic.text,
      descriptionShortEN: shortEN,
      descriptionShortAR: shortAR,
      publishDate: publishDate,
    );

    Get.toNamed(AppRoutes.newsDetailScreen, arguments: {
      "preview": true,
      "allNews": false,
      "news": previewNews,
      "id": null
    });
  }

  String getTitle() => news != null ? "editNews" : "newsDetails";

  @override
  void onClose() {
    scrollController.dispose();

    titleInEnglish.dispose();
    titleInArabic.dispose();
    publishDateTime.dispose();
    authorNameInEnglish.dispose();
    authorNameInArabic.dispose();
    firstPic.dispose();
    secondPic.dispose();
    thumbnail.dispose();

    titleInEnglishNode.dispose();
    titleInArabicNode.dispose();

    selectedCategory.close();
    shortDescEnglishEmpty.close();
    shortDescArabicEmpty.close();
    descEnglishEmpty.close();
    descArabicEmpty.close();

    super.onClose();
  }
}
