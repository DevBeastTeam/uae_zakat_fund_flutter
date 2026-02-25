class CashNotes {
  int notes, amount, totalAmount;

  CashNotes({
    required this.notes,
    required this.amount,
    required this.totalAmount,
  });

  factory CashNotes.fromJson(Map<String, dynamic> json) => CashNotes(
    notes: json["notes"],
    amount: json["amount"],
    totalAmount: json["totalAmount"],
  );

}
