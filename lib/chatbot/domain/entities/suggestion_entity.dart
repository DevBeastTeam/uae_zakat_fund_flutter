import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';

class SuggestionEntity {
  final int id;
  final String titleAr;
  final String titleEn;
  final MessageEntity messageAr;
  final MessageEntity messageEn;

  const SuggestionEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.messageAr,
    required this.messageEn,
  });
}
