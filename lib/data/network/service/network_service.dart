import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

abstract class NetworkService {
  Future<ApiResponse> registerUser({required RequestBody request});

  Future<ApiResponse> validateOTP({required RequestBody request});

  Future<ApiResponse> sendOTP({required RequestBody request});

  Future<ApiResponse> forgotPassword({required RequestBody request});

  Future<ApiResponse> logIn({required RequestBody request});

  Future<ApiResponse> uploadFile({required RequestBody request});

  Future<ApiResponse> fetchLookUpData({required RequestBody request});

  Future<ApiResponse> saveIndividualAccountInfo({required RequestBody request});

  Future<ApiResponse> saveIndividualContactInfo({required RequestBody request});

  Future<ApiResponse> saveIndividualPreferences({required RequestBody request});

  Future<ApiResponse> fetchIndividualProfile({required RequestBody request});

  Future<ApiResponse> fetchCompanyProfile({required RequestBody request});

  Future<ApiResponse> saveCompanyInfo({required RequestBody request});

  Future<ApiResponse> saveCompanyInfoPutRequest({required RequestBody request});

  Future<ApiResponse> saveCompanyContactInfo({required RequestBody request});

  Future<ApiResponse> saveCompanyRepresentativeInfo(
      {required RequestBody request});

  Future<ApiResponse> saveCompanyBankAccount({required RequestBody request});

  Future<ApiResponse> fetchAssociationProfile({required RequestBody request});

  Future<ApiResponse> saveAssociationInfo({required RequestBody request});

  Future<ApiResponse> saveAssociationInfoPutRequest(
      {required RequestBody request});

  Future<ApiResponse> saveAssociationContactInfo(
      {required RequestBody request});

  Future<ApiResponse> saveAssociationRepresentativeInfo(
      {required RequestBody request});

  Future<ApiResponse> saveAssociationBankAccount(
      {required RequestBody request});

  Future<ApiResponse> fetchAssociationProjects({required RequestBody request});

  Future<ApiResponse> fetchAllProjects({required RequestBody request});

  Future<ApiResponse> createProject({required RequestBody request});

  Future<ApiResponse> createProjectPutRequest({required RequestBody request});

  Future<ApiResponse> fetchProjects({required RequestBody request});

  Future<ApiResponse> fetchAssociations({required RequestBody request});

  Future<ApiResponse> fetchCart({required RequestBody request});

  Future<ApiResponse> addToCart({required RequestBody request});

  Future<ApiResponse> deleteCartProduct({required RequestBody request});

  Future<ApiResponse> deleteAllCart({required RequestBody request});

  Future<ApiResponse> updateCartItem({required RequestBody request});

  Future<ApiResponse> updateUserCart({required RequestBody request});

  Future<ApiResponse> socialRegister({required RequestBody request});

  Future<ApiResponse> appleInfo({required RequestBody request});

  Future<ApiResponse> uaeIdExist({required RequestBody request});

  Future<ApiResponse> saveUaeUser({required RequestBody request});

  Future<ApiResponse> fetchFAQCategories({required RequestBody request});

  Future<ApiResponse> fetchFAQsByCategory({required RequestBody request});

  Future<ApiResponse> fetchAllServices({required RequestBody request});

  Future<ApiResponse> latestNews({required RequestBody request});

  Future<ApiResponse> featuredProject({required RequestBody request});

  Future<ApiResponse> staticPages({required RequestBody request});

  Future<ApiResponse> allEmployees({required RequestBody request});

  Future<ApiResponse> disableEmployee({required RequestBody request});

  Future<ApiResponse> addEmployee({required RequestBody request});

  Future<ApiResponse> updateEmployee({required RequestBody request});

  Future<ApiResponse> deleteEmployee({required RequestBody request});

  Future<ApiResponse> favoriteProject({required RequestBody request});

  Future<ApiResponse> userProjects({required RequestBody request});

  Future<ApiResponse> projectDetails({required RequestBody request});

  Future<ApiResponse> favoriteProjects({required RequestBody request});

  Future<ApiResponse> addFavoriteNews({required RequestBody request});

  Future<ApiResponse> newsDetails({required RequestBody request});

  Future<ApiResponse> favouriteNews({required RequestBody request});

  Future<ApiResponse> addFavoriteService({required RequestBody request});

  Future<ApiResponse> favouriteServices({required RequestBody request});

  Future<ApiResponse> associationNews({required RequestBody request});

  Future<ApiResponse> associationAboutUs({required RequestBody request});

  Future<ApiResponse> sendContactUs({required RequestBody request});

  Future<ApiResponse> userNotifications({required RequestBody request});

  Future<ApiResponse> readNotification({required RequestBody request});

  Future<ApiResponse> deleteNotification({required RequestBody request});

  Future<ApiResponse> addDevice({required RequestBody request});

  Future<ApiResponse> verifyEmail({required RequestBody request});

  Future<ApiResponse> verifyPhone({required RequestBody request});

  Future<ApiResponse> fetchFeedbacks({required RequestBody request});

  Future<ApiResponse> submitFeedback({required RequestBody request});

  Future<ApiResponse> deleteFeedback({required RequestBody request});

  Future<ApiResponse> feedbackDetails({required RequestBody request});

  Future<ApiResponse> fetchRequests({required RequestBody request});

  Future<ApiResponse> adDetails({required RequestBody request});

  Future<ApiResponse> staticPageDetails({required RequestBody request});

  Future<ApiResponse> aboutAssociation({required RequestBody request});

  Future<ApiResponse> serviceDetails({required RequestBody request});

  Future<ApiResponse> updateFeedbackStatus({required RequestBody request});

  Future<ApiResponse> updateAboutStatus({required RequestBody request});

  Future<ApiResponse> requestApproval({required RequestBody request});

  Future<ApiResponse> transactions({required RequestBody request});

  Future<ApiResponse> transactionDetails({required RequestBody request});

  Future<ApiResponse> addQuickProjects({required RequestBody request});

  Future<ApiResponse> campaignDetails({required RequestBody request});

  Future<ApiResponse> recipients({required RequestBody request});

  Future<ApiResponse> surveyDetails({required RequestBody request});

  Future<ApiResponse> refundRequestDetails({required RequestBody request});

  Future<ApiResponse> offlinePayment({required RequestBody request});

  Future<ApiResponse> refundRequest({required RequestBody request});

  Future<ApiResponse> faqDetails({required RequestBody request});

  Future<ApiResponse> allAssociations({required RequestBody request});

  Future<ApiResponse> allCompanies({required RequestBody request});

  Future<ApiResponse> myAssociations({required RequestBody request});

  Future<ApiResponse> myCompanies({required RequestBody request});

  Future<ApiResponse> allDonors({required RequestBody request});

  Future<ApiResponse> assignFeedback({required RequestBody request});

  Future<ApiResponse> submitFeedbackResponse({required RequestBody request});

  Future<ApiResponse> latestDonation({required RequestBody request});
  Future<ApiResponse> mobileDashboardStats({required RequestBody request});

  Future<ApiResponse> expirySoonProjects({required RequestBody request});

  Future<ApiResponse> refundHistory({required RequestBody request});

  Future<ApiResponse> superEmployees({required RequestBody request});

  Future<ApiResponse> superAgents({required RequestBody request});

  Future<ApiResponse> donationHistory({required RequestBody request});

  Future<ApiResponse> donorDashboardData({required RequestBody request});

  Future<ApiResponse> assignTask({required RequestBody request});

  Future<ApiResponse> myTasks({required RequestBody request});

  Future<ApiResponse> associationDashboardData({required RequestBody request});

  Future<ApiResponse> associationAverageSummary({required RequestBody request});

  Future<ApiResponse> associationProjectsData({required RequestBody request});

  Future<ApiResponse> rejectTask({required RequestBody request});

  Future<ApiResponse> taskDetailsByCode({required RequestBody request});

  Future<ApiResponse> taskCollection({required RequestBody request});

  Future<ApiResponse> donorPercentage({required RequestBody request});

  Future<ApiResponse> taskDetails({required RequestBody request});

  Future<ApiResponse> donorHeaderData({required RequestBody request});

  Future<ApiResponse> donorDemographics({required RequestBody request});

  Future<ApiResponse> topDonors({required RequestBody request});

  Future<ApiResponse> headerDataCPDD({required RequestBody request});

  Future<ApiResponse> topPerformingProjectsCPDD({required RequestBody request});

  Future<ApiResponse> campaignFundingGapCPDD({required RequestBody request});

  Future<ApiResponse> projectsReachingEndCPDD({required RequestBody request});

  Future<ApiResponse> donationBreakdownByProjectAODD(
      {required RequestBody request});

  Future<ApiResponse> top5ProjectsAODD({required RequestBody request});

  Future<ApiResponse> top5AssociationsAODD({required RequestBody request});

  Future<ApiResponse> donorAverageAODD({required RequestBody request});

  Future<ApiResponse> donorPercentageAODD({required RequestBody request});

  Future<ApiResponse> walletBalance({required RequestBody request});

  Future<ApiResponse> payViaWallet({required RequestBody request});

  Future<ApiResponse> acceptAssociationRequest({required RequestBody request});

  Future<ApiResponse> myRefunds({required RequestBody request});

  Future<ApiResponse> myWallet({required RequestBody request});

  Future<ApiResponse> adsList({required RequestBody request});

  Future<ApiResponse> taskCollectionDetails({required RequestBody request});

  Future<ApiResponse> authenticateTaskRequest({required RequestBody request});

  Future<ApiResponse> publicDocuments({required RequestBody request});

  Future<ApiResponse> userDocuments({required RequestBody request});

  Future<ApiResponse> platformDocuments({required RequestBody request});

  Future<ApiResponse> updateDocumentStatus({required RequestBody request});

  Future<ApiResponse> savePlatformDocument({required RequestBody request});

  Future<ApiResponse> uploadPublicDocument({required RequestBody request});

  Future<ApiResponse> updatePlatformDocument({required RequestBody request});

  Future<ApiResponse> archiveNews({required RequestBody request});

  Future<ApiResponse> publicDocumentStatus({required RequestBody request});

  Future<ApiResponse> associationProjectsPaginated(
      {required RequestBody request});

  Future<ApiResponse> submitFundTransferRequest({required RequestBody request});

  Future<ApiResponse> auditLog({required RequestBody request});

  Future<ApiResponse> fundRequest({required RequestBody request});

  Future<ApiResponse> sahemBank({required RequestBody request});

  Future<ApiResponse> fundTransferDetail({required RequestBody request});

  Future<ApiResponse> deleteFAQ({required RequestBody request});

  Future<ApiResponse> addFAQ({required RequestBody request});

  Future<ApiResponse> updateFAQ({required RequestBody request});

  Future<ApiResponse> faqPaginated({required RequestBody request});

  Future<ApiResponse> additionalDocuments({required RequestBody request});

  Future<ApiResponse> associationsList({required RequestBody request});

  Future<ApiResponse> projectListPaginated({required RequestBody request});

  Future<ApiResponse> saveAdditionalDocuments({required RequestBody request});

  Future<ApiResponse> allUserRequests({required RequestBody request});

  Future<ApiResponse> allNewsPaginated({required RequestBody request});

  Future<ApiResponse> addNews({required RequestBody request});

  Future<ApiResponse> updateNews({required RequestBody request});

  Future<ApiResponse> cmsAssociationNews({required RequestBody request});

  Future<ApiResponse> addAboutUs({required RequestBody request});

  Future<ApiResponse> updateAboutUs({required RequestBody request});

  Future<ApiResponse> notificationDetails({required RequestBody request});

  Future<ApiResponse> addAssociation({required RequestBody request});

  Future<ApiResponse> updateAssociation({required RequestBody request});

  Future<ApiResponse> allFeedbacksPaginated({required RequestBody request});

  Future<ApiResponse> auditLogsById({required RequestBody request});

  Future<ApiResponse> cmsNotifications({required RequestBody request});

  Future<ApiResponse> saveNotification({required RequestBody request});

  Future<ApiResponse> updateNotification({required RequestBody request});

  Future<ApiResponse> addCompany({required RequestBody request});

  Future<ApiResponse> updateCompany({required RequestBody request});

  Future<ApiResponse> cmsServices({required RequestBody request});

  Future<ApiResponse> activeDeActiveService({required RequestBody request});

  Future<ApiResponse> userPermissions({required RequestBody request});

  Future<ApiResponse> addService({required RequestBody request});

  Future<ApiResponse> updateService({required RequestBody request});

  Future<ApiResponse> fundTransferQueue({required RequestBody request});

  Future<ApiResponse> globalSearch({required RequestBody request});

  Future<ApiResponse> allAdsPaginated({required RequestBody request});

  Future<ApiResponse> addAds({required RequestBody request});

  Future<ApiResponse> updateAds({required RequestBody request});

  Future<ApiResponse> notificationPreferences({required RequestBody request});

  Future<ApiResponse> allCampaignListPaginated({required RequestBody request});

  Future<ApiResponse> allRecipientsListPaginated(
      {required RequestBody request});

  Future<ApiResponse> addGroup({required RequestBody request});

  Future<ApiResponse> updateGroup({required RequestBody request});

  Future<ApiResponse> groupDetails({required RequestBody request});

  Future<ApiResponse> deleteGroup({required RequestBody request});

  Future<ApiResponse> deleteGroupRecipients({required RequestBody request});

  Future<ApiResponse> associationAllProjectsPaginated(
      {required RequestBody request});

  Future<ApiResponse> saveAsDraft({required RequestBody request});

  Future<ApiResponse> updateDraft({required RequestBody request});

  Future<ApiResponse> associationNewsPaginated({required RequestBody request});

  Future<ApiResponse> contentRating({required RequestBody request});

  Future<ApiResponse> downloadTaxCertificate({required RequestBody request});

  Future<ApiResponse> enableDisableAssociation({required RequestBody request});

  Future<ApiResponse> enableDisableProject({required RequestBody request});

  Future<ApiResponse> financialStatementBalance({required RequestBody request});

  Future<ApiResponse> financialStatementByMonth({required RequestBody request});

  Future<ApiResponse> userDonations({required RequestBody request});

  Future<ApiResponse> enableDisableFAQ({required RequestBody request});

  Future<ApiResponse> enableDisableNews({required RequestBody request});

  Future<ApiResponse> enableDisableAds({required RequestBody request});

  Future<ApiResponse> deleteAccount({required RequestBody request});

  Future<ApiResponse> approverGroups({required RequestBody request});

  Future<ApiResponse> enableDisableGroup({required RequestBody request});

  Future<ApiResponse> deleteApproverGroup({required RequestBody request});

  Future<ApiResponse> approverGroupEmployees({required RequestBody request});

  Future<ApiResponse> approverGroupDetails({required RequestBody request});

  Future<ApiResponse> addApproverGroup({required RequestBody request});

  Future<ApiResponse> updateApproverGroup({required RequestBody request});

  Future<ApiResponse> allWorkflows({required RequestBody request});

  Future<ApiResponse> enableDisableWorkflow({required RequestBody request});

  Future<ApiResponse> deleteWorkflow({required RequestBody request});

  Future<ApiResponse> addWorkflow({required RequestBody request});

  Future<ApiResponse> updateWorkflow({required RequestBody request});

  Future<ApiResponse> enableDisableCompany({required RequestBody request});

  Future<ApiResponse> associationFundRequests({required RequestBody request});

  Future<ApiResponse> allReminders({required RequestBody request});

  Future<ApiResponse> deleteReminder({required RequestBody request});

  Future<ApiResponse> addDonationReminder({required RequestBody request});

  Future<ApiResponse> updateDonationReminder({required RequestBody request});

  Future<ApiResponse> addGuestReminder({required RequestBody request});

  Future<ApiResponse> addUpdateProjectAlerts({required RequestBody request});

  Future<ApiResponse> projectAlerts({required RequestBody request});

  Future<ApiResponse> feedbackByUserIdPaginated({required RequestBody request});

  Future<ApiResponse> moneyTransferred({required RequestBody request});

  Future<ApiResponse> changePassword({required RequestBody request});

  Future<ApiResponse> smtpConfig({required RequestBody request});

  Future<ApiResponse> addSMTPConfig({required RequestBody request});

  Future<ApiResponse> getContactUs({required RequestBody request});

  Future<ApiResponse> areaChartDonationDataAssociationDashboard(
      {required RequestBody request});

  Future<ApiResponse> donorBarchartDetails({required RequestBody request});

  Future<ApiResponse> donorsBreakdown({required RequestBody request});

  Future<ApiResponse> donationDataMonthWiseAODD({required RequestBody request});

  Future<ApiResponse> adminDashboardGetHeaderDataFDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetPendingCollectionDataFDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetDonationsWRTPaymentTypeFDD(
      {required RequestBody request});

  Future<ApiResponse> adminOperationsDashboardData(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetHeaderDataUEIDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetFeedbackItemUEIDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetSurveyItemUEIDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetRatingPerContentUEIDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetRatingPerUserTypeUEIDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGGetListDataByContentTypeUEIDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetPreferredLoginTimeListUEIDD(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardSLAGetHeaderData(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowType(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowApproverGroup(
      {required RequestBody request});

  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowLevel(
      {required RequestBody request});

  Future<ApiResponse> sahemEmployees(
      {required RequestBody request});

  Future<ApiResponse> updateDonorProfile(
      {required RequestBody request});

  Future<ApiResponse> biometricAuth(
      {required RequestBody request});

  Future<ApiResponse> deletePlatformDocument(
      {required RequestBody request});

  Future<ApiResponse> deletePublicDocument(
      {required RequestBody request});

  Future<ApiResponse> aboutSahem(
      {required RequestBody request});

  Future<ApiResponse> auditLogByEntityId(
      {required RequestBody request});

  Future<ApiResponse> generateOTPForUser(
      {required RequestBody request});

  Future<ApiResponse> createDubaiPayment(
      {required RequestBody request});

  Future<ApiResponse> adduestUserDP(
      {required RequestBody request});

  Future<ApiResponse> sendSmsEmailMobileApp(
      {required RequestBody request});

}
