//
//  adjust_attribution.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

class AdjustAttribution {
  String trackerToken;
  String trackerName;
  String network;
  String campaign;
  String adgroup;
  String creative;
  String clickLabel;
  String adid;

  static AdjustAttribution fromMap(dynamic map) {
    AdjustAttribution attribution = new AdjustAttribution();
    try {
      attribution.trackerToken = map['trackerToken'];
      attribution.trackerName = map['trackerName'];
      attribution.network = map['network'];
      attribution.campaign = map['campaign'];
      attribution.adgroup = map['adgroup'];
      attribution.creative = map['creative'];
      attribution.clickLabel = map['clickLabel'];
      attribution.adid = map['adid'];
    } catch (e) {
      print('[AdjustFlutter]: Failed to create AdjustAttribution object from given map object. Details: ' + e.toString());
    }
    return attribution;
  }
}
