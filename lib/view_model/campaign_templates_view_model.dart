import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/network/service/network_service_impl.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/campaign_template.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';

class CampaignTemplatesViewModel extends GetxController with GenericMixin {
  final NetworkServiceImpl _networkService = NetworkServiceImpl();

  RxList<CampaignTemplate> templates = <CampaignTemplate>[].obs;
  Rx<CampaignTemplateStats> stats = CampaignTemplateStats(
    total: 0,
    accepted: 0,
    pending: 0,
    rejected: 0,
    returned: 0,
    drafted: 0,
    active: 0,
    inActive: 0,
  ).obs;

  RxList<StatsData> statsList = <StatsData>[
    StatsData(
        title: "Total",
        value: "0",
        titleStyle: AppTextStyle.darkBrown12spTextStyle1,
        valueStyle: AppTextStyle.darkBrown20spTextStyle1,
        backgroundColor: const Color.fromARGB(255, 255, 236, 202)),
    StatsData(
        title: "Active",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: const Color.fromARGB(255, 204, 255, 170)),
    StatsData(
        title: "InActive",
        value: "0",
        titleStyle: AppTextStyle.red12spTextStyle,
        valueStyle: AppTextStyle.red16spTextStyle,
        backgroundColor: const Color.fromARGB(255, 255, 168, 168)),
  ].obs;

  RxInt currentPage = 1.obs;
  RxInt pageSize = 10.obs;
  RxInt totalRecords = 0.obs;
  RxBool isLoading = false.obs;
  RxBool hasMoreData = true.obs;

  late ScrollController scrollController;
  TextEditingController searchController = TextEditingController();

  bool canView = true;
  bool canAdd = true;
  bool canEdit = true;
  bool canDelete = true;
  bool canExport = true;

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    fetchTemplates();
    super.onInit();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (hasMoreData.value && !isLoading.value) {
        currentPage.value++;
        fetchTemplates(loadMore: true);
      }
    }
  }

  Future<void> fetchTemplates(
      {bool loadMore = false, bool clear = false}) async {
    if (clear) {
      currentPage.value = 1;
      templates.clear();
      hasMoreData.value = true;
    }

    if (isLoading.value) return;
    isLoading.value = true;

    try {
      String endpoint =
          "emailer/GetAllEmailTemplateListPaginated?pageNumber=${currentPage.value}&pageSize=${pageSize.value}";

      if (searchController.text.isNotEmpty) {
        endpoint += "&templateName=${searchController.text}";
      }

      final apiResponse = await _networkService.fetchLookUpData(
        request: RequestBody(endPoint: endpoint),
      );

      if (apiResponse.appState == AppState.onSuccess) {
        BaseApiModel baseApiModel = apiResponse.data;
        totalRecords.value = baseApiModel.totalRecords ?? 0;

        // Parse stats from the response, with fallback to top-level counts
        stats.value = CampaignTemplateStats(
          total: baseApiModel.stats.total != 0
              ? baseApiModel.stats.total
              : (baseApiModel.totalRecords ?? 0),
          accepted: baseApiModel.stats.accepted,
          pending: baseApiModel.stats.pending,
          rejected: baseApiModel.stats.rejected,
          returned: baseApiModel.stats.returned,
          drafted: 0,
          active: baseApiModel.stats.active != 0
              ? baseApiModel.stats.active
              : (baseApiModel.activeCount ?? 0),
          inActive: baseApiModel.stats.inActive != 0
              ? baseApiModel.stats.inActive
              : (baseApiModel.inactiveCount ?? 0),
        );

        _updateStatsList();

        // Parse templates from the data list
        List<CampaignTemplate> templatesList = List<CampaignTemplate>.from(
            baseApiModel.data.map(
                (x) => CampaignTemplate.fromJson(x as Map<String, dynamic>)));

        if (loadMore) {
          templates.addAll(templatesList);
        } else {
          templates.value = templatesList;
        }

        hasMoreData.value = templates.length < totalRecords.value;
      } else {
        Utils.handleAPIError(apiResponse);
      }
    } catch (e) {
      Utils.showGlobalSnackBar(message: "Error loading templates: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStatsList() {
    statsList[0].value = stats.value.total.toString();
    statsList[1].value = stats.value.active.toString();
    statsList[2].value = stats.value.inActive.toString();
    statsList.refresh();
  }

  void createTemplate() {
    Utils.showGlobalSnackBar(
        message: "Create template functionality coming soon");
  }

  void toggleTemplateStatus(CampaignTemplate template) {
    // Optimistic UI update
    int index = templates.indexWhere((element) => element.id == template.id);
    if (index != -1) {
      // Create a copy with toggled status if your model supports it,
      // otherwise fetch again or update manually
      Utils.showGlobalSnackBar(
          message: "Status update functionality coming soon");
    }
  }

  void onMenuSelected(String value, CampaignTemplate template) {
    switch (value) {
      case 'view':
        viewTemplate(template);
        break;
      case 'edit':
        editTemplate(template);
        break;
      case 'delete':
        deleteTemplate(template);
        break;
    }
  }

  void viewTemplate(CampaignTemplate template) {
    Get.dialog(
      AlertDialog(
        title: Text(template.templateName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status: ${template.isActive ? "Active" : "Inactive"}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Category: ${template.category ?? "N/A"}'),
              const SizedBox(height: 8),
              if (template.emailerDescriptionHtml != null) ...[
                Text('Description:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(template.emailerDescriptionHtml ?? '',
                    maxLines: 5, overflow: TextOverflow.ellipsis),
              ]
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void editTemplate(CampaignTemplate template) {
    Utils.showGlobalSnackBar(message: "Edit functionality coming soon");
  }

  void deleteTemplate(CampaignTemplate template) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Template'),
        content:
            Text('Are you sure you want to delete "${template.templateName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Utils.showGlobalSnackBar(
                  message: "Delete functionality coming soon");
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void exportTemplates() {
    Utils.showGlobalSnackBar(message: "Export functionality coming soon");
  }

  void filterBottomSheet() {
    Utils.showGlobalSnackBar(message: "Filter functionality coming soon");
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
