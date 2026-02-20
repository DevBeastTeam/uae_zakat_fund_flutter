import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class ApproverGroupsRepo {
  Future<ApiResponse> approverGroups({required RequestBody request});
  Future<ApiResponse> enableDisableGroup({required RequestBody request});
  Future<ApiResponse> deleteApproverGroup({required RequestBody request});
  Future<ApiResponse> approverGroupEmployees({required RequestBody request});
  Future<ApiResponse> approverGroupDetails({required RequestBody request});
  Future<ApiResponse> addApproverGroup({required RequestBody request});
  Future<ApiResponse> updateApproverGroup({required RequestBody request});
}

class ApproverGroupsRepoImpl implements ApproverGroupsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> approverGroups({required RequestBody request}) {
    return _remoteRepo.approverGroups(request: request);
  }

  @override
  Future<ApiResponse> enableDisableGroup({required RequestBody request}) {
    return _remoteRepo.enableDisableGroup(request: request);
  }

  @override
  Future<ApiResponse> deleteApproverGroup({required RequestBody request}) {
    return _remoteRepo.deleteApproverGroup(request: request);
  }

  @override
  Future<ApiResponse> approverGroupEmployees({required RequestBody request}) {
    return _remoteRepo.approverGroupEmployees(request: request);
  }

  @override
  Future<ApiResponse> approverGroupDetails({required RequestBody request}) {
    return _remoteRepo.approverGroupDetails(request: request);
  }

  @override
  Future<ApiResponse> addApproverGroup({required RequestBody request}) {
    return _remoteRepo.addApproverGroup(request: request);
  }

  @override
  Future<ApiResponse> updateApproverGroup({required RequestBody request}) {
    return _remoteRepo.updateApproverGroup(request: request);
  }

}
