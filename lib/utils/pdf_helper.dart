import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/task_receipt.dart';
import 'package:zakat_fund/model/tax_certificate_details.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

abstract class PDFHelper {
  static List<LookupData> banksList = [];
  static String bankNameEn = "", bankNameAr = "";

  static Future<void> generateTaxCertificatePdf(
      {required TaxCertificateDetails details,
      required String date,
      required bool isCompany,
      bool isPreview = false}) async {
    if (!isPreview && !await _requestStoragePermission()) return;

    final pdf = pw.Document();
    final fonts = await _loadFonts();
    final logos = await _loadLogos();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) =>
            _buildTaxCertificateContent(fonts, logos, details, date, isCompany),
      ),
    );

    final pdfBytes = await pdf.save();
    Utils.hideLoadingDialog();
    if (isPreview) {
      Get.toNamed(AppRoutes.pdfPreviewScreen, arguments: {
        'pdfBytes': pdfBytes,
        'title': 'taxCertificate'.tr,
      });
    } else {
      final directory = await _getDirectory();
      final file = File(
          '${directory.path}/Tax_Certificate_${date.replaceAll("/", "-")}.pdf');
      await file.writeAsBytes(pdfBytes);
      OpenFilex.open(file.path);
      Utils.showGlobalSnackBar(message: 'downloadedSuccessfully'.tr);
    }
  }

  static Future<void> generateDonationReceiptPdf(
      ReceiptDetails details, bool isCompany,
      {bool isPreview = false}) async {
    if (!isPreview && !await _requestStoragePermission()) return;
    if (details.paymentType == 3 || details.paymentType == 4) {
      await fetchBanks();
      LookupData bankData =
          banksList.firstWhere((bank) => bank.value == details.bankId);
      bankNameEn = bankData.name;
      bankNameAr = bankData.nameAr;
    }
    final pdf = pw.Document();
    final fonts = await _loadFonts();
    final logos = await _loadLogos();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) =>
            _buildDonationReceiptContent(fonts, logos, details, isCompany),
      ),
    );

    final pdfBytes = await pdf.save();
    Utils.hideLoadingDialog();
    if (isPreview) {
      Get.toNamed(AppRoutes.pdfPreviewScreen, arguments: {
        'pdfBytes': pdfBytes,
        'title': 'paymentReceipt'.tr,
      });
    } else {
      final directory = await _getDirectory();
      String fileName = "";
      if (details.paymentType == 3) {
        fileName = AppConstant.chequePaymentInvoice;
      } else if (details.paymentType == 2) {
        fileName = AppConstant.cashPaymentInvoice;
      } else if (details.paymentType == 4) {
        fileName = AppConstant.bankDepositPaymentInvoice;
      } else if (details.paymentType == 1 || details.paymentType == 6) {
        fileName = AppConstant.creditCardPaymentInvoice;
      } else if (details.paymentType == 5) {
        fileName = AppConstant.walletPaymentInvoice;
      }
      final file = File(
          '${directory.path}/$fileName${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(pdfBytes);
      OpenFilex.open(file.path);
      Utils.showGlobalSnackBar(message: 'downloadedSuccessfully'.tr);
    }
  }

  static Future<void> generateTaskCollectionReceiptPdf(TaskReceipt details,
      {bool isPreview = false}) async {
    if (!isPreview && !await _requestStoragePermission(hideLoader: false)) {
      return;
    }
    final pdf = pw.Document();
    final fonts = await _loadFonts();
    final logos = await _loadLogos();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => _buildTaskReceiptContent(fonts, logos, details),
      ),
    );

    final pdfBytes = await pdf.save();
    if (isPreview) {
      Utils.hideLoadingDialog();
      Get.toNamed(AppRoutes.pdfPreviewScreen, arguments: {
        'pdfBytes': pdfBytes,
        'title': 'collectionReceipt'.tr,
      });
    } else {
      final directory = await _getDirectory();
      String fileName = "";
      List<String> parts = details.paymentType.split('/');
      fileName = parts[0].trim().replaceAll(" ", "_");

      final file = File('${directory.path}/$fileName${details.requestId}.pdf');
      await file.writeAsBytes(pdfBytes);
      OpenFilex.open(file.path);
      Utils.showFrontEndSnackBar(message: 'downloadedSuccessfully'.tr);
    }
  }

  static Future<bool> _requestStoragePermission(
      {bool hideLoader = true}) async {
    if (Platform.isAndroid) {
      // For Android 13 and above, we use media permissions if needed,
      // but for app-specific directories, no permission is required.
      // If you were accessing shared storage, you'd need READ_MEDIA_IMAGES etc.
      // For PDF generation in app-specific folders, we can return true.
      return true;
    } else {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (hideLoader) Utils.hideLoadingDialog();
        Utils.showFrontEndSnackBar(message: 'Storage permission denied');
        return false;
      }
    }
    return true;
  }

  static Future<Map<String, pw.Font>> _loadFonts() async {
    return {
      'regular': pw.Font.ttf(
          await rootBundle.load('assets/fonts/NotoKufiArabic-Regular.ttf')),
      'bold': pw.Font.ttf(
          await rootBundle.load('assets/fonts/NotoKufiArabic-Bold.ttf')),
      'medium': pw.Font.ttf(
          await rootBundle.load('assets/fonts/NotoKufiArabic-Medium.ttf')),
    };
  }

  static Future<Map<String, pw.MemoryImage>> _loadLogos() async {
    final left = pw.MemoryImage(
        (await rootBundle.load(AppResources.pdfLeftLogo)).buffer.asUint8List());
    final right = pw.MemoryImage(
        (await rootBundle.load(AppResources.uaeLogo)).buffer.asUint8List());
    return {'left': left, 'right': right};
  }

  static Future<Directory> _getDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final newPath = "${directory!.path}/npz";
      final dir = Directory(newPath);
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir;
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  static List<pw.Widget> _buildTaxCertificateContent(
      Map<String, pw.Font> fonts,
      Map<String, pw.MemoryImage> logos,
      TaxCertificateDetails details,
      String date,
      bool isCompany) {
    final arabicFont = fonts['regular']!;
    final boldArabicFont = fonts['bold']!;
    final mediumArabicFont = fonts['medium']!;
    final headers = [
      'Date/التاريخ',
      'Project Name/اسم المشروع',
      'Donation Type/نوع التبرع',
      'Amount (AED)/المبالغ'
    ];
    List data = [];
    data = details.details
        .map((project) => [
              Utils.dateFormat1.format(project.createdDate),
              '${project.projectName}\n${project.projectNameArabic}',
              '${TranslationService().keys['en']![Utils.getPaymentType(project.paymentType)]}\n${TranslationService().keys['ar']![Utils.getPaymentType(project.paymentType)]}',
              '${project.amount.toInt()}'
            ])
        .toList();
    return [
      _buildHeader(logos['left']!, logos['right']!),
      _buildTitle(boldArabicFont, 'Donation Certificate / شهادة تبرع'),
      _buildSection(
          'Certificate Information / معلومات الشهادة', mediumArabicFont),
      _buildCertificateInfoTable(arabicFont, details, date),
      isCompany
          ? _buildSection(
              'Company Information / معلومات الشركة', mediumArabicFont)
          : _buildSection(
              'Donor Information / معلومات المتبرع', mediumArabicFont),
      _buildTaxDonorInfoTable(arabicFont, details, isCompany),
      _buildSection('Donation Summary / ملخص التبرعات', mediumArabicFont),
      _buildDonationSummaryText(arabicFont),
      _buildTable(arabicFont, headers, data),
      _buildTotalDonation(arabicFont, details),
      _buildSection('Authorization / تفويض', mediumArabicFont),
      _buildAuthorizationInfo(arabicFont),
      pw.SizedBox(height: 16),
      _buildValidityNote(mediumArabicFont),
      _buildNotesSection(mediumArabicFont, boldArabicFont),
      _buildFooter(arabicFont),
    ];
  }

  static List<pw.Widget> _buildDonationReceiptContent(
      Map<String, pw.Font> fonts,
      Map<String, pw.MemoryImage> logos,
      ReceiptDetails details,
      bool isCompany) {
    final arabicFont = fonts['regular']!;
    final boldArabicFont = fonts['bold']!;
    final mediumArabicFont = fonts['medium']!;
    final headers = ['Project Name', 'Amount (AED)/المبالغ', 'اسم المشروع'];
    List data = [];
    data = details.projects
        .map((project) => [
              project.projectName,
              '${project.amount.toInt()}',
              project.projectNameArabic
            ])
        .toList();
    return [
      _buildHeader(logos['left']!, logos['right']!),
      pw.Divider(color: PdfColor.fromInt(0xFFCBCBCC)),
      if (details.paymentType == 1 || details.paymentType == 6)
        pw.SizedBox(height: 5),
      _buildTitle(boldArabicFont,
          "Credit Card Payment Invoice / إيصال الدفع ببطاقة الائتمان"),
      if (details.paymentType == 2)
        _buildTitle(
            boldArabicFont, "Cash Payment Invoice / إيصال الدفع النقدي"),
      if (details.paymentType == 3)
        _buildTitle(
            boldArabicFont, "Cheque Payment Invoice / إيصال الدفع بالشيك"),
      if (details.paymentType == 4)
        _buildTitle(boldArabicFont, "Bank Deposit Receipt / إيصال إيداع بنكي"),
      if (details.paymentType == 5)
        _buildTitle(
            boldArabicFont, "Wallet Payment Invoice / فاتورة دفع المحفظة"),
      if (details.paymentType == 1 || details.paymentType == 6)
        _buildReceiptContainer(
          arabicFont,
          AppConstant.onlinePaymentReceiptMessageEnglish,
          AppConstant.onlinePaymentReceiptMessageArabic,
        ),
      if (details.paymentType == 5)
        _buildReceiptContainer(
          arabicFont,
          AppConstant.walletPaymentReceiptMessageEnglish,
          AppConstant.walletPaymentReceiptMessageArabic,
        ),
      if (details.paymentType == 2)
        _buildReceiptContainer(
          arabicFont,
          AppConstant.cashPaymentReceiptMessageEnglish,
          AppConstant.cashPaymentReceiptMessageArabic,
        ),
      if (details.paymentType == 3)
        _buildReceiptContainer(
          arabicFont,
          AppConstant.chequePaymentReceiptMessageEnglish,
          AppConstant.chequePaymentReceiptMessageArabic,
        ),
      isCompany
          ? _buildSection(
              'Company Information / معلومات الشركة', boldArabicFont)
          : _buildSection(
              'Donor Information / معلومات المتبرع', boldArabicFont),
      _buildReceiptDonorInfoTable(arabicFont, details, isCompany),
      _buildSection('Amount & Collection Details / تفاصيل المبلغ والتحصيل',
          boldArabicFont),
      _buildAmountAndCollectionDetailsTable(arabicFont, details),
      _buildSection('Projects / المشاريع', boldArabicFont),
      _buildTable(arabicFont, headers, data, isReceipt: true),
      _buildSection(
          'Total Amount: ${details.totalAmount.toInt()} AED / المبلغ الإجمالي: ${details.totalAmount.toInt()} درهم ',
          boldArabicFont,
          isDivider: false),
      _buildFooter(mediumArabicFont),
    ];
  }

  static List<pw.Widget> _buildTaskReceiptContent(Map<String, pw.Font> fonts,
      Map<String, pw.MemoryImage> logos, TaskReceipt details) {
    final arabicFont = fonts['regular']!;
    final boldArabicFont = fonts['bold']!;
    final mediumArabicFont = fonts['medium']!;
    final headers = [
      'Request ID/معرف الطلب',
      'Date/التاريخ',
      'Collection Time/ وقت التجميع ',
      'Amount (AED)/المبالغ'
    ];
    List data = [];
    data = [0]
        .map((project) => [
              details.requestId,
              details.date,
              details.collectionTime,
              details.amount
            ])
        .toList();
    return [
      _buildHeader(logos['left']!, logos['right']!),
      _buildTitle(boldArabicFont, details.paymentType),
      pw.SizedBox(height: 10),
      _buildTaskInfoTable(arabicFont),
      _buildSection('Donor Information / معلومات المتبرع', mediumArabicFont),
      _buildTaskReceiptDonorInfoTable(arabicFont, details),
      _buildSection('Donation Summary / ملخص التبرعات', mediumArabicFont),
      _buildTaskSummaryText(arabicFont),
      _buildTaskReceiptTable(arabicFont, headers, data),
      _buildFooter(arabicFont),
    ];
  }

  static pw.Widget _buildReceiptContainer(
      pw.Font font, String english, String arabic) {
    return pw.Container(
        width: double.infinity,
        padding: pw.EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: pw.EdgeInsets.only(top: 16),
        decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xffE7E6E7),
            border: pw.Border.all(color: PdfColor.fromInt(0xffD0D5DD))),
        child: pw.Column(children: [
          pw.Text(english,
              style: pw.TextStyle(fontSize: 9, font: font),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 2),
          pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text(arabic,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 9, font: font))),
        ]));
  }

  static pw.Widget _buildHeader(
          pw.MemoryImage leftLogo, pw.MemoryImage rightLogo) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(leftLogo, width: 200),
          pw.Image(rightLogo, width: 40),
        ],
      );

  static pw.Widget _buildTitle(pw.Font font, String title) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Center(
          child: pw.Text(title,
              style: pw.TextStyle(
                  font: font,
                  fontSize: 14,
                  color: PdfColor.fromInt(0xff262626))),
        ),
      );

  static pw.Widget _buildSection(String title, pw.Font font,
          {bool isDivider = true}) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.SizedBox(height: 10),
          pw.SizedBox(width: double.infinity),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(title,
                style: pw.TextStyle(
                    font: font,
                    fontSize: 15,
                    color: PdfColor.fromInt(0xff262626))),
          ),
          pw.SizedBox(height: 3),
          if (isDivider) pw.Divider(color: PdfColor.fromInt(0xFFCBCBCC)),
          if (isDivider) pw.SizedBox(height: 5),
        ],
      );

  static pw.Table _buildCertificateInfoTable(
          pw.Font font, TaxCertificateDetails details, String date) =>
      pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1),
        },
        children: [
          _buildInfoRow(
              'Certificate No:', details.uniqueCode, 'رقم الشهادة:', font),
          _buildInfoRow('Date:', date, 'التاريخ:', font),
        ],
      );

  static pw.Table _buildTaxDonorInfoTable(
    pw.Font font,
    TaxCertificateDetails details,
    bool isCompany,
  ) =>
      pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1),
        },
        children: [
          if (isCompany)
            _buildInfoRow(
                'Company Name:',
                '${details.donorName} / ${details.donorNameAr}',
                'اسم الشركة:',
                font),
          if (!isCompany) ...[
            _buildInfoRow(
                'Donor Name:',
                '${details.donorName} / ${details.donorNameAr}',
                'اسم المتبرع:',
                font),
            _buildInfoRow(
                'Nationality:',
                '${details.nationalityName} / ${details.nationalityNameAr}',
                'الجنسية:',
                font),
            _buildInfoRow('EID:', details.emirateId, 'رقم الهوية:', font),
          ],
          _buildInfoRow('Address:', details.address, 'العنوان:', font),
          _buildInfoRow(
              'Email:', details.emailAddress, 'البريد الإلكتروني:', font),
          _buildInfoRow('Mobile:', details.phoneNumber, 'رقم الهاتف:', font),
        ],
      );

  static pw.Table _buildReceiptDonorInfoTable(
    pw.Font font,
    ReceiptDetails details,
    bool isCompany,
  ) =>
      pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1),
        },
        children: [
          if (isCompany)
            _buildInfoRow(
                'Company Name:',
                '${details.donorName} / ${details.donorNameAr}',
                'اسم الشركة:',
                font),
          if (!isCompany)
            _buildInfoRow(
                'Donor Name:',
                '${details.donorName} / ${details.donorNameAr}',
                'اسم المتبرع:',
                font),
          _buildInfoRow('Mobile:', details.mobile, 'رقم الهاتف:', font),
          _buildInfoRow('Email:', details.email, 'البريد الإلكتروني:', font),
          _buildInfoRow(
              'Status:',
              "${TranslationService().keys['en']![Utils.statusIntoString(details.requestStatus)]} / ${TranslationService().keys['ar']![Utils.statusIntoString(details.requestStatus)]}",
              'حالة:',
              font),
        ],
      );

  static pw.Table _buildTaskReceiptDonorInfoTable(
          pw.Font font, TaskReceipt details) =>
      pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1),
        },
        children: [
          _buildInfoRow(
              'Donor Name:', details.donorName, 'اسم الجهة المانحة:', font),
          _buildInfoRow('Address:', details.address, 'عنوان:', font),
        ],
      );

  static pw.Table _buildTaskInfoTable(pw.Font font) {
    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(1),
      },
      children: [
        _buildInfoRow('Date of Issue:',
            Utils.dateFormat1.format(DateTime.now()), 'تاريخ الإصدار:', font),
      ],
    );
  }

  static pw.Table _buildAmountAndCollectionDetailsTable(
    pw.Font font,
    ReceiptDetails details,
  ) {
    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(1),
      },
      children: [
        _buildInfoRow(
            'Transaction ID:', details.transactionId, 'رقم المعاملة:', font),
        _buildInfoRow(
            'Payment Type:',
            '${TranslationService().keys['en']![Utils.getPaymentType(details.paymentType)]} / ${TranslationService().keys['ar']![Utils.getPaymentType(details.paymentType)]}',
            'نوع الدفع:',
            font),
        if (bankNameEn.isNotEmpty) ...[
          _buildInfoRow(
              'Bank Name:', "$bankNameEn / $bankNameAr", 'اسم البنك:', font),
        ],
        if (details.paymentType == 3) ...[
          _buildInfoRow('Cheque No:', details.chequeNo, 'رقم الشيك:', font),
          _buildInfoRow('Cheque Amount:',
              "${details.totalAmount.toInt()} (AED)", 'مبلغ الشيك:', font),
          _buildInfoRow(
              'Cheque Date:',
              Utils.dateFormat1.format(details.chequeDate ?? DateTime.now()),
              'تاريخ الشيك:',
              font),
        ],
        if (details.paymentType == 4)
          _buildInfoRow(
              'Receipt Number:', details.chequeNo, 'رقم الإيصال:', font),
        if (details.paymentType == 4 ||
            details.paymentType == 1 ||
            details.paymentType == 6 ||
            details.paymentType == 5)
          _buildInfoRow(
              'Payment Date::',
              Utils.dateFormat1.format(details.chequeDate ?? DateTime.now()),
              'تاريخ الدفع:',
              font),
        if (details.paymentType != 3)
          _buildInfoRow('Payment Amount:',
              "${details.totalAmount.toInt()} (AED)", 'مبلغ الدفع:', font),
        if (details.paymentType == 2 || details.paymentType == 3) ...[
          _buildInfoRow(
              'Collection Date:',
              Utils.dateFormat1
                  .format(details.collectionDate ?? DateTime.now()),
              'تاريخ التحصيل:',
              font),
          _buildInfoRow('Collection Time:', details.collectionTime.toString(),
              'وقت التحصيل:', font),
          _buildInfoRow('Collection Point:', details.collectionPoint.toString(),
              'نقطة التحصيل:', font),
        ],
      ],
    );
  }

  static Future fetchBanks() async {
    ApiResponse apiResponse = await GenericRepoImpl()
        .fetchLookUpData(request: RequestBody(endPoint: ApiConstant.banks));
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel response = apiResponse.data;
      List<LookupData> newBanksLis = List<LookupData>.from(
          response.data.map((bank) => LookupData.bankFromJson(bank)));
      banksList = newBanksLis.toSet().toList();
    }
  }

  static pw.Widget _buildDonationSummaryText(pw.Font font) => pw.Column(
        children: [
          pw.Text(
            "This certificate serves as a formal acknowledgment of your contributions to the Zakat Fund. Each donation listed below qualifies for tax exemption as per the relevant tax laws.",
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font, fontSize: 10),
          ),
          pw.SizedBox(height: 4),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(
              "تعمل هذه الشهادة بمثابة اعتراف رسمي بمساهماتك في صندوق الزكاة. كل تبرع مذكور أدناه مؤهل للإعفاء الضريبي وفقًا لقوانين الضرائب ذات الصلة",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
          ),
          pw.SizedBox(height: 10),
        ],
      );

  static pw.Widget _buildTaskSummaryText(pw.Font font) => pw.Column(
        children: [
          pw.Text(
            "Thank you for your generous donations to the Zakat Fund. Your contributions help us support vital projects and bring meaningful change to our communities.",
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font, fontSize: 10),
          ),
          pw.SizedBox(height: 8),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(
              "نشكركم على تبرعاتكم السخية لصندوق الزكاة. مساهماتكم تساعدنا على دعم مشاريع حيوية وإحداث تغيير إيجابي في مجتمعاتنا.",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
          ),
          pw.SizedBox(height: 10),
        ],
      );

  static pw.TableRow _buildInfoRow(
      String label, String value, String arabicLabel, pw.Font font) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Text(label, style: pw.TextStyle(font: font, fontSize: 11)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text(value,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: font, fontSize: 11))),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(arabicLabel,
                style: pw.TextStyle(font: font, fontSize: 11)),
          ),
        ),
      ],
    );
  }

  static pw.Table _buildTable(pw.Font font, List headers, List data,
      {bool isReceipt = false}) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColor.fromInt(0xffd0d5dd)),
      columnWidths: {
        0: !isReceipt
            ? const pw.IntrinsicColumnWidth()
            : const pw.FlexColumnWidth(1),
        1: isReceipt ? pw.IntrinsicColumnWidth() : const pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(isReceipt ? 1 : 1.5),
        if (!isReceipt) 3: const pw.IntrinsicColumnWidth(),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xfff2f2f2)),
          children: headers
              .map((header) => pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Text(header,
                            style: pw.TextStyle(font: font, fontSize: 10),
                            textAlign: pw.TextAlign.center)),
                  ))
              .toList(),
        ),
        ...data.map((row) => pw.TableRow(
              children: row
                  .map<pw.Widget>((cell) => pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Directionality(
                            textDirection: pw.TextDirection.rtl,
                            child: pw.Text(cell,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(font: font, fontSize: 9))),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  static pw.Table _buildTaskReceiptTable(
    pw.Font font,
    List headers,
    List data,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColor.fromInt(0xffd0d5dd)),
      // columnWidths: {
      //   0: !isReceipt
      //       ? const pw.IntrinsicColumnWidth()
      //       : const pw.FlexColumnWidth(1),
      //   1: isReceipt ? pw.IntrinsicColumnWidth() : const pw.FlexColumnWidth(2),
      //   2: pw.FlexColumnWidth(isReceipt ? 1 : 1.5),
      //   if (!isReceipt) 3: const pw.IntrinsicColumnWidth(),
      // },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xfff2f2f2)),
          children: headers
              .map((header) => pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Text(header,
                            style: pw.TextStyle(font: font, fontSize: 10),
                            textAlign: pw.TextAlign.center)),
                  ))
              .toList(),
        ),
        ...data.map((row) => pw.TableRow(
              children: row
                  .map<pw.Widget>((cell) => pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Directionality(
                            textDirection: pw.TextDirection.rtl,
                            child: pw.Text(cell,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(font: font, fontSize: 9))),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  static pw.Widget _buildTotalDonation(
      pw.Font font, TaxCertificateDetails details) {
    int totalAmount =
        details.details.fold(0, (sum, proj) => sum + proj.amount.toInt());
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16),
      child: pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1),
        },
        children: [
          _buildInfoRow('Total Donation Amount:', '$totalAmount',
              'إجمالي مبلغ التبرع:', font),
        ],
      ),
    );
  }

  static pw.Widget _buildAuthorizationInfo(pw.Font font) {
    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
      },
      children: [
        _buildInfoRow('Date of Issue:',
            Utils.dateFormat1.format(DateTime.now()), 'تاريخ الإصدار:', font),
        pw.TableRow(
          children: [
            pw.Text("Authorized Signature:",
                style: pw.TextStyle(font: font, fontSize: 11)),
            pw.Divider(color: PdfColor.fromInt(0xFFCBCBCC)),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text("التوقيع المعتمد:",
                  style: pw.TextStyle(font: font, fontSize: 11)),
            ),
          ],
        ),
        _buildInfoRow('Name:', '', 'الاسم:', font),
        _buildInfoRow(
            'Position:', 'Managing Director / مدير عام', 'منصب:', font),
        _buildInfoRow('Contact:', '+97 878 67789 1', 'اتصال:', font),
      ],
    );
  }

  static pw.Widget _buildValidityNote(pw.Font font) => pw.Center(
        child: pw.Text(
          'This certificate is valid for one month from the issue date / هذه الشهادة صالحة لمدة شهر واحد من تاريخ الإصدار.',
          style: pw.TextStyle(
              font: font, fontSize: 8, color: PdfColor.fromInt(0xff8a868a)),
          textAlign: pw.TextAlign.center,
        ),
      );

  static pw.Widget _buildNotesSection(pw.Font font, pw.Font boldFont) {
    final List notes = [
      {
        "english":
            "Only donations made directly to the Zakat Fund are included in this certificate.",
        "arabic":
            "يتم تضمين التبرعات المقدمة مباشرة إلى صندوق الزكاة فقط في هذه الشهادة"
      },
      {
        "english": "Please retain this certificate for your tax records.",
        "arabic": "يرجى الاحتفاظ بهذه الشهادة لسجلاتك الضريبية"
      },
    ];
    return pw.Column(
      children: [
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Notes:',
                style: pw.TextStyle(font: boldFont, fontSize: 10)),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text('ملاحظات:',
                  style: pw.TextStyle(font: boldFont, fontSize: 10)),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        ...List.generate(
            notes.length,
            (index) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Flexible(
                      child: pw.Bullet(
                        bulletSize: 1 * PdfPageFormat.mm,
                        bulletColor: PdfColor.fromInt(0xff8a868a),
                        text: notes[index]["english"],
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 8,
                            color: PdfColor.fromInt(0xff8a868a)),
                      ),
                    ),
                    pw.Flexible(
                      child: pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Bullet(
                          bulletSize: 1 * PdfPageFormat.mm,
                          bulletColor: PdfColor.fromInt(0xff8a868a),
                          text: notes[index]["arabic"],
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              font: font,
                              fontSize: 8,
                              color: PdfColor.fromInt(0xff8a868a)),
                        ),
                      ),
                    ),
                  ],
                )),
      ],
    );
  }

  static pw.Widget _buildFooter([pw.Font? font]) => pw.Column(
        children: [
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text(
                'Federal Authority | هيئة اتحادية\nP.O. BOX ص.ب. 2272 • ABU DHABI, UNITED ARAB EMIRATES • أبوظبي، الإمارات العربية المتحدة\nFAX فاكس +971 2621 1746 • TEL هاتف +9712614 3666',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  height: 2,
                  lineSpacing: 0,
                  color: PdfColor.fromInt(0xff92722a),
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 7),
          pw.Center(
            child: pw.Text(
              'www.awqaf.gov.ae',
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
                color: PdfColor.fromInt(0xff92722a),
              ),
            ),
          ),
        ],
      );
}
