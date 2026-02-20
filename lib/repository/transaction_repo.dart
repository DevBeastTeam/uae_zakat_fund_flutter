import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class TransactionRepo {
  Future<ApiResponse> fetchTransaction({required RequestBody request});

  Future<ApiResponse> refundRequest({required RequestBody request});

  Future<ApiResponse> refundHistory({required RequestBody request});

  Future<ApiResponse> donationHistory({required RequestBody request});

  Future<ApiResponse> donorDashboardData({required RequestBody request});

  Future<ApiResponse> downloadTaxCertificate({required RequestBody request});
  Future<ApiResponse> userDonations({required RequestBody request});
}

class TransactionRepoImpl implements TransactionRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchTransaction({required RequestBody request}) {
    return _remoteRepo.transactions(request: request);
  }

  @override
  Future<ApiResponse> refundRequest({required RequestBody request}) {
    return _remoteRepo.refundRequest(request: request);
  }

  @override
  Future<ApiResponse> refundHistory({required RequestBody request}) {
    return _remoteRepo.refundHistory(request: request);
  }

  @override
  Future<ApiResponse> donationHistory({required RequestBody request}) {
    return _remoteRepo.donationHistory(request: request);
  }

  @override
  Future<ApiResponse> donorDashboardData({required RequestBody request}) {
    return _remoteRepo.donorDashboardData(request: request);
  }

  @override
  Future<ApiResponse> downloadTaxCertificate({required RequestBody request}) {
    return _remoteRepo.downloadTaxCertificate(request: request);
  }

  @override
  Future<ApiResponse> userDonations({required RequestBody request}) {
    return _remoteRepo.userDonations(request: request);
  }
}
