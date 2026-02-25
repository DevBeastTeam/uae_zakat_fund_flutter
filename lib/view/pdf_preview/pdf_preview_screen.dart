import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final pdfBytes = args['pdfBytes'];
    final title = args['title'] ?? 'Preview';

    return Scaffold(
      appBar: myAppBar(title: title),
      body: PdfPreview(
        build: (format) => pdfBytes,
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}
