class FundRequest {
  int associationId;
  int fundTransferDetailId;
  String associationName;
  String associationNameAr;
  double availableAmount;
  double requestedAmount;
  BankAccount bankAccount;

  FundRequest({
    required this.associationId,
    required this.fundTransferDetailId,
    required this.associationName,
    required this.associationNameAr,
    required this.availableAmount,
    required this.requestedAmount,
    required this.bankAccount,
  });

  factory FundRequest.fromJson(Map<String, dynamic> json) => FundRequest(
    associationId: json["associationId"],
    fundTransferDetailId: json["fundTransferDetailId"],
    associationName: json["associationName"],
    associationNameAr: json["associationNameAr"],
    availableAmount: json["availableAmount"],
    requestedAmount: json["requestedAmount"],
    bankAccount: BankAccount.fromJson(json["bankAccount"]),
  );

}

class BankAccount {
  int id;
  int accountId;
  String bankName;
  String swiftCode;
  String iban;
  dynamic bankNameNew;

  BankAccount({
    required this.id,
    required this.accountId,
    required this.bankName,
    required this.swiftCode,
    required this.iban,
    required this.bankNameNew,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
    id: json["id"],
    accountId: json["accountID"],
    bankName: json["bankName"],
    swiftCode: json["swiftCode"],
    iban: json["iban"],
    bankNameNew: json["bankNameNew"]??"",
  );


}

class FundRequestDetails {
  int associationId;
  int? sahemBankAccountId;

  FundRequestDetails({
    required this.associationId,
    required this.sahemBankAccountId,
  });

  factory FundRequestDetails.fromJson(Map<String, dynamic> json) => FundRequestDetails(
    associationId: json["associationId"],
    sahemBankAccountId: json["sahemBankAccountId"],
  );

}
