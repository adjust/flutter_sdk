//
//  adjust_play_store_subscription.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 9th June 2020.
//  Copyright (c) 2020-2021 Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustPlayStoreSubscription {
  String? _price;
  String? _currency;
  String? _sku;
  String? _orderId;
  String? _signature;
  String? _purchaseToken;
  String? _billingStore;
  String? _purchaseTime;
  Map<String, String>? _callbackParameters;
  Map<String, String>? _partnerParameters;

  AdjustPlayStoreSubscription(this._price, this._currency, this._sku,
      this._orderId, this._signature, this._purchaseToken) {
    _billingStore = "GooglePlay";
    _callbackParameters = new Map<String, String>();
    _partnerParameters = new Map<String, String>();
  }

  void setPurchaseTime(String purchaseTime) {
    _purchaseTime = purchaseTime;
  }

  void addCallbackParameter(String key, String value) {
    _callbackParameters![key] = value;
  }

  void addPartnerParameter(String key, String value) {
    _partnerParameters![key] = value;
  }

  Map<String, String?> get toMap {
    Map<String, String?> subscriptionMap = new Map<String, String?>();

    if (_price != null) {
      subscriptionMap['price'] = _price;
    }
    if (_currency != null) {
      subscriptionMap['currency'] = _currency;
    }
    if (_sku != null) {
      subscriptionMap['sku'] = _sku;
    }
    if (_orderId != null) {
      subscriptionMap['orderId'] = _orderId;
    }
    if (_signature != null) {
      subscriptionMap['signature'] = _signature;
    }
    if (_purchaseToken != null) {
      subscriptionMap['purchaseToken'] = _purchaseToken;
    }
    if (_billingStore != null) {
      subscriptionMap['billingStore'] = _billingStore;
    }
    if (_purchaseTime != null) {
      subscriptionMap['purchaseTime'] = _purchaseTime;
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
