import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class CartRepo {
  Future<ApiResponse> addToCart({required RequestBody request});

  Future<ApiResponse> fetchCart({required RequestBody request});

  Future<ApiResponse> deleteCartProduct({required RequestBody request});

  Future<ApiResponse> deleteAllCart({required RequestBody request});

  Future<ApiResponse> updateCartItem({required RequestBody request});

  Future<ApiResponse> updateUserCart({required RequestBody request});
}

class CartRepoImpl implements CartRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchCart({required RequestBody request}) {
    return _remoteRepo.fetchCart(request: request);
  }

  @override
  Future<ApiResponse> addToCart({required RequestBody request}) {
    return _remoteRepo.addToCart(request: request);
  }

  @override
  Future<ApiResponse> deleteCartProduct({required RequestBody request}) {
    return _remoteRepo.deleteCartProduct(request: request);
  }

  @override
  Future<ApiResponse> deleteAllCart({required RequestBody request}) {
    return _remoteRepo.deleteAllCart(request: request);
  }

  @override
  Future<ApiResponse> updateCartItem({required RequestBody request}) {
    return _remoteRepo.updateCartItem(request: request);
  }

  @override
  Future<ApiResponse> updateUserCart({required RequestBody request}) {
    return _remoteRepo.updateUserCart(request: request);
  }
}
