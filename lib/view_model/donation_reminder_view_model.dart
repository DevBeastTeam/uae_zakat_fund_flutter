import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/donation_reminders.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/reminders_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class DonationReminderViewModel extends GetxController {
  RxList<DonationReminder> reminders = <DonationReminder>[].obs;
  final repo = RemindersRepoImpl();
  List<String> monthsList = [];

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.donationReminderScreen);
    monthsList = List.generate(
        12, (index) => "${"every".tr} ${index + 1} ${"months".tr}");
    fetchReminders();
    super.onInit();
  }

  fetchReminders() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.allReminders(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      reminders.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  deleteReminder(DonationReminder reminder) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteReminder(request: RequestBody(endPoint: "${ApiConstant.deleteReminder}${reminder.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message:"reminderDeletedSuccessfully".tr);
      reminders.remove(reminder);
    } else{
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    reminders.close();

    super.onClose();
  }

}
