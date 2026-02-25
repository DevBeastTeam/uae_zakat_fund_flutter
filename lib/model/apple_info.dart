import 'package:hive/hive.dart';

part 'apple_info.g.dart';
@HiveType(typeId: 3)
class AppleInfo {
  @HiveField(1)
  dynamic firstName;
  @HiveField(2)
  dynamic lastName;
  @HiveField(3)
  dynamic email;
  @HiveField(4)
  dynamic identifier;

  AppleInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.identifier,
  });

  factory AppleInfo.fromJson(Map<String, dynamic> json) => AppleInfo(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    identifier: json["identifier"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "identifier": identifier,
  };
}
