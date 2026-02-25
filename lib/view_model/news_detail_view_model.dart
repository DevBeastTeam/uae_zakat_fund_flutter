import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/media_center_view_model.dart';

class NewsDetailViewModel extends GetxController with GenericMixin {

  final RxBool loading = true.obs;
  final Rx<News> news = News.empty().obs;

  final ScrollController scrollController = ScrollController();

  late final User user;
  late final String currentLocale;
  late final bool isAllNews;
  late final bool isPreview;
  late final int? newsId;
  late final MediaCenterViewModel newsViewModel;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.newsDetailsScreen);
    currentLocale  = Get.locale!.languageCode;
    var data = Get.arguments;
    newsId = data["id"];
    isAllNews = data["allNews"]??false;
    isPreview = data["preview"] ?? false;
    News? newsData = data["news"];
    if (isPreview&&newsData!=null) {
      news.value = newsData;
      loading.value = false;
    } else {
      newsDetails();
    }

    if (isAllNews) {
      if(Get.isRegistered<MediaCenterViewModel>()){
        newsViewModel = Get.find<MediaCenterViewModel>();
      }else{
        newsViewModel = Get.put(MediaCenterViewModel());

      }
    }
    if (userBox.isNotEmpty) {
      user = userBox.getAt(0);
    }
  }

  newsDetails() async {
    Utils.showLoadingDialog();
    final result = await getNewsDetails(newsId!);
    if(result!=null){
      news.value = result;
      loading.value = false;
    }
    Utils.hideLoadingDialog();
  }

  addToFavorite() async {
    var body = {
      "newsId": newsId,
      "userId": user.id,
      "isFavorite": !news.value.isFavorite
    };
    final result = await addNewsToFavourite(body: body);
    if(result){
      news.value.isFavorite = !news.value.isFavorite;
      news.refresh();
    }
  }

  onWillPopScope(){
    if (isPreview) {
      Get.updateLocale(Locale(currentLocale));
    }
    Future.microtask(() => Get.back());
    return Future.value(false);
  }

  viewRecentPressRelease(int index,int id){
    if (news.value.id != newsViewModel.allNews[index].id) {
      Get.back(result: id);
    } else {
      scrollController.animateTo(0.0,
          duration:
          const Duration(milliseconds: 500),
          curve: Curves.ease);
    }
  }

  showPreview(){
    if (isPreview) {
      Get.updateLocale(Locale(currentLocale));
    }
    Future.microtask(() => Get.back());
  }

  @override
  void onClose() {
    scrollController.dispose();

    loading.close();
    news.close();
    super.onClose();
  }

}
