import 'package:get/get.dart';

class UserEngagementInteraction {
  List<UserActivityOverview> userActivityOverview;
  List<PreferredLoginPeriod> preferredLoginPeriods;
  List<PreferredLoginDay> preferredLoginDays;
  List<WeekdayWeekendLogin> weekdayWeekendLogins;
  List<LowestActivityTimesWeek> lowestActivityTimesWeekdays;
  List<LowestActivityTimesWeek> lowestActivityTimesWeekends;

  UserEngagementInteraction({
    required this.userActivityOverview,
    required this.preferredLoginPeriods,
    required this.preferredLoginDays,
    required this.weekdayWeekendLogins,
    required this.lowestActivityTimesWeekdays,
    required this.lowestActivityTimesWeekends,
  });

  factory UserEngagementInteraction.fromJson(Map<String, dynamic> json) => UserEngagementInteraction(
    userActivityOverview: List<UserActivityOverview>.from(json["userActivityOverview"].map((x) => UserActivityOverview.fromJson(x))),
    preferredLoginPeriods: json["preferredLoginPeriods"]==null?[]:List<PreferredLoginPeriod>.from(json["preferredLoginPeriods"].map((x) => PreferredLoginPeriod.fromJson(x))),
    preferredLoginDays: json["preferredLoginDays"]==null?[]:List<PreferredLoginDay>.from(json["preferredLoginDays"].map((x) => PreferredLoginDay.fromJson(x))),
    weekdayWeekendLogins:json["weekdayWeekendLogins"]==null?[]: List<WeekdayWeekendLogin>.from(json["weekdayWeekendLogins"].map((x) => WeekdayWeekendLogin.fromJson(x))),
    lowestActivityTimesWeekdays: json["lowestActivityTimesWeekdays"]==null?[]:List<LowestActivityTimesWeek>.from(json["lowestActivityTimesWeekdays"].map((x) => LowestActivityTimesWeek.fromJson(x))),
    lowestActivityTimesWeekends: json["lowestActivityTimesWeekends"]==null?[]:List<LowestActivityTimesWeek>.from(json["lowestActivityTimesWeekends"].map((x) => LowestActivityTimesWeek.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userActivityOverview": List<dynamic>.from(userActivityOverview.map((x) => x.toJson())),
    "preferredLoginPeriods": List<dynamic>.from(preferredLoginPeriods.map((x) => x.toJson())),
    "preferredLoginDays": List<dynamic>.from(preferredLoginDays.map((x) => x.toJson())),
    "weekdayWeekendLogins": List<dynamic>.from(weekdayWeekendLogins.map((x) => x.toJson())),
    "lowestActivityTimesWeekdays": List<dynamic>.from(lowestActivityTimesWeekdays.map((x) => x.toJson())),
    "lowestActivityTimesWeekends": List<dynamic>.from(lowestActivityTimesWeekends.map((x) => x.toJson())),
  };
}

class LowestActivityTimesWeek {
  String dayType;
  String timeRange;
  int logins;

  LowestActivityTimesWeek({
    required this.dayType,
    required this.timeRange,
    required this.logins,
  });

  factory LowestActivityTimesWeek.fromJson(Map<String, dynamic> json) => LowestActivityTimesWeek(
    dayType: json["dayType"]??"",
    timeRange: json["timeRange"]??"",
    logins: json["logins"],
  );

  Map<String, dynamic> toJson() => {
    "dayType": dayType,
    "timeRange": timeRange,
    "logins": logins,
  };
}

class PreferredLoginDay {
  String preferredLoginDay;
  int logins;

  PreferredLoginDay({
    required this.preferredLoginDay,
    required this.logins,
  });

  factory PreferredLoginDay.fromJson(Map<String, dynamic> json) => PreferredLoginDay(
    preferredLoginDay: json["preferredLoginDay"].toString().toLowerCase().tr,
    logins: json["logins"],
  );

  Map<String, dynamic> toJson() => {
    "preferredLoginDay": preferredLoginDay,
    "logins": logins,
  };
}

class PreferredLoginPeriod {
  String preferredLoginPeriod;
  int logins;

  PreferredLoginPeriod({
    required this.preferredLoginPeriod,
    required this.logins,
  });

  factory PreferredLoginPeriod.fromJson(Map<String, dynamic> json) => PreferredLoginPeriod(
    preferredLoginPeriod: json["preferredLoginPeriod"]??"",
    logins: json["logins"]??0,
  );

  Map<String, dynamic> toJson() => {
    "preferredLoginPeriod": preferredLoginPeriod,
    "logins": logins,
  };
}

class UserActivityOverview {
  int userActivityOverview;

  UserActivityOverview({
    required this.userActivityOverview,
  });

  factory UserActivityOverview.fromJson(Map<String, dynamic> json) => UserActivityOverview(
    userActivityOverview: json["userActivityOverview"],
  );

  Map<String, dynamic> toJson() => {
    "userActivityOverview": userActivityOverview,
  };
}

class WeekdayWeekendLogin {
  String loginType;
  int logins;

  WeekdayWeekendLogin({
    required this.loginType,
    required this.logins,
  });

  factory WeekdayWeekendLogin.fromJson(Map<String, dynamic> json) => WeekdayWeekendLogin(
    loginType: json["loginType"],
    logins: json["logins"],
  );

  Map<String, dynamic> toJson() => {
    "loginType": loginType,
    "logins": logins,
  };
}

class FeedbacksSummary {
  int totalFeedback;
  int complaint;
  int suggestion;

  FeedbacksSummary({
    required this.totalFeedback,
    required this.complaint,
    required this.suggestion,
  });

  factory FeedbacksSummary.fromJson(Map<String, dynamic> json) => FeedbacksSummary(
    totalFeedback: json["totalFeedback"],
    complaint: json["complaint"],
    suggestion: json["suggestion"],
  );

  Map<String, dynamic> toJson() => {
    "totalFeedback": totalFeedback,
    "complaint": complaint,
    "suggestion": suggestion,
  };
}

class SurveysSummary {
  int totalSurvey;
  int active;
  int completed;

  SurveysSummary({
    required this.totalSurvey,
    required this.active,
    required this.completed,
  });

  factory SurveysSummary.fromJson(Map<String, dynamic> json) => SurveysSummary(
    totalSurvey: json["totalSurvey"],
    active: json["active"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "totalSurvey": totalSurvey,
    "active": active,
    "completed": completed,
  };
}

class CategoryRating {
  String contentType;
  int yesRatings;
  int noRatings;

  CategoryRating({
    required this.contentType,
    required this.yesRatings,
    required this.noRatings,
  });

  factory CategoryRating.fromJson(Map<String, dynamic> json) => CategoryRating(
    contentType: json["contentType"],
    yesRatings: json["yesRatings"],
    noRatings: json["noRatings"],
  );

  Map<String, dynamic> toJson() => {
    "contentType": contentType,
    "yesRatings": yesRatings,
    "noRatings": noRatings,
  };
}

class UserTypeRating {
  String name;
  String nameAr;
  int yesRatings;
  int noRatings;

  UserTypeRating({
    required this.name,
    required this.nameAr,
    required this.yesRatings,
    required this.noRatings,
  });

  factory UserTypeRating.fromJson(Map<String, dynamic> json) => UserTypeRating(
    name: json["name"]??"",
    nameAr: json["nameAr"]??"",
    yesRatings: json["yesRatings"],
    noRatings: json["noRatings"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "nameAr": nameAr,
    "yesRatings": yesRatings,
    "noRatings": noRatings,
  };
}

class CategoryRatingDetails {
  String titleEn;
  String titleAr;
  int yesRatings;
  int noRatings;

  CategoryRatingDetails({
    required this.titleEn,
    required this.titleAr,
    required this.yesRatings,
    required this.noRatings,
  });

  factory CategoryRatingDetails.fromJson(Map<String, dynamic> json) => CategoryRatingDetails(
    titleEn: json["titleEN"],
    titleAr: json["titleAR"],
    yesRatings: json["yesRatings"],
    noRatings: json["noRatings"],
  );

  Map<String, dynamic> toJson() => {
    "titleEN": titleEn,
    "titleAR": titleAr,
    "yesRatings": yesRatings,
    "noRatings": noRatings,
  };
}
