import 'package:get/get.dart';
import 'package:zakat_fund/model/user_selection_type.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';

class UserSelectionViewModel extends GetxController {
  RxBool donorSelected = false.obs;
  RxInt selectedUserType = 0.obs;
  RxInt selectedSubType = 0.obs;

  final List<UserSelectionType> userTypes = const [
    UserSelectionType(
        icon: AppResources.donorIcon,
        title: "donor",
        subTitle: "donorDetails",
        userType: 1000,
        roleId: 5),
    UserSelectionType(
        icon: AppResources.associationIcon,
        title: "association",
        subTitle: "associationDetails",
        userType: 1001,
        roleId: 3),
  ];

  final List<UserSelectionType> donorSubTypes = const [
    UserSelectionType(
        icon: AppResources.individualIcon,
        title: "individual",
        subTitle: "individualDetails",
        userType: 1000,
        roleId: 5),
    UserSelectionType(
        icon: AppResources.companyIcon,
        title: "company",
        subTitle: "companyDetails",
        userType: 1000,
        roleId: 4),
  ];

  UserSelectionType get selectedUser => donorSelected.value
      ? donorSubTypes[selectedSubType.value]
      : userTypes[selectedUserType.value];

  onPreviousPressed(){
    if (!donorSelected.value) {
      Get.back();
      return;
    }
    donorSelected.value = false;
  }

  onNextPressed(){
    if (selectedUserType.value == 0 && !donorSelected.value) {
      donorSelected.value = true;
    } else {
      final viewModel = Get.find<LogInViewModel>();
      viewModel.uaeSocialMedia(true);
    }
  }

  onChangeUserType(int index){
    if (donorSelected.value) {
      selectedSubType.value = index;
    } else {
      selectedUserType.value = index;
    }
  }

  @override
  void onClose() {
    donorSelected.close();
    selectedUserType.close();
    selectedSubType.close();
    super.onClose();
  }

}
