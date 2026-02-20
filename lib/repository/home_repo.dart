import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class HomeRepo {
  Future<ApiResponse> fetchProjects({required RequestBody request});
  Future<ApiResponse> fetchAssociations({required RequestBody request});
  Future<ApiResponse> featuredProject({required RequestBody request});
  Future<ApiResponse> fetchStaticPages({required RequestBody request});
  Future<ApiResponse> userProjects({required RequestBody request});
  Future<ApiResponse> latestDonation({required RequestBody request});
  Future<ApiResponse> expirySoonProjects({required RequestBody request});
  Future<ApiResponse> fetchAds({required RequestBody request});
  Future<ApiResponse> mobileDashboardStats({required RequestBody request});
}

class HomeRepoImpl implements HomeRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchProjects({required RequestBody request}) {
    return _remoteRepo.fetchProjects(request: request);
  }

  @override
  Future<ApiResponse> fetchAssociations({required RequestBody request}) {
    return _remoteRepo.fetchAssociations(request: request);
  }

  @override
  Future<ApiResponse> featuredProject({required RequestBody request}) {
    return _remoteRepo.featuredProject(request: request);
  }

  @override
  Future<ApiResponse> fetchStaticPages({required RequestBody request}) {
    return _remoteRepo.staticPages(request: request);
  }

  @override
  Future<ApiResponse> userProjects({required RequestBody request}) {
    return _remoteRepo.userProjects(request: request);
  }

  @override
  Future<ApiResponse> latestDonation({required RequestBody request}) {
    return _remoteRepo.latestDonation(request: request);
  }

  @override
  Future<ApiResponse> mobileDashboardStats({required RequestBody request}) {
    return _remoteRepo.mobileDashboardStats(request: request);
  }

  @override
  Future<ApiResponse> expirySoonProjects({required RequestBody request}) {
    return _remoteRepo.expirySoonProjects(request: request);
  }

  @override
  Future<ApiResponse> fetchAds({required RequestBody request}) {
    return _remoteRepo.adsList(request: request);
  }
}
