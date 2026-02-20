
class Survey {
  int id;
  String surveyName;
  String pageLink;
  int responseLimit;
  int languageCode;
  String description;
  String instructions;
  int requestStatus;

  Survey({
    required this.id,
    required this.surveyName,
    required this.pageLink,
    required this.responseLimit,
    required this.languageCode,
    required this.description,
    required this.instructions,
    required this.requestStatus,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
    id: json["id"],
    surveyName: json["surveyName"]??"",
    pageLink: json["pageLink"]??"",
    responseLimit: json["responseLimit"]??0,
    languageCode: json["languageCode"]??1,
    description: json["description"]??"",
    instructions: json["instructions"]??"",
    requestStatus: json["requestStatus"],
  );
}
