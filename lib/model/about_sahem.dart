class AboutSahem {
  final String aboutEn;
  final String aboutAr;
  final String missionSubjectEn;
  final String missionSubjectAr;
  final String missionDetailsEn;
  final String missionDetailsAr;
  final String visionDetailsEn;
  final String visionDetailsAr;
  final List<Section> sections;
  final List<CorporateValue> corporateValues;
  final List<StrategicGoal> strategicGoals;
  final List<TeamMember> teamMembers;

  AboutSahem({
    required this.aboutEn,
    required this.aboutAr,
    required this.missionSubjectEn,
    required this.missionSubjectAr,
    required this.missionDetailsEn,
    required this.missionDetailsAr,
    required this.visionDetailsEn,
    required this.visionDetailsAr,
    required this.sections,
    required this.corporateValues,
    required this.strategicGoals,
    required this.teamMembers,
  });
}


class Section {
  final String headingEn;
  final String headingAr;
  final String detailsEn;
  final String detailsAr;
  final String image;

  Section({
    required this.headingEn,
    required this.headingAr,
    required this.detailsEn,
    required this.detailsAr,
    required this.image,
  });
}

class CorporateValue {
  final String headingEn;
  final String headingAr;
  final String detailsEn;
  final String detailsAr;

  CorporateValue({
    required this.headingEn,
    required this.headingAr,
    required this.detailsEn,
    required this.detailsAr,
  });
}

class StrategicGoal {
  final String detailsEn;
  final String detailsAr;

  StrategicGoal({
    required this.detailsEn,
    required this.detailsAr,
  });
}

class TeamMember {
  final String nameEn;
  final String nameAr;
  final String jobTitleEn;
  final String jobTitleAr;
  final String image;

  TeamMember({
    required this.nameEn,
    required this.nameAr,
    required this.jobTitleEn,
    required this.jobTitleAr,
    required this.image,
  });
}
