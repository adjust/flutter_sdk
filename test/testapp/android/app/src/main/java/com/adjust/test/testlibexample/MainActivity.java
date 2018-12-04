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
  }

  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);
  }
}
