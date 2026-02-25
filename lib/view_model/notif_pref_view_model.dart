import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/notification_preference.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/individual_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class NotificationPreferenceViewModel extends GetxController {

  final repo = IndividualRepoImpl();

  late User user;
  late NotificationPreferences notificationPreferences;


  RxList<NotificationPreference> preferences = <NotificationPreference>[
    NotificationPreference(
        title: "emailNotifications",
        subTitle: "emailNotificationsDetails",
        enable: false),
    NotificationPreference(
        title: "messageNotifications",
        subTitle: "messageNotificationsDetails",
        enable: false),
    NotificationPreference(
        title: "mobileAppNotifications",
        subTitle: "mobileAppNotificationsDetails",
        enable: false),
  ].obs;


  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.notificationsPreferencesScreen);
    user = userBox.getAt(0);
    fetchNotificationPreferences();
  }

  Future fetchNotificationPreferences() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.notificationPreferences(request: RequestBody(endPoint: "${ApiConstant.notificationPreferences}/${user.empId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      notificationPreferences = apiResponse.data;
      _updatePreferences();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _updatePreferences() {
    preferences[0].enable = notificationPreferences.isEmailNotification;
    preferences[1].enable = notificationPreferences.isSmsNotification;
    preferences[2].enable = notificationPreferences.isInAppNotification;
    preferences.refresh();
  }

  savePreferences(int index, bool val) async {
    try {
      Utils.showLoadingDialog();
      if (index == 0) {
        notificationPreferences.isEmailNotification = val;
      } else if (index == 1) {
        notificationPreferences.isSmsNotification = val;
      } else {
        notificationPreferences.isInAppNotification = val;
      }
      ApiResponse apiResponse = await repo.savePreferences(
          request: RequestBody(body: notificationPreferences.toJson()));
      Utils.hideLoadingDialog();
      if (apiResponse.appState == AppState.onSuccess) {
        if (index == 2) {
          val ? Utils.subscribeTopics() : Utils.unSubscribeFromTopics();
        }
        preferences[index].enable = val;
        preferences.refresh();
      } else {
        Utils.handleAPIError(apiResponse);
      }
    } catch (_) {
      Utils.hideLoadingDialog();
    }
  }

  @override
  void onClose() {
    preferences.close();
    super.onClose();
  }

}
