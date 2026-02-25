import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class ServicesRepo {
  Future<ApiResponse> fetchAllServices({required RequestBody request});
  Future<ApiResponse> fetchCMSServices({required RequestBody request});
  Future<ApiResponse> activeDeActiveService({required RequestBody request});
  Future<ApiResponse> addService({required RequestBody request});
  Future<ApiResponse> updateService({required RequestBody request});
}

class ServicesRepoImpl implements ServicesRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchAllServices({required RequestBody request}) {
    return _remoteRepo.fetchAllServices(request: request);
  }

  @override
  Future<ApiResponse> fetchCMSServices({required RequestBody request}) {
    return _remoteRepo.cmsServices(request: request);
  }

  @override
  Future<ApiResponse> activeDeActiveService({required RequestBody request}) {
    return _remoteRepo.activeDeActiveService(request: request);
  }

  @override
  Future<ApiResponse> addService({required RequestBody request}) {
    return _remoteRepo.addService(request: request);
  }

  @override
  Future<ApiResponse> updateService({required RequestBody request}) {
    return _remoteRepo.updateService(request: request);
  }
}
