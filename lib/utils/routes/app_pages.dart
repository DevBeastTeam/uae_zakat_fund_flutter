import 'package:get/get.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view/about_sahem/about_sahem_binding.dart';
import 'package:zakat_fund/view/about_sahem/about_sahem_screen.dart';
import 'package:zakat_fund/view/accessibility/accessibility_binding.dart';
import 'package:zakat_fund/view/accessibility/accessibility_screen.dart';
import 'package:zakat_fund/view/activity_log/activity_log_binding.dart';
import 'package:zakat_fund/view/activity_log/activity_log_screen.dart';
import 'package:zakat_fund/view/admin/admin_dashboard/admin_dashboard_binding.dart';
import 'package:zakat_fund/view/admin/admin_dashboard/admin_dashboard_screen.dart';
import 'package:zakat_fund/view/admin/admin_operations/admin_operations_binding.dart';
import 'package:zakat_fund/view/admin/admin_operations/admin_operations_screen.dart';
import 'package:zakat_fund/view/admin/ads_management/add_ads/ad_ads_binding.dart';
import 'package:zakat_fund/view/admin/ads_management/add_ads/add_ads_screen.dart';
import 'package:zakat_fund/view/admin/ads_management/ads_management_binding.dart';
import 'package:zakat_fund/view/admin/ads_management/ads_management_screen.dart';
import 'package:zakat_fund/view/admin/audit_log/audit_log_binding.dart';
import 'package:zakat_fund/view/admin/audit_log/audit_log_screen.dart';
import 'package:zakat_fund/view/admin/campaigns_projects/campaigns_projects_binding.dart';
import 'package:zakat_fund/view/admin/campaigns_projects/campaigns_projects_screen.dart';
import 'package:zakat_fund/view/admin/cms_news/add_news/add_news_binding.dart';
import 'package:zakat_fund/view/admin/cms_news/add_news/add_news_screen.dart';
import 'package:zakat_fund/view/admin/cms_news/cms_news_binding.dart';
import 'package:zakat_fund/view/admin/cms_news/cms_news_screen.dart';
import 'package:zakat_fund/view/admin/cms_services/add_service/add_service_screen.dart';
import 'package:zakat_fund/view/admin/cms_services/add_service/add_services_binding.dart';
import 'package:zakat_fund/view/admin/cms_services/cms_services_binding.dart';
import 'package:zakat_fund/view/admin/cms_services/cms_services_screen.dart';
import 'package:zakat_fund/view/admin/document_managemnt/platform_documents/add_platform_doc.dart';
import 'package:zakat_fund/view/admin/document_managemnt/platform_documents/platform_documents_binding.dart';
import 'package:zakat_fund/view/admin/document_managemnt/platform_documents/platform_documents_screen.dart';
import 'package:zakat_fund/view/admin/document_managemnt/public_documents/public_documents_binding.dart';
import 'package:zakat_fund/view/admin/document_managemnt/public_documents/public_documents_screen.dart';
import 'package:zakat_fund/view/admin/document_managemnt/user_documents/user_documents_binding.dart';
import 'package:zakat_fund/view/admin/document_managemnt/user_documents/user_documents_screen.dart';
import 'package:zakat_fund/view/admin/donations/donation_binding.dart';
import 'package:zakat_fund/view/admin/donations/donation_screen.dart';
import 'package:zakat_fund/view/admin/donor/donor_binding.dart';
import 'package:zakat_fund/view/admin/donor/donor_screen.dart';
import 'package:zakat_fund/view/admin/faqs/add_faq_screen.dart';
import 'package:zakat_fund/view/admin/faqs/faqs_binding.dart';
import 'package:zakat_fund/view/admin/faqs/faqs_screen.dart';
import 'package:zakat_fund/view/admin/financial/financial_binding.dart';
import 'package:zakat_fund/view/admin/financial/financial_screen.dart';
import 'package:zakat_fund/view/admin/notification_management/add_notification/add_notification_binding.dart';
import 'package:zakat_fund/view/admin/notification_management/add_notification/add_notification_screen.dart';
import 'package:zakat_fund/view/admin/notification_management/notification_management_binding.dart';
import 'package:zakat_fund/view/admin/notification_management/notification_managemnt_screen.dart';
import 'package:zakat_fund/view/admin/recipients_campaign/add_group/add_group_binding.dart';
import 'package:zakat_fund/view/admin/recipients_campaign/add_group/add_group_screen.dart';
import 'package:zakat_fund/view/admin/recipients_campaign/group_details/group_details_binding.dart';
import 'package:zakat_fund/view/admin/recipients_campaign/group_details/recipients__details_screen.dart';
import 'package:zakat_fund/view/admin/recipients_campaign/recipients_campaign_binding.dart';
import 'package:zakat_fund/view/admin/recipients_campaign/recipients_campaign_screen.dart';
import 'package:zakat_fund/view/admin/sla_dashboard/sla_dashboard_binding.dart';
import 'package:zakat_fund/view/admin/sla_dashboard/sla_dashboard_screen.dart';
import 'package:zakat_fund/view/admin/smtp_config/smtp_config_binding.dart';
import 'package:zakat_fund/view/admin/smtp_config/smtp_config_screen.dart';
import 'package:zakat_fund/view/admin/transfer_queue/transfer_queue_binding.dart';
import 'package:zakat_fund/view/admin/transfer_queue/transfer_queue_screen.dart';
import 'package:zakat_fund/view/admin/user_engagemnt/user_engagement_binding.dart';
import 'package:zakat_fund/view/admin/user_engagemnt/user_engagement_screen.dart';
import 'package:zakat_fund/view/admin/workflow_management/approver_group/add_approver_group/add_approver_group_binding.dart';
import 'package:zakat_fund/view/admin/workflow_management/approver_group/add_approver_group/add_approver_group_screen.dart';
import 'package:zakat_fund/view/admin/workflow_management/approver_group/approver_group_binding.dart';
import 'package:zakat_fund/view/admin/workflow_management/approver_group/approver_group_screen.dart';
import 'package:zakat_fund/view/admin/workflow_management/workflow_config/add_workflow/add_workflow_binding.dart';
import 'package:zakat_fund/view/admin/workflow_management/workflow_config/add_workflow/add_workflow_screen.dart';
import 'package:zakat_fund/view/admin/workflow_management/workflow_config/workflow_config_binding.dart';
import 'package:zakat_fund/view/admin/workflow_management/workflow_config/workflow_config_screen.dart';
import 'package:zakat_fund/view/agent/add_cash/add_cash_binding.dart';
import 'package:zakat_fund/view/agent/add_cash/add_cash_screen.dart';
import 'package:zakat_fund/view/agent/auth_task/auth_task_binding.dart';
import 'package:zakat_fund/view/agent/auth_task/auth_task_screen.dart';
import 'package:zakat_fund/view/agent/collection/collection_binding.dart';
import 'package:zakat_fund/view/agent/collection/collection_screen.dart';
import 'package:zakat_fund/view/association/about_association/about_association_binding.dart';
import 'package:zakat_fund/view/association/about_association/about_association_screen.dart';
import 'package:zakat_fund/view/association/association_binding.dart';
import 'package:zakat_fund/view/association/association_dashboard/association_dashboard_binding.dart';
import 'package:zakat_fund/view/association/association_dashboard/association_dashboard_screen.dart';
import 'package:zakat_fund/view/association/association_screen.dart';
import 'package:zakat_fund/view/association/finaancial_statement/financial_statement_binding.dart';
import 'package:zakat_fund/view/association/finaancial_statement/financial_statement_screen.dart';
import 'package:zakat_fund/view/association/funds_requests/funds_requests_binding.dart';
import 'package:zakat_fund/view/association/funds_requests/funds_requests_screen.dart';
import 'package:zakat_fund/view/association/management_staff/management_staff_binding.dart';
import 'package:zakat_fund/view/association/management_staff/management_staff_screen.dart';
import 'package:zakat_fund/view/association/project_management/create_project_screen.dart';
import 'package:zakat_fund/view/association/project_management/project_binding.dart';
import 'package:zakat_fund/view/association/project_management/project_detail_binding.dart';
import 'package:zakat_fund/view/association/project_management/project_details_screen.dart';
import 'package:zakat_fund/view/association/project_management/project_management.dart';
import 'package:zakat_fund/view/association/project_management/project_mgt_binding.dart';
import 'package:zakat_fund/view/auth/forgot_password/forgot_password_binding.dart';
import 'package:zakat_fund/view/auth/forgot_password/forgot_password_screen.dart';
import 'package:zakat_fund/view/auth/login/legacy_login_screen.dart';
import 'package:zakat_fund/view/auth/login/log_in_binding.dart';
import 'package:zakat_fund/view/auth/login/login_screen.dart';
import 'package:zakat_fund/view/auth/otp_verification/otp_verification_screen.dart';
import 'package:zakat_fund/view/auth/register/register_binding.dart';
import 'package:zakat_fund/view/auth/register/register_screen.dart';
import 'package:zakat_fund/view/auth/register/register_success_screen.dart';
import 'package:zakat_fund/view/auth/uae_link/role_link_screen.dart';
import 'package:zakat_fund/view/auth/uae_link/uae_link_screen.dart';
import 'package:zakat_fund/view/auth/uae_link/uae_log_in_binding.dart';
import 'package:zakat_fund/view/auth/uae_link/uae_login_screen.dart';
import 'package:zakat_fund/view/auth/uae_link/uae_role_binding.dart';
import 'package:zakat_fund/view/auth/user_selection/user_selection_binding.dart';
import 'package:zakat_fund/view/auth/user_selection/user_selection_screen.dart';
import 'package:zakat_fund/view/bottom_bar/account/account_screen.dart';
import 'package:zakat_fund/view/bottom_bar/account/admin_account_screen.dart';
import 'package:zakat_fund/view/bottom_bar/cart/cart_binding.dart';
import 'package:zakat_fund/view/bottom_bar/cart/cart_screen.dart';
import 'package:zakat_fund/view/bottom_bar/donated_project_screen.dart';
import 'package:zakat_fund/view/bottom_bar/home/all_associations_screen.dart';
import 'package:zakat_fund/view/bottom_bar/home/all_news_screen.dart';
import 'package:zakat_fund/view/bottom_bar/home/all_projects_binding.dart';
import 'package:zakat_fund/view/bottom_bar/home/all_projects_screen.dart';
import 'package:zakat_fund/view/bottom_bar/home/association_detail_binding.dart';
import 'package:zakat_fund/view/bottom_bar/home/association_details_screen.dart';
import 'package:zakat_fund/view/bottom_bar/last_donated_binding.dart';
import 'package:zakat_fund/view/bottom_bar/receipt/payment_receipt_binding.dart';
import 'package:zakat_fund/view/bottom_bar/receipt/payment_receipt_screen.dart';
import 'package:zakat_fund/view/bottom_bar/statics/statics_binding.dart';
import 'package:zakat_fund/view/bottom_bar/statics/statics_screen.dart';
import 'package:zakat_fund/view/companies/all_companies_binding.dart';
import 'package:zakat_fund/view/companies/all_company_screen.dart';
import 'package:zakat_fund/view/company/company_binding.dart';
import 'package:zakat_fund/view/company/company_screen.dart';
import 'package:zakat_fund/view/contact_us/contact_us_binding.dart';
import 'package:zakat_fund/view/contact_us/contact_us_screen.dart';
import 'package:zakat_fund/view/donor/all_donors_binding.dart';
import 'package:zakat_fund/view/donor/all_donors_screen.dart';
import 'package:zakat_fund/view/donor/donor_dashboard/donor_dashboard_binding.dart';
import 'package:zakat_fund/view/donor/donor_dashboard/donor_dashboard_screen.dart';
import 'package:zakat_fund/view/donor/individual/individual_binding.dart';
import 'package:zakat_fund/view/donor/individual/individual_screen.dart';
import 'package:zakat_fund/view/faq/faq_binding.dart';
import 'package:zakat_fund/view/faq/faq_screen.dart';
import 'package:zakat_fund/view/pdf_preview/pdf_preview_screen.dart';
import 'package:zakat_fund/view/favourite/favourite_binding.dart';
import 'package:zakat_fund/view/favourite/favourite_screen.dart';
import 'package:zakat_fund/view/feedback/add_feedback/add_feedback_binding.dart';
import 'package:zakat_fund/view/feedback/add_feedback/add_feedback_screen.dart';
import 'package:zakat_fund/view/feedback/feedback_binding.dart';
import 'package:zakat_fund/view/feedback/feedback_screen.dart';
import 'package:zakat_fund/view/global_search/global_search_binding.dart';
import 'package:zakat_fund/view/global_search/global_search_screen.dart';
import 'package:zakat_fund/view/global_search/search_result/search_result_binding.dart';
import 'package:zakat_fund/view/global_search/search_result/search_result_screen.dart';
import 'package:zakat_fund/view/main/main_binding.dart';
import 'package:zakat_fund/view/main/main_screen.dart';
import 'package:zakat_fund/view/media_center/media_center_screen.dart';
import 'package:zakat_fund/view/media_center/news_binding.dart';
import 'package:zakat_fund/view/media_center/news_detail_binding.dart';
import 'package:zakat_fund/view/media_center/news_detail_screen.dart';
import 'package:zakat_fund/view/my_refunds/my_refunds_binding.dart';
import 'package:zakat_fund/view/my_refunds/my_refunds_screen.dart';
import 'package:zakat_fund/view/my_wallet/my_wallet_binding.dart';
import 'package:zakat_fund/view/my_wallet/my_wallet_screen.dart';
import 'package:zakat_fund/view/notifications/notification_binding.dart';
import 'package:zakat_fund/view/notifications/notification_screen.dart';
import 'package:zakat_fund/view/onboarding/onboarding_binding.dart';
import 'package:zakat_fund/view/onboarding/onboarding_screen.dart';
import 'package:zakat_fund/view/our_services/our_service_screen.dart';
import 'package:zakat_fund/view/our_services/service_detail_binding.dart';
import 'package:zakat_fund/view/our_services/service_details.dart';
import 'package:zakat_fund/view/our_services/services_binding.dart';
import 'package:zakat_fund/view/photo_view/photo_view_binding.dart';
import 'package:zakat_fund/view/photo_view/photo_view_screen.dart';
import 'package:zakat_fund/view/qr_scanner/qr_scanner_screen.dart';
import 'package:zakat_fund/view/requests/about_us/about_us_binding.dart';
import 'package:zakat_fund/view/requests/about_us/about_us_screen.dart';
import 'package:zakat_fund/view/requests/ads/ad_binding.dart';
import 'package:zakat_fund/view/requests/ads/ad_screen.dart';
import 'package:zakat_fund/view/requests/association/association_preview_binding.dart';
import 'package:zakat_fund/view/requests/association/association_preview_screen.dart';
import 'package:zakat_fund/view/requests/audit_details/audit_details_binding.dart';
import 'package:zakat_fund/view/requests/audit_details/audit_details_screen.dart';
import 'package:zakat_fund/view/requests/campaigns/campaign_binding.dart';
import 'package:zakat_fund/view/requests/campaigns/campaign_screen.dart';
import 'package:zakat_fund/view/requests/donor/donor_preview_binding.dart';
import 'package:zakat_fund/view/requests/donor/donor_preview_screen.dart';
import 'package:zakat_fund/view/requests/faq/faq_preview_binding.dart';
import 'package:zakat_fund/view/requests/faq/faq_preview_screen.dart';
import 'package:zakat_fund/view/requests/feedback/feedback_preview_binding.dart';
import 'package:zakat_fund/view/requests/feedback/feedback_preview_screen.dart';
import 'package:zakat_fund/view/requests/fund_request/funds_request_preview_binding.dart';
import 'package:zakat_fund/view/requests/fund_request/funds_request_preview_screen.dart';
import 'package:zakat_fund/view/requests/news/news_preview_binding.dart';
import 'package:zakat_fund/view/requests/news/news_preview_screen.dart';
import 'package:zakat_fund/view/requests/notifications/notifications_preview_binding.dart';
import 'package:zakat_fund/view/requests/notifications/notifications_preview_screen.dart';
import 'package:zakat_fund/view/requests/project/project_preview_binding.dart';
import 'package:zakat_fund/view/requests/project/project_preview_screen.dart';
import 'package:zakat_fund/view/requests/refund/refund_preview_binding.dart';
import 'package:zakat_fund/view/requests/refund/refund_preview_screen.dart';
import 'package:zakat_fund/view/requests/rejection/request_reject_binding.dart';
import 'package:zakat_fund/view/requests/rejection/request_reject_screen.dart';
import 'package:zakat_fund/view/requests/requests_binding.dart';
import 'package:zakat_fund/view/requests/requests_screen.dart';
import 'package:zakat_fund/view/requests/services/service_preview_binding.dart';
import 'package:zakat_fund/view/requests/services/service_preview_screen.dart';
import 'package:zakat_fund/view/requests/static_pages/static_page_binding.dart';
import 'package:zakat_fund/view/requests/static_pages/static_page_screen.dart';
import 'package:zakat_fund/view/admin/static_pages/static_pages_binding.dart';
import 'package:zakat_fund/view/admin/static_pages/static_pages_screen.dart';
import 'package:zakat_fund/view/requests/survey/survey_binding.dart';
import 'package:zakat_fund/view/requests/survey/survey_screen.dart';
import 'package:zakat_fund/view/requests/transaction/transaction_request_binding.dart';
import 'package:zakat_fund/view/requests/transaction/transaction_request_screen.dart';
import 'package:zakat_fund/view/settings/account_deletion/account_deletion_binding.dart';
import 'package:zakat_fund/view/settings/account_deletion/account_deletion_screen.dart';
import 'package:zakat_fund/view/settings/change_password/chnage_password.dart';
import 'package:zakat_fund/view/settings/change_password/chnage_password_binding.dart';
import 'package:zakat_fund/view/settings/donation_reminder/add_donation_reminder/add_donation_binding.dart';
import 'package:zakat_fund/view/settings/donation_reminder/add_donation_reminder/add_donation_reminder.dart';
import 'package:zakat_fund/view/settings/donation_reminder/donation_reminder_binding.dart';
import 'package:zakat_fund/view/settings/donation_reminder/donation_reminder_screen.dart';
import 'package:zakat_fund/view/settings/language/languagae_binding.dart';
import 'package:zakat_fund/view/settings/language/language_screen.dart';
import 'package:zakat_fund/view/settings/notification_preferences/notif_pref_binding.dart';
import 'package:zakat_fund/view/settings/notification_preferences/notif_preference_screen.dart';
import 'package:zakat_fund/view/settings/password_security/password_security_binding.dart';
import 'package:zakat_fund/view/settings/password_security/password_security_screen.dart';
import 'package:zakat_fund/view/settings/project_alerts/project_alerts_binding.dart';
import 'package:zakat_fund/view/settings/project_alerts/project_alerts_screen.dart';
import 'package:zakat_fund/view/settings/settings_binding.dart';
import 'package:zakat_fund/view/settings/settings_screen.dart';
import 'package:zakat_fund/view/splash/splash_page.dart';
import 'package:zakat_fund/view/splash/splash_screen.dart';
import 'package:zakat_fund/view/transactions/transaction_binding.dart';
import 'package:zakat_fund/view/transactions/transaction_screen.dart';
import 'package:zakat_fund/view/web_view/web_view_binding.dart';
import 'package:zakat_fund/view/web_view/web_view_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashPage(),
    ),
    GetPage(
        name: AppRoutes.mainScreen,
        page: () => MainScreen(),
        bindings: [MainBinding(), CartBinding()]),
    // GetPage(
    //   name: AppRoutes.logInScreen,
    //   page: () => const LogInScreen(),
    //   binding: LogInBinding(),
    // ),
    GetPage(
        name: AppRoutes.userSelectionScreen,
        page: () => const UserSelectionScreen(),
        binding: UserSelectionBinding()),
    GetPage(
        name: AppRoutes.registerScreen,
        page: () => const RegisterScreen(),
        binding: RegisterBinding()),
    GetPage(
        name: AppRoutes.otpVerificationScreen,
        page: () => OtpVerificationScreen()),
    GetPage(
      name: AppRoutes.registerSuccessScreen,
      page: () => const RegisterSuccessScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.individualScreen,
      page: () => const IndividualScreen(),
      binding: IndividualBinding(),
    ),
    GetPage(
      name: AppRoutes.companyScreen,
      page: () => const CompanyScreen(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: AppRoutes.associationScreen,
      page: () => const AssociationScreen(),
      binding: AssociationBinding(),
    ),
    GetPage(
      name: AppRoutes.createProjectScreen,
      page: () => const CreateProjectScreen(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: AppRoutes.projectDetailsScreen,
      page: () => const ProjectDetailsScreen(),
      binding: ProjectDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.allProjectsScreen,
      page: () => const AllProjectsScreen(),
      binding: AllProjectsBinding(),
    ),
    GetPage(
      name: AppRoutes.allAssociationsScreen,
      page: () => const AllAssociationsScreen(),
    ),
    GetPage(
        name: AppRoutes.associationDetailsScreen,
        page: () => const AssociationDetailsScreen(),
        bindings: [AssociationDetailBinding(), ContactUsBinding()]),
    GetPage(
      name: AppRoutes.uaeLinkScreen,
      page: () => const UaeLinkScreen(),
    ),
    GetPage(
      name: AppRoutes.roleLinkScreen,
      binding: UaeRoleBinding(),
      page: () => const RoleLinkScreen(),
    ),
    GetPage(
      name: AppRoutes.uaeLoginScreen,
      binding: UaeLogInBinding(),
      page: () => const UaeLoginScreen(),
    ),
    GetPage(
      name: AppRoutes.faqScreen,
      page: () => const FaqScreen(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: AppRoutes.mediaCenterScreen,
      page: () => const MediaCenterScreen(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: AppRoutes.newsDetailScreen,
      page: () => NewsDetailScreen(),
      binding: NewsDetailBinding(),
    ),
    GetPage(
        name: AppRoutes.ourServiceScreen,
        page: () => const OurServiceScreen(),
        binding: ServicesBinding()),
    GetPage(
        name: AppRoutes.serviceDetails,
        page: () => const ServiceDetailsScreen(),
        binding: ServiceDetailBinding()),
    GetPage(
        name: AppRoutes.contactUsScreen,
        page: () => const ContactUsScreen(),
        binding: ContactUsBinding()),
    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.projectManagementScreen,
      page: () => const ProjectManagementScreen(),
      binding: ProjectMgtBinding(),
    ),
    GetPage(
      name: AppRoutes.webViewScreen,
      page: () => const WebViewScreen(),
      binding: WebViewBinding(),
    ),
    GetPage(
      name: AppRoutes.managementStaffScreen,
      page: () => const ManagementStaffScreen(),
      binding: ManagementStaffBinding(),
    ),
    GetPage(
      name: AppRoutes.settingsScreen,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
        name: AppRoutes.notificationPreferenceScreen,
        page: () => const NotificationPreferenceScreen(),
        binding: NotificationPreferenceBinding()),
    GetPage(
        name: AppRoutes.languageScreen,
        page: () => const LanguageScreen(),
        binding: LanguageBinding()),
    GetPage(
        name: AppRoutes.passwordSecurityScreen,
        page: () => const PasswordSecurityScreen(),
        binding: PasswordSecurityBinding()),
    GetPage(
        name: AppRoutes.changePasswordScreen,
        page: () => const ChangePasswordScreen(),
        binding: ChangePasswordBinding()),
    GetPage(
        name: AppRoutes.favouriteScreen,
        page: () => const FavouriteScreen(),
        binding: FavouriteBinding()),
    GetPage(
      name: AppRoutes.allNewsScreen,
      page: () => const AllNewsScreen(),
    ),
    GetPage(
      name: AppRoutes.accessibilityScreen,
      page: () => const AccessibilityScreen(),
      binding: AccessibilityBinding(),
    ),
    GetPage(
      name: AppRoutes.addFeedbackScreen,
      page: () => const AddFeedbackScreen(),
      binding: AddFeedbackBinding(),
    ),
    GetPage(
      name: AppRoutes.requestsScreen,
      page: () => const RequestsScreen(),
      binding: RequestsBinding(),
    ),
    GetPage(
      name: AppRoutes.associationPreviewScreen,
      page: () => const AssociationPreviewScreen(),
      binding: AssociationPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.requestRejectScreen,
      page: () => const RequestRejectScreen(),
      binding: RequestRejectBinding(),
    ),
    GetPage(
      name: AppRoutes.feedbackPreviewScreen,
      page: () => const FeedbackPreviewScreen(),
      binding: FeedbackPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.projectPreviewScreen,
      page: () => const ProjectPreviewScreen(),
      binding: ProjectPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.adScreen,
      page: () => const AdScreen(),
      binding: AdBinding(),
    ),
    GetPage(
      name: AppRoutes.campaignScreen,
      page: () => const CampaignScreen(),
      binding: CampaignBinding(),
    ),
    GetPage(
      name: AppRoutes.feedbackScreen,
      page: () => const FeedbackScreen(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: AppRoutes.staticPageScreen,
      page: () => const StaticPageScreen(),
      binding: StaticPageBinding(),
    ),
    GetPage(
      name: AppRoutes.staticPagesScreen,
      page: () => const StaticPagesScreen(),
      binding: StaticPagesBinding(),
    ),
    GetPage(
      name: AppRoutes.aboutUsScreen,
      page: () => const AboutUsScreen(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: AppRoutes.newsPreviewScreen,
      page: () => const NewsPreviewScreen(),
      binding: NewsPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.servicePreviewScreen,
      page: () => const ServicePreviewScreen(),
      binding: ServicePreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.paymentReceiptScreen,
      page: () => const PaymentReceiptScreen(),
      binding: PaymentReceiptBinding(),
    ),
    GetPage(
      name: AppRoutes.transactionScreen,
      page: () => const TransactionScreen(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: AppRoutes.transactionRequestScreen,
      page: () => const TransactionRequestScreen(),
      binding: TransactionRequestBinding(),
    ),
    GetPage(
      name: AppRoutes.surveyScreen,
      page: () => const SurveyScreen(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: AppRoutes.refundPreviewScreen,
      page: () => const RefundPreviewScreen(),
      binding: RefundPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.allCompanyScreen,
      page: () => const AllCompanyScreen(),
      binding: AllCompaniesBinding(),
    ),
    GetPage(
      name: AppRoutes.allDonorsScreen,
      page: () => const AllDonorsScreen(),
      binding: AllDonorsBinding(),
    ),
    GetPage(
      name: AppRoutes.faqPreviewScreen,
      page: () => const FaqPreviewScreen(),
      binding: FaqPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.collectionScreen,
      page: () => const CollectionScreen(),
      binding: CollectionBinding(),
    ),
    GetPage(
      name: AppRoutes.addCashScreen,
      page: () => const AddCashScreen(),
      binding: AddCashBinding(),
    ),
    GetPage(
      name: AppRoutes.associationDashboardScreen,
      page: () => const AssociationDashboardScreen(),
      binding: AssociationDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.donorDashboardScreen,
      page: () => const DonorDashboardScreen(),
      binding: DonorDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.fundsRequestsScreen,
      page: () => const FundsRequestsScreen(),
      binding: FundsRequestsBinding(),
    ),
    GetPage(
      name: AppRoutes.fundsRequestPreviewScreen,
      page: () => const FundsRequestPreviewScreen(),
      binding: FundsRequestPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.financialStatementScreen,
      page: () => const FinancialStatementScreen(),
      binding: FinancialStatementBinding(),
    ),
    GetPage(
      name: AppRoutes.adminAndOperationsScreen,
      page: () => const AdminAndOperationsScreen(),
      binding: AdminAndOperationsBinding(),
    ),
    GetPage(
      name: AppRoutes.campaignsProjectsScreen,
      page: () => const CampaignsProjectsScreen(),
      binding: CampaignsProjectsBinding(),
    ),
    GetPage(
      name: AppRoutes.donorScreen,
      page: () => const DonorScreen(),
      binding: DonorBinding(),
    ),
    GetPage(
      name: AppRoutes.financialScreen,
      page: () => const FinancialScreen(),
      binding: FinancialBinding(),
    ),
    GetPage(
      name: AppRoutes.donationDataScreen,
      page: () => const DonationDataScreen(),
      binding: DonationDataBinding(),
    ),
    GetPage(
      name: AppRoutes.userEngagementScreen,
      page: () => const UserEngagementScreen(),
      binding: UserEngagementBinding(),
    ),
    GetPage(
      name: AppRoutes.myWalletScreen,
      page: () => const MyWalletScreen(),
      binding: MyWalletBinding(),
    ),
    GetPage(
      name: AppRoutes.myRefundsScreen,
      page: () => const MyRefundsScreen(),
      binding: MyRefundsBinding(),
    ),
    GetPage(
      name: AppRoutes.authTaskScreen,
      page: () => const AuthTaskScreen(),
      binding: AuthTaskBinding(),
    ),
    GetPage(
      name: AppRoutes.accountDeletionScreen,
      page: () => const AccountDeletionScreen(),
      binding: AccountDeletionBinding(),
    ),
    GetPage(
      name: AppRoutes.publicDocumentsScreen,
      page: () => const PublicDocumentsScreen(),
      binding: PublicDocumentsBinding(),
    ),
    GetPage(
      name: AppRoutes.userDocumentsScreen,
      page: () => const UserDocumentsScreen(),
      binding: UserDocumentsBinding(),
    ),
    GetPage(
      name: AppRoutes.platformDocumentsScreen,
      page: () => const PlatformDocumentsScreen(),
      binding: PlatformDocumentsBinding(),
    ),
    GetPage(
      name: AppRoutes.auditLogScreen,
      page: () => const AuditLogScreen(),
      binding: AuditLogBinding(),
    ),
    GetPage(
      name: AppRoutes.faqsScreen,
      page: () => const FaqsScreen(),
      binding: FaqsBinding(),
    ),
    GetPage(
      name: AppRoutes.cmsNewsScreen,
      page: () => const CMSNewsScreen(),
      binding: CMSNewsBinding(),
    ),
    GetPage(
      name: AppRoutes.adminAccountScreen,
      page: () => const AdminAccountScreen(),
    ),
    GetPage(
      name: AppRoutes.addPlatformDoc,
      page: () => const AddPlatformDoc(),
    ),
    GetPage(
      name: AppRoutes.addFaqScreen,
      page: () => const AddFaqScreen(),
    ),
    GetPage(
      name: AppRoutes.addNewsScreen,
      transition: Transition.rightToLeft,
      page: () => const AddNewsScreen(),
      binding: AddNewsBinding(),
    ),
    GetPage(
      name: AppRoutes.aboutAssociationScreen,
      page: () => const AboutAssociationScreen(),
      binding: AboutAssociationBinding(),
    ),
    GetPage(
      name: AppRoutes.notificationsPreviewScreen,
      page: () => const NotificationsPreviewScreen(),
      binding: NotificationsPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.auditDetailsScreen,
      page: () => const AuditDetailsScreen(),
      binding: AuditDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.notificationManagementScreen,
      page: () => const NotificationManagementScreen(),
      binding: NotificationManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.addNotificationScreen,
      page: () => const AddNotificationScreen(),
      binding: AddNotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.cmsServicesScreen,
      page: () => const CmsServicesScreen(),
      binding: CmsServicesBinding(),
    ),
    GetPage(
      name: AppRoutes.addServiceScreen,
      page: () => const AddServiceScreen(),
      transition: Transition.rightToLeft,
      binding: AddServicesBinding(),
    ),
    GetPage(
      name: AppRoutes.transferQueueScreen,
      page: () => const TransferQueueScreen(),
      binding: TransferQueueBinding(),
    ),
    GetPage(
      name: AppRoutes.globalSearchScreen,
      page: () => const GlobalSearchScreen(),
      binding: GlobalSearchBinding(),
    ),
    GetPage(
      name: AppRoutes.searchResultScreen,
      page: () => const SearchResultScreen(),
      binding: SearchResultBinding(),
    ),
    GetPage(
      name: AppRoutes.adsManagementScreen,
      page: () => const AdsManagementScreen(),
      binding: AdsManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.addAdsScreen,
      page: () => const AddAdsScreen(),
      binding: AddAdsBinding(),
    ),
    GetPage(
      name: AppRoutes.recipientsCampaignScreen,
      page: () => const RecipientsCampaignScreen(),
      binding: RecipientsCampaignBinding(),
    ),
    GetPage(
      name: AppRoutes.addGroupScreen,
      page: () => const AddGroupScreen(),
      binding: AddGroupBinding(),
    ),
    GetPage(
      name: AppRoutes.recipientDetailsScreen,
      page: () => const RecipientDetailsScreen(),
      binding: GroupDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.approverGroupScreen,
      page: () => const ApproverGroupScreen(),
      binding: ApproverGroupBinding(),
    ),
    GetPage(
      name: AppRoutes.workflowConfigScreen,
      page: () => const WorkflowConfigScreen(),
      binding: WorkflowConfigBinding(),
    ),
    GetPage(
      name: AppRoutes.qrScannerScreen,
      page: () => const QrScannerScreen(),
    ),
    GetPage(
      name: AppRoutes.addApproverGroupScreen,
      page: () => const AddApproverGroupScreen(),
      binding: AddApproverGroupBinding(),
    ),
    GetPage(
      name: AppRoutes.addWorkflowScreen,
      page: () => const AddWorkflowScreen(),
      binding: AddWorkflowBinding(),
    ),
    GetPage(
      name: AppRoutes.addDonationReminderScreen,
      page: () => const AddDonationReminderScreen(),
      binding: AddDonationReminderBinding(),
    ),
    GetPage(
      name: AppRoutes.projectAlertsScreen,
      page: () => const ProjectAlertsScreen(),
      binding: ProjectAlertsBinding(),
    ),
    GetPage(
      name: AppRoutes.donationReminderScreen,
      page: () => const DonationReminderScreen(),
      binding: DonationReminderBinding(),
    ),
    GetPage(
      name: AppRoutes.smtpConfigScreen,
      page: () => const SmtpConfigScreen(),
      binding: SmtpConfigBinding(),
    ),
    GetPage(
      name: AppRoutes.adminDashboardScreen,
      page: () => const AdminDashboardScreen(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.slaDashboardScreen,
      page: () => const SlaDashboardScreen(),
      binding: SlaDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.photoViewScreen,
      page: () => const PhotoViewScreen(),
      binding: PhotoViewBinding(),
    ),
    GetPage(
      name: AppRoutes.aboutSahemScreen,
      page: () => const AboutSahemScreen(),
      binding: AboutSahemBinding(),
    ),
    GetPage(
      name: AppRoutes.donorPreviewScreen,
      page: () => const DonorPreviewScreen(),
      binding: DonorPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.activityLogScreen,
      page: () => const ActivityLogScreen(),
      binding: ActivityLogBinding(),
    ),
    GetPage(
      name: AppRoutes.onBoardingScreen,
      page: () => const OnBoardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.logInScreen,
      page: () => const LoginScreen(),
      binding: LogInBinding(),
    ),
    GetPage(
      name: AppRoutes.legacyLoginScreen,
      page: () => const LegacyLoginScreen(),
      binding: LogInBinding(),
    ),
    GetPage(
      name: AppRoutes.cartScreen,
      page: () => const CartScreen(),
    ),
    GetPage(
      name: AppRoutes.projectsDonatedScreen,
      page: () => const ProjectsDonatedScreen(),
      binding: LastDonatedBinding(),
    ),
    GetPage(
      name: AppRoutes.accountScreen,
      page: () => const AccountScreen(),
    ),
    GetPage(
        name: AppRoutes.staticsScreen,
        page: () => const StatisticsScreen(),
        binding: StaticsBinding()),
    GetPage(
        name: AppRoutes.pdfPreviewScreen, page: () => const PdfPreviewScreen()),
    GetPage(name: AppRoutes.splashPage, page: () => const SplashInitPage())
  ];
}
