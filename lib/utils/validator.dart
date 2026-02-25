import 'package:get/get.dart';
import 'package:iban/iban.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/utils.dart';

abstract class Validator {
  static RegExp emailReg =
      RegExp(r"^^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static RegExp emirateIdReg = RegExp(r"^784-?[0-9]{4}-?[0-9]{7}-?[0-9]{1}$");
  static RegExp websiteReg = RegExp(
    r'\b((?:https?|ftp):\/\/)?(?:www\.)?((?:[a-zA-Z0-9-]+\.)+[a-zA-Z0-9-]+\.[a-zA-Z]{2,})(:\d+)?(\/[^\s]*)?\b|\b(?:www\.)?((?:[a-zA-Z0-9-]+\.)+[a-zA-Z0-9-]+\.[a-zA-Z]{2,})(:\d+)?(\/[^\s]*)?\b',
  );
  static RegExp phoneReg = RegExp(r"^\+971(5[0-9])\d{7}$");

  static String? validateEmpty(
      {required String? value, required String label}) {
    if (value!.trim().isEmpty) {
      return Utils.isArabic
          ? "${"isRequired".tr} ${label.tr}"
          : "${label.tr} ${"isRequired".tr}";
    }
    return null;
  }

  static String? validateDropDown(
      {required String? value, required String label}) {
    if (value == null) {
      return "${"pleaseSelect".tr} ${label.tr}";
    }
    return null;
  }

  static String? validateDropDown2(
      {required LookupData? value, required String label}) {
    if (value == null) {
      return "${"pleaseSelect".tr} ${label.tr}";
    }
    return null;
  }

  static String? validateEmailOrPhoneEmpty({required String value}) {
    final isPhone = RegExp(r'\d+$').hasMatch(value);

    if (value.trim().isEmpty) {
      return "validEmailOrPhone".tr;
    }
    if (!isPhone && !emailReg.hasMatch(value)) {
      return "validEmailOrPhone".tr;
    }
    if (isPhone && !phoneReg.hasMatch(value)) {
      return "validEmailOrPhone".tr;
    }
    return null;
  }

  static String? validateEmailId({required String value}) {
    if (value.trim().isEmpty) {
      return "${"email".tr} ${"isRequired".tr}";
    } else if (!emailReg.hasMatch(value)) {
      return "invalidEmail".tr;
    }

    return null;
  }

  static String? validateMobile(String phone) {
    if (phone.trim().isEmpty) {
      return "${"mobileNumberPrimary".tr} ${"isRequired".tr}";
    } else if (!phoneReg.hasMatch(phone)) {
      return "inValidMobile".tr;
    }
    return null;
  }

  static String? validatePhoneNumber(String phone) {
    if (phone.trim().isEmpty) {
      return "${"phoneNumber".tr} ${"isRequired".tr}";
    } else if (!phoneReg.hasMatch(phone)) {
      return "inValidMobile".tr;
    }
    return null;
  }

  static String? validatePassword({required String value}) {
    if (value.trim().isEmpty) {
      return "validPassword".tr;
    }
    return null;
  }

  static String? validateConfirmPassword(
      {required String pass1, required String pass2}) {
    if (pass1.trim() != pass2.trim() || pass1.isEmpty) {
      return "validConfirmPassword".tr;
    }
    return null;
  }

  static bool validateEmail(String email) {
    if (emailReg.hasMatch(email)) {
      return true;
    }
    return false;
  }

  static bool validatePhone(String phone) {
    if (phoneReg.hasMatch(phone)) {
      return true;
    }
    return false;
  }

  static bool validateFax(String fax) {
    if (phoneReg.hasMatch(fax)) {
      return true;
    }
    return false;
  }

  static bool validateEmirateId(String emirateId) {
    if (emirateIdReg.hasMatch(emirateId)) {
      return true;
    }
    return false;
  }

  static bool isValidEmailOrPhone(String phone) {
    final isPhone = RegExp(r'\d+$').hasMatch(phone);

    final validInput = isPhone
        ? Validator.validatePhone(phone)
        : Validator.validateEmail(phone);

    if (!validInput) {
      final message = isPhone ? "invalidPhone".tr : "invalidEmail".tr;
      Utils.showGlobalSnackBar(message: message);
    }
    return validInput;
  }

  static bool isLink(String text) {
    return websiteReg.hasMatch(text);
  }

  static bool validateUAEIban(String iban) {
    bool valid = isValid(iban);
    return valid;
  }

  static String? validateIBANNumber(String val){
    if (val.trim().isEmpty) {
      return "${"ibanNumber".tr} ${"isRequired".tr}";
    } else if (!validateUAEIban(val)) {
      return "invalidIBAN".tr;
    }
    return null;
  }

}
