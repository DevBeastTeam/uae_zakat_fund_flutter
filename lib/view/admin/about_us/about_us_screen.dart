import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("About Us"),
          _buildDualFieldRow("About Us (English)", "aboutSahemEn",
              "About Us (Arabic)", "aboutSahemAr"),
          _buildSectionTitle("Section"),
          ...List.generate(
              3,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDualFieldRow(
                          "Section ${index + 1} Heading (English)",
                          "section_${index}_headingEn",
                          "Section ${index + 1} Heading (Arabic)",
                          "section_${index}_headingAr"),
                      _buildDualFieldRow(
                          "Section ${index + 1} Details (English)",
                          "section_${index}_detailsEn",
                          "Section ${index + 1} Details (Arabic)",
                          "section_${index}_detailsAr"),
                      _buildFilePicker("section_${index}_image",
                          "Section ${index + 1} Image"),
                      if (index < 2) 20.verticalSpace,
                    ],
                  )),
          _buildSectionTitle("Our Mission & Vision"),
          _buildDualFieldRow("Mission Subject (English)", "missionSubjectEn",
              "Mission Subject (Arabic)", "missionSubjectAr"),
          _buildDualFieldRow("Mission Details (English)", "missionDetailsEn",
              "Mission Details (Arabic)", "missionDetailsAr"),
          _buildDualFieldRow("Vision Details (English)", "visionDetailsEn",
              "Vision Details (Arabic)", "visionDetailsAr"),
          _buildSectionTitle("The entity Vision and Mission"),
          _buildSectionTitle("Corporate Values"),
          ...List.generate(
              3,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDualFieldRow(
                          "Corporate Values Heading (English) ${index + 1}",
                          "corporateValue_${index}_headingEn",
                          "Corporate Values Heading (Arabic) ${index + 1}",
                          "corporateValue_${index}_headingAr"),
                      _buildDualFieldRow(
                          "Corporate Values Details (English) ${index + 1}",
                          "corporateValue_${index}_detailsEn",
                          "Corporate Values Details (Arabic) ${index + 1}",
                          "corporateValue_${index}_detailsAr"),
                      if (index < 2) 16.verticalSpace,
                    ],
                  )),
          _buildSectionTitle("Strategic Goals"),
          ...List.generate(
              3,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDualFieldRow(
                          "Strategic Goals Details (English) ${index + 1}",
                          "strategicGoal_${index}_detailsEn",
                          "Strategic Goals Details (Arabic) ${index + 1}",
                          "strategicGoal_${index}_detailsAr"),
                      if (index < 2) 16.verticalSpace,
                    ],
                  )),
          _buildSectionTitle("Our Team"),
          ...List.generate(
              4,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDualFieldRow(
                          "Our TeamMember Name (English) ${index + 1}",
                          "teamMember_${index}_nameEn",
                          "Our TeamMember Name (Arabic) ${index + 1}",
                          "teamMember_${index}_nameAr"),
                      _buildDualFieldRow(
                          "Our TeamMember JobTitle (English)",
                          "teamMember_${index}_jobEn",
                          "Our TeamMember JobTitle (Arabic)",
                          "teamMember_${index}_jobAr"),
                      _buildFilePicker(
                          "teamMember_${index}_image", "Our TeamMember Image",
                          buttonLabel: "Choose File", isRequired: true),
                      if (index < 3) 24.verticalSpace,
                    ],
                  )),
          30.verticalSpace,
          _buildActionButtons(),
          20.verticalSpace,
        ],
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldWidget(labelEn, keyEn),
        16.verticalSpace,
        _buildTextFieldWidget(labelAr, keyAr, isArabic: true),
        16.verticalSpace,
      ],
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
                            "No file chosen",
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
            "Supported Formats: PNG, JPEG and SVG",
            style: AppTextStyle.primaryDarkGrey12spTextStyle1
                .copyWith(fontSize: 10.sp, color: AppColors.darkGreyColor),
          ),
          Text(
            "Maximum Size: 5MB",
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
              "Save",
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
                    "Edit",
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
                    "Cancel",
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
