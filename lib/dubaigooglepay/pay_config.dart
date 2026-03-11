// This configuration should be passed to the `pay` package.
// Note: Some of these parameters, especially `merchantId` and `gatewayMerchantId`,
// need to be provided by DubaiPay/Google Business Console.

const String defaultGooglePayConfigString = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "dubaipay", 
            "gatewayMerchantId": "YOUR_GATEWAY_MERCHANT_ID"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "YOUR_MERCHANT_ID",
      "merchantName": "YOUR_MERCHANT_NAME"
    },
    "transactionInfo": {
      "countryCode": "AE",
      "currencyCode": "AED"
    }
  }
}''';
