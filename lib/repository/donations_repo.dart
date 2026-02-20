import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class DonationsRepo {
  Future<ApiResponse> fetchDonations({required RequestBody request});

  Future<ApiResponse> fetchTop5Projects({required RequestBody request});

  Future<ApiResponse> fetchTop5Associations({required RequestBody request});

  Future<ApiResponse> fetchDonorSummary({required RequestBody request});

  Future<ApiResponse> donorsBreakdown({required RequestBody request});
  Future<ApiResponse> donationDataMonthWiseAODD({required RequestBody request});
}

class DonationsRepoImpl implements DonationsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchDonations({required RequestBody request}) {
    return _remoteRepo.donationBreakdownByProjectAODD(request: request);
  }

  @override
  Future<ApiResponse> fetchTop5Projects({required RequestBody request}) {
    return _remoteRepo.top5ProjectsAODD(request: request);
  }

  @override
  Future<ApiResponse> fetchTop5Associations({required RequestBody request}) {
    return _remoteRepo.top5AssociationsAODD(request: request);
  }

  @override
  Future<ApiResponse> fetchDonorSummary({required RequestBody request}) {
    return _remoteRepo.donorPercentageAODD(request: request);
  }

  @override
  Future<ApiResponse> donorsBreakdown({required RequestBody request}) {
    return _remoteRepo.donorsBreakdown(request: request);
  }

  @override
  Future<ApiResponse> donationDataMonthWiseAODD({required RequestBody request}) {
    return _remoteRepo.donationDataMonthWiseAODD(request: request);
  }
}
