import 'package:zakat_fund/chatbot/domain/entities/message_service_card_entity.dart';

class ChatMessageEntity {
  String? id;
  String? sessionId;
  String? user;
  String? sender;
  String? title;
  String? message;
  String? categoryId;
  String? serviceCardId;
  String? createdAt;
  MessageServiceCardEntity? serviceCard;

  ChatMessageEntity({
    required this.id,
    required this.sessionId,
    required this.user,
    required this.sender,
    required this.title,
    required this.message,
    required this.categoryId,
    required this.serviceCardId,
    required this.serviceCard,
    required this.createdAt,
  });
}
