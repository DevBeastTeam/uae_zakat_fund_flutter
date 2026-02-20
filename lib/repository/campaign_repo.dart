import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class CampaignRepo {
  Future<ApiResponse> fetchCampaignDetails({required RequestBody request});
  Future<ApiResponse> fetchRecipients({required RequestBody request});
  Future<ApiResponse> allCampaignListPaginated({required RequestBody request});
  Future<ApiResponse> allRecipientsListPaginated({required RequestBody request});
  Future<ApiResponse> addGroup({required RequestBody request});
  Future<ApiResponse> updateGroup({required RequestBody request});
  Future<ApiResponse> groupDetails({required RequestBody request});
  Future<ApiResponse> deleteGroup({required RequestBody request});
  Future<ApiResponse> deleteGroupRecipients({required RequestBody request});
}

class CampaignRepoImpl implements CampaignRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchCampaignDetails({required RequestBody request}) {
    return _remoteRepo.campaignDetails(request: request);
  }

  @override
  Future<ApiResponse> fetchRecipients({required RequestBody request}) {
    return _remoteRepo.recipients(request: request);
  }

  @override
  Future<ApiResponse> allCampaignListPaginated({required RequestBody request}) {
    return _remoteRepo.allCampaignListPaginated(request: request);
  }

  @override
  Future<ApiResponse> allRecipientsListPaginated({required RequestBody request}) {
    return _remoteRepo.allRecipientsListPaginated(request: request);
  }

  @override
  Future<ApiResponse> addGroup({required RequestBody request}) {
    return _remoteRepo.addGroup(request: request);
  }

  @override
  Future<ApiResponse> updateGroup({required RequestBody request}) {
    return _remoteRepo.updateGroup(request: request);
  }

  @override
  Future<ApiResponse> groupDetails({required RequestBody request}) {
    return _remoteRepo.groupDetails(request: request);
  }

  @override
  Future<ApiResponse> deleteGroup({required RequestBody request}) {
    return _remoteRepo.deleteGroup(request: request);
  }

  @override
  Future<ApiResponse> deleteGroupRecipients({required RequestBody request}) {
    return _remoteRepo.deleteGroupRecipients(request: request);
  }

}
