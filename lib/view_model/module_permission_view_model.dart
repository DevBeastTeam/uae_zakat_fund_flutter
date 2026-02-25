import 'package:get/get.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/utils.dart';

abstract class ModulePermissionsViewModel extends GetxController {

  final RxBool isAdmin = false.obs;
  Requests? request;
  late User user;

  bool showAccept = true;
  bool showReturn = true;
  bool showReject = true;
  bool canExport = true;
  bool canAdd = true;
  bool canView = true;
  bool canEdit = true;
  bool canDelete = true;

  @override
  void onInit() {
    _initializeRequestBaseViewModel();
    super.onInit();
  }

  void _initializeRequestBaseViewModel() async {
    final data = Get.arguments;
    request = data["request"];
    final String? code = data["code"];
    _setPermissions(code);
    user = userBox.getAt(0);
  }

  void _setPermissions(String? code) {
    final result = Utils.getModulePermissions(routeArguments: code);
    showAccept = result.canAccept;
    showReturn = result.canReturn;
    showReject = result.canReject;
    canExport = result.canExport;
    canAdd = result.canAdd;
    canView = result.canView;
    canEdit = result.canEdit;
    canDelete = result.canDelete;
  }

}
