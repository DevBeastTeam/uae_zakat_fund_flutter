import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zakat_fund/model/notification_preference.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/biometric_helper.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class PasswordSecurityViewModel extends GetxController {
  RxList<NotificationPreference> options = <NotificationPreference>[].obs;

  bool showChangePassword = false;
  BiometricUser? biometricUser;

  late int userId;
  late User user;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.passwordSecurityScreen);
    user = userBox.getAt(0);
    userId = user.empId ?? user.id;
    if (biometricsBox.isNotEmpty) {
      biometricUser = biometricsBox.getAt(0);
      if (userId == biometricUser?.userId) {
        showChangePasswordBox.add(biometricUser!.showChangePassword);
      }
    }
    initBiometricAuth();
  }

  enableDisable(bool val, NotificationPreference preference) async {
    bool didAuthenticate = await BiometricAuthHelper.enableDisableBiometric();
    if (didAuthenticate) {
      preference.enable = val;
      options.refresh();
      if (val) {
        await biometricsBox.clear();
        BiometricUser biometric = BiometricUser(
            userName: user.email,
            type: preference.title,
            userId: userId,
            showChangePassword: showChangePasswordBox.isNotEmpty);
        await biometricsBox.add(biometric);
      } else {
        biometricsBox.clear();
      }
    }
  }

  initBiometricAuth() async {
    List<BiometricType> availableBiometrics =
        await BiometricAuthHelper.checkAvailabilityOfBiometrics();
    if (availableBiometrics.isNotEmpty) {
      bool enable = false;
      if (userId == biometricUser?.userId) {
        enable = true;
      }
      options.value = [
        NotificationPreference(
          title: "biometricAuth",
          subTitle: "",
          enable: enable,
        ),
      ];
    }
  }

  @override
  void onClose() {
    options.close();
    super.onClose();
  }
}
