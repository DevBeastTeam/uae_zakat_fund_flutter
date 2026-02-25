import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';

class WebViewModel extends GetxController with GenericMixin {
  late final WebViewController webViewController;

  bool isLoading = true;
  bool isStaticPage = false;

  late String title;
  late String url;
  String? sessionId;
  final List<String> _completionUrls = [
    'success',
    'complete',
    'approved',
    'payment-success',
    'transaction-success',
    'payment-complete',
    'thank-you',
    'confirmation',
    'receipt',
  ];

  final List<String> _failureUrls = [
    'cancel',
    'cancelled',
    'failed',
    'error',
    'payment-failed',
    'transaction-failed',
    'payment-error',
    'declined',
    'rejected',
  ];

  WebViewModel({required this.title, required this.url, this.sessionId});

  @override
  void onInit() {
    super.onInit();
    Utils.showLoadingDialog();

    var data = Get.arguments;
    if (data != null) {
      title = data["title"];
      url = data["url"];
      isStaticPage = data["isStaticPage"] ?? false;
      sessionId = data["sessionId"] ?? "";
    }
    webViewController = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(_buildNavigationDelegate())
      ..loadRequest(Uri.parse(url));
  }

  NavigationDelegate _buildNavigationDelegate() {
    return NavigationDelegate(
        onProgress: (progress) => debugPrint("Loading progress: $progress"),
        onPageStarted: (url) => debugPrint("Page started: $url"),
        onPageFinished: (url) {
          hideLoader();
          debugPrint("Page finished: $url");
        },
        onHttpError: (error) {
          hideLoader();
          debugPrint("HTTP Error: ${error.response?.statusCode}");
        },
        onWebResourceError: (error) {
          hideLoader();
          debugPrint(
              "Web Resource Error: ${error.errorCode} - ${error.description}");
          Utils.showGlobalSnackBar(message: error.description);
          // no need on error
          // if (GetPlatform.isIOS) {
          //   Get.back();
          // }
        },
        onNavigationRequest: _handleNavigationRequest,
        onSslAuthError: (SslAuthError sslAuthError) {
          sslAuthError.platform.proceed();
        });
  }

  Future<NavigationDecision> _handleNavigationRequest(
      NavigationRequest request) async {
    String requestUrl = request.url;
    debugPrint("Navigating to: $requestUrl");

    final lowercaseUrl = request.url.toLowerCase();

    for (String pattern in _completionUrls) {
      if (lowercaseUrl.contains(pattern.toLowerCase())) {
        fetchTransactionDetails(sessionId!);
        return NavigationDecision.prevent;
      }
    }

    for (String pattern in _failureUrls) {
      if (lowercaseUrl.contains(pattern.toLowerCase())) {
        Utils.showGlobalSnackBar(message: "Payment failed");
        if (GetPlatform.isIOS) {
          Get.back();
        }
        return NavigationDecision.prevent;
      }
    }

    if (lowercaseUrl.contains('paymentresult') ||
        requestUrl.startsWith('http://192.168.27.11')) {
      Utils.showGlobalSnackBar(message: "Payment cancelled");
      if (GetPlatform.isIOS) {
        Get.back();
      }
      return NavigationDecision.prevent;
    }

    if (requestUrl
        .startsWith("${FlavorConfig.baseUrl}DubaiPayIntegration/ReturnIndex")) {
      sessionId = Uri.parse(requestUrl).queryParameters['SessionId'] ?? "";
    }
    if (requestUrl.startsWith("${FlavorConfig.webSiteUrl}//cart") ||
        requestUrl.startsWith("${FlavorConfig.webSiteUrl}/cart")) {
      fetchTransactionDetails(sessionId!);
      return NavigationDecision.prevent;
    }
    if (requestUrl.startsWith("${FlavorConfig.webSiteUrl}cart")) {
      await Utils.successDialog(
          title: "topUpSuccess", message: "topUpSuccessMessage");
      Get.back(result: true);
      return NavigationDecision.prevent;
    }

    if (isStaticPage && _isBlockedStaticPage(requestUrl)) {
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  bool _isBlockedStaticPage(String url) {
    return url.startsWith("https://chatbot.zakatfund.gov.ae") ||
        url.startsWith("https://sahem-6c798.firebaseapp");
  }

  Future<void> fetchTransactionDetails(String id) async {
    Utils.showLoadingDialog();
    final result = await getTransactionDetails({"sessionId": id});
    Utils.hideLoadingDialog();
    if (result != null) {
      if (result.requestStatus == 2) {
        sendSmsEmailMobileApp({"sessionId": id});
      }
      _handleSuccessfulTransaction(result);
    }
  }

  void _handleSuccessfulTransaction(ReceiptDetails details) {
    if (Get.isRegistered<CartViewModel>()) {
      Get.find<CartViewModel>()
        ..cart.clear()
        ..cartCount.value = 0;
    } else {
      Get.back();
    }

    Get.offNamed(
      AppRoutes.paymentReceiptScreen,
      arguments: {"transactionDetails": details, "type": 3},
    );
  }

  void hideLoader() {
    if (isLoading) {
      Utils.hideLoadingDialog();
      isLoading = false;
    }
  }
}
