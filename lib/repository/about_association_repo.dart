import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class AboutAssociationRepo {
  Future<ApiResponse> aboutAssociation({required RequestBody request});
  Future<ApiResponse> updateAboutStatus({required RequestBody request});
  Future<ApiResponse> addAboutUs({required RequestBody request});
  Future<ApiResponse> updateAboutUs({required RequestBody request});
  Future<ApiResponse> associationAboutUs({required RequestBody request});
}

class AboutAssociationRepoImpl implements AboutAssociationRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> aboutAssociation({required RequestBody request}) {
    return _remoteRepo.aboutAssociation(request: request);
  }

  @override
  Future<ApiResponse> updateAboutStatus({required RequestBody request}) {
    return _remoteRepo.updateAboutStatus(request: request);
  }

  @override
  Future<ApiResponse> addAboutUs({required RequestBody request}) {
    return _remoteRepo.addAboutUs(request: request);
  }

  @override
  Future<ApiResponse> updateAboutUs({required RequestBody request}) {
    return _remoteRepo.updateAboutUs(request: request);
  }

  @override
  Future<ApiResponse> associationAboutUs({required RequestBody request}) {
    return _remoteRepo.associationAboutUs(request: request);
  }

}
