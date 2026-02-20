import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class WorkflowRepo {
  Future<ApiResponse> allWorkflows({required RequestBody request});
  Future<ApiResponse> enableDisableWorkflow({required RequestBody request});
  Future<ApiResponse> deleteWorkflow({required RequestBody request});
  Future<ApiResponse> addWorkflow({required RequestBody request});
  Future<ApiResponse> updateWorkflow({required RequestBody request});
}

class WorkflowRepoImpl implements WorkflowRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> allWorkflows({required RequestBody request}) {
    return _remoteRepo.allWorkflows(request: request);
  }

  @override
  Future<ApiResponse> enableDisableWorkflow({required RequestBody request}) {
    return _remoteRepo.enableDisableWorkflow(request: request);
  }

  @override
  Future<ApiResponse> deleteWorkflow({required RequestBody request}) {
    return _remoteRepo.deleteWorkflow(request: request);
  }

  @override
  Future<ApiResponse> addWorkflow({required RequestBody request}) {
    return _remoteRepo.addWorkflow(request: request);
  }

  @override
  Future<ApiResponse> updateWorkflow({required RequestBody request}) {
    return _remoteRepo.updateWorkflow(request: request);
  }

}
