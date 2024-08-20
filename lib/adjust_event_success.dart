//
//  adjust_event_success.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

class AdjustEventSuccess {
  final String? message;
  final String? timestamp;
  final String? adid;
  final String? eventToken;
  final String? callbackId;
  final String? jsonResponse;

  AdjustEventSuccess({
    this.message,
    this.timestamp,
    this.adid,
    this.eventToken,
    this.callbackId,
    this.jsonResponse,
  });

  factory AdjustEventSuccess.fromMap(dynamic map) {
    try {
      return AdjustEventSuccess(
        message: map['message'],
        timestamp: map['timestamp'],
        adid: map['adid'],
        eventToken: map['eventToken'],
        callbackId: map['callbackId'],
        jsonResponse: map['jsonResponse'],
      );
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustEventSuccess object from given map object. Details: ' +
              e.toString());
    }
  }
}
