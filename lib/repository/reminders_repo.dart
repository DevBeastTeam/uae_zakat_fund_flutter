import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class RemindersRepo {
  Future<ApiResponse> allReminders({required RequestBody request});
  Future<ApiResponse> deleteReminder({required RequestBody request});
  Future<ApiResponse> addDonationReminder({required RequestBody request});
  Future<ApiResponse> updateDonationReminder({required RequestBody request});
  Future<ApiResponse> addGuestReminder({required RequestBody request});
  Future<ApiResponse> addUpdateProjectAlerts({required RequestBody request});
  Future<ApiResponse> projectAlerts({required RequestBody request});
}

class RemindersRepoImpl implements RemindersRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> allReminders({required RequestBody request}) {
    return _remoteRepo.allReminders(request: request);
  }

  @override
  Future<ApiResponse> deleteReminder({required RequestBody request}) {
    return _remoteRepo.deleteReminder(request: request);
  }


  @override
  Future<ApiResponse> addDonationReminder({required RequestBody request}) {
    return _remoteRepo.addDonationReminder(request: request);
  }

  @override
  Future<ApiResponse> updateDonationReminder({required RequestBody request}) {
    return _remoteRepo.updateDonationReminder(request: request);
  }

  @override
  Future<ApiResponse> addGuestReminder({required RequestBody request}) {
    return _remoteRepo.addGuestReminder(request: request);
  }

  @override
  Future<ApiResponse> addUpdateProjectAlerts({required RequestBody request}) {
    return _remoteRepo.addUpdateProjectAlerts(request: request);
  }

  @override
  Future<ApiResponse> projectAlerts({required RequestBody request}) {
    return _remoteRepo.projectAlerts(request: request);
  }

}
