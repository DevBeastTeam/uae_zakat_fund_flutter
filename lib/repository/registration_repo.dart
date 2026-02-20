import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class RegistrationRepo {
  Future<ApiResponse> registerUser({required RequestBody request});
}

class RegistrationRepoImpl implements RegistrationRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> registerUser({required RequestBody request}) {
    return _remoteRepo.registerUser(request: request);
  }

}
