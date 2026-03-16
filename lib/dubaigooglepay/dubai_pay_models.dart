class DubaiPayHeader {
  final String spCode;
  final String servCode;
  final String paymentMode;
  final String paymentType;

  DubaiPayHeader({
    required this.spCode,
    required this.servCode,
    this.paymentMode = "EPAY",
    this.paymentType = "GOOGLE_PAY",
  });

  Map<String, dynamic> toJson() => {
        "spCode": spCode,
        "servCode": servCode,
        "paymentMode": paymentMode,
        "paymentType": paymentType,
      };
}

class TransactionInfo {
  final String spCode;
  final String servCode;
  final String? spTrn;
  final String? amount;
  final String? timestamp;
  final String? channel;
  final String? description;
  final String? type;
  final String? version;
  final String? email;
  final String? mobileNo;

  TransactionInfo({
    required this.spCode,
    required this.servCode,
    this.spTrn,
    this.amount,
    this.timestamp,
    this.channel = "104", // 104 for mobile
    this.description,
    this.type = "sale",
    this.version,
    this.email,
    this.mobileNo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "spCode": spCode,
      "servCode": servCode,
    };
    if (spTrn != null) data["spTrn"] = spTrn;
    if (amount != null) data["amount"] = amount;
    if (timestamp != null) data["timestamp"] = timestamp;
    if (channel != null) data["channel"] = channel;
    if (description != null) data["description"] = description;
    if (type != null) data["type"] = type;
    if (version != null) data["version"] = version;
    if (email != null) data["email"] = email;
    if (mobileNo != null) data["mobileNo"] = mobileNo;
    return data;
  }
}

class GooglePayData {
  final String cardToken;
  final String cardType;

  GooglePayData({required this.cardToken, required this.cardType});

  Map<String, dynamic> toJson() => {
        "cardToken": cardToken,
        "cardType": cardType,
      };
}

class InitiateRequest {
  final DubaiPayHeader header;
  final TransactionInfo transaction;
  final GooglePayData paymentData;

  InitiateRequest({
    required this.header,
    required this.transaction,
    required this.paymentData,
  });

  Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "body": {
          "transaction": transaction.toJson(),
          "paymentData": {
            "googlePayData": paymentData.toJson(),
          }
        }
      };
}

class StatusRequest {
  final DubaiPayHeader header;
  final TransactionInfo transaction;
  final String? responseToken;

  StatusRequest({
    required this.header,
    required this.transaction,
    this.responseToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "header": header.toJson(),
      "body": {
        "transaction": transaction.toJson(),
      }
    };
    if (responseToken != null) {
      data["body"]["responseToken"] = responseToken;
    }
    return data;
  }
}

class DubaiPayTransactionResponse {
  final String? spCode;
  final String? servCode;
  final String? spTrn;
  final String? amount;
  final String? timestamp;
  final String? degTrn;
  final String? pgTrn;
  final String? approvalCode;
  final String? paymentMethod;
  final String? statusCode;
  final String? statusDesc;
  final String? errorMessage;
  final String? uri; // For register response

  DubaiPayTransactionResponse({
    this.spCode,
    this.servCode,
    this.spTrn,
    this.amount,
    this.timestamp,
    this.degTrn,
    this.pgTrn,
    this.approvalCode,
    this.paymentMethod,
    this.statusCode,
    this.statusDesc,
    this.errorMessage,
    this.uri,
  });

  factory DubaiPayTransactionResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('transactionResponse')) {
      final tr = json['transactionResponse'] as Map<String, dynamic>;
      return DubaiPayTransactionResponse(
        spCode: tr['spCode'],
        servCode: tr['servCode'],
        spTrn: tr['spTrn'],
        amount: tr['amount'],
        timestamp: tr['timestamp'],
        degTrn: tr['degTrn'],
        pgTrn: tr['pgTrn'],
        approvalCode: tr['approvalCode'],
        paymentMethod: tr['paymentMethod'],
        statusCode: tr['statusCode'],
        statusDesc: tr['statusDesc'],
        errorMessage: tr['errorMessage'],
      );
    }

    // For initiate response
    return DubaiPayTransactionResponse(
      statusCode: json['statusCode'],
      statusDesc: json['statusDesc'],
      errorMessage: json['errorMessage'],
      uri: json['uri'],
    );
  }
}
