import 'package:zakat_fund/data/network/service/network_service.dart';
import 'package:zakat_fund/data/network/service/network_service_impl.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';

class RemoteRepo {
  final NetworkService _service = NetworkServiceImpl();

  Future<ApiResponse> registerUser({required RequestBody request}) async {
    final response = await _service.registerUser(request: request);
    return response;
  }

  Future<ApiResponse> sendOTP({required RequestBody request}) async {
    final response = await _service.sendOTP(request: request);
    return response;
  }

  Future<ApiResponse> validateOTP({required RequestBody request}) async {
    final response = await _service.validateOTP(request: request);
    return response;
  }

  Future<ApiResponse> forgotPassword({required RequestBody request}) async {
    final response = await _service.forgotPassword(request: request);
    return response;
  }

  Future<ApiResponse> logIn({required RequestBody request}) async {
    final response = await _service.logIn(request: request);
    return response;
  }

  Future<ApiResponse> uploadFile({required RequestBody request}) async {
    final response = await _service.uploadFile(request: request);
    return response;
  }

  Future<ApiResponse> fetchLookUpData({required RequestBody request}) async {
    final response = await _service.fetchLookUpData(request: request);
    return response;
  }

  Future<ApiResponse> fetchIndividualProfile(
      {required RequestBody request}) async {
    final response = await _service.fetchIndividualProfile(request: request);
    return response;
  }

  Future<ApiResponse> saveIndividualAccountInfo(
      {required RequestBody request}) async {
    final response = await _service.saveIndividualAccountInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveIndividualContactInfo(
      {required RequestBody request}) async {
    final response = await _service.saveIndividualContactInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveIndividualPreferences(
      {required RequestBody request}) async {
    final response = await _service.saveIndividualPreferences(request: request);
    return response;
  }

  Future<ApiResponse> fetchCompanyProfile(
      {required RequestBody request}) async {
    final response = await _service.fetchCompanyProfile(request: request);
    return response;
  }

  Future<ApiResponse> saveCompanyInfo({required RequestBody request}) async {
    final response = await _service.saveCompanyInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveCompanyInfoPut({required RequestBody request}) async {
    final response = await _service.saveCompanyInfoPutRequest(request: request);
    return response;
  }

  Future<ApiResponse> saveCompanyContactInfo(
      {required RequestBody request}) async {
    final response = await _service.saveCompanyContactInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveCompanyRepresentativeInfo(
      {required RequestBody request}) async {
    final response =
        await _service.saveCompanyRepresentativeInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveCompanyBankAccount(
      {required RequestBody request}) async {
    final response = await _service.saveCompanyBankAccount(request: request);
    return response;
  }

  Future<ApiResponse> fetchAssociationProfile(
      {required RequestBody request}) async {
    final response = await _service.fetchAssociationProfile(request: request);
    return response;
  }

  Future<ApiResponse> saveAssociationInfo(
      {required RequestBody request}) async {
    final response = await _service.saveAssociationInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveAssociationInfoPut(
      {required RequestBody request}) async {
    final response =
        await _service.saveAssociationInfoPutRequest(request: request);
    return response;
  }

  Future<ApiResponse> saveAssociationContactInfo(
      {required RequestBody request}) async {
    final response =
        await _service.saveAssociationContactInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveAssociationRepresentativeInfo(
      {required RequestBody request}) async {
    final response =
        await _service.saveAssociationRepresentativeInfo(request: request);
    return response;
  }

  Future<ApiResponse> saveAssociationBankAccount(
      {required RequestBody request}) async {
    final response =
        await _service.saveAssociationBankAccount(request: request);
    return response;
  }

  Future<ApiResponse> fetchAssociationProjects(
      {required RequestBody request}) async {
    final response = await _service.fetchAssociationProjects(request: request);
    return response;
  }

  Future<ApiResponse> createProject({required RequestBody request}) async {
    final response = await _service.createProject(request: request);
    return response;
  }

  Future<ApiResponse> createProjectPutRequest(
      {required RequestBody request}) async {
    final response = await _service.createProjectPutRequest(request: request);
    return response;
  }

  Future<ApiResponse> fetchProjects({required RequestBody request}) async {
    final response = await _service.fetchProjects(request: request);
    return response;
  }

  Future<ApiResponse> fetchAssociations({required RequestBody request}) async {
    final response = await _service.fetchAssociations(request: request);
    return response;
  }

  Future<ApiResponse> fetchCart({required RequestBody request}) async {
    final response = await _service.fetchCart(request: request);
    return response;
  }

  Future<ApiResponse> addToCart({required RequestBody request}) async {
    final response = await _service.addToCart(request: request);
    return response;
  }

  Future<ApiResponse> deleteAllCart({required RequestBody request}) async {
    final response = await _service.deleteAllCart(request: request);
    return response;
  }

  Future<ApiResponse> deleteCartProduct({required RequestBody request}) async {
    final response = await _service.deleteCartProduct(request: request);
    return response;
  }

  Future<ApiResponse> updateCartItem({required RequestBody request}) async {
    final response = await _service.updateCartItem(request: request);
    return response;
  }

  Future<ApiResponse> updateUserCart({required RequestBody request}) async {
    final response = await _service.updateUserCart(request: request);
    return response;
  }

  Future<ApiResponse> socialRegister({required RequestBody request}) async {
    final response = await _service.socialRegister(request: request);
    return response;
  }

  Future<ApiResponse> appleInfo({required RequestBody request}) async {
    final response = await _service.appleInfo(request: request);
    return response;
  }

  Future<ApiResponse> uaeIdExist({required RequestBody request}) async {
    final response = await _service.uaeIdExist(request: request);
    return response;
  }

  Future<ApiResponse> saveUaeUser({required RequestBody request}) async {
    final response = await _service.saveUaeUser(request: request);
    return response;
  }

  Future<ApiResponse> fetchFAQCategories({required RequestBody request}) async {
    final response = await _service.fetchFAQCategories(request: request);
    return response;
  }

  Future<ApiResponse> fetchFAQsByCategory({required RequestBody request}) async {
    final response = await _service.fetchFAQsByCategory(request: request);
    return response;
  }

  Future<ApiResponse> fetchAllServices({required RequestBody request}) async {
    final response = await _service.fetchAllServices(request: request);
    return response;
  }

  Future<ApiResponse> latestNews({required RequestBody request}) async {
    final response = await _service.latestNews(request: request);
    return response;
  }

  Future<ApiResponse> featuredProject({required RequestBody request}) async {
    final response = await _service.featuredProject(request: request);
    return response;
  }

  Future<ApiResponse> staticPages({required RequestBody request}) async {
    final response = await _service.staticPages(request: request);
    return response;
  }

  Future<ApiResponse> allEmployees({required RequestBody request}) async {
    final response = await _service.allEmployees(request: request);
    return response;
  }

  Future<ApiResponse> disableEmployee({required RequestBody request}) async {
    final response = await _service.disableEmployee(request: request);
    return response;
  }

  Future<ApiResponse> addEmployee({required RequestBody request}) async {
    final response = await _service.addEmployee(request: request);
    return response;
  }

  Future<ApiResponse> updateEmployee({required RequestBody request}) async {
    final response = await _service.updateEmployee(request: request);
    return response;
  }

  Future<ApiResponse> deleteEmployee({required RequestBody request}) async {
    final response = await _service.deleteEmployee(request: request);
    return response;
  }

  Future<ApiResponse> favoriteProject({required RequestBody request}) async {
    final response = await _service.favoriteProject(request: request);
    return response;
  }

  Future<ApiResponse> userProjects({required RequestBody request}) async {
    final response = await _service.userProjects(request: request);
    return response;
  }

  Future<ApiResponse> projectDetails({required RequestBody request}) async {
    final response = await _service.projectDetails(request: request);
    return response;
  }

  Future<ApiResponse> favoriteProjects({required RequestBody request}) async {
    final response = await _service.favoriteProjects(request: request);
    return response;
  }

  Future<ApiResponse> addFavoriteNews({required RequestBody request}) async {
    final response = await _service.addFavoriteNews(request: request);
    return response;
  }

  Future<ApiResponse> newsDetails({required RequestBody request}) async {
    final response = await _service.newsDetails(request: request);
    return response;
  }

  Future<ApiResponse> favouriteNews({required RequestBody request}) async {
    final response = await _service.favouriteNews(request: request);
    return response;
  }

  Future<ApiResponse> addFavoriteService({required RequestBody request}) async {
    final response = await _service.addFavoriteService(request: request);
    return response;
  }

  Future<ApiResponse> favouriteServices({required RequestBody request}) async {
    final response = await _service.favouriteServices(request: request);
    return response;
  }

  Future<ApiResponse> associationNews({required RequestBody request}) async {
    final response = await _service.associationNews(request: request);
    return response;
  }

  Future<ApiResponse> associationAboutUs({required RequestBody request}) async {
    final response = await _service.associationAboutUs(request: request);
    return response;
  }


  Future<ApiResponse> sendContactUs({required RequestBody request}) async {
    final response = await _service.sendContactUs(request: request);
    return response;
  }

  Future<ApiResponse> userNotifications({required RequestBody request}) async {
    final response = await _service.userNotifications(request: request);
    return response;
  }

  Future<ApiResponse> readNotification({required RequestBody request}) async {
    final response = await _service.readNotification(request: request);
    return response;
  }

  Future<ApiResponse> deleteNotification({required RequestBody request}) async {
    final response = await _service.deleteNotification(request: request);
    return response;
  }

  Future<ApiResponse> addDevice({required RequestBody request}) async {
    final response = await _service.addDevice(request: request);
    return response;
  }

  Future<ApiResponse> verifyEmail({required RequestBody request}) async {
    final response = await _service.verifyEmail(request: request);
    return response;
  }

  Future<ApiResponse> verifyPhone({required RequestBody request}) async {
    final response = await _service.verifyPhone(request: request);
    return response;
  }

  Future<ApiResponse> fetchFeedbacks({required RequestBody request}) async {
    final response = await _service.fetchFeedbacks(request: request);
    return response;
  }

  Future<ApiResponse> submitFeedback({required RequestBody request}) async {
    final response = await _service.submitFeedback(request: request);
    return response;
  }

  Future<ApiResponse> deleteFeedback({required RequestBody request}) async {
    final response = await _service.deleteFeedback(request: request);
    return response;
  }

  Future<ApiResponse> feedbackDetails({required RequestBody request}) async {
    final response = await _service.feedbackDetails(request: request);
    return response;
  }

  Future<ApiResponse> fetchRequests({required RequestBody request}) async {
    final response = await _service.fetchRequests(request: request);
    return response;
  }

  Future<ApiResponse> adDetails({required RequestBody request}) async {
    final response = await _service.adDetails(request: request);
    return response;
  }

  Future<ApiResponse> staticPageDetails({required RequestBody request}) async {
    final response = await _service.staticPageDetails(request: request);
    return response;
  }

  Future<ApiResponse> fetchStaticPages({required RequestBody request}) async {
    final response = await _service.fetchStaticPages(request: request);
    return response;
  }

  Future<ApiResponse> aboutAssociation({required RequestBody request}) async {
    final response = await _service.aboutAssociation(request: request);
    return response;
  }

  Future<ApiResponse> serviceDetails({required RequestBody request}) async {
    final response = await _service.serviceDetails(request: request);
    return response;
  }

  Future<ApiResponse> updateFeedbackStatus({required RequestBody request}) async {
    final response = await _service.updateFeedbackStatus(request: request);
    return response;
  }

  Future<ApiResponse> updateAboutStatus({required RequestBody request}) async {
    final response = await _service.updateAboutStatus(request: request);
    return response;
  }

  Future<ApiResponse> requestApproval({required RequestBody request}) async {
    final response = await _service.requestApproval(request: request);
    return response;
  }

  Future<ApiResponse> transactions({required RequestBody request}) async {
    final response = await _service.transactions(request: request);
    return response;
  }

  Future<ApiResponse> transactionDetails({required RequestBody request}) async {
    final response = await _service.transactionDetails(request: request);
    return response;
  }

  Future<ApiResponse> addQuickProjects({required RequestBody request}) async {
    final response = await _service.addQuickProjects(request: request);
    return response;
  }

  Future<ApiResponse> campaignDetails({required RequestBody request}) async {
    final response = await _service.campaignDetails(request: request);
    return response;
  }

  Future<ApiResponse> recipients({required RequestBody request}) async {
    final response = await _service.recipients(request: request);
    return response;
  }

  Future<ApiResponse> surveyDetails({required RequestBody request}) async {
    final response = await _service.surveyDetails(request: request);
    return response;
  }

  Future<ApiResponse> refundRequestDetails({required RequestBody request}) async {
    final response = await _service.refundRequestDetails(request: request);
    return response;
  }

  Future<ApiResponse> offlinePayment({required RequestBody request}) async {
    final response = await _service.offlinePayment(request: request);
    return response;
  }

  Future<ApiResponse> fetchAllProjects({required RequestBody request}) async {
    final response = await _service.fetchAllProjects(request: request);
    return response;
  }

  Future<ApiResponse> refundRequest({required RequestBody request}) async {
    final response = await _service.refundRequest(request: request);
    return response;
  }

  Future<ApiResponse> faqDetails({required RequestBody request}) async {
    final response = await _service.faqDetails(request: request);
    return response;
  }

  Future<ApiResponse> allAssociations({required RequestBody request}) async {
    final response = await _service.allAssociations(request: request);
    return response;
  }

  Future<ApiResponse> allCompanies({required RequestBody request}) async {
    final response = await _service.allCompanies(request: request);
    return response;
  }

  Future<ApiResponse> myAllAssociations({required RequestBody request}) async {
    final response = await _service.myAssociations(request: request);
    return response;
  }

  Future<ApiResponse> myAllCompanies({required RequestBody request}) async {
    final response = await _service.myCompanies(request: request);
    return response;
  }

  Future<ApiResponse> allDonors({required RequestBody request}) async {
    final response = await _service.allDonors(request: request);
    return response;
  }

  Future<ApiResponse> assignFeedback({required RequestBody request}) async {
    final response = await _service.assignFeedback(request: request);
    return response;
  }

  Future<ApiResponse> submitFeedbackResponse({required RequestBody request}) async {
    final response = await _service.submitFeedbackResponse(request: request);
    return response;
  }

  Future<ApiResponse> latestDonation({required RequestBody request}) async {
    final response = await _service.latestDonation(request: request);
    return response;
  }

  Future<ApiResponse> mobileDashboardStats({required RequestBody request}) async {
    final response = await _service.mobileDashboardStats(request: request);
    return response;
  }

  Future<ApiResponse> expirySoonProjects({required RequestBody request}) async {
    final response = await _service.expirySoonProjects(request: request);
    return response;
  }

  Future<ApiResponse> refundHistory({required RequestBody request}) async {
    final response = await _service.refundHistory(request: request);
    return response;
  }

  Future<ApiResponse> superEmployees({required RequestBody request}) async {
    final response = await _service.superEmployees(request: request);
    return response;
  }

  Future<ApiResponse> superAgents({required RequestBody request}) async {
    final response = await _service.superAgents(request: request);
    return response;
  }

  Future<ApiResponse> donationHistory({required RequestBody request}) async {
    final response = await _service.donationHistory(request: request);
    return response;
  }

  Future<ApiResponse> donorDashboardData({required RequestBody request}) async {
    final response = await _service.donorDashboardData(request: request);
    return response;
  }

  Future<ApiResponse> assignTask({required RequestBody request}) async {
    final response = await _service.assignTask(request: request);
    return response;
  }

  Future<ApiResponse> myTasks({required RequestBody request}) async {
    final response = await _service.myTasks(request: request);
    return response;
  }

  Future<ApiResponse> associationDashboardData({required RequestBody request}) async {
    final response = await _service.associationDashboardData(request: request);
    return response;
  }

  Future<ApiResponse> associationAverageSummary({required RequestBody request}) async {
    final response = await _service.associationAverageSummary(request: request);
    return response;
  }

  Future<ApiResponse> associationProjectsData({required RequestBody request}) async {
    final response = await _service.associationProjectsData(request: request);
    return response;
  }

  Future<ApiResponse> rejectTask({required RequestBody request}) async {
    final response = await _service.rejectTask(request: request);
    return response;
  }

  Future<ApiResponse> taskDetailsByCode({required RequestBody request}) async {
    final response = await _service.taskDetailsByCode(request: request);
    return response;
  }

  Future<ApiResponse> taskCollection({required RequestBody request}) async {
    final response = await _service.taskCollection(request: request);
    return response;
  }

  Future<ApiResponse> donorPercentage({required RequestBody request}) async {
    final response = await _service.donorPercentage(request: request);
    return response;
  }

  Future<ApiResponse> taskDetails({required RequestBody request}) async {
    final response = await _service.taskDetails(request: request);
    return response;
  }

  Future<ApiResponse> donorHeaderData({required RequestBody request}) async {
    final response = await _service.donorHeaderData(request: request);
    return response;
  }

  Future<ApiResponse> donorDemographics({required RequestBody request}) async {
    final response = await _service.donorDemographics(request: request);
    return response;
  }

  Future<ApiResponse> topDonors({required RequestBody request}) async {
    final response = await _service.topDonors(request: request);
    return response;
  }

  Future<ApiResponse> headerDataCPDD({required RequestBody request}) async {
    final response = await _service.headerDataCPDD(request: request);
    return response;
  }

  Future<ApiResponse> topPerformingProjectsCPDD({required RequestBody request}) async {
    final response = await _service.topPerformingProjectsCPDD(request: request);
    return response;
  }

  Future<ApiResponse> campaignFundingGapCPDD({required RequestBody request}) async {
    final response = await _service.campaignFundingGapCPDD(request: request);
    return response;
  }

  Future<ApiResponse> projectsReachingEndCPDD({required RequestBody request}) async {
    final response = await _service.projectsReachingEndCPDD(request: request);
    return response;
  }

  Future<ApiResponse> donationBreakdownByProjectAODD({required RequestBody request}) async {
    final response = await _service.donationBreakdownByProjectAODD(request: request);
    return response;
  }

  Future<ApiResponse> top5ProjectsAODD({required RequestBody request}) async {
    final response = await _service.top5ProjectsAODD(request: request);
    return response;
  }

  Future<ApiResponse> top5AssociationsAODD({required RequestBody request}) async {
    final response = await _service.top5AssociationsAODD(request: request);
    return response;
  }

  Future<ApiResponse> donorAverageAODD({required RequestBody request}) async {
    final response = await _service.donorAverageAODD(request: request);
    return response;
  }

  Future<ApiResponse> donorPercentageAODD({required RequestBody request}) async {
    final response = await _service.donorPercentageAODD(request: request);
    return response;
  }

  Future<ApiResponse> walletBalance({required RequestBody request}) async {
    final response = await _service.walletBalance(request: request);
    return response;
  }

  Future<ApiResponse> payViaWallet({required RequestBody request}) async {
    final response = await _service.payViaWallet(request: request);
    return response;
  }

  Future<ApiResponse> acceptAssociationRequest({required RequestBody request}) async {
    final response = await _service.acceptAssociationRequest(request: request);
    return response;
  }

  Future<ApiResponse> myRefunds({required RequestBody request}) async {
    final response = await _service.myRefunds(request: request);
    return response;
  }

  Future<ApiResponse> myWallet({required RequestBody request}) async {
    final response = await _service.myWallet(request: request);
    return response;
  }

  Future<ApiResponse> adsList({required RequestBody request}) async {
    final response = await _service.adsList(request: request);
    return response;
  }

  Future<ApiResponse> taskCollectionDetails({required RequestBody request}) async {
    final response = await _service.taskCollectionDetails(request: request);
    return response;
  }

  Future<ApiResponse> authenticateTaskRequest({required RequestBody request}) async {
    final response = await _service.authenticateTaskRequest(request: request);
    return response;
  }

  Future<ApiResponse> publicDocuments({required RequestBody request}) async {
    final response = await _service.publicDocuments(request: request);
    return response;
  }

  Future<ApiResponse> userDocuments({required RequestBody request}) async {
    final response = await _service.userDocuments(request: request);
    return response;
  }

  Future<ApiResponse> platformDocuments({required RequestBody request}) async {
    final response = await _service.platformDocuments(request: request);
    return response;
  }

  Future<ApiResponse> updateDocumentStatus({required RequestBody request}) async {
    final response = await _service.updateDocumentStatus(request: request);
    return response;
  }

  Future<ApiResponse> savePlatformDocument({required RequestBody request}) async {
    final response = await _service.savePlatformDocument(request: request);
    return response;
  }

  Future<ApiResponse> uploadPublicDocument({required RequestBody request}) async {
    final response = await _service.uploadPublicDocument(request: request);
    return response;
  }

  Future<ApiResponse> updatePlatformDocument({required RequestBody request}) async {
    final response = await _service.updatePlatformDocument(request: request);
    return response;
  }

  Future<ApiResponse> archiveNews({required RequestBody request}) async {
    final response = await _service.archiveNews(request: request);
    return response;
  }

  Future<ApiResponse> publicDocumentStatus({required RequestBody request}) async {
    final response = await _service.publicDocumentStatus(request: request);
    return response;
  }

  Future<ApiResponse> associationProjectsPaginated({required RequestBody request}) async {
    final response = await _service.associationProjectsPaginated(request: request);
    return response;
  }

  Future<ApiResponse> submitFundTransferRequest({required RequestBody request}) async {
    final response = await _service.submitFundTransferRequest(request: request);
    return response;
  }

  Future<ApiResponse> auditLog({required RequestBody request}) async {
    final response = await _service.auditLog(request: request);
    return response;
  }

  Future<ApiResponse> fundRequest({required RequestBody request}) async {
    final response = await _service.fundRequest(request: request);
    return response;
  }

  Future<ApiResponse> sahemBank({required RequestBody request}) async {
    final response = await _service.sahemBank(request: request);
    return response;
  }

  Future<ApiResponse> fundTransferDetail({required RequestBody request}) async {
    final response = await _service.fundTransferDetail(request: request);
    return response;
  }

  Future<ApiResponse> deleteFAQ({required RequestBody request}) async {
    final response = await _service.deleteFAQ(request: request);
    return response;
  }

  Future<ApiResponse> addFAQ({required RequestBody request}) async {
    final response = await _service.addFAQ(request: request);
    return response;
  }

  Future<ApiResponse> updateFAQ({required RequestBody request}) async {
    final response = await _service.updateFAQ(request: request);
    return response;
  }

  Future<ApiResponse> faqPaginated({required RequestBody request}) async {
    final response = await _service.faqPaginated(request: request);
    return response;
  }

  Future<ApiResponse> additionalDocuments({required RequestBody request}) async {
    final response = await _service.additionalDocuments(request: request);
    return response;
  }

  Future<ApiResponse> associationsList({required RequestBody request}) async {
    final response = await _service.associationsList(request: request);
    return response;
  }

  Future<ApiResponse> projectListPaginated({required RequestBody request}) async {
    final response = await _service.projectListPaginated(request: request);
    return response;
  }

  Future<ApiResponse> saveAdditionalDocuments({required RequestBody request}) async {
    final response = await _service.saveAdditionalDocuments(request: request);
    return response;
  }

  Future<ApiResponse> allUserRequests({required RequestBody request}) async {
    final response = await _service.allUserRequests(request: request);
    return response;
  }

  Future<ApiResponse> allNewsPaginated({required RequestBody request}) async {
    final response = await _service.allNewsPaginated(request: request);
    return response;
  }

  Future<ApiResponse> addNews({required RequestBody request}) async {
    final response = await _service.addNews(request: request);
    return response;
  }

  Future<ApiResponse> updateNews({required RequestBody request}) async {
    final response = await _service.updateNews(request: request);
    return response;
  }

  Future<ApiResponse> cmsAssociationNews({required RequestBody request}) async {
    final response = await _service.cmsAssociationNews(request: request);
    return response;
  }

  Future<ApiResponse> addAboutUs({required RequestBody request}) async {
    final response = await _service.addAboutUs(request: request);
    return response;
  }

  Future<ApiResponse> updateAboutUs({required RequestBody request}) async {
    final response = await _service.updateAboutUs(request: request);
    return response;
  }

  Future<ApiResponse> notificationDetails({required RequestBody request}) async {
    final response = await _service.notificationDetails(request: request);
    return response;
  }

  Future<ApiResponse> addAssociation({required RequestBody request}) async {
    final response = await _service.addAssociation(request: request);
    return response;
  }

  Future<ApiResponse> updateAssociation({required RequestBody request}) async {
    final response = await _service.updateAssociation(request: request);
    return response;
  }

  Future<ApiResponse> allFeedbacksPaginated({required RequestBody request}) async {
    final response = await _service.allFeedbacksPaginated(request: request);
    return response;
  }

  Future<ApiResponse> auditLogsById({required RequestBody request}) async {
    final response = await _service.auditLogsById(request: request);
    return response;
  }

  Future<ApiResponse> cmsNotifications({required RequestBody request}) async {
    final response = await _service.cmsNotifications(request: request);
    return response;
  }

  Future<ApiResponse> saveNotification({required RequestBody request}) async {
    final response = await _service.saveNotification(request: request);
    return response;
  }

  Future<ApiResponse> updateNotification({required RequestBody request}) async {
    final response = await _service.updateNotification(request: request);
    return response;
  }

  Future<ApiResponse> addCompany({required RequestBody request}) async {
    final response = await _service.addCompany(request: request);
    return response;
  }

  Future<ApiResponse> updateCompany({required RequestBody request}) async {
    final response = await _service.updateCompany(request: request);
    return response;
  }

  Future<ApiResponse> cmsServices({required RequestBody request}) async {
    final response = await _service.cmsServices(request: request);
    return response;
  }

  Future<ApiResponse> activeDeActiveService({required RequestBody request}) async {
    final response = await _service.activeDeActiveService(request: request);
    return response;
  }

  Future<ApiResponse> userPermissions({required RequestBody request}) async {
    final response = await _service.userPermissions(request: request);
    return response;
  }

  Future<ApiResponse> addService({required RequestBody request}) async {
    final response = await _service.addService(request: request);
    return response;
  }

  Future<ApiResponse> updateService({required RequestBody request}) async {
    final response = await _service.updateService(request: request);
    return response;
  }

  Future<ApiResponse> fundTransferQueue({required RequestBody request}) async {
    final response = await _service.fundTransferQueue(request: request);
    return response;
  }

  Future<ApiResponse> globalSearch({required RequestBody request}) async {
    final response = await _service.globalSearch(request: request);
    return response;
  }

  Future<ApiResponse> allAdsPaginated({required RequestBody request}) async {
    final response = await _service.allAdsPaginated(request: request);
    return response;
  }

  Future<ApiResponse> addAds({required RequestBody request}) async {
    final response = await _service.addAds(request: request);
    return response;
  }

  Future<ApiResponse> updateAds({required RequestBody request}) async {
    final response = await _service.updateAds(request: request);
    return response;
  }

  Future<ApiResponse> notificationPreferences({required RequestBody request}) async {
    final response = await _service.notificationPreferences(request: request);
    return response;
  }

  Future<ApiResponse> allCampaignListPaginated({required RequestBody request}) async {
    final response = await _service.allCampaignListPaginated(request: request);
    return response;
  }

  Future<ApiResponse> allRecipientsListPaginated({required RequestBody request}) async {
    final response = await _service.allRecipientsListPaginated(request: request);
    return response;
  }

  Future<ApiResponse> addGroup({required RequestBody request}) async {
    final response = await _service.addGroup(request: request);
    return response;
  }

  Future<ApiResponse> updateGroup({required RequestBody request}) async {
    final response = await _service.updateGroup(request: request);
    return response;
  }

  Future<ApiResponse> groupDetails({required RequestBody request}) async {
    final response = await _service.groupDetails(request: request);
    return response;
  }

  Future<ApiResponse> deleteGroup({required RequestBody request}) async {
    final response = await _service.deleteGroup(request: request);
    return response;
  }

  Future<ApiResponse> deleteGroupRecipients({required RequestBody request}) async {
    final response = await _service.deleteGroupRecipients(request: request);
    return response;
  }

  Future<ApiResponse> associationAllProjectsPaginated({required RequestBody request}) async {
    final response = await _service.associationAllProjectsPaginated(request: request);
    return response;
  }

  Future<ApiResponse> saveAsDraft({required RequestBody request}) async {
    final response = await _service.saveAsDraft(request: request);
    return response;
  }

  Future<ApiResponse> updateDraft({required RequestBody request}) async {
    final response = await _service.updateDraft(request: request);
    return response;
  }

  Future<ApiResponse> associationNewsPaginated({required RequestBody request}) async {
    final response = await _service.associationNewsPaginated(request: request);
    return response;
  }

  Future<ApiResponse> contentRating({required RequestBody request}) async {
    final response = await _service.contentRating(request: request);
    return response;
  }

  Future<ApiResponse> downloadTaxCertificate({required RequestBody request}) async {
    final response = await _service.downloadTaxCertificate(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableAssociation({required RequestBody request}) async {
    final response = await _service.enableDisableAssociation(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableProject({required RequestBody request}) async {
    final response = await _service.enableDisableProject(request: request);
    return response;
  }

  Future<ApiResponse> financialStatementBalance({required RequestBody request}) async {
    final response = await _service.financialStatementBalance(request: request);
    return response;
  }

  Future<ApiResponse> financialStatementByMonth({required RequestBody request}) async {
    final response = await _service.financialStatementByMonth(request: request);
    return response;
  }

  Future<ApiResponse> userDonations({required RequestBody request}) async {
    final response = await _service.userDonations(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableFAQ({required RequestBody request}) async {
    final response = await _service.enableDisableFAQ(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableNews({required RequestBody request}) async {
    final response = await _service.enableDisableNews(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableAds({required RequestBody request}) async {
    final response = await _service.enableDisableAds(request: request);
    return response;
  }

  Future<ApiResponse> deleteAccount({required RequestBody request}) async {
    final response = await _service.deleteAccount(request: request);
    return response;
  }

  Future<ApiResponse> approverGroups({required RequestBody request}) async {
    final response = await _service.approverGroups(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableGroup({required RequestBody request}) async {
    final response = await _service.enableDisableGroup(request: request);
    return response;
  }

  Future<ApiResponse> deleteApproverGroup({required RequestBody request}) async {
    final response = await _service.deleteApproverGroup(request: request);
    return response;
  }

  Future<ApiResponse> approverGroupEmployees({required RequestBody request}) async {
    final response = await _service.approverGroupEmployees(request: request);
    return response;
  }

  Future<ApiResponse> approverGroupDetails({required RequestBody request}) async {
    final response = await _service.approverGroupDetails(request: request);
    return response;
  }

  Future<ApiResponse> addApproverGroup({required RequestBody request}) async {
    final response = await _service.addApproverGroup(request: request);
    return response;
  }

  Future<ApiResponse> updateApproverGroup({required RequestBody request}) async {
    final response = await _service.updateApproverGroup(request: request);
    return response;
  }

  Future<ApiResponse> allWorkflows({required RequestBody request}) async {
    final response = await _service.allWorkflows(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableWorkflow({required RequestBody request}) async {
    final response = await _service.enableDisableWorkflow(request: request);
    return response;
  }

  Future<ApiResponse> deleteWorkflow({required RequestBody request}) async {
    final response = await _service.deleteWorkflow(request: request);
    return response;
  }

  Future<ApiResponse> addWorkflow({required RequestBody request}) async {
    final response = await _service.addWorkflow(request: request);
    return response;
  }

  Future<ApiResponse> updateWorkflow({required RequestBody request}) async {
    final response = await _service.updateWorkflow(request: request);
    return response;
  }

  Future<ApiResponse> enableDisableCompany({required RequestBody request}) async {
    final response = await _service.enableDisableCompany(request: request);
    return response;
  }

  Future<ApiResponse> associationFundRequests({required RequestBody request}) async {
    final response = await _service.associationFundRequests(request: request);
    return response;
  }

  Future<ApiResponse> allReminders({required RequestBody request}) async {
    final response = await _service.allReminders(request: request);
    return response;
  }

  Future<ApiResponse> deleteReminder({required RequestBody request}) async {
    final response = await _service.deleteReminder(request: request);
    return response;
  }

  Future<ApiResponse> addDonationReminder({required RequestBody request}) async {
    final response = await _service.addDonationReminder(request: request);
    return response;
  }

  Future<ApiResponse> updateDonationReminder({required RequestBody request}) async {
    final response = await _service.updateDonationReminder(request: request);
    return response;
  }

  Future<ApiResponse> addGuestReminder({required RequestBody request}) async {
    final response = await _service.addGuestReminder(request: request);
    return response;
  }

  Future<ApiResponse> addUpdateProjectAlerts({required RequestBody request}) async {
    final response = await _service.addUpdateProjectAlerts(request: request);
    return response;
  }

  Future<ApiResponse> projectAlerts({required RequestBody request}) async {
    final response = await _service.projectAlerts(request: request);
    return response;
  }

  Future<ApiResponse> feedbackByUserIdPaginated({required RequestBody request}) async {
    final response = await _service.feedbackByUserIdPaginated(request: request);
    return response;
  }

  Future<ApiResponse> moneyTransferred({required RequestBody request}) async {
    final response = await _service.moneyTransferred(request: request);
    return response;
  }

  Future<ApiResponse> changePassword({required RequestBody request}) async {
    final response = await _service.changePassword(request: request);
    return response;
  }

  Future<ApiResponse> smtpConfig({required RequestBody request}) async {
    final response = await _service.smtpConfig(request: request);
    return response;
  }

  Future<ApiResponse> addSMTPConfig({required RequestBody request}) async {
    final response = await _service.addSMTPConfig(request: request);
    return response;
  }

  Future<ApiResponse> getContactUs({required RequestBody request}) async {
    final response = await _service.getContactUs(request: request);
    return response;
  }

  Future<ApiResponse> areaChartDonationDataAssociationDashboard({required RequestBody request}) async {
    final response = await _service.areaChartDonationDataAssociationDashboard(request: request);
    return response;
  }

  Future<ApiResponse> donorBarchartDetails({required RequestBody request}) async {
    final response = await _service.donorBarchartDetails(request: request);
    return response;
  }

  Future<ApiResponse> donorsBreakdown({required RequestBody request}) async {
    final response = await _service.donorsBreakdown(request: request);
    return response;
  }

  Future<ApiResponse> donationDataMonthWiseAODD({required RequestBody request}) async {
    final response = await _service.donationDataMonthWiseAODD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetHeaderDataFDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetHeaderDataFDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetPendingCollectionDataFDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetPendingCollectionDataFDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetDonationsWRTPaymentTypeFDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetDonationsWRTPaymentTypeFDD(request: request);
    return response;
  }

  Future<ApiResponse> adminOperationsDashboardData({required RequestBody request}) async {
    final response = await _service.adminOperationsDashboardData(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetHeaderDataUEIDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetHeaderDataUEIDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetFeedbackItemUEIDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetFeedbackItemUEIDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetSurveyItemUEIDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetSurveyItemUEIDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetRatingPerContentUEIDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetRatingPerContentUEIDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetRatingPerUserTypeUEIDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetRatingPerUserTypeUEIDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGGetListDataByContentTypeUEIDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGGetListDataByContentTypeUEIDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetPreferredLoginTimeListUEIDD({required RequestBody request}) async {
    final response = await _service.adminDashboardGetPreferredLoginTimeListUEIDD(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardSLAGetHeaderData({required RequestBody request}) async {
    final response = await _service.adminDashboardSLAGetHeaderData(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowType({required RequestBody request}) async {
    final response = await _service.adminDashboardGetSLADetailsPerWorkflowType(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowApproverGroup({required RequestBody request}) async {
    final response = await _service.adminDashboardGetSLADetailsPerWorkflowApproverGroup(request: request);
    return response;
  }

  Future<ApiResponse> adminDashboardGetSLADetailsPerWorkflowLevel({required RequestBody request}) async {
    final response = await _service.adminDashboardGetSLADetailsPerWorkflowLevel(request: request);
    return response;
  }

  Future<ApiResponse> sahemEmployees({required RequestBody request}) async {
    final response = await _service.sahemEmployees(request: request);
    return response;
  }

  Future<ApiResponse> updateDonorProfile({required RequestBody request}) async {
    final response = await _service.updateDonorProfile(request: request);
    return response;
  }

  Future<ApiResponse> biometricAuth({required RequestBody request}) async {
    final response = await _service.biometricAuth(request: request);
    return response;
  }

  Future<ApiResponse> deletePlatformDocument({required RequestBody request}) async {
    final response = await _service.deletePlatformDocument(request: request);
    return response;
  }

  Future<ApiResponse> deletePublicDocument({required RequestBody request}) async {
    final response = await _service.deletePublicDocument(request: request);
    return response;
  }

  Future<ApiResponse> aboutSahem({required RequestBody request}) async {
    final response = await _service.aboutSahem(request: request);
    return response;
  }

  Future<ApiResponse> auditLogByEntityId({required RequestBody request}) async {
    final response = await _service.auditLogByEntityId(request: request);
    return response;
  }

  Future<ApiResponse> generateOTPForUser({required RequestBody request}) async {
    final response = await _service.generateOTPForUser(request: request);
    return response;
  }

  Future<ApiResponse> createDubaiPayment({required RequestBody request}) async {
    final response = await _service.createDubaiPayment(request: request);
    return response;
  }

  Future<ApiResponse> adduestUserDP({required RequestBody request}) async {
    final response = await _service.adduestUserDP(request: request);
    return response;
  }

  Future<ApiResponse> sendSmsEmailMobileApp({required RequestBody request}) async {
    final response = await _service.sendSmsEmailMobileApp(request: request);
    return response;
  }

}
