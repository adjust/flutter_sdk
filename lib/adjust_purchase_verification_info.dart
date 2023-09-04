//
//  adjust_purchase_verification_info.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 4th September 2020.
//  Copyright (c) 2020-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustPurchaseVerificationInfo {
  final num? code;
  final String? message;
  final String? verificationStatus;

  AdjustPurchaseVerificationInfo(this.code, this.message, this.verificationStatus);

  factory AdjustPurchaseVerificationInfo.fromMap(dynamic map) {
    try {
      int parsedCode = -1;
      try {
        if (map['code'] != null) {
          parsedCode = int.parse(map['code']);
        }
      } catch (ex) {}

      return AdjustPurchaseVerificationInfo(parsedCode, map['message'], map['verificationStatus']);
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustPurchaseVerificationInfo object from given map object. Details: ' +
              e.toString());
    }
  }

  Map<String, String?> get toMap {
    Map<String, String?> verificationInfoMap = new Map<String, String?>();

    if (code != null) {
      verificationInfoMap['code'] = code.toString();
    }
    if (message != null) {
      verificationInfoMap['message'] = message;
    }
    if (verificationStatus != null) {
      verificationInfoMap['verificationStatus'] = verificationStatus;
    }

    return verificationInfoMap;
  }
}
