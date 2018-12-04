//
//  adjust_session_success.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

class AdjustSessionSuccess {
  String message;
  String timestamp;
  String adid;
  String jsonResponse;

  static AdjustSessionSuccess fromMap(dynamic map) {
    AdjustSessionSuccess sessionSuccess = new AdjustSessionSuccess();
    try {
      sessionSuccess.message = map['message'];
      sessionSuccess.timestamp = map['timestamp'];
      sessionSuccess.adid = map['adid'];
      sessionSuccess.jsonResponse = map['jsonResponse'];
    } catch (e) {
      print('[AdjustFlutter]: Failed to create AdjustSessionSuccess object from given map object. Details: ' + e.toString());
    }
    return sessionSuccess;
  }
}
