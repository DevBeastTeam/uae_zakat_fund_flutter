import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart' as http;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlParser;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zakat_fund/data/network/client/dio_client.dart';
import 'package:zakat_fund/data/network/service/firebase_messaging_service.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/moduel_permissions.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

abstract class Utils {
  static ImagePicker imagePicker = ImagePicker();
  static DateFormat dateFormat = DateFormat("dd MMM, yyyy");
  static DateFormat dateFormat1 = DateFormat("dd/MM/yyyy");
  static DateFormat dateFormat2 = DateFormat("dd-MM-yyyy");
  static DateFormat newDateFormat = DateFormat("yyyy-MM-dd");
  static DateFormat dateTimeFormat = DateFormat("dd/MM/yyyy HH:mm");
  static DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static String deviceName = "";
  static const MethodChannel _channel = MethodChannel('ae.gov.awqaf.zakat');
  static DateFormat dateFormatAMPM = DateFormat("dd/MM/yyyy, hh:mm a");

  static bool get isArabic {
    return Get.locale == const Locale("ar");
  }

  static String getCurrency(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);

    return formatter.format(amount);
  }

  static bool isEmpty(String text) {
    return text.trim().isEmpty;
  }

  static scrollToTextField(FocusNode node) {
    final context = node.context;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        alignment: 0.1,
      );
    }
  }

  static bool isWidgetVisible(BuildContext context) {
    final RenderObject? object = context.findRenderObject();
    if (object == null || !object.attached) return false;

    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);

    final ScrollableState scrollableState = Scrollable.of(context);

    final ScrollPosition position = scrollableState.position;
    final RevealedOffset offset = viewport.getOffsetToReveal(object, 0.0);

    final double widgetTop = offset.offset;
    final double widgetBottom = widgetTop + object.paintBounds.height;

    final double visibleStart = position.pixels;
    final double visibleEnd = visibleStart + position.viewportDimension;

    return widgetBottom > visibleStart && widgetTop < visibleEnd;
  }

  static String employeeId(String value) {
    RegExp regExp = RegExp(r'\((\d+)\)');
    Match? match = regExp.firstMatch(value);

    return match!.group(1)!;
  }

  static int statusIntoInt(String status) {
    if (status == "pendingForAcknowledgement") {
      return 9;
    } else if (status == "chequeDepositAcknowledgement") {
      return 10;
    } else if (status == "pendingForCollection") {
      return 4;
    } else if (status == "pendingForConfirmation") {
      return 6;
    } else if (status == "accepted") {
      return 2;
    } else if (status == "completed") {
      return 5;
    } else if (status == "pending") {
      return 1;
    } else if (status == "returned") {
      return 7;
    } else if (status == "drafted") {
      return 8;
    } else {
      return 3;
    }
  }

  static int paymentMethodIntoInt(String status) {
    if (status == "card") {
      return 1;
    } else if (status == "cash") {
      return 2;
    } else if (status == "backCheque") {
      return 3;
    } else if (status == "deposit") {
      return 4;
    } else if (status == "wallet") {
      return 5;
    } else {
      return 0;
    }
  }

  static String getPaymentType(int type) {
    if (type == 1 || type == 6) {
      return "cardPayment";
    } else if (type == 2) {
      return "cash";
    } else if (type == 3) {
      return "bankCheque";
    } else if (type == 4) {
      return "deposit";
    } else if (type == 5) {
      return "wallet";
    } else {
      return "";
    }
  }

  static Color getPaymentMethodColor(int type) {
    if (type == 1 || type == 6) {
      return AppColors.creditColor;
    } else if (type == 2) {
      return AppColors.cashColor;
    } else if (type == 3) {
      return AppColors.chequeColor;
    } else if (type == 4) {
      return AppColors.depositColor;
    } else if (type == 5) {
      return AppColors.walletColor;
    } else {
      return AppColors.darkBlueColor;
    }
  }

  static Color getPaymentMethodColorByName(String type) {
    if (type == "Card") {
      return AppColors.creditColor;
    } else if (type == "Cash") {
      return AppColors.cashColor;
    } else if (type == "Cheque") {
      return AppColors.chequeColor;
    } else if (type == "Deposit") {
      return AppColors.depositColor;
    } else if (type == "Wallet") {
      return AppColors.walletColor;
    } else {
      return AppColors.darkBlueColor;
    }
  }

  static int categoryTypeIntoInt(String type) {
    if (type == "Projects") {
      return 1;
    } else if (type == "Associations") {
      return 2;
    } else if (type == "News") {
      return 3;
    } else if (type == "Services") {
      return 4;
    } else if (type == "Static Pages") {
      return 5;
    } else {
      return -1;
    }
  }

  static String getPaymentIcon(int type) {
    if (type == 1) {
      return AppResources.cardPayIcon;
    } else if (type == 2) {
      return AppResources.cashPayIcon;
    } else if (type == 3) {
      return AppResources.chequePayIcon;
    } else if (type == 4) {
      return AppResources.depositPayIcon;
    } else {
      return AppResources.cardPayIcon;
    }
  }

  static void showGlobalSnackBar(
      {required String message, SnackBarAction? action}) {
    globalKey.currentState!.hideCurrentSnackBar();
    final SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontFamily: "Alexandria"),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      duration: const Duration(seconds: 3),
      action: action,
    );
    globalKey.currentState?.showSnackBar(snackBar);
  }

  static showFrontEndSnackBar(
      {required String message, TextButton? mainButton}) {
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.snackbar(
      '', '',
      titleText: const SizedBox.shrink(), // removes the title widget entirely
      messageText: Text(
        message,
        style: TextStyle(fontFamily: "Alexandria", color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xff372f28),
      borderRadius: 10.r,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
      mainButton: mainButton,
    );
  }

  static Future<XFile?> imgFromGallery() async {
    final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    return image;
  }

  static Future<XFile?> imgFromCamera() async {
    final XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 70);
    return image;
  }

  static Future<XFile?> videoFromGallery() async {
    final XFile? image = await imagePicker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(minutes: 3));
    return image;
  }

  static Future<List<XFile>> pickMultipleImages() async {
    final List<XFile> images =
        await imagePicker.pickMultiImage(imageQuality: 80);
    return images;
  }

  static Future<Uint8List?> fileThumbnail(String path) async {
    final hashedName = md5.convert(utf8.encode(path)).toString();
    final cacheDir = await getTemporaryDirectory();
    final thumbnailPath = '${cacheDir.path}/thumb_$hashedName.jpg';
    final thumbnailFile = File(thumbnailPath);

    if (await thumbnailFile.exists()) {
      return await thumbnailFile.readAsBytes();
    }

    final Uint8List uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100.sw.round(),
      maxHeight: 357.h.round(),
      quality: 100,
    );

    await thumbnailFile.writeAsBytes(uint8list);

    return uint8list;
  }

  static bool isVideo(String url) {
    List<String> images = ["png", "jpg", "jpeg", "png"];
    int idx = url.indexOf(".");
    String extension = url.substring(idx + 1).toLowerCase();
    if (!images.contains(extension)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> urlThumbnail(String url) async {
    final hashedName = md5.convert(utf8.encode(url)).toString();
    final cacheDir = await getTemporaryDirectory();
    final cachedThumbnailPath = '${cacheDir.path}/thumb_$hashedName.webp';

    final cachedThumbnailFile = File(cachedThumbnailPath);

    if (await cachedThumbnailFile.exists()) {
      return cachedThumbnailFile.path;
    }

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: "${FlavorConfig.storageUrl}$url",
      thumbnailPath:
          cachedThumbnailPath, // Save directly to the intended location
      imageFormat: ImageFormat.WEBP,
      maxWidth: Get.width.round(),
      maxHeight: 357,
      quality: 100,
    );

    return thumbnailPath.path;
  }

  static logInAgain() async {
    if (userBox.isNotEmpty &&
        userBox.getAt(0).userName.toLowerCase() == "dev@gmail.com") {
      debugPrint("Bypassing session logout for developer account");
      return;
    }
    showGlobalSnackBar(message: "sessionExpired".tr);
    await userBox.clear();
    await switchAccountBox.clear();
    final accountViewModel = Get.find<AccountViewModel>();
    final mainViewModel = Get.find<MainViewModel>();
    accountViewModel.initAccountTabs();
    accountViewModel.permissions.clear();
    final homeViewModel = Get.find<HomeViewModel>();
    Get.find<CartViewModel>().clearData();
    mainViewModel.currentIndex.value = 0;
    mainViewModel.notificationCount.value = 0;
    showChangePasswordBox.clear();
    Get.until((route) => route.settings.name == AppRoutes.mainScreen);
  }

  static Future<PlatformFile?> pickFile(
      {List<String> allowedExtensions = const ['jpg', 'pdf', 'jpeg', 'png'],
      bool isVideo = false}) async {
    List<String> extensions =
        allowedExtensions.map((format) => format.trim()).toList();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    PlatformFile? file;
    if (result != null) {
      file = result.files.first;
      String fileName = file.name;
      String extension = fileName.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        Utils.showGlobalSnackBar(message: "mediaTypeNotAllowed".tr);
        return null;
      }

      if (!isVideo && file.size > 5000000) {
        Utils.showGlobalSnackBar(message: "maxFileSize".tr);
        file = null;
      }
    }
    return file;
  }

  static Future<List<PlatformFile>> pickMultipleFiles() async {
    List<String> allowedExtensions = [
      'jpg',
      'pdf',
      'jpeg',
      'png',
      'doc',
      'docx',
      'txt'
    ];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: allowedExtensions,
    );
    List<PlatformFile> files = [];
    if (result != null) {
      files = result.files;
      // for (var file in result.files) {
      //   if (file.size > 5000000) {
      //     Utils.showGlobalSnackBar(message: "maxFileSize".tr);
      //     files.add(file);
      //   }
      // }
    }
    return files;
  }

  static String fileName(String filePath) {
    return filePath.split("/").last;
  }

  static showLoadingDialog() {
    Future.microtask(() {
      Get.dialog(
          WillPopScope(
            onWillPop: () => Future.value(false),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: SvgPicture.asset(AppResources.newLogo)),
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false);
    });
  }

  static Future successDialog({String? title, String? message}) async {
    await Get.defaultDialog(
        backgroundColor: Colors.white,
        title: "",
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        content: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppResources.thumbUpIcon),
                10.verticalSpace,
                if (title != null)
                  Text(
                    title.tr,
                    style: AppTextStyle.secondaryBlack14spTextStyle,
                  ),
                if (title != null) 4.verticalSpace,
                Text(
                  message!.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.secondaryBlack14spTextStyle1,
                ),
                16.verticalSpace,
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: themeViewModel.color),
                  child: Text(
                    "ok".tr,
                    style: AppTextStyle.btnText14spTextStyle2,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inSeconds < 5) {
      return 'justNow'.tr;
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${"secondsAgo".tr}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${"minutesAgo".tr}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${"hoursAgo".tr}';
    } else if (dateTime.day == now.day) {
      return "today".tr;
    } else if (dateTime.day == now.day - 1) {
      return 'yesterday'.tr;
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String getDateAgo(DateTime dateTime) {
    DateFormat dateFormat =
        DateFormat("dd MMM, yyyy", Get.locale?.languageCode);
    final now = DateTime.now();
    if (dateTime.day == now.day) {
      return '${"today".tr} ${dateFormat.format(dateTime)}';
    } else if (dateTime.day == now.day - 1) {
      return '${"yesterday".tr} ${dateFormat.format(dateTime)}';
    } else {
      return dateFormat.format(dateTime);
    }
  }

  static Future getDeviceName() async {
    deviceName = await _channel.invokeMethod('getDeviceName');
    debugPrint("Device Name : $deviceName");
  }

  static Future<void> sharePlainText(String text) async {
    try {
      await _channel.invokeMethod('shareText', {'text': text});
    } on PlatformException catch (e) {
      debugPrint("Failed to share text: '${e.message}'.");
    }
  }

  static hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static Color hexToColor(String hexString) {
    if (hexString.isEmpty) {
      return Color(0xff000000);
    }
    String color = hexString.replaceAll("#", "0xff");
    return Color(int.parse(color));
  }

  static String hexFromColor(Color hexString) {
    String color = hexString.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();
    return "#$color";
  }

  static subscribeTopics() async {
    if (mobileAppMessageBox.isEmpty) {
      await FirebaseMessagingService.instance!.subscribeToTopic(
          topic: Platform.isAndroid
              ? AppConstant.androidFirebaseGeneralTopic
              : AppConstant.iosFirebaseGeneralTopic);
      if (Utils.isArabic) {
        await FirebaseMessagingService.instance!.subscribeToTopic(
            topic: Platform.isAndroid
                ? AppConstant.androidFirebaseGeneralTopicAr
                : AppConstant.iosFirebaseGeneralTopicAr);
      } else {
        await FirebaseMessagingService.instance!.subscribeToTopic(
            topic: Platform.isAndroid
                ? AppConstant.androidFirebaseGeneralTopicEn
                : AppConstant.iosFirebaseGeneralTopicEn);
      }
      mobileAppMessageBox.add(true);
    }
  }

  static unSubscribeFromTopics() async {
    if (mobileAppMessageBox.isNotEmpty) {
      await FirebaseMessagingService.instance!.unsubscribeFromTopic(
          topic: Platform.isAndroid
              ? AppConstant.androidFirebaseGeneralTopic
              : AppConstant.iosFirebaseGeneralTopic);
      if (Utils.isArabic) {
        await FirebaseMessagingService.instance!.unsubscribeFromTopic(
            topic: Platform.isAndroid
                ? AppConstant.androidFirebaseGeneralTopicAr
                : AppConstant.iosFirebaseGeneralTopicAr);
      } else {
        await FirebaseMessagingService.instance!.unsubscribeFromTopic(
            topic: Platform.isAndroid
                ? AppConstant.androidFirebaseGeneralTopicEn
                : AppConstant.iosFirebaseGeneralTopicEn);
      }
      mobileAppMessageBox.add(false);
    }
  }

  subscribeToTopic() async {
    if (Utils.isArabic) {
      await FirebaseMessagingService.instance!.subscribeToTopic(
          topic: Platform.isAndroid
              ? AppConstant.androidFirebaseGeneralTopicAr
              : AppConstant.iosFirebaseGeneralTopicAr);
      await FirebaseMessagingService.instance!.unsubscribeFromTopic(
          topic: Platform.isAndroid
              ? AppConstant.androidFirebaseGeneralTopicEn
              : AppConstant.iosFirebaseGeneralTopicEn);
    } else {
      await FirebaseMessagingService.instance!.subscribeToTopic(
          topic: Platform.isAndroid
              ? AppConstant.androidFirebaseGeneralTopicEn
              : AppConstant.iosFirebaseGeneralTopicEn);
      await FirebaseMessagingService.instance!.unsubscribeFromTopic(
          topic: Platform.isAndroid
              ? AppConstant.androidFirebaseGeneralTopicAr
              : AppConstant.iosFirebaseGeneralTopicAr);
    }
  }

  static Future<void> openUrl(String url) async {
    if (!url.contains("http")) {
      url = "http://$url";
    }
    debugPrint(url);
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      showGlobalSnackBar(message: "Can't open this");
    }
  }

  static Color getStatusColor(String status) {
    if (status == "high" ||
        status == "rejected" ||
        status == "returned" ||
        status == "inactive") {
      return AppColors.highBackColor;
    } else if (status == "medium" ||
        status == "pending" ||
        status == "drafted" ||
        status == "collected" ||
        status == "pendingForConfirmation" ||
        status == "pendingForCollection") {
      return AppColors.mediumBackColor;
    } else if (status == "low" ||
        status == "accepted" ||
        status == "completed" ||
        status == "active" ||
        status == "success") {
      return AppColors.lowBackColor;
    } else {
      return Colors.white;
    }
  }

  static String feedbackUserTypeIntoString(int type) {
    if (type == 1) {
      return "guestUser".tr;
    } else {
      return "registeredUser".tr;
    }
  }

  static String footerParentPageIntoString(int type) {
    if (type == 1) {
      return "sahemElzakwi".tr;
    } else if (type == 2) {
      return "help".tr;
    } else if (type == 3) {
      return "support".tr;
    } else if (type == 4) {
      return "otherLinks".tr;
    } else {
      return "";
    }
  }

  static String headerParentPageIntoString(int type) {
    if (type == 1) {
      return "aboutSahem".tr;
    } else if (type == 4) {
      return "mediaCenter".tr;
    } else if (type == 5) {
      return "faq".tr;
    } else if (type == 6) {
      return "contactUs".tr;
    } else {
      return "";
    }
  }

  static String feedbackTypeIntoString(int type) {
    if (type == 1) {
      return "complaint".tr;
    } else if (type == 2) {
      return "suggestion".tr;
    } else {
      return "support".tr;
    }
  }

  static int feedbackTypeIntoInt(String type) {
    if (type == "complaint") {
      return 1;
    } else if (type == "suggestion") {
      return 2;
    } else {
      return 3;
    }
  }

  static String statusIntoString(int type) {
    if (type == 1 || type == 0) {
      return "pending";
    } else if (type == 2) {
      return "accepted";
    } else if (type == 3) {
      return "rejected";
    } else if (type == 4) {
      return "pendingForCollection";
    } else if (type == 5) {
      return "completed";
    } else if (type == 6) {
      return "pendingForConfirmation";
    } else if (type == 7) {
      return "returned";
    } else if (type == 8) {
      return "drafted";
    } else if (type == 9) {
      return "pendingForAcknowledgement";
    } else if (type == 10) {
      return "chequeDepositAcknowledgement";
    } else {
      return "";
    }
  }

  static String slAStatusIntoString(int type) {
    if (type == 1) {
      return "onTrack";
    } else if (type == 2) {
      return "breached";
    } else if (type == 3) {
      return "nearingDeadline";
    } else {
      return "";
    }
  }

  static String taskStatusIntoString(int type) {
    if (type == 1 || type == 0) {
      return "pending";
    } else if (type == 2) {
      return "inProgress";
    } else if (type == 3) {
      return "completed";
    } else if (type == 4) {
      return "rejected";
    } else if (type == 5) {
      return "pendingForCollection";
    } else if (type == 6) {
      return "pendingForConfirmation";
    } else if (type == 7) {
      return "returned";
    } else {
      return "";
    }
  }

  static String employeeStatusIntoString(int type) {
    if (type == 0) {
      return "pending";
    } else if (type == 1) {
      return "accepted";
    } else if (type == 2) {
      return "rejected";
    } else if (type == 3) {
      return "pending";
    } else {
      return "";
    }
  }

  static String entityTypesIntoString(int type) {
    if (type == 1) {
      return "association";
    } else if (type == 2) {
      return "company";
    } else if (type == 3) {
      return "project";
    } else if (type == 4) {
      return "user";
    } else if (type == 5) {
      return "campaign";
    } else {
      return "";
    }
  }

  // "equalTo",
  // "notEqualTo",
  // "lessThan",
  // "biggerThan",
  // "lessThanEqualTo",
  // "greaterThanEqualTo",
  // "contains",
  // "notContains",

  static String operatorIntoString(String operator) {
    if (operator == "1") {
      return "equalTo";
    } else if (operator == "2") {
      return "notEqualTo";
    } else if (operator == "3") {
      return "lessThan";
    } else if (operator == "4") {
      return "biggerThan";
    } else if (operator == "5") {
      return "lessThanEqualTo";
    } else if (operator == "6") {
      return "greaterThanEqualTo";
    } else if (operator == "7") {
      return "contains";
    } else {
      return "notContains";
    }
  }

  static int operatorIntoInt(String operator) {
    if (operator == "equalTo") {
      return 1;
    } else if (operator == "notEqualTo") {
      return 2;
    } else if (operator == "lessThan") {
      return 3;
    } else if (operator == "biggerThan") {
      return 4;
    } else if (operator == "lessThanEqualTo") {
      return 5;
    } else if (operator == "greaterThanEqualTo") {
      return 6;
    } else if (operator == "contains") {
      return 7;
    } else {
      return 8;
    }
  }

  static int entityTypesIntoInt(String priority) {
    if (priority == "association") {
      return 1;
    } else if (priority == "company") {
      return 2;
    } else if (priority == "project") {
      return 3;
    } else if (priority == "user") {
      return 4;
    } else if (priority == "campaign") {
      return 5;
    } else {
      return -1;
    }
  }

  static int groupsTypesIntoInt(String group) {
    if (group == "association") {
      return 3;
    } else if (group == "company") {
      return 4;
    } else if (group == "donor") {
      return 5;
    } else if (group == "employee") {
      return 6;
    } else if (group == "agent") {
      return 7;
    } else {
      return -1;
    }
  }

  static int notificationMethodIntoInt(String group) {
    if (group == "email") {
      return 1;
    } else if (group == "sms") {
      return 2;
    } else if (group == "mobileAppNotifications") {
      return 3;
    } else {
      return 0;
    }
  }

  static int notificationFrequencyIntoInt(String frequency) {
    if (frequency == "instant") {
      return 1;
    } else if (frequency == "daily") {
      return 2;
    } else {
      return 3;
    }
  }

  static String notificationFrequencyString(int type) {
    if (type == 1) {
      return "instant";
    } else if (type == 2) {
      return "daily";
    }
    {
      return "weekly";
    }
  }

  static String notificationMethodString(int type) {
    if (type == 1) {
      return "email";
    } else if (type == 2) {
      return "sms";
    } else if (type == 3) {
      return "mobileAppNotifications";
    } else {
      return "";
    }
  }

  static String groupsTypesString(String type) {
    if (type == "3") {
      return "association";
    } else if (type == "4") {
      return "company";
    } else if (type == "5") {
      return "donor";
    } else if (type == "6") {
      return "employee";
    } else if (type == "7") {
      return "agent";
    } else {
      return "";
    }
  }

  static String priorityIntoString(int type) {
    if (type == 1) {
      return "low";
    } else if (type == 2) {
      return "medium";
    } else {
      return "high";
    }
  }

  static Future<DateTimeRange?> dateRangePicker(
      DateTimeRange? selectedDateRange,
      DateTimeRange? dateTimeRange,
      DateTime currentDate) async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: selectedDateRange ?? dateTimeRange,
      firstDate: DateTime(1950),
      lastDate: currentDate,
      errorFormatText: "invalidFormat".tr,
      errorInvalidRangeText: "outOfRange".tr,
      errorInvalidText: "invalidDate".tr,
      saveText: "save".tr,
      cancelText: "cancel".tr,
      confirmText: "ok".tr,
      fieldStartLabelText: "startDate".tr,
      fieldEndLabelText: "endDate".tr,
      helpText: "selectStartAndEndDate".tr,
      barrierDismissible: false,
    );
    return newDateRange;
  }

  static int priorityIntoInt(String priority) {
    if (priority == "low") {
      return 1;
    } else if (priority == "medium") {
      return 2;
    } else {
      return 3;
    }
  }

  static Future<void> downloadFile({
    required String url,
    bool isExport = false,
    bool taxCertificate = false,
    String filename = "",
    // required Function(int, int) onProgress,
  }) async {
    Dio dio = DioClient.instance!.dio;
    var status = Platform.isAndroid
        ? await Permission.manageExternalStorage.request()
        : await Permission.storage.request();

    if (status.isGranted) {
      try {
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          debugPrint("$directory");
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/Sahem";
          directory = Directory(newPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (filename == "") {
          filename = url;
        }
        final savePath = '${directory.path}/$filename';
        showLoadingDialog();
        File file = File(savePath);

        if (!await file.exists() || isExport) {
          try {
            String baseUrl = FlavorConfig.baseUrl;
            if (taxCertificate) {
              baseUrl = baseUrl.replaceAll("/api", "");
            }
            http.Response response = await dio.download(
              "${isExport ? baseUrl : FlavorConfig.storageUrl}$url",
              savePath,
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  // onProgress(received, total);
                  debugPrint("$received/$total");
                }
              },
            );
            debugPrint("${response.realUri}");
            showGlobalSnackBar(message: 'downloadedSuccessfully'.tr);
          } on DioException catch (e) {
            if (e.response?.statusCode == 401) {
              Utils.logInAgain();
            }
          }
        } else {
          showGlobalSnackBar(message: 'downloadedSuccessfully'.tr);
        }
        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showGlobalSnackBar(message: 'Error downloading file: $e');
      }
    } else {
      showGlobalSnackBar(message: 'Storage permission denied');
    }
  }

  static String getRemainingTime(DateTime projectEndDate) {
    DateTime currentDate = DateTime.now();

    Duration difference = projectEndDate.difference(currentDate);

    if (difference.isNegative) {
      return "Project has already ended";
    }

    int years = projectEndDate.year - currentDate.year;
    int months = projectEndDate.month - currentDate.month;

    if (months < 0) {
      years--;
      months += 12;
    }

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    String remainingTime = '';

    // if (years > 0) {
    //   remainingTime += '$years y ';
    // }
    // if (months > 0) {
    //   remainingTime += '$months m ';
    // }
    if (days > 0) {
      remainingTime += '${days}d ';
    }
    if (hours > 0) {
      remainingTime += '${hours}h ';
    }
    if (minutes > 0) {
      remainingTime += '${minutes}m';
    }

    return remainingTime.trim();
  }

  static hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showGlobalSnackBar(message: "copied".tr);
  }

  static bool isLink(String path) {
    if (path.contains("http")) {
      return true;
    }
    final validExtensions = [
      'png',
      'jpg',
      'jpeg',
      'pdf',
      'doc',
      'docx',
      'txt',
      "csv",
      "xlsx",
      "xls",
      'mp4',
      'avi',
      'mov',
      'mkv',
      '3gp'
    ];
    final extension = path.split('.').last.toLowerCase();
    return validExtensions.contains(extension);
  }

  static openRejectionScreen(
      {required String title,
      required Requests request,
      bool isRejected = false}) {
    Get.toNamed(AppRoutes.requestRejectScreen, arguments: {
      "title": title,
      "request": request,
      "isRejected": isRejected,
    });
  }

  static String htmlToPlainText(String htmlContent) {
    dom.Document document = htmlParser.parse(htmlContent);
    return document.body?.text ?? "";
  }

  static bool hasPermission(List<String> permissions, String type) {
    return permissions
        .any((permission) => permission.contains(type.toLowerCase()));
  }

  static List<String> modulePermissions(
      ModulePermissions permissions, String code) {
    Module? module = permissions.modules
        .firstWhereOrNull((module) => module.moduleCode == code);
    List<String> permissionsList = module != null
        ? module.modulePermission
            .map((permission) => permission.permissionNameEn.toLowerCase())
            .toList()
        : [];
    return permissionsList;
  }

  static viewLink(String url) {
    if (url.isEmpty) {
      return;
    }
    if (!url.contains("http")) {
      url = "http://$url";
    }
    Get.toNamed(AppRoutes.webViewScreen,
        arguments: {"title": "preview".tr, "url": url});
  }

  static Future<String> getIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var address in interface.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          return address.address;
        }
      }
    }
    return "";
  }

  static Future<Color?> colorPickerDialog() async {
    Color? selectedColor;
    Color pickedColor = AppColors.black;
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('pickColor'.tr),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: pickedColor,
              onColorChanged: (color) {
                pickedColor = color;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: elevatedButton(
                      text: "cancel",
                      backgroundColor: AppColors.lightGreyColor,
                      onPressed: () => Get.back()),
                ),
                16.horizontalSpace,
                Expanded(
                  child: elevatedButton(
                      text: "select",
                      onPressed: () {
                        selectedColor = pickedColor;
                        Get.back();
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
    return selectedColor;
  }

  static handleAPIError(ApiResponse apiResponse) {
    if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      if (userBox.isNotEmpty &&
          userBox.getAt(0).userName.toLowerCase() == "dev@gmail.com") {
        debugPrint("Bypassing 401 logout for developer account");
        return;
      }
      Utils.logInAgain();
    }
  }

  static Future<DateTime?> datePickerDialog({
    required DateTime initialDate,
    required DateTime lastDate,
    required DateTime firstDate,
  }) async {
    final DateTime? selectedDateTime = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      fieldHintText: "dd/mm/yyyy",
      lastDate: lastDate,
    );
    return selectedDateTime;
  }

  static Future<TimeOfDay?> timePickerDialog() async {
    final TimeOfDay? time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      helpText: "selectTime".tr,
      confirmText: "ok".tr,
      cancelText: "cancel".tr,
      hourLabelText: "hour".tr,
      minuteLabelText: "minute".tr,
    );
    return time;
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  static String formatDateAndTime(DateTime date, TimeOfDay time) {
    return "${dateFormat1.format(date)} ${formatTime(time)}";
  }

  static String genderIntToString(int? gender) {
    if (gender == 1) {
      return "male".tr;
    } else if (gender == 2) {
      return "female".tr;
    } else {
      return "";
    }
  }

  static bool isDateAfter(String formattedDateTime) {
    DateTime dateTime = dateTimeFormat.parse(formattedDateTime);
    String currentDateTime = dateTimeFormat.format(DateTime.now());
    DateTime currentDate = dateTimeFormat.parse(currentDateTime);
    bool after = false;
    if (dateTime.isAfter(currentDate) || dateTime.compareTo(currentDate) == 0) {
      after = true;
    }
    if (!after) {
      showGlobalSnackBar(message: "cantSelectPastTime".tr);
    }
    return after;
  }

  static KeyboardActionsConfig buildConfig(
      BuildContext context, List<KeyboardActionsItem>? actions) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: actions,
    );
  }

  static bool containsArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  static logEvent(
      {required String name, Map<String, Object>? parameters}) async {
    User? user;
    if (userBox.isNotEmpty) {
      user = userBox.getAt(0);
    }
    var params = {"type": user != null ? user.roles[0] : "Guest"};
    if (parameters != null) {
      params.addAll(params);
    }
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: params,
    );
  }

  static String toCamelCase(String input) {
    final words = input.split(RegExp(r'\s+'));
    if (words.isEmpty) return '';

    final firstWord = words.first.toLowerCase();
    final capitalizedWords = words.skip(1).map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    });

    return firstWord + capitalizedWords.join();
  }

  static double calculateRation(int value, int total) {
    return total > 0 ? value / total : 0;
  }

  static String formatWithPlus(String value, {int maxLength = 6}) {
    if (value.length > maxLength) {
      return '${value.substring(0, maxLength - 1)}+';
    }
    return value;
  }

  static String formatToIsoWithZeroTime(DateTime inputDate) {
    return '${inputDate.toIso8601String().split('T')[0]}T00:00:00';
  }

  static Future<File?> urlIntoFile(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$fileName';
      final file = File(savePath);

      if (await file.exists()) {
        return file;
      }

      Dio dio = Dio();
      await dio.download(
        "${FlavorConfig.storageUrl}/$url",
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
                'Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      return file;
    } catch (e) {
      return null;
    }
  }

  static bool isImageFile(String path) {
    final imageExtensions = [
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.bmp',
      '.webp',
      '.tiff',
      '.svg'
    ];
    final lowerPath = path.toLowerCase();
    return imageExtensions.any((ext) => lowerPath.endsWith(ext));
  }

  static List<DashboardData> buildChartData(
      List<int> values, int total, List<Color> colors, List<String> titles) {
    final List<DashboardData> chart = [];
    for (var i = 0; i < values.length; i++) {
      if (total > 0 && values[i] > 0) {
        final fraction = Utils.calculateRation(values[i], total);
        if (fraction > 0) {
          chart.add(DashboardData(
            title: titles[i],
            value: '${values[i]}',
            valueInDouble: fraction,
            backColor: colors[i],
          ));
        }
      }
    }
    return chart;
  }

  static ({
    bool canExport,
    bool canEdit,
    bool canView,
    bool canAdd,
    bool canDelete,
    bool canAccept,
    bool canReturn,
    bool canReject
  }) getModulePermissions({
    required dynamic routeArguments,
  }) {
    final accountViewModel = Get.find<AccountViewModel>();
    if (accountViewModel.permissions.isEmpty || routeArguments == null) {
      return (
        canExport: true,
        canEdit: true,
        canView: true,
        canAdd: true,
        canDelete: true,
        canAccept: true,
        canReturn: true,
        canReject: true
      );
    }

    final permission =
        modulePermissions(accountViewModel.permissions[0], routeArguments);
    return (
      canExport: hasPermission(permission, 'export'),
      canEdit: hasPermission(permission, 'update'),
      canView: hasPermission(permission, 'view'),
      canAdd: hasPermission(permission, 'insert'),
      canAccept: hasPermission(permission, 'acceptlo'),
      canReturn: hasPermission(permission, 'return'),
      canReject: hasPermission(permission, 'reject'),
      canDelete: hasPermission(permission, 'delete'),
    );
  }

  static imageCropper(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'cropImage'.tr,
          toolbarColor: themeViewModel.color,
          toolbarWidgetColor: Colors.white,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'cropImage'.tr,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
  }

  static String findLookupName(List<LookupData> list, dynamic id) {
    final match = list
        .firstWhereOrNull((item) => item.value == int.tryParse(id.toString()));
    if (match == null) return '';
    return Utils.isArabic ? (match.nameAr ?? match.name) : match.name;
  }

  static Future updateUserPreferences(bool forRegister,
      {bool multiRole = false}) async {
    await Get.find<HomeViewModel>().addDevice();
    if (cartBox.isNotEmpty) {
      await Get.find<CartViewModel>().updateUserCart();
    }
    await Future.wait([
      Get.find<CartViewModel>().fetchCart(showLoading: false),
      Get.find<MainViewModel>().fetchNotifications()
    ]);
    Utils.hideLoadingDialog();
    Get.until((route) => route.settings.name == AppRoutes.mainScreen);
    Get.find<AccountViewModel>().fetchProfile();
  }
}
