import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class AssociationRepo {
  Future<ApiResponse> fetchAssociationProfile({required RequestBody request});

  Future<ApiResponse> saveAssociationInfo({required RequestBody request});

  Future<ApiResponse> saveAssociationContactInfo({required RequestBody request});

  Future<ApiResponse> saveAssociationRepresentativeInfo(
      {required RequestBody request});

  Future<ApiResponse> saveAssociationBankAccount({required RequestBody request});
  Future<ApiResponse> saveAssociationInfoPut({required RequestBody request});
  Future<ApiResponse> fetchAllAssociations({required RequestBody request});
  Future<ApiResponse> fetchMyAssociations({required RequestBody request});
  Future<ApiResponse> fetchAssociationsList({required RequestBody request});
  Future<ApiResponse> addAssociation({required RequestBody request});
  Future<ApiResponse> updateAssociation({required RequestBody request});
  Future<ApiResponse> enableDisableAssociation({required RequestBody request});
}

class AssociationRepoImpl implements AssociationRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchAssociationProfile({required RequestBody request}) {
    return _remoteRepo.fetchAssociationProfile(request: request);
  }

  @override
  Future<ApiResponse> saveAssociationInfo({required RequestBody request}) {
    return _remoteRepo.saveAssociationInfo(request: request);
  }

  @override
  Future<ApiResponse> saveAssociationInfoPut({required RequestBody request}) {
    return _remoteRepo.saveAssociationInfoPut(request: request);
  }

  @override
  Future<ApiResponse> saveAssociationContactInfo({required RequestBody request}) {
    return _remoteRepo.saveAssociationContactInfo(request: request);
  }

  @override
  Future<ApiResponse> saveAssociationRepresentativeInfo(
      {required RequestBody request}) {
    return _remoteRepo.saveAssociationRepresentativeInfo(request: request);
  }

  @override
  Future<ApiResponse> saveAssociationBankAccount({required RequestBody request}) {
    return _remoteRepo.saveAssociationBankAccount(request: request);
  }

  @override
  Future<ApiResponse> fetchAllAssociations({required RequestBody request}) {
    return _remoteRepo.allAssociations(request: request);
  }

  @override
  Future<ApiResponse> fetchMyAssociations({required RequestBody request}) {
    return _remoteRepo.myAllAssociations(request: request);
  }

  @override
  Future<ApiResponse> fetchAssociationsList({required RequestBody request}) {
    return _remoteRepo.associationsList(request: request);
  }

  @override
  Future<ApiResponse> addAssociation({required RequestBody request}) {
    return _remoteRepo.addAssociation(request: request);
  }

  @override
  Future<ApiResponse> updateAssociation({required RequestBody request}) {
    return _remoteRepo.updateAssociation(request: request);
  }

  @override
  Future<ApiResponse> enableDisableAssociation({required RequestBody request}) {
    return _remoteRepo.enableDisableAssociation(request: request);
  }
}
