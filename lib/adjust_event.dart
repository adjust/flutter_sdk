//
//  adjust_event.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustEvent {
  num _revenue;
  String _eventToken;
  String _currency;
  String _transactionId;
  String _callbackId;
  Map<String, String> _callbackParameters;
  Map<String, String> _partnerParameters;

  AdjustEvent(this._eventToken) {
    _callbackParameters = new Map<String, String>();
    _partnerParameters = new Map<String, String>();
  }

  void setRevenue(num revenue, String currency) {
    _revenue = revenue;
    _currency = currency;
  }

  void setTransactionId(String transactionId) {
    _transactionId = transactionId;
  }

  void setCallbackId(String callbackId) {
    _callbackId = callbackId;
  }

  void addCallbackParameter(String key, String value) {
    _callbackParameters[key] = value;
  }

  void addPartnerParameter(String key, String value) {
    _partnerParameters[key] = value;
  }

  Map<String, String> get toMap {
    Map<String, String> eventMap = {
      'eventToken': _eventToken
    };

    if (_revenue != null) {
      eventMap['revenue'] = _revenue.toString();
    }
    if (_currency != null) {
      eventMap['currency'] = _currency;
    }
    if (_transactionId != null) {
      eventMap['transactionId'] = _transactionId;
    }
    if (_callbackId != null) {
      eventMap['callbackId'] = _callbackId;
    }
    if (_callbackParameters.length > 0) {
      eventMap['callbackParameters'] = json.encode(_callbackParameters);
    }
    if (_partnerParameters.length > 0) {
      eventMap['partnerParameters'] = json.encode(_partnerParameters);
    }

    return eventMap;
  }
}
