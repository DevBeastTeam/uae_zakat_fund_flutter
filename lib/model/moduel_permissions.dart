class ModulePermissions {
  int roleId;
  List<Module> modules;

  ModulePermissions({
    required this.roleId,
    required this.modules,
  });

  factory ModulePermissions.fromJson(Map<String, dynamic> json) => ModulePermissions(
    roleId: json["roleId"],
    modules: List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roleId": roleId,
    "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
  };
}

class Module {
  int moduleId;
  String moduleNameEn;
  String moduleNameAr;
  int? parentModuleId;
  String moduleCode;
  List<ModulePermission> modulePermission;

  Module({
    required this.moduleId,
    required this.moduleNameEn,
    required this.moduleNameAr,
    required this.parentModuleId,
    required this.moduleCode,
    required this.modulePermission,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    moduleId: json["moduleId"],
    moduleNameEn: json["moduleNameEN"],
    moduleNameAr: json["moduleNameAR"],
    parentModuleId: json["parentModuleId"],
    moduleCode: json["moduleCode"],
    modulePermission: List<ModulePermission>.from(json["modulePermission"].map((x) => ModulePermission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "moduleId": moduleId,
    "moduleNameEN": moduleNameEn,
    "moduleNameAR": moduleNameAr,
    "parentModuleId": parentModuleId,
    "moduleCode": moduleCode,
    "modulePermission": List<dynamic>.from(modulePermission.map((x) => x.toJson())),
  };
}

class ModulePermission {
  int permissionId;
  String permissionNameEn;
  dynamic permissionNameAr;
  dynamic actionEn;
  dynamic actionAr;
  dynamic description;
  dynamic moduleId;
  dynamic isEnabled;

  ModulePermission({
    required this.permissionId,
    required this.permissionNameEn,
    required this.permissionNameAr,
    required this.actionEn,
    required this.actionAr,
    required this.description,
    required this.moduleId,
    required this.isEnabled,
  });

  factory ModulePermission.fromJson(Map<String, dynamic> json) => ModulePermission(
    permissionId: json["permissionId"],
    permissionNameEn: json["permissionNameEN"],
    permissionNameAr: json["permissionNameAR"],
    actionEn: json["actionEN"],
    actionAr: json["actionAR"],
    description: json["description"],
    moduleId: json["moduleId"],
    isEnabled: json["isEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "permissionId": permissionId,
    "permissionNameEN": permissionNameEn,
    "permissionNameAR": permissionNameAr,
    "actionEN": actionEn,
    "actionAR": actionAr,
    "description": description,
    "moduleId": moduleId,
    "isEnabled": isEnabled,
  };
}
