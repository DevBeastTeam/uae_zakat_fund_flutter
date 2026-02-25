import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class FundRequestRepo {
  Future<ApiResponse> fetchFundRequest({required RequestBody request});
  Future<ApiResponse> fetchSahemBank({required RequestBody request});
  Future<ApiResponse> fetchAssociationId({required RequestBody request});
}

class FundRequestRepoImpl implements FundRequestRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchFundRequest({required RequestBody request}) {
    return _remoteRepo.fundRequest(request: request);
  }

  @override
  Future<ApiResponse> fetchSahemBank({required RequestBody request}) {
    return _remoteRepo.sahemBank(request: request);
  }

  @override
  Future<ApiResponse> fetchAssociationId({required RequestBody request}) {
    return _remoteRepo.fundTransferDetail(request: request);
  }
}
