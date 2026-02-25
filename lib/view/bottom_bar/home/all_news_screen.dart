import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/association_detail_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AllNewsScreen extends GetView<AssociationDetailViewModel> {
  const AllNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: myAppBar(title: "news"),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
        itemCount: controller.news.length,
        separatorBuilder: (BuildContext context, _) => 16.verticalSpace,
        itemBuilder: (BuildContext context, int index) {
          News news = controller.news[index];
          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.newsDetailScreen,
                arguments: {"id": news.id, "allNews": false}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15.r)),
                  child: news.thumbNail != ""
                      ? CachedImage(
                          image: news.thumbNail,
                          width: Get.width,
                          height: 200.h,
                        )
                      : Image.asset(
                          AppResources.placeholder,
                          width: Get.width,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(15.r)),
                    border: Border(
                      left: BorderSide(color: AppColors.lightGrey, width: 1.w),
                      bottom:
                          BorderSide(color: AppColors.lightGrey, width: 1.w),
                      right: BorderSide(color: AppColors.lightGrey, width: 1.w),
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          controller.dateFormat.format(news.createdDate),
                          style: AppTextStyle.darkGreyOne12spTextStyle,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        Utils.isArabic ? news.titleAr : news.titleEn,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.secondaryBlack16spTextStyle,
                      ),
                      8.verticalSpace,
                      Text(
                        Utils.isArabic ? Utils.htmlToPlainText(news.descriptionShortAR) : Utils.htmlToPlainText(news.descriptionShortEN),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.secondaryBlack14spTextStyle1,)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
