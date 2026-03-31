//
//  adjust_remote_trigger.dart
//  Adjust SDK
//
//  Created by Ugljesa Erceg (@uerceg) on 30th March 2026.
//  Copyright (c) 2026-Present Adjust GmbH. All rights reserved.
//

class AdjustRemoteTrigger {
  final String label;
  final Map<String, dynamic> payload;

  AdjustRemoteTrigger({
    required this.label,
    required this.payload,
  });

  factory AdjustRemoteTrigger.fromMap(dynamic map) {
    try {
      if (map == null || map is! Map) {
        throw Exception('Input map is null or has unexpected type.');
      }

      final String? label = map['label'];
      final dynamic payload = map['payload'];
      if (label == null) {
        throw Exception('Missing required remote trigger label.');
      }

      return AdjustRemoteTrigger(
        label: label,
        payload: _castPayload(payload),
      );
    } catch (e) {
      throw Exception(
          '[AdjustFlutter]: Failed to create AdjustRemoteTrigger object from given map object. Details: ' +
              e.toString());
    }
  }

  static Map<String, dynamic> _castPayload(dynamic payload) {
    if (payload == null) {
      return <String, dynamic>{};
    }

    if (payload is! Map) {
      throw Exception('Remote trigger payload has unexpected type.');
    }

    return payload.map<String, dynamic>((dynamic key, dynamic value) {
      return MapEntry<String, dynamic>(key.toString(), _castValue(value));
    });
  }

  static dynamic _castValue(dynamic value) {
    if (value is Map) {
      return _castPayload(value);
    }

    if (value is List) {
      return value.map<dynamic>(_castValue).toList();
    }

    return value;
  }
}
