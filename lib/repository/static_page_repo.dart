import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class StaticPageRepo {
  Future<ApiResponse> staticPageDetails({required RequestBody request});
}

class StaticPageRepoImpl implements StaticPageRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> staticPageDetails({required RequestBody request}) {
    return _remoteRepo.staticPageDetails(request: request);
  }

}
