import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class TaskRepo {
  Future<ApiResponse> rejectTask({required RequestBody request});
  Future<ApiResponse> taskDetailsByCode({required RequestBody request});
  Future<ApiResponse> taskCollection({required RequestBody request});
  Future<ApiResponse> taskDetails({required RequestBody request});
  Future<ApiResponse> fetchTaskCollectionDetails({required RequestBody request});
  Future<ApiResponse> authenticateTaskRequest({required RequestBody request});
}

class TaskRepoImpl implements TaskRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> rejectTask({required RequestBody request}) {
    return _remoteRepo.rejectTask(request: request);
  }

  @override
  Future<ApiResponse> taskDetailsByCode({required RequestBody request}) {
    return _remoteRepo.taskDetailsByCode(request: request);
  }

  @override
  Future<ApiResponse> taskCollection({required RequestBody request}) {
    return _remoteRepo.taskCollection(request: request);
  }

  @override
  Future<ApiResponse> taskDetails({required RequestBody request}) {
    return _remoteRepo.taskDetails(request: request);
  }

  @override
  Future<ApiResponse> fetchTaskCollectionDetails({required RequestBody request}) {
    return _remoteRepo.taskCollectionDetails(request: request);
  }

  @override
  Future<ApiResponse> authenticateTaskRequest({required RequestBody request}) {
    return _remoteRepo.authenticateTaskRequest(request: request);
  }
}
