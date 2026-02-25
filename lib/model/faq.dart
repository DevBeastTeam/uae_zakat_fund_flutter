class FaqCategory {
  int categoryId;
  String title;
  String titleArabic;

  FaqCategory({
    required this.categoryId,
    required this.title,
    required this.titleArabic,
  });

  factory FaqCategory.fromJson(Map<String, dynamic> json) => FaqCategory(
        categoryId: json["categoryId"],
        title: json["title"],
        titleArabic: json["titleArabic"],
      );
}

class FaQs {
  int id;
  int categoryId;
  String question;
  String questionArabic;
  String answer;
  String answerArabic;
  bool isExpanded;
  int requestStatus;
  DateTime? createdDate;
  DateTime? publishDate;
  bool isActive;

  FaQs({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.questionArabic,
    required this.answer,
    required this.answerArabic,
    required this.requestStatus,
    required  this.isActive,
    this.isExpanded = false,
    this.createdDate,
    this.publishDate,
  });

  factory FaQs.fromJson(Map<String, dynamic> json) => FaQs(
        id: json["id"],
        categoryId: json["categoryId"],
        question: json["question"]??"",
        questionArabic: json["questionArabic"]??"",
        answer: json["answer"]??"",
        answerArabic: json["answerArabic"]??"",
    requestStatus: json["requestStatus"],
        isExpanded: false,
    isActive: json["isActive"]??false,
    createdDate: json["createdDate"]!=null?DateTime.parse(json["createdDate"]):null,
    publishDate: json["publishDate"]!=null?DateTime.parse(json["publishDate"]):null,

      );


  Map<String, dynamic> toJson({bool check=true}) => {
    "id": id,
    "categoryId": categoryId,
    "question": question,
    "questionArabic": questionArabic,
    "answer": answer,
    "answerArabic": answerArabic,
    "requestStatus": requestStatus,
    if(check)"isExpanded": isExpanded,
    "createdDate": createdDate?.toIso8601String(),
    "publishDate": publishDate?.toIso8601String(),
  };

}
