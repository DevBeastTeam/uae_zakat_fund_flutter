import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zakat_fund/view_model/web_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class WebViewScreen extends GetView<WebViewModel> {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.title),
      body: WebViewWidget(controller: controller.webViewController),
    );
  }
}
