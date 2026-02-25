import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class WalletRepo {
  Future<ApiResponse> fetchMyWalletDetails({required RequestBody request});
}

class WalletRepoImpl implements WalletRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchMyWalletDetails({required RequestBody request}) {
    return _remoteRepo.myWallet(request: request);
  }
}
