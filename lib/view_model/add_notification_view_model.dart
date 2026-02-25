import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/notifications_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/notification_management_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class AddNotificationViewModel extends GetxController with GenericMixin {
  final titleInEnglish = TextEditingController();
  final titleInArabic = TextEditingController();
  final publishDateTime = TextEditingController();
  final imageController = TextEditingController();
  final descInEnglish = TextEditingController();
  final descInArabic = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final titleInEnglishNode = FocusNode();
  final titleInArabicNode = FocusNode();
  final descInEnglishNode = FocusNode();
  final descInArabicNode = FocusNode();

  Rxn selectedIcon = Rxn<String>();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Notifications? notification;
  late User user;

  RxList<String> selectedRecipients = <String>[].obs;
  RxList<Categories> recipients = <Categories>[].obs;
  List<String> icons = ["2", "3"];

  final genericRepo = GenericRepoImpl();
  final repo = NotificationsRepoImpl();
  final notificationViewModel = Get.find<NotificationManagementViewModel>();

  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: descInEnglishNode),
      KeyboardActionsItem(focusNode: descInArabicNode),
    ];
    notification = Get.arguments;
    user = userBox.getAt(0);
    recipients.add(Categories(
        name: "android",
        icon: AppResources.androidIcon,
        isOpen: notification != null
            ? notification!.recipients.toLowerCase().contains("android")
            : false));
    recipients.add(Categories(
        name: "ios",
        icon: AppResources.appleIcon,
        isOpen: notification != null
            ? notification!.recipients.toLowerCase().contains("ios")
            : false));
    recipients.add(Categories(
        name: "web",
        icon: AppResources.webIcon,
        isOpen: notification != null
            ? notification!.recipients.toLowerCase().contains("web") ||
                notification!.recipients.toLowerCase().contains("windows")
            : false));
    if (notification != null) {
      setData();
    }
    Utils.logEvent(
        name: notification != null
            ? EventConstant.updateNotificationScreen
            : EventConstant.addNewNotificationScreen);
  }

  setData() {
    for (Categories data in recipients) {
      if (data.isOpen) {
        String type = data.name;
        selectedRecipients.add(type == "web"
            ? "Windows"
            : TranslationService().keys['en']![type]!);
      }
    }

    titleInEnglish.text = notification!.titleEn;
    titleInArabic.text = notification!.titleAr;
    if (notification!.imageName != null) {
      imageController.text = notification!.imageName!;
    }
    if (notification!.publishDate != null) {
      publishDateTime.text =
          Utils.dateTimeFormat.format(notification!.publishDate!);
    }
    selectedIcon.value = notification!.iconName;
    descInEnglish.text = notification!.descriptionEn;
    descInArabic.text = notification!.descriptionAr;
  }

  saveNotification({bool saveAsDraft = false, bool isPreview = false}) async {
    String titleEnglish = titleInEnglish.text.trim();
    String titleArabic = titleInArabic.text.trim();
    if (!saveAsDraft && !isPreview) {
      if (!formKey.currentState!.validate() || selectedRecipients.isEmpty) {
        return;
      }
    } else {
      if (titleEnglish.isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInEnglishNode);
        return;
      }

      if (titleArabic.isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInArabicNode);
        return;
      }
    }
    if (isPreview) {
      showPreview();
      return;
    }
    Utils.showLoadingDialog();
    String? publishDate;
    if (publishDateTime.text.isNotEmpty) {
      DateTime parsedDate = Utils.dateTimeFormat.parse(publishDateTime.text);
      publishDate = Utils.outputFormat.format(parsedDate.toUtc());
    }

    var body = {
      if (notification != null && notification?.requestStatus != 8)
        "id": notification?.id,
      "titleEN": titleEnglish,
      "titleAR": titleArabic,
      "descriptionEN": descInEnglish.text,
      "descriptionAR": descInArabic.text,
      "imageName": imageController.text,
      "iconName": selectedIcon.value,
      "recipients": selectedRecipients.join(","),
      "type": 1,
      "publishDate": publishDate
    };
    if (saveAsDraft) {
      _saveAsDraft(body);
    } else {
      _submitNotification(body);
    }
  }

  _submitNotification(body) async {
    Map<String, dynamic>? queryParameters;
    if (notification != null && notification?.requestStatus == 8) {
      queryParameters = {
        "draftId": notification?.id,
      };
      ApiResponse apiResponse1 = await genericRepo.updateDraft(
          request: RequestBody(queryParameters: queryParameters));
      if (apiResponse1.appState != AppState.onSuccess) {
        Utils.hideLoadingDialog();
        Utils.handleAPIError(apiResponse1);
        return;
      }
    }

    if (notification != null) {
      queryParameters = {
        "resubmitForApproval": notification!.requestStatus == 7,
      };
    }
    ApiResponse apiResponse =
        notification == null || notification?.requestStatus == 8
            ? await repo.saveNotification(request: RequestBody(body: body))
            : await repo.updateNotification(
                request: RequestBody(
                    body: body,
                    endPoint:
                        "${ApiConstant.updateNotification}/${notification!.id}",
                    queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (notification != null) {
        notificationViewModel.pageSize =
            notificationViewModel.notifications.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _saveAsDraft(body) async {
    Map<String, dynamic>? queryParameters;
    if (notification != null) {
      queryParameters = {
        "draftId": notification?.id,
      };
    }
    var draftBody = {
      "userId": user.id,
      "draftType": 12,
      "draftJson": jsonEncode(body),
      if (notification != null) "draftId": notification?.id
    };
    ApiResponse apiResponse = await genericRepo.saveAsDraft(
        request:
            RequestBody(body: draftBody, queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
      if (notification != null) {
        notificationViewModel.pageSize =
            notificationViewModel.notifications.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  showPreview() {
    Notifications notifications = Notifications(
      id: 0,
      userId: user.id,
      isMark: false,
      titleEn: titleInEnglish.text,
      descriptionEn: descInEnglish.text,
      titleAr: titleInArabic.text,
      descriptionAr: descInArabic.text,
      imageName: imageController.text,
      iconName: selectedIcon.value,
      notificationDetail: null,
      createdDate: DateTime.now(),
      date: DateTime.now(),
      requestStatus: 1,
      recipients: "",
    );
    notificationViewModel.notificationDetailsDialog(notifications);
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

  addImage() async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      Utils.showLoadingDialog();
      final result = await uploadImage(filePath: image.path);
      Utils.hideLoadingDialog();
      imageController.text = result ?? "";
    }
  }

  notificationDetailsDialog(Notifications notification) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.highlight_remove_outlined,
                    color: AppColors.secondaryPrimaryBlackColor,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Text(
                Utils.isArabic ? notification.titleAr : notification.titleEn,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
              ),
            ),
            if (notification.imageName != null && notification.imageName != "")
              16.verticalSpace,
            if (notification.imageName != null && notification.imageName != "")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedImage(
                    image: notification.imageName!,
                    width: Get.width,
                    height: 175.h,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
              child: Text(
                Utils.isArabic
                    ? notification.descriptionAr
                    : notification.descriptionEn,
                style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
              ),
            ),
            4.verticalSpace,
          ],
        ),
      ),
    ));
  }

  onChangeRecipients(bool val, Categories data) {
    String value = TranslationService().keys['en']![data.name]!;
    if (val) {
      selectedRecipients.add(value);
    } else {
      selectedRecipients.remove(value);
    }
    data.isOpen = val;
    recipients.refresh();
    selectedRecipients.refresh();
  }

  onChangeIcon(String value) => selectedIcon.value = value;

  String getTitle() =>
      notification != null ? "editNotification" : "notificationDetails";

  @override
  void onClose() {
    titleInEnglish.dispose();
    titleInArabic.dispose();
    publishDateTime.dispose();
    imageController.dispose();
    descInEnglish.dispose();
    descInArabic.dispose();

    titleInEnglishNode.dispose();
    titleInArabicNode.dispose();
    descInEnglishNode.dispose();
    descInArabicNode.dispose();

    selectedIcon.close();
    selectedRecipients.close();
    recipients.close();

    super.onClose();
  }
}
