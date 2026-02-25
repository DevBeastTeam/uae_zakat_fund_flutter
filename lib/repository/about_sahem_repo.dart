import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class AboutSahemRepo {
  Future<ApiResponse> aboutSahem({required RequestBody request});
}

class AboutSahemRepoImpl implements AboutSahemRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> aboutSahem({required RequestBody request}) {
    return _remoteRepo.aboutSahem(request: request);
  }

}
