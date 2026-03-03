import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/campaign.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class CampaignsAdminViewModel extends GetxController {
  final GenericRepo genericRepo = GenericRepoImpl();

  RxInt totalRecords = 0.obs;
  RxInt activeCount = 0.obs;
  RxInt inactiveCount = 0.obs;
  RxList<Campaign> campaigns = <Campaign>[].obs;
  Rx<CampaignStats> stats = CampaignStats(
    total: 0,
    accepted: 0,
    pending: 0,
    rejected: 0,
    returned: 0,
    drafted: 0,
  ).obs;

  RxList<DashboardData> statsList = <DashboardData>[].obs;
  RxBool isLoading = false.obs;
  RxInt pageNumber = 1.obs;
  RxInt pageSize = 10.obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initStatsList();
    fetchCampaigns();
  }

  void _initStatsList() {
    statsList.value = [
      DashboardData(
        title: "Total",
        value: "0",
        backColor: const Color(0xffFFF9E7),
        labelColor: const Color(0xffD69E2E),
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xffD69E2E),
        ),
      ),
      DashboardData(
        title: "Approved",
        value: "0",
        backColor: const Color(0xffE6F4EA),
        labelColor: const Color(0xff1E7E34),
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xff1E7E34),
        ),
      ),
      DashboardData(
        title: "Pending",
        value: "0",
        backColor: const Color(0xffFFF4E5),
        labelColor: const Color(0xffA17111),
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xffA17111),
        ),
      ),
      DashboardData(
        title: "Returned",
        value: "0",
        backColor: const Color(0xffFFF1F1),
        labelColor: const Color(0xffE53E3E),
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xffE53E3E),
        ),
      ),
      DashboardData(
        title: "Rejected",
        value: "0",
        backColor: const Color(0xffFFF1F1),
        labelColor: const Color(0xffE53E3E),
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xffE53E3E),
        ),
      ),
    ];
  }

  Future<void> fetchCampaigns({bool isRefresh = false}) async {
    if (isRefresh) {
      pageNumber.value = 1;
      campaigns.clear();
    }

    isLoading.value = true;
    final queryParams = {
      "pageNumber": pageNumber.value.toString(),
      "pageSize": pageSize.value.toString(),
      if (searchController.text.isNotEmpty)
        "compaignName": searchController.text,
    };

    final response = await genericRepo.fetchCampaignsList(
      request: RequestBody(
        endPoint: ApiConstant.allCampaignListPaginated,
        queryParameters: queryParams,
      ),
    );

    isLoading.value = false;
    if (response.appState == AppState.onSuccess) {
      if (response.data is! BaseApiModel) {
        debugPrint(
            "Error: Expected BaseApiModel, but got ${response.data.runtimeType}");
      }
      final baseApiModel = response.data as BaseApiModel;
      final List<dynamic> dataList =
          baseApiModel.data is List ? baseApiModel.data : [];
      final List<Campaign> items = dataList
          .map((x) => Campaign.fromJson(x as Map<String, dynamic>))
          .toList();

      if (isRefresh) {
        campaigns.value = items;
      } else {
        campaigns.addAll(items);
      }
      totalRecords.value = baseApiModel.totalRecords;
      activeCount.value = baseApiModel.activeCount;
      inactiveCount.value = baseApiModel.inactiveCount;
      stats.value = CampaignStats(
        total: baseApiModel.stats.total,
        accepted: baseApiModel.stats.accepted,
        pending: baseApiModel.stats.pending,
        rejected: baseApiModel.stats.rejected,
        returned: baseApiModel.stats.returned,
        drafted: baseApiModel.stats.drafted,
      );
      _updateStatsList();
    } else {
      Utils.handleAPIError(response);
    }
  }

  void _updateStatsList() {
    if (statsList.length >= 5) {
      statsList[0].value = stats.value.total.toString();
      statsList[1].value = stats.value.accepted.toString();
      statsList[2].value = stats.value.pending.toString();
      statsList[3].value = stats.value.returned.toString();
      statsList[4].value = stats.value.rejected.toString();
      statsList.refresh();
    }
  }

  void onSearch(String value) {
    fetchCampaigns(isRefresh: true);
  }

  void loadMore() {
    if (campaigns.length < totalRecords.value) {
      pageNumber.value++;
      fetchCampaigns();
    }
  }

  // Placeholder actions
  void createCampaign() {}
  void exportCampaigns() {}
  void filterBottomSheet() {}
  void openCampaignDetails(Campaign campaign) {}
}
