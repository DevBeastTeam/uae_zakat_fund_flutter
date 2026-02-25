import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/audit_logs.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/audit_log_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';

class AuditDetailsViewModel extends ModulePermissionsViewModel {
  final repo = AuditLogRepoImpl();

  Rxn<AuditLogs> auditLogs = Rxn<AuditLogs>();

  final requestViewModel = Get.find<RequestsViewModel>();
  final accountViewModel = Get.find<AccountViewModel>();

  int status = 0;

  @override
  void onInit() {
    Future.microtask(()=> fetchAuditLogs());
    super.onInit();
  }


  fetchAuditLogs() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.fetchAuditLogById(
        request: RequestBody(
            endPoint: "${ApiConstant.auditLogById}/${request?.auditLogId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      auditLogs.value = apiResponse.data;
      isAdmin.value = (request?.status == 1 && user.isAdmin);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  openPreviewScreen() {
    request?.status = 2;

    var arguments = {
      "request": request,
      "isAdmin": false,
    };
    switch (request?.requestType) {
      case "Banner Update" || "Popup Update":
        arguments.addAll({"title": request?.requestType});
        previewScreen(AppRoutes.adScreen, arguments: arguments);
        break;

      case "Feedback" || "Feedback Response":
        arguments.addAll({"fromTasks": requestViewModel.isTasks});
        previewScreen(AppRoutes.feedbackPreviewScreen, arguments: arguments);
        break;

      case "Association Update":
        arguments.addAll({"isAssociation": true});
        previewScreen(AppRoutes.associationPreviewScreen, arguments: arguments);
        break;

      case "Company Update":
        arguments.addAll({"isAssociation": false});
        previewScreen(AppRoutes.associationPreviewScreen, arguments: arguments);
        break;

      case "Static Page Update":
        previewScreen(AppRoutes.staticPageScreen, arguments: arguments);
        break;

      case "Project Update":
        previewScreen(AppRoutes.projectPreviewScreen, arguments: arguments);
        break;

      case "About Us Update":
        previewScreen(AppRoutes.aboutUsScreen, arguments: arguments);
        break;

      case "News Update":
        previewScreen(AppRoutes.newsPreviewScreen, arguments: arguments);
        break;

      case "Service Update":
        previewScreen(AppRoutes.servicePreviewScreen, arguments: arguments);
        break;
      case "Campaign Update":
        previewScreen(AppRoutes.campaignScreen, arguments: arguments);
        break;
      case "Survey Update":
        previewScreen(AppRoutes.surveyScreen, arguments: arguments);
        break;
      case "Refund":
        previewScreen(AppRoutes.refundPreviewScreen, arguments: arguments);
        break;
      case "FAQ Update":
        previewScreen(AppRoutes.faqPreviewScreen, arguments: arguments);
        break;
      case "Fund Transfer":
        previewScreen(AppRoutes.fundsRequestPreviewScreen,
            arguments: arguments);
        break;
      case "Bank Cheque" || "Deposit" || "Cash":
        if (requestViewModel.isTasks) {
          previewScreen(AppRoutes.collectionScreen, arguments: arguments);
        } else {
          previewScreen(AppRoutes.transactionRequestScreen,
              arguments: arguments);
        }
        break;
      case "Notifications Update":
        previewScreen(AppRoutes.notificationsPreviewScreen,
            arguments: arguments);
        break;

      default:
        print("Unknown request type: ${request?.requestType}");
        break;
    }
  }

  previewScreen(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments)!.then((_) {
      request?.status = status;
    });
  }

  @override
  void onClose() {
    auditLogs.close();

    super.onClose();
  }

}
