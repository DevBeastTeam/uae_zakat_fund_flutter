class AboutUsConfig {
  String? aboutSahemEn;
  String? aboutSahemAr;
  String? missionSubjectEn;
  String? missionSubjectAr;
  String? missionDetailsEn;
  String? missionDetailsAr;
  String? visionDetailsEn;
  String? visionDetailsAr;
  List<AboutUsSection> sections;
  List<CorporateValuesSection> corporateValuesSections;
  List<StrategicGoalsSection> strategicGoalsSections;
  bool isEnableTeamMember;
  List<TeamMember> teamMembers;

  AboutUsConfig({
    this.aboutSahemEn,
    this.aboutSahemAr,
    this.missionSubjectEn,
    this.missionSubjectAr,
    this.missionDetailsEn,
    this.missionDetailsAr,
    this.visionDetailsEn,
    this.visionDetailsAr,
    required this.sections,
    required this.corporateValuesSections,
    required this.strategicGoalsSections,
    required this.isEnableTeamMember,
    required this.teamMembers,
  });

  factory AboutUsConfig.fromJson(List<dynamic> data) {
    Map<String, String> configMap = {};
    for (var item in data) {
      configMap[item['key']] = item['value'] ?? '';
    }

    return AboutUsConfig(
      aboutSahemEn: configMap['AboutSahemEn'],
      aboutSahemAr: configMap['AboutSahemAr'],
      missionSubjectEn: configMap['MissionSubjectEn'],
      missionSubjectAr: configMap['MissionSubjectAr'],
      missionDetailsEn: configMap['MissionDetailsEn'],
      missionDetailsAr: configMap['MissionDetailsAr'],
      visionDetailsEn: configMap['VisionDetailsEn'],
      visionDetailsAr: configMap['VisionDetailsAr'],
      sections: _parseSections(configMap),
      corporateValuesSections: _parseCorporateValues(configMap),
      strategicGoalsSections: _parseStrategicGoals(configMap),
      isEnableTeamMember: configMap['isEnableTeamMember'] == 'true',
      teamMembers: _parseTeamMembers(configMap),
    );
  }

  static List<AboutUsSection> _parseSections(Map<String, String> configMap) {
    List<AboutUsSection> sections = [];
    int index = 0;
    while (configMap.containsKey('sections[$index].SectionHeadingEn')) {
      sections.add(AboutUsSection(
        sectionHeadingEn: configMap['sections[$index].SectionHeadingEn'],
        sectionHeadingAr: configMap['sections[$index].SectionHeadingAr'],
        sectionDetailsEn: configMap['sections[$index].SectionDetailsEn'],
        sectionDetailsAr: configMap['sections[$index].SectionDetailsAr'],
        sectionImage: configMap['sections[$index].SectionImage'],
      ));
      index++;
    }
    return sections;
  }

  static List<CorporateValuesSection> _parseCorporateValues(Map<String, String> configMap) {
    List<CorporateValuesSection> sections = [];
    int index = 0;
    while (configMap.containsKey('corporateValuesSections[$index].CorporateValuesHeadingEn')) {
      sections.add(CorporateValuesSection(
        headingEn: configMap['corporateValuesSections[$index].CorporateValuesHeadingEn'],
        headingAr: configMap['corporateValuesSections[$index].CorporateValuesHeadingAr'],
        detailsEn: configMap['corporateValuesSections[$index].CorporateValuesDetailsEn'],
        detailsAr: configMap['corporateValuesSections[$index].CorporateValuesDetailsAr'],
      ));
      index++;
    }
    return sections;
  }

  static List<StrategicGoalsSection> _parseStrategicGoals(Map<String, String> configMap) {
    List<StrategicGoalsSection> sections = [];
    int index = 0;
    while (configMap.containsKey('strategicGoalsSections[$index].StrategicGoalsDetailsEn')) {
      sections.add(StrategicGoalsSection(
        detailsEn: configMap['strategicGoalsSections[$index].StrategicGoalsDetailsEn'],
        detailsAr: configMap['strategicGoalsSections[$index].StrategicGoalsDetailsAr'],
      ));
      index++;
    }
    return sections;
  }

  static List<TeamMember> _parseTeamMembers(Map<String, String> configMap) {
    List<TeamMember> members = [];
    int index = 0;
    while (configMap.containsKey('teamMembers[$index].OurTeamMemberNameEn')) {
      members.add(TeamMember(
        nameEn: configMap['teamMembers[$index].OurTeamMemberNameEn'],
        nameAr: configMap['teamMembers[$index].OurTeamMemberNameAr'],
        jobTitleEn: configMap['teamMembers[$index].OurTeamMemberJobTitleEn'],
        jobTitleAr: configMap['teamMembers[$index].OurTeamMemberJobTitleAr'],
        image: configMap['teamMembers[$index].OurTeamMemberImage'],
      ));
      index++;
    }
    return members;
  }
}

class AboutUsSection {
  String? sectionHeadingEn;
  String? sectionHeadingAr;
  String? sectionDetailsEn;
  String? sectionDetailsAr;
  String? sectionImage;

  AboutUsSection({
    this.sectionHeadingEn,
    this.sectionHeadingAr,
    this.sectionDetailsEn,
    this.sectionDetailsAr,
    this.sectionImage,
  });
}

class CorporateValuesSection {
  String? headingEn;
  String? headingAr;
  String? detailsEn;
  String? detailsAr;

  CorporateValuesSection({
    this.headingEn,
    this.headingAr,
    this.detailsEn,
    this.detailsAr,
  });
}

class StrategicGoalsSection {
  String? detailsEn;
  String? detailsAr;

  StrategicGoalsSection({
    this.detailsEn,
    this.detailsAr,
  });
}

class TeamMember {
  String? nameEn;
  String? nameAr;
  String? jobTitleEn;
  String? jobTitleAr;
  String? image;

  TeamMember({
    this.nameEn,
    this.nameAr,
    this.jobTitleEn,
    this.jobTitleAr,
    this.image,
  });
}
