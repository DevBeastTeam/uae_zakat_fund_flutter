import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class DonorDataRepo {
  Future<ApiResponse> fetchDonorDemographic({required RequestBody request});

  Future<ApiResponse> fetchTopDonors({required RequestBody request});
  Future<ApiResponse> donorBarchartDetails({required RequestBody request});
}

class DonorDataRepoImpl implements DonorDataRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();



  @override
  Future<ApiResponse> fetchDonorDemographic({required RequestBody request}) {
    return _remoteRepo.donorDemographics(request: request);
  }

  @override
  Future<ApiResponse> fetchTopDonors({required RequestBody request}) {
    return _remoteRepo.topDonors(request: request);
  }

  @override
  Future<ApiResponse> donorBarchartDetails({required RequestBody request}) {
    return _remoteRepo.donorBarchartDetails(request: request);
  }
}
