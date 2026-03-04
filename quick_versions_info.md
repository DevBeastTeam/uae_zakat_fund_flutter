// flutter run --flavor dev -t lib/main_dev.dart     

// buiild with stage level
// flutter build apk --flavor dev -t lib/main_dev.dart

// buiild with production level
// flutter build apk --flavor prod -t lib/main_prod.dart


//# for fill payment form if without login
// Name: Naeem
// Email: naeem@evento.ae
// Phone: 56000000

// # app login
// hassanbajwa.sqae+donor5@gmail.com
// Sahem@1122

//  # static dummy app login
// dev@gmail.com
// 12345678

// admin login
admin@zakatfund.com
Admin@12345


//// temporary
// 1. 
// lib/view_model/log_in_view_model.dart
// inside quick login is added on line 444.


// by passing login 401.
  // } else if (apiResponse.appState == AppState.onUnauthorized) {
  //     if (userBox.isNotEmpty &&
  //         userBox.getAt(0).userName.toLowerCase() == "dev@gmail.com") {
  //       debugPrint("Bypassing 401 logout for developer account");
  //       return;
  //     }
  //     Utils.logInAgain();
  //   }



  3. /Users/mac/Documents/flutter_projects/uae_zakat_fund_flutter/lib/view/bottom_bar/cart/payment/online_payment_method.dart

  added --> 
  on bottom of comment:
   SizedBox(
              height: 72.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                children: [
                  if (controller.showCreditCard) ...[
                    _buildCreditCardOption(),
                    16.horizontalSpace
                  ],
                  if (Platform.isAndroid && controller.showGooglePay)
                    GooglePayButton(
                      paymentItems: controller.paymentItems,
                      type: GooglePayButtonType.donate,
                      onPaymentResult: (paymentResult) {
                        debugPrint("Payment Result: $paymentResult");
                      },
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      paymentConfiguration: defaultGooglePayConfig,
                    ),
                  if (Platform.isIOS && controller.showApplePay)
                    ApplePayButton(
                      paymentItems: controller.paymentItems,
                      type: ApplePayButtonType.donate,
                      onPaymentResult: (paymentResult) {
                        debugPrint("Payment Result: $paymentResult");
                      },
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      paymentConfiguration: defaultApplePayConfig,
                    ),
                ],
              ),
            ),