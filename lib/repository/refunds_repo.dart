import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class RefundsRepo {
  Future<ApiResponse> fetchMyRefunds({required RequestBody request});
}

class RefundsRepoImpl implements RefundsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchMyRefunds({required RequestBody request}) {
    return _remoteRepo.myRefunds(request: request);
  }
}
