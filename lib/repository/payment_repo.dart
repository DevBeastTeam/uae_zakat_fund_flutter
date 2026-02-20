import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class PaymentRepo {
  Future<ApiResponse> offlinePayment({required RequestBody request});
  Future<ApiResponse> fetchWalletBalance({required RequestBody request});
  Future<ApiResponse> payViaWallet({required RequestBody request});
}

class PaymentRepoImpl implements PaymentRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> offlinePayment({required RequestBody request}) {
    return _remoteRepo.offlinePayment(request: request);
  }

  @override
  Future<ApiResponse> fetchWalletBalance({required RequestBody request}) {
    return _remoteRepo.walletBalance(request: request);
  }

  @override
  Future<ApiResponse> payViaWallet({required RequestBody request}) {
    return _remoteRepo.payViaWallet(request: request);
  }
}
