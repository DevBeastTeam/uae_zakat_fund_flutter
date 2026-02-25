import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class NewsCard extends GetView<HomeViewModel> {
  final News news;
  final bool all;

  const NewsCard({
    super.key,
    required this.news,
    this.all=true
  });

  openNewsDetailsScreen(id) {
    Get.toNamed(AppRoutes.newsDetailScreen,
        arguments: {"id": id, "allNews": all})?.then((val) async {
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openNewsDetailsScreen(news.id),
      child: Container(
        width: 127.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: news.thumbNail != ""
                  ? CachedImage(
                      image: news.thumbNail,
                      width: 117.w,
                      height: 84.h,
                    )
                  : Image.asset(
                      AppResources.placeholder,
                      width: 117.w,
                      height: 84.h,
                      fit: BoxFit.cover,
                    ),
            ),
            8.verticalSpace,
            Text(
              DateFormat('dd MMMM yyyy', Get.locale?.languageCode)
                  .format(news.createdDate),
              style: AppTextStyle.darkGreyOne12spTextStyle,
            ),
            8.verticalSpace,
            Flexible(
              child: Text(
                Utils.isArabic ? news.titleAr : news.titleEn,
                style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
