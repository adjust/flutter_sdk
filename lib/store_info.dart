import 'dart:convert';

class StoreInfo {
  String? storeName;
  String? storeAppId;

  StoreInfo(this.storeName,this.storeAppId);

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