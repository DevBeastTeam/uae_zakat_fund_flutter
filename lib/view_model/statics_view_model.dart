import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/statics_insights.dart';
import 'package:zakat_fund/repository/home_repo.dart';
import 'package:zakat_fund/utils/utils.dart';

class StaticsViewModel extends GetxController {
  final homeRepo = HomeRepoImpl();
  Rxn<StaticsInsights> statistics = Rxn<StaticsInsights>();

  @override
  Future<void> onInit() async {
    fetchStatics();
    super.onInit();
  }

  Future fetchStatics() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await homeRepo.mobileDashboardStats(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      statistics.value = apiResponse.data;
      statistics.refresh();
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }
}
