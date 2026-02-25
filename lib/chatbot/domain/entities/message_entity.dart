import 'package:zakat_fund/chatbot/domain/entities/message_metadata_entity.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_service_card_entity.dart';

class MessageEntity {
  String? reply;
  String? categoryId;
  String? serviceCardAID;
  MessageMetadataEntity? metadata;
  bool? fromZakat;
  DateTime? date;
  MessageServiceCardEntity? serviceCard;

  MessageEntity({
    required this.reply,
    required this.categoryId,
    required this.serviceCardAID,
    required this.metadata,
    required this.fromZakat,
    required this.date,
    required this.serviceCard,
  });
}
