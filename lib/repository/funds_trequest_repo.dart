import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class FundsRequestRepo {
  Future<ApiResponse> associationFundRequests({required RequestBody request});
  Future<ApiResponse> submitFundsRequest({required RequestBody request});
}

class FundsRequestRepoImpl implements FundsRequestRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> associationFundRequests({required RequestBody request}) {
    return _remoteRepo.associationFundRequests(request: request);
  }

  @override
  Future<ApiResponse> submitFundsRequest({required RequestBody request}) {
    return _remoteRepo.submitFundTransferRequest(request: request);
  }
}
