import 'dart:convert';
import 'package:crypto/crypto.dart';

class DubaiPaySignature {
  /// Generates the HMAC-SHA512 checksum for a given message and secret key.
  /// The returned checksum is in uppercase hex format.
  static String generateHMAC(String message, String signKey) {
    try {
      var key = utf8.encode(signKey);
      var bytes = utf8.encode(message);

      var hmacSha512 = Hmac(sha512, key); // HMAC-SHA512
      var digest = hmacSha512.convert(bytes);

      return digest.toString().toUpperCase();
    } catch (e) {
      print("Failed to generate HMAC - $e");
      return "";
    }
  }

  /// Helper to convert map to JSON payload string.
  static String payloadToJson(Map<String, dynamic> payload) {
    return jsonEncode(payload);
  }
}
