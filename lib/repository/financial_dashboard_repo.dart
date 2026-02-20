import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class FinancialDashboardRepo {
  Future<ApiResponse> adminDashboardGetPendingCollectionDataFDD({required RequestBody request});
  Future<ApiResponse> adminDashboardGetDonationsWRTPaymentTypeFDD({required RequestBody request});
}

class FinancialDashboardRepoImpl implements FinancialDashboardRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> adminDashboardGetPendingCollectionDataFDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetPendingCollectionDataFDD(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetDonationsWRTPaymentTypeFDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetDonationsWRTPaymentTypeFDD(request: request);
  }
}
