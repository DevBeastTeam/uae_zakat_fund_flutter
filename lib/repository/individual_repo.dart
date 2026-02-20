import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class IndividualRepo {
  Future<ApiResponse> fetchProfile({required RequestBody request});

  Future<ApiResponse> saveAccountInfo({required RequestBody request});

  Future<ApiResponse> saveContactInfo({required RequestBody request});

  Future<ApiResponse> savePreferences({required RequestBody request});

  Future<ApiResponse> fetchAllDonors({required RequestBody request});
  Future<ApiResponse> notificationPreferences({required RequestBody request});
  Future<ApiResponse> updateDonorProfile({required RequestBody request});
}

class IndividualRepoImpl implements IndividualRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchProfile({required RequestBody request}) {
    return _remoteRepo.fetchIndividualProfile(request: request);
  }

  @override
  Future<ApiResponse> saveAccountInfo({required RequestBody request}) {
    return _remoteRepo.saveIndividualAccountInfo(request: request);
  }

  @override
  Future<ApiResponse> saveContactInfo({required RequestBody request}) {
    return _remoteRepo.saveIndividualContactInfo(request: request);
  }

  @override
  Future<ApiResponse> savePreferences({required RequestBody request}) {
    return _remoteRepo.saveIndividualPreferences(request: request);
  }

  @override
  Future<ApiResponse> fetchAllDonors({required RequestBody request}) {
    return _remoteRepo.allDonors(request: request);
  }

  @override
  Future<ApiResponse> notificationPreferences({required RequestBody request}) {
    return _remoteRepo.notificationPreferences(request: request);
  }

  @override
  Future<ApiResponse> updateDonorProfile({required RequestBody request}) {
    return _remoteRepo.updateDonorProfile(request: request);
  }
}
