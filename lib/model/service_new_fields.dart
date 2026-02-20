import 'package:flutter/cupertino.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class ServiceNewFields {
  late TextEditingController controller1;
  TextEditingController controller2;
  TextEditingController controller3;
  TextEditingController controller4;
  final HtmlEditorController htmlController1 = HtmlEditorController();
  final HtmlEditorController htmlController2 = HtmlEditorController();
  String initialValue1 = "", initialValue2 = "";

  ServiceNewFields(
      {TextEditingController? controller1,
      TextEditingController? controller2,
      TextEditingController? controller3,
      TextEditingController? controller4})
      : controller1 = controller1 ?? TextEditingController(),
        controller2 = controller2 ?? TextEditingController(),
        controller3 = controller3 ?? TextEditingController(),
        controller4 = controller4 ?? TextEditingController();
}
