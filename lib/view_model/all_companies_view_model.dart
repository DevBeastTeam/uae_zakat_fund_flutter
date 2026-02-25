import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/association_company_info.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/association_repo.dart';
import 'package:zakat_fund/repository/company_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class AllCompaniesViewModel extends ModulePermissionsViewModel
    with GenericMixin {
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  final rejectionNotes = TextEditingController();
  final establishDate = TextEditingController();
  final creationDate = TextEditingController();
  final scrollController = ScrollController();

  final associationRepo = AssociationRepoImpl();
  final companyRepo = CompanyRepoImpl();

  RxList<Association> associations = <Association>[].obs;
  RxList<Company> companies = <Company>[].obs;
  RxList<AssociationAndCompanyInfo> associationCompanyData =
      <AssociationAndCompanyInfo>[].obs;
  RxList<StatsData> stats = [
    StatsData(
      title: "total",
      value: "0",
      titleStyle: AppTextStyle.btnBackground12spTextStyle1,
      valueStyle: AppTextStyle.btnBackground16spTextStyle,
      backgroundColor: AppColors.btnBackgroundColor,
    ),
    StatsData(
      title: "approved",
      value: "0",
      titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
      valueStyle: AppTextStyle.darkGreen16spTextStyle1,
      backgroundColor: AppColors.darkGreenColor,
    ),
    StatsData(
      title: "pending",
      value: "0",
      titleStyle: AppTextStyle.lightBrown12spTextStyle2,
      valueStyle: AppTextStyle.lightBrown16spTextStyle1,
      backgroundColor: AppColors.lightBrownColor1,
    ),
    StatsData(
      title: "returned",
      value: "0",
      titleStyle: AppTextStyle.highBack12spTextStyle,
      valueStyle: AppTextStyle.highBack16spTextStyle,
      backgroundColor: AppColors.highBackColor,
    ),
    StatsData(
      title: "rejected",
      value: "0",
      titleStyle: AppTextStyle.highBack12spTextStyle,
      valueStyle: AppTextStyle.highBack16spTextStyle,
      backgroundColor: AppColors.highBackColor,
    )
  ].obs;
  Rxn<String> selectedStatus = Rxn<String>();
  Rxn<String> selectedActiveStatus = Rxn<String>();
  Rxn<LookupData> selectedType = Rxn<LookupData>();

  List<Association> allAssociations = [];
  List<Company> allCompanies = [];
  List<LookupData> associationTypes = [];

  int totalRecords = 0;
  int currentPage = 1;
  int pageSize = 10;

  DateTime currentDate = DateTime.now();
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedEDateRange, selectedCDateRange;

  final accountViewModel = Get.find<AccountViewModel>();
  final formKey = GlobalKey<FormState>();
  late bool isAssociation;

  @override
  void onInit() {
    _initParams();
    scrollController.addListener(_scrollListener);
    Future.microtask(() => _initDataLoad());
    super.onInit();
  }

  void _initParams() {
    final data = Get.arguments;
    isAssociation = data["isAssociation"];
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
  }

  void _scrollListener() {
    final isEndOfList = scrollController.position.pixels ==
        scrollController.position.maxScrollExtent;
    if (!isEndOfList) return;
    if (user.isAdmin) {
      if (_isDataComplete()) return;
      currentPage++;
      isAssociation ? fetchAllAssociations() : fetchAllCompanies();
    } else {
      if (associationCompanyData.length == totalRecords) return;
      currentPage++;
      isAssociation ? fetchMyAssociations() : fetchMyCompanies();
    }
  }

  void _initDataLoad() {
    final screenEvent = isAssociation
        ? (user.isAdmin
            ? EventConstant.allAssociationsScreen
            : EventConstant.myAssociationsScreen)
        : (user.isAdmin
            ? EventConstant.allCompaniesScreen
            : EventConstant.myCompaniesScreen);
    Utils.logEvent(name: screenEvent);

    if (!canView) return;
    user.isAdmin
        ? (isAssociation ? fetchAllAssociations() : fetchAllCompanies())
        : (isAssociation ? fetchMyAssociations() : fetchMyCompanies());

    if (user.isAdmin) {
      fetchAssociationTypes();
    }
  }

  bool _isDataComplete() {
    return isAssociation
        ? associations.length >= totalRecords
        : companies.length >= totalRecords;
  }

  searchData() {
    if (isAssociation) {
      user.isAdmin
          ? fetchAllAssociations(clear: true)
          : fetchMyAssociations(clear: true);
    } else {
      user.isAdmin
          ? fetchAllCompanies(clear: true)
          : fetchMyCompanies(clear: true);
    }
  }

  Future fetchAssociationTypes() async {
    final result = await getLookUpData(
        endPoint: isAssociation
            ? ApiConstant.associationType
            : ApiConstant.companyTypes);
    associationTypes = result;
  }

  fetchCompanyProfile(String accountId) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await companyRepo.fetchCompanyProfile(
        request: RequestBody(
            endPoint:
                "${ApiConstant.companyProfile}/${user.id}/$accountId?isDrafted=true"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Company company = apiResponse.data;
      Get.toNamed(AppRoutes.companyScreen,
          arguments: {"data": company, "isEdit": false})?.then((_) {
        fetchMyCompanies(clear: true);
      });
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  fetchAssociationProfile(String accountId) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await associationRepo.fetchAssociationProfile(
        request: RequestBody(
            endPoint:
                "${ApiConstant.associationProfile}/${user.id}/$accountId?isDrafted=true"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Association association = apiResponse.data;
      Get.toNamed(AppRoutes.associationScreen,
          arguments: {"data": association, "isEdit": false})?.then((_) {
        fetchMyAssociations(clear: true);
      });
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  updateStatus(AssociationAndCompanyInfo info, {String? reason}) async {
    Utils.showLoadingDialog();
    var body = {
      "accountContactId": info.accountContactId,
      "status": reason == null ? 1 : 2,
      if (reason != null) "reason": "string"
    };
    ApiResponse apiResponse =
        await companyRepo.updateStatus(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      pageSize = associationCompanyData.length;
      if (isAssociation) {
        fetchMyAssociations(clear: true);
      } else {
        fetchMyCompanies(clear: true);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  rejectionDialog(AssociationAndCompanyInfo info) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  Text(
                    "notes".tr,
                    style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                  ),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.highlight_remove_outlined,
                        color: AppColors.secondaryPrimaryBlackColor,
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      LabelTextField(
                        controller: rejectionNotes,
                        isRequired: true,
                        checkValidation: true,
                        label: "addNote",
                        maxLines: 4,
                      ),
                      16.verticalSpace,
                      elevatedButton(
                          text: "send",
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            Get.back();
                            updateStatus(info, reason: rejectionNotes.text);
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    )).then((_) {
      Future.delayed(Duration(seconds: 1)).then((_) {
        rejectionNotes.clear();
      });
    });
  }

  Future<void> fetchAllAssociations({bool clear = false}) async {
    await _handleApiCall(
      clear: clear,
      isCompany: false,
      fetchFunction: associationRepo.fetchAssociationsList,
      onSuccess: (baseModel) {
        final data = List<Association>.from(
            baseModel.data.map((x) => Association.fromJson(x)));
        if (clear) {
          associations.value = data;
        } else {
          associations.addAll(data);
        }
      },
    );
  }

  Future<void> fetchAllCompanies({bool clear = false}) async {
    await _handleApiCall(
      clear: clear,
      isCompany: true,
      fetchFunction: companyRepo.fetchAllCompanies,
      onSuccess: (baseModel) {
        final data =
            List<Company>.from(baseModel.data.map((x) => Company.fromJson(x)));
        if (clear) {
          companies.value = data;
        } else {
          companies.addAll(data);
        }
      },
    );
  }

  setStatsData(Stats statsData) {
    stats[0].value = statsData.total.toString();
    stats[1].value = statsData.accepted.toString();
    stats[2].value = statsData.pending.toString();
    stats[3].value = statsData.returned.toString();
    stats[4].value = statsData.rejected.toString();
    stats.refresh();
  }

  Future<void> fetchMyAssociations({bool clear = false}) async {
    await _handleApiCall(
      clear: clear,
      isCompany: false,
      isMine: true,
      fetchFunction: associationRepo.fetchMyAssociations,
      onSuccess: (baseModel) {
        final data = List<AssociationAndCompanyInfo>.from(
            baseModel.data.map((x) => AssociationAndCompanyInfo.fromJson(x)));
        if (clear) {
          associationCompanyData.value = data;
        } else {
          associationCompanyData.addAll(data);
        }
      },
    );
  }

  Future<void> fetchMyCompanies({bool clear = false}) async {
    await _handleApiCall(
      clear: clear,
      isCompany: true,
      isMine: true,
      fetchFunction: companyRepo.fetchMyCompanies,
      onSuccess: (baseModel) {
        final data = List<AssociationAndCompanyInfo>.from(
            baseModel.data.map((x) => AssociationAndCompanyInfo.fromJson(x)));
        if (clear) {
          associationCompanyData.value = data;
        } else {
          associationCompanyData.addAll(data);
        }
      },
    );
  }

  filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
        Padding(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetHeader(),
              Obx(() => LabelDropDown(
                    items: AppConstant.statuses,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                    label: 'status',
                  )),
              16.verticalSpace,
              if (user.isAdmin)
                Obx(() => LabelDropDown2(
                      items: associationTypes,
                      selectedValue: selectedType.value,
                      hint: "chooseAnOption",
                      onChanged: (value) => selectedType.value = value,
                      label: isAssociation ? 'associationType' : 'companyType',
                    )),
              if (user.isAdmin) 16.verticalSpace,
              LabelTextField(
                controller: establishDate,
                label: "dateOfEstablishment",
                isDate: true,
                readOnly: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                onTap: () => dateRangePicker(),
              ),
              16.verticalSpace,
              LabelTextField(
                controller: creationDate,
                label: "creationDate",
                isDate: true,
                readOnly: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                onTap: () => dateRangePicker(cDate: true),
              ),
              if (user.isAdmin) 16.verticalSpace,
              if (user.isAdmin)
                Obx(() => LabelDropDown(
                      items: AppConstant.activeInActiveStatuses,
                      selectedValue: selectedActiveStatus.value,
                      hint: "chooseAnOption",
                      onChanged: (value) {
                        selectedActiveStatus.value = value;
                      },
                      label: '${"active".tr}/${"inactive".tr}',
                    )),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearFilter(),
                  onApply: () {
                    Get.back();
                    searchData();
                  })
            ],
          ),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    selectedStatus.value = null;
    selectedType.value = null;
    selectedActiveStatus.value = null;
    establishDate.clear();
    creationDate.clear();
    selectedEDateRange = null;
    selectedCDateRange = null;
    searchData();
  }

  dateRangePicker({bool cDate = false}) async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        cDate ? selectedCDateRange : selectedEDateRange,
        dateTimeRange,
        currentDate);
    if (newDateRange != null) {
      String date =
          "${Utils.dateFormat1.format(newDateRange.start)} - ${Utils.dateFormat1.format(newDateRange.end)}";
      if (cDate) {
        selectedCDateRange = newDateRange;
        creationDate.text = date;
      } else {
        selectedEDateRange = newDateRange;
        establishDate.text = date;
      }
    } else {
      if (cDate) {
        establishDate.clear();
        selectedCDateRange = null;
      } else {
        establishDate.clear();
        selectedEDateRange = null;
      }
    }
  }

  DateTime? pickedExpiry;

  datePickerDialog() async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: dateTime,
      firstDate: DateTime(1950),
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      fieldHintText: "dd/mm/yyyy",
      lastDate: dateTime,
    );
    String date = Utils.dateFormat1.format(picked!);
    pickedExpiry = picked;
    dateController.text = date;
  }

  enableDisableAssociation(Association associationDetails) async {
    Utils.showLoadingDialog();
    associationDetails.associationInfo!.isActive =
        !associationDetails.associationInfo!.isActive;
    var body = {
      "id": associationDetails.associationInfo?.userId,
      "isActive": associationDetails.associationInfo!.isActive,
      "accountId": associationDetails.associationInfo?.accountId,
      "userType": "Association"
    };
    ApiResponse apiResponse = await associationRepo.enableDisableAssociation(
        request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message: associationDetails.associationInfo!.isActive
              ? "userActivatedSuccessfully".tr
              : "userDeactivatedSuccessfully".tr);
      if (selectedActiveStatus.value != null) {
        associations.remove(associationDetails);
      }
      associations.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  enableDisableCompany(Company companyDetails) async {
    Utils.showLoadingDialog();
    companyDetails.accountInfo!.isActive =
        !companyDetails.accountInfo!.isActive;
    var body = {
      "id": companyDetails.accountInfo?.userId,
      "isActive": companyDetails.accountInfo!.isActive,
      "accountId": companyDetails.accountInfo!.accountId,
      "userType": "Company"
    };
    ApiResponse apiResponse = await companyRepo.enableDisableCompany(
        request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message: companyDetails.accountInfo!.isActive
              ? "userActivatedSuccessfully".tr
              : "userDeactivatedSuccessfully".tr);
      if (selectedActiveStatus.value != null) {
        companies.remove(companyDetails);
      }
      companies.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Map<String, dynamic> _buildQueryParameters(
      {required bool isCompany, bool isMine = false}) {
    final Map<String, dynamic> params = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
    };

    if (searchController.text.isNotEmpty) {
      params["searchText"] = searchController.text;
    }

    if (selectedType.value != null) {
      final typeValue = selectedType.value!.value;
      params[isCompany ? "companyType" : "associationType"] = typeValue;
    }

    if (selectedStatus.value != null) {
      params["status"] = Utils.statusIntoInt(selectedStatus.value!);
    }

    if (selectedActiveStatus.value != null) {
      params["isActive"] = selectedActiveStatus.value == "active";
    }

    if (selectedEDateRange != null) {
      params["dateOfEstablishmentStart"] =
          Utils.newDateFormat.format(selectedEDateRange!.start);
      params["dateOfEstablishmentEnd"] =
          Utils.newDateFormat.format(selectedEDateRange!.end);
    }

    if (selectedCDateRange != null) {
      params["CreationDateStart"] =
          Utils.newDateFormat.format(selectedCDateRange!.start);
      params["CreationDateEnd"] =
          Utils.newDateFormat.format(selectedCDateRange!.end);
    }

    if (isMine) {
      if (isCompany) {
        params["userid"] = user.id;
      } else {
        params["id"] = user.id;
      }
    }

    return params;
  }

  Future<void> _handleApiCall({
    required bool clear,
    required bool isCompany,
    required Future<ApiResponse> Function({required RequestBody request})
        fetchFunction,
    required Function(BaseApiModel baseModel) onSuccess,
    bool isMine = false,
  }) async {
    Utils.showLoadingDialog();
    if (clear) currentPage = 1;

    final params = _buildQueryParameters(isCompany: isCompany, isMine: isMine);
    final response =
        await fetchFunction(request: RequestBody(queryParameters: params));

    Utils.hideLoadingDialog();

    if (response.appState == AppState.onSuccess) {
      final baseModel = response.data as BaseApiModel;
      totalRecords = baseModel.totalRecords;
      if (!isMine) setStatsData(baseModel.stats);
      onSuccess(baseModel);
    } else {
      Utils.handleAPIError(response);
    }
  }

  exportAssociationCompany() {
    String url = "", fileName = "";
    if (user.isAdmin) {
      url =
          "${ApiConstant.exportFile}${isAssociation ? AppConstant.association : AppConstant.company}";
      fileName = isAssociation ? "Associations.csv" : "Companies.csv";
    } else {
      url =
          "${isAssociation ? ApiConstant.exportMyAssociations : ApiConstant.exportMyCompanies}${user.id}";
      fileName = isAssociation ? "My_Associations.csv" : "My_Companies.csv";
    }
    Utils.downloadFile(url: url, isExport: true, filename: fileName);
  }

  addNewAssociationCompany() {
    if (isAssociation) {
      Get.toNamed(AppRoutes.associationScreen,
          arguments: {"isEdit": false, "fromAdd": true})?.then((_) {
        fetchMyAssociations(clear: true);
      });
    } else {
      Get.toNamed(AppRoutes.companyScreen,
          arguments: {"isEdit": false, "fromAdd": true})?.then((_) {
        fetchMyCompanies(clear: true);
      });
    }
  }

  onPopupMenuSelected(String item, CompanyItemData data) {
    if (item == "view") {
      viewDetails(data.info, data.company, data.association);
    } else if (item == "accept") {
      updateStatus(data.info!);
    } else if (item == "edit") {
      isAssociation
          ? fetchAssociationProfile(data.id)
          : fetchCompanyProfile(data.id);
    } else {
      rejectionDialog(data.info!);
    }
  }

  viewDetails(AssociationAndCompanyInfo? info, Company? company,
      Association? association) {
    Get.toNamed(AppRoutes.associationPreviewScreen, arguments: {
      "isAssociation": association != null,
      "data": association ?? company
    });
    return;
  }

  enableDisable(int index) {
    if (isAssociation) {
      enableDisableAssociation(associations[index]);
    } else {
      enableDisableCompany(companies[index]);
    }
  }

  CompanyItemData extractItemData(int index) {
    if (user.isAdmin) {
      if (isAssociation) {
        final a = associations[index];
        final i = a.associationInfo!;
        final c = a.accountContact!;
        return CompanyItemData(
          id: i.accountId.toString(),
          name: i.accountName,
          nameAr: i.accountNameArabic,
          email: c.email,
          mobile: c.mobile,
          website: c.website ?? "",
          logo: i.accountLogo ?? "",
          status: i.requestStatus ?? 1,
          isActive: i.isActive,
          association: a,
        );
      } else {
        final c = companies[index];
        final i = c.accountInfo!;
        final cc = c.accountContact!;
        return CompanyItemData(
          id: i.accountId.toString(),
          name: i.accountName,
          nameAr: i.accountNameArabic,
          email: cc.email,
          mobile: cc.mobile,
          website: cc.website ?? "",
          logo: i.accountLogo ?? "",
          status: i.requestStatus,
          isActive: i.isActive,
          company: c,
        );
      }
    } else {
      final info = associationCompanyData[index];
      return CompanyItemData(
          id: info.accountContactId.toString(),
          name: info.accountName,
          nameAr: info.accountNameArabic,
          email: info.email,
          mobile: info.mobile,
          website: info.website ?? "",
          logo: info.accountLogo ?? "",
          status: info.status,
          info: info,
          requestStatus: info.requestStatus);
    }
  }

  String getTitle() => isAssociation ? "associationList" : "companyList";

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
    dateController.dispose();
    rejectionNotes.dispose();
    establishDate.dispose();
    creationDate.dispose();

    associations.close();
    companies.close();
    associationCompanyData.close();
    stats.close();
    selectedStatus.close();
    selectedActiveStatus.close();
    selectedType.close();

    super.onClose();
  }
}
