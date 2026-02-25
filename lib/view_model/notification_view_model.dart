import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/notifications_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class NotificationViewModel extends GetxController with GetTickerProviderStateMixin {

  late final TabController tabController;

  final notifications = <Notifications>[].obs;
  List<Notifications> allNotifications = [];

  late final DateTime dateTime;
  late final User user;

  final repo = NotificationsRepoImpl();
  final mainViewModel = Get.find<MainViewModel>();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.myNotificationsScreen);
    dateTime = DateTime.now();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(_tabListener);
    if (userBox.isNotEmpty) {
      user = userBox.getAt(0);
      fetchNotifications();
    }
  }


  fetchNotifications() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.userNotifications(
        request: RequestBody(endPoint: "${ApiConstant.userNotifications}/${user.empId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allNotifications = apiResponse.data;
      notifications.assignAll(allNotifications);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  Future readNotification(int? id) async {
    String endPoint;
    if (id != null) {
      endPoint = "${ApiConstant.readSingNotification}/$id";
    } else {
      endPoint = "${ApiConstant.readAllNotification}/${user.empId}";
      List<Notifications> unreadNotifications =
          allNotifications.where((data) => data.isMark == false).toList();
      if (unreadNotifications.isEmpty) {
        return;
      }
    }

    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await repo.readNotification(request: RequestBody(endPoint: endPoint));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (id != null) {
        allNotifications.firstWhere((data) => data.id == id).isMark = true;
        notifications.firstWhere((data) => data.id == id).isMark = true;
        mainViewModel.notificationCount.value--;
      } else {
        allNotifications
            .where((n) => !n.isMark)
            .forEach((n) => n.isMark = true);
        notifications
            .where((n) => !n.isMark)
            .forEach((n) => n.isMark = true);
        mainViewModel.notificationCount.value=0;
      }
      _tabListener();
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  deleteAllNotification() async {
    if (allNotifications.isEmpty) {
      return;
    }
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteNotification(
        request: RequestBody(endPoint: "${ApiConstant.deleteAllNotification}/${user.empId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allNotifications.clear();
      notifications.clear();
      notifications.refresh();
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  void _tabListener() {
    if (tabController.index == 0) {
      notifications.value = List.from(allNotifications);
    } else if (tabController.index == 1) {
      notifications.value = allNotifications.where((notification) => notification.isMark).toList();
    } else {
      notifications.value = allNotifications.where((notification) => !notification.isMark).toList();
    }
  }

  @override
  void onClose() {
    tabController.removeListener(_tabListener);
    tabController.dispose();

    notifications.close();
    super.onClose();
  }

}
