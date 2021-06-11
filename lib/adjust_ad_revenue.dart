//
//  adjust_ad_revenue.dart
//  Adjust SDK
//
//  Created by Uglješa Erceg (@uerceg) on 10th June 2021.
//  Copyright (c) 2021 Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustAdRevenue {
  String _source;
  num? _revenue;
  String? _currency;
  num? adImpressionsCount;
  String? adRevenueNetwork;
  String? adRevenueUnit;
  String? adRevenuePlacement;
  Map<String, String>? _callbackParameters;
  Map<String, String>? _partnerParameters;

  AdjustAdRevenue(this._source) {
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

  void addPartnerParameter(String key, String value) {
    _partnerParameters![key] = value;
  }

  Map<String, String?> get toMap {
    Map<String, String?> adRevenueMap = {
      'source': _source
    };

    if (_revenue != null) {
      adRevenueMap['revenue'] = _revenue.toString();
    }
    if (_currency != null) {
      adRevenueMap['currency'] = _currency;
    }
    if (adImpressionsCount != null) {
      adRevenueMap['adImpressionsCount'] = adImpressionsCount.toString();
    }
    if (adRevenueNetwork != null) {
      adRevenueMap['adRevenueNetwork'] = adRevenueNetwork;
    }
    if (adRevenueUnit != null) {
      adRevenueMap['adRevenueUnit'] = adRevenueUnit;
    }
    if (adRevenuePlacement != null) {
      adRevenueMap['adRevenuePlacement'] = adRevenuePlacement;
    }
    if (_callbackParameters!.length > 0) {
      adRevenueMap['callbackParameters'] = json.encode(_callbackParameters);
    }
    if (_partnerParameters!.length > 0) {
      adRevenueMap['partnerParameters'] = json.encode(_partnerParameters);
    }

    return adRevenueMap;
  }
}
