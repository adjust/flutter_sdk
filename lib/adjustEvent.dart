class AdjustEvent {
  String eventToken;
  num revenue;
  String currency;
  String orderId;

  // TODO:
  // Map<String, String> callbackParameters;
  // Map<String, String> partnerParameters;

  AdjustEvent(this.eventToken, this.revenue, this.currency, [this.orderId = '']);

  Map<String, String> get adjustEventParamsMap {
    return {
      'eventToken': eventToken,
      'revenue': revenue.toString(),
      'currency': currency,
      'orderId': orderId,
    };
  }
}
