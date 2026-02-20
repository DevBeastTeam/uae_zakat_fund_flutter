import 'package:zakat_fund/chatbot/domain/entities/message_context_entity.dart';

class MessageContextModel extends MessageContextEntity {
  MessageContextModel({
    required super.sender,
    required super.message,
    super.serviceCardAID,
    super.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      if (serviceCardAID != null) 'serviceCardAID': serviceCardAID,
      if (categoryId != null) 'category_id': categoryId,
    };
  }
}
