import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class SlaDashboardRepo {
  Future<ApiResponse> adminDashboardSLAGetHeaderData({required RequestBody request});
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowType({required RequestBody request});
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowApproverGroup({required RequestBody request});
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowLevel({required RequestBody request});
}

class SlaDashboardRepoImpl implements SlaDashboardRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> adminDashboardSLAGetHeaderData({required RequestBody request}) {
    return _remoteRepo.adminDashboardSLAGetHeaderData(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowType({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetSLADetailsPerWorkflowType(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowApproverGroup({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetSLADetailsPerWorkflowApproverGroup(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowLevel({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetSLADetailsPerWorkflowLevel(request: request);
  }

}
