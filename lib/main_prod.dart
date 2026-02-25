import 'package:zakat_fund/chatbot/core/di.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/my_app/my_app.dart';

void main() {
  di();
  FlavorConfig.config(Flavor.prod);
  mainFunction();
}
