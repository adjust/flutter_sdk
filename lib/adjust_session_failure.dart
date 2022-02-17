//
//  adjust_session_failure.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

class AdjustSessionFailure {
  final String? message;
  final String? timestamp;
  final String? adid;
  final String? jsonResponse;
  final bool? willRetry;

  AdjustSessionFailure({
    required this.message,
    required this.timestamp,
    required this.adid,
    required this.jsonResponse,
    required this.willRetry,
  });

  factory AdjustSessionFailure.fromMap(dynamic map) {
    try {
      return AdjustSessionFailure(
        message: map['message'],
        timestamp: map['timestamp'],
        adid: map['adid'],
        jsonResponse: map['jsonResponse'],
        willRetry: map['willRetry']?.toString().toLowerCase() == 'true',
      );
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustSessionFailure object from given map object. Details: ' +
              e.toString());
    }
  }
}
