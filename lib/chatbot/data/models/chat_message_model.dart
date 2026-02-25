import 'package:zakat_fund/chatbot/data/models/message_service_card_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.sessionId,
    required super.user,
    required super.sender,
    required super.message,
    required super.title,
    required super.categoryId,
    required super.serviceCardId,
    required super.serviceCard,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['_id'],
      sessionId: json['sessionId'],
      user: json['user'],
      sender: json['sender'],
      message: json['message'],
      title: json['title'],
      categoryId: json['categoryId'],
      serviceCardId: json['serviceCardId'],
      serviceCard: json['serviceCard'] != null
          ? MessageServiceCardModel.fromJson(json['serviceCard'] ?? {})
          : null,
      createdAt:
          (DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
                  DateTime.now().toString())
              .toString(),
    );
  }
}
