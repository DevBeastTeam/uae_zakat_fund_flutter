class MessageContextEntity {
  final String sender;
  final String message;
  final String? serviceCardAID;
  final String? categoryId;

  const MessageContextEntity({
    required this.sender,
    required this.message,
    this.serviceCardAID,
    this.categoryId,
  });
}
