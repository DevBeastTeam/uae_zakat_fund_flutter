import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/ads.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class PopUpDialog extends StatelessWidget {
  final Ads ads;

  const PopUpDialog({super.key, required this.ads});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: SafeArea(
        child: Center(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          width: Get.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: ads.adLanguage==1?TextDirection.ltr:TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(
                      AppResources.closeCircleIcon,
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(ads.icon!=null&&ads.icon!="")Image.network(
                        "${FlavorConfig.storageUrl}${ads.icon}",
                        width: 50.w,
                        height: 50.h,
                      ),
                      Flexible(
                        child: Text(
                          getTitle(),
                          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                        ),
                      ),
                    ],
                  ),

                  10.verticalSpace,
                  Text(
                    getDetails(),
                    style: AppTextStyle.darkGreyOne14spTextStyle2.copyWith(color: ads.adType==1?Utils.hexToColor(ads.bannerTextColor):null),
                  ),
                  if(ads.adsImage!=null&&ads.adsImage!="")16.verticalSpace,
                  if(ads.adsImage!=null&&ads.adsImage!="")ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CachedImage(
                      image: ads.adsImage!,
                      width: Get.width,
                      height: 450.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  String getTitle(){
    String title = "";
    if(ads.adLanguage==1){
      title = ads.adTitleEn;
    }else{
      title = ads.adTitleAr;
    }
    return title;
  }

  String getDetails(){
    String details = "";
    if(ads.adLanguage==1){
      details = ads.adDetailEn;
    }else{
      details = ads.adDetailAr;
    }

    return details;
  }


}
