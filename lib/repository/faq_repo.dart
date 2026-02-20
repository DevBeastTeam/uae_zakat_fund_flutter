import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class FaqRepo {
  Future<ApiResponse> fetchFAQCategories({required RequestBody request});

  Future<ApiResponse> fetchFAQs({required RequestBody request});

  Future<ApiResponse> fetchFAQPaginated({required RequestBody request});

  Future<ApiResponse> fetchFaqDetails({required RequestBody request});

  Future<ApiResponse> deleteFAQ({required RequestBody request});

  Future<ApiResponse> addFAQ({required RequestBody request});

  Future<ApiResponse> updateFAQ({required RequestBody request});

  Future<ApiResponse> enableDisableFAQ({required RequestBody request});
}

class FaqRepoImpl implements FaqRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchFAQCategories({required RequestBody request}) {
    return _remoteRepo.fetchFAQCategories(request: request);
  }

  @override
  Future<ApiResponse> fetchFAQs({required RequestBody request}) {
    return _remoteRepo.fetchFAQsByCategory(request: request);
  }

  @override
  Future<ApiResponse> fetchFaqDetails({required RequestBody request}) {
    return _remoteRepo.faqDetails(request: request);
  }

  @override
  Future<ApiResponse> deleteFAQ({required RequestBody request}) {
    return _remoteRepo.deleteFAQ(request: request);
  }

  @override
  Future<ApiResponse> addFAQ({required RequestBody request}) {
    return _remoteRepo.addFAQ(request: request);
  }

  @override
  Future<ApiResponse> updateFAQ({required RequestBody request}) {
    return _remoteRepo.updateFAQ(request: request);
  }

  @override
  Future<ApiResponse> fetchFAQPaginated({required RequestBody request}) {
    return _remoteRepo.faqPaginated(request: request);
  }

  @override
  Future<ApiResponse> enableDisableFAQ({required RequestBody request}) {
    return _remoteRepo.enableDisableFAQ(request: request);
  }
}
