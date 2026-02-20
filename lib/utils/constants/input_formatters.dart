import 'package:flutter/services.dart';

abstract class InputFormatters {
  static List<TextInputFormatter>? companyEnglishNameFormatter =
      <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z. ]'),
    ),
  ];
  static List<TextInputFormatter>? englishNameFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z ]'),
    ),
  ];

  static List<TextInputFormatter>? arabicNameFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[\u0621-\u064A ]'),
    ),
  ];

  static List<TextInputFormatter>? denySpaces = <TextInputFormatter>[
    FilteringTextInputFormatter.deny(
      RegExp(r'[ ]'),
    ),
  ];

  static List<TextInputFormatter>? companyArabicNameFormatter =
      <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[\u0621-\u064A. ]'),
    ),
  ];

  static List<TextInputFormatter>? arabicAddressFormatter =
      <TextInputFormatter>[
    FilteringTextInputFormatter.deny(
      RegExp(r'[a-zA-Z]'),
    ),
  ];

  static List<TextInputFormatter>? englishAddressFormatter =
      <TextInputFormatter>[
    FilteringTextInputFormatter.deny(
      RegExp(r'[\u0621-\u064A]'),
    ),
  ];

  static List<TextInputFormatter>? numericFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[0-9]'),
    ),
  ];

  static List<TextInputFormatter>? phoneNumberFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[+0-9]'),
    ),
  ];

  static List<TextInputFormatter>? amountFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[0-9]'),
    ),
    FilteringTextInputFormatter.deny(
      RegExp(r'^0+'), //users can't type 0 at 1st position
    ),
  ];

  static List<TextInputFormatter>? ibanNumberFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z0-9 ]'),
    ),
  ];
}
