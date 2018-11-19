import 'dart:convert';

import 'package:adjust_sdk_plugin/nullable.dart';

class AdjustEvent {
  String eventToken;
  Nullable<num> _revenue;
  String currency;
  String orderId;
  String callbackId;

  Map<String, String> callbackParameters;
  Map<String, String> partnerParameters;

  AdjustEvent(this.eventToken, [num revenue=-1, this.currency='',
      this.orderId = '']) {
    if (revenue >= 0) {
      _revenue = new Nullable<num>(revenue);
    }
    callbackParameters = new Map<String, String>();
    partnerParameters = new Map<String, String>();
  }

  void addCallbackParameter(String key, String value) {
    callbackParameters[key] = value;
  }

  void addPartnerParameter(String key, String value) {
    partnerParameters[key] = value;
  }

  set revenue(num revenue) {
    _revenue = new Nullable<num>(revenue);
  }

  Map<String, String> get adjustEventParamsMap {
    Map<String, String> adjustEventParamsMap = {
      'eventToken': eventToken
    };

    if (_revenue != null) {
      adjustEventParamsMap['revenue'] = _revenue.strValue;
    }
    if (currency != null) {
      adjustEventParamsMap['currency'] = currency;
    }
    if (orderId != null && orderId.length > 0) {
      adjustEventParamsMap['orderId'] = orderId;
    }
    if (callbackId != null) {
      adjustEventParamsMap['callbackId'] = callbackId;
    }

    if (callbackParameters.length > 0) {
      adjustEventParamsMap['callbackParameters'] =
          json.encode(callbackParameters);
    }

    if (partnerParameters.length > 0) {
      adjustEventParamsMap['partnerParameters'] =
          json.encode(partnerParameters);
    }
    
    return adjustEventParamsMap;
  }
}
