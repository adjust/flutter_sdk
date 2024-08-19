//
//  adjust_event.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustEvent {
  String _eventToken;
  
  num? _revenue;
  String? _currency;
  String? callbackId;
  String? _deduplicationId;
  String? productId;
  Map<String, String>? _callbackParameters;
  Map<String, String>? _partnerParameters;

  // ios only
  String? transactionId;

  // android only
  String? purchaseToken;

  AdjustEvent(this._eventToken) {
    _callbackParameters = new Map<String, String>();
    _partnerParameters = new Map<String, String>();
  }

  void setRevenue(num revenue, String currency) {
    _revenue = revenue;
    _currency = currency;
  }

  void addCallbackParameter(String key, String value) {
    _callbackParameters![key] = value;
  }

  void setDeduplicationId(String? deduplicationId) {
    _deduplicationId = deduplicationId;
  }

  void addPartnerParameter(String key, String value) {
    _partnerParameters![key] = value;
  }

  Map<String, String?> get toMap {
    Map<String, String?> eventMap = {'eventToken': _eventToken};

    if (_revenue != null) {
      eventMap['revenue'] = _revenue.toString();
    }
    if (_currency != null) {
      eventMap['currency'] = _currency;
    }
    if (_deduplicationId != null) {
      eventMap['deduplicationId'] = _deduplicationId;
    }
    if (transactionId != null) {
      eventMap['transactionId'] = transactionId;
    }
    if (productId != null) {
      eventMap['productId'] = productId;
    }
    if (purchaseToken != null) {
      eventMap['purchaseToken'] = purchaseToken;
    }
    if (callbackId != null) {
      eventMap['callbackId'] = callbackId;
    }
    if (_callbackParameters!.length > 0) {
      eventMap['callbackParameters'] = json.encode(_callbackParameters);
    }
    if (_partnerParameters!.length > 0) {
      eventMap['partnerParameters'] = json.encode(_partnerParameters);
    }

    return eventMap;
  }
}
