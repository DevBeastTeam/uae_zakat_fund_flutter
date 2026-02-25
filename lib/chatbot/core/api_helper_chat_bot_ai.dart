import 'dart:developer';

import 'package:dio/dio.dart';

class ApiHelperChatBotAi {
  Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
    'lang': "en",
  };

  Dio get dio => Dio(
    BaseOptions(
      headers: headers,
      baseUrl: "https://dev.awqaf.bot.araby.ai/api/",
      sendTimeout: const Duration(milliseconds: 100000),
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    ),
  );

  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? query,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    try {
      final Response response = await dio.get(url, queryParameters: query);
      final responseJson = response.data;
      logRequestInfo(
        url,
        response: responseJson,
        server: dio.options.baseUrl,
        query: query.toString(),
      );
      return responseJson;
    } catch (e) {
      log("Error: ${e.toString()}");
      logRequestInfo(url, server: dio.options.baseUrl);
    }
  }

  Future<dynamic> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, dynamic>? query,
  }) async {
    try {
      final Response response = await dio.post(
        url,
        data: body,
        queryParameters: query,
      );
      final responseJson = response.data;

      logRequestInfo(
        url,
        body: body.toString(),
        response: responseJson,
        query: query.toString(),
        server: dio.options.baseUrl,
      );
      return responseJson;
    } catch (e) {
      log("Error: ${e.toString()}");
      logRequestInfo(url, server: dio.options.baseUrl, body: body.toString());
    }
  }

  void logRequestInfo(
    String url, {
    String? body,
    String? query,
    dynamic response,
    String? server,
  }) {
    log('server: $server');
    log('url: $url');
    if (body != null) log('body: $body');
    if (query != null) log('query: $query');
    log('headers: $headers');
    log('response: $response');
    // log('Config: ${Config.refreshTokenExpiryTime}');
  }

  void throwInternetException(DioException e) {
    log('e: $e');
    log('error response: ${e.response}');
    if (e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      String message = "NO INTERNET FOUND!";
      log(message);
    }
  }
}
