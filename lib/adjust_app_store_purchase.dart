//
//  adjust_app_store_purchase.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 5th September 2023.
//  Copyright (c) 2020-Present Adjust GmbH. All rights reserved.
//

class AdjustAppStorePurchase {
  final String _productId;
  final String _transactionId;

  AdjustAppStorePurchase(this._productId, this._transactionId);

  Map<String, String?> get toMap {
    Map<String, String?> purchaseMap = new Map<String, String?>();

    purchaseMap['productId'] = _productId;
    purchaseMap['transactionId'] = _transactionId;

    return purchaseMap;
  }
}
