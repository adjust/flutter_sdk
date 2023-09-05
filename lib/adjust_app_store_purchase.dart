//
//  adjust_app_store_purchase.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 5th September 2023.
//  Copyright (c) 2020-Present Adjust GmbH. All rights reserved.
//

class AdjustAppStorePurchase {
  String? receipt;
  String? productId;
  String? transactionId;

  AdjustAppStorePurchase(this.receipt, this.productId, this.transactionId);

  Map<String, String?> get toMap {
    Map<String, String?> purchaseMap = new Map<String, String?>();

    if (receipt != null) {
      purchaseMap['receipt'] = receipt;
    }
    if (productId != null) {
      purchaseMap['productId'] = productId;
    }
    if (transactionId != null) {
      purchaseMap['transactionId'] = transactionId;
    }

    return purchaseMap;
  }
}
