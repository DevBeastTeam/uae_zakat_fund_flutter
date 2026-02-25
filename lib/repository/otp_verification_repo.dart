import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class OtpVerificationRepo {
  Future<ApiResponse> sendOTP({required RequestBody request});

  Future<ApiResponse> validateOTP({required RequestBody request});
}

class OtpVerificationRepoImpl implements OtpVerificationRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> sendOTP({required RequestBody request}) {
    return _remoteRepo.sendOTP(request: request);
  }

  @override
  Future<ApiResponse> validateOTP({required RequestBody request}) {
    return _remoteRepo.validateOTP(request: request);
  }
}
