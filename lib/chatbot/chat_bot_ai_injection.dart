import 'package:get_it/get_it.dart';
import 'package:zakat_fund/chatbot/data/data_sources/chat_data_source.dart';
import 'package:zakat_fund/chatbot/data/data_sources/get_chat_messages_data_source.dart';
import 'package:zakat_fund/chatbot/data/data_sources/get_chats_history_data_source.dart';
import 'package:zakat_fund/chatbot/data/data_sources/suggestions_data_source.dart';
import 'package:zakat_fund/chatbot/data/repositories/chat_repo_impl.dart';
import 'package:zakat_fund/chatbot/data/repositories/get_chat_messages_repo_impl.dart';
import 'package:zakat_fund/chatbot/data/repositories/get_chats_history_repo_impl.dart';
import 'package:zakat_fund/chatbot/data/repositories/suggestions_repo_impl.dart';
import 'package:zakat_fund/chatbot/domain/repositories/chat_repo.dart';
import 'package:zakat_fund/chatbot/domain/repositories/get_chat_messages_repo.dart';
import 'package:zakat_fund/chatbot/domain/repositories/get_chats_history_repo.dart';
import 'package:zakat_fund/chatbot/domain/repositories/suggestions_repo.dart';
import 'package:zakat_fund/chatbot/domain/usecases/chat_usecase.dart';
import 'package:zakat_fund/chatbot/domain/usecases/get_chat_messages_usecase.dart';
import 'package:zakat_fund/chatbot/domain/usecases/get_chats_history_usecase.dart';
import 'package:zakat_fund/chatbot/domain/usecases/suggestions_usecase.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/chatbot/core/api_helper_chat_bot_ai.dart';

Future<void> initChatBotAiInjection(GetIt sl) async {
  sl.registerLazySingleton<ApiHelperChatBotAi>(() => ApiHelperChatBotAi());

  /// DATA SOURCES ///

  // SuggestionsUsecase Data Source
  sl.registerLazySingleton<SuggestionsDataSource>(
    () => SuggestionsDataSourceImpl(),
  );

  // Chat Data Source
  sl.registerLazySingleton<ChatDataSource>(
    () => ChatDataSourceImpl(sl<ApiHelperChatBotAi>()),
  );

  // Get Chats History
  sl.registerLazySingleton<GetChatsHistoryDataSource>(
    () => GetChatsHistoryDataSourceImpl(sl<ApiHelperChatBotAi>()),
  );

  sl.registerLazySingleton<GetChatMessagesDataSource>(
    () => GetChatMessagesDataSourceImpl(sl<ApiHelperChatBotAi>()),
  );

  /// REPOSITORIES ///

  // SuggestionsUsecase Repository
  sl.registerLazySingleton<SuggestionsRepo>(
    () => SuggestionsRepoImpl(suggestionsDataSource: sl()),
  );

  // Chat Repository
  sl.registerLazySingleton<ChatRepo>(() => ChatRepoImpl(sl()));

  // Get Chats History Repository
  sl.registerLazySingleton<GetChatsHistoryRepo>(
    () => GetChatsHistoryRepoImpl(sl()),
  );

  sl.registerLazySingleton<GetChatMessagesRepo>(
    () => GetChatMessagesRepoImpl(sl()),
  );

  /// USECASES ///

  // Suggestion Usecase
  sl.registerLazySingleton<SuggestionsUsecase>(() => SuggestionsUsecase(sl()));

  // Chat Usecase
  sl.registerLazySingleton<ChatUsecase>(() => ChatUsecase(sl()));

  // Get Chats History Usecase
  sl.registerLazySingleton<GetChatsHistoryUsecase>(
    () => GetChatsHistoryUsecase(sl()),
  );

  sl.registerLazySingleton<GetChatMessagesUsecase>(
    () => GetChatMessagesUsecase(sl()),
  );

  /// PROVIDERS & VIEW MODELS ///

  // Chat Bot View Model
  sl.registerFactory(
    () => ChatBotViewModel(
      suggestionsUsecase: sl(),
      chatUsecase: sl(),
      getChatsHistoryUsecase: sl(),
      getChatMessagesUsecase: sl(),
    ),
  );
}
