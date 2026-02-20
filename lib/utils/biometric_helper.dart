import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

abstract class BiometricAuthHelper{
   static LocalAuthentication auth = LocalAuthentication();

  static Future<bool> enableDisableBiometric() async {
    bool didAuthenticate = false;
    try{
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle:
            'Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'cancel'.tr,
            goToSettingsButton: "goSettings".tr,
            goToSettingsDescription:
            "goToSettingsDescription".tr,
          ),
        ],
        options: const AuthenticationOptions(),
      );
      return didAuthenticate;
    }on PlatformException catch (_){
      debugPrint("PlatformException Failed");
      return didAuthenticate;
    }
  }

  static Future<List<BiometricType>> checkAvailabilityOfBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics && await auth.isDeviceSupported();
    if (canAuthenticate) {
      availableBiometrics = await auth.getAvailableBiometrics();
    }
    return availableBiometrics;
  }
}