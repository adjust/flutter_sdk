class AdjustSessionFailure {
  String message;
  String timestamp;
  String adid;
  bool willRetry;
  String jsonResponse;

  static AdjustSessionFailure fromMap(dynamic map) {
    AdjustSessionFailure sessionFailure = new AdjustSessionFailure();
    try {
      sessionFailure.message = map['message'];
      sessionFailure.timestamp = map['timestamp'];
      sessionFailure.adid = map['adid'];
      bool willRetry = map['willRetry'].toString().toLowerCase() == 'true';
      sessionFailure.willRetry = willRetry;
      sessionFailure.jsonResponse = map['jsonResponse'];
    } catch (e) {
      print('Error! Failed to map AdjustSessionFailure from incoming data. Details: ' + e.toString());
    }
    return sessionFailure;
  }

  @override
  String toString() {
    return "SessionFailure [ message: $message, timestamp: $timestamp, adid: $adid, willRetry: $willRetry, jsonResp: $jsonResponse ]";
  }
}
