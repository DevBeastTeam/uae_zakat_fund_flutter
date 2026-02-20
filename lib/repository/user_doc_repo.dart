import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class UserDocRepo {
  Future<ApiResponse> fetchUserDocuments({required RequestBody request});
}

class UserDocRepoImpl implements UserDocRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchUserDocuments({required RequestBody request}) {
    return _remoteRepo.userDocuments(request: request);
  }
}
