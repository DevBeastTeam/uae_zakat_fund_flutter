import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
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
        title: "total",
        value: "0",
        backColor: const Color(0xffFFF9E7),
        style: const TextStyle(
            color: Color(0xffFFB800), fontWeight: FontWeight.bold),
      ),
      DashboardData(
        title: "activeCount",
        value: "0",
        backColor: const Color(0xffE8F5E9),
        style: const TextStyle(
            color: Color(0xff2E7D32), fontWeight: FontWeight.bold),
      ),
      DashboardData(
        title: "inactiveCount",
        value: "0",
        backColor: const Color(0xffFFEBEE),
        style: const TextStyle(
            color: Color(0xffC62828), fontWeight: FontWeight.bold),
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
      final campaignResponse = CampaignResponse.fromJson(response.data);
      if (isRefresh) {
        campaigns.value = campaignResponse.data;
      } else {
        campaigns.addAll(campaignResponse.data);
      }
      totalRecords.value = campaignResponse.totalRecords;
      activeCount.value = campaignResponse.activeCount;
      inactiveCount.value = campaignResponse.inactiveCount;
      stats.value = campaignResponse.stats;
      _updateStatsList();
    } else {
      Utils.handleAPIError(response);
    }
  }

  void _updateStatsList() {
    statsList[0].value = stats.value.total.toString();
    statsList[1].value = activeCount.value.toString();
    statsList[2].value = inactiveCount.value.toString();
    statsList.refresh();
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
