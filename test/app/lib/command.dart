//
//  command.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

import 'dart:convert';
import 'dart:io';

/// represents a test command received from the test library
/// contains class name, method name, and parameters for execution
class Command {
  String? _className;
  String? _methodName;
  String? _jsonParameters;
  Map<dynamic, dynamic>? _parameters;

  /// creates a Command from a dynamic map received from the test framework
  Command(dynamic map) {
    try {
      _className = map['className'];
      _methodName = map['methodName'];

      if (Platform.isAndroid) {
        // android sends parameters as JSON string
        _jsonParameters = map['jsonParameters'];
        _parameters = json.decode(_jsonParameters!);
      } else {
        // iOS sends parameters as map directly
        _parameters = map['jsonParameters'];
        _jsonParameters = json.encode(_parameters);
      }
    } catch (e) {
      print('[Command]: Failed to parse command from incoming data. Error: $e');
    }
  }

  /// the class name to execute the method on
  String? get className => _className;

  /// the method name to execute
  String? get methodName => _methodName;

  /// gets the first value for a given parameter key
  /// returns null if parameter doesn't exist or has no values
  String? getFirstParameterValue(String parameterKey) {
    final List<dynamic>? parameterValues = _parameters![parameterKey];
    if (parameterValues == null || parameterValues.isEmpty) {
      return null;
    }
    return parameterValues.first;
  }

  /// gets all parameter values for a given key
  /// fixed typo: was "getParamteters", now "getParameters"
  List<dynamic>? getParameters(String parameterKey) {
    return _parameters![parameterKey];
  }

  /// checks if the command contains a specific parameter
  bool containsParameter(String parameterKey) {
    return _parameters?[parameterKey] != null;
  }

  /// returns a string representation of the command for debugging
  @override
  String toString() {
    return 'Command[className: $_className, methodName: $_methodName, jsonParameters: $_jsonParameters]';
  }
}
