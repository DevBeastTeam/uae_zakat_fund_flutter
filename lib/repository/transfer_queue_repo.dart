import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class TransferQueueRepo {
  Future<ApiResponse> fetchFundTransferQueue({required RequestBody request});
}

class TransferQueueRepoImpl implements TransferQueueRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchFundTransferQueue({required RequestBody request}) {
    return _remoteRepo.fundTransferQueue(request: request);
  }
}
