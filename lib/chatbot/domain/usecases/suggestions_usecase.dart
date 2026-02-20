import 'package:zakat_fund/chatbot/domain/entities/suggestion_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/suggestions_repo.dart';

class SuggestionsUsecase {
  final SuggestionsRepo suggestionsRepo;

  SuggestionsUsecase(this.suggestionsRepo);

  List<SuggestionEntity> call() {
    return suggestionsRepo.getSuggestions();
  }
}
