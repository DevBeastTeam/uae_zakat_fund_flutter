import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/view/bottom_bar/account/admin_account_screen.dart';
import 'package:zakat_fund/view/bottom_bar/account/association/association_account_screen.dart';
import 'package:zakat_fund/view/bottom_bar/account/company/company_account_screen.dart';
import 'package:zakat_fund/view/bottom_bar/account/individual/individual_account_screen.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';

class AccountScreen extends GetView<AccountViewModel> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.user = userBox.getAt(0);
    controller.initTabController();
    return Container(
      color: Colors.white,
      height: Get.height,
      child: _getRoleBasedScreen(controller.user.roles.first),
    );
  }

  Widget _getRoleBasedScreen(String? role) {
    switch (role?.toLowerCase()) {
      case 'individuals':
        return const IndividualAccountScreen();
      case 'companies':
        return const CompanyAccountScreen();
      case 'orgainizations':
        return const AssociationAccountScreen();
      case 'admin':
        return const AdminAccountScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
