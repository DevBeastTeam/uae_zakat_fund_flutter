import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class UserEngagementDashboardRepo {
  Future<ApiResponse> adminDashboardGetFeedbackItemUEIDD({required RequestBody request});
  Future<ApiResponse> adminDashboardGetSurveyItemUEIDD({required RequestBody request});
  Future<ApiResponse> adminDashboardGetRatingPerContentUEIDD({required RequestBody request});
  Future<ApiResponse> adminDashboardGetRatingPerUserTypeUEIDD({required RequestBody request});
  Future<ApiResponse> adminDashboardGGetListDataByContentTypeUEIDD({required RequestBody request});
  Future<ApiResponse> adminDashboardGetPreferredLoginTimeListUEIDD({required RequestBody request});
}

class UserEngagementDashboardRepoImpl implements UserEngagementDashboardRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> adminDashboardGetFeedbackItemUEIDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetFeedbackItemUEIDD(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetSurveyItemUEIDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetSurveyItemUEIDD(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetRatingPerContentUEIDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetRatingPerContentUEIDD(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetRatingPerUserTypeUEIDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetRatingPerUserTypeUEIDD(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGGetListDataByContentTypeUEIDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGGetListDataByContentTypeUEIDD(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetPreferredLoginTimeListUEIDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetPreferredLoginTimeListUEIDD(request: request);
  }

}
