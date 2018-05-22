class AdjustEventSuccess {
  String message;
  String timestamp;
  String adid;
  String eventToken;
  String jsonResponse;

  static AdjustEventSuccess fromMap(dynamic map) {
    AdjustEventSuccess eventSuccess = new AdjustEventSuccess();
    try {
      eventSuccess.message = map['message'];
      eventSuccess.timestamp = map['timestamp'];
      eventSuccess.adid = map['adid'];
      eventSuccess.eventToken = map['eventToken'];
      eventSuccess.jsonResponse = map['jsonResponse'];
    } catch (e) {
      print('Error! Failed to map AdjustEventSuccess from incoming data. Details: ' + e.toString());
    }
    return eventSuccess;
  }
  
  @override
  String toString() {
    return "EventSuccess[ message: $message, timestamp: $timestamp, adid: $adid, token: $eventToken, jsonResp: $jsonResponse ]";
  }
}
