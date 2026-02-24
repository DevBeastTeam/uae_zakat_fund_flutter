import 'package:flutter/material.dart';
import 'package:uaepass_api/uaepass/models/uaepass_response_model.dart';
import 'package:uaepass_api/uaepass_api.dart';

class UaepassApiService {
  static const bool _isProduction = false;
  static const String _appScheme = 'uaepassZakatPlatformDS';
  // 👉🏻 stage state
  static const String _clientId = 'zf_mobile_stage';
  static const String _clientSecret = 'gFWkKtbGlADdAwZg';
  static const String _redirectUri =
      'https://oauthtest.com/authorization/return';
  // 👉🏻 production state
  // static const String _clientId = 'fed_zakatfund_mob_prod';
  // static const String _clientSecret = 'PX9nNY42gMbEAnNt';
  // static const String _redirectUri =
  //     'https://www.zakatfund.gov.ae/zfp/web/default.aspx';

  final String language;

  UaepassApiService({required this.language});

  UaePassAPI _buildClient() {
    return UaePassAPI(
      isProduction: _isProduction,
      appScheme: _appScheme,
      clientId: _clientId,
      clientSecrete: _clientSecret,
      redirectUri: _redirectUri,
      language: language,
    );
  }

  Future<UaepassResponseModel> signIn(BuildContext context) async {
    return _buildClient().signIn(context);
  }

  Future<String?> getAccessToken(String code) async {
    return _buildClient().getAccessToken(code);
  }

  Future<UAEPASSUserProfile?> getProfile(String token) async {
    return _buildClient().getUserProfile(token);
  }
}
