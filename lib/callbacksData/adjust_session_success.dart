class AdjustSessionSuccess {
  String message;
  String timestamp;
  String adid;
  String jsonResponse;

  static AdjustSessionSuccess fromMap(dynamic map) {
    AdjustSessionSuccess sessionSuccess = new AdjustSessionSuccess();
    try {
      sessionSuccess.message = map['message'];
      sessionSuccess.timestamp = map['timestamp'];
      sessionSuccess.adid = map['adid'];
      sessionSuccess.jsonResponse = map['jsonResponse'];
    } catch (e) {
      print('Error! Failed to map AdjustSessionSuccess from incoming data. Details: ' + e.toString());
    }
    return sessionSuccess;
  }

  @override
  String toString() {
    return "SessionSuccess[ message: $message, timestamp: $timestamp, adid: $adid, jsonResp: $jsonResponse ]";
  }
}
