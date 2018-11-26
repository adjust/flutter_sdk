package com.adjust.test.testlibexample;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.adjust.sdk.flutter.AdjustSdk;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    System.out.println(" ====>> ADJUST-PLUGIN-BRIDGE-APP: onCreate ...");

    Intent intent = getIntent();
    if (/*intent.getAction() == Intent.ACTION_VIEW &&*/ intent.getData() != null) {
      Uri data = intent.getData();
      System.out.println(" ====>> ADJUST-PLUGIN-BRIDGE-APP: deeplink URI = " + data.toString());
      AdjustSdk.appWillOpenUrl(data.toString());
    } else {
      System.out.println(" ====>> ADJUST-PLUGIN-BRIDGE-APP: deeplink URI is null ...");
    }
  }

  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);

    System.out.println(" ====>> ADJUST-PLUGIN-BRIDGE-APP: onNewIntent ...");

    Uri data = intent.getData();
    if (data != null) {
      System.out.println(" ====>> ADJUST-PLUGIN-BRIDGE-APP: deeplink URI = " + data.toString());
      AdjustSdk.appWillOpenUrl(data.toString());
    } else {
      System.out.println(" ====>> ADJUST-PLUGIN-BRIDGE-APP: deeplink URI is null ...");
    }
  }
}
