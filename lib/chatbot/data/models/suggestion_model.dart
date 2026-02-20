import 'package:zakat_fund/chatbot/domain/entities/suggestion_entity.dart';

class SuggestionModel extends SuggestionEntity {
  const SuggestionModel({
    required super.id,
    required super.titleAr,
    required super.titleEn,
    required super.messageAr,
    required super.messageEn,
  });
}
