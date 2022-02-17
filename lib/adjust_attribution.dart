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
  final String? adid;
  final String? costType;
  final num? costAmount;
  final String? costCurrency;

  AdjustAttribution({
    required this.trackerToken,
    required this.trackerName,
    required this.network,
    required this.campaign,
    required this.adgroup,
    required this.creative,
    required this.clickLabel,
    required this.adid,
    required this.costType,
    required this.costAmount,
    required this.costCurrency,
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
        adid: map['adid'],
        costType: map['costType'],
        costAmount: parsedCostAmount != -1 ? parsedCostAmount : null,
        costCurrency: map['costCurrency'],
      );
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustAttribution object from given map object. Details: ' +
              e.toString());
    }
  }
}
