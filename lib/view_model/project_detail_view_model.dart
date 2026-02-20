import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';

class ProjectDetailViewModel extends GetxController with GenericMixin {

  final RxInt currentPicIndex = 0.obs;
  final Rxn<int> selectedAmountIndex = Rxn<int>();
  final RxBool isFavorite = false.obs;
  final RxBool isLoading = true.obs;
  bool canDonate = true;

  final CarouselSliderController? carouselController = CarouselSliderController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final FocusNode quantityNode = FocusNode();
  final FocusNode amountNode = FocusNode();

  final cartViewModel = Get.find<CartViewModel>();
  final homeViewmodel = Get.find<HomeViewModel>();
  final genericRepo = GenericRepoImpl();

  late User user;
  late String currentLocale;
  late bool isPreview;

  late List<KeyboardActionsItem> keyboardActionsItem;

  ProjectElements? project;
  int? projectId;


  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.projectDetailsScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: quantityNode, displayArrows: false),
      KeyboardActionsItem(focusNode: amountNode, displayArrows: false),
    ];
    final args = Get.arguments;

    project = args["project"];
    projectId = args["projectId"];
    isPreview = args["isPreview"]??false;

    if (userBox.isNotEmpty) {
      user = userBox.getAt(0);
      final role = user.roles.first;
      if (role == "Admin" || role == "Orgainizations") {
        canDonate = false;
      }
    }

    currentLocale = Get.locale!.languageCode;
    isPreview ? isLoading.value = false : fetchProjectDetails();
  }

  Future<bool> onWillPop() async {
    if (isPreview) {
      Get.updateLocale(Locale(currentLocale));
    }
    Future.microtask(() => Get.back());
    return false;
  }

  void toggleLocale() {
    final newLocale = Utils.isArabic ? const Locale("en") : const Locale("ar");
    Get.updateLocale(newLocale);
  }

  void handleBackPress() {
    if (isPreview) {
      Get.updateLocale(Locale(currentLocale));
    }
    Future.microtask(() => Get.back());
  }

  void updateAmount(int index) {
    selectedAmountIndex.value = index;
    String amountSelected = project?.quickAmount.split(',')[index];
    String qty = quantity.text.trim();
    if (project!.isAddQuantity && qty.isNotEmpty && int.parse(qty) > 0) {
      amount.text = "${int.parse(amountSelected) * int.parse(qty)}";
    } else {
      amount.text = amountSelected;
      quantity.text = "1";
    }
  }

  Future<void> handlePageChange(int index) async {
    final previousIndex = currentPicIndex.value;
    final previousImage = project!.projectImages[previousIndex];
    if (previousImage.mediaType == 1 && previousImage.playerKey?.currentState?.playerController?.value.isPlaying == true) {
      await previousImage.playerKey!.currentState!.playerController?.pause();
    }

    updateIndicator(index);
  }

  String getCat(String id) {
    final category = homeViewmodel.categoriesList.firstWhereOrNull((data) => data.value == int.tryParse(id));
    if (category == null) return "";
    return Utils.isArabic ? category.nameAr : category.name;
  }

  updateTotalAmount() {
    int? index = selectedAmountIndex.value;
    if (quantity.text.isNotEmpty) {
      int qty = int.parse(quantity.text);
      if (qty > 0) {
        String amountSelected = project!.quickAmount.split(',')[index];
        int baseAmount = int.parse(amountSelected);
        amount.text = "${baseAmount * qty}";
      }
    }else{
      amount.text = "";
    }
  }

  void updateIndicator(int index) => currentPicIndex.value = index;



  addToCart({bool isDonate = false}) {
    if (!canDonate) {
      Utils.showGlobalSnackBar(message: "loginAsDonor".tr);
      return;
    }
    if (amount.text.trim().isEmpty) {
      Utils.showGlobalSnackBar(message: "${"totalAmount".tr} ${"isRequired".tr}");
      return;
    } else if (project!.minimumAmount != null) {
      int totalAmount = int.parse(amount.text);
      if (totalAmount < project!.minimumAmount) {
        Utils.showGlobalSnackBar(message: "${"minDonationAmount".tr} ${project!.minimumAmount}");
        return;
      }
    }
    cartViewModel.addToCart(project: project!, totalAmount: amount.text, isDonate: isDonate);
  }

  addToFavorite() async {
    var body = {"projectId": projectId, "userId": user.empId};
    final result = await addProjectToFavourite(body: body);
    if(result){
      isFavorite.value = !isFavorite.value;
    }
  }

  fetchProjectDetails() async {
    Utils.showLoadingDialog();
    final result = await getProjectDetails(projectId!);
    if(result!=null){
      project = result;
      isFavorite.value = project!.isFavorite!;
      isLoading.value = false;
    }
    Utils.hideLoadingDialog();
  }

  String getTitle() => isPreview ? "projectPreview" : "projectDetails";

  @override
  void onClose() {
    quantity.dispose();
    amount.dispose();
    quantityNode.dispose();
    amountNode.dispose();

    currentPicIndex.close();
    selectedAmountIndex.close();
    isFavorite.close();
    isLoading.close();
    super.onClose();
  }

  }
