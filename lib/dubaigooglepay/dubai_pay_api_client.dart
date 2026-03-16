import 'package:dio/dio.dart';
import 'dart:convert';
import 'dubai_pay_models.dart';
import 'dubai_pay_signature.dart';

class DubaiPayApiClient {
  final Dio _dio;
  final String basicAuthToken;
  final String secretKey;

  // QA Base URL
  // "https://api.qa.dubai.gov.ae/secure/sdg/dubaipay/payment/2.0.0"
  // PROD Base URL (To be updated by client when going live)
  final String baseUrl;

  DubaiPayApiClient({
    required this.basicAuthToken,
    required this.secretKey,
    required this.baseUrl,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic $basicAuthToken',
          },
        ));

  Map<String, dynamic> _buildHeaders(String jsonPayload) {
    // Generate signature for payload
    String signature = DubaiPaySignature.generateHMAC(jsonPayload, secretKey);
    return {
      'dubaiPaySignature': signature,
    };
  }

  Future<DubaiPayTransactionResponse> register(InitiateRequest request) async {
    final payload = request.toJson();
    final jsonStr = jsonEncode(payload);

    try {
      final response = await _dio.post(
        '/register',
        data: jsonStr,
        options: Options(
          headers: _buildHeaders(jsonStr),
        ),
      );

      return DubaiPayTransactionResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return DubaiPayTransactionResponse.fromJson(e.response!.data);
      }
      throw Exception('Failed to register translation: ${e.message}');
    }
  }

  Future<DubaiPayTransactionResponse> inquire(StatusRequest request) async {
    final payload = request.toJson();
    final jsonStr = jsonEncode(payload);

    try {
      final response = await _dio.post(
        '/inquire',
        data: jsonStr,
        options: Options(
          headers: _buildHeaders(jsonStr),
        ),
      );

      return DubaiPayTransactionResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return DubaiPayTransactionResponse.fromJson(e.response!.data);
      }
      throw Exception('Failed to inquire translation: ${e.message}');
    }
  }

  Future<DubaiPayTransactionResponse> confirm(StatusRequest request) async {
    final payload = request.toJson();
    final jsonStr = jsonEncode(payload);

    try {
      final response = await _dio.post(
        '/confirm',
        data: jsonStr,
        options: Options(
          headers: _buildHeaders(jsonStr),
        ),
      );

      return DubaiPayTransactionResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return DubaiPayTransactionResponse.fromJson(e.response!.data);
      }
      throw Exception('Failed to confirm translation: ${e.message}');
    }
  }

  Future<DubaiPayTransactionResponse> query(StatusRequest request) async {
    final payload = request.toJson();
    final jsonStr = jsonEncode(payload);

    try {
      final response = await _dio.post(
        '/query',
        data: jsonStr,
        options: Options(
          headers: _buildHeaders(jsonStr),
        ),
      );

      return DubaiPayTransactionResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return DubaiPayTransactionResponse.fromJson(e.response!.data);
      }
      throw Exception('Failed to query translation: ${e.message}');
    }
  }
}
