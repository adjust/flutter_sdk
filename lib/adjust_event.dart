//
//  adjust_event.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustEvent {
  num revenue;
  String _eventToken;
  String currency;
  String transactionId;
  String callbackId;
  Map<String, String> callbackParameters;
  Map<String, String> partnerParameters;

  AdjustEvent(this._eventToken) {
    callbackParameters = new Map<String, String>();
    partnerParameters = new Map<String, String>();
  }

  void setRevenue(num revenue, String currency) {
    this.revenue = revenue;
    this.currency = currency;
  }

  void addCallbackParameter(String key, String value) {
    callbackParameters[key] = value;
  }

  void addPartnerParameter(String key, String value) {
    partnerParameters[key] = value;
  }

  Map<String, String> get toMap {
    Map<String, String> eventMap = {
      'eventToken': _eventToken
    };

    if (revenue != null) {
      eventMap['revenue'] = revenue.toString();
    }
    if (currency != null) {
      eventMap['currency'] = currency;
    }
    if (transactionId != null) {
      eventMap['transactionId'] = transactionId;
    }
    if (callbackId != null) {
      eventMap['callbackId'] = callbackId;
    }
    if (callbackParameters.length > 0) {
      eventMap['callbackParameters'] = json.encode(callbackParameters);
    }
    if (partnerParameters.length > 0) {
      eventMap['partnerParameters'] = json.encode(partnerParameters);
    }

    return eventMap;
  }
}
