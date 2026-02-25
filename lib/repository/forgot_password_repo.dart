import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class ForgotPasswordRepo {
  Future<ApiResponse> forgotPassword({required RequestBody request});
  Future<ApiResponse> changePassword({required RequestBody request});

}

class ForgotPasswordRepoImpl implements ForgotPasswordRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> forgotPassword({required RequestBody request}) {
    return _remoteRepo.forgotPassword(request: request);
  }

  @override
  Future<ApiResponse> changePassword({required RequestBody request}) {
    return _remoteRepo.changePassword(request: request);
  }

}
