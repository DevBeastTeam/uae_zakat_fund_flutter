import 'package:zakat_fund/chatbot/core/di.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/my_app/my_app.dart';

void main() {
  di();
  FlavorConfig.config(Flavor.dev);
  mainFunction();
}





















// flutter run --flavor dev -t lib/main_dev.dart     


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