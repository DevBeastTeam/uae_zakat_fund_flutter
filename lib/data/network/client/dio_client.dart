import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';

class DioClient {
  static DioClient? _instance;
  late Dio dio;

  factory DioClient() {
    _instance ??= DioClient._initialize();
    return _instance!;
  }

  DioClient._initialize() {
    dio = Dio(BaseOptions(baseUrl:FlavorConfig.baseUrl))
      ..options.contentType = Headers.jsonContentType;
    //if (!kReleaseMode) {

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    //}
  }

  static DioClient? get instance => _instance;
}
