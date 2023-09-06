//
//  adjust_play_store_purchase.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 4th September 2023.
//  Copyright (c) 2020-Present Adjust GmbH. All rights reserved.
//

class AdjustPlayStorePurchase {
  String? productId;
  String? purchaseToken;

  AdjustPlayStorePurchase(this.productId, this.purchaseToken);

  Map<String, String?> get toMap {
    Map<String, String?> purchaseMap = new Map<String, String?>();

    if (productId != null) {
      purchaseMap['productId'] = productId;
    }
    if (purchaseToken != null) {
      purchaseMap['purchaseToken'] = purchaseToken;
    }

    return purchaseMap;
  }
}
