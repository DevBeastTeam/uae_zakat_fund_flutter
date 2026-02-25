import 'package:zakat_fund/data/remote/remote_repo.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class SurveyRepo {
  Future<ApiResponse> fetchSurveyDetails({required RequestBody request});
}

class SurveyRepoImpl implements SurveyRepo {
  final RemoteRepo _remoteRepo = RemoteRepo();

  @override
  Future<ApiResponse> fetchSurveyDetails({required RequestBody request}) {
    return _remoteRepo.surveyDetails(request: request);
  }
}
