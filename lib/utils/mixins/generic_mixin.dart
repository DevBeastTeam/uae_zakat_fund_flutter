import 'package:dio/dio.dart' as dio;
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/admin_dashbaord_data.dart';
import 'package:zakat_fund/model/association_dashboard_data.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/campaign_project_header_data.dart';
import 'package:zakat_fund/model/donor_header_data.dart';
import 'package:zakat_fund/model/engagemnt_interaction.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

mixin GenericMixin {
  final GenericRepo _repo = GenericRepoImpl();

  Future<String?> uploadImage({required String filePath}) async {
    String? result;
    final filename = Utils.fileName(filePath);
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(filePath, filename: filename)
    });
    ApiResponse apiResponse = await _repo.uploadFile(
      request: RequestBody(formData: formData, isFormDataRequest: true),
    );
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel response = apiResponse.data;
      result = response.fileName;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return result;
  }

  Future<({List<LookupData> nationalities, List<LookupData> countries})>
      getCountryAndNationality() async {
    List<LookupData> nationalitiesList = [];
    List<LookupData> countriesList = [];
    ApiResponse apiResponse = await _repo.fetchLookUpData(
        request: RequestBody(endPoint: ApiConstant.nationality));
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel response = apiResponse.data;
      for (var data in response.data) {
        LookupData nationalityData = LookupData.nationalityFromJson(data);
        LookupData countryDataData = LookupData.countriesFromJson(data);
        nationalitiesList.add(nationalityData);
        countriesList.add(countryDataData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return (nationalities: nationalitiesList, countries: countriesList);
  }

  Future<List<LookupData>> getLookUpData({required String endPoint}) async {
    List<LookupData> lookUpData = [];
    ApiResponse apiResponse =
        await _repo.fetchLookUpData(request: RequestBody(endPoint: endPoint));
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel response = apiResponse.data;
      lookUpData = List<LookupData>.from(
          response.data.map((job) => LookupData.fromJson(job)));
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return lookUpData;
  }

  Future<List<AdditionalDocuments>> getAdditionalDocuments(
      {required String endPoint}) async {
    List<AdditionalDocuments> additionalDocuments = [];
    ApiResponse apiResponse = await _repo.additionalDocuments(
        request: RequestBody(endPoint: endPoint));
    if (apiResponse.appState == AppState.onSuccess) {
      additionalDocuments = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return additionalDocuments;
  }

  Future<List<LookupData>> getAllBanks() async {
    List<LookupData> banks = [];
    ApiResponse apiResponse = await _repo.fetchLookUpData(
        request: RequestBody(endPoint: ApiConstant.banks));
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel response = apiResponse.data;
      banks = List<LookupData>.from(
          response.data.map((job) => LookupData.bankFromJson(job)));
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return banks;
  }

  Future<BaseApiModel?> getAuditLogByEntityId(
      {required Map<String, dynamic> queryParams,
      required String endPoint}) async {
    BaseApiModel? baseApiModel;
    ApiResponse apiResponse = await _repo.auditLogByEntityId(
        request: RequestBody(queryParameters: queryParams, endPoint: endPoint));
    if (apiResponse.appState == AppState.onSuccess) {
      baseApiModel = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return baseApiModel;
  }

  Future<bool> addAdditionalDocuments({required Object body}) async {
    ApiResponse apiResponse =
        await _repo.saveAdditionalDocuments(request: RequestBody(body: body));
    if (apiResponse.appState != AppState.onSuccess) {
      Utils.handleAPIError(apiResponse);
      return false;
    } else {
      return true;
    }
  }

  Future<Project?> getAssociationProjects(int accountID) async {
    Project? projects;
    ApiResponse apiResponse = await _repo.fetchAssociationProjects(
        request: RequestBody(
            endPoint: "${ApiConstant.associationProjects}/$accountID"));
    if (apiResponse.appState == AppState.onSuccess) {
      projects = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return projects;
  }

  Future<ProjectElements?> getProjectDetails(int projectId) async {
    ProjectElements? details;
    ApiResponse apiResponse = await _repo.projectDetails(
        request: RequestBody(endPoint: "${ApiConstant.project}/$projectId"));
    if (apiResponse.appState == AppState.onSuccess) {
      details = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return details;
  }

  Future<bool> addProjectToFavourite({required Object body}) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await _repo.favoriteProject(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      return true;
    } else {
      Utils.handleAPIError(apiResponse);
      return false;
    }
  }

  Future<bool> addNewsToFavourite({required Object body}) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await _repo.addFavoriteNews(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      return true;
    } else {
      Utils.handleAPIError(apiResponse);
      return false;
    }
  }

  Future<News?> getNewsDetails(int newsId) async {
    News? details;
    ApiResponse apiResponse = await _repo.newsDetails(
        request: RequestBody(endPoint: "${ApiConstant.newsDetails}/$newsId"));
    if (apiResponse.appState == AppState.onSuccess) {
      details = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return details;
  }

  Future<bool> addServiceToFavourite({required Object body}) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await _repo.addFavoriteService(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      return true;
    } else {
      Utils.handleAPIError(apiResponse);
      return false;
    }
  }

  Future<OurServices?> getServiceDetails(int serviceId) async {
    OurServices? details;
    ApiResponse apiResponse = await _repo.serviceDetails(
        request:
            RequestBody(endPoint: "${ApiConstant.serviceDetails}/$serviceId"));
    if (apiResponse.appState == AppState.onSuccess) {
      details = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return details;
  }

  Future<ReceiptDetails?> getTransactionDetails(
      Map<String, dynamic> queryParameters) async {
    if (queryParameters.containsKey("sessionId") &&
        queryParameters["sessionId"].toString().startsWith("dummy_")) {
      return ReceiptDetails(
        id: 9999,
        donorName: "Developer",
        donorNameAr: "مطور",
        createdDate: DateTime.now(),
        mobile: "123456789",
        email: "dev@gmail.com",
        transactionId: "DUMMY-TRAN-ID",
        totalAmount: 100.0,
        paymentType: 1,
        isRefunded: false,
        requestStatus: 2,
        taskStatus: 2,
        uniqueCode: "DUMMY-CODE",
        projects: [
          Detail(
            id: 1,
            projectId: 1,
            projectName: "Mock Project English",
            projectNameArabic: "مشروع وهمي",
            amount: 100.0,
            status: "Accepted",
            sessionId: queryParameters["sessionId"],
            createdDate: DateTime.now(),
            createdBy: "dev",
            refundType: 0,
            refundAmount: 0.0,
            email: "dev@gmail.com",
            zfTransactionId: "DUMMY-ZF-ID",
          )
        ],
        collectionDate: DateTime.now(),
        collectionTime: "10:00 AM",
        collectionPoint: "Zakat Fund Office",
        bankId: "B001",
        chequeNo: "123456",
        chequePhoto: "",
        chequeDate: DateTime.now(),
        firstName: "Dev",
        lastName: "User",
        emailAddress: "dev@gmail.com",
        phoneNumber: "123456789",
        payersName: "Developer",
      );
    }
    ReceiptDetails? details;
    ApiResponse apiResponse = await _repo.transactionDetails(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      details = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return details;
  }

  Future<BaseApiModel?> getProjectListPaginated(
      Map<String, dynamic> queryParameters) async {
    BaseApiModel? projectsData;
    ApiResponse apiResponse = await _repo.fetchProjectListPaginated(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      projectsData = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return projectsData;
  }

  Future<List<ProjectElements>> getFeaturedProjects() async {
    List<ProjectElements> projects = [];
    ApiResponse apiResponse =
        await _repo.fetchFeaturedProjects(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      projects = List<ProjectElements>.from(apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return projects;
  }

  Future<AdminDashboardData?> getAdminOperationsDashboardData(
      Map<String, dynamic> queryParameters) async {
    AdminDashboardData? data;
    ApiResponse apiResponse = await _repo.adminOperationsDashboardData(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      data = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return data;
  }

  Future<AssociationAverageSummary?> getAdminDashboardGetHeaderDataFDD(
      Map<String, dynamic> queryParameters) async {
    AssociationAverageSummary? summary;
    ApiResponse apiResponse = await _repo.adminDashboardGetHeaderDataFDD(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      summary = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return summary;
  }

  Future<AssociationAverageSummary?> getAverageDonations(
      Map<String, dynamic> queryParameters) async {
    AssociationAverageSummary? summary;
    ApiResponse apiResponse = await _repo.fetchAverageDonations(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      summary = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return summary;
  }

  Future<CampaignAndProjectsHeaderData?> getHeaderData(
      Map<String, dynamic> queryParameters) async {
    CampaignAndProjectsHeaderData? data;
    ApiResponse apiResponse = await _repo.fetchHeaderData(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      data = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return data;
  }

  Future<DonorHeaderData?> getDonorHeaderData(
      Map<String, dynamic> queryParameters) async {
    DonorHeaderData? data;
    ApiResponse apiResponse = await _repo.fetchDonorHeaderData(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      data = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return data;
  }

  Future<UserEngagementInteraction?> getAdminDashboardGetHeaderDataUEIDD(
      Map<String, dynamic> queryParameters) async {
    UserEngagementInteraction? data;
    ApiResponse apiResponse = await _repo.adminDashboardGetHeaderDataUEIDD(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      data = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return data;
  }

  Future<String?> generateOTPForUser(Object? body) async {
    String? message;
    ApiResponse apiResponse =
        await _repo.generateOTPForUser(request: RequestBody(body: body));
    if (apiResponse.appState == AppState.onSuccess) {
      message = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return message;
  }

  Future<ApiResponse?> sendSmsEmailMobileApp(
      Map<String, dynamic> queryParameters) async {
    ApiResponse apiResponse = await _repo.sendSmsEmailMobileApp(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      //Nothing to do with the response.
    } else {
      Utils.handleAPIError(apiResponse);
    }
    return apiResponse;
  }
}
