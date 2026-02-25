class TaskReceipt {
  String paymentType;
  String donorName;
  String address;
  String requestId;
  String date;
  String collectionTime;
  String amount;

  TaskReceipt({
    required this.paymentType,
    required this.donorName,
    required this.address,
    required this.requestId,
    required this.date,
    required this.collectionTime,
    required this.amount,
  });
}
