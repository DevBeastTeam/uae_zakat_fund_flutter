import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class SmtpConfigRepo {
  Future<ApiResponse> smtpConfig({required RequestBody request});
  Future<ApiResponse> addSMTPConfig({required RequestBody request});
  Future<ApiResponse> getContactUs({required RequestBody request});
}

class SmtpConfigRepoImpl implements SmtpConfigRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> smtpConfig({required RequestBody request}) {
    return _remoteRepo.smtpConfig(request: request);
  }

  @override
  Future<ApiResponse> addSMTPConfig({required RequestBody request}) {
    return _remoteRepo.addSMTPConfig(request: request);
  }

  @override
  Future<ApiResponse> getContactUs({required RequestBody request}) {
    return _remoteRepo.getContactUs(request: request);
  }

}
