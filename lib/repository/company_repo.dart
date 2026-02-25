import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class CompanyRepo {
  Future<ApiResponse> fetchCompanyProfile({required RequestBody request});

  Future<ApiResponse> saveCompanyInfo({required RequestBody request});

  Future<ApiResponse> saveCompanyContactInfo({required RequestBody request});

  Future<ApiResponse> saveCompanyRepresentativeInfo(
      {required RequestBody request});

  Future<ApiResponse> saveCompanyBankAccount({required RequestBody request});

  Future<ApiResponse> saveCompanyInfoPut({required RequestBody request});

  Future<ApiResponse> fetchAllCompanies({required RequestBody request});

  Future<ApiResponse> fetchMyCompanies({required RequestBody request});

  Future<ApiResponse> updateStatus({required RequestBody request});

  Future<ApiResponse> addCompany({required RequestBody request});

  Future<ApiResponse> updateCompany({required RequestBody request});
  Future<ApiResponse> enableDisableCompany({required RequestBody request});
}

class CompanyRepoImpl implements CompanyRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchCompanyProfile({required RequestBody request}) {
    return _remoteRepo.fetchCompanyProfile(request: request);
  }

  @override
  Future<ApiResponse> saveCompanyInfo({required RequestBody request}) {
    return _remoteRepo.saveCompanyInfo(request: request);
  }

  @override
  Future<ApiResponse> saveCompanyInfoPut({required RequestBody request}) {
    return _remoteRepo.saveCompanyInfoPut(request: request);
  }

  @override
  Future<ApiResponse> saveCompanyContactInfo({required RequestBody request}) {
    return _remoteRepo.saveCompanyContactInfo(request: request);
  }

  @override
  Future<ApiResponse> saveCompanyRepresentativeInfo(
      {required RequestBody request}) {
    return _remoteRepo.saveCompanyRepresentativeInfo(request: request);
  }

  @override
  Future<ApiResponse> saveCompanyBankAccount({required RequestBody request}) {
    return _remoteRepo.saveCompanyBankAccount(request: request);
  }

  @override
  Future<ApiResponse> fetchAllCompanies({required RequestBody request}) {
    return _remoteRepo.allCompanies(request: request);
  }

  @override
  Future<ApiResponse> fetchMyCompanies({required RequestBody request}) {
    return _remoteRepo.myAllCompanies(request: request);
  }

  @override
  Future<ApiResponse> updateStatus({required RequestBody request}) {
    return _remoteRepo.acceptAssociationRequest(request: request);
  }

  @override
  Future<ApiResponse> addCompany({required RequestBody request}) {
    return _remoteRepo.addCompany(request: request);
  }

  @override
  Future<ApiResponse> updateCompany({required RequestBody request}) {
    return _remoteRepo.updateCompany(request: request);
  }

  @override
  Future<ApiResponse> enableDisableCompany({required RequestBody request}) {
    return _remoteRepo.enableDisableCompany(request: request);
  }
}
