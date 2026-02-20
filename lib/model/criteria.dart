import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Criteria {
  Rxn<String> selectedRange = Rxn<String>();
  Rxn<String> selectedDropDownValue = Rxn<String>();
  Rxn<String> selectedUserType = Rxn<String>();
  Rxn<String> selectedOperation = Rxn<String>();
  Rxn<String> selectedLogicalOperation = Rxn<String>();
  RxList<String> ranges = <String>[].obs;
  RxList<String> dropDownValues = <String>[].obs;
  TextEditingController controller = TextEditingController();

  Criteria({
    String? selectedRange,
    String? selectedUserType,
    String? selectedOperation,
    String? selectedDropDownValue,
    String? selectedLogicalOperation,
    required TextEditingController controller,
    required List<String> ranges,
    required List<String> dropDownValues,
  }) {
    this.controller = TextEditingController();
    this.selectedRange.value = selectedRange;
    this.selectedUserType.value = selectedUserType;
    this.selectedDropDownValue.value = selectedDropDownValue;
    this.selectedOperation.value = selectedOperation;
    this.selectedLogicalOperation.value = selectedLogicalOperation;
    this.ranges.value = ranges;
    this.dropDownValues.value = dropDownValues;
  }
}

class CriteriaAttributes {
  String key, value, type;

  CriteriaAttributes({
    required this.key,
    required this.value,
    required this.type,
  });
}
