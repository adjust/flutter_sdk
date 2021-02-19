//
//  adjust_event_success.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-2021 Adjust GmbH. All rights reserved.
//

class AdjustEventSuccess {
  String message;
  String timestamp;
  String adid;
  String eventToken;
  String callbackId;
  String jsonResponse;

  static AdjustEventSuccess fromMap(dynamic map) {
    AdjustEventSuccess eventSuccess = new AdjustEventSuccess();
    try {
      eventSuccess.message = map['message'];
      eventSuccess.timestamp = map['timestamp'];
      eventSuccess.adid = map['adid'];
      eventSuccess.eventToken = map['eventToken'];
      eventSuccess.callbackId = map['callbackId'];
      eventSuccess.jsonResponse = map['jsonResponse'];
    } catch (e) {
      print('[AdjustFlutter]: Failed to create AdjustEventSuccess object from given map object. Details: ' + e.toString());
    }
    return eventSuccess;
  }
}
