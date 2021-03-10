//
//  adjust_app_store_subscription.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 9th June 2020.
//  Copyright (c) 2020-2021 Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustAppStoreSubscription {
  String? _price;
  String? _currency;
  String? _transactionId;
  String? _receipt;
  String? _transactionDate;
  String? _salesRegion;
  String? _billingStore;
  Map<String, String>? _callbackParameters;
  Map<String, String>? _partnerParameters;

  AdjustAppStoreSubscription(
    this._price,
    this._currency,
    this._transactionId,
    this._receipt,
  ) {
    _billingStore = "iOS";
    _callbackParameters = new Map<String, String>();
    _partnerParameters = new Map<String, String>();
  }

  void setTransactionDate(String transactionDate) {
    _transactionDate = transactionDate;
  }

  void setSalesRegion(String salesRegion) {
    _salesRegion = salesRegion;
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
    if (_transactionId != null) {
      subscriptionMap['transactionId'] = _transactionId;
    }
    if (_receipt != null) {
      subscriptionMap['receipt'] = _receipt;
    }
    if (_transactionDate != null) {
      subscriptionMap['transactionDate'] = _transactionDate;
    }
    if (_salesRegion != null) {
      subscriptionMap['salesRegion'] = _salesRegion;
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
