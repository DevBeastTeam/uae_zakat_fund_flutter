import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class AssociationDashboardRepo {
  Future<ApiResponse> fetchDashboardData({required RequestBody request});
  Future<ApiResponse> fetchAverageSummary({required RequestBody request});
  Future<ApiResponse> fetchProjects({required RequestBody request});
  Future<ApiResponse> fetchDonorPercentage({required RequestBody request});
  Future<ApiResponse> areaChartDonationDataAssociationDashboard({required RequestBody request});
}

class AssociationDashboardRepoImpl implements AssociationDashboardRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchDashboardData({required RequestBody request}) {
    return _remoteRepo.associationDashboardData(request: request);
  }

  @override
  Future<ApiResponse> fetchAverageSummary({required RequestBody request}) {
    return _remoteRepo.associationAverageSummary(request: request);
  }

  @override
  Future<ApiResponse> fetchProjects({required RequestBody request}) {
    return _remoteRepo.associationProjectsData(request: request);
  }
  @override
  Future<ApiResponse> fetchDonorPercentage({required RequestBody request}) {
    return _remoteRepo.donorPercentage(request: request);
  }

  @override
  Future<ApiResponse> areaChartDonationDataAssociationDashboard({required RequestBody request}) {
    return _remoteRepo.areaChartDonationDataAssociationDashboard(request: request);
  }

}
