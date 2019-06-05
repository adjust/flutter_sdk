package com.adjust.examples;

import android.os.Bundle;
import android.content.Intent;
import android.net.Uri;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.adjust.sdk.flutter.AdjustSdk;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        Intent intent = getIntent();
        Uri data = intent.getData();
        AdjustSdk.appWillOpenUrl(data, this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Uri data = intent.getData();
        AdjustSdk.appWillOpenUrl(data, this);
    }
}
