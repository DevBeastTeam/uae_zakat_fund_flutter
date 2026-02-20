class MyWallet {
  double availableBalance;
  List<WalletTopupDetail> walletTopupDetail;

  MyWallet({
    required this.availableBalance,
    required this.walletTopupDetail,
  });

  factory MyWallet.fromJson(Map<String, dynamic> json) => MyWallet(
    availableBalance: json["availableBalance"]??0,
    walletTopupDetail: json["walletTopupDetail"]==null?[]:List<WalletTopupDetail>.from(json["walletTopupDetail"].map((x) => WalletTopupDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "availableBalance": availableBalance,
    "walletTopupDetail": List<dynamic>.from(walletTopupDetail.map((x) => x.toJson())),
  };
}

class WalletTopupDetail {
  String transactionId;
  DateTime date;
  double amount;
  double refundAmount;
  int paymentMethod;

  WalletTopupDetail({
    required this.transactionId,
    required this.date,
    required this.amount,
    required this.refundAmount,
    required this.paymentMethod,
  });

  factory WalletTopupDetail.fromJson(Map<String, dynamic> json) => WalletTopupDetail(
    transactionId: json["transactionId"],
    date: DateTime.parse(json["date"]),
    amount: json["amount"]??0,
    refundAmount: json["refundAmount"]??0,
    paymentMethod: json["paymentMethod"],
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "date": date.toIso8601String(),
    "amount": amount,
    "refundAmount": refundAmount,
    "paymentMethod": paymentMethod,
  };
}
