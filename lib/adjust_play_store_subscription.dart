//
//  adjust_play_store_subscription.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 9th June 2020.
//  Copyright (c) 2020-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustPlayStoreSubscription {
  final String _price;
  final String _currency;
  final String _sku;
  final String _orderId;
  final String _signature;
  final String _purchaseToken;
  String? _billingStore;
  String? purchaseTime;
  Map<String, String>? _callbackParameters;
  Map<String, String>? _partnerParameters;

  AdjustPlayStoreSubscription(
    this._price,
    this._currency,
    this._sku,
    this._orderId,
    this._signature,
    this._purchaseToken) {
    _billingStore = "GooglePlay";
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
    subscriptionMap['sku'] = _sku;
    subscriptionMap['orderId'] = _orderId;
    subscriptionMap['signature'] = _signature;
    subscriptionMap['purchaseToken'] = _purchaseToken;
    if (_billingStore != null) {
      subscriptionMap['billingStore'] = _billingStore;
    }
    if (purchaseTime != null) {
      subscriptionMap['purchaseTime'] = purchaseTime;
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
