import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/about_sahem.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/smtp_config.dart';
import 'package:zakat_fund/repository/about_sahem_repo.dart';
import 'package:zakat_fund/utils/utils.dart';

class AboutSahemViewModel extends GetxController {
  List<SmtpConfig> aboutSahemList = [];
  final repo = AboutSahemRepoImpl();
  Rxn<AboutSahem> aboutSahem = Rxn<AboutSahem>();

  @override
  void onInit() {
    _fetchAboutSahem();
    super.onInit();
  }

  _fetchAboutSahem() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.aboutSahem(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      aboutSahemList = apiResponse.data;
      _setAboutSahemData();
    } else {
      Utils.showGlobalSnackBar(message: apiResponse.message ?? "");
    }
  }

  _setAboutSahemData() {
    String aboutEn = _getValue("AboutSahemEn");
    String aboutAr = _getValue("AboutSahemAr");
    String missionSubjectEn = _getValue("MissionSubjectEn");
    String missionSubjectAr = _getValue("MissionSubjectAr");
    String missionDetailsEn = _getValue("MissionDetailsEn");
    String missionDetailsAr = _getValue("MissionDetailsAr");
    String visionDetailsEn = _getValue("VisionDetailsEn");
    String visionDetailsAr = _getValue("VisionDetailsAr");

    List<Section> sections = [];
    for (int i = 0; i < 10; i++) {
      if (_getValue("sections[$i].SectionHeadingEn") != "") {
        sections.add(Section(
          headingEn: _getValue("sections[$i].SectionHeadingEn"),
          headingAr: _getValue("sections[$i].SectionHeadingAr"),
          detailsEn: _getValue("sections[$i].SectionDetailsEn"),
          detailsAr: _getValue("sections[$i].SectionDetailsAr"),
          image: _getValue("sections[$i].SectionImage"),
        ));
      }
    }

    List<CorporateValue> corporateValues = [];
    for (int i = 0; i < 10; i++) {
      if (_getValue("corporateValuesSections[$i].CorporateValuesHeadingEn") !=
          "") {
        corporateValues.add(CorporateValue(
          headingEn:
              _getValue("corporateValuesSections[$i].CorporateValuesHeadingEn"),
          headingAr:
              _getValue("corporateValuesSections[$i].CorporateValuesHeadingAr"),
          detailsEn:
              _getValue("corporateValuesSections[$i].CorporateValuesDetailsEn"),
          detailsAr:
              _getValue("corporateValuesSections[$i].CorporateValuesDetailsAr"),
        ));
      }
    }

    List<StrategicGoal> strategicGoals = [];
    for (int i = 0; i < 10; i++) {
      if (_getValue("strategicGoalsSections[$i].StrategicGoalsDetailsEn") !=
          "") {
        strategicGoals.add(StrategicGoal(
          detailsEn:
              _getValue("strategicGoalsSections[$i].StrategicGoalsDetailsEn"),
          detailsAr:
              _getValue("strategicGoalsSections[$i].StrategicGoalsDetailsAr"),
        ));
      }
    }

    List<TeamMember> teamMembers = [];
    for (int i = 0; i < 10; i++) {
      if (_getValue("teamMembers[$i].OurTeamMemberNameEn") != "") {
        teamMembers.add(TeamMember(
          nameEn: _getValue("teamMembers[$i].OurTeamMemberNameEn"),
          nameAr: _getValue("teamMembers[$i].OurTeamMemberNameAr"),
          jobTitleEn: _getValue("teamMembers[$i].OurTeamMemberJobTitleEn"),
          jobTitleAr: _getValue("teamMembers[$i].OurTeamMemberJobTitleAr"),
          image: _getValue("teamMembers[$i].OurTeamMemberImage"),
        ));
      }
    }

    aboutSahem.value = AboutSahem(
      aboutEn: aboutEn,
      aboutAr: aboutAr,
      missionSubjectEn: missionSubjectEn,
      missionSubjectAr: missionSubjectAr,
      missionDetailsEn: missionDetailsEn,
      missionDetailsAr: missionDetailsAr,
      visionDetailsEn: visionDetailsEn,
      visionDetailsAr: visionDetailsAr,
      sections: sections,
      corporateValues: corporateValues,
      strategicGoals: strategicGoals,
      teamMembers: teamMembers,
    );
  }

  String _getValue(String key) {
    return aboutSahemList.firstWhereOrNull((data) => data.key == key)?.value ??
        "";
  }

  @override
  void onClose() {
    aboutSahem.close();

    super.onClose();
  }
}
