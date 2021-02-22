//
//  adjust_event_failure.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-2021 Adjust GmbH. All rights reserved.
//

class AdjustEventFailure {
  String message;
  String timestamp;
  String adid;
  String eventToken;
  String callbackId;
  String jsonResponse;
  bool willRetry;

  static AdjustEventFailure fromMap(dynamic map) {
    AdjustEventFailure eventFailure = new AdjustEventFailure();
    try {
      eventFailure.message = map['message'];
      eventFailure.timestamp = map['timestamp'];
      eventFailure.adid = map['adid'];
      eventFailure.eventToken = map['eventToken'];
      eventFailure.callbackId = map['callbackId'];
      eventFailure.jsonResponse = map['jsonResponse'];
      bool willRetry = map['willRetry'].toString().toLowerCase() == 'true';
      eventFailure.willRetry = willRetry;
    } catch (e) {
      print('[AdjustFlutter]: Failed to create AdjustEventFailure object from given map object. Details: ' + e.toString());
    }
    return eventFailure;
  }
}
