import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/model/campaign_template.dart';
import 'package:zakat_fund/data/network/service/network_service_impl.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/base_api_model.dart';

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

  Future<void> fetchTemplates({bool loadMore = false, bool clear = false}) async {
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

      final apiResponse = await _networkService.fetchLookUpData(
        request: RequestBody(endPoint: endpoint),
      );

      if (apiResponse.appState == AppState.onSuccess) {
        BaseApiModel baseApiModel = apiResponse.data;
        totalRecords.value = baseApiModel.totalRecords ?? 0;

        // Parse stats from the response
        stats.value = CampaignTemplateStats(
          total: baseApiModel.stats?.total ?? 0,
          accepted: baseApiModel.stats?.accepted ?? 0,
          pending: baseApiModel.stats?.pending ?? 0,
          rejected: baseApiModel.stats?.rejected ?? 0,
          returned: baseApiModel.stats?.returned ?? 0,
          drafted: 0,
          active: baseApiModel.stats?.active ?? 0,
          inActive: baseApiModel.stats?.inActive ?? 0,
        );

        // Parse templates from the data list
        List<CampaignTemplate> templatesList = List<CampaignTemplate>.from(
            baseApiModel.data.map((x) => CampaignTemplate.fromJson(x as Map<String, dynamic>)));

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
                Text('Description:', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(template.emailerDescriptionHtml ?? '', maxLines: 5, overflow: TextOverflow.ellipsis),
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
        content: Text('Are you sure you want to delete "${template.templateName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Utils.showGlobalSnackBar(message: "Delete functionality coming soon");
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

