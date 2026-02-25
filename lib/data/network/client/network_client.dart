import 'package:zakat_fund/model/request_body.dart';

abstract class NetworkClient {
  Future postRequest({
    required RequestBody request,
    required String endPoint,
  });

  Future getRequest({
    required RequestBody request,
    required String endPoint,
  });

  Future putRequest({
    required RequestBody request,
    required String endPoint,
  });

  Future deleteRequest({
    required RequestBody request,
    required String endPoint,
  });
}
