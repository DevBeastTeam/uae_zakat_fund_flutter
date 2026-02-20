import 'package:zakat_fund/chatbot/data/models/message_metadata_model.dart';
import 'package:zakat_fund/chatbot/data/models/message_service_card_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.reply,
    required super.categoryId,
    required super.serviceCardAID,
    required super.metadata,
    required super.fromZakat,
    required super.date,
    required super.serviceCard,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final metadata = MessageMetadataModel.fromJson(json['metadata'] ?? {});

    return MessageModel(
      reply: json['reply'],
      fromZakat: true,
      categoryId: json['category_id']?.toString(),
      serviceCardAID: json['serviceCardAID']?.toString(),
      metadata: metadata,
      date: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
                DateTime.now()
          : DateTime.now(),
      serviceCard: json['serviceCard'] != null
          ? MessageServiceCardModel.fromJson(json['serviceCard'] ?? {})
          : null,
    );
  }
}
