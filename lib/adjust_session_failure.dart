//
//  adjust_session_failure.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

class AdjustSessionFailure {
  String message;
  String timestamp;
  String adid;
  String jsonResponse;
  bool willRetry;

  static AdjustSessionFailure fromMap(dynamic map) {
    AdjustSessionFailure sessionFailure = new AdjustSessionFailure();
    try {
      sessionFailure.message = map['message'];
      sessionFailure.timestamp = map['timestamp'];
      sessionFailure.adid = map['adid'];
      sessionFailure.jsonResponse = map['jsonResponse'];
      bool willRetry = map['willRetry'].toString().toLowerCase() == 'true';
      sessionFailure.willRetry = willRetry;
    } catch (e) {
      print('[AdjustFlutter]: Failed to create AdjustSessionFailure object from given map object. Details: ' + e.toString());
    }
    return sessionFailure;
  }
}
