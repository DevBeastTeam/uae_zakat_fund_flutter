import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'dubai_pay_api_client.dart';
import 'dubai_pay_models.dart';
import 'pay_config.dart';

class DubaiGooglePayService {
  final DubaiPayApiClient apiClient;
  final String spCode;
  final String servCode;
  final String version;

  DubaiGooglePayService({
    required this.apiClient,
    required this.spCode,
    required this.servCode,
    required this.version,
  });

  /// This is the entry point after the user authorizes payment with Google Pay native UI.
  /// The [paymentResult] is a JSON string emitted by the `pay` flutter package.
  Future<DubaiPayTransactionResponse> processGooglePayPayment({
    required Map<String, dynamic> paymentResult,
    required String amount,
    required String spTrn,
    String? email,
    String? mobileNo,
    String? description,
  }) async {
    // 1. Extract the token and card networking returned by Google Pay
    final paymentMethodData = paymentResult['paymentMethodData'];
    final tokenizationData = paymentMethodData['tokenizationData'];
    final cardTokenString = tokenizationData['token'];
    final info = paymentMethodData['info'];
    final cardNetwork = info['cardNetwork']; // e.g., "MASTERCARD" or "VISA"

    // 2. Prepare headers
    final header = DubaiPayHeader(
      spCode: spCode,
      servCode: servCode,
      paymentMode: "EPAY",
      paymentType: "GOOGLE_PAY",
    );

    // 3. Prepare transaction details
    final transaction = TransactionInfo(
      spCode: spCode,
      servCode: servCode,
      spTrn: spTrn,
      amount: amount,
      timestamp: DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
      description: description ?? 'Google Pay Transaction',
      version: version,
      email: email,
      mobileNo: mobileNo,
    );

    // 4. Prepare Google Pay Data
    final paymentData = GooglePayData(
      cardToken: cardTokenString,
      cardType: cardNetwork,
    );

    final initiateRequest = InitiateRequest(
      header: header,
      transaction: transaction,
      paymentData: paymentData,
    );

    // 5. Register the payment with Dubai Pay
    final registerResponse = await apiClient.register(initiateRequest);

    return registerResponse;
  }

  /// Inquire status using response token
  Future<DubaiPayTransactionResponse> inquireTransaction({
    required String responseToken,
  }) async {
    final header = DubaiPayHeader(spCode: spCode, servCode: servCode);
    final transaction = TransactionInfo(spCode: spCode, servCode: servCode);

    final request = StatusRequest(
      header: header,
      transaction: transaction,
      responseToken: responseToken,
    );

    return await apiClient.inquire(request);
  }

  /// Confirm transaction status with Dubai Pay (mandatory for successful transactions)
  Future<DubaiPayTransactionResponse> confirmTransaction({
    required String spTrn,
  }) async {
    final header = DubaiPayHeader(spCode: spCode, servCode: servCode);
    final transaction = TransactionInfo(
      spCode: spCode,
      servCode: servCode,
      spTrn: spTrn,
    );

    final request = StatusRequest(header: header, transaction: transaction);

    return await apiClient.confirm(request);
  }

  /// Query transaction status by spTrn (Useful when status is pending for more than 5 minutes)
  Future<DubaiPayTransactionResponse> queryTransaction({
    required String spTrn,
  }) async {
    final header = DubaiPayHeader(spCode: spCode, servCode: servCode);
    final transaction = TransactionInfo(
      spCode: spCode,
      servCode: servCode,
      spTrn: spTrn,
    );

    final request = StatusRequest(header: header, transaction: transaction);

    return await apiClient.query(request);
  }

  /// Programmatically show Google Pay without the Button Widget
  Future<void> showGooglePay({
    required String amount,
    required String spTrn,
    String label = 'Payment',
    String? email,
    String? mobileNo,
    String? description,
    Function(dynamic result)? onPaymentResult,
    Function(String error)? onError,
  }) async {
    try {
      final paymentConfiguration =
          PaymentConfiguration.fromJsonString(defaultGooglePayConfigString);
      final payClient = Pay({PayProvider.google_pay: paymentConfiguration});

      final result = await payClient.showPaymentSelector(
        PayProvider.google_pay,
        [
          PaymentItem(
            label: label,
            amount: amount,
            status: PaymentItemStatus.final_price,
          ),
        ],
      );

      final response = await processGooglePayPayment(
        paymentResult: result,
        amount: amount,
        spTrn: spTrn,
        email: email,
        mobileNo: mobileNo,
        description: description,
      );

      if (response.statusCode == "00") {
        onPaymentResult?.call(response);
      } else {
        onError?.call(response.errorMessage ??
            response.statusDesc ??
            "Unknown Payment Error");
      }
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
