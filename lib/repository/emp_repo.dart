import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class EmpRepo {
  Future<ApiResponse> fetchEmployees({required RequestBody request});

  Future<ApiResponse> disableEmployee({required RequestBody request});

  Future<ApiResponse> addEmployee({required RequestBody request});

  Future<ApiResponse> updateEmployee({required RequestBody request});

  Future<ApiResponse> deleteEmployee({required RequestBody request});

  Future<ApiResponse> verifyEmail({required RequestBody request});

  Future<ApiResponse> verifyPhone({required RequestBody request});

  Future<ApiResponse> fetchSuperEmployees({required RequestBody request});
  Future<ApiResponse> fetchSuperAgents({required RequestBody request});
  Future<ApiResponse> fetchSahemEmployees({required RequestBody request});
}

class EmpRepoImpl implements EmpRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchEmployees({required RequestBody request}) {
    return _remoteRepo.allEmployees(request: request);
  }

  @override
  Future<ApiResponse> disableEmployee({required RequestBody request}) {
    return _remoteRepo.disableEmployee(request: request);
  }

  @override
  Future<ApiResponse> addEmployee({required RequestBody request}) {
    return _remoteRepo.addEmployee(request: request);
  }

  @override
  Future<ApiResponse> updateEmployee({required RequestBody request}) {
    return _remoteRepo.updateEmployee(request: request);
  }

  @override
  Future<ApiResponse> deleteEmployee({required RequestBody request}) {
    return _remoteRepo.deleteEmployee(request: request);
  }

  @override
  Future<ApiResponse> verifyEmail({required RequestBody request}) {
    return _remoteRepo.verifyEmail(request: request);
  }

  @override
  Future<ApiResponse> verifyPhone({required RequestBody request}) {
    return _remoteRepo.verifyPhone(request: request);
  }

  @override
  Future<ApiResponse> fetchSuperEmployees({required RequestBody request}) {
    return _remoteRepo.superEmployees(request: request);
  }

  @override
  Future<ApiResponse> fetchSuperAgents({required RequestBody request}) {
    return _remoteRepo.superAgents(request: request);
  }

  @override
  Future<ApiResponse> fetchSahemEmployees({required RequestBody request}) {
    return _remoteRepo.sahemEmployees(request: request);
  }
}
