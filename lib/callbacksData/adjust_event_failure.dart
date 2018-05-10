class AdjustEventFailure {
  String message;
  String timestamp;
  String adid;
  String eventToken;
  bool willRetry;
  String jsonResponse;

  static AdjustEventFailure fromMap(dynamic map) {
    AdjustEventFailure eventFailure = new AdjustEventFailure();
    try {
      eventFailure.message = map['message'];
      eventFailure.timestamp = map['timestamp'];
      eventFailure.adid = map['adid'];
      eventFailure.eventToken = map['eventToken'];
      bool willRetry = map['willRetry'].toString().toLowerCase() == 'true';
      eventFailure.willRetry = willRetry;
      eventFailure.jsonResponse = map['jsonResponse'];
    } catch (e) {
      print(e.toString());
    }
    return eventFailure;
  }
}
