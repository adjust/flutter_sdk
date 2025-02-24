//
//  adjust_attribution.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

class AdjustAttribution {
  final String? trackerToken;
  final String? trackerName;
  final String? network;
  final String? campaign;
  final String? adgroup;
  final String? creative;
  final String? clickLabel;
  final String? costType;
  final num? costAmount;
  final String? costCurrency;
  final String? jsonResponse;
  // Android only
  final String? fbInstallReferrer;

  AdjustAttribution({
    this.trackerToken,
    this.trackerName,
    this.network,
    this.campaign,
    this.adgroup,
    this.creative,
    this.clickLabel,
    this.costType,
    this.costAmount,
    this.costCurrency,
    this.jsonResponse,
    this.fbInstallReferrer,
  });

  factory AdjustAttribution.fromMap(dynamic map) {
    try {
      double parsedCostAmount = -1;
      try {
        if (map['costAmount'] != null) {
          parsedCostAmount = double.parse(map['costAmount']);
        }
      } catch (ex) {}

      return AdjustAttribution(
        trackerToken: map['trackerToken'],
        trackerName: map['trackerName'],
        network: map['network'],
        campaign: map['campaign'],
        adgroup: map['adgroup'],
        creative: map['creative'],
        clickLabel: map['clickLabel'],
        costType: map['costType'],
        costAmount: parsedCostAmount != -1 ? parsedCostAmount : null,
        costCurrency: map['costCurrency'],
        jsonResponse: map['jsonResponse'],
        fbInstallReferrer: map['fbInstallReferrer'],
      );
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustAttribution object from given map object. Details: ' +
              e.toString());
    }
  }
}
