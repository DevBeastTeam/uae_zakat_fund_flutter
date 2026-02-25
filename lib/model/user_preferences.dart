import 'package:zakat_fund/utils/constants/app_constant.dart';

class UserPreferences {
  final String name;
  List<String> choices;
  int selectedChoice;
  bool show;

  UserPreferences({
    required this.name,
    this.choices=AppConstant.popUpCloseButtons,
    this.selectedChoice = 0,
    this.show = true,
  });
}
