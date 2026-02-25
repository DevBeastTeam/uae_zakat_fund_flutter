import 'package:get_it/get_it.dart';
import 'package:zakat_fund/chatbot/chat_bot_ai_injection.dart';

GetIt sl = GetIt.instance;

void di() {
  initChatBotAiInjection(sl);
}
