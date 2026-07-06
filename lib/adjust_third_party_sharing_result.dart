//
//  adjust_third_party_sharing_result.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 6th July 2026.
//  Copyright (c) 2026-Present Adjust GmbH. All rights reserved.
//

class AdjustThirdPartySharingResult {
  final String thirdPartySharingSettingsJson;

  AdjustThirdPartySharingResult({
    required this.thirdPartySharingSettingsJson,
  });

  factory AdjustThirdPartySharingResult.fromMap(dynamic map) {
    try {
      if (map == null || map is! Map) {
        throw Exception('Input map is null or has unexpected type.');
      }

      final dynamic settingsJson = map['thirdPartySharingSettingsJson'];

      return AdjustThirdPartySharingResult(
        thirdPartySharingSettingsJson:
            settingsJson is String && settingsJson.isNotEmpty
                ? settingsJson
                : '{}',
      );
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustThirdPartySharingResult object from given map object. Details: ' +
              e.toString());
    }
  }
}
