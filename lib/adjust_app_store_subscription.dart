//
//  adjust_app_store_subscription.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 9th June 2020.
//  Copyright (c) 2020-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustAppStoreSubscription {
  final String _price;
  final String _currency;
  final String _transactionId;
  String? transactionDate;
  String? salesRegion;
  String? _billingStore;
  Map<String, String>? _callbackParameters;
  Map<String, String>? _partnerParameters;

  AdjustAppStoreSubscription(this._price, this._currency, this._transactionId) {
    _billingStore = "iOS";
    _callbackParameters = new Map<String, String>();
    _partnerParameters = new Map<String, String>();
  }

  void addCallbackParameter(String key, String value) {
    _callbackParameters![key] = value;
  }

  void addPartnerParameter(String key, String value) {
    _partnerParameters![key] = value;
  }

  Map<String, String?> get toMap {
    Map<String, String?> subscriptionMap = new Map<String, String?>();

    subscriptionMap['price'] = _price;
    subscriptionMap['currency'] = _currency;
    subscriptionMap['transactionId'] = _transactionId;
    if (transactionDate != null) {
      subscriptionMap['transactionDate'] = transactionDate;
    }
    if (salesRegion != null) {
      subscriptionMap['salesRegion'] = salesRegion;
    }
    if (_billingStore != null) {
      subscriptionMap['billingStore'] = _billingStore;
    }
    if (_callbackParameters!.length > 0) {
      subscriptionMap['callbackParameters'] = json.encode(_callbackParameters);
    }
    if (_partnerParameters!.length > 0) {
      subscriptionMap['partnerParameters'] = json.encode(_partnerParameters);
    }

    return subscriptionMap;
  }
}
