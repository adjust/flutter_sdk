import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util {
  static const String EVENT_TOKEN_SIMPLE = 'g3mfiw';
  static const String EVENT_TOKEN_REVENUE = 'a4fd35';
  static const String EVENT_TOKEN_CALLBACK = '34vgg9';
  static const String EVENT_TOKEN_PARTNER = 'w788qs';

  static Widget buildRaisedButton(String text, Function action) {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ElevatedButton(
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

  static Widget buildCupertinoButton(String text, Function action) {
    return new CupertinoButton(
      child: Text(text),
      color: CupertinoColors.activeBlue,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
      onPressed: action as void Function()?,
    );
  }

  static Widget buildRaisedButtonRow(String text, Function action) {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new Container(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ElevatedButton(
              child: Text(text),
              onPressed: () {
                action();
              },
            ),
          ],
        ),
        margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        padding: new EdgeInsets.all(1.0),
        decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
      ),
    );
  }

  static AdjustEvent buildSimpleEvent() {
    return new AdjustEvent(EVENT_TOKEN_SIMPLE);
  }

  static AdjustEvent buildRevenueEvent() {
    AdjustEvent event = new AdjustEvent(EVENT_TOKEN_REVENUE);
    event.setRevenue(100.0, 'EUR');
    event.transactionId = 'DummyTransactionId';
    event.callbackId = 'DummyCallbackId';
    return event;
  }

  static AdjustEvent buildCallbackEvent() {
    AdjustEvent event = new AdjustEvent(EVENT_TOKEN_CALLBACK);
    event.addCallbackParameter('key1', 'value1');
    event.addCallbackParameter('key2', 'value2');
    return event;
  }

  static AdjustEvent buildPartnerEvent() {
    AdjustEvent event = new AdjustEvent(EVENT_TOKEN_PARTNER);
    event.addPartnerParameter('foo1', 'bar1');
    event.addPartnerParameter('foo2', 'bar2');
    return event;
  }

  static void showMessage(BuildContext context, String dialogText, String message) {
    showDialog<Null>(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(dialogText),
              content: new Text(message),
            ));
  }

  static void showDemoDialog<T>(
      {GlobalKey<ScaffoldState>? scaffoldKey, required BuildContext context, Widget? child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child!,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
      if (scaffoldKey != null && value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          new SnackBar(
            content: new Text('You selected: $value'),
          ),
        );
      }
    });
  }
}
