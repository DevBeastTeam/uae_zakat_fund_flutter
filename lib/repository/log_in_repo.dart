import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class LogInRepo {
  Future<ApiResponse> logIn({required RequestBody request});
  Future<ApiResponse> socialRegister({required RequestBody request});
  Future<ApiResponse> appleInfo({required RequestBody request});
  Future<ApiResponse> saveUaeUser({required RequestBody request});
  Future<ApiResponse> uaeIdExist({required RequestBody request});
  Future<ApiResponse> biometricAuth({required RequestBody request});
}

class LogInRepoImpl implements LogInRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> logIn({required RequestBody request}) {
    return _remoteRepo.logIn(request: request);
  }

  @override
  Future<ApiResponse> socialRegister({required RequestBody request}) {
    return _remoteRepo.socialRegister(request: request);
  }

  @override
  Future<ApiResponse> appleInfo({required RequestBody request}) {
    return _remoteRepo.appleInfo(request: request);
  }

  @override
  Future<ApiResponse> saveUaeUser({required RequestBody request}) {
    return _remoteRepo.saveUaeUser(request: request);
  }

  @override
  Future<ApiResponse> uaeIdExist({required RequestBody request}) {
    return _remoteRepo.uaeIdExist(request: request);
  }

  @override
  Future<ApiResponse> biometricAuth({required RequestBody request}) {
    return _remoteRepo.biometricAuth(request: request);
  }
}
