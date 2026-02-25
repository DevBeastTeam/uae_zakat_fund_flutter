import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class NewsRepo {
  Future<ApiResponse> latestNews({required RequestBody request});

  Future<ApiResponse> fetchArchiveNews({required RequestBody request});

  Future<ApiResponse> fetchAllNewsPaginated({required RequestBody request});

  Future<ApiResponse> saveNews({required RequestBody request});

  Future<ApiResponse> updateNews({required RequestBody request});

  Future<ApiResponse> fetchCMSAssociationNews({required RequestBody request});

  Future<ApiResponse> associationNewsPaginated({required RequestBody request});

  Future<ApiResponse> enableDisableNews({required RequestBody request});
}

class NewsRepoImpl implements NewsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> latestNews({required RequestBody request}) {
    return _remoteRepo.latestNews(request: request);
  }

  @override
  Future<ApiResponse> fetchArchiveNews({required RequestBody request}) {
    return _remoteRepo.archiveNews(request: request);
  }

  @override
  Future<ApiResponse> fetchAllNewsPaginated({required RequestBody request}) {
    return _remoteRepo.allNewsPaginated(request: request);
  }

  @override
  Future<ApiResponse> saveNews({required RequestBody request}) {
    return _remoteRepo.addNews(request: request);
  }

  @override
  Future<ApiResponse> updateNews({required RequestBody request}) {
    return _remoteRepo.updateNews(request: request);
  }

  @override
  Future<ApiResponse> fetchCMSAssociationNews({required RequestBody request}) {
    return _remoteRepo.cmsAssociationNews(request: request);
  }

  @override
  Future<ApiResponse> associationNewsPaginated({required RequestBody request}) {
    return _remoteRepo.associationNewsPaginated(request: request);
  }

  @override
  Future<ApiResponse> enableDisableNews({required RequestBody request}) {
    return _remoteRepo.enableDisableNews(request: request);
  }
}
