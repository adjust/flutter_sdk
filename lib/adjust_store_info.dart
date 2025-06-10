import 'dart:convert';

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
