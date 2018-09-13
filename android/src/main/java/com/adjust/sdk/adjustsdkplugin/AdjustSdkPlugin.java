package com.adjust.sdk.adjustsdkplugin;

import android.content.Context;
import android.net.Uri;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustAttribution;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;
import com.adjust.sdk.AdjustEventFailure;
import com.adjust.sdk.AdjustEventSuccess;
import com.adjust.sdk.AdjustSessionFailure;
import com.adjust.sdk.AdjustSessionSuccess;
import com.adjust.sdk.AdjustTestOptions;
import com.adjust.sdk.LogLevel;
import com.adjust.sdk.OnAttributionChangedListener;
import com.adjust.sdk.OnDeeplinkResponseListener;
import com.adjust.sdk.OnDeviceIdsRead;
import com.adjust.sdk.OnEventTrackingFailedListener;
import com.adjust.sdk.OnEventTrackingSucceededListener;
import com.adjust.sdk.OnSessionTrackingFailedListener;
import com.adjust.sdk.OnSessionTrackingSucceededListener;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.adjust.sdk.adjustsdkplugin.AdjustPluginUtils.*;

/**
 * com.adjust.sdk.adjustsdkplugin
 * Created by 2beens on 25.04.18.
 */
public class AdjustSdkPlugin implements MethodCallHandler {
  private static MethodChannel channel;
  private static MethodChannel deeplinkChannel;
  private Context applicationContext;

  public AdjustSdkPlugin(Context context) {
    this.applicationContext = context;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    if (channel != null) {
      throw new IllegalStateException("You should not call registerWith more than once.");
    }

    AdjustSdkPlugin adjustSdkPlugin = new AdjustSdkPlugin(registrar.context());
    channel = new MethodChannel(registrar.messenger(), "com.adjust/api");
    channel.setMethodCallHandler(adjustSdkPlugin);

    deeplinkChannel = new MethodChannel(registrar.messenger(), "com.adjust/deeplink");
    deeplinkChannel.setMethodCallHandler(adjustSdkPlugin);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    log("Trying to call a method: " + call.method);

    switch (call.method) {
      case "getPlatformVersion": getPlatformVersion(result); break;
      case "onCreate": onCreate(call, result); break;
      case "onPause": onPause(result); break;
      case "onResume": onResume(result); break;
      case "trackEvent": trackEvent(call, result); break;
      case "isEnabled": isEnabled(result); break;
      case "setIsEnabled": setIsEnabled(call, result); break;
      case "setOfflineMode": setOfflineMode(call, result); break;
      case "setPushToken": setPushToken(call, result); break;
      case "appWillOpenUrl": appWillOpenUrl(call, result); break;
      case "sendFirstPackages": sendFirstPackages(result); break;
      case "getAdid": getAdid(result); break;
      case "getIdfa": getIdfa(result); break;
      case "getGoogleAdId": getGoogleAdId(result); break;
      case "getAmazonAdId": getAmazonAdId(result); break;
      case "getAttribution": getAttribution(result); break;
      case "setReferrer": setReferrer(call, result); break;
      case "gdprForgetMe": gdprForgetMe(result); break;
      case "addSessionCallbackParameter": addSessionCallbackParameter(call, result); break;
      case "addSessionPartnerParameter": addSessionPartnerParameter(call, result); break;
      case "removeSessionCallbackParameter": removeSessionCallbackParameter(call, result);
      case "removeSessionPartnerParameter": removeSessionPartnerParameter(call, result); break;
      case "resetSessionCallbackParameters": resetSessionCallbackParameters(result); break;
      case "resetSessionPartnerParameters": resetSessionPartnerParameters(result); break;
      case "setTestOptions": setTestOptions(call, result); break;

      default:
        error("Not implemented method: " + call.method);
        result.notImplemented();
        break;
    }
  }

  private void getPlatformVersion(final Result result) {
    result.success("Android " + android.os.Build.VERSION.RELEASE);
  }

  private void setTestOptions(final MethodCall call, final Result result) {
    AdjustTestOptions testOptions = new AdjustTestOptions();
    Map testOptionsMap = (Map)call.arguments;

    if(testOptionsMap.containsKey("baseUrl")) {
      testOptions.baseUrl = (String) testOptionsMap.get("baseUrl");
    }
    if(testOptionsMap.containsKey("gdprUrl")) {
      testOptions.gdprUrl = (String) testOptionsMap.get("gdprUrl");
    }
    if(testOptionsMap.containsKey("basePath")) {
      testOptions.basePath = (String) testOptionsMap.get("basePath");
    }
    if(testOptionsMap.containsKey("gdprPath")) {
      testOptions.gdprPath = (String) testOptionsMap.get("gdprPath");
    }
    if(testOptionsMap.containsKey("useTestConnectionOptions")) {
      testOptions.useTestConnectionOptions = testOptionsMap.get("useTestConnectionOptions").toString().equals("true");
    }
    if(testOptionsMap.containsKey("teardown")) {
      testOptions.teardown = testOptionsMap.get("teardown").toString().equals("true");
    }
    if(testOptionsMap.containsKey("tryInstallReferrer")) {
      testOptions.tryInstallReferrer = testOptionsMap.get("tryInstallReferrer").toString().equals("true");
    }
    if(testOptionsMap.containsKey("timerIntervalInMilliseconds")) {
      testOptions.timerIntervalInMilliseconds = Long.parseLong(testOptionsMap.get("timerIntervalInMilliseconds").toString());
    }
    if(testOptionsMap.containsKey("timerStartInMilliseconds")) {
      testOptions.timerStartInMilliseconds = Long.parseLong(testOptionsMap.get("timerStartInMilliseconds").toString());
    }
    if(testOptionsMap.containsKey("sessionIntervalInMilliseconds")) {
      testOptions.sessionIntervalInMilliseconds = Long.parseLong(testOptionsMap.get("sessionIntervalInMilliseconds").toString());
    }
    if(testOptionsMap.containsKey("subsessionIntervalInMilliseconds")) {
      testOptions.subsessionIntervalInMilliseconds = Long.parseLong(testOptionsMap.get("subsessionIntervalInMilliseconds").toString());
    }
    if(testOptionsMap.containsKey("deleteState")) {
      testOptions.context = applicationContext;
    }

    Adjust.setTestOptions(testOptions);
  }

  private void onCreate(final MethodCall call, final Result result) {
    Map adjustConfigMap = (Map)call.arguments;
    if(!adjustConfigMap.containsKey("appToken")) {
      result.error("0", "Arguments null or wrong (missing argument >appToken<", null);
      return;
    }
    if(!adjustConfigMap.containsKey("environment")) {
      result.error("0", "Arguments null or wrong (missing argument >environment<", null);
      return;
    }

    String appToken = (String) adjustConfigMap.get("appToken");
    String environment = (String) adjustConfigMap.get("environment");

    String secretIdString = (String) adjustConfigMap.get("secretId");
    String info1String = (String) adjustConfigMap.get("info1");
    String info2String = (String) adjustConfigMap.get("info2");
    String info3String = (String) adjustConfigMap.get("info3");
    String info4String = (String) adjustConfigMap.get("info4");

    AdjustConfig config = new AdjustConfig(applicationContext, appToken, environment);

    AdjustSdkPlugin.log("Calling onCreate with values:");
    AdjustSdkPlugin.log("\tappToken: " + appToken);
    AdjustSdkPlugin.log("\tenvironment: " + environment);

    if(adjustConfigMap.containsKey("processName")) {
      String processName = (String) adjustConfigMap.get("processName");
      config.setProcessName(processName);
      AdjustSdkPlugin.log("\tprocessName: " + processName);
    }

    if(adjustConfigMap.containsKey("defaultTracker")) {
      String defaultTracker = (String) adjustConfigMap.get("defaultTracker");
      config.setDefaultTracker(defaultTracker);
      AdjustSdkPlugin.log("\tdefaultTracker: " + defaultTracker);
    }

    if(adjustConfigMap.containsKey("userAgent")) {
      String userAgent = (String) adjustConfigMap.get("userAgent");
      config.setUserAgent(userAgent);
      AdjustSdkPlugin.log("\tuserAgent: " + userAgent);
    }

    if(adjustConfigMap.containsKey("logLevel")) {
      String logLevel = (String) adjustConfigMap.get("logLevel");
      config.setLogLevel(LogLevel.valueOf(logLevel));
      AdjustSdkPlugin.log("\tlogLevel: " + logLevel);
    }

    if(adjustConfigMap.containsKey("eventBufferingEnabled")) {
      String eventBufferingEnabledString = (String) adjustConfigMap.get("eventBufferingEnabled");
      boolean eventBufferingEnabled = Boolean.valueOf(eventBufferingEnabledString);
      config.setEventBufferingEnabled(eventBufferingEnabled);
      AdjustSdkPlugin.log("\teventBufferingEnabled: " + eventBufferingEnabled);
    }

    if(adjustConfigMap.containsKey("sendInBackground")) {
      String sendInBackgroundString = (String) adjustConfigMap.get("sendInBackground");
      boolean sendInBackground = Boolean.valueOf(sendInBackgroundString);
      config.setSendInBackground(sendInBackground);
      AdjustSdkPlugin.log("\tsendInBackground: " + sendInBackground);
    }

    if(adjustConfigMap.containsKey("isDeviceKnown")) {
      String isDeviceKnownString = (String) adjustConfigMap.get("isDeviceKnown");
      boolean isDeviceKnown = Boolean.valueOf(isDeviceKnownString);
      config.setDeviceKnown(isDeviceKnown);
      AdjustSdkPlugin.log("\tisDeviceKnown: " + isDeviceKnown);
    }

    if(adjustConfigMap.containsKey("readImei")) {
      String readImeiString = (String) adjustConfigMap.get("readImei");
      boolean readImei = Boolean.valueOf(readImeiString);
      config.setReadMobileEquipmentIdentity(readImei);
      AdjustSdkPlugin.log("\treadImei: " + readImei);
    }

    if(adjustConfigMap.containsKey("delayStart")) {
      String delayStartString = (String) adjustConfigMap.get("delayStart");
      if(stringIsNumber(delayStartString)) {
        double delayStart = Double.valueOf(delayStartString);
        config.setDelayStart(delayStart);
        AdjustSdkPlugin.log("\tdelayStart: " + delayStart);
      } else {
        AdjustSdkPlugin.error("DelayStart parameter provided, but not a number! DelatStartString = " + delayStartString);
      }
    }

    if(stringIsNumber(secretIdString) && stringIsNumber(info1String) && stringIsNumber(info2String)
            && stringIsNumber(info3String) && stringIsNumber(info4String)) {
      long secretId = Long.valueOf(secretIdString);
      long info1 = Long.valueOf(info1String);
      long info2 = Long.valueOf(info2String);
      long info3 = Long.valueOf(info3String);
      long info4 = Long.valueOf(info4String);

      config.setAppSecret(secretId, info1, info2, info3, info4);
      AdjustSdkPlugin.log(String.format("\tappSecret: %d, %d, %d, %d, %d", secretId, info1, info2, info3, info4));
    }

    config.setOnDeeplinkResponseListener(new OnDeeplinkResponseListener() {
      @Override
      // maybe also implement a `launchReceivedDeeplink` method which returns void, but provides a callback
      // in that case, this could work like a charm
      public boolean launchReceivedDeeplink(Uri uri) {
        HashMap uriParamsMap = new HashMap();
        uriParamsMap.put("uri", uri);

        final boolean[] shouldLaunchUri = new boolean[1];
        deeplinkChannel.invokeMethod("should-launch-uri", uriParamsMap, new Result() {
          @Override
          public void success(Object o) {
            if(o instanceof Boolean) {
              shouldLaunchUri[0] = (Boolean)o;
            } else {
              shouldLaunchUri[0] = false;
            }
          }

          @Override
          public void error(String s, String s1, Object o) {
            shouldLaunchUri[0] = false;
          }

          @Override
          public void notImplemented() {
            shouldLaunchUri[0] = false;
          }
        });

        // TODO: this won't work. it's even stupid :)
        // probalby requires changes in the native part, where launchReceivedDeeplink(uri) can be
        // extended to provide a callback launchReceivedDeeplink(uri, callback) which can be called
        // after the non-native flutter part `should-launch-uri` is called
        return shouldLaunchUri[0];
      }
    });

    config.setOnSessionTrackingSucceededListener(new OnSessionTrackingSucceededListener() {
      @Override
      public void onFinishedSessionTrackingSucceeded(AdjustSessionSuccess adjustSessionSuccess) {
        HashMap adjustSessionSuccessMap = new HashMap();
        adjustSessionSuccessMap.put("message", adjustSessionSuccess.message);
        adjustSessionSuccessMap.put("timestamp", adjustSessionSuccess.timestamp);
        adjustSessionSuccessMap.put("adid", adjustSessionSuccess.adid);
        adjustSessionSuccessMap.put("jsonResponse", adjustSessionSuccess.jsonResponse.toString());

        channel.invokeMethod("session-success", adjustSessionSuccessMap);
      }
    });

    config.setOnSessionTrackingFailedListener(new OnSessionTrackingFailedListener() {
      @Override
      public void onFinishedSessionTrackingFailed(AdjustSessionFailure adjustSessionFailure) {
        HashMap adjustSessionFailureMap = new HashMap();
        adjustSessionFailureMap.put("message", adjustSessionFailure.message);
        adjustSessionFailureMap.put("timestamp", adjustSessionFailure.timestamp);
        adjustSessionFailureMap.put("adid", adjustSessionFailure.adid);
        adjustSessionFailureMap.put("willRetry", adjustSessionFailure.willRetry);
        adjustSessionFailureMap.put("jsonResponse", adjustSessionFailure.jsonResponse.toString());

        channel.invokeMethod("session-fail", adjustSessionFailureMap);
      }
    });

    config.setOnEventTrackingSucceededListener(new OnEventTrackingSucceededListener() {
      @Override
      public void onFinishedEventTrackingSucceeded(AdjustEventSuccess adjustEventSuccess) {
        HashMap adjustEventSuccessMap = new HashMap();
        adjustEventSuccessMap.put("message", adjustEventSuccess.message);
        adjustEventSuccessMap.put("timestamp", adjustEventSuccess.timestamp);
        adjustEventSuccessMap.put("adid", adjustEventSuccess.adid);
        adjustEventSuccessMap.put("eventToken", adjustEventSuccess.eventToken);
        if (adjustEventSuccess.jsonResponse != null) {
          adjustEventSuccessMap.put("jsonResponse", adjustEventSuccess.jsonResponse.toString());
        }

        channel.invokeMethod("event-success", adjustEventSuccessMap);
      }
    });

    config.setOnEventTrackingFailedListener(new OnEventTrackingFailedListener() {
      @Override
      public void onFinishedEventTrackingFailed(AdjustEventFailure adjustEventFailure) {
        HashMap<String, String> adjustEventFailureMap = new HashMap();
        adjustEventFailureMap.put("message", adjustEventFailure.message);
        adjustEventFailureMap.put("timestamp", adjustEventFailure.timestamp);
        adjustEventFailureMap.put("adid", adjustEventFailure.adid);
        adjustEventFailureMap.put("eventToken", adjustEventFailure.eventToken);
        adjustEventFailureMap.put("willRetry", Boolean.toString(adjustEventFailure.willRetry));
        if (adjustEventFailure.jsonResponse != null) {
          adjustEventFailureMap.put("jsonResponse", adjustEventFailure.jsonResponse.toString());
        }

        channel.invokeMethod("event-fail", adjustEventFailureMap);
      }
    });

    config.setOnAttributionChangedListener(new OnAttributionChangedListener() {
      @Override
      public void onAttributionChanged(AdjustAttribution adjustAttribution) {
        HashMap<String, String> adjustAttributionMap = new HashMap();
        adjustAttributionMap.put("trackerToken", adjustAttribution.trackerToken);
        adjustAttributionMap.put("trackerName", adjustAttribution.trackerName);
        adjustAttributionMap.put("network", adjustAttribution.network);
        adjustAttributionMap.put("campaign", adjustAttribution.campaign);
        adjustAttributionMap.put("adgroup", adjustAttribution.adgroup);
        adjustAttributionMap.put("creative", adjustAttribution.creative);
        adjustAttributionMap.put("clickLabel", adjustAttribution.clickLabel);
        adjustAttributionMap.put("adid", adjustAttribution.adid);

        channel.invokeMethod("attribution-change", adjustAttributionMap);
      }
    });

    AdjustBridge.onCreate(config);
    AdjustBridge.onResume();

    result.success(null);
  }

  private void onResume(final Result result) {
    AdjustBridge.onResume();
    result.success(null);
  }

  private void onPause(final Result result) {
    AdjustBridge.onPause();
    result.success(null);
  }

  private void trackEvent(final MethodCall call, final Result result) {
    Map eventParamsMap = (Map)call.arguments;
    if(!eventParamsMap.containsKey("eventToken")) {
      result.error("0", "Arguments null or wrong (missing argument >eventToken<", null);
      return;
    }

    String eventToken = (String) eventParamsMap.get("eventToken");
    AdjustEvent event = new AdjustEvent(eventToken);

    if(eventParamsMap.containsKey("revenue") && eventParamsMap.containsKey("currency")) {
      String revenue = (String) eventParamsMap.get("revenue");
      String currency = (String) eventParamsMap.get("currency");
      event.setRevenue(Double.valueOf(revenue), currency);
    }

    if(eventParamsMap.containsKey("orderId")) {
      String orderId = (String) eventParamsMap.get("orderId");
      event.setOrderId(orderId);
    }

    // get callback parameters
    if(eventParamsMap.containsKey("callbackParameters")) {
      String callbackParametersJsonStr = (String) eventParamsMap.get("callbackParameters");
      try {
        JSONObject callbackParametersJson = new JSONObject(callbackParametersJsonStr);
        JSONArray callbackParamsKeys = callbackParametersJson.names();
        for (int i = 0; i < callbackParamsKeys.length (); ++i) {
          String key = callbackParamsKeys.getString(i);
          String value = callbackParametersJson.getString(key);
          event.addCallbackParameter(key, value);
        }
      } catch (JSONException e) {
        error("Failed to parse event callback parameters!");
        e.printStackTrace();
      }
    }

    // get partner parameters
    if(eventParamsMap.containsKey("partnerParameters")) {
      String partnerParametersJsonStr = (String) eventParamsMap.get("partnerParameters");
      try {
        JSONObject partnerParametersJson = new JSONObject(partnerParametersJsonStr);
        JSONArray partnerParamsKeys = partnerParametersJson.names();
        for (int i = 0; i < partnerParamsKeys.length (); ++i) {
          String key = partnerParamsKeys.getString(i);
          String value = partnerParametersJson.getString(key);
          event.addPartnerParameter(key, value);
        }
      } catch (JSONException e) {
        error("Failed to parse event partner parameters!");
        e.printStackTrace();
      }
    }

    AdjustBridge.trackEvent(event);
    result.success(null);
  }

  private void isEnabled(final Result result) {
    result.success(AdjustBridge.isEnabled());
  }

  private void setOfflineMode(final MethodCall call, final Result result) {
    Map isOfflineParamsMap = (Map)call.arguments;
    boolean isOffline = (boolean) isOfflineParamsMap.get("isOffline");
    AdjustBridge.setOfflineMode(isOffline);
    result.success(null);
  }

  private void setPushToken(final MethodCall call, final Result result) {
    Map tokenParamsMap = (Map)call.arguments;
    if(!tokenParamsMap.containsKey("token")) {
      result.error("0", "Arguments null or wrong (missing argument >token<", null);
      return;
    }

    String pushToken = tokenParamsMap.get("token").toString();
    AdjustBridge.setPushToken(pushToken);
    result.success(null);
  }

  private void setIsEnabled(final MethodCall call, final Result result) {
    Map isEnabledParamsMap = (Map)call.arguments;
    if(!isEnabledParamsMap.containsKey("isEnabled")) {
      result.error("0", "Arguments null or wrong (missing argument >isEnabled<", null);
      return;
    }

    boolean isEnabled = (boolean) isEnabledParamsMap.get("isEnabled");
    AdjustBridge.setIsEnabled(isEnabled);
    result.success(null);
  }

  private void appWillOpenUrl(final MethodCall call, final Result result) {
    Map urlParamsMap = (Map)call.arguments;
    if(!urlParamsMap.containsKey("url")) {
      result.error("0", "Arguments null or wrong (missing argument >url<", null);
      return;
    }

    String url = urlParamsMap.get("url").toString();
    AdjustBridge.appWillOpenUrl(url);
    result.success(null);
  }

  private void sendFirstPackages(final Result result) {
    AdjustBridge.sendFirstPackages();
    result.success(null);
  }

  private void getAdid(final Result result) {
    result.success(AdjustBridge.getAdid());
  }

  private void getIdfa(final Result result) {
    result.error("0", "Error. No IDFA in Android Plaftorm!", null);
  }

  private void getGoogleAdId(final Result result) {
    AdjustBridge.getGoogleAdId(applicationContext, new OnDeviceIdsRead() {
      @Override
      public void onGoogleAdIdRead(String googleAdId) {
        result.success(googleAdId);
      }
    });
  }

  private void getAmazonAdId(final Result result) {
    result.success(AdjustBridge.getAmazonAdId(applicationContext));
  }

  private void gdprForgetMe(final Result result) {
    AdjustBridge.gdprForgetMe(applicationContext);
    result.success(null);
  }

  private void getAttribution(final Result result) {
    result.success(AdjustBridge.getAttribution());
  }

  private void setReferrer(final MethodCall call, final Result result) {
    if(!call.hasArgument("referrer")) {
      result.error("0", "Argument [referrer] null or wrong", null);
      return;
    }

    String referrer = (String) call.argument("referrer");
    AdjustBridge.setReferrer(applicationContext, referrer);
    result.success(null);
  }

  private void addSessionCallbackParameter(final MethodCall call, final Result result) {
    if(!call.hasArgument("key") || !call.hasArgument("value")) {
      result.error("0", "Arguments null or wrong", null);
      return;
    }

    String key = (String) call.argument("key");
    String value = (String) call.argument("value");
    AdjustBridge.addSessionCallbackParameter(key, value);

    result.success(null);
  }

  private void addSessionPartnerParameter(final MethodCall call, final Result result) {
    if(!call.hasArgument("key") || !call.hasArgument("value")) {
      result.error("0", "Arguments null or wrong", null);
      return;
    }

    String key = (String) call.argument("key");
    String value = (String) call.argument("value");
    AdjustBridge.addSessionPartnerParameter(key, value);

    result.success(null);
  }

  private void removeSessionCallbackParameter(final MethodCall call, final Result result) {
    if(!call.hasArgument("key")) {
      result.error("0", "Argument [key] null or wrong", null);
      return;
    }

    String key = (String) call.argument("key");
    AdjustBridge.removeSessionCallbackParameter(key);

    result.success(null);
  }

  private void removeSessionPartnerParameter(final MethodCall call, final Result result) {
    if(!call.hasArgument("key")) {
      result.error("0", "Argument [key] null or wrong", null);
      return;
    }

    String key = (String) call.argument("key");
    AdjustBridge.removeSessionPartnerParameter(key);

    result.success(null);
  }

  private void resetSessionCallbackParameters(final Result result) {
    AdjustBridge.resetSessionCallbackParameters();
    result.success(null);
  }

  private void resetSessionPartnerParameters(final Result result) {
    AdjustBridge.resetSessionPartnerParameters();
    result.success(null);
  }

  public static void log(String message) {
    System.out.println("ADJUST-PLUGIN-BRIDGE: " + message);
  }

  public static void error(String message) { System.out.println("ADJUST-PLUGIN-BRIDGE: ERROR - " + message); }
}
