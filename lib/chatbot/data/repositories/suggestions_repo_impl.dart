import 'package:zakat_fund/chatbot/data/data_sources/suggestions_data_source.dart';
import 'package:zakat_fund/chatbot/domain/entities/suggestion_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/suggestions_repo.dart';

class SuggestionsRepoImpl extends SuggestionsRepo {
  final SuggestionsDataSource suggestionsDataSource;

  SuggestionsRepoImpl({required this.suggestionsDataSource});

  @override
  List<SuggestionEntity> getSuggestions() {
    return suggestionsDataSource.getSuggestions();
  }
}
