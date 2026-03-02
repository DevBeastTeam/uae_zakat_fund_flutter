import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/module_codes.dart';

abstract class AppConstant {
  static const String home = "Home";
  static const String campaigns = "Campaigns";
  static const String cart = "Cart";
  static const String account = "Account";
  static const List<String> individualTabs = [
    "accountInformation",
    "contactInformation",
    // "preferences"
  ];

  static const List<String> companyTabs = [
    "companyInformation",
    "contactInformation",
    "companyRepresentative",
    "bankAccount",
  ];

  static const List<String> associationTabs = [
    "associationInformation",
    "contactInformation",
    "representativeInformation",
    "bankAccount",
  ];

  static const androidFirebaseGeneralTopic = "ANDROID_SAHEM_ZAKAT_FUND";
  static const androidFirebaseGeneralTopicEn = "ANDROID_SAHEM_ZAKAT_FUND_EN";
  static const androidFirebaseGeneralTopicAr = "ANDROID_SAHEM_ZAKAT_FUND_AR";
  static const iosFirebaseGeneralTopic = "IOS_SAHEM_ZAKAT_FUND";
  static const iosFirebaseGeneralTopicEn = "IOS_SAHEM_ZAKAT_FUND_EN";
  static const iosFirebaseGeneralTopicAr = "IOS_SAHEM_ZAKAT_FUND_AR";
  static const devAppId = "ae.gov.awqaf.zakat";
  static const prodAppId = "ae.gov.awqaf.zakat";
  static const donor = "Donor";
  static const association = "Association";
  static const company = "Company";
  static const project = "Project";
  static const List<String> statuses = [
    "pending",
    "accepted",
    "returned",
    "rejected"
  ];
  static const List<String> feedbackTypes = [
    "complaint",
    "suggestion",
    "supportFeedbackType"
  ];
  static const List<String> priorities = ["low", "medium", "high"];
  static const List<String> notificationTypes = ["notification", "warning"];
  static const List<String> searchKeywords = [
    "donations",
    "projects",
    "services",
    "associations",
    "zakat",
    "sadaqat",
    "contactUs",
    "support",
    "login",
    "register",
    "faqs",
    "news",
    "helpCenter",
  ];
  static const List<String> searchResultTabs = [
    "all",
    "association",
    "projects",
    "services",
    "news",
    "faq",
    "documents",
  ];

  static const List<String> periods = [
    "monthly",
    "yearly",
  ];

  static const List<String> donationStatuses = [
    "pending",
    "accepted",
    "rejected",
    "pendingForCollection",
    "pendingForConfirmation"
  ];

  static const List<String> languages = [
    "english",
    "arabic",
  ];

  static const List<String> activeInActiveStatuses = [
    "active",
    "inactive",
  ];

  static const List<String> paymentMethods = [
    "card",
    "cash",
    "bankCheque",
    "deposit",
    "wallet",
  ];

  static const List<String> workflowTypes = [
    "association",
    "associationUpdate",
    "company",
    "companyUpdate",
    "aboutUs",
    "aboutUsUpdate",
    "popUp",
    "popUpUpdate",
    "banner",
    "bannerUpdate",
    "staticPage",
    "staticPageUpdate",
    "service",
    "serviceUpdate",
    "news",
    "newsUpdate",
    "faq",
    "faqUpdate",
    "survey",
    "surveyUpdate",
    "campaign",
    "campaignUpdate",
    "project",
    "projectUpdate",
    "refund",
    "cash",
    "deposit",
    "bankCheque",
    "feedbackResponse",
    "fundTransfer",
    "notifications",
    "notificationsUpdate",
  ];

  static const List<String> notificationFrequencies = [
    "instant",
    "daily",
    "weekly",
  ];

  static const List<String> yesNoList = [
    "yes",
    "no",
  ];

  static const List<String> reminderFrequencies = ["monthly", "customDate"];
  static const String onlinePaymentReceiptMessageEnglish =
      "Thank you for your donation. A receipt has been sent to your registered email address.";
  static const String onlinePaymentReceiptMessageArabic =
      "شكراً لتبرعك الذي تم عن طريق. تم إرسال إيصال إلى عنوان بريدك الإلكتروني المسجل.";
  static const String walletPaymentReceiptMessageEnglish =
      "Thank you for your donation made via wallet. A receipt has been sent to your registered email address.";
  static const String walletPaymentReceiptMessageArabic =
      "شكرًا لتبرعك عبر المحفظة. تم إرسال إيصال إلى بريدك الإلكتروني المسجل.";
  static const String cashPaymentReceiptMessageEnglish =
      "Kindly hand over the cash to the General Authority Of Islamic Affairs Endowments & Zakat's rider during collection. Thank you for your cooperation.";
  static const String cashPaymentReceiptMessageArabic =
      "يرجى تسليم المبلغ إلى مندوب الهيئة العامة للشؤون الإسلامية والأوقاف والزكاة عند الاستلام. شكرًا لتعاونكم.";
  static const String chequePaymentReceiptMessageEnglish =
      "Please make your cheque payable to the General Authority Of Islamic Affairs Endowments & Zakat. Our representative will collect it at your convenience, or you can deposit it at the nearest General Authority Of Islamic Affairs Endowments & Zakat branch.";
  static const String chequePaymentReceiptMessageArabic =
      "يرجى إصدار شيك مستحق الدفع للهيئة العامة للشؤون الإسلامية والأوقاف والزكاة. سيقوم مندوبنا بتحصيله في الوقت الذي يناسبك، أو يمكنك إيداعه في أقرب فرع للهيئة العامة للشؤون الإسلامية والأوقاف والزكاة.";
  static const String chequePaymentInvoice = "Cheque_Payment_Invoice";
  static const String cashPaymentInvoice = "Cash_Payment_Invoice";
  static const String bankDepositPaymentInvoice = "Bank_Deposit_Receipt";
  static const String creditCardPaymentInvoice = "Credit_Card_Payment_Invoice";
  static const String walletPaymentInvoice = "Wallet_Payment_Invoice";

  static const List<String> auditLogsStatuses = [
    "success",
    "rejected",
    "pending",
    "returned"
  ];

  static const List<String> auditLogsActions = [
    "login",
    "logout",
    "create",
    "delete",
    "approve",
    "reject",
    "return",
    "view",
    "export",
    "payment",
    "topupWallet",
    "resetPassword",
    "changePassword",
    "validateOTP"
  ];

  static const List<String> auditLogsEntityTypes = [
    "aboutUs",
    "account",
    "accountContact",
    "association",
    "associationUpdate",
    "associationType",
    "bankAccount",
    "bankLookup",
    "campaign",
    "cart",
    "cash",
    "city",
    "CMSNotification",
    "CollectionDetail",
    "CompanyType",
    "country",
    "emirate",
    "faq",
    "feedback",
    "feedbackResponse",
    "fundTransfer",
    "fundTransferDetail",
    "issuingAuthority",
    "jobs",
    "news",
    "newsFavorite",
    "project",
    "projectBeneficiaryType",
    "projectCategories",
    "refund",
    "service",
    "services",
    "staticPagesCMS",
    "taskAssigned",
    "transactionDetail",
    "user",
    "userSession",
    "userDevices",
    "walletDetail",
    "workflow",
  ];

  static const List<String> statusesWithDraft = [
    "pending",
    "accepted",
    "returned",
    "rejected",
    "drafted"
  ];

  static const List<String> donorRequestTypes = [
    "association",
    "bankCheque",
    "cash",
    "company",
    "deposit",
    "feedbackResponse",
    "feedbackResponseUpdate",
    "refund",
  ];

  static const List<String> companyRequestTypes = [
    "bankCheque",
    "cash",
    "company",
    "companyUpdate",
    "deposit",
    "feedbackResponse",
    "feedbackResponseUpdate",
    "refund",
  ];

  static const List<String> associationRequestTypes = [
    "aboutUs",
    "aboutUsUpdate",
    "association",
    "associationUpdate",
    "feedbackResponse",
    "feedbackResponseUpdate",
    "fundTransfer",
    "news",
    "newsUpdate",
    "project",
    "projectUpdate",
  ];

  static const List<String> adminRequestTypes = [
    "aboutUs",
    "aboutUsUpdate",
    "association",
    "associationUpdate",
    "banner",
    "bannerUpdate",
    "bankCheque",
    "campaign",
    "campaignUpdate",
    "cash",
    "company",
    "companyUpdate",
    "deposit",
    "faq",
    "faqUpdate",
    "feedbackResponse",
    "feedbackResponseUpdate",
    "fundTransfer",
    "news",
    "newsUpdate",
    "notifications",
    "notificationsUpdate",
    "popUp",
    "popUpUpdate",
    "project",
    "projectUpdate",
    "refund",
    "service",
    "serviceUpdate",
    "staticPage",
    "staticPageUpdate",
    "survey",
    "surveyUpdate",
  ];

  static const List<String> donorRequestStatuses = [
    "pending",
    "accepted",
    "returned",
    "rejected",
    "pendingForCollection",
    "pendingForConfirmation",
    "pendingForAcknowledgement",
  ];

  static const List<String> fileTypes = [
    "JPEG",
    "PNG",
    "SVG",
    "PDF",
    "XLS",
    "XLSX",
    "CSV",
  ];

  static const List<String> enableDisAbleStatus = [
    "enable",
    "disable",
  ];

  static const List<String> employeeStatus = [
    "pending",
    "accepted",
    "rejected",
  ];

  static const List<String> associationRanges = [
    "dateOfEstablishment",
    "associationType",
    "issuingAuthority",
    "licenseExpiryDate"
  ];

  static const List<String> companyRanges = [
    "dateOfEstablishment",
    "issuingAuthority",
    "licenseExpiryDate"
  ];

  static const List<String> donorRanges = [
    "gender",
    "hasPhoto",
    "jobDescription",
    "isVIP",
    "nationality"
  ];

  static const List<String> employeeRanges = [
    "jobTitle",
    "nationality",
    "isEmailVerified",
    "isSMSVerified",
    "isActive",
  ];

  static const List<String> operations = [
    "equalTo",
    "notEqualTo",
    "lessThan",
    "biggerThan",
    "lessThanEqualTo",
    "greaterThanEqualTo",
    "contains",
    "notContains",
  ];

  static const List<String> logicalOperations = [
    "and",
    "or",
  ];

  static const List<String> userDocEntityTypes = [
    "association",
    "company",
    "project",
    "user",
    "campaign",
  ];

  static const List<String> associatedUserTypes = [
    "association",
    "company",
    "project",
    "user",
    "campaign",
  ];

  static const List<String> reasons = [
    "insufficientData",
    "invalidData",
    "other"
  ];

  static const List<String> adsTypes = ["banner", "popUp"];

  static const List<String> popUpCloseButtons = ["yes", "no"];

  static const List<String> popUpPositions = ["center", "top"];

  static const List<String> recipientsUserTypes = [
    "association",
    "company",
    "donor",
    "employee",
    "agent",
  ];

  static const List<String> accountDeletionReasons = [
    "concernedAboutPrivacy",
    "lackOfSupport",
    "changeInInterest",
    "other"
  ];

  static List<Categories> individualAccountTabs = [
    Categories(name: "dashboard", icon: AppResources.dashboardIcon),
    Categories(
        name: "myProfile",
        icon: AppResources.profileCircleOutlined,
        code: "myProfile"),
    favAccountTab,
    Categories(name: "requests", icon: AppResources.requestsIcon),
    Categories(name: "feedback", icon: AppResources.feedbackIcon),
    // Categories(name: "myAssociations", icon: AppResources.myAssociationIcon),
    // Categories(name: "myCompanies", icon: AppResources.myCompanyIcon),
    Categories(name: "contributionLog", icon: AppResources.donationsIcon),
    // Categories(name: "myWallet", icon: AppResources.walletIcon),
    // Categories(name: "myRefunds", icon: AppResources.refundIcon),
    accessibilityAccountTab,
    myNotificationsTab,
    settingsAccountTab,
  ];

  static List<Categories> companyAccountTabs = [
    Categories(
        name: "dashboard",
        icon: AppResources.dashboardIcon,
        code: ModuleCodes.companyDashboardCode),
    Categories(
        name: "myProfile",
        icon: AppResources.profileCircleOutlined,
        code: ModuleCodes.companyProfileCode),
    favAccountTab,
    Categories(
        name: "requests",
        icon: AppResources.requestsIcon,
        code: ModuleCodes.companyRequestsCode),
    Categories(
        name: "feedback",
        icon: AppResources.feedbackIcon,
        code: ModuleCodes.companyFeedbacksCode),
    Categories(
        name: "managementAndStaff",
        icon: AppResources.mgtStaffIcon,
        code: ModuleCodes.companyEmployeesCode),
    Categories(
        name: "contributionLog",
        icon: AppResources.donationsIcon,
        code: ModuleCodes.companyDonationsCode),
    // Categories(
    //     name: "myRefunds",
    //     icon: AppResources.refundIcon,
    //     code: ModuleCodes.companyMyRefundsCode),
    accessibilityAccountTab,
    myNotificationsTab,
    settingsAccountTab,
  ];

  static List<Categories> associationAccountTabs = [
    Categories(
        name: "dashboard",
        icon: AppResources.dashboardIcon,
        code: ModuleCodes.associationDashboardCode),
    Categories(
        name: "myProfile",
        icon: AppResources.profileCircleOutlined,
        code: ModuleCodes.associationProfileCode),
    favAccountTab,
    Categories(
        name: "requests",
        icon: AppResources.requestsIcon,
        code: ModuleCodes.associationRequestsCode),
    Categories(
        name: "myProjects",
        icon: AppResources.certificateIcon,
        code: ModuleCodes.associationMyProjectsCode),
    Categories(
        name: "feedback",
        icon: AppResources.feedbackIcon,
        code: ModuleCodes.associationFeedbacksCode),
    Categories(
        name: "myContent",
        icon: AppResources.documentCopyIcon,
        isExpansion: true,
        code: ModuleCodes.associationMyContentCode),
    Categories(
        name: "managementAndStaff",
        icon: AppResources.mgtStaffIcon,
        code: ModuleCodes.associationEmployeesCode),
    Categories(
        name: "myFundings",
        icon: AppResources.myFundingIcon,
        isExpansion: true,
        code: ModuleCodes.associationMyFundingCode),
    accessibilityAccountTab,
    myNotificationsTab,
    settingsAccountTab,
  ];

  static List<Categories> myFundingSubTabs = [
    Categories(
        name: "fundsRequests", code: ModuleCodes.associationFundRequestCode),
    Categories(
        name: "financialStatement",
        code: ModuleCodes.associationFinancialStatementCode),
  ];

  static List<Categories> myContentSubTabs = [
    Categories(name: "news", code: ModuleCodes.associationNewsCode),
    Categories(
        name: "aboutTheAssociation", code: ModuleCodes.associationAboutUsCode),
  ];

  static List<Categories> adminAccountTabs = [
    Categories(
        name: "dashboard",
        icon: AppResources.dashboardIcon,
        isExpansion: true,
        code: ModuleCodes.adminDashboardCode),
    favAccountTab,
    Categories(
        name: "requestsManagement",
        icon: AppResources.requestsIcon,
        code: ModuleCodes.adminRequestManagementCode),
    Categories(
        name: "associations",
        icon: AppResources.myAssociationIcon,
        code: ModuleCodes.adminAllAssociationsCode),
    Categories(
        name: "companies",
        icon: AppResources.myCompanyIcon,
        code: ModuleCodes.adminAllCompaniesCode),
    Categories(
        name: "donors",
        icon: AppResources.donorsIcon,
        code: ModuleCodes.adminAllDonorsCode),
    Categories(
        name: "projectManagement",
        icon: AppResources.certificateIcon,
        code: ModuleCodes.adminProjectManagementCode),
    Categories(
        name: "pageManagement",
        icon: AppResources.documentCopyIcon,
        isExpansion: true,
        code: ModuleCodes.adminPageManagementCode),
    Categories(
        name: "adsManagement",
        icon: AppResources.adsIcon,
        code: ModuleCodes.adminAdsManagementCode),
    Categories(
        name: "massCampaignManagement",
        icon: AppResources.massCampaignIcon,
        isExpansion: true,
        code: ModuleCodes.adminMassCampaignManagementCode),
    Categories(
        name: "notificationsManagement",
        icon: AppResources.notificationIcon,
        code: ModuleCodes.adminNotificationsManagementCode),
    Categories(
        name: "feedbackManagement",
        icon: AppResources.feedbackIcon,
        code: ModuleCodes.adminFeedbackManagementCode),
    Categories(
        name: "usersManagement",
        icon: AppResources.profileEditIcon,
        code: ModuleCodes.adminUsersManagementCode),
    Categories(
        name: "financialManagement",
        icon: AppResources.receiptEditIcon,
        isExpansion: true,
        code: ModuleCodes.adminFinancialManagementCode),
    Categories(
        name: "documentManagement",
        icon: AppResources.documentIcon,
        isExpansion: true,
        code: ModuleCodes.adminDocumentManagementCode),
    Categories(
        name: "systemConfiguration",
        icon: AppResources.systemConfigIcon,
        isExpansion: true,
        code: ModuleCodes.adminSystemConfigurationCode),
    Categories(
        name: "workflowManagement",
        icon: AppResources.workflowIcon,
        isExpansion: true,
        code: ModuleCodes.adminWorkflowManagementCode),
    accessibilityAccountTab,
    settingsAccountTab,
  ];

  static List<Categories> dashboardSubTabs = [
    Categories(
        name: "adminDashboard", code: ModuleCodes.adminAdminDashboardCode),
    Categories(
        name: "adminAndOperations",
        code: ModuleCodes.adminAdminAndOperationsDashboardCode),
    Categories(
        name: "campaignsAndProjects",
        code: ModuleCodes.adminCampaignsAndProjectsDashboardCode),
    Categories(
        name: "donations", code: ModuleCodes.adminDonationsDashboardCode),
    Categories(name: "donors", code: ModuleCodes.adminDonorsDashboardCode),
    Categories(
        name: "financial", code: ModuleCodes.adminFinancialDashboardCode),
    Categories(
        name: "userEngagementAndInteraction",
        code: ModuleCodes.adminEngagementAndInteractionsDashboardCode),
    Categories(
        name: "slaCompliance",
        code: ModuleCodes.adminSLAComplianceDashboardCode),
  ];

  static List<Categories> workflowSubTabs = [
    Categories(name: "approverGroup", code: ModuleCodes.adminApproverGroupCode),
    Categories(
        name: "workflowConfiguration",
        code: ModuleCodes.adminWorkflowConfigCode),
  ];

  static List<Categories> documentSubTabs = [
    Categories(
        name: "publicDocuments", code: ModuleCodes.adminPublicDocumentsCode),
    Categories(
        name: "userDocuments", code: ModuleCodes.adminUsersDocumentsCode),
    Categories(
        name: "platformDocuments",
        code: ModuleCodes.adminPlatformDocumentsCode),
  ];

  static List<Categories> systemConfigSubTabs = [
    Categories(name: "auditLog", code: ModuleCodes.adminAuditLogsCode),
    Categories(name: "emailSMTPConfig", code: ModuleCodes.adminSMTPConfigCode),
  ];

  static List<Categories> pageManagementSubTabs = [
    Categories(name: "faqs", code: ModuleCodes.adminFAQCode),
    Categories(name: "services", code: ModuleCodes.adminServicesCode),
    Categories(name: "news", code: ModuleCodes.adminNewsCode),
    Categories(name: "staticPage", code: ModuleCodes.adminStaticPageCode),
    Categories(name: "aboutUs", code: ModuleCodes.adminAboutUsCode),
  ];

  static List<Categories> financialManagementSubTabs = [
    Categories(
        name: "fundTransferQueue", code: ModuleCodes.adminFundsTransferQueCode),
    Categories(
        name: "donationRegister", code: ModuleCodes.adminDonationRegisterCode),
  ];

  static List<Categories> campaignSubTabs = [
    Categories(name: "campaignTemplates", code: ModuleCodes.adminCampaignTemplatesCode),
    Categories(name: "recipients", code: ModuleCodes.adminRecipientsCode),
  ];

  static Categories taskAccountTab = Categories(
      name: "tasks",
      icon: AppResources.logIcon,
      code: ModuleCodes.adminTasksCode);
  static Categories favAccountTab = Categories(
      name: "favourites",
      icon: AppResources.favIcon,
      code: ModuleCodes.favouritesCode);
  static Categories accessibilityAccountTab = Categories(
      name: "accessibility",
      icon: AppResources.accessibilityIcon,
      code: ModuleCodes.accessibilityCode);
  static Categories settingsAccountTab = Categories(
      name: "settings",
      icon: AppResources.settingsIcon,
      code: ModuleCodes.settingsCode);

  static Categories myNotificationsTab = Categories(
      name: "notificationsSettings",
      icon: AppResources.notificationIcon,
      code: "N-0");

  static const List<String> collectionTimings = [
    "09:00 am to 10:00 am",
    "10:00 am to 11:00 am",
    "11:00 am to 12:00 pm",
    "12:00 pm to 01:00 pm",
    "01:00 pm to 02:00 pm",
    "02:00 pm to 03:00 pm",
    "03:00 pm to 04:00 pm",
    "04:00 pm to 05:00 pm",
    "05:00 pm to 06:00 pm",
    "06:00 pm to 07:00 pm",
    "07:00 pm to 08:00 pm",
    "08:00 pm to 09:00 pm",
  ];
}
