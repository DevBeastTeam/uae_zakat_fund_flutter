import 'package:dio/dio.dart';

class RequestBody {
  Map<String, dynamic>? queryParameters;
  Object? body;
  bool isFormDataRequest;
  FormData? formData;
  String? endPoint;

  RequestBody({
    this.queryParameters,
    this.body,
    this.formData,
    this.endPoint,
    this.isFormDataRequest = false,
  });
}