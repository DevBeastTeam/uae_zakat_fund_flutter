import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:uuid/uuid.dart';
import 'package:zakat_fund/chatbot/core/date_utils.dart';
import 'package:zakat_fund/chatbot/data/models/message_context_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_bot_ai_chats_history_entity.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_message_entity.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_context_entity.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_metadata_entity.dart';
import 'package:zakat_fund/chatbot/domain/entities/suggestion_entity.dart';
import 'package:zakat_fund/chatbot/domain/usecases/chat_usecase.dart';
import 'package:zakat_fund/chatbot/domain/usecases/get_chat_messages_usecase.dart';
import 'package:zakat_fund/chatbot/domain/usecases/get_chats_history_usecase.dart';
import 'package:zakat_fund/chatbot/domain/usecases/suggestions_usecase.dart';
import 'package:zakat_fund/utils/utils.dart';

class ChatBotViewModel extends ChangeNotifier {
  final SuggestionsUsecase suggestionsUsecase;
  final ChatUsecase chatUsecase;
  final GetChatsHistoryUsecase getChatsHistoryUsecase;
  final GetChatMessagesUsecase getChatMessagesUsecase;

  ChatBotViewModel({
    required this.suggestionsUsecase,
    required this.chatUsecase,
    required this.getChatsHistoryUsecase,
    required this.getChatMessagesUsecase,
  });

  @override
  void dispose() {
    super.dispose();

    _messageController.dispose();
    _messagesScrollController.dispose();
  }

  // Private Variables
  String _userId = '123456789';
  String _sessionId =
      'zakat_sess_${const Uuid().v4()}_${DateTime.now().millisecondsSinceEpoch}';

  bool _sendingMessage = false;
  bool _loadingChatsHistory = false;
  bool _loadingExistingChat = false;
  bool _paginatingChatsHistory = false;
  bool _paginatingChatMessages = false;

  int _chatsHistoryPageNumber = 1;
  int _chatMessagesPageNumber = 1;
  int loadingOpenServiceLinkMessageIndex = -1;
  final int _chatsPageSize = 20;
  final int _chatMessagesPageSize = 20;
  List<MessageContextModel> _messageContext = [];

  List<SuggestionEntity> _suggestions = [];
  List<MessageEntity> _messages = [];
  ChatBotAiChatsHistoryEntity? _chatsHistoryInstance;

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _chatsSearchController = TextEditingController();
  final ScrollController _messagesScrollController = ScrollController();
  final ScrollController _chatsScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _messagesScaffoldKey =
      GlobalKey<ScaffoldState>();

  // Public Variables
  bool get sendingMessage => _sendingMessage;
  bool get loadingChatsHistory => _loadingChatsHistory;
  bool get loadingExistingChat => _loadingExistingChat;
  bool get paginatingChatsHistory => _paginatingChatsHistory;
  bool get paginatingChatMessages => _paginatingChatMessages;
  int get chatsHistoryPageNumber => _chatsHistoryPageNumber;
  int get chatMessagesPageNumber => _chatMessagesPageNumber;
  String get sessionId => _sessionId;
  ChatBotAiChatsHistoryEntity? get chatsHistoryInstance =>
      _chatsHistoryInstance;
  List<SuggestionEntity> get suggestions => _suggestions;
  List<MessageEntity> get messages => _messages;
  TextEditingController get messageController => _messageController;
  TextEditingController get chatsSearchController => _chatsSearchController;
  ScrollController get messagesScrollController => _messagesScrollController;
  ScrollController get chatsScrollController => _chatsScrollController;
  GlobalKey<ScaffoldState> get messagesScaffoldKey => _messagesScaffoldKey;
  List<MessageContextEntity> get messageContext => _messageContext;
  List<ChatMessageEntity> get searchedChats {
    final chats = _chatsHistoryInstance?.chats;
    if (chats == null || chats.isEmpty) return [];
    if (_chatsSearchController.text.isEmpty) return chats;

    return chats.where((chat) {
      final searchText = _chatsSearchController.text.toLowerCase();
      final chatTitle = chat.title?.toLowerCase();
      return chatTitle?.contains(searchText) ?? false;
    }).toList();
  }

  List<ChatMessageEntity> get todayChats {
    return searchedChats.where((chat) {
      final date = _parseDate(chat.createdAt);
      return date.isToday;
    }).toList();
  }

  List<ChatMessageEntity> get yesterdayChats {
    return searchedChats.where((chat) {
      final date = _parseDate(chat.createdAt);
      return date.isYesterday;
    }).toList();
  }

  List<ChatMessageEntity> get thisWeekChats {
    return searchedChats.where((chat) {
      final date = _parseDate(chat.createdAt);
      return date.isThisWeek && !date.isToday && !date.isYesterday;
    }).toList();
  }

  List<ChatMessageEntity> get otherChats {
    return searchedChats.where((chat) {
      final date = _parseDate(chat.createdAt);
      return !date.isToday && !date.isYesterday && !date.isThisWeek;
    }).toList();
  }

  DateTime _parseDate(String? dateStr) {
    return (DateTime.tryParse(dateStr ?? '') ?? DateTime.now()).toLocal();
  }

  // Setters
  void setUserId(String value) {
    _userId = value;
    notifyListeners();
  }

  void setSendingMessage(bool value) {
    _sendingMessage = value;
    notifyListeners();
  }

  void setLoadingChatsHistory(bool value) {
    _loadingChatsHistory = value;
    notifyListeners();
  }

  void setLoadingExistingChat(bool value) {
    _loadingExistingChat = value;
    notifyListeners();
  }

  void setPaginatingChatsHistory(bool value) {
    _paginatingChatsHistory = value;
    notifyListeners();
  }

  void setPaginatingChatMessages(bool value) {
    _paginatingChatMessages = value;
    notifyListeners();
  }

  void setSuggestions(List<SuggestionEntity> value) {
    _suggestions = value;
    notifyListeners();
  }

  void setLoadingOpenServiceLinkMessageIndex(int index) {
    loadingOpenServiceLinkMessageIndex = index;
    notifyListeners();
  }

  void addMessage(MessageEntity message) {
    _messages.add(message);
    notifyListeners();
  }

  void addMessageContext(MessageContextModel message) {
    _messageContext.add(message);
  }

  void setChatsHistoryPageNumber(int value) {
    _chatsHistoryPageNumber = value;
    notifyListeners();
  }

  void setChatMessagesPageNumber(int value) {
    _chatMessagesPageNumber = value;
    notifyListeners();
  }

  void setChatsHistoryInstance(ChatBotAiChatsHistoryEntity? value) {
    _chatsHistoryInstance = value;
    notifyListeners();
  }

  void setSessionId(String value) {
    _sessionId = value;
    notifyListeners();
  }

  // Methods
  void getSuggestions() {
    setSuggestions(suggestionsUsecase.call());
  }

  void clearMessageTextField() {
    _messageController.clear();
    notifyListeners();
  }

  void clearSearchTextField() {
    _chatsSearchController.clear();
    notifyListeners();
  }

  Future<void> scrollToBottom({
    bool manual = false,
    bool fromTextField = false,
    BuildContext? context,
  }) async {
    if (!_messagesScrollController.hasClients) return;

    if (fromTextField && context != null) {
      double distanceFromBottom =
          _messagesScrollController.position.maxScrollExtent -
          _messagesScrollController.position.pixels;

      if (distanceFromBottom > MediaQuery.sizeOf(context).height / 2) {
        return;
      }
    }

    if (!manual) await Future.delayed(const Duration(milliseconds: 200));

    _messagesScrollController.animateTo(
      _messagesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void paginate({
    required ScrollController controller,
    required VoidCallback callback,
    required bool paginateFromBottom,
  }) {
    final condition = paginateFromBottom
        ? controller.position.pixels == controller.position.maxScrollExtent
        : controller.position.pixels == controller.position.minScrollExtent;

    if (condition) {
      callback();
    }
  }

  void addScrollControllerListener({
    required ScrollController controller,
    required VoidCallback callback,
    required bool paginateFromBottom,
  }) {
    controller.removeListener(
      () => paginate(
        paginateFromBottom: paginateFromBottom,
        controller: controller,
        callback: callback,
      ),
    );
    controller.addListener(
      () => paginate(
        paginateFromBottom: paginateFromBottom,
        controller: controller,
        callback: callback,
      ),
    );
  }

  MessageEntity formMessageEntity(String message) {
    return MessageEntity(
      reply: message,
      fromZakat: false,
      categoryId: null,
      serviceCardAID: null,
      metadata: null,
      date: DateTime.now(),
      serviceCard: null,
    );
  }

  Future<void> onSendMessage({
    required BuildContext context,
    SuggestionEntity? suggestion,
    bool fromMoreDetails = false,
  }) async {
    String message = '';

    if (!fromMoreDetails) {
      if (suggestion != null) {
        setSendingMessage(true);

        final messageModel = Utils.isArabic
            ? suggestion.messageAr
            : suggestion.messageEn;

        message = Utils.isArabic
            ? suggestion.titleAr
            : suggestion.titleEn;

        // Adding the human message
        addMessageContext(
          MessageContextModel(sender: 'human', message: message),
        );

        // Adding the ai message
        addMessageContext(
          MessageContextModel(
            sender: 'ai',
            message: messageModel.reply ?? '',
            serviceCardAID: messageModel.serviceCardAID,
            categoryId: messageModel.categoryId,
          ),
        );

        // Add user message
        addMessage(formMessageEntity(message));

        await Future.delayed(const Duration(milliseconds: 500));

        // Add ready-made bot message
        addMessage(messageModel);

        setSendingMessage(false);

        return;
      } else {
        message = _messageController.text;
      }
    } else {
      message = 'moreDetails'.tr;
    }

    if (message.isEmpty || _sendingMessage) return;

    try {
      setSendingMessage(true);

      // Adding the new message
      addMessage(formMessageEntity(message));

      scrollToBottom();

      // Clear Text Field
      if (suggestion == null) {
        clearMessageTextField();
      }

      // Call the API
      final MessageEntity? recievedMessage = await chatUsecase.call(
        message: message,
        sessionId: _sessionId,
        userId: _userId,
        messageContext: _messageContext,
      );

      _messageContext = [];

      if (recievedMessage != null) {
        recievedMessage.fromZakat = true;
        addMessage(recievedMessage);
      }

      setSendingMessage(false);

      await scrollToBottom();
    } catch (error) {
      addMessage(
        MessageEntity(
          reply: 'genericError'.tr,
          fromZakat: true,
          categoryId: null,
          serviceCardAID: null,
          metadata: null,
          date: null,
          serviceCard: null,
        ),
      );
      setSendingMessage(false);
    }
  }

  void openChatHistory(BuildContext context) {
    if (_loadingExistingChat) return;
    _messagesScaffoldKey.currentState?.openDrawer();
  }

  Future<void> getChatsHistory() async {
    if (loadingChatsHistory ||
        _paginatingChatsHistory ||
        _chatsHistoryPageNumber == -1) {
      return;
    }

    try {
      if (_chatsHistoryPageNumber <= 1) {
        setLoadingChatsHistory(true);
      } else {
        setPaginatingChatsHistory(true);
      }

      final result = await getChatsHistoryUsecase.call(
        userId: _userId,
        pageSize: _chatsPageSize,
        pageNumber: _chatsHistoryPageNumber,
      );

      if (_chatsHistoryPageNumber <= 1) {
        setChatsHistoryInstance(result);
        setLoadingChatsHistory(false);
      } else {
        final existingChats = _chatsHistoryInstance?.chats ?? [];
        final newChats = result?.chats ?? [];

        final combinedChats = [...existingChats, ...newChats];

        _chatsHistoryInstance?.chats = combinedChats;
        setPaginatingChatsHistory(false);
      }

      if (result?.hasNextPage ?? false) {
        setChatsHistoryPageNumber(result?.nextPage ?? -1);
      } else {
        setChatsHistoryPageNumber(-1);
      }
    } catch (error) {
      setLoadingChatsHistory(false);
      if (_chatsHistoryPageNumber <= 1) {
        setLoadingChatsHistory(false);
      } else {
        setPaginatingChatsHistory(false);
      }
      setChatsHistoryPageNumber(-1);

      log('Error here is : ${error.toString()}');
    }
  }

  Future<void> getChatMessagesHistory({
    required String chatSessionId,
    required int pageNumber,
  }) async {
    final fromExistingChat =
        _chatsHistoryInstance?.chats?.firstWhereOrNull(
          (chat) => chat.sessionId == chatSessionId,
        ) !=
        null;

    if (!fromExistingChat ||
        _loadingExistingChat ||
        _paginatingChatMessages ||
        (_chatMessagesPageNumber == -1 && chatSessionId == _sessionId)) {
      return;
    }

    if (chatSessionId != _sessionId) {
      setChatMessagesPageNumber(1);
    }

    _messagesScaffoldKey.currentState?.closeDrawer();

    if (_sessionId == chatSessionId && _loadingExistingChat) return;

    final cachedSessionId = _sessionId;

    setSessionId(chatSessionId);

    try {
      if (_chatMessagesPageNumber <= 1) {
        setLoadingExistingChat(true);
      } else {
        setPaginatingChatMessages(true);
      }

      final result = await getChatMessagesUsecase.call(
        userId: _userId,
        sessionId: chatSessionId,
        pageSize: _chatMessagesPageSize,
        pageNumber: pageNumber,
      );

      if (result?.messages != null) {
        if (_chatMessagesPageNumber <= 1) _messages.clear();

        final data = (result?.messages ?? []).reversed.map((msg) {
          return MessageEntity(
            reply: msg.message,
            categoryId: msg.categoryId,
            serviceCardAID: msg.serviceCardId,
            metadata: MessageMetadataEntity(
              title: msg.title,
              starting: null,
              url: null,
              moreInfo: true,
            ),
            fromZakat: msg.sender == 'ai',
            date: DateTime.tryParse(msg.createdAt ?? '') ?? DateTime.now(),
            serviceCard: msg.serviceCard,
          );
        }).toList();

        _messages = [...data, ..._messages];
      }

      if (_chatMessagesPageNumber <= 1) {
        setLoadingExistingChat(false);
      } else {
        setPaginatingChatMessages(false);
      }

      if (_chatMessagesPageNumber <= 1) {
        await Future.delayed(const Duration(milliseconds: 200), () {
          scrollToBottom();
        });
      }

      if (!_messagesScrollController.hasListeners) {
        addScrollControllerListener(
          paginateFromBottom: false,
          controller: _messagesScrollController,
          callback: () {
            getChatMessagesHistory(
              chatSessionId: chatSessionId,
              pageNumber: _chatMessagesPageNumber,
            );
          },
        );
      }

      if (result?.hasNextPage ?? false) {
        setChatMessagesPageNumber(result?.nextPage ?? -1);
      } else {
        setChatMessagesPageNumber(-1);
      }

      log('_chatMessagesPageNumber = $_chatMessagesPageNumber');
    } catch (error) {
      setSessionId(cachedSessionId);
      if (_chatMessagesPageNumber <= 1) {
        setLoadingExistingChat(false);
      } else {
        setPaginatingChatMessages(false);
      }
    }
  }

  // Starting a new chat
  void startNewChat() {
    _messagesScaffoldKey.currentState?.closeDrawer();

    if (_messages.isEmpty) return;

    _messages.clear();
    setSessionId(
      'zakat_sess_${const Uuid().v4()}_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  void notifyListeners() {
    if (hasListeners) {
      super.notifyListeners();
    }
  }
}
