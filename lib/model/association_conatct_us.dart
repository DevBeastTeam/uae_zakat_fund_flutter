class AssociationContactUs {
  int contactId;
  String email;
  String name;
  String message;
  int associationId;

  AssociationContactUs({
    required this.contactId,
    required this.email,
    required this.name,
    required this.message,
    required this.associationId,
  });

  factory AssociationContactUs.fromJson(Map<String, dynamic> json) =>
      AssociationContactUs(
        contactId: json["contactId"],
        email: json["email"],
        name: json["name"],
        message: json["message"],
        associationId: json["associationId"],
      );

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "email": email,
        "name": name,
        "message": message,
        "associationId": associationId,
      };
}
