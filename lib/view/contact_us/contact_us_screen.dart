import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/contact_us_view_model.dart';
import 'package:zakat_fund/widgets/content_helpful_widget.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ContactUsScreen extends GetView<ContactUsViewModel> {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchContactUs();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "contactUs"),
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52.h,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTabItem('callUs'.tr, 0),
                    _buildTabItem('contactUs'.tr, 1),
                    _buildTabItem('suggestionAndNotes'.tr, 2),
                  ],
                ),
              ),
              _buildBody()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.index.value == 0) {
        return ContactUsScreenOne();
      } else if (controller.index.value == 1) {
        return ContactUsScreenTwo();
      } else {
        return ContactUsScreenThree();
      }
    });
  }

  Widget _buildTabItem(String text, int index) {
    return Obx(() => Expanded(
          child: GestureDetector(
            onTap: () {
              controller.index.value = index;
            },
            child: Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: controller.index.value == index
                    ? AppColors.secondaryDarkBrownColor.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: controller.index.value == index
                    ? AppTextStyle.secondaryDarkBrownColor14spTextStyle
                    : AppTextStyle.greyColor14spTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ));
  }
}

class ContactUsScreenThree extends GetView<ContactUsViewModel> {
  const ContactUsScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        Text(
          "email".tr,
          style: AppTextStyle.darkGreyOne16spTextStyle1,
        ),
        Text(
          controller.email.value,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
        ),
        16.verticalSpace,
        Text(
          "toolFreeCall".tr,
          style: AppTextStyle.darkGreyOne16spTextStyle1,
        ),
        Text(
          controller.phoneNumber.value,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
        ),
        16.verticalSpace,
        Text(
          "stayInTouch".tr,
          style: AppTextStyle.darkGreyOne16spTextStyle1,
        ),
        Text(
          "sahemLiveSupport".tr,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
        ),
        16.verticalSpace,
        Text(
          "contactWith".tr,
          style: AppTextStyle.darkGreyOne16spTextStyle1,
        ),
        Text(
          "sahemLeadership".tr,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
        ),
        16.verticalSpace,
        // Text(
        //   "socialMedia".tr,
        //   style: AppTextStyle.darkGreyOne16spTextStyle1,
        // ),
        _buildSocialMediaRow(),
        20.verticalSpace,
        ContentHelpfulWidget(
          id: 121,
          type: 'Contact Us',
        ),
      ],
    );
  }

  Widget _buildSocialMediaRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldLabel(label: "socialMedia"),
        4.verticalSpace,
        Obx(() {
          final icons = <Widget>[
            if (controller.youtube.isNotEmpty)
              _socialIcon(
                  AppResources.youtubeFillIcon, controller.youtube.value),
            if (controller.twitter.isNotEmpty)
              _socialIcon(
                  AppResources.twitterFillIcon, controller.twitter.value),
            if (controller.instagram.isNotEmpty)
              _socialIcon(
                  AppResources.instFillIcon, controller.instagram.value),
            if (controller.facebook.isNotEmpty)
              _socialIcon(AppResources.fbFillIcon, controller.facebook.value),
          ].expand((icon) => [icon, 8.horizontalSpace]).toList();

          if (icons.isNotEmpty) icons.removeLast(); // remove last spacer

          return Row(children: icons);
        }),
      ],
    );
  }

  Widget _socialIcon(String icon, String url) => buildIconButton(
        icon: icon,
        color: AppColors.secondaryDarkBrownColor,
        onPressed: () => Utils.openUrl(url),
      );
}

class ContactUsScreenTwo extends GetView<ContactUsViewModel> {
  const ContactUsScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          16.verticalSpace,
          LabelTextField(
            isBackWhite: true,
            isBlack: true,
            controller: controller.nameController,
            readOnly: controller.nameController.text.isNotEmpty,
            label: 'name',
            hint: 'name',
          ),
          16.verticalSpace,
          LabelTextField(
            isBackWhite: true,
            isBlack: true,
            controller: controller.emailController,
            label: 'email',
            keyboardType: TextInputType.emailAddress,
            isArabicDirection: true,
            readOnly: controller.emailController.text.isNotEmpty,
            hint: 'you@email.com',
            validator: (value) => Validator.validateEmailId(value: value!),
            checkValidation: true,
            inputFormatters: InputFormatters.denySpaces,
          ),
          16.verticalSpace,
          LabelTextField(
            isBackWhite: true,
            isBlack: true,
            controller: controller.subjectController,
            label: 'subject',
            hint: 'writeSubject'.tr,
          ),
          16.verticalSpace,
          LabelTextField(
            isBackWhite: true,
            isBlack: true,
            maxLines: 5,
            checkValidation: true,
            focusNode: controller.messageNode,
            controller: controller.messageController,
            label: 'theMessage',
            hint: "enterMessage".tr,
          ),
          20.verticalSpace,
          elevatedButton(
              text: "sendMessage".tr,
              onPressed: () {
                controller.sendContactUs(null);
              })
        ],
      ),
    );
  }
}

class ContactUsScreenOne extends GetView<ContactUsViewModel> {
  const ContactUsScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    initialValue: 'headquarters'.tr,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  16.verticalSpace,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      AppResources.mapImage,
                      width: Get.width,
                      fit: BoxFit.cover,
                      height: 222.h,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _launchLocation(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppColors.secondaryDarkBrownColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'location'.tr,
                        style:
                            AppTextStyle.secondaryDarkBrownColor14spTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              controller.address.value,
              style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.mail_outline,
                    text: controller.email.value,
                    bgColor: AppColors.accentGreen,
                    iconColor: AppColors.darkGreen,
                    textColor: AppColors.darkGreen,
                    onTap: () => _launchEmail(controller.email.value),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.phone_outlined,
                    text: controller.phoneNumber.value,
                    bgColor: AppColors.warningBackColor,
                    iconColor: AppColors.lightBrownColor2,
                    textColor: AppColors.lightBrownColor2,
                    onTap: () => _launchPhone(controller.phoneNumber.value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.greyBackColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time,
                            color: AppColors.lightBlack),
                        16.verticalSpace,
                        Text(
                          'workingHoursValue'.tr,
                          style: TextStyle(
                            color: AppColors.lightBlack,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ));
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String text,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor),
                Icon(Icons.arrow_forward_ios, size: 14, color: iconColor),
              ],
            ),
            16.verticalSpace,
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return;

    final mailUri = Uri(scheme: 'mailto', path: trimmed);

    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri, mode: LaunchMode.externalApplication);
      return;
    }

    Utils.showGlobalSnackBar(message: "cantOpenThis".tr);
  }

  Future<void> _launchPhone(String phone) async {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return;

    final cleaned = trimmed.replaceAll(RegExp(r'[^0-9+]+'), '');
    final telUri =
        Uri(scheme: 'tel', path: cleaned.isEmpty ? trimmed : cleaned);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
      return;
    }

    Utils.showGlobalSnackBar(message: "cantOpenThis".tr);
  }

  Future<void> _launchLocation() async {
    final url = controller.addressApiUrl.trim();
    if (url.isEmpty) {
      Utils.showGlobalSnackBar(message: "locationNotAvailable".tr);
      return;
    }

    final Uri uri;
    if (url.contains('://') || url.startsWith('geo:')) {
      uri = Uri.parse(url);
    } else {
      final query = Uri.encodeComponent(url);
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    Utils.showGlobalSnackBar(message: "cantOpenThis".tr);
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    padding:
                        const EdgeInsets.only(top: 252, left: 24, right: 24),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: IntrinsicHeight(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment(1, 1),
                                    end: Alignment(-1, -1),
                                    colors: [
                                      Color(0xFF21BDCA),
                                      Color(0xFF39A606),
                                    ],
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                margin: const EdgeInsets.only(bottom: 48),
                                width: double.infinity,
                                child: Column(children: [
                                  Text(
                                    "Example",
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
