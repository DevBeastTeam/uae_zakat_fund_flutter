import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class PublicDocRepo {
  Future<ApiResponse> fetchPublicDocuments({required RequestBody request});
  Future<ApiResponse> uploadPublicDocument({required RequestBody request});
  Future<ApiResponse> updateDocumentStatus({required RequestBody request});
  Future<ApiResponse> deletePublicDocument({required RequestBody request});
}

class PublicDocRepoImpl implements PublicDocRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchPublicDocuments({required RequestBody request}) {
    return _remoteRepo.publicDocuments(request: request);
  }

  @override
  Future<ApiResponse> uploadPublicDocument({required RequestBody request}) {
    return _remoteRepo.uploadPublicDocument(request: request);
  }

  @override
  Future<ApiResponse> updateDocumentStatus({required RequestBody request}) {
    return _remoteRepo.publicDocumentStatus(request: request);
  }

  @override
  Future<ApiResponse> deletePublicDocument({required RequestBody request}) {
    return _remoteRepo.deletePublicDocument(request: request);
  }
}
