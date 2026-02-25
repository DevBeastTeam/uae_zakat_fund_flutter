import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/model/audit_logs.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class ActivityLogViewModel extends GetxController with GenericMixin {
  final scrollController = ScrollController();

  RxList<AuditLogs> activityLogs = <AuditLogs>[].obs;

  DateFormat dateFormatAMPM = DateFormat("dd/MM/yyyy, hh:mm a", Get.locale!.languageCode);

  late int id;

  int totalRecords = 0;
  int currentPage = 0;

  late String type;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    var data = Get.arguments;
    id = data["id"];
    type = data["type"];
    scrollController.addListener(_scrollListener);
    fetchActivityLogs();

  }

  _scrollListener(){
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        activityLogs.length < totalRecords) {
      currentPage++;
      fetchActivityLogs();
    }
  }

  fetchActivityLogs() async {
    Utils.showLoadingDialog();
    Map<String, dynamic> queryParameters = {
      "pageNumber": 1,
      "pageSize": 10,
      "entityType": type
    };
    final result = await getAuditLogByEntityId(queryParams: queryParameters, endPoint: "${ApiConstant.auditLogByEntityId}/$id");
    Utils.hideLoadingDialog();
    if(result!=null){
      BaseApiModel baseApiModel = result;
      totalRecords = baseApiModel.totalRecords;
      List<AuditLogs> logs = List<AuditLogs>.from(
          baseApiModel.data.map((log) => AuditLogs.fromJson(log)));
      activityLogs.addAll(logs);
    }

  }

  @override
  void onClose() {
    activityLogs.close();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    super.onClose();
  }

}
