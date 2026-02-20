import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

class HtmlEditorWidget extends StatelessWidget {
  final HtmlEditorController controller;
  final String? initialText;
  final bool lessHeight;
  final bool disable;
  final void Function(String?)? onChangeContent;
  const HtmlEditorWidget(
      {super.key, required this.controller, this.initialText,  this.lessHeight=false, this.onChangeContent, this.disable=false});

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      controller: controller,
      callbacks: Callbacks(onChangeContent: onChangeContent),
      htmlEditorOptions: HtmlEditorOptions(
        hint: "Enter text here...",
        initialText: initialText,
        shouldEnsureVisible: true,
        disabled: disable
        // adjustHeightForKeyboard: true,
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        toolbarItemHeight: disable?0:36,
        defaultToolbarButtons: disable?[]:[
          StyleButtons(),
          FontSettingButtons(fontSize: false, fontSizeUnit: false),
          FontButtons(
              clearAll: false,
              strikethrough: false,
              superscript: false,
              subscript: false),
          ColorButtons(),
          ListButtons(listStyles: false),
          ParagraphButtons(
            increaseIndent: false,
            decreaseIndent: false,
            textDirection: false,
            lineHeight: false,
            caseConverter: false,
          ),
          InsertButtons(
            audio: false,
            video: false,
            otherFile: false,
            table: false,
            hr: false,
          ),
        ],
      ),
      otherOptions: OtherOptions(
          height: lessHeight?150.h:300.h,
          decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                  width: 1.w, color: AppColors.secondaryLightGreyColor))),
    );
  }
}
