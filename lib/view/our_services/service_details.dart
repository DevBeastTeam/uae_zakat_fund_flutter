import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/service_detail_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/content_helpful_widget.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class ServiceDetailsScreen extends GetView<ServiceDetailViewModel> {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "serviceDetails"),
      // bottomNavigationBar: startServiceBtn(),
      body: _buildBody(),
    );
  }

  WillPopScope _buildBody() {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.all(16.r),
                padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 16.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.lightGrey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceTitle(),
                    16.verticalSpace,
                    _buildServiceDescription(),
                    _buildServiceProcedure(),
                    _buildTermsOfUse(),
                  ],
                )),
            _buildFaqs(),
            _buildServiceDetails(),
            _buildServiceStart(),
            16.verticalSpace,
            _buildImageDetails(),
            _buildAdditionalText(),
            _buildVideoList(),
            _buildLinkList(),
            _buildAmountList(),
            _buildButtonList(),
            16.verticalSpace,
            _moreLinks(),
            16.verticalSpace,
            if (!controller.showPreview)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ContentHelpfulWidget(
                  id: controller.service.id,
                  type: "Services",
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _moreLinks() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("relatedServices".tr,
              style: AppTextStyle.secondaryPrimaryBlack26spTextStyle1),
          16.verticalSpace,
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final service = controller.allServices[index];
              return GestureDetector(
                onTap: () {
                  Get.offNamed(
                      preventDuplicates: false,
                      AppRoutes.serviceDetails,
                      arguments: {
                        "service": service,
                        "allServices": controller.allServices
                      });
                },
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: index == 0 ? Color(0xffF1F5F9) : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.lightGrey),
                    boxShadow: index == 0
                        ? [
                            BoxShadow(
                                color: AppColors.lightBlackColor
                                    .withValues(alpha: 0.1),
                                offset: const Offset(0.0, 4.0),
                                blurRadius: 6.0,
                                spreadRadius: -4),
                            BoxShadow(
                                color: AppColors.lightBlackColor
                                    .withValues(alpha: 0.1),
                                offset: const Offset(0.0, 10.0),
                                blurRadius: 15.0,
                                spreadRadius: -3),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.isArabic ? service.titleAr : service.titleEn,
                        style: AppTextStyle.secondaryPrimaryBlack20spTextStyle3,
                      ),
                      16.verticalSpace,
                      Row(
                        children: [
                          Text(
                            "viewMoreLink".tr,
                            style: AppTextStyle
                                .secondaryDarkBrownColor16spTextStyle1,
                          ),
                          8.horizontalSpace,
                          Icon(Icons.arrow_forward, size: 16.r)
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                16.verticalSpace,
            itemCount: controller.allServices.length > 3
                ? 3
                : controller.allServices.length,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        Utils.isArabic
            ? controller.service.titleAr
            : controller.service.titleEn,
        style: AppTextStyle.secondaryPrimaryBlack32spTextStyle2,
      ),
    );
  }

  Widget _buildServiceDescription() {
    if (controller.service.descriptionEn.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("aboutService".tr,
              style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1),
          SizedBox(height: 16.h),
          HtmlWidget(
            Utils.isArabic
                ? controller.service.descriptionAr
                : controller.service.descriptionEn,
            renderMode: RenderMode.column,
            textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
          ),
          SizedBox(height: 16.h),
          const Divider(color: AppColors.lightGrey1),
        ],
      ),
    );
  }

  Widget _buildServiceProcedure() {
    if (controller.service.procedureAr.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("theOperation".tr,
              style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1),
          SizedBox(height: 13.h),
          HtmlWidget(
            Utils.isArabic
                ? controller.service.procedureAr
                : controller.service.proceduresEn,
            renderMode: RenderMode.column,
            textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
          ),
          SizedBox(height: 16.h),
          const Divider(color: AppColors.lightGrey1),
        ],
      ),
    );
  }

  Widget _buildTermsOfUse() {
    if (controller.service.termsOfUseAr.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("termsOfUse".tr,
              style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1),
          SizedBox(height: 13.h),
          HtmlWidget(
            Utils.isArabic
                ? controller.service.termsOfUseAr
                : controller.service.termsOfUseEn,
            renderMode: RenderMode.column,
            textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildFaqs() {
    if (controller.subFaqs.isEmpty) return SizedBox.shrink();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("frequentlyAskedQuestions".tr,
              style: AppTextStyle.secondaryPrimaryBlack26spTextStyle1),
          SizedBox(height: 13.h),
          faqListView(),
        ],
      ),
    );
  }

  Widget _buildServiceStart() {
    List<Widget> details = [];

    if (controller.service.duration.isNotEmpty) {
      details.add(_buildRowHeader(
          icon: AppResources.durationIcon, heading: 'durationOfService'));
      details.add(SizedBox(height: 13.h));
      details.add(Text(
          Utils.isArabic
              ? controller.service.durationAr
              : controller.service.duration,
          textAlign: TextAlign.justify,
          style: AppTextStyle.lightBlack14spTextStyle));
      if (controller.service.serviceFee.isNotEmpty) {
        details.add(SizedBox(height: 16.h));
        details.add(const Divider(color: AppColors.lightGrey1));
        details.add(SizedBox(height: 16.h));
      }
    }

    if (controller.service.serviceFee.isNotEmpty) {
      details.add(
          _buildRowHeader(icon: AppResources.costIcon, heading: 'serviceCost'));
      details.add(SizedBox(height: 13.h));
      details.add(Text(controller.service.serviceFee,
          textAlign: TextAlign.justify,
          style: AppTextStyle.lightBlack14spTextStyle));
      if (controller.service.serviceChannelsEn.isNotEmpty) {
        details.add(SizedBox(height: 16.h));
        details.add(const Divider(color: AppColors.lightGrey1));
        details.add(SizedBox(height: 16.h));
      }
    }
    final serviceUrl = controller.service.startServiceEN;

    if (serviceUrl.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size(190.w, 52.h)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r))),
              backgroundColor: const WidgetStatePropertyAll(
                  AppColors.secondaryDarkBrownColor),
              elevation: const WidgetStatePropertyAll(0),
            ),
            onPressed: () {
              controller.startService(serviceUrl);
            },
            label: Text(
              "startService".tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.white18spTextStyle1,
            ),
            iconAlignment: IconAlignment.end,
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
          16.verticalSpace,
          Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: details)
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
    List<Widget> details = [];

    if (controller.service.duration.isNotEmpty) {
      details.add(_buildRowHeader(
          icon: AppResources.durationIcon, heading: 'durationOfService'));
      details.add(SizedBox(height: 13.h));
      details.add(Text(
          Utils.isArabic
              ? controller.service.durationAr
              : controller.service.duration,
          textAlign: TextAlign.justify,
          style: AppTextStyle.lightBlack14spTextStyle));
      if (controller.service.serviceFee.isNotEmpty) {
        details.add(SizedBox(height: 16.h));
        details.add(const Divider(color: AppColors.lightGrey1));
        details.add(SizedBox(height: 16.h));
      }
    }

    if (controller.service.serviceFee.isNotEmpty) {
      details.add(
          _buildRowHeader(icon: AppResources.costIcon, heading: 'serviceCost'));
      details.add(SizedBox(height: 13.h));
      details.add(Text(controller.service.serviceFee,
          textAlign: TextAlign.justify,
          style: AppTextStyle.lightBlack14spTextStyle));
      if (controller.service.serviceChannelsEn.isNotEmpty) {
        details.add(SizedBox(height: 16.h));
        details.add(const Divider(color: AppColors.lightGrey1));
        details.add(SizedBox(height: 16.h));
      }
    }

    if (controller.service.serviceChannelsEn.isNotEmpty) {
      details.add(_buildRowHeader(
          icon: AppResources.serviceChannelIcon, heading: 'serviceChannels'));
      details.add(SizedBox(height: 13.h));
      details.add(HtmlWidget(
        Utils.isArabic
            ? controller.service.serviceChannelsAr
            : controller.service.serviceChannelsEn,
        renderMode: RenderMode.column,
        textStyle: AppTextStyle.lightBlack14spTextStyle,
      ));
      if (controller.service.targetAudienceEn.isNotEmpty) {
        details.add(SizedBox(height: 16.h));
        details.add(const Divider(color: AppColors.lightGrey1));
        details.add(SizedBox(height: 16.h));
      }
    }

    if (controller.service.targetAudienceEn.isNotEmpty) {
      details.add(_buildRowHeader(
          icon: AppResources.audienceIcon, heading: 'targetAudience'));
      details.add(SizedBox(height: 13.h));
      details.add(HtmlWidget(
        Utils.isArabic
            ? controller.service.targetAudienceAr
            : controller.service.targetAudienceEn,
        renderMode: RenderMode.column,
        textStyle: AppTextStyle.lightBlack14spTextStyle,
      ));
      if (controller.service.support.isNotEmpty) {
        details.add(SizedBox(height: 16.h));
        details.add(const Divider(color: AppColors.lightGrey1));
        details.add(SizedBox(height: 16.h));
      }
    }

    if (controller.service.support.isNotEmpty) {
      details.add(_buildRowHeader(
          icon: AppResources.supportIcon, heading: 'theSupport'));
      details.add(SizedBox(height: 13.h));
      details.add(Text(controller.service.support,
          style: AppTextStyle.lightBlack14spTextStyle));
    }

    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details,
      ),
    );
  }

  Widget _buildImageDetails() {
    if (controller.imagesList.isEmpty) return SizedBox.shrink();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
              controller.imagesList.length,
              (topIndex) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100.h,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            String image =
                                controller.imagesList[topIndex][index];
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: CachedImage(
                                  image: image
                                      .toLowerCase()
                                      .split("attachments/")
                                      .last,
                                  width: 150.w,
                                  height: 100.h,
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              10.horizontalSpace,
                          itemCount: controller.imagesList[topIndex].length,
                        ),
                      ),
                      16.verticalSpace,
                    ],
                  )),
          const Divider(color: AppColors.lightGrey1),
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildAdditionalText() {
    if (controller.englishText.isNotEmpty && !Utils.isArabic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.lightGrey)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (controller.englishText.isNotEmpty && !Utils.isArabic)
            ...List.generate(
                controller.englishText.length,
                (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRowHeader(
                            icon: AppResources.costIcon,
                            heading: controller.englishText[index]["title"]),
                        13.verticalSpace,
                        Text(controller.englishText[index]["value"],
                            style: AppTextStyle.lightBlack16spTextStyle1),
                      ],
                    )),
          if (controller.arabicText.isNotEmpty && Utils.isArabic)
            ...List.generate(
                controller.arabicText.length,
                (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRowHeader(
                            icon: AppResources.costIcon,
                            heading: controller.arabicText[index]["title"]),
                        13.verticalSpace,
                        Text(controller.englishText[index]["value"],
                            style: AppTextStyle.lightBlack16spTextStyle1),
                      ],
                    )),
          if (controller.englishText.isNotEmpty && !Utils.isArabic ||
              controller.arabicText.isNotEmpty && Utils.isArabic) ...[
            16.verticalSpace,
            const Divider(color: AppColors.lightGrey1),
            16.verticalSpace
          ],
        ]),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildVideoList() {
    if (controller.videoList.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowHeader(icon: AppResources.supportIcon, heading: 'videoURL'),
          SizedBox(height: 13.h),
          ...controller.videoList.map((url) => GestureDetector(
                onTap: () => Utils.viewLink(url),
                child: Text(
                  url,
                  style: AppTextStyle.lightBlack16spTextStyle1.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.lightBlueColor,
                    color: AppColors.lightBlueColor,
                  ),
                ),
              )),
          SizedBox(height: 16.h),
          const Divider(color: AppColors.lightGrey1),
        ],
      ),
    );
  }

  Widget _buildLinkList() {
    if (controller.englishLink.isNotEmpty && !Utils.isArabic ||
        controller.arabicLink.isNotEmpty && Utils.isArabic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.lightGrey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.englishLink.isNotEmpty && !Utils.isArabic ||
                controller.arabicLink.isNotEmpty && Utils.isArabic) ...[
              _buildRowHeader(icon: AppResources.supportIcon, heading: 'link'),
              13.verticalSpace
            ],
            if (controller.englishLink.isNotEmpty && !Utils.isArabic)
              ...List.generate(
                  controller.englishLink.length,
                  (index) => GestureDetector(
                        onTap: () => Utils.viewLink(
                            controller.englishLink[index]["value"]),
                        child: Text(
                          controller.englishLink[index]["title"],
                          style: AppTextStyle.lightBlack16spTextStyle1.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.lightBlueColor,
                            color: AppColors.lightBlueColor,
                          ),
                        ),
                      )),
            if (controller.arabicLink.isNotEmpty && Utils.isArabic)
              ...List.generate(
                  controller.arabicLink.length,
                  (index) => GestureDetector(
                        onTap: () => Utils.viewLink(
                            controller.englishLink[index]["value"]),
                        child: Text(
                          controller.arabicLink[index]["title"],
                          style: AppTextStyle.lightBlack16spTextStyle1.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.lightBlueColor,
                            color: AppColors.lightBlueColor,
                          ),
                        ),
                      )),
            if (controller.englishLink.isNotEmpty && !Utils.isArabic ||
                controller.arabicLink.isNotEmpty && Utils.isArabic) ...[
              16.verticalSpace,
              const Divider(color: AppColors.lightGrey1),
              16.verticalSpace
            ],
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildAmountList() {
    if (controller.englishAmount.isNotEmpty && !Utils.isArabic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.lightGrey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.englishAmount.isNotEmpty && !Utils.isArabic)
              ...List.generate(
                  controller.englishAmount.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowHeader(
                              icon: AppResources.costIcon,
                              heading: controller.englishAmount[index]
                                  ["title"]),
                          13.verticalSpace,
                          Text(controller.englishAmount[index]["value"],
                              style: AppTextStyle.lightBlack16spTextStyle1),
                        ],
                      )),
            if (controller.arabicAmount.isNotEmpty && Utils.isArabic)
              ...List.generate(
                  controller.arabicAmount.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowHeader(
                              icon: AppResources.costIcon,
                              heading: controller.arabicAmount[index]["title"]),
                          13.verticalSpace,
                          Text(controller.englishAmount[index]["value"],
                              style: AppTextStyle.lightBlack16spTextStyle1),
                        ],
                      )),
            if (controller.englishAmount.isNotEmpty && !Utils.isArabic ||
                controller.arabicAmount.isNotEmpty && Utils.isArabic) ...[
              16.verticalSpace,
              const Divider(color: AppColors.lightGrey1),
              16.verticalSpace
            ],
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildButtonList() {
    if (controller.englishButton.isNotEmpty && !Utils.isArabic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.lightGrey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.englishButton.isNotEmpty && !Utils.isArabic)
              ...List.generate(
                  controller.englishButton.length,
                  (index) => Column(
                        children: [
                          elevatedButton(
                              text: controller.englishButton[index]["title"],
                              onPressed: () {
                                Utils.viewLink(
                                    controller.englishButton[index]["value"]);
                              }),
                          16.verticalSpace,
                        ],
                      )),
            if (controller.arabicAmount.isNotEmpty && Utils.isArabic)
              ...List.generate(
                  controller.arabicButton.length,
                  (index) => Column(
                        children: [
                          elevatedButton(
                              text: controller.arabicButton[index]["title"],
                              onPressed: () {
                                Utils.viewLink(
                                    controller.englishButton[index]["value"]);
                              }),
                          16.verticalSpace,
                        ],
                      )),
            if (controller.englishButton.isNotEmpty && !Utils.isArabic ||
                controller.arabicAmount.isNotEmpty && Utils.isArabic) ...[
              const Divider(color: AppColors.lightGrey1),
              16.verticalSpace
            ],
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Row _buildRowHeader({required String icon, required String heading}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: SvgPicture.asset(
            icon,
            color: AppColors.darkGreyColor1,
            width: 19.5.w,
            height: 19.5.h,
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: Text(
            heading.tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1
                .copyWith(height: 0),
          ),
        ),
      ],
    );
  }

  Widget faqListView() {
    return Obx(() => ExpansionPanelList(
          elevation: 0,
          dividerColor: AppColors.lightGrey,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: controller.expansionCallback,
          children: controller.subFaqs.value.map<ExpansionPanel>((FaQs faq) {
            return ExpansionPanel(
              canTapOnHeader: true,
              backgroundColor: Colors.white,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    Utils.isArabic ? faq.questionArabic : faq.question,
                    style: AppTextStyle.bottomBarTextColor20spTextStyle,
                  ),
                );
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.isArabic ? faq.answerArabic : faq.answer,
                    style: AppTextStyle.secondaryPrimaryBlack20spTextStyle,
                  ),
                  const Divider(
                    color: AppColors.lightGrey,
                  ),
                ],
              ),
              isExpanded: faq.isExpanded,
            );
          }).toList(),
        ));
  }

  Widget startServiceBtn() {
    final serviceUrl = controller.service.startServiceEN;

    if (serviceUrl.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 100,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.showPreview) ...[
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
                minimumSize: Size(Get.width, 45.h),
              ),
              onPressed: () {
                final newLocale = Locale(Utils.isArabic ? "en" : "ar");
                Get.updateLocale(newLocale);
              },
              icon: const Icon(
                Icons.visibility_rounded,
                color: AppColors.primaryDarkBrownColor,
              ),
              label: Text(
                Utils.isArabic ? "previewInEnglish".tr : "previewInArabic".tr,
                maxLines: 1,
                style: AppTextStyle.primaryDarkBrown16spTextStyle1,
              ),
            ),
            16.verticalSpace,
          ],
          elevatedButton(
            text: "startService",
            onPressed: () => controller.startService(serviceUrl),
          ),
        ],
      ),
    );
  }
}
