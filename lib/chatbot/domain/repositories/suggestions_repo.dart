import 'package:zakat_fund/chatbot/domain/entities/suggestion_entity.dart';

abstract class SuggestionsRepo {
  List<SuggestionEntity> getSuggestions();
}
