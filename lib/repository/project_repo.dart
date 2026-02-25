import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class ProjectRepo {
  Future<ApiResponse> createProject({required RequestBody request});
  Future<ApiResponse> createProjectPutRequest({required RequestBody request});
  Future<ApiResponse> associationAllProjectsPaginated({required RequestBody request});
  Future<ApiResponse> enableDisableProject({required RequestBody request});
}

class ProjectRepoImpl implements ProjectRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();


  @override
  Future<ApiResponse> createProject({required RequestBody request}) {
    return _remoteRepo.createProject(request: request);
  }

  @override
  Future<ApiResponse> createProjectPutRequest({required RequestBody request}) {
    return _remoteRepo.createProjectPutRequest(request: request);
  }

  @override
  Future<ApiResponse> associationAllProjectsPaginated({required RequestBody request}) {
    return _remoteRepo.associationAllProjectsPaginated(request: request);
  }

  @override
  Future<ApiResponse> enableDisableProject({required RequestBody request}) {
    return _remoteRepo.enableDisableProject(request: request);
  }
}
