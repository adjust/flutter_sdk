//
//  command.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';
import 'dart:io';

class Command {
  String? _className;
  String? _methodName;
  String? _jsonParameters;
  Map<dynamic, dynamic>? _parameters;

  Command(dynamic map) {
    try {
      _className = map['className'];
      _methodName = map['methodName'];

      if (Platform.isAndroid) {
        _jsonParameters = map['jsonParameters'];
        _parameters = json.decode(_jsonParameters!);
      } else {
        _parameters = map['jsonParameters'];
        _jsonParameters = json.encode(_parameters);
      }
    } catch (e) {
      print(
          '[Command]: Error! Failed to map Command from incoming data. Details: ${e.toString()}');
    }
  }

  String? get className => _className;
  String? get methodName => _methodName;

  String? getFirstParameterValue(String parameterKey) {
    List<dynamic>? parameterValues = _parameters![parameterKey];
    if (parameterValues == null || parameterValues.isEmpty) {
      return null;
    }
    return parameterValues.first;
  }

  List<dynamic>? getParamteters(String parameterKey) {
    return _parameters![parameterKey];
  }

  bool containsParameter(String parameterKey) {
    return _parameters![parameterKey] != null;
  }

  @override
  String toString() {
    return 'Command[className: $_className, methodName: $_methodName, jsonParameters: $_jsonParameters]';
  }
}
