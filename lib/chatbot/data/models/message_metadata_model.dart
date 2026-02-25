
import 'package:zakat_fund/chatbot/domain/entities/message_metadata_entity.dart';

class MessageMetadataModel extends MessageMetadataEntity {
  MessageMetadataModel({
    required super.title,
    required super.starting,
    required super.url,
    required super.moreInfo,
  });

  factory MessageMetadataModel.fromJson(Map<String, dynamic> json) {
    return MessageMetadataModel(
      title: json['title'],
      starting: json['starting'],
      url: json['url'],
      moreInfo: json['more_info'],
    );
  }
}
