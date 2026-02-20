import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/project_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/file_view_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ProjectPreviewScreen extends GetView<ProjectPreviewViewModel> {
  const ProjectPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "projectPreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTextField(
                controller: controller.nameInEnglish,
                readOnly: true,
                label: "projectNameInEnglish",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.nameInArabic,
                readOnly: true,
                label: "projectNameInArabic",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.startDate,
                readOnly: true,
                isDate: true,
                label: "startDate",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.endDate,
                readOnly: true,
                isDate: true,
                label: "endDate",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.beneficiariesOfProject,
                readOnly: true,
                label: "beneficiariesOfTheProject",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.noOfBeneficiaries,
                readOnly: true,
                label: "noOfBeneficiaries",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.projectGoal,
                readOnly: true,
                label: "projectGoal",
                amountOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.shortDescriptionInEnglish,
                readOnly: true,
                label: "briefDescriptionInEnglish",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.shortDescriptionInArabic,
                readOnly: true,
                label: "briefDescriptionInArabic",
              ),
              10.verticalSpace,
              textFieldLabel(label: "projectLicense"),
              4.verticalSpace,
              fileViewWidget(
                  isImage: false,
                  value: "${controller.project?.permitRequired}"),
              10.verticalSpace,
              LabelTextField(
                controller: controller.startDateOfPermit,
                readOnly: true,
                isDate: true,
                label: "licenseStartDate",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.endDateOfPermit,
                readOnly: true,
                isDate: true,
                label: "licenseEndDate",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.longDescriptionInEnglish,
                readOnly: true,
                maxLines: 4,
                label: "longDescriptionInEnglish",
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.longDescriptionInArabic,
                readOnly: true,
                maxLines: 4,
                label: "longDescriptionInArabic",
              ),
              10.verticalSpace,
              textFieldLabel(label: "socialMediaLinks"),
              8.verticalSpace,
              LabelTextField(
                controller: controller.instagram,
                label: 'instagram',
                isBlack: true,
                readOnly: true,
                prefixIcon: AppResources.instagramIcon,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.twitter,
                label: 'twitter',
                isBlack: true,
                readOnly: true,
                prefixIcon: AppResources.twitterIcon,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.facebook,
                label: 'facebook',
                isBlack: true,
                readOnly: true,
                prefixIcon: AppResources.facebookIcon,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.linkedIn,
                label: 'linkedIn',
                readOnly: true,
                isBlack: true,
                prefixIcon: AppResources.linkedinIcon,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.webLink,
                label: 'otherLink',
                readOnly: true,
                isBlack: true,
                prefixIcon: AppResources.websiteIcon,
              ),
              10.verticalSpace,
              textFieldLabel(label: "category"),
              4.verticalSpace,
              _buildCategoryWrap(),
              10.verticalSpace,
              textFieldLabel(label: "addQuickAmounts"),
              4.verticalSpace,
              _buildQuickAmountsArap(),
              10.verticalSpace,
              LabelTextField(
                controller: controller.addQuantities,
                label: 'addQuantities',
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.urgentProject,
                label: 'urgentProject',
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.minimumAmountController,
                label: 'addMinimumAmount',
                readOnly: true,
                amountOnly: true,
              ),
              16.verticalSpace,
              _buildFeaturedProject(),
              if (controller.additionalDocuments.isNotEmpty) ...[
                13.verticalSpace,
                Text(
                  "additionalDocuments".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                ),
                ...List.generate(
                    controller.additionalDocuments.length,
                    (index) => additionalDocumentViewWidget(
                        controller.additionalDocuments[index]))
              ],
              13.verticalSpace,
              Text(
                "photosVideosOfProject".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
              ),
              13.verticalSpace,
              _buildImagesGridView(),
              2.verticalSpace,
              _buildBottomActions()
            ],
          )),
    );
  }

  Wrap _buildQuickAmountsArap() {
    return Wrap(
        runSpacing: 8.h,
        spacing: 8.w,
        alignment: WrapAlignment.start,
        children: List.generate(controller.amounts.length, (index) {
          String amount = controller.amounts[index];
          return Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(amount),
            labelStyle: AppTextStyle.lightBrown14spTextStyle3,
            side: BorderSide(color: AppColors.lightBrownColor, width: 1.w),
            backgroundColor: AppColors.chipBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          );
        }).toList());
  }

  Wrap _buildCategoryWrap() {
    return Wrap(
        runSpacing: 8.h,
        spacing: 8.w,
        alignment: WrapAlignment.start,
        children: List.generate(controller.selectedCategories.length, (index) {
          LookupData cat = controller.selectedCategories[index];
          return Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(Utils.isArabic ? cat.nameAr : cat.name),
            labelStyle: AppTextStyle.lightBrown14spTextStyle3,
            side: BorderSide(color: AppColors.lightBrownColor, width: 1.w),
            backgroundColor: AppColors.chipBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          );
        }).toList());
  }

  Container _buildFeaturedProject() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          border: Border.all(color: const Color(0xffD1D0D1), width: 1.w)),
      child: Column(
        children: [
          LabelTextField(
            controller: controller.featuredForAssociation,
            label: 'featuredForAssociation',
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.featuredForAppWeb,
            label: 'featuredForAppWeb',
            readOnly: true,
          ),
          Obx(() => controller.showFeatured.value
              ? Column(
                  children: [
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.titleInArabicController,
                      label: 'titleInArabic',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.titleInEnglishController,
                      label: 'titleInEnglish',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static1EnglishController,
                      label: 'static1English',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static2EnglishController,
                      label: 'static2English',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static1ArabicController,
                      label: 'static1Arabic',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static2ArabicController,
                      label: 'static2Arabic',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static1DescEnglishController,
                      label: 'static1DescArabic',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static2DescArabicController,
                      label: 'static2DescArabic',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static1DescEnglishController,
                      label: 'static1DescEnglish',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.static2DescEnglishController,
                      label: 'static2DescEnglish',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    textFieldLabel(label: "projectCoverForWeb"),
                    4.verticalSpace,
                    fileViewWidget(
                        isImage: false,
                        value: "${controller.project?.projectCoverWeb}"),
                    10.verticalSpace,
                    textFieldLabel(label: "projectCoverForApp"),
                    4.verticalSpace,
                    fileViewWidget(
                        isImage: false,
                        value: "${controller.project?.projectCoverApp}"),
                  ],
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  GridView _buildImagesGridView() {
    return GridView(
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 187.w / 148.h),
      children: List.generate(
          controller.projectImages.length,
          (index) => GestureDetector(
                onTap: () {
                  Utils.openUrl(
                      "${FlavorConfig.storageUrl}${controller.project!.projectImages[index].mediaUrl}");
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: controller.project?.projectImages[index].mediaType == 1
                      ? Stack(
                          children: [
                            FutureBuilder(
                              future: controller.project?.projectImages[index]
                                          .projectId !=
                                      null
                                  ? Utils.urlThumbnail(controller
                                      .project!.projectImages[index].mediaUrl)
                                  : Utils.fileThumbnail(controller
                                      .project!.projectImages[index].mediaUrl),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Image.file(
                                    File(snapshot.data),
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: Get.height,
                                  );
                                } else if (snapshot.hasError) {
                                  return Image.asset(
                                    AppResources.placeholder,
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: Get.height,
                                  );
                                } else {
                                  return Image.asset(
                                    AppResources.placeholder,
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: Get.height,
                                  );
                                }
                              },
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: SvgPicture.asset(
                                  AppResources.playIcon,
                                  width: 33.w,
                                  height: 33.h,
                                ),
                              ),
                            )
                          ],
                        )
                      : GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.photoViewScreen,
                              arguments: controller
                                  .project!.projectImages[index].mediaUrl),
                          child: CachedImage(
                            image: controller
                                .project!.projectImages[index].mediaUrl,
                            width: Get.width,
                            height: Get.height,
                          ),
                        ),
                ),
              )),
    );
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (!controller.isAdmin.value) {
        return SizedBox.shrink();
      }
      return acceptRejectBottomBar(
        onAccept: controller.showAccept
            ? () {
                Utils.showLoadingDialog();
                Get.find<RequestsViewModel>().approveRejectRequest(
                    request: controller.request!, message: "projectAccepted");
              }
            : null,
        onReturn: controller.showReturn
            ? () => Utils.openRejectionScreen(
                  title: "projectReturn",
                  request: controller.request!,
                )
            : null,
        onReject: controller.showReject
            ? () => Utils.openRejectionScreen(
                title: "projectRejection",
                request: controller.request!,
                isRejected: true)
            : null,
      );
    });
  }
}
