import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class FavouriteRepo {
  Future<ApiResponse> favoriteProjects({required RequestBody request});
  Future<ApiResponse> favouriteNews({required RequestBody request});
  Future<ApiResponse> favouriteServices({required RequestBody request});

}

class FavouriteRepoImpl implements FavouriteRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> favoriteProjects({required RequestBody request}) {
    return _remoteRepo.favoriteProjects(request: request);
  }

  @override
  Future<ApiResponse> favouriteNews({required RequestBody request}) {
    return _remoteRepo.favouriteNews(request: request);
  }

  @override
  Future<ApiResponse> favouriteServices({required RequestBody request}) {
    return _remoteRepo.favouriteServices(request: request);
  }

}
