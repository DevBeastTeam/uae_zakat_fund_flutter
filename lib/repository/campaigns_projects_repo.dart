import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class CampaignsProjectsRepo {

  Future<ApiResponse> fetchTopPerformingProjects(
      {required RequestBody request});

  Future<ApiResponse> fetchCampaignFundingGap({required RequestBody request});

  Future<ApiResponse> fetchProjectsReachingEnd({required RequestBody request});
}

class CampaignsProjectsRepoImpl implements CampaignsProjectsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchTopPerformingProjects({required RequestBody request}) {
    return _remoteRepo.topPerformingProjectsCPDD(request: request);
  }

  @override
  Future<ApiResponse> fetchCampaignFundingGap({required RequestBody request}) {
    return _remoteRepo.campaignFundingGapCPDD(request: request);
  }

  @override
  Future<ApiResponse> fetchProjectsReachingEnd({required RequestBody request}) {
    return _remoteRepo.projectsReachingEndCPDD(request: request);
  }
}
