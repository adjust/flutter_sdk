//
//  adjust_play_store_purchase.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 4th September 2023.
//  Copyright (c) 2020-Present Adjust GmbH. All rights reserved.
//

class AdjustPlayStorePurchase {
  final String _productId;
  final String _purchaseToken;

  AdjustPlayStorePurchase(this._productId, this._purchaseToken);

  Map<String, String?> get toMap {
    Map<String, String?> purchaseMap = new Map<String, String?>();

    purchaseMap['productId'] = _productId;
    purchaseMap['purchaseToken'] = _purchaseToken;

    return purchaseMap;
  }
}
