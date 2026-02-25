import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class AuditLogRepo {
  Future<ApiResponse> fetchAuditLog({required RequestBody request});
  Future<ApiResponse> fetchAuditLogById({required RequestBody request});
}

class AuditLogRepoImpl implements AuditLogRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchAuditLog({required RequestBody request}) {
    return _remoteRepo.auditLog(request: request);
  }

  @override
  Future<ApiResponse> fetchAuditLogById({required RequestBody request}) {
    return _remoteRepo.auditLogsById(request: request);
  }
}
