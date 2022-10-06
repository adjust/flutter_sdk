//
//  adjust_third_party_sharing.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 18th February 2021.
//  Copyright (c) 2021-Present Adjust GmbH. All rights reserved.
//

class AdjustThirdPartySharing {
  bool? _isEnabled;
  late List<String> _granularOptions;
  late List<String> _partnerSharingSettings;

  AdjustThirdPartySharing(this._isEnabled) {
    _granularOptions = <String>[];
    _partnerSharingSettings = <String>[];
  }

  void addGranularOption(String partnerName, String key, String value) {
    _granularOptions.add(partnerName);
    _granularOptions.add(key);
    _granularOptions.add(value);
  }

  void addPartnerSharingSetting(String partnerName, String key, bool value) {
    _partnerSharingSettings.add(partnerName);
    _partnerSharingSettings.add(key);
    _partnerSharingSettings.add(value.toString());
  }

  Map<String, Object?> get toMap {
    Map<String, Object?> thirdPartySharingMap = {'isEnabled': _isEnabled};
    if (_granularOptions.length > 0) {
      thirdPartySharingMap['granularOptions'] =
          _granularOptions.join('__ADJ__');
    }
    if (_partnerSharingSettings.length > 0) {
      thirdPartySharingMap['partnerSharingSettings'] =
          _partnerSharingSettings.join('__ADJ__');
    }

    return thirdPartySharingMap;
  }
}
