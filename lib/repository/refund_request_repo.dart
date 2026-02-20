import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class RefundRequestRepo {
  Future<ApiResponse> refundRequestDetails({required RequestBody request});
}

class RefundRequestRepoImpl implements RefundRequestRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> refundRequestDetails({required RequestBody request}) {
    return _remoteRepo.refundRequestDetails(request: request);
  }
}
