import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class ServiceDetailViewModel extends GetxController {
  final RxList<FaQs> subFaqs = <FaQs>[].obs;
  int preIndex = -1;

  late final OurServices service;

  String? currentLocale;
  bool showPreview = false;

  List<List<String>> imagesList = [];
  List<String> videoList = [];
  List<OurServices> allServices = [];
  List<Map<String, dynamic>> englishLink = [];
  List<Map<String, dynamic>> arabicLink = [];
  List<Map<String, dynamic>> englishText = [];
  List<Map<String, dynamic>> arabicText = [];
  List<Map<String, dynamic>> englishAmount = [];
  List<Map<String, dynamic>> arabicAmount = [];
  List<Map<String, dynamic>> englishButton = [];
  List<Map<String, dynamic>> arabicButton = [];

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.serviceDetailsScreen);
    if(currentLocale!=null){
      currentLocale = Get.locale?.languageCode ?? 'en';
    }
    final data = Get.arguments;
    service = data["service"];
    allServices = data["allServices"];
    showPreview = data["showPreview"] ?? false;
    subFaqs.value = service.faqs;
    // _decodeImages(service.serviceUploadImage);
    // _decodeVideos(service.serviceCustomUrl);

    englishText = _decodeJsonList(service.serviceCustomTextEn);
    arabicText = _decodeJsonList(service.serviceCustomTextAr);

    englishLink = _decodeJsonList(service.serviceCustomLinkEn);
    arabicLink = _decodeJsonList(service.serviceCustomLinkAr);

    englishAmount = _decodeJsonList(service.serviceCustomAmountEn);
    arabicAmount = _decodeJsonList(service.serviceCustomAmountAr);

    englishButton = _decodeJsonList(service.serviceCustomButtonEn);
    arabicButton = _decodeJsonList(service.serviceCustomButtonAr);
  }


  Future<bool> onWillPop() async {
    if (showPreview) {
      Get.updateLocale(Locale(currentLocale!));
    }
    Get.back();
    return false;
  }


  void expansionCallback(int index, bool isExpanded) {
    if (preIndex != -1) {
      subFaqs[preIndex].isExpanded = false;
    }
    preIndex = index;
    subFaqs[index].isExpanded = isExpanded;
    subFaqs.refresh();
  }

  void startService(String serviceUrl) {
    final url = serviceUrl.contains("http") ? serviceUrl : "http://$serviceUrl";
    Get.toNamed(AppRoutes.webViewScreen, arguments: {
      "title": "startService".tr,
      "url": url,
    });
  }


  void _decodeImages(String jsonString) {
    if (jsonString.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonString);
        imagesList = List<List<String>>.from(decoded.map((e) => List<String>.from(e)));
      } catch (e) {
        imagesList = [];
      }
    }
  }

  void _decodeVideos(String jsonString) {
    if (jsonString.isNotEmpty) {
      try {
        videoList = List<String>.from(jsonDecode(jsonString));
      } catch (e) {
        videoList = [];
      }
    }
  }

  List<Map<String, dynamic>> _decodeJsonList(String jsonString) {
    if (jsonString.isNotEmpty) {
      try {
        return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  @override
  void onClose() {
    subFaqs.close();
    super.onClose();
  }

}

