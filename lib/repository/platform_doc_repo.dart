import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class PlatformDocRepo {
  Future<ApiResponse> fetchPlatformDocuments({required RequestBody request});
  Future<ApiResponse> updateDocumentStatus({required RequestBody request});
  Future<ApiResponse> savePlatformDocument({required RequestBody request});
  Future<ApiResponse> updatePlatformDocument({required RequestBody request});
  Future<ApiResponse> deletePlatformDocument({required RequestBody request});
}

class PlatformDocRepoImpl implements PlatformDocRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchPlatformDocuments({required RequestBody request}) {
    return _remoteRepo.platformDocuments(request: request);
  }

  @override
  Future<ApiResponse> updateDocumentStatus({required RequestBody request}) {
    return _remoteRepo.updateDocumentStatus(request: request);
  }

  @override
  Future<ApiResponse> savePlatformDocument({required RequestBody request}) {
    return _remoteRepo.savePlatformDocument(request: request);
  }

  @override
  Future<ApiResponse> updatePlatformDocument({required RequestBody request}) {
    return _remoteRepo.updatePlatformDocument(request: request);
  }@override

  Future<ApiResponse> deletePlatformDocument({required RequestBody request}) {
    return _remoteRepo.deletePlatformDocument(request: request);
  }
}
