class AdjustEventFailure {
  String message;
  String timestamp;
  String adid;
  String eventToken;
  String callbackId;
  bool willRetry;
  String jsonResponse;

  static AdjustEventFailure fromMap(dynamic map) {
    AdjustEventFailure eventFailure = new AdjustEventFailure();
    try {
      eventFailure.message = map['message'];
      eventFailure.timestamp = map['timestamp'];
      eventFailure.adid = map['adid'];
      eventFailure.eventToken = map['eventToken'];
      eventFailure.callbackId = map['callbackId'];
      bool willRetry = map['willRetry'].toString().toLowerCase() == 'true';
      eventFailure.willRetry = willRetry;
      eventFailure.jsonResponse = map['jsonResponse'];
    } catch (e) {
      print('Error! Failed to map AdjustEventFailure from incoming data. Details: ' + e.toString());
    }
    return eventFailure;
  }

  @override
  String toString() {
    return "EventFailure [ message: $message, timestamp: $timestamp, adid: $adid, token: $eventToken, callbackId: $callbackId, willRetry: $willRetry, jsonResp: $jsonResponse ]";
  }
}
