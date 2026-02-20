import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/company_association_info.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class UaeRoleViewModel extends GetxController {

  final RxInt selectedRole = 5.obs;

  final Rxn<String> selectedCompany = Rxn<String>();
  final Rxn<String> selectedAssociation = Rxn<String>();

  late LogInViewModel loginViewModel;

  User? user;

  bool isUaePass = true;

  List<String> companiesList = [];
  List<String> associationsList = [];
  bool fromLogin = false;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    var data = Get.arguments;
    fromLogin = Get.isRegistered<LogInViewModel>();
    if(fromLogin){
      loginViewModel = Get.find<LogInViewModel>();
    }
    user = data["user"];
    isUaePass = data["isUaePass"];
    companiesList = _getAccountNames(user?.companyList ?? []);
    associationsList = _getAccountNames(user?.associationList ?? []);
  }

  List<String> _getAccountNames(List<CompanyAndAssociationInfo> accounts) {
    return accounts
        .map((account) =>
            Utils.isArabic ? account.accountNameArabic : account.accountName)
        .toSet()
        .toList();
  }

  Future<void> logIn() async {
    if (!_validateSelections()) return;
    Utils.showLoadingDialog();
    if(!fromLogin){
      await clearData();
    }
    await switchAccountBox.add(user?.clone());
    _setUserRoleAndInfo();
    if(fromLogin)await _handleRememberMe();
    userBox.add(user);
    await Utils.updateUserPreferences(false, multiRole: true);
  }

  bool _validateSelections() {
    if (selectedRole.value == 5) {
      Utils.showGlobalSnackBar(message: "pleaseSelectAccount".tr);
      return false;
    }
    if (selectedRole.value == 1 && selectedAssociation.value == null) {
      Utils.showGlobalSnackBar(message: "pleaseSelectAssociationAccount".tr);
      return false;
    }
    if (selectedRole.value == 2 && selectedCompany.value == null) {
      Utils.showGlobalSnackBar(message: "pleaseSelectCompanyAccount".tr);
      return false;
    }

    return true;
  }

  void _setUserRoleAndInfo() {
    if (selectedRole.value == 0) {
      user?.roles = ["Individuals"];
      user?.accountId = 0;
      return;
    }

    CompanyAndAssociationInfo? info = _getSelectedAccountInfo();
    if (info != null) {
      user?.roles = selectedCompany.value != null ? ["Companies"] : ["Orgainizations"];
      user?.accountId = info.accountId;
      user?.id = info.userId;
      user?.photo = "${FlavorConfig.storageUrl}${info.accountLogo}";
    }
  }

  CompanyAndAssociationInfo? _getSelectedAccountInfo() {

    final selectedName = selectedCompany.value ?? selectedAssociation.value;
    if (selectedName == null) return null;

    final isCompany = selectedCompany.value != null;
    final list = isCompany ? user?.companyList : user?.associationList;

    return list?.firstWhereOrNull((account) =>
    (Utils.isArabic ? account.accountNameArabic : account.accountName) == selectedName);

  }

  Future<void> _handleRememberMe() async {
    await rememberMeBox.clear();
    if (loginViewModel.rememberMe.value) {
      await rememberMeBox.add({
        "email": loginViewModel.phoneEmailController.text,
        "password": loginViewModel.passwordController.text,
      });
    }
  }

  onBackPressed(){
    if(fromLogin)loginViewModel.signOut();
    Get.back();
  }

  onAccountChange(int index){
    if (selectedRole.value == index) return;
    selectedRole.value = index;
    selectedAssociation.value = null;
    selectedCompany.value = null;
  }

  @override
  void onClose() {
    selectedRole.close();
    selectedCompany.close();
    selectedAssociation.close();
    super.onClose();
  }

  Future clearData() async {
    final mainViewModel = Get.find<MainViewModel>();
    mainViewModel.notificationCount.value = 0;
    final homeViewModel = Get.find<HomeViewModel>();
    await homeViewModel.addDevice(isLogout: true);
    await userBox.clear();
    await switchAccountBox.clear();
    final accountViewModel = Get.find<AccountViewModel>();
    accountViewModel.initAccountTabs();
    accountViewModel.permissions.clear();
    Get.find<CartViewModel>().clearData();
    mainViewModel.currentIndex.value = 0;
  }

}
