import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "scanQrCode"),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates
        ),
        onDetect: (capture){
          List<Barcode> barcodes = capture.barcodes;
          for(final barcode in barcodes){
            Get.back(result: barcode.rawValue);
            break;
          }
        },
      ),
    );
  }
}
