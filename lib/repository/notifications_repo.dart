import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class NotificationsRepo {
  Future<ApiResponse> userNotifications({required RequestBody request});
  Future<ApiResponse> readNotification({required RequestBody request});
  Future<ApiResponse> deleteNotification({required RequestBody request});
  Future<ApiResponse> notificationDetails({required RequestBody request});
  Future<ApiResponse> cmsNotifications({required RequestBody request});
  Future<ApiResponse> saveNotification({required RequestBody request});
  Future<ApiResponse> updateNotification({required RequestBody request});
}

class NotificationsRepoImpl implements NotificationsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> userNotifications({required RequestBody request}) {
    return _remoteRepo.userNotifications(request: request);
  }

  @override
  Future<ApiResponse> readNotification({required RequestBody request}) {
    return _remoteRepo.readNotification(request: request);
  }

  @override
  Future<ApiResponse> deleteNotification({required RequestBody request}) {
    return _remoteRepo.deleteNotification(request: request);
  }

  @override
  Future<ApiResponse> notificationDetails({required RequestBody request}) {
    return _remoteRepo.notificationDetails(request: request);
  }

  @override
  Future<ApiResponse> cmsNotifications({required RequestBody request}) {
    return _remoteRepo.cmsNotifications(request: request);
  }

  @override
  Future<ApiResponse> saveNotification({required RequestBody request}) {
    return _remoteRepo.saveNotification(request: request);
  }

  @override
  Future<ApiResponse> updateNotification({required RequestBody request}) {
    return _remoteRepo.updateNotification(request: request);
  }
}
