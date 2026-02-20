import 'package:zakat_fund/chatbot/domain/entities/message_service_card_entity.dart';

class MessageServiceCardModel extends MessageServiceCardEntity {
  MessageServiceCardModel({
    required super.serviceCardAID,
    required super.serviceNameEn,
    required super.serviceNameAr,
    required super.desc,
    required super.key,
    required super.serviceCode,
    required super.name,
  });

  factory MessageServiceCardModel.fromJson(Map<String, dynamic> json) {
    return MessageServiceCardModel(
      serviceCardAID: json['serviceCardAID'],
      serviceNameEn: json['serviceNameEn'],
      serviceNameAr: json['serviceNameAr'],
      desc: json['desc'],
      key: json['key'],
      serviceCode: json['service_code'],
      name: json['name'],
    );
  }
}
