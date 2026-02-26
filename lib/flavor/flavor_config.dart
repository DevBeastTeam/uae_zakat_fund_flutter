import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/uae_pass/uaepass_api_service.dart';

enum Flavor { dev, prod }

abstract class FlavorConfig {
  static late String baseUrl;
  static late String webSiteUrl;
  static late String customerPulseUrl;
  static late String storageUrl;
  static late String appId;
  static late bool isDev;

  static config(Flavor flavor) {
    //   switch (flavor) {
    // case Flavor.dev:
    if (!UaepassApiService.isProduction) {
      baseUrl = ApiConstant.devBaseUrl;
      webSiteUrl = ApiConstant.devWebSiteUrl;
      customerPulseUrl = ApiConstant.devCustomerPulseUrl;
      storageUrl = ApiConstant.devStorageUrl;
      appId = AppConstant.devAppId;
      isDev = true;
    } else {
      baseUrl = ApiConstant.prodBaseUrl;
      webSiteUrl = ApiConstant.prodWebSiteUrl;
      customerPulseUrl = ApiConstant.prodCustomerPulseUrl;
      storageUrl = ApiConstant.prodStorageUrl;
      appId = AppConstant.prodAppId;
      isDev = false;
    }
  }
}
