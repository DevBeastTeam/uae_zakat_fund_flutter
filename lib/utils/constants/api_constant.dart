abstract class ApiConstant {
  static const String devUrl =
      'https://zakatfundapi.eventoclients.com/'; //'https://npzapi.npz.gov.ae/';
  static const String prodUrl =
      'https://npzapi.npz.gov.ae/'; //'https://stgnpzapi.npz.gov.ae/'; //'https://npzapi.npz.gov.ae/';
  static const String devBaseUrl = '${devUrl}api/';
  static const String prodBaseUrl = '${prodUrl}api/';
  static const String devWebSiteUrl =
      'https://zakatfundweb.eventoclients.com/'; //'https://www.npz.gov.ae/';//
  static const String prodWebSiteUrl =
      'https://www.npz.gov.ae/'; //'https://www.stgnpz.npz.gov.ae/'; //'https://www.npz.gov.ae/';//
  static const String devCustomerPulseUrl =
      "https://sandboxsurvey.customerpulse.gov.ae/v2/F/ks//?lang=";
  static const String prodCustomerPulseUrl =
      "https://survey.customerpulse.gov.ae/v2/F/ks//?lang=";
  static const String devStorageUrl = '${devUrl}Attachments/';
  static const String prodStorageUrl = '${prodUrl}Attachments/';
  static const String chatBotUrl =
      'https://chatbot.zakatfund.gov.ae/Zakat-Fund/faces/pages/';

  ///

  static const String registerUser = 'Register/user';
  static const String validateOTP = 'Register/OTP-validate';
  static const String resendOTP = 'Register/OTP-request';
  static const String forgotPassword = 'Auth/forgot-password';
  static const String logIn = 'Auth';
  static const String fileUpload = 'FileUpload';
  static const String fileUploadOrgAttach = 'FileUpload/org-config-attacments';
  static const String donorAccountInfo = 'Donor/account-info';
  static const String donorContactInfo = 'Donor/contact-info';
  static const String donorProfile = 'Donor/profileSetting';
  static const String nationality = 'Nationality/GetAllNationalities';
  static const String serviceCategories = 'Lookup/service-category';
  static const String countries = 'Lookup/Country';
  static const String cities = 'Lookup/city';
  static const String citiesByCountry = 'Lookup/city-by-country';
  static const String states = 'Lookup/state';
  static const String banks = 'BankList/GetAllBankLookupList';
  static const String companyField = 'Lookup/company-field';
  static const String associationType =
      'AssociationType/GetAllAssociationTypesList';
  static const String companyInfo = 'Company/company-info';
  static const String companyContactInfo = 'Company/contact-info';
  static const String companyRepresentative = 'Company/company-representative';
  static const String companyBankAccount = 'Company/bank-account';
  static const String companyProfile = 'Company/profileSetting';
  static const String associationInfo = 'Association/association-info';
  static const String associationContactInfo = 'Association/contact-info';
  static const String associationRepresentative =
      'Association/company-representative';
  static const String associationBankAccount = 'Association/bank-account';
  static const String associationProfile = 'Association/profileSetting';
  static const String associationProjects = 'Association/projects';
  static const String project = 'Project';
  static const String userProjects = 'Project/getAllProjectByUserId';
  static const String campaignType = 'Lookup/campaign-type';
  static const String associations = 'Association/List';
  static const String userCart = 'Cart/user-cart';
  static const String addToCart = 'Cart/add-to-cart';
  static const String deleteCartProduct = 'Cart';
  static const String deleteAllCart = 'Cart/delete-all';
  static const String updateCartItem = 'Cart/update-cart';
  static const String updateUserCart = 'Cart/cart-items';
  static const String socialRegister = 'Auth/social-media';
  static const String appleInfo = 'AppleInformation';
  static const String checkUAEUser = 'Auth/userExistCheckWithUUID';
  static const String saveUAEUser = 'Auth/AddUserWithUAEPass';
  static const String faqCategory = 'Category/GetAllCategoryList';
  static const String getAllFAQs = 'FAQ/GetAllFAQList';
  static const String getAllServices = 'Service/GetAllServicesList';
  static const String latestNews = 'News/GetAllNewsList';
  static const String jobTitle = 'JobTitle/GetAllJobTitles';
  static const String featuredProject = 'Project/getFeaturedProjects';
  static const String staticPages = 'StaticPage/GetAllStaticPagesBySectionList';
  static const String allEmployees =
      'Employee/GetAllEmployeeListByAccountIdPaginated';
  static const String addEmployee = 'Employee';
  static const String allTransactions = 'Payment/all-transaction-detail';
  static const String updateEmployee = 'Employee/update-employee';
  static const String disableEmployee = 'Employee/disable-empl';
  static const String deleteEmployee = 'Employee/delete-empl';
  static const String addFavoriteProject = 'Favorite/add-to-favorite';
  static const String addFavoriteNews = 'News/add-news-favorite';
  static const String addFavoriteService = 'Service/add-service-favorite';
  static const String favoriteProjects = 'Favorite/user-favorite';
  static const String newsDetails = 'News/GetNewsById';
  static const String favouriteNews = 'News/get-user-favorite-news';
  static const String favouriteServices = 'Service/get-user-favorite-service';
  static const String associationNews = 'News/get-association-news';
  static const String newsCategories = 'Lookup/news-category';
  static const String associationAboutUs = 'AboutUs/get-association-AboutUs';
  static const String associationContactUs =
      'ContactUs/get-association-contactus';
  static const String sendContactUs = 'ContactUs/add-contactus';
  static const String userNotifications =
      'CMSNotification/getnotification-by-user';
  static const String readSingNotification =
      'CMSNotification/read-notification';
  static const String readAllNotification =
      'CMSNotification/read-all-notification';
  static const String deleteAllNotification =
      'CMSNotification/delete-all-notification';
  static const String addDevice = 'User/add-device';
  static const String verifyEmail = 'Employee/resend-email';
  static const String verifyPhone = 'Employee/phone-verification';
  static const String feedbacks = 'Feedback/GetAllFeedbackByUserId';
  static const String allFeedbacks = 'Feedback/GetAllFeedbackList';
  static const String addFeedbacks = 'Feedback/add-Feedback';
  static const String deleteFeedback = 'Feedback/delete-Feedback';
  static const String feedbackDetails = 'Feedback/GetAllFeedbackById';
  static const String requests = 'UserRequest/request-userId';
  static const String adDetails = 'Ads/GetAllAdsById';
  static const String staticPageDetails = '/StaticPage/GetStaticPageById';
  static const String aboutAssociation = 'AboutUs/GetAboutUsById';
  static const String serviceDetails = 'Service/GetServiceById';
  static const String updateFeedbackStatus = 'Feedback/update-Feedback';
  static const String updateServiceStatus = 'Service/update-Service';
  static const String updateNewsStatus = 'News/update-news';
  static const String updateAboutUsStatus = 'AboutUs/update-AboutUs';
  static const String requestApproval = 'UserRequest/request-approval';
  static const String transactions = 'Payment/transaction-by-user';
  static const String creditDebitPayment = 'ViewMobile/Index';
  static const String walletPayment = 'ViewMobilewallet/Index';
  static const String transactionDetails = 'Payment/detail-by-session';
  static const String addQuickProjects = 'Payment/add-quick-donate';
  static const String campaignDetails = 'Campaign/GetAllCampaignById';
  static const String recipients = 'Campaign/GetAllCampaignDetailById';
  static const String surveyDetails = 'Survey/GetAllSurveyById';
  static const String refundRequestDetails = 'Payment/refund-detail-by-session';
  static const String offlinePayment = 'Payment/offline-payment';
  static const String refundRequest = 'UserRequest';
  static const String faqDetails = 'FAQ/GetAllFAQById';
  static const String allAssociations = 'Association/GetAllAssociation';
  static const String myAllAssociations = 'Association/my-association-list';
  static const String allCompanies = 'Company/GetAllCompaniesPaginated';
  static const String myAllCompanies = 'Company/my-company-list';
  static const String allDonors = 'Donor/GetAllDonorsPaginated';
  static const String assignFeedback = 'Feedback/AssignFeedback';
  static const String submitFeedbackResponse = 'Feedback/update-Feedback';
  static const String latestDonation = 'Payment/GetLastDonatedDataByUserId';
  static const String refundHistory =
      'DonorDashboard/GetRefundHistoryDonorDashboard';
  static const String donationHistory =
      'DonorDashboard/GetDonationHistoryDonorDashboard';
  static const String superEmployees = 'Employee/GetAllSuperEmployee';
  static const String superAgents = 'Employee/GetAllSuperAgent';
  static const String donorDashboardData =
      'DonorDashboard/GetHeaderDataDonorDashboard';
  static const String addTask = 'Tasks/AddTask';
  static const String myTasks = 'Tasks/GetAllTasksList';
  static const String associationDashboardData =
      'AssociationDashboard/GetHeaderDataAssociationDashboard';
  static const String associationAverageSummary =
      'AssociationDashboard/GetDonorAverageAssociationDashboard';
  static const String associationTopProjects =
      'AssociationDashboard/GetTopProjectsAssociationDashboard';
  static const String associationDonations =
      'AssociationDashboard/GetProjectAssociationDashboard';
  static const String rejectTask = 'Tasks/RejectTask';
  static const String taskDetailsByCode = 'UserRequest/RequestByUniqueCode';
  static const String taskCollection = 'Payment/AddCollectionDetail';
  static const String donorPercentage =
      'AssociationDashboard/GetDonorPercentageAssociationDashboard';
  static const String taskDetails = 'Tasks/GetTaskById';
  static const String headerDataDDD =
      'AdminDashboard/AdminDashboardGetHeaderDataDDD';
  static const String donorDemographicsDDD =
      'AdminDashboard/AdminDashboardGetDonorDemographicsLevel1DDD';
  static const String topDonorDemographicsDDD =
      'AdminDashboard/AdminDashboardGetTopDonorDemographicsDDD';
  static const String headerDataCPDD =
      'AdminDashboard/AdminDashboardGetHeaderDataCPDD';
  static const String topPerformingProjectsCPDD =
      'AdminDashboard/AdminDashboardGetTopPerformingProjectsCPDD';
  static const String campaignFundingGapCPDD =
      'AdminDashboard/AdminDashboardGetCampaignFundingGapCPDD';
  static const String projectsReachingEndCPDD =
      'AdminDashboard/AdminDashboardGetProjectsReachingEndCPDD';
  static const String donationBreakdownByProjectAODD =
      'AdminDashboard/AdminDashboardGetDonationBreakdownByProjectAODD';
  static const String top5ProjectsAODD =
      'AdminDashboard/AdminDashboardGetTopProjectsAODD';
  static const String top5AssociationsAODD =
      'AdminDashboard/AdminDashboardGetTopAssociationsAODD';
  static const String donorAverageAODD =
      'AdminDashboard/AdminDashboardGetGetDonorAverageAODD';
  static const String donorPercentageAODD =
      'AdminDashboard/AdminDashboardGetDonorPercentageAODD';
  static const String walletBalance = 'Wallet/GetWalletBalance';
  static const String payViaWallet = 'Wallet/PayViaWallet';
  static const String acceptAssociationRequest =
      'Association/account_contact_status';
  static const String acceptCompanyRequest = 'Company/account_contact_status';
  static const String myRefunds = 'Payment/GetAllRefundDetailByUserPaginated';
  static const String myWallet = 'Wallet/GetTopupHistory';
  static const String adsList = 'Ads/GetHomeAdsList';
  static const String taskCollectionDetails =
      'UserRequest/GetDetailsForAuthenticate';
  static const String authenticateTaskRequest = 'Tasks/AuthenticateTaskRequest';
  static const String publicDocuments = 'Document/public-document-list';
  static const String userDocuments = 'Document/user-document-list';
  static const String platformDocuments = 'Document/platform-document-list';
  static const String platformDocumentStatus =
      'Document/update-platform-document-status';
  static const String savePlatformDocument = 'Document/add-platform-document';
  static const String uploadPublicDocument = 'Document';
  static const String updatePlatformDocument =
      'Document/update-platform-document';
  static const String archiveNews = 'News/GetAllArchivesNews';
  static const String publicDocumentStatus =
      'Document/update-public-document-status';
  static const String associationProjectsPaginated =
      'Association/projectsPaginated';
  static const String submitFundTransferRequest =
      'FundTransfer/SubmitFundTransferRequest';
  static const String auditLog = 'AuditLog/GetAllAuditLogsPaginated';
  static const String fundRequestDetails =
      'Association/GetAssociationFundTransferRequestDetails';
  static const String sahemBanks = 'SahemBankAccount/GetAllSahemBankAccounts';
  static const String fundTransferDetail =
      'FundTransfer/GetFundTransferDetailById';
  static const String deleteFAQ = 'FAQ/delete-faq';
  static const String addFAQ = 'FAQ/add-faq';
  static const String updateFAQ = 'FAQ/update-faq';
  static const String faqPaginated = 'FAQ/GetAllFaqPaginated';
  static const String exportFAQs = 'FAQ/ExportAllFaqToCsv';
  static const String additionalDocuments =
      'Document/GetDocumentAssociatedWithById';
  static const String projectCategories =
      'ProjectCategories/GetAllProjectCategoriesList';
  static const String projectBeneficiaryTypes =
      'ProjectBeneficiaryType/GetAllProjectBeneficiaryTypesList';
  static const String issuingAuthorities =
      'IssuingAuthority/GetAllIssuingAuthoritiesList';
  static const String emirates = 'Emirates/GetAllStatesByCountryID/';
  static const String exportFile = 'Export/ExportToCsv?entityName=';
  static const String associationsList =
      'Association/GetAllAssociationsPaginated';
  static const String projectListPaginated = 'Project/getProjectListPaginated';
  static const String saveAdditionalDocuments =
      'Document/AddDocsByAssociatedWith';
  static const String companyTypes = 'CompanyType/GetAllCompanyTypesList';
  static const String userRequestPaginated =
      'UserRequest/GetAllUserRequestPaginated';
  static const String allNewsPaginated = 'News/GetAllNewsPaginated';
  static const String exportNews = 'News/ExportAllNewsToCsv';
  static const String addNews = 'News/add-News';
  static const String updateNews = 'News/update-news';
  static const String exportUserRequests =
      'UserRequest/ExportUserRequestsToCsv';
  static const String cmsAssociationNews = 'News/get-association-news';
  static const String addAboutUs = 'AboutUs/add-AboutUs';
  static const String updateAboutUs = 'AboutUs/update-AboutUs';
  static const String notificationDetails =
      'CMSNotification/GetCMSNotificationById';
  static const String addAssociation = 'Association/AddAssociationProfile';
  static const String updateAssociation =
      'Association/UpdateAssociationProfile';
  static const String exportFeedbacks =
      'Feedback/ExportFeedbacksToCsv?pageNumber=1&pageSize=1000';
  static const String allFeedbacksPaginated =
      'Feedback/GetAllFeedbacksPaginated';
  static const String auditLogById = 'AuditLog/GetAuditLogById';
  static const String exportNotifications =
      'CMSNotification/ExportAllNotificationToCsv/1';
  static const String cmsNotifications =
      'CMSNotification/GetAllNotificationPaginated';
  static const String saveNotification = 'CMSNotification/add-CMSNotification';
  static const String updateNotification =
      'CMSNotification/update-CMSNotification';
  static const String addCompany = 'Company/AddCompanyProfile';
  static const String updateCompany = 'Company/UpdateCompanyProfile';
  static const String cmsServices = 'Service/GetAllServicesPaginated';
  static const String exportServices = 'Service/ExportAllServicesToCsv';
  static const String activeDeActiveService = 'Service/ActiveDeactiveService';
  static const String sahemUsers = 'RoleAndPermission/GetAllSahemUser';
  static const String sahemRoles = 'Lookup/GetRoleByCategory/';
  static const String addSahemUser = 'RoleAndPermission/AddSahemUser';
  static const String updateSahemUser = 'RoleAndPermission/UpdateSahemUser';
  static const String userPermissions =
      'RoleAndPermission/GetModuleAndPermissionListByUserId';
  static const String addService = 'Service/add-service';
  static const String updateService = 'Service/update-service';
  static const String exportFundTransferQueue =
      'FundTransfer/fund-transfer-queue-list/export-to-csv?PageSize=1000&PageNumber=1';
  static const String fundTransferQueue =
      'FundTransfer/fund-transfer-queue-list';
  static const String globalSearch = 'Common/GetSearchResult';
  static const String allAdsPaginated = 'Ads/GetAllAdsPaginated';
  static const String exportAds =
      'Ads/ExportAdsToCsv?pageNumber=1&pageSize=1000';
  static const String addAds = 'Ads/add-Ads';
  static const String updateAds = 'Ads/update-Ads';
  static const String notificationPreferences = 'Donor/preferences';
  static const String exportMassCampaigns =
      'Campaign/ExportToCsv?pageNumber=1&pageSize=1000';
  static const String allCampaignListPaginated =
      'Campaign/GetAllCampaignListPaginated';
  static const String exportRecipients =
      'Group/ExportToCsv?pageNumber=1&pageSize=1000';
  static const String allRecipientsListPaginated =
      'Group/GetAllRecipientsListPaginated';
  static const String addGroup = 'group/add-Group';
  static const String updateGroup = 'group/update-Group';
  static const String groupDetails = 'group/GetUsersByGroupId';
  static const String deleteGroup = 'group/delete-group';
  static const String deleteGroupRecipients = 'group/delete-groupdetail-list';
  static const String saveAsDraft = 'UserDraft/SaveAsDraft';
  static const String updateDraft = 'userDraft/UpdateUserDraftStatus';
  static const String associationNewsPaginated =
      'News/get-association-news-paginated';
  static const String exportAssociationNews =
      'News/ExportAllAssociationNewsToCsv/';
  static const String enableDisableSahemUser =
      'RoleAndPermission/ActiveDeactiveSahemUser';
  static const String contentRating = 'ContentRating/add-ContentRating';
  static const String taxCertificate = 'Payment/DownloadTaxCertificate';
  static const String enableDisableAssociation =
      'Association/ActiveDeactiveAssociation';
  static const String enableDisableProject = 'Project/ActiveDeactiveProject';
  static const String financialStatementBalance =
      'FinancialStatement/GetFinancialStatementBalance';
  static const String financialStatementByMonth =
      'FinancialStatement/GetMonthlyDonationsBreakdownByProject';
  static const String userDonations =
      'Payment/GetAllTransactionDetailByUserPaginated';
  static const String enableDisableFAQ = 'FAQ/ActiveDeactiveFAQ';
  static const String enableDisableNews = 'News/ActiveDeactiveNews';
  static const String enableDisableAds = 'Ads/ActiveDeactiveAds';
  static const String deleteAccount = 'Common/DeleteAccount';
  static const String approverGroups = 'ApproverGroup/GetAllApprovedGroupList';
  static const String enableDisableGroup =
      'ApproverGroup/update-Approve-Group-Status';
  static const String deleteApproverGroup =
      'ApproverGroup/delete-Approve-Group/';
  static const String exportMyRefunds =
      'Payment/ExportRefundDetailByUserToCsv?pageNumber=1&pageSize=10';
  static const String approverGroupEmployees = 'ApproverGroup/GetEmployeeById';
  static const String approverGroupDetails =
      'ApproverGroup/GetApprovedGroupById/';
  static const String addApproverGroup = 'ApproverGroup/add-Approve-Group';
  static const String updateApproverGroup =
      'ApproverGroup/update-Approve-Group/';
  static const String allWorkflows = 'Workflow/GetAllWorkflowsPaginated';
  static const String exportWorkflows = 'Workflow/ExportWorkflowsToCsv';
  static const String enableDisableWorkflow = 'Workflow/ActiveDeactiveWorkflow';
  static const String deleteWorkflow = 'Workflow/delete-Workflow/';
  static const String addWorkflow = 'Workflow/add-Workflow';
  static const String updateWorkflow = 'Workflow/update-Workflow/';
  static const String enableDisableCompany =
      'Association/ActiveDeactiveAccount';
  static const String associationFundRequests =
      'FundTransfer/GetFundRequestsByAssociationId';
  static const String allReminders = 'Donor/GetAllReminderList';
  static const String deleteReminder = 'donor/DeleteReminder/';
  static const String addDonationReminder = 'Donor/AddReminder';
  static const String updateDonationReminder = 'Donor/UpdateReminder/';
  static const String addGuestReminder = 'Donor/AddUpdateProjectAlertsGuest';
  static const String addUpdateProjectAlerts = 'Donor/AddUpdateProjectAlerts';
  static const String projectAlerts = 'Donor/GetProjectAlertsByUserId';
  static const String feedbackByUserIdPaginated =
      'Feedback/GetAllFeedbackByUserIdPaginated/';
  static const String exportUserFeedbacks =
      'Feedback/ExportFeedbackByUserAssCompIdToCsv?pageNumber=1&pageSize=1000';
  static const String exportMyRequest =
      'UserRequest/ExportMyRequestsToCsv?userId=';
  static const String moneyTransferred =
      'FinancialStatement/GetMoneyTransferred';
  static const String changePassword = 'User/change-password';
  static const String smtpConfig =
      'SystemConfiguration/GetSystemConfiguration/Email';
  static const String addSMTPConfig =
      'SystemConfiguration/AddSystemConfiguration/Email';
  static const String getContactUs =
      'SystemConfiguration/GetSystemConfiguration/Organization';
  static const String areaChartDonationDataAssociationDashboard =
      'AssociationDashboard/GetAreaChartDonationDataAssociationDashboard';
  static const String donorBarchartDetails =
      'AdminDashboard/AdminDashboardGetDonorDemographicsDDD';
  static const String donorsBreakdown =
      'AdminDashboard/AdminDashboardGetDonationBreakdownByTypeAODD';
  static const String donationDataMonthWiseAODD =
      'AdminDashboard/AdminDashboardGetDonationDataMonthWiseAODD';
  static const String adminDashboardGetHeaderDataFDD =
      'AdminDashboard/AdminDashboardGetHeaderDataFDD';
  static const String adminDashboardGetPendingCollectionDataFDD =
      'AdminDashboard/AdminDashboardGetPendingCollectionDataFDD';
  static const String adminDashboardGetDonationsWRTPaymentTypeFDD =
      'AdminDashboard/AdminDashboardGetDonationsWRTPaymentTypeFDD';
  static const String adminOperationsDashboardData =
      'AdminDashboard/AdminOperationsDashboardData';
  static const String adminDashboardGetHeaderDataUEIDD =
      'AdminDashboard/AdminDashboardGetHeaderDataUEIDD';
  static const String adminDashboardGetFeedbackItemUEIDD =
      'AdminDashboard/AdminDashboardGetFeedbackItemUEIDD';
  static const String adminDashboardGetSurveyItemUEIDD =
      'AdminDashboard/AdminDashboardGetSurveyItemUEIDD';
  static const String adminDashboardGetRatingPerContentUEIDD =
      'AdminDashboard/AdminDashboardGetRatingPerContentUEIDD';
  static const String adminDashboardGetRatingPerUserTypeUEIDD =
      'AdminDashboard/AdminDashboardGetRatingPerUserTypeUEIDD';
  static const String adminDashboardGGetListDataByContentTypeUEIDD =
      'AdminDashboard/AdminDashboardGGetListDataByContentTypeUEIDD';
  static const String adminDashboardGetPreferredLoginTimeListUEIDD =
      'AdminDashboard/AdminDashboardGetPreferredLoginTimeListUEIDD';
  static const String adminDashboardSLAGetHeaderData =
      'AdminDashboard/AdminDashboardSLAGetHeaderData';
  static const String adminDashboardGetSLADetailsPerWorkflowType =
      'AdminDashboard/AdminDashboardGetSLADetailsPerWorkflowType';
  static const String adminDashboardGetSLADetailsPerWorkflowApproverGroup =
      'AdminDashboard/AdminDashboardGetSLADetailsPerWorkflowApproverGroup';
  static const String adminDashboardGetSLADetailsPerWorkflowLevel =
      'AdminDashboard/AdminDashboardGetSLADetailsPerWorkflowLevel';
  static const String exportMyCompanies =
      'Company/export-my-company-list?pageNumber=1&pageSize=1000&userId=';
  static const String exportMyAssociations =
      'Association/export-my-association-list?pageNumber=1&pageSize=10&id=';
  static const String sahemEmployees = 'RoleAndPermission/GetAllSahemUserList';
  static const String updateDonorProfile = 'Donor/donor-profile-update';
  static const String biometricAuth = 'Auth/AppleLogin';
  static const String deletePlatformDocument = 'Document/delete-document';
  static const String exportAuditLogs =
      'AuditLog/ExportAuditLogsToCsv?pageNumber=';
  static const String exportEmployees = 'Employee/ExportToCsv?pageNumber=';
  static const String exportAssociationProjects =
      'Association/ExportAssociationProjects/';
  static const String exportAllProjects = 'Project/ExportProjectsToCSV';
  static const String aboutSahem =
      'SystemConfiguration/GetSystemConfiguration/AboutSahem';
  static const String auditLogByEntityId = 'AuditLog/GetAuditLogByEntityId';
  static const String exportAllDonations =
      'Payment/ExportTransactionDetailByUserToCsv?pageNumber=';
  static const String exportDonorDonations =
      'Payment/ExportTransactionDetailByUserToCsv?pageNumber=';
  static const String exportAdminEmployees =
      'RoleAndPermission/ExportToCsv?pageNumber=';
  static const String exportApproverGroups =
      'ApproverGroup/ExportApproverGroupsToCsv';
  static const String generateOTPForUser = 'Register/GenerateOTPForUser';
  // static const String createDubaiPay= 'api/DubaiPayIntegration/create-payment';
  static const String createDubaiPay = 'DubaiPayIntegration/create-payment';
  static const String payDetails = 'Payment/detail-by-session';
  static const String addDpGuestUser = 'User/add-guest-user';
  static const String getExpirySoonProjects = 'Project/getExpirySoonProjects';
  static const String mobileDashboardStats =
      'AdminDashboard/MobileDashboardStats';
  static const String sendSmsEmailMobileApp = 'DubaiPayIntegration/sendSmsEmailMobileApp';
}
