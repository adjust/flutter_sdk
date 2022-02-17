//
//  adjust_session_success.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

class AdjustSessionSuccess {
  final String? message;
  final String? timestamp;
  final String? adid;
  final String? jsonResponse;

  AdjustSessionSuccess({
    required this.message,
    required this.timestamp,
    required this.adid,
    required this.jsonResponse,
  });

  factory AdjustSessionSuccess.fromMap(dynamic map) {
    try {
      return AdjustSessionSuccess(
        message: map['message'],
        timestamp: map['timestamp'],
        adid: map['adid'],
        jsonResponse: map['jsonResponse'],
      );
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustSessionSuccess object from given map object. Details: ' +
              e.toString());
    }
  }
}
