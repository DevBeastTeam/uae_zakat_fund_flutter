import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class FinancialStatementRepo {
  Future<ApiResponse> financialStatementBalance({required RequestBody request});
  Future<ApiResponse> financialStatementByMonth({required RequestBody request});
  Future<ApiResponse> moneyTransferred({required RequestBody request});
}

class FinancialStatementRepoImpl implements FinancialStatementRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> financialStatementBalance({required RequestBody request}) {
    return _remoteRepo.financialStatementBalance(request: request);
  }

  @override
  Future<ApiResponse> financialStatementByMonth({required RequestBody request}) {
    return _remoteRepo.financialStatementByMonth(request: request);
  }

  @override
  Future<ApiResponse> moneyTransferred({required RequestBody request}) {
    return _remoteRepo.moneyTransferred(request: request);
  }

}
