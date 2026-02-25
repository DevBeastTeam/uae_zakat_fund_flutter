import 'package:dio/dio.dart';
import 'package:zakat_fund/data/network/client/dio_client.dart';
import 'package:zakat_fund/data/network/client/network_client.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/utils.dart';

class NetworkClientImpl implements NetworkClient {
  Dio dio = DioClient.instance!.dio;

  @override
  Future deleteRequest({
    required RequestBody request,
    required String endPoint,
  }) async {
    Response response = await dio.delete(
      endPoint,
      queryParameters: request.queryParameters,
      data: request.body,
    );
    return response;
  }

  @override
  Future getRequest({
    required RequestBody request,
    required String endPoint,
  }) async {
    addHeaders(request.isFormDataRequest);
    Response response = await dio.get(
      endPoint,
      queryParameters: request.queryParameters,
    );
    return response;
  }

  @override
  Future postRequest({
    required RequestBody request,
    required String endPoint,
  }) async {
    addHeaders(request.isFormDataRequest);
    Response response = await dio.post(
      endPoint,
      queryParameters: request.queryParameters,
      data: request.isFormDataRequest ? request.formData : request.body,
    );
    return response;
  }

  @override
  Future putRequest({
    required RequestBody request,
    required String endPoint,
  }) async {
    addHeaders(request.isFormDataRequest);
    Response response = await dio.put(
      endPoint,
      queryParameters: request.queryParameters,
      data: request.body,
    );
    return response;
  }

  addHeaders(bool isFormDataRequest) {
    if (userBox.isNotEmpty) {
      User user = userBox.getAt(0);
      dio.options.headers = {
        if (isFormDataRequest)
          "Content-Type": Headers.multipartFormDataContentType,
        "Authorization": "Bearer ${user.bearerToken}",
        "accountid": user.accountId??0,
        "role": user.roles[0],
        "Accept-Language": Utils.isArabic?"ar":"en"
      };
    } else {
      dio.options.headers = {
        "Content-Type": Headers.jsonContentType,
        "Accept-Language": Utils.isArabic?"ar":"en"
      };
    }
  }
}
