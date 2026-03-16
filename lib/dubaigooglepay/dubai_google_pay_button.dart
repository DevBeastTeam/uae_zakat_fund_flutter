import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'pay_config.dart';
import 'dubai_pay_service.dart';

class DubaiGooglePayButton extends StatelessWidget {
  final Map<String, dynamic> customPayConfig;
  final DubaiGooglePayService dubaiGooglePayService;
  final String amount;
  final String label;
  final String spTrn;
  final String? email;
  final String? mobileNo;
  final String? description;
  final Function(dynamic result)? onPaymentResult;
  final Function(String error)? onError;

  const DubaiGooglePayButton({
    super.key,
    required this.dubaiGooglePayService,
    required this.amount,
    required this.spTrn,
    this.customPayConfig = const {},
    this.label = 'Payment',
    this.email,
    this.mobileNo,
    this.description,
    this.onPaymentResult,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    // You should use standard or custom config depending on your actual integration
    // We are using `PaymentConfiguration.fromJsonString` with the default base string.

    // Convert base configuration logic
    final paymentConfiguration =
        PaymentConfiguration.fromJsonString(defaultGooglePayConfigString);

    return GooglePayButton(
      paymentConfiguration: paymentConfiguration,
      paymentItems: [
        PaymentItem(
          label: label,
          amount: amount,
          status: PaymentItemStatus.final_price,
        ),
      ],
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.all(0),
      onPaymentResult: (Map<String, dynamic> result) async {
        try {
          // Send tokenization result (GPay token) to DubaiPay API via DubaiGooglePayService
          final response = await dubaiGooglePayService.processGooglePayPayment(
            paymentResult: result,
            amount: amount,
            spTrn: spTrn,
            email: email,
            mobileNo: mobileNo,
            description: description,
          );

          if (response.statusCode == "00") {
            // Success Initiating Payment! Next logic like URL redirect or inquire
            onPaymentResult?.call(response);
          } else {
            // Handle payment rejection
            onError?.call(response.errorMessage ??
                response.statusDesc ??
                "Unknown Payment Error");
          }
        } catch (e) {
          onError?.call(e.toString());
        }
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
