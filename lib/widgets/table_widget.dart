import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/audit_logs.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';

class TableWidget extends StatelessWidget {
  final List<AuditLogDetail> auditDetails;

  const TableWidget({super.key, required this.auditDetails});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      children: [
        _buildTableHeaderRow(),
        ...auditDetails.map(_buildDataRow),
      ],
    );
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        _buildHeaderCell("field"),
        _buildHeaderCell("oldValue"),
        _buildHeaderCell("updatedValue"),
      ],
    );
  }

  Widget _buildHeaderCell(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, top: 5.h, bottom: 5.h),
      child: Text(
        label.tr,
        style: AppTextStyle.darkGrey13TextStyle,
      ),
    );
  }

  TableRow _buildDataRow(AuditLogDetail detail) {
    return TableRow(
      children: [
        _buildDataCell(detail.fieldName.tr,
            padding: EdgeInsets.only(left: 10.w, right: 4.w)),
        _buildDataCell(Utils.htmlToPlainText(detail.oldValue)),
        _buildDataCell(Utils.htmlToPlainText(detail.newValue),
            padding: EdgeInsets.only(right: 10.w, left: 4.w)),
      ],
    );
  }

  Widget _buildDataCell(String text, {EdgeInsets? padding}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
      child: Text(
        text,
        style: AppTextStyle.secondaryPrimaryBlack13TextStyle,
      ),
    );
  }
}
