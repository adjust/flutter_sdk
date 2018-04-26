package com.adjust.sdk.adjustsdkplugin;

import android.content.Context;

import com.adjust.sdk.Adjust;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * com.adjust.sdk.adjustsdkplugin
 * Created by 2beens on 25.04.18.
 */
public class AdjustSdkPlugin implements MethodCallHandler {

  private Context applicationContext;

  public AdjustSdkPlugin(Context context) {
    this.applicationContext = context;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "adjust_sdk_plugin");
    channel.setMethodCallHandler(new AdjustSdkPlugin(registrar.context()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    log("Trying to call a method: " + call.method);

    switch (call.method) {
      case "getPlatformVersion": getPlatformVersion(result); break;
      case "onCreate": onCreate(call, result); break;
      case "onPause": onPause(result); break;
      case "onResume": onResume(result); break;
      case "trackEvent": trackEvent(call, result); break;
      case "isEnabled": isEnabled(result); break;
      case "setIsEnabled": setIsEnabled(call, result); break;
      case "addSessionCallbackParameter": addSessionCallbackParameter(call, result); break;
      case "addSessionPartnerParameter": addSessionPartnerParameter(call, result); break;

      default:
        error("Not implemented method: " + call.method);
        result.notImplemented();
        break;
    }
  }

  private void getPlatformVersion(Result result) {
    result.success("Android " + android.os.Build.VERSION.RELEASE);
  }

  private void onCreate(MethodCall call, Result result) {
    AdjustBridge.onCreate(applicationContext, (Map)call.arguments);
    result.success(null);
  }

  private void onResume(Result result) {
    AdjustBridge.onResume();
    result.success(null);
  }

  private void onPause(Result result) {
    AdjustBridge.onPause();
    result.success(null);
  }

  private void trackEvent(MethodCall call, Result result) {
    AdjustBridge.trackEvent((Map)call.arguments);
    result.success(null);
  }

  private void isEnabled(Result result) {
    result.success(AdjustBridge.isEnabled());
  }

  private void setIsEnabled(MethodCall call, Result result) {
    AdjustBridge.setIsEnabled((Map)call.arguments);
    result.success(null);
  }

  private void addSessionCallbackParameter(MethodCall call, Result result) {
    if(!call.hasArgument("key") && !call.hasArgument("value")) {
      result.error("0", "Arguments null or wrong", null);
      return;
    }

    String key = (String) call.argument("key");
    String value = (String) call.argument("value");
    AdjustBridge.addSessionCallbackParameter(key, value);

    result.success(null);
  }

  private void addSessionPartnerParameter(MethodCall call, Result result) {
    if(!call.hasArgument("key") && !call.hasArgument("value")) {
      result.error("0", "Arguments null or wrong", null);
      return;
    }

    String key = (String) call.argument("key");
    String value = (String) call.argument("value");
    AdjustBridge.addSessionPartnerParameter(key, value);

    result.success(null);
  }

  public static void log(String message) {
    System.out.println(">>> ADJUST PLUGIN LOG: " + message);
  }

  public static void error(String message) { System.out.println("!!>>> ADJUST PLUGIN ERROR LOG: " + message); }
}
