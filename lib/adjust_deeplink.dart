//
//  adjust_deeplink.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 19th August 2024.
//  Copyright (c) 2024-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';

class AdjustDeeplink {
  String deeplink;
  String? referrer;

  AdjustDeeplink(this.deeplink);

  Map<String, String?> get toMap {
    Map<String, String?> deeplinkMap = new Map<String, String?>();

    if (deeplink != null) {
      deeplinkMap['deeplink'] = deeplink;
    }
    if (referrer != null) {
      deeplinkMap['referrer'] = referrer;
    }

    return deeplinkMap;
  }
}
