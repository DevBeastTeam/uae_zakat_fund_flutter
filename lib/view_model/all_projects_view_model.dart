import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/utils.dart';

class AllProjectsViewModel extends GetxController{

  List<ProjectElements> allProjects = [];
  RxList<ProjectElements> projects = <ProjectElements>[].obs;
  final searchController = TextEditingController();


  @override
  void onInit() {
    var data = Get.arguments;
    if(data["title"]!=null){
      allProjects = data["projects"];
    }else{
      allProjects = data;
    }
    projects.value = List.from(allProjects);
    super.onInit();
  }

  filterProjects(){
   String value = searchController.text;
    if(value.trim().isEmpty){
      projects.value = List.from(allProjects);
      return;
    }
    projects.value = allProjects.where((project) {
      String name = Utils.isArabic?project.projectNameArabic:project.projectName;
      return name.toLowerCase().contains(value.toLowerCase());
    }).toList();
  }

  @override
  void onClose() {
    searchController.dispose();

    projects.close();

    super.onClose();
  }

}