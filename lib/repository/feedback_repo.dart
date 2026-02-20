import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class FeedbackRepo {
  Future<ApiResponse> fetchFeedbacks({required RequestBody request});
  Future<ApiResponse> submitFeedback({required RequestBody request});
  Future<ApiResponse> deleteFeedback({required RequestBody request});
  Future<ApiResponse> feedbackDetails({required RequestBody request});
  Future<ApiResponse> updateFeedbackStatus({required RequestBody request});
  Future<ApiResponse> assignFeedback({required RequestBody request});
  Future<ApiResponse> submitFeedbackResponse({required RequestBody request});
  Future<ApiResponse> allFeedbacksPaginated({required RequestBody request});
  Future<ApiResponse> feedbackByUserIdPaginated({required RequestBody request});
}

class FeedbackRepoImpl implements FeedbackRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchFeedbacks({required RequestBody request}) {
    return _remoteRepo.fetchFeedbacks(request: request);
  }

  @override
  Future<ApiResponse> submitFeedback({required RequestBody request}) {
    return _remoteRepo.submitFeedback(request: request);
  }
  @override
  Future<ApiResponse> deleteFeedback({required RequestBody request}) {
    return _remoteRepo.deleteFeedback(request: request);
  }

  @override
  Future<ApiResponse> feedbackDetails({required RequestBody request}) {
    return _remoteRepo.feedbackDetails(request: request);
  }

  @override
  Future<ApiResponse> updateFeedbackStatus({required RequestBody request}) {
    return _remoteRepo.updateFeedbackStatus(request: request);
  }

  @override
  Future<ApiResponse> assignFeedback({required RequestBody request}) {
    return _remoteRepo.assignFeedback(request: request);
  }

  @override
  Future<ApiResponse> submitFeedbackResponse({required RequestBody request}) {
    return _remoteRepo.submitFeedbackResponse(request: request);
  }

  @override
  Future<ApiResponse> allFeedbacksPaginated({required RequestBody request}) {
    return _remoteRepo.allFeedbacksPaginated(request: request);
  }

  @override
  Future<ApiResponse> feedbackByUserIdPaginated({required RequestBody request}) {
    return _remoteRepo.feedbackByUserIdPaginated(request: request);
  }


}
