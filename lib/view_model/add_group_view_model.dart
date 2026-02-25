import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/criteria.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/recipients_campaign.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/campaign_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/recipients_campaign_view_model.dart';

class AddGroupViewModel extends GetxController with GenericMixin {
  final formKey = GlobalKey<FormState>();

  RecipientsCampaign? recipients;

  final groupName = TextEditingController();

  List<CriteriaAttributes> associationAttributes = [
    CriteriaAttributes(
        key: "dateOfEstablishment", value: "EstablishmentDate", type: "date"),
    CriteriaAttributes(
        key: "associationType", value: "AccountTypeID", type: "dropdown"),
    CriteriaAttributes(
        key: "issuingAuthority", value: "IssuingAuthority", type: "dropdown"),
    CriteriaAttributes(
        key: "licenseExpiryDate", value: "LicenseExpiryDate", type: "date"),
  ];
  List<CriteriaAttributes> companyAttributes = [
    CriteriaAttributes(
        key: "dateOfEstablishment", value: "EstablishmentDate", type: "date"),
    CriteriaAttributes(
        key: "issuingAuthority", value: "IssuingAuthority", type: "dropdown"),
    CriteriaAttributes(
        key: "licenseExpiryDate", value: "LicenseExpiryDate", type: "date"),
  ];
  List<CriteriaAttributes> donorAttributes = [
    CriteriaAttributes(key: "gender", value: "Gender", type: "dropdown"),
    CriteriaAttributes(key: "hasPhoto", value: "HasPhoto", type: "boolean"),
    CriteriaAttributes(
        key: "jobDescription", value: "JobDescription", type: "dropdown"),
    CriteriaAttributes(key: "isVIP", value: "IsVIP", type: "boolean"),
    CriteriaAttributes(
        key: "nationality", value: "NationalityID", type: "dropdown"),
  ];
  List<CriteriaAttributes> employeeAttributes = [
    CriteriaAttributes(
        key: "jobTitle", value: "JobDescription", type: "dropdown"),
    CriteriaAttributes(
        key: "nationality", value: "NationalityID", type: "dropdown"),
    CriteriaAttributes(
        key: "isEmailVerified", value: "EmailConfirmed", type: "dropdown"),
    CriteriaAttributes(
        key: "isSMSVerified", value: "PhoneNumberConfirmed", type: "dropdown"),
    CriteriaAttributes(key: "isActive", value: "IsActive", type: "dropdown"),
  ];

  RxList<Criteria> criteria = <Criteria>[].obs;

  Rxn selectedGroupType = Rxn<String>();

  List associationType = [];
  List issuingAuthority = [];
  List jobs = [];

  List<LookupData> jobsList = [];
  List<LookupData> nationalitiesList = [];
  List<LookupData> issuingAuthorityList = [];
  List<LookupData> associationTypeList = [];

  List<String> nationalities = [];
  List<String> groupTypes = ["fixed", "dynamic"];
  List<String> genders = ["male", "female"];

  final genericRepo = GenericRepoImpl();
  final repo = CampaignRepoImpl();

  final recipientsViewModel = Get.find<RecipientsCampaignViewModel>();
  final accountViewModel = Get.find<AccountViewModel>();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    recipients = Get.arguments;
    nationalitiesList = accountViewModel.nationalitiesList;
    nationalities = accountViewModel.nationalities;
    if (recipients == null) {
      addCriteria();
    } else {
      setData();
    }
    Utils.logEvent(
        name: recipients != null
            ? EventConstant.updateRecipientGroupScreen
            : EventConstant.addNewRecipientGroupScreen);
  }

  setData() async {
    Utils.showLoadingDialog();
    await Future.wait(
        [fetchJobTitles(), fetchAuthorities(), fetchAssociationTypes()]);
    Utils.hideLoadingDialog();
    groupName.text = recipients!.groupName;
    selectedGroupType.value = recipients!.groupType == 1 ? "fixed" : "dynamic";
    for (Operation operation in recipients!.operation) {
      String userType = Utils.groupsTypesString(operation.userType.toString());
      var result = filterAttributes(userType);
      List<CriteriaAttributes> attributes = result.$1;
      CriteriaAttributes attribute =
          attributes.firstWhere((key) => key.value == operation.columnName);
      bool isDate = attribute.value == "date";
      dynamic value = "";
      List<String> dropDownValues = [];
      List<String> ranges = result.$2;
      String range = attribute.key;

      if (range == "associationType") {
        dropDownValues = List.from(associationType);
      } else if (range == "issuingAuthority") {
        dropDownValues = List.from(issuingAuthority);
      } else if (range == "nationality") {
        dropDownValues = List.from(nationalities);
      } else if (range == "jobDescription" || range == "jobTitle") {
        dropDownValues = List.from(jobs);
      }

      if (isDate) {
        value = operation.value;
      } else {
        if (["hasPhoto", "isVIP"].contains(range)) {
          value = operation.value == "1" ? "yes" : "no";
        } else if (range == "gender") {
          value = operation.value == "1" ? "male" : "female";
        } else if (range == "associationType") {
          LookupData lookupData = associationTypeList.firstWhere((filed) {
            return filed.value == int.parse(operation.value.toString());
          });
          value = Utils.isArabic
              ? lookupData.nameAr ?? lookupData.name
              : lookupData.name;
        } else if (range == "issuingAuthority") {
          LookupData lookupData = issuingAuthorityList.firstWhere((filed) {
            return filed.value == int.parse(operation.value.toString());
          });
          value = Utils.isArabic
              ? lookupData.nameAr ?? lookupData.name
              : lookupData.name;
        } else if (range == "nationality") {
          LookupData lookupData = nationalitiesList.firstWhere((filed) {
            return filed.value == int.parse(operation.value.toString());
          });
          value = Utils.isArabic
              ? lookupData.nameAr ?? lookupData.name
              : lookupData.name;
        } else if (range == "jobDescription" || range == "jobTitle") {
          LookupData lookupData = jobsList.firstWhere((filed) {
            return filed.value == int.parse(operation.value.toString());
          });
          value = Utils.isArabic
              ? lookupData.nameAr ?? lookupData.name
              : lookupData.name;
        }
      }

      criteria.add(Criteria(
          selectedUserType: userType,
          ranges: ranges,
          controller: TextEditingController(text: isDate ? value : ""),
          selectedRange: range,
          selectedDropDownValue: value,
          selectedLogicalOperation:
              operation.logicalOperator == 1 ? "and" : "or",
          selectedOperation:
              Utils.operatorIntoString(operation.operationOperator.toString()),
          dropDownValues: dropDownValues));
    }
  }

  updateRanges(String type, int index) {
    criteria[index].selectedUserType.value = type;
    criteria[index].selectedRange.value = null;
    if (type == "association") {
      criteria[index].ranges.value = List.from(AppConstant.associationRanges);
    } else if (type == "company") {
      criteria[index].ranges.value = List.from(AppConstant.companyRanges);
    } else if (type == "donor") {
      criteria[index].ranges.value = List.from(AppConstant.donorRanges);
    } else {
      criteria[index].ranges.value = List.from(AppConstant.employeeRanges);
    }
  }

  addCriteria() {
    criteria.add(Criteria(
        selectedUserType: "association",
        ranges: AppConstant.associationRanges,
        controller: TextEditingController(),
        selectedRange: "dateOfEstablishment",
        selectedLogicalOperation: "and",
        selectedOperation: "equalTo",
        dropDownValues: []));
  }

  deleteCriteria(int index) {
    criteria.removeAt(index);
  }

  Future<void> datePickerDialog(TextEditingController dateController) async {
    final DateTime now = DateTime.now();
    DateTime? selectedDateTime = await Utils.datePickerDialog(
      initialDate: now,
      lastDate: DateTime(now.year + 10),
      firstDate: DateTime(1950),
    );
    TimeOfDay? time = await Utils.timePickerDialog();
    if (time != null) {
      dateController.text = Utils.formatDateAndTime(selectedDateTime!, time);
    }
  }

  bool isDropDown(Criteria criteria) {
    String range = criteria.selectedRange.value!;
    String userType = criteria.selectedUserType.value!;
    var result = filterAttributes(userType);
    List<CriteriaAttributes> attributes = result.$1;

    String type =
        attributes.firstWhere((attribute) => attribute.key == range).type;
    if (type == "date") return false;
    if (userType == "donor" &&
        ["gender", "hasPhoto", "isVIP"].contains(range)) {
      criteria.dropDownValues.value = List.from(
          range == "gender" ? genders : AppConstant.popUpCloseButtons);
    } else if (["isEmailVerified", "isSMSVerified", "isActive"]
        .contains(range)) {
      criteria.dropDownValues.value = List.from(AppConstant.popUpCloseButtons);
    }

    return true;
  }

  (List<CriteriaAttributes>, List<String>) filterAttributes(String userType) {
    List<CriteriaAttributes> attributes = [];
    List<String> ranges = [];
    switch (userType) {
      case "association":
        attributes = associationAttributes;
        ranges = AppConstant.associationRanges;
        break;
      case "company":
        attributes = companyAttributes;
        ranges = AppConstant.companyRanges;
        break;
      case "donor":
        attributes = donorAttributes;
        ranges = AppConstant.donorRanges;
        break;
      case "employee":
      case "agent":
        attributes = employeeAttributes;
        ranges = AppConstant.employeeRanges;
        break;
      default:
    }
    return (attributes, ranges);
  }

  onChangeRange(Criteria operation) {
    operation.selectedDropDownValue.value = null;
    operation.dropDownValues.clear();
    operation.controller.clear();
    if (operation.selectedRange.value == "associationType") {
      fetchAssociationTypes(operation: operation);
    } else if (operation.selectedRange.value == "issuingAuthority") {
      fetchAuthorities(operation: operation);
    } else if (operation.selectedRange.value == "nationality") {
      fetchNationality(operation: operation);
    } else if (operation.selectedRange.value == "jobDescription" ||
        operation.selectedRange.value == "jobTitle") {
      fetchJobTitles(operation: operation);
    }
  }

  Future fetchAssociationTypes({Criteria? operation}) async {
    if (associationType.isNotEmpty) {
      operation?.dropDownValues.value = List.from(associationType);
      return;
    }
    if (operation != null) Utils.showLoadingDialog();
    final result = await getLookUpData(endPoint: ApiConstant.associationType);
    if (operation != null) {
      Utils.hideLoadingDialog();
      associationTypeList = result;
      for (var data in associationTypeList) {
        associationType
            .add(Utils.isArabic ? data.nameAr ?? data.name : data.name);
      }
      operation.dropDownValues.value = List.from(associationType);
    }
  }

  Future fetchAuthorities({Criteria? operation}) async {
    if (issuingAuthority.isNotEmpty) {
      operation?.dropDownValues.value = List.from(issuingAuthority);
      return;
    }
    if (operation != null) Utils.showLoadingDialog();
    final result =
        await getLookUpData(endPoint: ApiConstant.issuingAuthorities);
    if (operation != null) {
      Utils.hideLoadingDialog();
      issuingAuthorityList = result;
      for (var data in issuingAuthorityList) {
        issuingAuthority
            .add(Utils.isArabic ? data.nameAr ?? data.name : data.name);
      }
      operation.dropDownValues.value = List.from(issuingAuthority);
    }
  }

  Future fetchJobTitles({Criteria? operation}) async {
    if (jobs.isNotEmpty) {
      operation?.dropDownValues.value = List.from(jobs);
      return;
    }
    if (operation != null) Utils.showLoadingDialog();
    final result = await getLookUpData(endPoint: ApiConstant.jobTitle);
    if (operation != null) {
      Utils.hideLoadingDialog();
      jobsList = result;
      for (var data in jobsList) {
        jobs.add(Utils.isArabic ? data.nameAr ?? data.name : data.name);
      }
      operation.dropDownValues.value = List.from(jobs);
    }
  }

  fetchNationality({Criteria? operation}) {
    operation?.dropDownValues.value = List.from(nationalities);
  }

  saveGroup() async {
    if (formKey.currentState?.validate() ?? false) {
      Utils.showLoadingDialog();
      List operationsList = [];
      for (Criteria criteria in criteria) {
        String userType = criteria.selectedUserType.value!;
        String range = criteria.selectedRange.value!;
        var result = filterAttributes(userType);
        List<CriteriaAttributes> attributes = result.$1;
        CriteriaAttributes attribute =
            attributes.firstWhere((key) => key.key == range);
        bool isDate = attribute.type == "date";

        dynamic value = "";
        if (isDate) {
          DateTime dateTime =
              Utils.dateTimeFormat.parse(criteria.controller.text);
          DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm");
          value = outputFormat.format(dateTime);
        } else {
          String dropDownValue = criteria.selectedDropDownValue.value!;
          if (["hasPhoto", "isVIP"].contains(range)) {
            value = dropDownValue == "yes" ? "1" : "2";
          } else if (range == "gender") {
            value = dropDownValue == "male" ? "1" : "2";
          } else if (range == "associationType") {
            value = associationTypeList.firstWhere((filed) {
              String field =
                  Utils.isArabic ? filed.nameAr ?? filed.name : filed.name;
              return field == dropDownValue;
            }).value;
          } else if (range == "issuingAuthority") {
            value = issuingAuthorityList.firstWhere((filed) {
              String field =
                  Utils.isArabic ? filed.nameAr ?? filed.name : filed.name;
              return field == dropDownValue;
            }).value;
          } else if (range == "nationality") {
            value = nationalitiesList.firstWhere((filed) {
              String field =
                  Utils.isArabic ? filed.nameAr ?? filed.name : filed.name;
              return field == dropDownValue;
            }).value;
          } else if (range == "jobDescription" || range == "jobTitle") {
            value = jobsList.firstWhere((filed) {
              String field =
                  Utils.isArabic ? filed.nameAr ?? filed.name : filed.name;
              return field == dropDownValue;
            }).value;
          }
        }
        operationsList.add({
          "logicalOperator":
              criteria.selectedLogicalOperation.value == "and" ? 1 : 2,
          "userType": Utils.groupsTypesIntoInt(userType).toString(),
          "columnName": attribute.value,
          "operator": Utils.operatorIntoInt(criteria.selectedOperation.value!),
          "value": value,
          "type": attribute.type,
          "ddlList": []
        });
      }

      var body = {
        if (recipients != null) "id": recipients?.id,
        "groupName": groupName.text,
        "groupType": selectedGroupType.value == "fixed" ? 1 : 2,
        "operation": operationsList
      };
      ApiResponse apiResponse = recipients != null
          ? await repo.updateGroup(
              request: RequestBody(
                  body: body,
                  endPoint: "${ApiConstant.updateGroup}/${recipients!.id}"))
          : await repo.addGroup(request: RequestBody(body: body));
      Utils.hideLoadingDialog();
      if (apiResponse.appState == AppState.onSuccess) {
        Utils.showGlobalSnackBar(message: apiResponse.data);
        if (recipients != null) {
          recipientsViewModel.pageSize = recipientsViewModel.recipients.length;
        } else {
          recipientsViewModel.pageSize = 10;
        }
        Get.back(result: true);
      } else {
        Utils.handleAPIError(apiResponse);
      }
    }
  }

  onChangeGroupType(String value) => selectedGroupType.value = value;

  onChangeUserType(String value, Criteria criteria, index) {
    if (value != criteria.selectedUserType.value) {
      updateRanges(value, index);
    }
  }

  onChangeGroupRange(String value, Criteria criteria) {
    if (value != criteria.selectedRange.value) {
      criteria.selectedRange.value = value;
      onChangeRange(criteria);
    }
  }

  String getTitle() => recipients != null ? "editGroup" : "addNewGroup";

  @override
  void onClose() {
    groupName.dispose();

    for (final c in criteria) {
      c.controller.dispose();
      c.selectedRange.close();
      c.dropDownValues.close();
      c.ranges.close();
      c.selectedDropDownValue.close();
      c.selectedLogicalOperation.close();
      c.selectedUserType.close();
      c.selectedOperation.close();
    }

    criteria.close();

    super.onClose();
  }
}
