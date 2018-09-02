class Command {
  String className;
  String methodName;
  String jsonParameters;

  static Command fromMap(dynamic map) {
    Command command = new Command();
    try {
      command.className = map['className'];
      command.methodName = map['methodName'];
      command.jsonParameters = map['jsonParameters'];
    } catch (e) {
      print('Error! Failed to map Command from incoming data. Details: ' + e.toString());
    }
    return command;
  }

  @override
  String toString() {
    return "Command[ className: $className, methodName: $methodName, adid: $jsonParameters, jsonResp: $jsonParameters ]";
  }
}
