import 'package:adjust_sdk_plugin/adjust_event.dart';
import 'package:flutter/material.dart';

class Util {
  static const String EVENT_TOKEN_SIMPLE = "g3mfiw";
  static const String EVENT_TOKEN_REVENUE = "a4fd35";
  static const String EVENT_TOKEN_CALLBACK = "34vgg9";
  static const String EVENT_TOKEN_PARTNER = "w788qs";

  static Widget buildRaisedButton(String text, Function action) {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new RaisedButton(
                child: Text(text),
                onPressed: () {
                  action();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildRasedButtonRow(String text, Function action) {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new Container(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new RaisedButton(
              child: Text(text),
              onPressed: () {
                action();
              },
            ),
          ],
        ),
        margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        padding: new EdgeInsets.all(1.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.black)),
      ),
    );
  }

  static AdjustEvent buildSimpleEvent() {
    return new AdjustEvent(EVENT_TOKEN_SIMPLE, 10, 'EUR', '');
  }

  static AdjustEvent buildRevenueEvent() {
    AdjustEvent event = new AdjustEvent(EVENT_TOKEN_REVENUE, 220, 'EUR', '');
    event.revenue = 100.0;
    return event;
  }

  static AdjustEvent buildCallbackEvent() {
    AdjustEvent event = new AdjustEvent(EVENT_TOKEN_CALLBACK, 100, 'EUR');
    event.addCallbackParameter('key1', 'value1');
    event.addCallbackParameter('key2', 'value2');
    return event;
  }

  static AdjustEvent buildPartnerEvent() {
    AdjustEvent event = new AdjustEvent(EVENT_TOKEN_PARTNER, 100, 'EUR');
    event.addPartnerParameter('foo1', 'bar1');
    event.addPartnerParameter('foo2', 'bar2');
    return event;
  }
}
