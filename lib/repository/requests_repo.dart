import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class RequestsRepo {
  Future<ApiResponse> fetchRequests({required RequestBody request});
  Future<ApiResponse> requestApproval({required RequestBody request});
  Future<ApiResponse> fetchTasks({required RequestBody request});
  Future<ApiResponse> fetchAllUserRequests({required RequestBody request});
}

class RequestsRepoImpl implements RequestsRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchRequests({required RequestBody request}) {
    return _remoteRepo.fetchRequests(request: request);
  }

  @override
  Future<ApiResponse> requestApproval({required RequestBody request}) {
    return _remoteRepo.requestApproval(request: request);
  }

  @override
  Future<ApiResponse> fetchTasks({required RequestBody request}) {
    return _remoteRepo.myTasks(request: request);
  }

  @override
  Future<ApiResponse> fetchAllUserRequests({required RequestBody request}) {
    return _remoteRepo.allUserRequests(request: request);
  }
}
