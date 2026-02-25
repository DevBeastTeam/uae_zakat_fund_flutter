import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/model/cart.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/cart_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/text_field_widget.dart';

class CartViewModel extends GetxController {
  final CartRepoImpl _cartRepo = CartRepoImpl();
  final MainViewModel _mainViewModel = Get.find<MainViewModel>();

  final RxList<Cart> cart = <Cart>[].obs;
  final RxInt totalAmount = 0.obs;
  final RxInt cartCount = 0.obs;
  final RxInt currentStep = 1.obs;
  final Rxn<int> selectedAmountIndex = Rxn<int>();

  final TextEditingController amount = TextEditingController();
  final FocusNode amountNode = FocusNode();
  late final List<KeyboardActionsItem> keyboardActionsItems;

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.cartScreen);
    keyboardActionsItems = [
      KeyboardActionsItem(focusNode: amountNode, displayArrows: false)
    ];
    super.onInit();
  }

  User get user => userBox.getAt(0);

  void resetData() => currentStep.value = 1;

  void clearData() {
    cart.clear();
    cartCount.value = 0;
  }

  void calculateTotalAmount() {
    totalAmount.value = cart.fold(0, (sum, item) => sum + item.amount.round());
  }

  void completePayment() {
    if (currentStep.value == 1) currentStep.value++;
  }

  Future<void> deleteAllCart() async {
    Utils.showLoadingDialog();
    final isGuest = userBox.isEmpty;
    final userId = isGuest ? 0 : user.empId;

    final apiResponse = await _cartRepo.deleteAllCart(
      request: RequestBody(body: {
        "userId": userId,
        if (isGuest) ...{
          "IsGuest": true,
          "GuestId": uuidBox.getAt(0),
        }
      }),
    );
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      cart.clear();
      cartCount.value = 0;
      calculateTotalAmount();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  quickAddToCart(
      {bool isDonate = false,
      required TextEditingController amount,
      required ProjectElements project}) {
    if (amount.text.trim().isEmpty) {
      Utils.showGlobalSnackBar(
          message: "${"totalAmount".tr} ${"isRequired".tr}");
      return;
    } else if (project.minimumAmount != null) {
      int totalAmount = int.parse(amount.text);
      if (totalAmount < project.minimumAmount) {
        Utils.showGlobalSnackBar(
            message: "${"minDonationAmount".tr} ${project.minimumAmount}");
        return;
      }
    }

    addToCart(
        project: project,
        totalAmount: amount.text,
        isDonate: isDonate,
        fromDialog: true);
  }

  Future<void> addToCart(
      {required ProjectElements project,
      required String totalAmount,
      bool isDonate = false,
      bool fromDialog = false}) async {
    final existing =
        cart.firstWhereOrNull((e) => e.projectId == project.projectId);
    if (existing != null) {
      return updateCartItem(
          cartItem: existing, amount: totalAmount, isDonate: isDonate);
    }

    Utils.showLoadingDialog();
    final isGuest = userBox.isEmpty;
    final userId = isGuest ? 0 : user.empId;

    final apiResponse = await _cartRepo.addToCart(
      request: RequestBody(body: {
        "projectId": project.projectId,
        "userId": userId,
        "amount": totalAmount,
        if (isGuest) ...{
          "IsGuest": true,
          "GuestId": uuidBox.getAt(0),
        }
      }),
    );
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (fromDialog) {
        Get.back();
      }
      cartCount.value++;
      _handleNavigation(isDonate);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future<void> deleteProduct(Cart item) async {
    Utils.showLoadingDialog();

    final apiResponse = await _cartRepo.deleteCartProduct(
      request: RequestBody(
          endPoint: "${ApiConstant.deleteCartProduct}/${item.cartId}"),
    );

    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      cart.remove(item);
      cart.refresh();
      cartCount.value = cart.length;
      calculateTotalAmount();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future<void> updateCartItem({
    required Cart cartItem,
    required String amount,
    bool isUpdate = false,
    bool isDonate = false,
  }) async {
    Utils.showLoadingDialog();

    final apiResponse = await _cartRepo.updateCartItem(
      request: RequestBody(
        endPoint: "${ApiConstant.updateCartItem}/${cartItem.cartId}",
        body: {"cartId": cartItem.cartId, "amount": amount},
      ),
    );

    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (isUpdate) {
        final index = cart.indexOf(cartItem);
        cart[index].amount = double.parse(amount);
        cart.refresh();
      }
      _handleResponse(isDonate: isDonate, isUpdate: isUpdate);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  final amountController = TextEditingController(text: "10");

  Widget _buildQuickAmountChips(List<String> amounts) {
    return Wrap(
      runSpacing: 13.h,
      spacing: 8.w,
      children: List.generate(amounts.length, (index) {
        return Obx(() {
          final isSelected = selectedAmountIndex.value == index;
          final labelText = "${amounts[index]} ${"currency".tr}";
          return RawChip(
            tapEnabled: true,
            onPressed: () {
              selectedAmountIndex.value = index;
              amountController.text = amounts[index];
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(
              labelText,
              style: isSelected
                  ? AppTextStyle.warningBackColor12spTextStyle1
                  : AppTextStyle.lightGray12spTextStyle,
            ),
            side: BorderSide(
                color:
                    isSelected ? themeViewModel.color : AppColors.remindColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            backgroundColor:
                isSelected ? themeViewModel.color : AppColors.greyBackColor,
          );
        });
      }),
    );
  }

  quickDonateDialog(project) {
    final quickAmounts = project?.quickAmount?.split(',') ?? [];
    amountController.clear();
    selectedAmountIndex.value = -1;
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(16.r),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        content: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "quickDonate".tr,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.highlight_remove_outlined,
                      color: AppColors.secondaryPrimaryBlackColor,
                    ),
                  ),
                ],
              ),
              if (quickAmounts.isNotEmpty) ...[
                16.verticalSpace,
                _buildQuickAmountChips(quickAmounts),
              ],
              16.verticalSpace,
              TextFieldWidget(
                white: true,
                hint: "amountDonated",
                focusNode: FocusNode(),
                controller: amountController,
                amount: true,
              ),
              16.verticalSpace,
              SizedBox(
                height: 40.h,
                child: elevatedButton(
                  text: "payNow",
                  onPressed: () {
                    quickAddToCart(
                        isDonate: true,
                        amount: amountController,
                        project: project);
                    // Get.back();
                  },
                ),
              ),
              16.verticalSpace,
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: OutlinedButton(
                  onPressed: () {
                    quickAddToCart(
                        isDonate: false,
                        amount: amountController,
                        project: project);
                    // Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondaryDarkBrownColor,
                    side: const BorderSide(
                        color: AppColors.secondaryDarkBrownColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 12),
                      SizedBox(width: 4),
                      Text("addToCart".tr,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserCart() async {
    final userId = user.empId;
    final items = cart
        .map((item) => {
              "projectId": item.projectId,
              "userId": userId,
              "amount": item.amount
            })
        .toList();

    cartBox.clear();

    final apiResponse = await _cartRepo.updateUserCart(
      request: RequestBody(body: {"items": items}),
    );

    if (apiResponse.appState != AppState.onSuccess) {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future<void> fetchCart({bool showLoading = true}) async {
    if (showLoading) Utils.showLoadingDialog();

    final isGuest = userBox.isEmpty;
    final userId = isGuest ? 0 : (user.empId ?? user.id);

    final apiResponse = await _cartRepo.fetchCart(
      request: RequestBody(queryParameters: {
        "id": userId,
        if (isGuest) ...{
          "IsGuest": true,
          "GuestId": uuidBox.getAt(0),
        }
      }),
    );

    if (showLoading) Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      cart.value = apiResponse.data;
      cartCount.value = cart.length;
      calculateTotalAmount();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _handleResponse({required bool isDonate, required bool isUpdate}) {
    if (isUpdate) {
      calculateTotalAmount();
      Utils.showGlobalSnackBar(message: "updatedSuccessfully".tr);
    } else {
      _handleNavigation(isDonate);
    }
  }

  void _handleNavigation(bool isDonate) {
    if (isDonate) {
      resetData();
      fetchCart(showLoading: true);
      Get.toNamed(AppRoutes.cartScreen);
    } else {
      Utils.showGlobalSnackBar(message: "addedToCart".tr);
    }
  }

  @override
  void onClose() {
    amount.dispose();
    amountNode.dispose();

    cart.close();
    totalAmount.close();
    cartCount.close();
    currentStep.close();

    super.onClose();
  }
}
