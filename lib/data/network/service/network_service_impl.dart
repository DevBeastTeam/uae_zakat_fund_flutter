import 'package:dio/dio.dart';
import 'package:zakat_fund/data/network/client/network_client.dart';
import 'package:zakat_fund/data/network/client/network_client_impl.dart';
import 'package:zakat_fund/data/network/client/network_exception.dart';
import 'package:zakat_fund/data/network/service/network_service.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/admin_dashbaord_data.dart';
import 'package:zakat_fund/model/ads.dart';
import 'package:zakat_fund/model/apple_info.dart';
import 'package:zakat_fund/model/approver_group_employee.dart';
import 'package:zakat_fund/model/approver_groups.dart';
import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/association_about_us.dart';
import 'package:zakat_fund/model/association_dashboard_data.dart';
import 'package:zakat_fund/model/association_donations.dart';
import 'package:zakat_fund/model/audit_logs.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/campaign.dart';
import 'package:zakat_fund/model/campaign_funding_gap.dart';
import 'package:zakat_fund/model/campaign_project_header_data.dart';
import 'package:zakat_fund/model/cart.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/compliance_per_workflow.dart';
import 'package:zakat_fund/model/donation_history.dart';
import 'package:zakat_fund/model/donation_reminders.dart';
import 'package:zakat_fund/model/donor_dashboard_data.dart';
import 'package:zakat_fund/model/donor_demographic.dart';
import 'package:zakat_fund/model/donor_header_data.dart';
import 'package:zakat_fund/model/engagemnt_interaction.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/faq_paginated.dart';
import 'package:zakat_fund/model/favourite_project.dart';
import 'package:zakat_fund/model/feedbacks.dart';
import 'package:zakat_fund/model/financial_statement.dart';
import 'package:zakat_fund/model/fund_request.dart';
import 'package:zakat_fund/model/group_details.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/line_chart_data.dart';
import 'package:zakat_fund/model/management_staff.dart';
import 'package:zakat_fund/model/moduel_permissions.dart';
import 'package:zakat_fund/model/money_transferred.dart';
import 'package:zakat_fund/model/my_wallet.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/news_archive.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/payment_method_history.dart';
import 'package:zakat_fund/model/piechart_data.dart';
import 'package:zakat_fund/model/platform_documents.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/project_alerts.dart';
import 'package:zakat_fund/model/projects_reaching_end.dart';
import 'package:zakat_fund/model/public_documents.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/model/recipients.dart';
import 'package:zakat_fund/model/refund_history.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/model/sahem_bank.dart';
import 'package:zakat_fund/model/sla_by_approver_group.dart';
import 'package:zakat_fund/model/smtp_config.dart';
import 'package:zakat_fund/model/static_page.dart';
import 'package:zakat_fund/model/statics_insights.dart';
import 'package:zakat_fund/model/survey.dart';
import 'package:zakat_fund/model/task_collection_details.dart';
import 'package:zakat_fund/model/task_details.dart';
import 'package:zakat_fund/model/tax_certificate_details.dart';
import 'package:zakat_fund/model/top_associations.dart';
import 'package:zakat_fund/model/top_donors.dart';
import 'package:zakat_fund/model/top_performing_projects.dart';
import 'package:zakat_fund/model/transactions.dart';
import 'package:zakat_fund/model/transfer_queue.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';

class NetworkServiceImpl implements NetworkService {
  final NetworkClient _api = NetworkClientImpl();

  @override
  Future<ApiResponse> registerUser({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.registerUser);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> sendOTP({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.resendOTP);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> validateOTP({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.validateOTP);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> forgotPassword({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.forgotPassword);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> logIn({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.postRequest(request: request, endPoint: ApiConstant.logIn);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> uploadFile({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request,
          endPoint: request.endPoint ?? ApiConstant.fileUpload);
      if (response.statusCode == 200) {
        BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error("Something went wrong");
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchLookUpData({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveIndividualAccountInfo(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.donorAccountInfo);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveIndividualContactInfo(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.donorContactInfo);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveIndividualPreferences(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.notificationPreferences);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveCompanyInfo({required RequestBody request}) async {
    late ApiResponse<int> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.companyInfo);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveAssociationInfo(
      {required RequestBody request}) async {
    late ApiResponse<int> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.associationInfo);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveCompanyInfoPutRequest(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveAssociationInfoPutRequest(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveCompanyContactInfo(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.companyContactInfo);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("saveAsDraftSuccessfully");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveAssociationContactInfo(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.associationContactInfo);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("saveAsDraftSuccessfully");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveCompanyRepresentativeInfo(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.companyRepresentative);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("saveAsDraftSuccessfully");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveAssociationRepresentativeInfo(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.associationRepresentative);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("saveAsDraftSuccessfully");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveCompanyBankAccount(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.companyBankAccount);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("saveAsDraftSuccessfully");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveAssociationBankAccount(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.associationBankAccount);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("saveAsDraftSuccessfully");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> createProject({required RequestBody request}) async {
    late ApiResponse<int> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.project);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> createProjectPutRequest(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed("");
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchIndividualProfile(
      {required RequestBody request}) async {
    late ApiResponse<Individual> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Individual individual = Individual.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(individual);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchCompanyProfile(
      {required RequestBody request}) async {
    late ApiResponse<Company> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Company company = Company.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(company);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchAssociationProfile(
      {required RequestBody request}) async {
    late ApiResponse<Association> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Association company = Association.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(company);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchAssociationProjects(
      {required RequestBody request}) async {
    late ApiResponse<Project?> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Project? projects;
        if (baseApiModel.data != null) {
          projects = Project.fromJson(baseApiModel.data[0]);
        }
        apiResponse = ApiResponse.completed(projects);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchAllProjects({required RequestBody request}) async {
    late ApiResponse<List<ProjectElements>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.project);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ProjectElements> projects = List<ProjectElements>.from(
            baseApiModel.data.map((x) => ProjectElements.fromJson(x)));
        apiResponse = ApiResponse.completed(projects);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchProjects({required RequestBody request}) async {
    late ApiResponse<List<ProjectElements>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.project);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ProjectElements> projects = [];
        if (baseApiModel.data != null) {
          projects = List<ProjectElements>.from(
              baseApiModel.data.map((x) => ProjectElements.fromJson(x)));
          apiResponse = ApiResponse.completed(projects);
        } else {
          apiResponse = ApiResponse.completed(projects);
        }
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> userProjects({required RequestBody request}) async {
    late ApiResponse<List<ProjectElements>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ProjectElements> projects = [];
        if (baseApiModel.data != null) {
          projects = List<ProjectElements>.from(
              baseApiModel.data.map((x) => ProjectElements.fromJson(x)));
          apiResponse = ApiResponse.completed(projects);
        } else {
          apiResponse = ApiResponse.completed(projects);
        }
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> projectDetails({required RequestBody request}) async {
    late ApiResponse<ProjectElements> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        ProjectElements project = ProjectElements.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(project);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> newsDetails({required RequestBody request}) async {
    late ApiResponse<News> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        News news = News.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(news);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchAssociations({required RequestBody request}) async {
    late ApiResponse<List<Project>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.associations);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Project> projects = [];
        if (baseApiModel.data != null) {
          projects = List<Project>.from(
              baseApiModel.data.map((x) => Project.fromJson(x)));
          apiResponse = ApiResponse.completed(projects);
        } else {
          apiResponse = ApiResponse.completed(projects);
        }
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchCart({required RequestBody request}) async {
    late ApiResponse<List<Cart>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.userCart);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Cart> cart =
            List<Cart>.from(baseApiModel.data.map((x) => Cart.fromJson(x)));
        apiResponse = ApiResponse.completed(cart);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addToCart({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addToCart);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteCartProduct({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteFeedback({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteAllCart({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: ApiConstant.deleteAllCart);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateCartItem({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateUserCart({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.updateUserCart);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> socialRegister({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.socialRegister);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> appleInfo({required RequestBody request}) async {
    late ApiResponse<AppleInfo> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.appleInfo);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AppleInfo appleInfo = AppleInfo.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(appleInfo);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> uaeIdExist({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.checkUAEUser);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      apiResponse = ApiResponse.completed(baseApiModel);
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveUaeUser({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.saveUAEUser);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      apiResponse = ApiResponse.completed(baseApiModel);

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchFAQCategories({required RequestBody request}) async {
    late ApiResponse<List<FaqCategory>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.faqCategory);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<FaqCategory> categories = List<FaqCategory>.from(
            baseApiModel.data.map((x) => FaqCategory.fromJson(x)));
        apiResponse = ApiResponse.completed(categories);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchFAQsByCategory(
      {required RequestBody request}) async {
    late ApiResponse<List<FaQs>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.getAllFAQs);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<FaQs> faqs =
            List<FaQs>.from(baseApiModel.data.map((x) => FaQs.fromJson(x)));
        apiResponse = ApiResponse.completed(faqs);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchAllServices({required RequestBody request}) async {
    late ApiResponse<List<OurServices>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.getAllServices);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<OurServices> services = List<OurServices>.from(
            baseApiModel.data.map((x) => OurServices.fromJson(x)));
        apiResponse = ApiResponse.completed(services);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> latestNews({required RequestBody request}) async {
    late ApiResponse<List<News>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.latestNews);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<News> news =
            List<News>.from(baseApiModel.data.map((x) => News.fromJson(x)));
        apiResponse = ApiResponse.completed(news);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationNews({required RequestBody request}) async {
    late ApiResponse<List<News>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<News> news =
            List<News>.from(baseApiModel.data.map((x) => News.fromJson(x)));
        apiResponse = ApiResponse.completed(news);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> featuredProject({required RequestBody request}) async {
    late ApiResponse<List<ProjectElements>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.featuredProject);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ProjectElements> projects = List<ProjectElements>.from(
            baseApiModel.data.map((x) => ProjectElements.fromJson(x)));
        apiResponse = ApiResponse.completed(projects);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> staticPages({required RequestBody request}) async {
    late ApiResponse<List<StaticPage>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<StaticPage> staticPages = List<StaticPage>.from(
            baseApiModel.data.map((x) => StaticPage.fromJson(x)));
        apiResponse = ApiResponse.completed(staticPages);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allEmployees({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> favoriteProjects({required RequestBody request}) async {
    late ApiResponse<List<FavouriteProject>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<FavouriteProject> projects = List<FavouriteProject>.from(
            baseApiModel.data.map((x) => FavouriteProject.fromJson(x)));
        apiResponse = ApiResponse.completed(projects);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> favouriteNews({required RequestBody request}) async {
    late ApiResponse<List<News>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<News> news =
            List<News>.from(baseApiModel.data.map((x) => News.fromJson(x)));
        apiResponse = ApiResponse.completed(news);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> favouriteServices({required RequestBody request}) async {
    late ApiResponse<List<OurServices>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<OurServices> services = List<OurServices>.from(
            baseApiModel.data.map((x) => OurServices.fromJson(x)));
        apiResponse = ApiResponse.completed(services);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> disableEmployee({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.postRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addEmployee({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response =
          await _api.postRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateEmployee({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteEmployee({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> favoriteProject({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addFavoriteProject);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addFavoriteNews({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addFavoriteNews);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addFavoriteService({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addFavoriteService);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationAboutUs({required RequestBody request}) async {
    late ApiResponse<List<AssociationAboutUs>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<AssociationAboutUs> aboutUs = List<AssociationAboutUs>.from(
            baseApiModel.data.map((x) => AssociationAboutUs.fromJson(x)));
        apiResponse = ApiResponse.completed(aboutUs);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> sendContactUs({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.sendContactUs);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> userNotifications({required RequestBody request}) async {
    late ApiResponse<List<Notifications>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Notifications> notifications = List<Notifications>.from(
            baseApiModel.data.map((x) => Notifications.fromJson(x)));
        apiResponse = ApiResponse.completed(notifications);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> readNotification({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteNotification({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addDevice({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addDevice);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> verifyEmail({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.verifyEmail);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> verifyPhone({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.verifyPhone);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchFeedbacks({required RequestBody request}) async {
    late ApiResponse<List<Feedbacks>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Feedbacks> feedbacks = List<Feedbacks>.from(
            baseApiModel.data.map((x) => Feedbacks.fromJson(x)));
        apiResponse = ApiResponse.completed(feedbacks);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fetchRequests({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> submitFeedback({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addFeedbacks);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> feedbackDetails({required RequestBody request}) async {
    late ApiResponse<Feedbacks> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Feedbacks feedback = Feedbacks.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(feedback);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adDetails({required RequestBody request}) async {
    late ApiResponse<Ads> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Ads ads = Ads.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(ads);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> staticPageDetails({required RequestBody request}) async {
    late ApiResponse<StaticPage> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        StaticPage staticPage = StaticPage.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(staticPage);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> aboutAssociation({required RequestBody request}) async {
    late ApiResponse<AssociationAboutUs> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AssociationAboutUs aboutAssociation =
            AssociationAboutUs.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(aboutAssociation);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> serviceDetails({required RequestBody request}) async {
    late ApiResponse<OurServices> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        OurServices services = OurServices.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(services);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateFeedbackStatus(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateAboutStatus({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> requestApproval({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.requestApproval);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> transactions({required RequestBody request}) async {
    late ApiResponse<List<Transactions>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Transactions> transactions = List<Transactions>.from(
            baseApiModel.data.map((x) => Transactions.fromJson(x)));
        apiResponse = ApiResponse.completed(transactions);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> transactionDetails({required RequestBody request}) async {
    late ApiResponse<ReceiptDetails> apiResponse;
    try {
      final dio = Dio(BaseOptions(baseUrl: FlavorConfig.baseUrl))
        ..options.contentType = Headers.jsonContentType;
      Response response = await dio.get(
        ApiConstant.payDetails,
        queryParameters: request.queryParameters,
      );
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        ReceiptDetails transactions =
            ReceiptDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(transactions);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> taskDetails({required RequestBody request}) async {
    late ApiResponse<ReceiptDetails> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        ReceiptDetails transactions =
            ReceiptDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(transactions);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addQuickProjects({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addQuickProjects);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> campaignDetails({required RequestBody request}) async {
    late ApiResponse<CampaignDetails> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        CampaignDetails campaignDetails =
            CampaignDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(campaignDetails);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> recipients({required RequestBody request}) async {
    late ApiResponse<List<Recipients>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Recipients> recipients = List<Recipients>.from(
            baseApiModel.data.map((x) => Recipients.fromJson(x)));
        apiResponse = ApiResponse.completed(recipients);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> surveyDetails({required RequestBody request}) async {
    late ApiResponse<Survey> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Survey survey = Survey.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(survey);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> refundRequestDetails(
      {required RequestBody request}) async {
    late ApiResponse<ReceiptDetails> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.refundRequestDetails);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        ReceiptDetails refundRequest =
            ReceiptDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(refundRequest);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> offlinePayment({required RequestBody request}) async {
    late ApiResponse<int> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.offlinePayment);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> refundRequest({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.refundRequest);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> faqDetails({required RequestBody request}) async {
    late ApiResponse<List<FaQs>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<FaQs> faqs =
            List<FaQs>.from(baseApiModel.data.map((x) => FaQs.fromJson(x)));
        apiResponse = ApiResponse.completed(faqs);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allAssociations({required RequestBody request}) async {
    late ApiResponse<List<Association>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allAssociations);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Association> faqs = List<Association>.from(
            baseApiModel.data.map((x) => Association.fromJson(x)));
        apiResponse = ApiResponse.completed(faqs);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> myAssociations({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.myAllAssociations);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allCompanies({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allCompanies);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> myCompanies({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.myAllCompanies);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allDonors({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allDonors);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> assignFeedback({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.postRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> submitFeedbackResponse(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> assignTask({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addTask);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> rejectTask({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.rejectTask);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> taskCollection({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.taskCollection);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> latestDonation({required RequestBody request}) async {
    late ApiResponse<List<ProjectElements>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.latestDonation);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ProjectElements> donations = List<ProjectElements>.from(
            baseApiModel.data.map((x) => ProjectElements.fromJson(x)));
        apiResponse = ApiResponse.completed(donations);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> mobileDashboardStats(
      {required RequestBody request}) async {
    late ApiResponse<StaticsInsights> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.mobileDashboardStats);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        StaticsInsights donations = StaticsInsights.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(donations);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> expirySoonProjects({required RequestBody request}) async {
    late ApiResponse<List<ProjectElements>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.getExpirySoonProjects);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ProjectElements> donations = List<ProjectElements>.from(
            baseApiModel.data.map((x) => ProjectElements.fromJson(x)));
        apiResponse = ApiResponse.completed(donations);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> refundHistory({required RequestBody request}) async {
    late ApiResponse<List<RefundHistory>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.refundHistory);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<RefundHistory> refundHistory = List<RefundHistory>.from(
            baseApiModel.data.map((x) => RefundHistory.fromJson(x)));
        apiResponse = ApiResponse.completed(refundHistory);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> superEmployees({required RequestBody request}) async {
    late ApiResponse<List<ManagementStaff>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.superEmployees);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ManagementStaff> staff = List<ManagementStaff>.from(
            baseApiModel.data.map((x) => ManagementStaff.fromJson(x)));
        apiResponse = ApiResponse.completed(staff);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> superAgents({required RequestBody request}) async {
    late ApiResponse<List<ManagementStaff>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.superAgents);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ManagementStaff> staff = List<ManagementStaff>.from(
            baseApiModel.data.map((x) => ManagementStaff.fromJson(x)));
        apiResponse = ApiResponse.completed(staff);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donationHistory({required RequestBody request}) async {
    late ApiResponse<List<DonationHistory>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donationHistory);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<DonationHistory> staff = List<DonationHistory>.from(
            baseApiModel.data.map((x) => DonationHistory.fromJson(x)));
        apiResponse = ApiResponse.completed(staff);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> myTasks({required RequestBody request}) async {
    late ApiResponse<List<Requests>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.myTasks);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Requests> tasks = List<Requests>.from(
            baseApiModel.data.map((x) => Requests.fromJson(x)));
        apiResponse = ApiResponse.completed(tasks);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorDashboardData({required RequestBody request}) async {
    late ApiResponse<DonorDashboardData> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donorDashboardData);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        DonorDashboardData dashboardData =
            DonorDashboardData.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(dashboardData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationDashboardData(
      {required RequestBody request}) async {
    late ApiResponse<AssociationDashboardData?> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AssociationDashboardData? associationDashboardData;
        if (baseApiModel.data != null && baseApiModel.data.isNotEmpty) {
          associationDashboardData =
              AssociationDashboardData.fromJson(baseApiModel.data);
        }
        apiResponse = ApiResponse.completed(associationDashboardData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationAverageSummary(
      {required RequestBody request}) async {
    late ApiResponse<AssociationAverageSummary> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AssociationAverageSummary associationAverageSummary =
            AssociationAverageSummary.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(associationAverageSummary);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationProjectsData(
      {required RequestBody request}) async {
    late ApiResponse<List<AssociationDonations>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<AssociationDonations> projectsData =
            List<AssociationDonations>.from(
                baseApiModel.data.map((x) => AssociationDonations.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> taskDetailsByCode({required RequestBody request}) async {
    late ApiResponse<TaskDetails> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.taskDetailsByCode);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        TaskDetails details = TaskDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(details);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorPercentage({required RequestBody request}) async {
    late ApiResponse<List<PieChartData>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PieChartData> projectsData = List<PieChartData>.from(
            baseApiModel.data.map((x) => PieChartData.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorDemographics({required RequestBody request}) async {
    late ApiResponse<List<DonorDemographic>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donorDemographicsDDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<DonorDemographic> projectsData = List<DonorDemographic>.from(
            baseApiModel.data.map((x) => DonorDemographic.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> topDonors({required RequestBody request}) async {
    late ApiResponse<List<TopDonors>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.topDonorDemographicsDDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<TopDonors> projectsData = List<TopDonors>.from(
            baseApiModel.data.map((x) => TopDonors.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorHeaderData({required RequestBody request}) async {
    late ApiResponse<DonorHeaderData> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.headerDataDDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        DonorHeaderData headerData =
            DonorHeaderData.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(headerData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> headerDataCPDD({required RequestBody request}) async {
    late ApiResponse<CampaignAndProjectsHeaderData> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.headerDataCPDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        CampaignAndProjectsHeaderData headerData =
            CampaignAndProjectsHeaderData.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(headerData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> topPerformingProjectsCPDD(
      {required RequestBody request}) async {
    late ApiResponse<List<TopPerformingProjects>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.topPerformingProjectsCPDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<TopPerformingProjects> topPerformingProjects =
            List<TopPerformingProjects>.from(baseApiModel.data
                .map((x) => TopPerformingProjects.fromJson(x)));
        apiResponse = ApiResponse.completed(topPerformingProjects);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> campaignFundingGapCPDD(
      {required RequestBody request}) async {
    late ApiResponse<List<CampaignFundingGap>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.campaignFundingGapCPDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<CampaignFundingGap> campaignFundingGap =
            List<CampaignFundingGap>.from(
                baseApiModel.data.map((x) => CampaignFundingGap.fromJson(x)));
        apiResponse = ApiResponse.completed(campaignFundingGap);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> projectsReachingEndCPDD(
      {required RequestBody request}) async {
    late ApiResponse<List<ProjectsReachingEnd>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.projectsReachingEndCPDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ProjectsReachingEnd> projectsReachingEnd =
            List<ProjectsReachingEnd>.from(
                baseApiModel.data.map((x) => ProjectsReachingEnd.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsReachingEnd);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donationBreakdownByProjectAODD(
      {required RequestBody request}) async {
    late ApiResponse<List<AssociationDonations>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.donationBreakdownByProjectAODD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<AssociationDonations> projectsReachingEnd =
            List<AssociationDonations>.from(
                baseApiModel.data.map((x) => AssociationDonations.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsReachingEnd);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> top5ProjectsAODD({required RequestBody request}) async {
    late ApiResponse<List<AssociationDonations>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.top5ProjectsAODD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<AssociationDonations> projectsReachingEnd =
            List<AssociationDonations>.from(
                baseApiModel.data.map((x) => AssociationDonations.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsReachingEnd);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> top5AssociationsAODD(
      {required RequestBody request}) async {
    late ApiResponse<List<Top5Associations>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.top5AssociationsAODD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Top5Associations> projectsReachingEnd =
            List<Top5Associations>.from(
                baseApiModel.data.map((x) => Top5Associations.fromJson(x)));
        apiResponse = ApiResponse.completed(projectsReachingEnd);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorAverageAODD({required RequestBody request}) async {
    late ApiResponse<AssociationAverageSummary> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donorAverageAODD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AssociationAverageSummary averageSummary =
            AssociationAverageSummary.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(averageSummary);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorPercentageAODD(
      {required RequestBody request}) async {
    late ApiResponse<List<PieChartData>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donorPercentageAODD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PieChartData> pieChartData = List<PieChartData>.from(
            baseApiModel.data.map((x) => PieChartData.fromJson(x)));
        apiResponse = ApiResponse.completed(pieChartData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> myRefunds({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.myRefunds);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adsList({required RequestBody request}) async {
    late ApiResponse<List<Ads>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.adsList);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<Ads> ads =
            List<Ads>.from(baseApiModel.data.map((x) => Ads.fromJson(x)));
        apiResponse = ApiResponse.completed(ads);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> publicDocuments({required RequestBody request}) async {
    late ApiResponse<List<PublicDocuments>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.publicDocuments);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PublicDocuments> publicDocuments = List<PublicDocuments>.from(
            baseApiModel.data.map((x) => PublicDocuments.fromJson(x)));
        apiResponse = ApiResponse.completed(publicDocuments);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> userDocuments({required RequestBody request}) async {
    late ApiResponse<List<PublicDocuments>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.userDocuments);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PublicDocuments> publicDocuments = List<PublicDocuments>.from(
            baseApiModel.data.map((x) => PublicDocuments.fromJson(x)));
        apiResponse = ApiResponse.completed(publicDocuments);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> platformDocuments({required RequestBody request}) async {
    late ApiResponse<List<PlatformDocuments>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.platformDocuments);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PlatformDocuments> platformDocuments =
            List<PlatformDocuments>.from(
                baseApiModel.data.map((x) => PlatformDocuments.fromJson(x)));
        apiResponse = ApiResponse.completed(platformDocuments);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> sahemBank({required RequestBody request}) async {
    late ApiResponse<List<SahemBank>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.sahemBanks);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SahemBank> sahemBanks = List<SahemBank>.from(
            baseApiModel.data.map((x) => SahemBank.fromJson(x)));
        apiResponse = ApiResponse.completed(sahemBanks);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> archiveNews({required RequestBody request}) async {
    late ApiResponse<NewsArchive> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.archiveNews);
      NewsArchive baseApiModel = NewsArchive.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> walletBalance({required RequestBody request}) async {
    late ApiResponse<double> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> payViaWallet({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.payViaWallet);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> acceptAssociationRequest(
      {required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.putRequest(
          request: request, endPoint: ApiConstant.acceptAssociationRequest);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> myWallet({required RequestBody request}) async {
    late ApiResponse<MyWallet> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.myWallet);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        MyWallet myWallet = MyWallet.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(myWallet);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> taskCollectionDetails(
      {required RequestBody request}) async {
    late ApiResponse<TaskCollectionDetails> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.taskCollectionDetails);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        TaskCollectionDetails taskCollectionDetails =
            TaskCollectionDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(taskCollectionDetails);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> authenticateTaskRequest(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.authenticateTaskRequest);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateDocumentStatus(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.platformDocumentStatus);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> publicDocumentStatus(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.publicDocumentStatus);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> savePlatformDocument(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.savePlatformDocument);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updatePlatformDocument(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> submitFundTransferRequest(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.submitFundTransferRequest);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> uploadPublicDocument(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.uploadPublicDocument);
      if (response.statusCode == 200) {
        BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error("Something went wrong");
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationProjectsPaginated(
      {required RequestBody request}) async {
    late ApiResponse<ProjectPagination> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      ProjectPagination baseApiModel =
          ProjectPagination.fromJson(response.data);
      if (response.statusCode == 200) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors ?? "");
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> auditLog({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.auditLog);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (response.statusCode == 200) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors ?? "");
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fundRequest({required RequestBody request}) async {
    late ApiResponse<FundRequest> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (response.statusCode == 200) {
        FundRequest fundRequest = FundRequest.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(fundRequest);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors ?? "");
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fundTransferDetail({required RequestBody request}) async {
    late ApiResponse<FundRequestDetails> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (response.statusCode == 200) {
        FundRequestDetails details =
            FundRequestDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(details);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors ?? "");
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteFAQ({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addFAQ({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addFAQ);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateFAQ({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> faqPaginated({required RequestBody request}) async {
    late ApiResponse<FaqPaginated> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.faqPaginated);
      FaqPaginated baseApiModel = FaqPaginated.fromJson(response.data);
      if (response.statusCode == 200) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors ?? "");
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> additionalDocuments(
      {required RequestBody request}) async {
    late ApiResponse<List<AdditionalDocuments>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<AdditionalDocuments> additionalDocuments =
            List<AdditionalDocuments>.from(
                baseApiModel.data.map((x) => AdditionalDocuments.fromJson(x)));
        apiResponse = ApiResponse.completed(additionalDocuments);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationsList({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.associationsList);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> projectListPaginated(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.projectListPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allUserRequests({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.userRequestPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allNewsPaginated({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allNewsPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveAdditionalDocuments(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.saveAdditionalDocuments);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addNews({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addNews);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateNews({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addAboutUs({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addAboutUs);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateAboutUs({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> cmsAssociationNews({required RequestBody request}) async {
    late ApiResponse<List<News>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<News> news =
            List<News>.from(baseApiModel.data.map((x) => News.fromJson(x)));
        apiResponse = ApiResponse.completed(news);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> notificationDetails(
      {required RequestBody request}) async {
    late ApiResponse<Notifications> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Notifications news = Notifications.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(news);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addAssociation({required RequestBody request}) async {
    late ApiResponse<int> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addAssociation);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateAssociation({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allFeedbacksPaginated(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allFeedbacksPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> auditLogsById({required RequestBody request}) async {
    late ApiResponse<AuditLogs> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AuditLogs auditLogs = AuditLogs.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(auditLogs);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> cmsNotifications({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.cmsNotifications);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveNotification({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.saveNotification);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateNotification({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addCompany({required RequestBody request}) async {
    late ApiResponse<int> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addCompany);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateCompany({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> cmsServices({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.cmsServices);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> activeDeActiveService(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.activeDeActiveService);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> userPermissions({required RequestBody request}) async {
    late ApiResponse<List<ModulePermissions>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ModulePermissions> permissions = List<ModulePermissions>.from(
            baseApiModel.data.map((x) => ModulePermissions.fromJson(x)));
        apiResponse = ApiResponse.completed(permissions);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addService({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addService);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateService({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> fundTransferQueue({required RequestBody request}) async {
    late ApiResponse<TransferQueue> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.fundTransferQueue);
      TransferQueue baseApiModel = TransferQueue.fromJson(response.data);
      apiResponse = ApiResponse.completed(baseApiModel);
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> globalSearch({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.globalSearch);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allAdsPaginated({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allAdsPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addAds({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addAds);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateAds({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> notificationPreferences(
      {required RequestBody request}) async {
    late ApiResponse<NotificationPreferences> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        NotificationPreferences notificationPreferences =
            NotificationPreferences.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(notificationPreferences);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allCampaignListPaginated(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allCampaignListPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allRecipientsListPaginated(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allRecipientsListPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addGroup({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addGroup);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateGroup({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> groupDetails({required RequestBody request}) async {
    late ApiResponse<List<GroupDetails>> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<GroupDetails> details = List<GroupDetails>.from(
            baseApiModel.data.map((x) => GroupDetails.fromJson(x)));
        apiResponse = ApiResponse.completed(details);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteGroup({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteGroupRecipients(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: ApiConstant.deleteGroupRecipients);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationAllProjectsPaginated(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> saveAsDraft({required RequestBody request}) async {
    late ApiResponse<dynamic> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.saveAsDraft);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateDraft({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.putRequest(
          request: request, endPoint: ApiConstant.updateDraft);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationNewsPaginated(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.associationNewsPaginated);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> contentRating({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.contentRating);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> downloadTaxCertificate(
      {required RequestBody request}) async {
    late ApiResponse<TaxCertificateDetails> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.taxCertificate);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        TaxCertificateDetails details =
            TaxCertificateDetails.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(details);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableAssociation(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableAssociation);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableProject(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableProject);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> financialStatementBalance(
      {required RequestBody request}) async {
    late ApiResponse<FinancialStatementBalance?> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.financialStatementBalance);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        FinancialStatementBalance? balance = baseApiModel.data.isNotEmpty
            ? FinancialStatementBalance.fromJson(baseApiModel.data)
            : null;
        apiResponse = ApiResponse.completed(balance);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> financialStatementByMonth(
      {required RequestBody request}) async {
    late ApiResponse<List<FinancialStatementByMonth>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.financialStatementByMonth);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<FinancialStatementByMonth> statement =
            List<FinancialStatementByMonth>.from(baseApiModel.data
                .map((x) => FinancialStatementByMonth.fromJson(x)));
        apiResponse = ApiResponse.completed(statement);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> userDonations({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.userDonations);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableFAQ({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableFAQ);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableNews({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableNews);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableAds({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableAds);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteAccount({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.deleteAccount);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> approverGroups({required RequestBody request}) async {
    late ApiResponse<List<ApproverGroups>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.approverGroups);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ApproverGroups> approverGroups = List<ApproverGroups>.from(
            baseApiModel.data.map((x) => ApproverGroups.fromJson(x)));
        apiResponse = ApiResponse.completed(approverGroups);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableGroup({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableGroup);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteApproverGroup(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> approverGroupEmployees(
      {required RequestBody request}) async {
    late ApiResponse<List<ApproverGroupEmployee>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.approverGroupEmployees);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<ApproverGroupEmployee> projects = List<ApproverGroupEmployee>.from(
            baseApiModel.data.map((x) => ApproverGroupEmployee.fromJson(x)));
        apiResponse = ApiResponse.completed(projects);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> approverGroupDetails(
      {required RequestBody request}) async {
    late ApiResponse<ApproverGroups> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        ApproverGroups groupDetails =
            ApproverGroups.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(groupDetails);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addApproverGroup({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addApproverGroup);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateApproverGroup(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allWorkflows({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allWorkflows);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableWorkflow(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableWorkflow);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteWorkflow({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addWorkflow({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addWorkflow);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateWorkflow({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> enableDisableCompany(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.enableDisableCompany);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> associationFundRequests(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> allReminders({required RequestBody request}) async {
    late ApiResponse<List<DonationReminder>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.allReminders);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<DonationReminder> reminders = List<DonationReminder>.from(
            baseApiModel.data.map((x) => DonationReminder.fromJson(x)));
        apiResponse = ApiResponse.completed(reminders);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deleteReminder({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addDonationReminder(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addDonationReminder);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateDonationReminder(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response =
          await _api.putRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addGuestReminder({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addGuestReminder);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addUpdateProjectAlerts(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addUpdateProjectAlerts);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> projectAlerts({required RequestBody request}) async {
    late ApiResponse<ProjectAlerts> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.projectAlerts);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        ProjectAlerts alerts = ProjectAlerts.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(alerts);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> feedbackByUserIdPaginated(
      {required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> moneyTransferred({required RequestBody request}) async {
    late ApiResponse<List<MoneyTransferred>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.moneyTransferred);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<MoneyTransferred> reminders = List<MoneyTransferred>.from(
            baseApiModel.data.map((x) => MoneyTransferred.fromJson(x)));
        apiResponse = ApiResponse.completed(reminders);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> changePassword({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.changePassword);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> smtpConfig({required RequestBody request}) async {
    late ApiResponse<List<SmtpConfig>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.smtpConfig);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SmtpConfig> reminders = List<SmtpConfig>.from(
            baseApiModel.data.map((x) => SmtpConfig.fromJson(x)));
        apiResponse = ApiResponse.completed(reminders);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> addSMTPConfig({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addSMTPConfig);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> getContactUs({required RequestBody request}) async {
    late ApiResponse<List<SmtpConfig>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.getContactUs);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SmtpConfig> reminders = List<SmtpConfig>.from(
            baseApiModel.data.map((x) => SmtpConfig.fromJson(x)));
        apiResponse = ApiResponse.completed(reminders);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> areaChartDonationDataAssociationDashboard(
      {required RequestBody request}) async {
    late ApiResponse<List<LineChartModel>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.areaChartDonationDataAssociationDashboard);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<LineChartModel> data = List<LineChartModel>.from(
            baseApiModel.data.map((x) => LineChartModel.fromJson(x)));
        apiResponse = ApiResponse.completed(data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorBarchartDetails(
      {required RequestBody request}) async {
    late ApiResponse<List<DonorDemographic>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donorBarchartDetails);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<DonorDemographic> data = List<DonorDemographic>.from(
            baseApiModel.data.map((x) => DonorDemographic.fromJson(x)));
        apiResponse = ApiResponse.completed(data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donorsBreakdown({required RequestBody request}) async {
    late ApiResponse<List<PieChartData>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donorsBreakdown);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PieChartData> data = List<PieChartData>.from(
            baseApiModel.data.map((x) => PieChartData.fromJson(x)));
        apiResponse = ApiResponse.completed(data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> donationDataMonthWiseAODD(
      {required RequestBody request}) async {
    late ApiResponse<List<LineChartModel>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.donationDataMonthWiseAODD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<LineChartModel> data = List<LineChartModel>.from(
            baseApiModel.data.map((x) => LineChartModel.fromJson(x)));
        apiResponse = ApiResponse.completed(data);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetHeaderDataFDD(
      {required RequestBody request}) async {
    late ApiResponse<AssociationAverageSummary> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetHeaderDataFDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AssociationAverageSummary associationAverageSummary =
            AssociationAverageSummary.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(associationAverageSummary);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetPendingCollectionDataFDD(
      {required RequestBody request}) async {
    late ApiResponse<List<PaymentMethodHistory>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetPendingCollectionDataFDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PaymentMethodHistory> history = List<PaymentMethodHistory>.from(
            baseApiModel.data.map((x) => PaymentMethodHistory.fromJson(x)));
        apiResponse = ApiResponse.completed(history);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetDonationsWRTPaymentTypeFDD(
      {required RequestBody request}) async {
    late ApiResponse<List<PaymentMethodHistory>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetDonationsWRTPaymentTypeFDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<PaymentMethodHistory> history = List<PaymentMethodHistory>.from(
            baseApiModel.data.map((x) => PaymentMethodHistory.fromJson(x)));
        apiResponse = ApiResponse.completed(history);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminOperationsDashboardData(
      {required RequestBody request}) async {
    late ApiResponse<AdminDashboardData> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.adminOperationsDashboardData);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        AdminDashboardData adminDashboardData =
            AdminDashboardData.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(adminDashboardData);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetHeaderDataUEIDD(
      {required RequestBody request}) async {
    late ApiResponse<UserEngagementInteraction> apiResponse;
    // try {
    final Response response = await _api.getRequest(
        request: request,
        endPoint: ApiConstant.adminDashboardGetHeaderDataUEIDD);
    BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
    if (baseApiModel.success) {
      UserEngagementInteraction userEngagementInteraction =
          UserEngagementInteraction.fromJson(baseApiModel.data);
      apiResponse = ApiResponse.completed(userEngagementInteraction);
    } else {
      apiResponse = ApiResponse.error(baseApiModel.errors);
    }
    return apiResponse;
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 401) {
    //     return ApiResponse.unauthorized();
    //   }
    //   final errorMessage = DioExceptions.fromDioError(e).toString();
    //   apiResponse = ApiResponse.error(errorMessage);
    //   return apiResponse;
    // } catch (e) {
    //   apiResponse = ApiResponse.error(e.toString());
    //   return apiResponse;
    // }
  }

  @override
  Future<ApiResponse> adminDashboardGetFeedbackItemUEIDD(
      {required RequestBody request}) async {
    late ApiResponse<FeedbacksSummary> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetFeedbackItemUEIDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        FeedbacksSummary summary = FeedbacksSummary.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(summary);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetSurveyItemUEIDD(
      {required RequestBody request}) async {
    late ApiResponse<SurveysSummary> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetSurveyItemUEIDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        SurveysSummary summary = SurveysSummary.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(summary);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetRatingPerContentUEIDD(
      {required RequestBody request}) async {
    late ApiResponse<List<CategoryRating>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetRatingPerContentUEIDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<CategoryRating> ratings = List<CategoryRating>.from(
            baseApiModel.data.map((x) => CategoryRating.fromJson(x)));
        apiResponse = ApiResponse.completed(ratings);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetRatingPerUserTypeUEIDD(
      {required RequestBody request}) async {
    late ApiResponse<List<UserTypeRating>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetRatingPerUserTypeUEIDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<UserTypeRating> ratings = List<UserTypeRating>.from(
            baseApiModel.data.map((x) => UserTypeRating.fromJson(x)));
        apiResponse = ApiResponse.completed(ratings);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGGetListDataByContentTypeUEIDD(
      {required RequestBody request}) async {
    late ApiResponse<List<CategoryRatingDetails>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGGetListDataByContentTypeUEIDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<CategoryRatingDetails> details = List<CategoryRatingDetails>.from(
            baseApiModel.data.map((x) => CategoryRatingDetails.fromJson(x)));
        apiResponse = ApiResponse.completed(details);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetPreferredLoginTimeListUEIDD(
      {required RequestBody request}) async {
    late ApiResponse<List<LowestActivityTimesWeek>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetPreferredLoginTimeListUEIDD);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<LowestActivityTimesWeek> loginTimes =
            List<LowestActivityTimesWeek>.from(baseApiModel.data
                .map((x) => LowestActivityTimesWeek.fromJson(x)));
        apiResponse = ApiResponse.completed(loginTimes);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardSLAGetHeaderData(
      {required RequestBody request}) async {
    late ApiResponse<Stats> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardSLAGetHeaderData);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        Stats stats = Stats.fromJson(baseApiModel.data);
        apiResponse = ApiResponse.completed(stats);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowType(
      {required RequestBody request}) async {
    late ApiResponse<List<SlaCompliancePerWorkflow>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetSLADetailsPerWorkflowType);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SlaCompliancePerWorkflow> compliancePerWorkflow =
            List<SlaCompliancePerWorkflow>.from(baseApiModel.data
                .map((x) => SlaCompliancePerWorkflow.fromJson(x)));
        apiResponse = ApiResponse.completed(compliancePerWorkflow);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowApproverGroup(
      {required RequestBody request}) async {
    late ApiResponse<List<SlaByApproversGroups>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint:
              ApiConstant.adminDashboardGetSLADetailsPerWorkflowApproverGroup);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SlaByApproversGroups> approverGroups =
            List<SlaByApproversGroups>.from(
                baseApiModel.data.map((x) => SlaByApproversGroups.fromJson(x)));
        apiResponse = ApiResponse.completed(approverGroups);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowLevel(
      {required RequestBody request}) async {
    late ApiResponse<List<SlaCompliancePerWorkflow>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request,
          endPoint: ApiConstant.adminDashboardGetSLADetailsPerWorkflowLevel);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SlaCompliancePerWorkflow> slaCompliancePerWorkflow =
            List<SlaCompliancePerWorkflow>.from(baseApiModel.data
                .map((x) => SlaCompliancePerWorkflow.fromJson(x)));
        apiResponse = ApiResponse.completed(slaCompliancePerWorkflow);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> sahemEmployees({required RequestBody request}) async {
    late ApiResponse<List<SahemEmployees>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.sahemEmployees);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SahemEmployees> sahemEmployees = List<SahemEmployees>.from(
            baseApiModel.data.map((x) => SahemEmployees.fromJson(x)));
        apiResponse = ApiResponse.completed(sahemEmployees);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> updateDonorProfile({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.updateDonorProfile);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> biometricAuth({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.biometricAuth);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deletePlatformDocument(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> deletePublicDocument(
      {required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.deleteRequest(
          request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> aboutSahem({required RequestBody request}) async {
    late ApiResponse<List<SmtpConfig>> apiResponse;
    try {
      final Response response = await _api.getRequest(
          request: request, endPoint: ApiConstant.aboutSahem);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        List<SmtpConfig> reminders = List<SmtpConfig>.from(
            baseApiModel.data.map((x) => SmtpConfig.fromJson(x)));
        apiResponse = ApiResponse.completed(reminders);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> auditLogByEntityId({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      final Response response =
          await _api.getRequest(request: request, endPoint: request.endPoint!);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> generateOTPForUser({required RequestBody request}) async {
    late ApiResponse<String> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.generateOTPForUser);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel.message);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> adduestUserDP({required RequestBody request}) async {
    late ApiResponse<bool> apiResponse;
    try {
      final Response response = await _api.postRequest(
          request: request, endPoint: ApiConstant.addDpGuestUser);
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(true);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> createDubaiPayment({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      // final dio = Dio(BaseOptions(baseUrl: "https://stgnpzapi.npz.gov.ae/"))
      //   ..options.contentType = Headers.jsonContentType;
      Response response = await _api.postRequest(
        endPoint: ApiConstant.createDubaiPay,
        request: request,
      );
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(e.message);
      }
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> sendSmsEmailMobileApp({required RequestBody request}) async {
    late ApiResponse<BaseApiModel> apiResponse;
    try {
      // final dio = Dio(BaseOptions(baseUrl: "https://stgnpzapi.npz.gov.ae/"))
      //   ..options.contentType = Headers.jsonContentType;
      Response response = await _api.getRequest(
        endPoint: ApiConstant.sendSmsEmailMobileApp,
        request: request,
      );
      BaseApiModel baseApiModel = BaseApiModel.fromJson(response.data);
      if (baseApiModel.success) {
        apiResponse = ApiResponse.completed(baseApiModel);
      } else {
        apiResponse = ApiResponse.error(baseApiModel.errors);
      }
      return apiResponse;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(e.message);
      }
      if (e.response?.statusCode == 401) {
        return ApiResponse.unauthorized();
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      apiResponse = ApiResponse.error(errorMessage);
      return apiResponse;
    } catch (e) {
      apiResponse = ApiResponse.error(e.toString());
      return apiResponse;
    }
  }
}
