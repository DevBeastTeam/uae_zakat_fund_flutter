import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/project_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/static_page.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/home_repo.dart';
import 'package:zakat_fund/repository/notifications_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/campaigns_view_model.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/view_model/payment_method_view_model.dart';
import 'package:zakat_fund/view_model/services_view_model.dart';
import 'package:zakat_fund/view_model/statics_view_model.dart';

class MainViewModel extends GetxController {
  final currentIndex = 0.obs;
  final notificationCount = 0.obs;
  final showPaymentMethod = false.obs;
  final goNext = false.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final viewModel = Get.put(AccountViewModel());
  final homeRepo = HomeRepoImpl();
  final repo = GenericRepoImpl();
  final notificationRepo = NotificationsRepoImpl();

  final menu = <StaticPage>[].obs;
  final projects = <ProjectElements>[].obs;
  final selectedProjectsList = <ProjectElements>[].obs;
  List<ProjectElements> allProjects = [];
  List<Notifications> notifications = [];

  List<DashboardData> bottomNavItems = [
    DashboardData(
        title: "home",
        value: AppResources.homeFillIcon,
        icon: AppResources.homeUnFillIcon),
    DashboardData(
        title: "services",
        value: AppResources.servicesFillIcon,
        icon: AppResources.servicesUnFillIcon),
    DashboardData(
        title: "projects",
        value: AppResources.projectsFillIcon,
        icon: AppResources.projectsUnFillIcon),
    DashboardData(
        title: "statics",
        value: AppResources.staticsFillIcon,
        icon: AppResources.staticsUnFillIcon),
    DashboardData(
        title: "profile",
        value: AppResources.profileFill,
        icon: AppResources.profileUnfill),
  ];

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void addMenuPages() {
    menu.addAll([
      StaticPage(pageTitleEN: "aboutSahem"),
      StaticPage(pageTitleEN: "projects"),
      StaticPage(pageTitleEN: "associations"),
      StaticPage(pageTitleEN: "ourServices"),
      //StaticPage(pageTitleEN: "mediaCenter"),
      StaticPage(pageTitleEN: "faq"),
      StaticPage(pageTitleEN: "contactUs"),
    ]);
  }

  Future<void> switchTab(int index) async {
    if (index == currentIndex.value) return;
    switch (index) {
      case 0:
        Get.find<HomeViewModel>().refreshData();
        break;
      case 1:
        Get.delete<OurServiceViewModel>();
        break;
      case 2:
        Get.delete<CampaignsViewModel>();
        break;
      case 3:
        Get.put(StaticsViewModel());
        break;
      case 4:
        if (userBox.isNotEmpty) {
          await viewModel.fetchProfile();
          return;
        }
        break;
    }
    currentIndex.value = index;
  }

  int getTotalAmount() =>
      selectedProjectsList.fold(0, (sum, proj) => sum + (proj.price ?? 0));

  Future fetchProjects() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await homeRepo.fetchProjects(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allProjects = apiResponse.data
          .where((project) => project.requestStatus == 2)
          .toList();
      projects.value = List.from(allProjects);
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  addQuickProjects() async {
    Utils.showLoadingDialog();
    List<ProjectData> projectData = selectedProjectsList
        .map((proj) =>
            ProjectData(projectId: proj.projectId!, amount: proj.price))
        .toList();
    final requestBody = {
      "projectData": projectData.map((e) => e.toJson()).toList(),
      if (userBox.isEmpty) ...{
        "isGuest": true,
        "guestId": uuidBox.getAt(0),
        "userId": 0,
      }
    };
    ApiResponse apiResponse =
        await repo.addQuickProjects(request: RequestBody(body: requestBody));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Get.delete<PaymentMethodViewModel>();
      Get.put(PaymentMethodViewModel(false));
      showPaymentMethod.value = true;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  logOut() async {
    Utils.showLoadingDialog();
    notificationCount.value = 0;
    final homeViewModel = Get.find<HomeViewModel>();
    await homeViewModel.addDevice(isLogout: true);
    await userBox.clear();
    await switchAccountBox.clear();
    final accountViewModel = Get.find<AccountViewModel>();
    accountViewModel.initAccountTabs();
    accountViewModel.permissions.clear();
    Get.find<CartViewModel>().clearData();
    currentIndex.value = 0;
    showChangePasswordBox.clear();
    Utils.hideLoadingDialog();
    Get.back();
  }

  addContentRating(
      {required int pageId, required String type, required bool yes}) async {
    final user = userBox.isNotEmpty ? userBox.getAt(0) : null;
    Utils.showLoadingDialog();
    var body = {
      "PageId": pageId,
      "UserId": user?.empId ?? 0,
      "AssociatedId": user?.accountId ?? 0,
      "Description": "",
      "Type": type,
      "ContentRate": yes
    };
    ApiResponse apiResponse =
        await repo.contentRating(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  chatBot() {
    Utils.logEvent(name: EventConstant.chatBotScreen);
    Get.toNamed(AppRoutes.webViewScreen, arguments: {
      "title": "chatbot".tr,
      "url": '${ApiConstant.chatBotUrl}index${Utils.isArabic ? "" : "En"}.xhtml'
    });
  }

  customerPulseSurvey() {
    Utils.logEvent(name: EventConstant.customerPulseSurveyScreen);
    Get.toNamed(AppRoutes.webViewScreen, arguments: {
      "title": "customerPulseSurvey".tr,
      "url":
          '${FlavorConfig.customerPulseUrl}${Utils.isArabic ? "ar" : "en"}&app_id=${FlavorConfig.appId}'
    });
  }

  Future fetchNotifications() async {
    if (userBox.isEmpty) return;
    final User user = userBox.getAt(0);
    ApiResponse apiResponse = await notificationRepo.userNotifications(
        request: RequestBody(
            endPoint:
                "${ApiConstant.userNotifications}/${user.empId ?? user.id}"));
    if (apiResponse.appState == AppState.onSuccess) {
      notifications = apiResponse.data;
      notificationCount.value =
          notifications.where((notification) => !notification.isMark).length;
    }
  }

  void handleDrawerNavigation(StaticPage option) {
    Get.back();

    final String route = option.pageTitleEN ?? '';

    final Map<String, void Function()> predefinedRoutes = {
      "aboutSahem": () => Get.toNamed(AppRoutes.aboutSahemScreen),
      "projects": () {
        Get.find<MainViewModel>().currentIndex.value = 2;
      },
      "faq": () => Get.toNamed(AppRoutes.faqScreen),
      //"mediaCenter": () => Get.toNamed(AppRoutes.mediaCenterScreen),
      "ourServices": () {
        Get.find<MainViewModel>().currentIndex.value = 1;
      },
      "associations": () => Get.toNamed(AppRoutes.allAssociationsScreen),
      "contactUs": () => Get.toNamed(AppRoutes.contactUsScreen),
      "addFeedback": () => Get.toNamed(AppRoutes.addFeedbackScreen),
    };

    if (predefinedRoutes.containsKey(route)) {
      predefinedRoutes[route]!();
    } else {
      final lang = Utils.isArabic ? "ar" : "en";
      final url =
          '${FlavorConfig.webSiteUrl}page/${option.pageLink}?mobile=true&lang=$lang';
      Utils.logEvent(
        name: EventConstant.staticPageScreen,
        parameters: {"pageUrl": url},
      );

      Get.toNamed(AppRoutes.webViewScreen, arguments: {
        "title": Utils.isArabic
            ? option.pageTitleAR ?? option.pageTitleEN
            : option.pageTitleEN,
        "isStaticPage": true,
        "url": url,
      });
    }
  }

  @override
  void onClose() {
    currentIndex.close();
    notificationCount.close();
    showPaymentMethod.close();
    goNext.close();
    menu.close();
    projects.close();
    selectedProjectsList.close();
    super.onClose();
  }
}
