//
//  adjust_deeplink.dart
//  Adjust SDK
//
//  Created by Mahdi ZTD (@MahdiZTD) on 6th June 2025.
//  Copyright (c) 2025-Present Adjust GmbH. All rights reserved.
//

class AdjustStoreInfo {
  String? storeName;
  String? storeAppId;

  AdjustStoreInfo(this.storeName);

  Map<String, String?> get toMap {
    Map<String, String?> storeInfoMap = new Map<String, String?>();

    if (storeName != null) {
      storeInfoMap['storeName'] = storeName;
    }
    if (storeAppId != null) {
      storeInfoMap['storeAppId'] = storeAppId;
    }

    return storeInfoMap;
  }
}
