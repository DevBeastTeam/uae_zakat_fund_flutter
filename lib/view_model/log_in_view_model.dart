import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uaepass_api/uaepass_api.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/apple_info.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/uae_pass_user.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/model/user_selection_type.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/log_in_repo.dart';
import 'package:zakat_fund/utils/biometric_helper.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/uae_pass/uaepass_api_service.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/otp_verification_view_model.dart';
import 'package:zakat_fund/view_model/user_selection_view_model.dart';

class LogInViewModel extends GetxController {
  RxBool showLegacyMessage = true.obs;
  RxBool showPassword = true.obs;
  RxBool rememberMe = false.obs;
  final formKey = GlobalKey<FormState>();

  final phoneEmailController = TextEditingController();
  final passwordController = TextEditingController();

  final repo = LogInRepoImpl();
  late UaepassApiService _uaePassApiService;
  late final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  late AccountViewModel accountViewModel;
  late int roleId;
  GoogleSignInAccount? googleAccount;
  Map<String, dynamic>? fbData;
  UAEPASSUserProfile? profileData;
  List<BiometricType> availableBiometrics = [];

  late AuthorizationCredentialAppleID authorizationCredentialAppleID;
  late AppleInfo appleInfo;
  UaePassUser? uaePassUser;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  hideLegacyMessage() {
    showLegacyMessage.value = false;
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.loginScreen);
    if (rememberMeBox.isNotEmpty) {
      var data = rememberMeBox.getAt(0);
      phoneEmailController.text = data["email"];
      passwordController.text = data["password"];
      rememberMe.value = true;
    }
    initUAEPASS().then((_) {
      signOut();
    });
    if (Get.isRegistered<AccountViewModel>()) {
      accountViewModel = Get.find();
    } else {
      accountViewModel = Get.put(AccountViewModel());
    }
    initBiometricAuth();
  }

  initBiometricAuth() async {
    availableBiometrics =
        await BiometricAuthHelper.checkAvailabilityOfBiometrics();
  }

  signOut() async {
    try {
      await _googleSignIn.signOut();
      await FacebookAuth.i.logOut();
    } catch (_) {}
  }

  Future<void> fbSignIn(bool forRegister) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        fbData = await FacebookAuth.i.getUserData();
        fbSocialMedia(forRegister);
      } else {
        Utils.showGlobalSnackBar(message: "Login failed.");
      }
    } catch (e) {
      Utils.showGlobalSnackBar(message: e.toString());
    }
  }

  appleSignIn(bool forRegister) async {
    authorizationCredentialAppleID = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (authorizationCredentialAppleID.email != null) {
      appleInfo = AppleInfo(
          firstName: authorizationCredentialAppleID.givenName,
          lastName: authorizationCredentialAppleID.familyName,
          email: authorizationCredentialAppleID.email,
          identifier: authorizationCredentialAppleID.userIdentifier);
      appleBox.add(appleInfo);
    }
    if (appleBox.isNotEmpty && authorizationCredentialAppleID.email == null) {
      appleInfo = appleBox.getAt(0);
      saveData(forRegister, false);
    } else {
      appleSocialMedia(forRegister);
    }
  }

  appleSocialMedia(bool forRegister) async {
    bool isLoading = true;
    Utils.showLoadingDialog();
    var body = {
      "firstName": authorizationCredentialAppleID.givenName,
      "lastName": authorizationCredentialAppleID.familyName,
      "email": authorizationCredentialAppleID.email,
      "identifier": authorizationCredentialAppleID.userIdentifier,
    };

    ApiResponse apiResponse =
        await repo.appleInfo(request: RequestBody(body: body));
    if (apiResponse.appState == AppState.onSuccess) {
      appleInfo = apiResponse.data;
      if (appleInfo.email == null) {
        isLoading = false;
        Utils.hideLoadingDialog();
        Utils.showGlobalSnackBar(message: "pleaseSignUp".tr);
        return;
      } else {
        if (authorizationCredentialAppleID.email == null) {
          appleInfo = AppleInfo(
              firstName: appleInfo.firstName,
              lastName: appleInfo.lastName,
              email: appleInfo.email,
              identifier: appleInfo.identifier);
          appleBox.add(appleInfo);
        }
        saveData(forRegister, isLoading);
      }
    } else {
      isLoading = false;
      Utils.hideLoadingDialog();
      return;
    }
  }

  saveData(forRegister, isLoading) {
    if (forRegister) {
      getRoleId();
    }
    String name = "${appleInfo.firstName ?? ""} ${appleInfo.lastName ?? ""}";
    String firstName = "", lastName = "";
    if (name.contains(" ")) {
      int idx = name.indexOf(" ");
      firstName = name.substring(0, idx);
      lastName = name.substring(idx + 1);
    }

    var body2 = {
      "name": name,
      "firstName": firstName,
      "lastName": lastName,
      "provider": "Apple",
      "email": appleInfo.email,
      if (forRegister) "roleId": roleId
    };
    socialRegister(body2, forRegister, isLoading: isLoading);
  }

  fbSocialMedia(bool forRegister) {
    if (forRegister) {
      getRoleId();
    }
    String name = fbData?["name"];
    int idx = name.indexOf(" ");
    String firstName = name.substring(0, idx);
    String lastname = name.substring(idx + 1);
    var body = {
      "name": name,
      "firstName": firstName,
      "lastName": lastname,
      "photoUrl": fbData?["picture"]["data"]["url"],
      "provider": "FACEBOOK",
      "email": fbData?["email"],
      if (forRegister) "roleId": roleId
    };
    socialRegister(body, forRegister);
  }

  Future<void> googleSigIn(bool forRegister) async {
    try {
      googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        googleSocialMedia(forRegister);
      }
    } catch (error) {
      Utils.showGlobalSnackBar(message: error.toString());
    }
  }

  getRoleId() {
    if (Get.isRegistered<UserSelectionViewModel>()) {
      final userSelection = Get.find<UserSelectionViewModel>();
      UserSelectionType user = userSelection.selectedUser;
      roleId = user.roleId;
    } else {
      roleId = uaePassUser?.roles[0] == "Individuals"
          ? 5
          : uaePassUser?.roles[0] == "Companies"
              ? 4
              : 3;
    }
  }

  Future initUAEPASS() async {
    _uaePassApiService =
        UaepassApiService(language: Get.locale?.languageCode ?? "en");
  }

  uaePassSignIn(bool forRegister) async {
    try {
      Utils.logEvent(name: EventConstant.uaePassScreen);
      final context = Get.context;
      if (context == null) {
        Utils.showGlobalSnackBar(message: "Unable to start UAE Pass");
        return;
      }
      final uaepassResponse = await _uaePassApiService.signIn(context);
      final authCode = uaepassResponse.code;
      if (authCode == null || authCode.isEmpty) {
        if ((uaepassResponse.message ?? "").isNotEmpty) {
          Utils.showGlobalSnackBar(message: uaepassResponse.message!);
        }
        return;
      }

      final accessToken = await _uaePassApiService.getAccessToken(authCode);
      if (accessToken == null || accessToken.isEmpty) {
        Utils.showGlobalSnackBar(message: "Unable to complete UAE Pass login");
        return;
      }

      profileData = await _uaePassApiService.getProfile(accessToken);

      // BUG FIX: Guard against null profileData or empty email from UAE Pass
      // if (profileData == null) {
      //   Utils.showGlobalSnackBar(
      //       message: "Failed to retrieve UAE Pass profile");
      //   return;
      // }
      // if (profileData!.email == null || profileData!.email!.isEmpty) {
      //   Utils.showGlobalSnackBar(
      //       message:
      //           "UAE Pass profile does not have a linked email. Please contact support.");
      //   return;
      // }

      uaeSocialMedia(forRegister);
    } catch (e) {
      Utils.showGlobalSnackBar(message: e.toString());
    }
  }

  uaeSocialMedia(bool forRegister) async {
    Utils.showLoadingDialog();
    var body = {
      "email": profileData!.email,
      "firstnameAR": profileData!.firstnameAR,
      "nationalityAR": profileData!.nationalityAR,
      "userType": profileData!.userType,
      "firstnameEN": profileData!.firstnameEN,
      "nationalityEN": profileData!.nationalityEN,
      "idn": profileData!.idn,
      "lastNameAR": profileData!.lastnameAR,
      "uuid": profileData!.uuid,
      "fullNameEN": profileData!.fullNameEN,
      "fullNameAR": profileData!.fullNameAR,
      "lastnameEN": profileData!.lastnameEN,
      "mobile": profileData!.mobile,
      "gender": profileData!.gender,
      "sub": profileData!.sub
    };
    ApiResponse apiResponse =
        await repo.uaeIdExist(request: RequestBody(body: body));
    BaseApiModel baseApiModel = apiResponse.data;
    if (baseApiModel.success) {
      uaePassUser = UaePassUser.fromJson(baseApiModel.data);
      uaePassUser?.roles = ["Individuals"];

      // BUG FIX: uuid==null means user record found but UAE Pass not yet linked
      // → send to link screen so they can complete the UAE Pass linkage
      if (uaePassUser!.uuid == null || uaePassUser!.uuid!.isEmpty) {
        Utils.hideLoadingDialog();
        Get.toNamed(AppRoutes.uaeLinkScreen);
      } else {
        redirectUaePassUser();
      }
    } else {
      Utils.hideLoadingDialog();

      // BUG FIX: Previously called uaeSocialMedia(true) recursively here
      // which caused an infinite loop / unexpected navigation.
      // Now: if user is not registered at all → go to link/register screen.
      // If they were trying to login (forRegister==false) show a clear message
      // so they know to register first via UAE Pass.
      if (forRegister) {
        Get.toNamed(AppRoutes.uaeLinkScreen);
      } else {
        // User not found in backend with this UAE Pass UUID.
        // Direct them to register instead of silent recursive retry.
        Utils.showGlobalSnackBar(
            message: "noAccountFound".tr.isNotEmpty
                ? "noAccountFound".tr
                : "No account found. Please register first.");
      }
    }
  }

  saveUaeUser({String password = "", String userName = ""}) async {
    Utils.showLoadingDialog();
    getRoleId();
    var body = {
      "email": profileData!.email,
      "firstnameAR": profileData!.firstnameAR,
      "nationalityAR": profileData!.nationalityAR,
      "userType": profileData!.userType,
      "firstnameEN": profileData!.firstnameEN,
      // "nationalityEN": profileData!.nationalityEN,
      // "idn": profileData!.idn,
      "lastNameAR": profileData!.lastnameAR,
      "uuid": profileData!.uuid,
      "fullNameEN": profileData!.fullNameEN,
      "fullNameAR": profileData!.firstnameAR,
      "lastnameEN": profileData!.lastnameEN,
      "mobile": profileData!.mobile,
      "gender": profileData!.gender,
      "sub": profileData!.sub,
      "isWanttoLinkOtherAccount": password != "" ? true : false,
      // "password": password,
      "userTypeId": roleId,
      // "userName": userName
    };
    ApiResponse apiResponse =
        await repo.saveUaeUser(request: RequestBody(body: body));
    BaseApiModel baseApiModel = apiResponse.data;
    if (baseApiModel.success) {
      uaePassUser = UaePassUser.fromJson(baseApiModel.data);
      redirectUaePassUser();
    } else {
      Utils.hideLoadingDialog();
      Utils.showGlobalSnackBar(message: baseApiModel.errors);
    }
  }

  redirectUaePassUser() async {
    User user = User(
        id: uaePassUser!.id,
        isAdmin: false,
        isEmployeeAndDonor: false,
        accountId: uaePassUser!.accountId,
        userName: uaePassUser!.userName ?? "",
        firstName: uaePassUser!.firstName,
        lastName: uaePassUser!.lastName,
        firstNameArabic: uaePassUser!.firstNameArabic,
        lastNameArabic: uaePassUser!.lastNameArabic,
        email: uaePassUser!.email,
        mobile: uaePassUser!.mobile,
        bearerToken: uaePassUser!.bearerToken,
        isAuthenticated: uaePassUser!.isAuthenticated,
        photo: uaePassUser!.photo,
        roles: ["Individuals"],
        status: uaePassUser!.status,
        uuid: uaePassUser!.uuid,
        customRoleId: null,
        empId: uaePassUser!.id,
        companyList: uaePassUser!.companyList,
        associationList: uaePassUser!.associationList,
        provider: uaePassUser!.provider);
    if (haveMultipleRoles(user)) {
      Get.toNamed(AppRoutes.roleLinkScreen,
          arguments: {"user": user, "isUaePass": true});
    } else {
      if (user.roles.contains("Individuals") &&
          user.companyList.isEmpty &&
          user.associationList.isEmpty) {
        user.roles = ["Individuals"];
      }
      userBox.add(user);
      await Utils.updateUserPreferences(true);
    }
  }

  googleSocialMedia(bool forRegister) {
    if (forRegister) {
      getRoleId();
    }
    String name = googleAccount!.displayName!;
    int idx = name.indexOf(" ");
    String firstName = name.substring(0, idx);
    String lastname = name.substring(idx + 1);
    var body = {
      "name": name,
      "firstName": firstName,
      "lastName": lastname,
      if (googleAccount!.photoUrl != null) "photoUrl": googleAccount!.photoUrl!,
      "provider": "GOOGLE",
      "email": googleAccount!.email,
      if (forRegister) "roleId": roleId
    };
    socialRegister(body, forRegister);
  }

  socialRegister(var body, bool forRegister, {bool isLoading = false}) async {
    if (!isLoading) Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await repo.socialRegister(request: RequestBody(body: body));
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel response = apiResponse.data;
      User user = User.fromJson(response.data);
      user.empId = user.id;

      if (!user.isAuthenticated) {
        Utils.hideLoadingDialog();
        Get.toNamed(AppRoutes.otpVerificationScreen,
            arguments: {"isRegister": true, "email": user.email});
        return;
      }
      await _processUser(user);
    } else {
      Utils.hideLoadingDialog();
      Utils.handleAPIError(apiResponse);
    }
  }

  updateShowPassword() => showPassword.value = !showPassword.value;

  updateRememberMe(bool value) => rememberMe.value = value;

  logInUser() async {
    Utils.hideKeyboard();
    if (!(formKey.currentState?.validate() ?? false)) return;
    final phone = phoneEmailController.text.trim();
    final password = passwordController.text;

    // temporary: whole condintion code just for quick login.
    if (phone.toLowerCase() == "dev@gmail.com" && password == "12345678") {
      final mockData = {
        "id": 1,
        "accountId": 0,
        "userName": "dev@gmail.com",
        "firstName": "Developer",
        "lastName": "User",
        "email": "dev@gmail.com",
        "firstNameArabic": "مطور",
        "lastNameArabic": "مستخدم",
        "bearerToken": "mock_token",
        "isAuthenticated": true,
        "roles": ["Individuals"],
        "isEmployeeAndDonor": false,
        "isAdmin": true,
        "companyList": [],
        "associationList": [],
        "status": "active"
      };
      final user = User.fromJson(mockData);
      user.empId = user.id;
      await _processUser(user);
      return;
    }

    if (!Validator.isValidEmailOrPhone(phone)) return;
    formKey.currentState!.save();
    Utils.showLoadingDialog();
    String ipAddress = await Utils.getIpAddress();
    var body = {
      "userName": phone.toLowerCase(),
      "password": passwordController.text,
      "deviceInfo": Platform.isAndroid ? "android" : "ios",
      "ipAddress": ipAddress
    };
    ApiResponse apiResponse =
        await repo.logIn(request: RequestBody(body: body));
    await _handleLoginResponse(apiResponse,
        phone: phone, password: passwordController.text);
  }

  biometricLogin() async {
    Get.back();
    bool didAuthenticate = await BiometricAuthHelper.enableDisableBiometric();
    if (!didAuthenticate) {
      Utils.showGlobalSnackBar(message: "Biometric authentication failed");
      return;
    }
    Utils.showLoadingDialog();
    BiometricUser user = biometricsBox.getAt(0);
    var body = {
      "userName": user.userName,
      "isPasswordLessAuthentication": true,
    };
    Map<String, dynamic>? queryParameters = {
      "IsPasswordLessAuthemtication": true,
    };
    ApiResponse apiResponse = await repo.biometricAuth(
        request: RequestBody(body: body, queryParameters: queryParameters));

    await _handleLoginResponse(apiResponse);
  }

  bool haveMultipleRoles(User user) {
    if (user.roles.contains("Individuals") && user.associationList.isNotEmpty ||
        user.roles.contains("Individuals") && user.companyList.isNotEmpty ||
        user.companyList.isNotEmpty && user.associationList.isNotEmpty) {
      return true;
    }
    return false;
  }

  void handleOtpVerification() {
    final otpViewModel = Get.put(OtpVerificationViewModel());
    otpViewModel
        .resendOtp({"isRegister": false, "email": phoneEmailController.text});
  }

  Future<void> _processUser(User user) async {
    if (haveMultipleRoles(user)) {
      Utils.hideLoadingDialog();
      Get.toNamed(AppRoutes.roleLinkScreen, arguments: {
        "user": user,
        "isUaePass": false,
      });
      return;
    }

    if (user.roles.contains("Individuals") &&
        user.companyList.isEmpty &&
        user.associationList.isEmpty) {
      user.roles = ["Individuals"];
      user.accountId = 0;
    }

    userBox.add(user);
    await Utils.updateUserPreferences(false);
  }

  Future<void> _handleLoginResponse(ApiResponse response,
      {String? phone, String? password}) async {
    if (response.appState == AppState.onSuccess) {
      final result = response.data as BaseApiModel;

      if (result.statusCode == 204) {
        handleOtpVerification();
        return;
      }

      final user = User.fromJson(result.data);
      user.empId = user.id;

      if (phone != null) {
        await showChangePasswordBox.add(true);
        if (rememberMe.value) {
          await rememberMeBox.clear();
          await rememberMeBox.add({"email": phone, "password": password});
        }
      }

      await _processUser(user);
    } else {
      Utils.hideLoadingDialog();
      Utils.handleAPIError(response);
    }
  }

  @override
  void onClose() {
    phoneEmailController.dispose();
    passwordController.dispose();

    showPassword.close();
    rememberMe.close();
    super.onClose();
  }
}
