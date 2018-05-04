class AdjustAttribution {
  String trackerToken;
  String trackerName;
  String network;
  String campaign;
  String adgroup;
  String creative;
  String clickLabel;
  String adid;

  static AdjustAttribution fromMap(dynamic map) {
    AdjustAttribution attChange = new AdjustAttribution();
    try {
      attChange.trackerToken = map['trackerToken'];
      attChange.trackerName = map['trackerName'];
      attChange.network = map['network'];
      attChange.campaign = map['campaign'];
      attChange.adgroup = map['adgroup'];
      attChange.creative = map['creative'];
      attChange.clickLabel = map['clickLabel'];
      attChange.adid = map['adid'];
    } catch (e) {
      print(e.toString());
    }
    return attChange;
  }
}
