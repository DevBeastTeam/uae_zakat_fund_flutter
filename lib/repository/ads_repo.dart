import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class AdsRepo {
  Future<ApiResponse> adDetails({required RequestBody request});
  Future<ApiResponse> allAdsPaginated({required RequestBody request});
  Future<ApiResponse> addAds({required RequestBody request});
  Future<ApiResponse> updateAds({required RequestBody request});
  Future<ApiResponse> enableDisableAds({required RequestBody request});
}

class AdsRepoImpl implements AdsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> adDetails({required RequestBody request}) {
    return _remoteRepo.adDetails(request: request);
  }

  @override
  Future<ApiResponse> allAdsPaginated({required RequestBody request}) {
    return _remoteRepo.allAdsPaginated(request: request);
  }

  @override
  Future<ApiResponse> addAds({required RequestBody request}) {
    return _remoteRepo.addAds(request: request);
  }

  @override
  Future<ApiResponse> updateAds({required RequestBody request}) {
    return _remoteRepo.updateAds(request: request);
  }

  @override
  Future<ApiResponse> enableDisableAds({required RequestBody request}) {
    return _remoteRepo.enableDisableAds(request: request);
  }
}
