import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/cms_about_us_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class CMSAboutUsScreen extends GetView<CMSAboutUsViewModel> {
  const CMSAboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(
        title: "aboutUs",
        customActions: [],
      ),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() {
        final config = controller.aboutUsConfig.value;
        if (config == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("aboutUs".tr),
            _buildDualFieldRow(
                "aboutUs".tr, "AboutSahemEn", "aboutUs".tr, "AboutSahemAr"),
            if (config.sections.isNotEmpty) ...[
              _buildSectionTitle("cmsSectionHeader".tr),
              ...List.generate(
                  config.sections.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDualFieldRow(
                              "${"cmsSectionHeader".tr} ${index + 1} ${"cmsHeadingLabel".tr}",
                              "sections[$index].SectionHeadingEn",
                              "${"cmsSectionHeader".tr} ${index + 1} ${"cmsHeadingLabel".tr}",
                              "sections[$index].SectionHeadingAr"),
                          _buildDualFieldRow(
                              "${"cmsSectionHeader".tr} ${index + 1} ${"cmsDetailsLabel".tr}",
                              "sections[$index].SectionDetailsEn",
                              "${"cmsSectionHeader".tr} ${index + 1} ${"cmsDetailsLabel".tr}",
                              "sections[$index].SectionDetailsAr"),
                          _buildFilePicker("sections[$index].SectionImage",
                              "${"cmsSectionHeader".tr} ${index + 1} ${"cmsImageLabel".tr}"),
                          if (index < config.sections.length - 1)
                            20.verticalSpace,
                        ],
                      )),
            ],
            _buildSectionTitle("missionAndVision".tr),
            _buildDualFieldRow("missionSubject".tr, "MissionSubjectEn",
                "missionSubject".tr, "MissionSubjectAr"),
            _buildDualFieldRow("missionDetails".tr, "MissionDetailsEn",
                "missionDetails".tr, "MissionDetailsAr"),
            _buildDualFieldRow("visionDetails".tr, "VisionDetailsEn",
                "visionDetails".tr, "VisionDetailsAr"),
            if (config.corporateValuesSections.isNotEmpty) ...[
              _buildSectionTitle("corporateValues".tr),
              ...List.generate(
                  config.corporateValuesSections.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDualFieldRow(
                              "${"corporateValues".tr} ${"cmsHeadingLabel".tr} ${index + 1}",
                              "corporateValuesSections[$index].CorporateValuesHeadingEn",
                              "${"corporateValues".tr} ${"cmsHeadingLabel".tr} ${index + 1}",
                              "corporateValuesSections[$index].CorporateValuesHeadingAr"),
                          _buildDualFieldRow(
                              "${"corporateValues".tr} ${"cmsDetailsLabel".tr} ${index + 1}",
                              "corporateValuesSections[$index].CorporateValuesDetailsEn",
                              "${"corporateValues".tr} ${"cmsDetailsLabel".tr} ${index + 1}",
                              "corporateValuesSections[$index].CorporateValuesDetailsAr"),
                          if (index < config.corporateValuesSections.length - 1)
                            16.verticalSpace,
                        ],
                      )),
            ],
            if (config.strategicGoalsSections.isNotEmpty) ...[
              _buildSectionTitle("strategicGoals".tr),
              ...List.generate(
                  config.strategicGoalsSections.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDualFieldRow(
                              "${"strategicGoals".tr} ${"cmsDetailsLabel".tr} ${index + 1}",
                              "strategicGoalsSections[$index].StrategicGoalsDetailsEn",
                              "${"strategicGoals".tr} ${"cmsDetailsLabel".tr} ${index + 1}",
                              "strategicGoalsSections[$index].StrategicGoalsDetailsAr"),
                          if (index < config.strategicGoalsSections.length - 1)
                            16.verticalSpace,
                        ],
                      )),
            ],
            if (config.teamMembers.isNotEmpty) ...[
              _buildSectionTitle("ourTeam".tr),
              ...List.generate(
                  config.teamMembers.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDualFieldRow(
                              "${"ourTeamMember".tr} ${"cmsNameLabel".tr} ${index + 1}",
                              "teamMembers[$index].OurTeamMemberNameEn",
                              "${"ourTeamMember".tr} ${"cmsNameLabel".tr} ${index + 1}",
                              "teamMembers[$index].OurTeamMemberNameAr"),
                          _buildDualFieldRow(
                              "${"ourTeamMember".tr} ${"cmsJobTitleLabel".tr}",
                              "teamMembers[$index].OurTeamMemberJobTitleEn",
                              "${"ourTeamMember".tr} ${"cmsJobTitleLabel".tr}",
                              "teamMembers[$index].OurTeamMemberJobTitleAr"),
                          _buildFilePicker(
                              "teamMembers[$index].OurTeamMemberImage",
                              "${"ourTeamMember".tr} ${"cmsImageLabel".tr}",
                              buttonLabel: "chooseFile".tr,
                              isRequired: true),
                          if (index < config.teamMembers.length - 1)
                            24.verticalSpace,
                        ],
                      )),
            ],
            30.verticalSpace,
            _buildActionButtons(),
            20.verticalSpace,
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        title,
        style: AppTextStyle.secondaryPrimaryBlack16spTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  Widget _buildDualFieldRow(
      String labelEn, String keyEn, String labelAr, String keyAr) {
    bool isArabic = Get.locale?.languageCode == 'ar';
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: _buildTextFieldWidget(
        isArabic ? labelAr : labelEn,
        isArabic ? keyAr : keyEn,
        isArabic: isArabic,
      ),
    );
  }

  Widget _buildTextFieldWidget(String label, String key,
      {bool isArabic = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.primaryDarkGrey12spTextStyle1.copyWith(
            color: AppColors.primaryDarkGreyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.verticalSpace,
        Obx(() => TextFormField(
              controller: controller.editControllers[key],
              enabled: controller.isEditMode.value,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              maxLines: null,
              decoration: InputDecoration(
                fillColor: AppColors.greyBackColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            )),
      ],
    );
  }

  Widget _buildFilePicker(String key, String label,
      {String buttonLabel = "Select File", bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1.copyWith(
                color: AppColors.primaryDarkGreyColor,
                fontWeight: FontWeight.w500,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
              ],
            ),
          ),
          8.verticalSpace,
          Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.greyBackColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.editControllers[key]?.text ??
                            "noFileChosen".tr,
                        style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    16.horizontalSpace,
                    ElevatedButton(
                      onPressed: controller.isEditMode.value
                          ? () => controller.pickImage(key)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: const BorderSide(color: AppColors.lightGrey),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.file_upload_outlined, size: 18.sp),
                          8.horizontalSpace,
                          Text(buttonLabel, style: TextStyle(fontSize: 12.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          4.verticalSpace,
          Text(
            "supportedFormatsMsg".tr,
            style: AppTextStyle.primaryDarkGrey12spTextStyle1
                .copyWith(fontSize: 10.sp, color: AppColors.darkGreyColor),
          ),
          Text(
            "maxSizeMsg".tr,
            style: AppTextStyle.primaryDarkGrey12spTextStyle1
                .copyWith(fontSize: 10.sp, color: AppColors.darkGreyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () => controller.saveAboutUs(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                  0xffC5B38B), // Matching the goldish brown in screenshot
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "save".tr,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp),
            ),
          ),
        ),
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: OutlinedButton(
                  onPressed: () => controller.isEditMode.value = true,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xff5D3B26)),
                    backgroundColor: const Color(0xffF3EFED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    "edit".tr,
                    style: TextStyle(
                        color: const Color(0xff5D3B26),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  ),
                ),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => controller.cancelEdit(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF7F7F7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    "cancel".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
