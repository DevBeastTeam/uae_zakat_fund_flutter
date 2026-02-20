import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/service_new_fields.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/faq_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/services_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cms_services_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class AddServiceViewModel extends GetxController with GenericMixin {
  OurServices? services;
  late User user;

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  final titleInEnglish = TextEditingController();
  final titleInArabic = TextEditingController();
  final publishDateTime = TextEditingController();
  final thumbnail = TextEditingController();
  final fees = TextEditingController();
  final durationInEnglish = TextEditingController();
  final durationInArabic = TextEditingController();
  final supportInEnglish = TextEditingController();
  final supportInArabic = TextEditingController();
  final startService = TextEditingController();

  final titleInEnglishNode = FocusNode();
  final titleInArabicNode = FocusNode();

  int preIndex = -1;
  int preFieldIndex = -1;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Rxn<LookupData> selectedCategory = Rxn<LookupData>();
  Rxn<String> selectedFAQ = Rxn<String>();

  List<FaQs> faq = <FaQs>[];
  final RxList<FaQs> selectedFAQs = <FaQs>[].obs;
  List<String> faqs = [];

  final RxList<Categories> newFields = <Categories>[].obs;
  Categories? selectedNewField;

  final RxList<List<ServiceNewFields>> picturesList =
      <List<ServiceNewFields>>[].obs;
  final RxList<ServiceNewFields> textList = <ServiceNewFields>[].obs;
  final RxList<ServiceNewFields> descList = <ServiceNewFields>[].obs;
  final RxList<ServiceNewFields> videoList = <ServiceNewFields>[].obs;
  final RxList<ServiceNewFields> linkList = <ServiceNewFields>[].obs;
  final RxList<ServiceNewFields> amountList = <ServiceNewFields>[].obs;
  final RxList<ServiceNewFields> buttonList = <ServiceNewFields>[].obs;

  final descEnglishController = HtmlEditorController();
  final descArabicController = HtmlEditorController();
  final procedureEnglishController = HtmlEditorController();
  final procedureArabicController = HtmlEditorController();
  final termsOfUseEnglishController = HtmlEditorController();
  final termsOfUseArabicController = HtmlEditorController();
  final serviceChannelsEnglishController = HtmlEditorController();
  final serviceChannelsArabicController = HtmlEditorController();
  final targetAudienceEnglishController = HtmlEditorController();
  final targetAudienceArabicController = HtmlEditorController();

  final serviceViewModel = Get.find<CMSServicesViewModel>();
  final faqRepo = FaqRepoImpl();
  final genericRepo = GenericRepoImpl();
  final repo = ServicesRepoImpl();

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    user = userBox.getAt(0);
    services = Get.arguments;
    await fetchFaqs();
    if (services != null) {
      setData();
    }
    Utils.logEvent(
        name: services != null
            ? EventConstant.updateServiceScreen
            : EventConstant.addNewServiceScreen);
  }

  setData() {
    try {
      titleInEnglish.text = services!.titleEn;
      titleInArabic.text = services!.titleAr;
      selectedCategory.value = serviceViewModel.categoriesList
          .firstWhereOrNull((cat) => cat.value == services!.serviceCategoryId);

      if (services!.publishDate != null) {
        publishDateTime.text =
            Utils.dateTimeFormat.format(services!.publishDate!);
      }
      fees.text = services!.serviceFee;
      durationInEnglish.text = services!.duration;
      durationInArabic.text = services!.durationAr;
      supportInEnglish.text = services!.supportTitleEn;
      supportInArabic.text = services!.supportTitleAr;
      startService.text = services!.startServiceEN;
      selectedFAQs.value = services!.faqs;

      if (services!.serviceUploadImage?.isNotEmpty) {
        List<dynamic> decodedList = jsonDecode(services!.serviceUploadImage);
        List<List<String>> imagesList =
            decodedList.map((e) => List<String>.from(e)).toList();
        picturesList.value = imagesList
            .map((picture) => picture
                .map((photo) => ServiceNewFields(
                    controller1: TextEditingController(
                        text: photo.toLowerCase().split("attachments/").last)))
                .toList())
            .toList();
      }
      if (services!.serviceCustomUrl?.isNotEmpty) {
        List<String> videoLinks =
            List<String>.from(jsonDecode(services!.serviceCustomUrl));
        videoList.value = videoLinks
            .map((videoURL) => ServiceNewFields(
                controller1: TextEditingController(text: videoURL)))
            .toList();
      }
      if (services!.serviceCustomTextEn.isNotEmpty) {
        List<Map<String, dynamic>> englishText =
            List<Map<String, dynamic>>.from(
                jsonDecode(services!.serviceCustomTextEn));
        List<Map<String, dynamic>> arabicText = [];
        if (services!.serviceCustomLinkAr.isNotEmpty) {
          arabicText = List<Map<String, dynamic>>.from(
              jsonDecode(services!.serviceCustomLinkAr));
        }
        for (int i = 0; i < englishText.length; i++) {
          textList.add(ServiceNewFields(
              controller1: TextEditingController(text: englishText[i]["title"]),
              controller2: TextEditingController(
                  text: arabicText.isEmpty ? "" : arabicText[i]["title"]),
              controller3: TextEditingController(text: englishText[i]["value"]),
              controller4: TextEditingController(
                  text: arabicText.isEmpty ? "" : arabicText[i]["value"])));
        }
      }
      if (services!.serviceCustomLinkEn.isNotEmpty) {
        List<Map<String, dynamic>> englishLink =
            List<Map<String, dynamic>>.from(
                jsonDecode(services!.serviceCustomLinkEn));
        List<Map<String, dynamic>> arabicLink = [];
        if (services!.serviceCustomLinkAr.isNotEmpty) {
          arabicLink = List<Map<String, dynamic>>.from(
              jsonDecode(services!.serviceCustomLinkAr));
        }
        for (int i = 0; i < englishLink.length; i++) {
          linkList.add(ServiceNewFields(
              controller1: TextEditingController(text: englishLink[i]["title"]),
              controller2: TextEditingController(text: arabicLink[i]["title"]),
              controller3:
                  TextEditingController(text: englishLink[i]["value"])));
        }
      }
      if (services!.serviceCustomAmountEn.isNotEmpty) {
        List<Map<String, dynamic>> englishAmount =
            List<Map<String, dynamic>>.from(
                jsonDecode(services!.serviceCustomAmountEn));
        List<Map<String, dynamic>> arabicAmount = [];
        if (services!.serviceCustomAmountAr.isNotEmpty) {
          arabicAmount = List<Map<String, dynamic>>.from(
              jsonDecode(services!.serviceCustomAmountAr));
        }
        for (int i = 0; i < englishAmount.length; i++) {
          amountList.add(ServiceNewFields(
              controller1:
                  TextEditingController(text: englishAmount[i]["title"]),
              controller2:
                  TextEditingController(text: arabicAmount[i]["title"]),
              controller3:
                  TextEditingController(text: englishAmount[i]["value"])));
        }
      }
      if (services!.serviceCustomButtonEn.isNotEmpty) {
        List<Map<String, dynamic>> englishButton =
            List<Map<String, dynamic>>.from(
                jsonDecode(services!.serviceCustomButtonEn));
        List<Map<String, dynamic>> arabicButton = [];
        if (services!.serviceCustomButtonAr.isNotEmpty) {
          arabicButton = List<Map<String, dynamic>>.from(
              jsonDecode(services!.serviceCustomButtonAr));
        }
        for (int i = 0; i < englishButton.length; i++) {
          buttonList.add(ServiceNewFields(
              controller1:
                  TextEditingController(text: englishButton[i]["title"]),
              controller2:
                  TextEditingController(text: arabicButton[i]["title"]),
              controller3:
                  TextEditingController(text: englishButton[i]["value"])));
        }
      }
      scrollAnimation();
    } catch (_) {
      scrollAnimation();
    }
  }

  scrollAnimation() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );
      Utils.hideLoadingDialog();
    });
  }

  Future fetchFaqs() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await faqRepo.fetchFAQs(request: RequestBody());
    if (services == null) Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      faq = apiResponse.data
          .where((project) => project.requestStatus == 2)
          .toList();
      faqs = faq
          .map((question) =>
              Utils.isArabic ? question.questionArabic : question.question)
          .toList();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  inItNewFields() {
    selectedNewField = null;
    newFields.clear();
    preFieldIndex = -1;
    newFields.add(Categories(name: "picture", icon: AppResources.pictureIcon));
    newFields.add(Categories(name: "text", icon: AppResources.textIcon));
    // newFields.add(Categories(name: "description", icon: AppResources.textIcon));
    newFields.add(Categories(name: "video", icon: AppResources.videoIcon));
    newFields.add(Categories(name: "link", icon: AppResources.linkIcon));
    newFields.add(Categories(name: "amount", icon: AppResources.amountIcon));
    newFields.add(Categories(name: "button", icon: AppResources.buttonIcon));
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

  onSelectFAQ(String val) {
    selectedFAQ.value = val;

    FaQs question = faq.firstWhere((question) {
      String q = Utils.isArabic ? question.questionArabic : question.question;
      return q == selectedFAQ.value;
    });
    FaQs? foundFaq =
        selectedFAQs.firstWhereOrNull((faq) => faq.id == question.id);
    if (foundFaq == null) {
      selectedFAQs.add(question);
    }
  }

  newFieldsDialog() {
    inItNewFields();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        content: SizedBox(
          width: Get.size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "addField".tr,
                      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                      textAlign: TextAlign.center,
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
              16.verticalSpace,
              Obx(() => GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                        newFields.length, (index) => _buildOption(index)),
                  )),
              16.verticalSpace,
              elevatedButton(
                  text: "add",
                  onPressed: () {
                    Get.back();
                    if (selectedNewField != null) {
                      if (selectedNewField?.name == "picture") {
                        picturesList.add([ServiceNewFields()]);
                      } else if (selectedNewField?.name == "text") {
                        textList.add(ServiceNewFields());
                      } else if (selectedNewField?.name == "description") {
                        descList.add(ServiceNewFields());
                      } else if (selectedNewField?.name == "video") {
                        videoList.add(ServiceNewFields());
                      } else if (selectedNewField?.name == "link") {
                        linkList.add(ServiceNewFields());
                      } else if (selectedNewField?.name == "amount") {
                        amountList.add(ServiceNewFields());
                      } else if (selectedNewField?.name == "button") {
                        buttonList.add(ServiceNewFields());
                      }
                    }
                  }),
              8.verticalSpace,
              elevatedButton(
                text: "cancel",
                onPressed: () => Get.back(),
                backgroundColor: AppColors.lightGreyColor,
              )
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  Widget _buildOption(int index) {
    return GestureDetector(
      onTap: () {
        if (preFieldIndex == -1) {
          preFieldIndex = index;
          newFields[index].isOpen = true;
        } else {
          newFields[preFieldIndex].isOpen = false;
          preFieldIndex = index;
          newFields[index].isOpen = true;
        }
        newFields.refresh();
        selectedNewField = newFields[index];
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.warningBackColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                color: newFields[index].isOpen
                    ? AppColors.lightBrownColor2
                    : AppColors.warningBackColor)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(newFields[index].icon!),
            4.verticalSpace,
            Text(
              newFields[index].name.tr,
              style: AppTextStyle.lightBrown14spTextStyle5,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  pickImage(TextEditingController controller) async {
    XFile? image =
        await Utils.imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Utils.showLoadingDialog();
      final result = await uploadImage(filePath: image.path);
      Utils.hideLoadingDialog();
      if (result != null) {
        controller.text = result;
        picturesList.refresh();
      }
    }
  }

  addService({bool preview = false, bool saveAsDraft = false}) async {
    try {
      if (!saveAsDraft && !preview) {
        if (!formKey.currentState!.validate()) {
          return;
        }
      } else {
        if (titleInEnglish.text.isEmpty) {
          Utils.showGlobalSnackBar(
              message: "${"titleInEnglish".tr} ${"isRequired".tr}");
          Utils.scrollToTextField(titleInEnglishNode);
          return;
        }

        if (titleInArabic.text.isEmpty) {
          Utils.showGlobalSnackBar(
              message: "${"titleInArabic".tr} ${"isRequired".tr}");
          Utils.scrollToTextField(titleInArabicNode);
          return;
        }
      }
      Utils.showLoadingDialog();
      final imagesList = _mapImagesList();
      final videoLists = _mapVideoList();
      final serviceCustomLinkEn = _mapCustomFields(linkList, 'en');
      final serviceCustomLinkAr = _mapCustomFields(linkList, 'ar');
      final serviceCustomTextEN = _mapCustomFields(textList, 'en');
      final serviceCustomTextAR = _mapCustomFields(textList, 'ar');
      final serviceCustomAmountEn = _mapCustomFields(amountList, 'en');
      final serviceCustomAmountAr =
          _mapCustomFields(amountList, 'ar', includeValue: true);
      final serviceCustomButtonEn = _mapCustomFields(buttonList, 'en');
      final serviceCustomButtonAr = _mapCustomFields(buttonList, 'ar');
      final faqsList =
          selectedFAQs.map((faq) => faq.toJson(check: false)).toList();

      String descriptionEN = await descEnglishController.getText();
      String descriptionAR = await descArabicController.getText();
      String proceduresEN = await procedureEnglishController.getText();
      String procedureAR = await procedureArabicController.getText();
      String termsOfUseEN = await termsOfUseEnglishController.getText();
      String termsOfUseAR = await termsOfUseArabicController.getText();
      String serviceChannelsEN =
          await serviceChannelsEnglishController.getText();
      String serviceChannelsAR =
          await serviceChannelsArabicController.getText();
      String targetAudienceEN = await targetAudienceEnglishController.getText();
      String targetAudienceAR = await targetAudienceArabicController.getText();
      String? publishDate;
      if (publishDateTime.text.isNotEmpty) {
        DateTime parsedDate = Utils.dateTimeFormat.parse(publishDateTime.text);
        publishDate = Utils.outputFormat.format(parsedDate.toUtc());
      }

      int? catId;
      if (selectedCategory.value != null) {
        catId = selectedCategory.value!.value;
      }
      var body = {
        if (services != null && services?.requestStatus != 8)
          "id": services?.id,
        "titleEN": titleInEnglish.text,
        "titleAR": titleInArabic.text,
        "serviceCategoryId": catId,
        "descriptionEN": descriptionEN,
        "descriptionAR": descriptionAR,
        "proceduresEN": proceduresEN,
        "procedureAR": procedureAR,
        "termsOfUseEN": termsOfUseEN,
        "termsOfUseAR": termsOfUseAR,
        "serviceFee": fees.text,
        "duration": durationInEnglish.text,
        "durationAR": durationInArabic.text,
        "serviceChannelsEN": serviceChannelsEN,
        "serviceChannelsAR": serviceChannelsAR,
        "targetAudienceEN": targetAudienceEN,
        "targetAudienceAR": targetAudienceAR,
        "supportTitleEn": supportInEnglish.text,
        "supportTitleAr": supportInArabic.text,
        if (services != null) "support": services?.support,
        "faqs": faqsList,
        "startServiceEN": startService.text,
        "tag": "tag",
        if (imagesList.isNotEmpty) "serviceUploadImage": jsonEncode(imagesList),
        if (serviceCustomTextEN.isNotEmpty)
          "serviceCustomTextEN": jsonEncode(serviceCustomTextEN),
        if (serviceCustomTextAR.isNotEmpty)
          "serviceCustomTextAR": jsonEncode(serviceCustomTextAR),
        if (services != null && services?.serviceCustomDescriptionEn.isNotEmpty)
          "serviceCustomDescriptionEN": services?.serviceCustomDescriptionEn,
        if (services != null && services?.serviceCustomDescriptionAr.isNotEmpty)
          "serviceCustomDescriptionAR": services?.serviceCustomDescriptionAr,
        if (videoLists.isNotEmpty) "serviceCustomUrl": jsonEncode(videoLists),
        if (serviceCustomLinkEn.isNotEmpty)
          "serviceCustomLinkEn": jsonEncode(serviceCustomLinkEn),
        if (serviceCustomLinkAr.isNotEmpty)
          "serviceCustomLinkAr": jsonEncode(serviceCustomLinkAr),
        if (serviceCustomButtonEn.isNotEmpty)
          "serviceCustomButtonEn": jsonEncode(serviceCustomButtonEn),
        if (serviceCustomButtonAr.isNotEmpty)
          "serviceCustomButtonAr": jsonEncode(serviceCustomButtonAr),
        if (serviceCustomAmountEn.isNotEmpty)
          "serviceCustomAmountEn": jsonEncode(serviceCustomAmountEn),
        if (serviceCustomAmountAr.isNotEmpty)
          "serviceCustomAmountAr": jsonEncode(serviceCustomAmountAr),
        "publishDate": publishDate
      };
      if (preview) {
        Utils.hideLoadingDialog();
        OurServices ourServices = OurServices.fromJson(body);
        Get.toNamed(AppRoutes.serviceDetails,
            arguments: {"service": ourServices, "showPreview": true});
        return;
      }
      if (saveAsDraft) {
        _saveAsDraft(body);
      } else {
        _submitService(body);
      }
    } catch (_) {
      Utils.hideLoadingDialog();
    }
  }

  List<List<String>> _mapImagesList() => picturesList
      .map((picture) => picture
          .map((photo) => "${FlavorConfig.storageUrl}${photo.controller1.text}")
          .toList())
      .toList();

  List<String> _mapVideoList() =>
      videoList.map((url) => url.controller1.text).toList();

  List<Map<String, dynamic>> _mapCustomFields(
      List<ServiceNewFields> list, String lang,
      {bool includeValue = false}) {
    return list.map((field) {
      final title =
          lang == 'en' ? field.controller1.text : field.controller2.text;
      final value = lang == 'en'
          ? field.controller3.text
          : includeValue
              ? field.controller4.text
              : "";
      return {
        "title": title,
        "value": value,
        "uuid": Uuid().v4(),
      };
    }).toList();
  }

  _submitService(body) async {
    Map<String, dynamic>? queryParameters;

    if (services != null && services?.requestStatus == 8) {
      queryParameters = {
        "draftId": services?.id,
      };

      ApiResponse apiResponse1 = await genericRepo.updateDraft(
          request: RequestBody(queryParameters: queryParameters));
      if (apiResponse1.appState != AppState.onSuccess) {
        Utils.hideLoadingDialog();
        Utils.handleAPIError(apiResponse1);
        return;
      }
    }

    if (services != null) {
      queryParameters = {
        "resubmitForApproval": services?.requestStatus == 7,
      };
    }

    ApiResponse apiResponse = services == null || services?.requestStatus == 8
        ? await repo.addService(request: RequestBody(body: body))
        : await repo.updateService(
            request: RequestBody(
                body: body,
                endPoint: "${ApiConstant.updateService}/${services!.id}",
                queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      if (services != null) {
        serviceViewModel.pageSize = serviceViewModel.services.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _saveAsDraft(body) async {
    Map<String, dynamic>? queryParameters;
    if (services != null) {
      queryParameters = {
        "draftId": services?.id,
      };
    }
    var draftBody = {
      "userId": user.id,
      "draftType": 13,
      "draftJson": jsonEncode(body),
      if (services != null) "draftId": services?.id
    };
    ApiResponse apiResponse = await genericRepo.saveAsDraft(
        request:
            RequestBody(body: draftBody, queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
      if (services != null) {
        serviceViewModel.pageSize = serviceViewModel.services.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  clearDrawerData() {
    if (descList.isNotEmpty) {
      if (picturesList.isNotEmpty) {
        picturesList.refresh();
      }
      if (textList.isNotEmpty) {
        textList.refresh();
      }
      if (videoList.isNotEmpty) {
        videoList.refresh();
      }
      if (linkList.isNotEmpty) {
        linkList.refresh();
      }
      if (amountList.isNotEmpty) {
        amountList.refresh();
      }
      if (buttonList.isNotEmpty) {
        buttonList.refresh();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();

    titleInEnglish.dispose();
    titleInArabic.dispose();
    publishDateTime.dispose();
    thumbnail.dispose();
    fees.dispose();
    durationInEnglish.dispose();
    durationInArabic.dispose();
    supportInEnglish.dispose();
    supportInArabic.dispose();
    startService.dispose();

    titleInEnglishNode.dispose();
    titleInArabicNode.dispose();

    selectedCategory.close();
    selectedFAQ.close();
    selectedFAQs.close();
    newFields.close();

    picturesList.close();
    textList.close();
    descList.close();
    videoList.close();
    linkList.close();
    amountList.close();
    buttonList.close();

    super.onClose();
  }
}
