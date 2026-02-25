import 'package:zakat_fund/data/response/app_state.dart';

class ApiResponse<T> {
  AppState? appState;
  T? data;
  String? message;

  ApiResponse(this.appState, this.data, this.message);

  ApiResponse.loading() : appState = AppState.onLoading;

  ApiResponse.unauthorized() : appState = AppState.onUnauthorized;

  ApiResponse.completed(this.data) : appState = AppState.onSuccess;

  ApiResponse.noInternet() : appState = AppState.noInternet;

  ApiResponse.error(this.message) : appState = AppState.onFailure;

  @override
  String toString() {
    return "AppState : $appState \n Message : $message \n Data : $data";
  }
}
