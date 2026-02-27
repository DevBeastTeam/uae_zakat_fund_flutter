import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class GenericRepo {
  Future<ApiResponse> uploadFile({required RequestBody request});

  Future<ApiResponse> fetchLookUpData({required RequestBody request});

  Future<ApiResponse> fetchAssociationProjects({required RequestBody request});

  Future<ApiResponse> favoriteProject({required RequestBody request});

  Future<ApiResponse> projectDetails({required RequestBody request});

  Future<ApiResponse> addFavoriteNews({required RequestBody request});

  Future<ApiResponse> addFavoriteService({required RequestBody request});

  Future<ApiResponse> newsDetails({required RequestBody request});

  Future<ApiResponse> associationNews({required RequestBody request});

  Future<ApiResponse> sendContactUs({required RequestBody request});

  Future<ApiResponse> addDevice({required RequestBody request});

  Future<ApiResponse> serviceDetails({required RequestBody request});

  Future<ApiResponse> transactionDetails({required RequestBody request});

  Future<ApiResponse> addQuickProjects({required RequestBody request});

  Future<ApiResponse> fetchAllProjects({required RequestBody request});

  Future<ApiResponse> assignTask({required RequestBody request});

  Future<ApiResponse> additionalDocuments({required RequestBody request});

  Future<ApiResponse> fetchProjectListPaginated({required RequestBody request});

  Future<ApiResponse> fetchFeaturedProjects({required RequestBody request});

  Future<ApiResponse> saveAdditionalDocuments({required RequestBody request});

  Future<ApiResponse> fetchUserPermissions({required RequestBody request});

  Future<ApiResponse> fetchSearchResults({required RequestBody request});

  Future<ApiResponse> saveAsDraft({required RequestBody request});

  Future<ApiResponse> updateDraft({required RequestBody request});

  Future<ApiResponse> contentRating({required RequestBody request});

  Future<ApiResponse> deleteAccount({required RequestBody request});

  Future<ApiResponse> auditLogByEntityId({required RequestBody request});

  Future<ApiResponse> adminOperationsDashboardData({required RequestBody request});

  Future<ApiResponse> adminDashboardGetHeaderDataFDD({required RequestBody request});

  Future<ApiResponse> fetchAverageDonations({required RequestBody request});

  Future<ApiResponse> fetchHeaderData({required RequestBody request});

  Future<ApiResponse> fetchDonorHeaderData({required RequestBody request});

  Future<ApiResponse> adminDashboardGetHeaderDataUEIDD({required RequestBody request});

  Future<ApiResponse> generateOTPForUser({required RequestBody request});
  Future<ApiResponse> createDubaiPayment({required RequestBody request});
  Future<ApiResponse> sendSmsEmailMobileApp({required RequestBody request});
  Future<ApiResponse> getSystemConfiguration({required RequestBody request});

  Future<ApiResponse> updateSystemConfiguration({required RequestBody request});

}

class GenericRepoImpl implements GenericRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> uploadFile({required RequestBody request}) {
    return _remoteRepo.uploadFile(request: request);
  }

  @override
  Future<ApiResponse> fetchAllProjects({required RequestBody request}) {
    return _remoteRepo.fetchAllProjects(request: request);
  }

  @override
  Future<ApiResponse> fetchLookUpData({required RequestBody request}) {
    return _remoteRepo.fetchLookUpData(request: request);
  }

  @override
  Future<ApiResponse> fetchAssociationProjects({required RequestBody request}) {
    return _remoteRepo.fetchAssociationProjects(request: request);
  }

  @override
  Future<ApiResponse> favoriteProject({required RequestBody request}) {
    return _remoteRepo.favoriteProject(request: request);
  }

  @override
  Future<ApiResponse> projectDetails({required RequestBody request}) {
    return _remoteRepo.projectDetails(request: request);
  }

  @override
  Future<ApiResponse> addFavoriteNews({required RequestBody request}) {
    return _remoteRepo.addFavoriteNews(request: request);
  }

  @override
  Future<ApiResponse> newsDetails({required RequestBody request}) {
    return _remoteRepo.newsDetails(request: request);
  }

  @override
  Future<ApiResponse> addFavoriteService({required RequestBody request}) {
    return _remoteRepo.addFavoriteService(request: request);
  }

  @override
  Future<ApiResponse> associationNews({required RequestBody request}) {
    return _remoteRepo.associationNews(request: request);
  }

  @override
  Future<ApiResponse> sendContactUs({required RequestBody request}) {
    return _remoteRepo.sendContactUs(request: request);
  }

  @override
  Future<ApiResponse> addDevice({required RequestBody request}) {
    return _remoteRepo.addDevice(request: request);
  }

  @override
  Future<ApiResponse> serviceDetails({required RequestBody request}) {
    return _remoteRepo.serviceDetails(request: request);
  }

  @override
  Future<ApiResponse> transactionDetails({required RequestBody request}) {
    return _remoteRepo.transactionDetails(request: request);
  }

  @override
  Future<ApiResponse> addQuickProjects({required RequestBody request}) {
    return _remoteRepo.addQuickProjects(request: request);
  }

  @override
  Future<ApiResponse> assignTask({required RequestBody request}) {
    return _remoteRepo.assignTask(request: request);
  }

  @override
  Future<ApiResponse> additionalDocuments({required RequestBody request}) {
    return _remoteRepo.additionalDocuments(request: request);
  }

  @override
  Future<ApiResponse> fetchProjectListPaginated(
      {required RequestBody request}) {
    return _remoteRepo.projectListPaginated(request: request);
  }

  @override
  Future<ApiResponse> fetchFeaturedProjects({required RequestBody request}) {
    return _remoteRepo.featuredProject(request: request);
  }

  @override
  Future<ApiResponse> saveAdditionalDocuments({required RequestBody request}) {
    return _remoteRepo.saveAdditionalDocuments(request: request);
  }

  @override
  Future<ApiResponse> fetchUserPermissions({required RequestBody request}) {
    return _remoteRepo.userPermissions(request: request);
  }

  @override
  Future<ApiResponse> fetchSearchResults({required RequestBody request}) {
    return _remoteRepo.globalSearch(request: request);
  }

  @override
  Future<ApiResponse> saveAsDraft({required RequestBody request}) {
    return _remoteRepo.saveAsDraft(request: request);
  }

  @override
  Future<ApiResponse> updateDraft({required RequestBody request}) {
    return _remoteRepo.updateDraft(request: request);
  }

  @override
  Future<ApiResponse> contentRating({required RequestBody request}) {
    return _remoteRepo.contentRating(request: request);
  }

  @override
  Future<ApiResponse> deleteAccount({required RequestBody request}) {
    return _remoteRepo.deleteAccount(request: request);
  }

  @override
  Future<ApiResponse> auditLogByEntityId({required RequestBody request}) {
    return _remoteRepo.auditLogByEntityId(request: request);
  }

  @override
  Future<ApiResponse> adminOperationsDashboardData({required RequestBody request}) {
    return _remoteRepo.adminOperationsDashboardData(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetHeaderDataFDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetHeaderDataFDD(request: request);
  }

  @override
  Future<ApiResponse> fetchAverageDonations({required RequestBody request}) {
    return _remoteRepo.donorAverageAODD(request: request);
  }

  @override
  Future<ApiResponse> fetchHeaderData({required RequestBody request}) {
    return _remoteRepo.headerDataCPDD(request: request);
  }

  @override
  Future<ApiResponse> fetchDonorHeaderData({required RequestBody request}) {
    return _remoteRepo.donorHeaderData(request: request);
  }

  @override
  Future<ApiResponse> adminDashboardGetHeaderDataUEIDD({required RequestBody request}) {
    return _remoteRepo.adminDashboardGetHeaderDataUEIDD(request: request);
  }

  @override
  Future<ApiResponse> generateOTPForUser({required RequestBody request}) {
    return _remoteRepo.generateOTPForUser(request: request);
  }

  @override
  Future<ApiResponse> createDubaiPayment({required RequestBody request}) {
    return _remoteRepo.createDubaiPayment(request: request);
  }

  @override
  Future<ApiResponse> adduestUserDP({required RequestBody request}) {
    return _remoteRepo.adduestUserDP(request: request);
  }

  @override
  Future<ApiResponse> sendSmsEmailMobileApp({required RequestBody request}) {
    return _remoteRepo.sendSmsEmailMobileApp(request: request);
  }

  @override
  Future<ApiResponse> getSystemConfiguration({required RequestBody request}) {
    return _remoteRepo.getSystemConfiguration(request: request);
  }

  @override
  Future<ApiResponse> updateSystemConfiguration({required RequestBody request}) {
    return _remoteRepo.updateSystemConfiguration(request: request);
  }

}
