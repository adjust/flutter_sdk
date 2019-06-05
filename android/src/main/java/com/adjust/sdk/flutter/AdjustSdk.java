//
//  AdjustSdk.java
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

package com.adjust.sdk.flutter;

import android.content.Context;
import android.net.Uri;
import android.util.Log;

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

import static com.adjust.sdk.flutter.AdjustUtils.*;

public class AdjustSdk implements MethodCallHandler {
    private static String TAG = "AdjustBridge";
    private static boolean launchDeferredDeeplink = true;
    private MethodChannel channel;
    private Context applicationContext;

    AdjustSdk(MethodChannel channel, Context applicationContext) {
        this.channel = channel;
        this.applicationContext = applicationContext;
    }

    // Plugin registration.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.adjust.sdk/api");
        channel.setMethodCallHandler(new AdjustSdk(channel, registrar.context()));
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case "start":
                start(call, result);
                break;
            case "onPause":
                onPause(result);
                break;
            case "onResume":
                onResume(result);
                break;
            case "trackEvent":
                trackEvent(call, result);
                break;
            case "isEnabled":
                isEnabled(result);
                break;
            case "setEnabled":
                setEnabled(call, result);
                break;
            case "setOfflineMode":
                setOfflineMode(call, result);
                break;
            case "setPushToken":
                setPushToken(call, result);
                break;
            case "appWillOpenUrl":
                appWillOpenUrl(call, result);
                break;
            case "sendFirstPackages":
                sendFirstPackages(result);
                break;
            case "getAdid":
                getAdid(result);
                break;
            case "getIdfa":
                getIdfa(result);
                break;
            case "getGoogleAdId":
                getGoogleAdId(result);
                break;
            case "getAmazonAdId":
                getAmazonAdId(result);
                break;
            case "getAttribution":
                getAttribution(result);
                break;
            case "getSdkVersion":
                getSdkVersion(result);
                break;
            case "setReferrer":
                setReferrer(call, result);
                break;
            case "gdprForgetMe":
                gdprForgetMe(result);
                break;
            case "addSessionCallbackParameter":
                addSessionCallbackParameter(call, result);
                break;
            case "addSessionPartnerParameter":
                addSessionPartnerParameter(call, result);
                break;
            case "removeSessionCallbackParameter":
                removeSessionCallbackParameter(call, result);
                break;
            case "removeSessionPartnerParameter":
                removeSessionPartnerParameter(call, result);
                break;
            case "resetSessionCallbackParameters":
                resetSessionCallbackParameters(result);
                break;
            case "resetSessionPartnerParameters":
                resetSessionPartnerParameters(result);
                break;
            case "setTestOptions":
                setTestOptions(call, result);
                break;
            default:
                Log.e(TAG, "Not implemented method: " + call.method);
                result.notImplemented();
                break;
        }
    }

    private void start(final MethodCall call, final Result result) {
        Map configMap = (Map) call.arguments;
        if (configMap == null) {
            return;
        }

        String appToken = null;
        String environment = null;
        String logLevel = null;
        boolean isLogLevelSuppress = false;

        // App token.
        if (configMap.containsKey("appToken")) {
            appToken = (String) configMap.get("appToken");
        }

        // Environment.
        if (configMap.containsKey("environment")) {
            environment = (String) configMap.get("environment");
        }

        // Suppress log level.
        if (configMap.containsKey("logLevel")) {
            logLevel = (String) configMap.get("logLevel");
            if (logLevel.equals("suppress")) {
                isLogLevelSuppress = true;
            }
        }

        // Create configuration object.
        AdjustConfig adjustConfig = new AdjustConfig(applicationContext, appToken, environment, isLogLevelSuppress);

        // SDK prefix.
        if (configMap.containsKey("sdkPrefix")) {
            String sdkPrefix = (String) configMap.get("sdkPrefix");
            adjustConfig.setSdkPrefix(sdkPrefix);
        }

        // Log level.
        if (configMap.containsKey("logLevel")) {
            logLevel = (String) configMap.get("logLevel");
            if (logLevel.equals("verbose")) {
                adjustConfig.setLogLevel(LogLevel.VERBOSE);
            } else if (logLevel.equals("debug")) {
                adjustConfig.setLogLevel(LogLevel.DEBUG);
            } else if (logLevel.equals("info")) {
                adjustConfig.setLogLevel(LogLevel.INFO);
            } else if (logLevel.equals("warn")) {
                adjustConfig.setLogLevel(LogLevel.WARN);
            } else if (logLevel.equals("error")) {
                adjustConfig.setLogLevel(LogLevel.ERROR);
            } else if (logLevel.equals("assert")) {
                adjustConfig.setLogLevel(LogLevel.ASSERT);
            } else if (logLevel.equals("suppress")) {
                adjustConfig.setLogLevel(LogLevel.SUPRESS);
            } else {
                adjustConfig.setLogLevel(LogLevel.INFO);
            }
        }

        // Event buffering.
        if (configMap.containsKey("eventBufferingEnabled")) {
            String eventBufferingEnabledString = (String) configMap.get("eventBufferingEnabled");
            boolean eventBufferingEnabled = Boolean.valueOf(eventBufferingEnabledString);
            adjustConfig.setEventBufferingEnabled(eventBufferingEnabled);
        }

        // Main process name.
        if (configMap.containsKey("processName")) {
            String processName = (String) configMap.get("processName");
            adjustConfig.setProcessName(processName);
        }

        // Default tracker.
        if (configMap.containsKey("defaultTracker")) {
            String defaultTracker = (String) configMap.get("defaultTracker");
            adjustConfig.setDefaultTracker(defaultTracker);
        }

        // User agent.
        if (configMap.containsKey("userAgent")) {
            String userAgent = (String) configMap.get("userAgent");
            adjustConfig.setUserAgent(userAgent);
        }

        // Background tracking.
        if (configMap.containsKey("sendInBackground")) {
            String strSendInBackground = (String) configMap.get("sendInBackground");
            boolean sendInBackground = Boolean.valueOf(strSendInBackground);
            adjustConfig.setSendInBackground(sendInBackground);
        }

        // Set device known.
        if (configMap.containsKey("isDeviceKnown")) {
            String strIsDeviceKnown = (String) configMap.get("isDeviceKnown");
            boolean isDeviceKnown = Boolean.valueOf(strIsDeviceKnown);
            adjustConfig.setDeviceKnown(isDeviceKnown);
        }

        // Delayed start.
        if (configMap.containsKey("delayStart")) {
            String strDelayStart = (String) configMap.get("delayStart");
            if (isNumber(strDelayStart)) {
                double delayStart = Double.valueOf(strDelayStart);
                adjustConfig.setDelayStart(delayStart);
            }
        }

        // App secret.
        if (configMap.containsKey("secretId")
                && configMap.containsKey("info1")
                && configMap.containsKey("info2")
                && configMap.containsKey("info3")
                && configMap.containsKey("info4")) {
            try {
                String strSecretId = (String) configMap.get("secretId");
                String strInfo1 = (String) configMap.get("info1");
                String strInfo2 = (String) configMap.get("info2");
                String strInfo3 = (String) configMap.get("info3");
                String strInfo4 = (String) configMap.get("info4");
                long secretId = Long.parseLong(strSecretId, 10);
                long info1 = Long.parseLong(strInfo1, 10);
                long info2 = Long.parseLong(strInfo2, 10);
                long info3 = Long.parseLong(strInfo3, 10);
                long info4 = Long.parseLong(strInfo4, 10);
                adjustConfig.setAppSecret(secretId, info1, info2, info3, info4);
            } catch (NumberFormatException ignore) {}
        }

        // Launch deferred deep link.
        if (configMap.containsKey("launchDeferredDeeplink")) {
            String strLaunchDeferredDeeplink = (String) configMap.get("launchDeferredDeeplink");
            this.launchDeferredDeeplink = strLaunchDeferredDeeplink.equals("true");
        }

        // Attribution callback.
        if (configMap.containsKey("attributionCallback")) {
            final String dartMethodName = (String) configMap.get("attributionCallback");
            adjustConfig.setOnAttributionChangedListener(new OnAttributionChangedListener() {
                @Override
                public void onAttributionChanged(AdjustAttribution adjustAttribution) {
                    HashMap<String, String> adjustAttributionMap = new HashMap<String, String>();
                    adjustAttributionMap.put("trackerToken", adjustAttribution.trackerToken);
                    adjustAttributionMap.put("trackerName", adjustAttribution.trackerName);
                    adjustAttributionMap.put("network", adjustAttribution.network);
                    adjustAttributionMap.put("campaign", adjustAttribution.campaign);
                    adjustAttributionMap.put("adgroup", adjustAttribution.adgroup);
                    adjustAttributionMap.put("creative", adjustAttribution.creative);
                    adjustAttributionMap.put("clickLabel", adjustAttribution.clickLabel);
                    adjustAttributionMap.put("adid", adjustAttribution.adid);
                    channel.invokeMethod(dartMethodName, adjustAttributionMap);
                }
            });
        }

        // Session success callback.
        if (configMap.containsKey("sessionSuccessCallback")) {
            final String dartMethodName = (String) configMap.get("sessionSuccessCallback");
            adjustConfig.setOnSessionTrackingSucceededListener(new OnSessionTrackingSucceededListener() {
                @Override
                public void onFinishedSessionTrackingSucceeded(AdjustSessionSuccess adjustSessionSuccess) {
                    HashMap<String, String> adjustSessionSuccessMap = new HashMap<String, String>();
                    adjustSessionSuccessMap.put("message", adjustSessionSuccess.message);
                    adjustSessionSuccessMap.put("timestamp", adjustSessionSuccess.timestamp);
                    adjustSessionSuccessMap.put("adid", adjustSessionSuccess.adid);
                    if (adjustSessionSuccess.jsonResponse != null) {
                        adjustSessionSuccessMap.put("jsonResponse", adjustSessionSuccess.jsonResponse.toString());
                    }
                    channel.invokeMethod(dartMethodName, adjustSessionSuccessMap);
                }
            });
        }

        // Session failure callback.
        if (configMap.containsKey("sessionFailureCallback")) {
            final String dartMethodName = (String) configMap.get("sessionFailureCallback");
            adjustConfig.setOnSessionTrackingFailedListener(new OnSessionTrackingFailedListener() {
                @Override
                public void onFinishedSessionTrackingFailed(AdjustSessionFailure adjustSessionFailure) {
                    HashMap<String, String> adjustSessionFailureMap = new HashMap<String, String>();
                    adjustSessionFailureMap.put("message", adjustSessionFailure.message);
                    adjustSessionFailureMap.put("timestamp", adjustSessionFailure.timestamp);
                    adjustSessionFailureMap.put("adid", adjustSessionFailure.adid);
                    adjustSessionFailureMap.put("willRetry", Boolean.toString(adjustSessionFailure.willRetry));
                    if (adjustSessionFailure.jsonResponse != null) {
                        adjustSessionFailureMap.put("jsonResponse", adjustSessionFailure.jsonResponse.toString());
                    }
                    channel.invokeMethod(dartMethodName, adjustSessionFailureMap);
                }
            });
        }

        // Event success callback.
        if (configMap.containsKey("eventSuccessCallback")) {
            final String dartMethodName = (String) configMap.get("eventSuccessCallback");
            adjustConfig.setOnEventTrackingSucceededListener(new OnEventTrackingSucceededListener() {
                @Override
                public void onFinishedEventTrackingSucceeded(AdjustEventSuccess adjustEventSuccess) {
                    HashMap<String, String> adjustEventSuccessMap = new HashMap<String, String>();
                    adjustEventSuccessMap.put("message", adjustEventSuccess.message);
                    adjustEventSuccessMap.put("timestamp", adjustEventSuccess.timestamp);
                    adjustEventSuccessMap.put("adid", adjustEventSuccess.adid);
                    adjustEventSuccessMap.put("eventToken", adjustEventSuccess.eventToken);
                    adjustEventSuccessMap.put("callbackId", adjustEventSuccess.callbackId);
                    if (adjustEventSuccess.jsonResponse != null) {
                        adjustEventSuccessMap.put("jsonResponse", adjustEventSuccess.jsonResponse.toString());
                    }
                    channel.invokeMethod(dartMethodName, adjustEventSuccessMap);
                }
            });
        }

        // Event failure callback.
        if (configMap.containsKey("eventFailureCallback")) {
            final String dartMethodName = (String) configMap.get("eventFailureCallback");
            adjustConfig.setOnEventTrackingFailedListener(new OnEventTrackingFailedListener() {
                @Override
                public void onFinishedEventTrackingFailed(AdjustEventFailure adjustEventFailure) {
                    HashMap<String, String> adjustEventFailureMap = new HashMap<String, String>();
                    adjustEventFailureMap.put("message", adjustEventFailure.message);
                    adjustEventFailureMap.put("timestamp", adjustEventFailure.timestamp);
                    adjustEventFailureMap.put("adid", adjustEventFailure.adid);
                    adjustEventFailureMap.put("eventToken", adjustEventFailure.eventToken);
                    adjustEventFailureMap.put("callbackId", adjustEventFailure.callbackId);
                    adjustEventFailureMap.put("willRetry", Boolean.toString(adjustEventFailure.willRetry));
                    if (adjustEventFailure.jsonResponse != null) {
                        adjustEventFailureMap.put("jsonResponse", adjustEventFailure.jsonResponse.toString());
                    }
                    channel.invokeMethod(dartMethodName, adjustEventFailureMap);
                }
            });
        }

        // Deferred deep link callback.
        if (configMap.containsKey("deferredDeeplinkCallback")) {
            final String dartMethodName = (String) configMap.get("deferredDeeplinkCallback");
            adjustConfig.setOnDeeplinkResponseListener(new OnDeeplinkResponseListener() {
                @Override
                public boolean launchReceivedDeeplink(Uri uri) {
                    HashMap<String, String> uriParamsMap = new HashMap<String, String>();
                    uriParamsMap.put("uri", uri.toString());
                    channel.invokeMethod(dartMethodName, uriParamsMap);
                    return launchDeferredDeeplink;
                }
            });
        }

        // Start SDK.
        Adjust.onCreate(adjustConfig);
        Adjust.onResume();
        result.success(null);
    }

    private void trackEvent(final MethodCall call, final Result result) {
        Map eventMap = (Map) call.arguments;
        if (eventMap == null) {
            return;
        }

        // Event token.
        String eventToken = null;
        if (eventMap.containsKey("eventToken")) {
            eventToken = (String) eventMap.get("eventToken");
        }

        // Create event object.
        AdjustEvent event = new AdjustEvent(eventToken);

        // Revenue.
        if (eventMap.containsKey("revenue") || eventMap.containsKey("currency")) {
            double revenue = -1.0;
            String strRevenue = (String) eventMap.get("revenue");

            try {
                revenue = Double.parseDouble(strRevenue);
            } catch (NumberFormatException ignore) {}

            String currency = (String) eventMap.get("currency");
            event.setRevenue(revenue, currency);
        }

        // Revenue deduplication.
        if (eventMap.containsKey("transactionId")) {
            String orderId = (String) eventMap.get("transactionId");
            event.setOrderId(orderId);
        }

        // Callback ID.
        if (eventMap.containsKey("callbackId")) {
            String callbackId = (String) eventMap.get("callbackId");
            event.setCallbackId(callbackId);
        }

        // Callback parameters.
        if (eventMap.containsKey("callbackParameters")) {
            String strCallbackParametersJson = (String) eventMap.get("callbackParameters");
            try {
                JSONObject jsonCallbackParameters = new JSONObject(strCallbackParametersJson);
                JSONArray callbackParametersKeys = jsonCallbackParameters.names();
                for (int i = 0; i < callbackParametersKeys.length(); ++i) {
                    String key = callbackParametersKeys.getString(i);
                    String value = jsonCallbackParameters.getString(key);
                    event.addCallbackParameter(key, value);
                }
            } catch (JSONException e) {
                Log.e(TAG, "Failed to parse event callback parameter! Details: " + e);
            }
        }

        // Partner parameters.
        if (eventMap.containsKey("partnerParameters")) {
            String strPartnerParametersJson = (String) eventMap.get("partnerParameters");
            try {
                JSONObject jsonPartnerParameters = new JSONObject(strPartnerParametersJson);
                JSONArray partnerParametersKeys = jsonPartnerParameters.names();
                for (int i = 0; i < partnerParametersKeys.length(); ++i) {
                    String key = partnerParametersKeys.getString(i);
                    String value = jsonPartnerParameters.getString(key);
                    event.addPartnerParameter(key, value);
                }
            } catch (JSONException e) {
                Log.e(TAG, "Failed to parse event partner parameter! Details: " + e);
            }
        }

        // Track event.
        Adjust.trackEvent(event);
        result.success(null);
    }

    private void setOfflineMode(final MethodCall call, final Result result) {
        Map isOfflineParamsMap = (Map) call.arguments;
        boolean isOffline = (boolean) isOfflineParamsMap.get("isOffline");
        Adjust.setOfflineMode(isOffline);
        result.success(null);
    }

    private void setPushToken(final MethodCall call, final Result result) {
        Map tokenParamsMap = (Map) call.arguments;
        String pushToken = null;
        if (tokenParamsMap.containsKey("pushToken")) {
            pushToken = tokenParamsMap.get("pushToken").toString();
        }
        Adjust.setPushToken(pushToken, applicationContext);
        result.success(null);
    }

    private void setEnabled(final MethodCall call, final Result result) {
        Map isEnabledParamsMap = (Map) call.arguments;
        if (!isEnabledParamsMap.containsKey("isEnabled")) {
            result.error("0", "Arguments null or wrong (missing argument of 'isEnabled' method.", null);
            return;
        }

        boolean isEnabled = (boolean) isEnabledParamsMap.get("isEnabled");
        Adjust.setEnabled(isEnabled);
        result.success(null);
    }

    private void appWillOpenUrl(final MethodCall call, final Result result) {
        Map urlParamsMap = (Map) call.arguments;
        String url = null;
        if (urlParamsMap.containsKey("url")) {
            url = urlParamsMap.get("url").toString();
        }
        Adjust.appWillOpenUrl(Uri.parse(url), applicationContext);
        result.success(null);
    }

    // Exposed for handling deep linking from native layer of the example app.
    public static void appWillOpenUrl(Uri deeplink, Context context) {
        Adjust.appWillOpenUrl(deeplink, context);
    }

    private void sendFirstPackages(final Result result) {
        Adjust.sendFirstPackages();
        result.success(null);
    }

    private void onResume(final Result result) {
        Adjust.onResume();
        result.success(null);
    }

    private void onPause(final Result result) {
        Adjust.onPause();
        result.success(null);
    }

    private void isEnabled(final Result result) {
        result.success(Adjust.isEnabled());
    }

    private void getAdid(final Result result) {
        result.success(Adjust.getAdid());
    }

    private void getIdfa(final Result result) {
        result.error("0", "Error. No IDFA for Android plaftorm!", null);
    }

    private void getGoogleAdId(final Result result) {
        Adjust.getGoogleAdId(applicationContext, new OnDeviceIdsRead() {
            @Override
            public void onGoogleAdIdRead(String googleAdId) {
                result.success(googleAdId);
            }
        });
    }

    private void getAmazonAdId(final Result result) {
        result.success(Adjust.getAmazonAdId(applicationContext));
    }

    private void gdprForgetMe(final Result result) {
        Adjust.gdprForgetMe(applicationContext);
        result.success(null);
    }

    private void getAttribution(final Result result) {
        AdjustAttribution adjustAttribution = Adjust.getAttribution();
        if (adjustAttribution == null) {
            adjustAttribution = new AdjustAttribution();
        }

        HashMap<String, String> adjustAttributionMap = new HashMap<String, String>();
        adjustAttributionMap.put("trackerToken", adjustAttribution.trackerToken);
        adjustAttributionMap.put("trackerName", adjustAttribution.trackerName);
        adjustAttributionMap.put("network", adjustAttribution.network);
        adjustAttributionMap.put("campaign", adjustAttribution.campaign);
        adjustAttributionMap.put("adgroup", adjustAttribution.adgroup);
        adjustAttributionMap.put("creative", adjustAttribution.creative);
        adjustAttributionMap.put("clickLabel", adjustAttribution.clickLabel);
        adjustAttributionMap.put("adid", adjustAttribution.adid);
        result.success(adjustAttributionMap);
    }

    private void getSdkVersion(final Result result) {
        result.success(Adjust.getSdkVersion());
    }

    private void setReferrer(final MethodCall call, final Result result) {
        String referrer = null;
        if (call.hasArgument("referrer")) {
            referrer = (String) call.argument("referrer");
        }
        Adjust.setReferrer(referrer, applicationContext);
        result.success(null);
    }

    private void addSessionCallbackParameter(final MethodCall call, final Result result) {
        String key = null;
        String value = null;
        if (call.hasArgument("key") && call.hasArgument("value")) {
            key = (String) call.argument("key");
            value = (String) call.argument("value");
        }
        Adjust.addSessionCallbackParameter(key, value);
        result.success(null);
    }

    private void addSessionPartnerParameter(final MethodCall call, final Result result) {
        String key = null;
        String value = null;
        if (call.hasArgument("key") && call.hasArgument("value")) {
            key = (String) call.argument("key");
            value = (String) call.argument("value");
        }
        Adjust.addSessionPartnerParameter(key, value);
        result.success(null);
    }

    private void removeSessionCallbackParameter(final MethodCall call, final Result result) {
        String key = null;
        if (call.hasArgument("key")) {
            key = (String) call.argument("key");
        }
        Adjust.removeSessionCallbackParameter(key);
        result.success(null);
    }

    private void removeSessionPartnerParameter(final MethodCall call, final Result result) {
        String key = null;
        if (call.hasArgument("key")) {
            key = (String) call.argument("key");
        }
        Adjust.removeSessionPartnerParameter(key);
        result.success(null);
    }

    private void resetSessionCallbackParameters(final Result result) {
        Adjust.resetSessionCallbackParameters();
        result.success(null);
    }

    private void resetSessionPartnerParameters(final Result result) {
        Adjust.resetSessionPartnerParameters();
        result.success(null);
    }

    private void setTestOptions(final MethodCall call, final Result result) {
        AdjustTestOptions testOptions = new AdjustTestOptions();
        Map testOptionsMap = (Map) call.arguments;

        if (testOptionsMap.containsKey("baseUrl")) {
            testOptions.baseUrl = (String) testOptionsMap.get("baseUrl");
        }
        if (testOptionsMap.containsKey("gdprUrl")) {
            testOptions.gdprUrl = (String) testOptionsMap.get("gdprUrl");
        }
        if (testOptionsMap.containsKey("basePath")) {
            testOptions.basePath = (String) testOptionsMap.get("basePath");
        }
        if (testOptionsMap.containsKey("gdprPath")) {
            testOptions.gdprPath = (String) testOptionsMap.get("gdprPath");
        }
        if (testOptionsMap.containsKey("useTestConnectionOptions")) {
            testOptions.useTestConnectionOptions = testOptionsMap.get("useTestConnectionOptions").toString().equals("true");
        }
        if (testOptionsMap.containsKey("noBackoffWait")) {
            testOptions.noBackoffWait = testOptionsMap.get("noBackoffWait").toString().equals("true");
        }
        if (testOptionsMap.containsKey("teardown")) {
            testOptions.teardown = testOptionsMap.get("teardown").toString().equals("true");
        }
        if (testOptionsMap.containsKey("tryInstallReferrer")) {
            testOptions.tryInstallReferrer = testOptionsMap.get("tryInstallReferrer").toString().equals("true");
        }
        if (testOptionsMap.containsKey("timerIntervalInMilliseconds")) {
            testOptions.timerIntervalInMilliseconds = Long.parseLong(testOptionsMap.get("timerIntervalInMilliseconds").toString());
        }
        if (testOptionsMap.containsKey("timerStartInMilliseconds")) {
            testOptions.timerStartInMilliseconds = Long.parseLong(testOptionsMap.get("timerStartInMilliseconds").toString());
        }
        if (testOptionsMap.containsKey("sessionIntervalInMilliseconds")) {
            testOptions.sessionIntervalInMilliseconds = Long.parseLong(testOptionsMap.get("sessionIntervalInMilliseconds").toString());
        }
        if (testOptionsMap.containsKey("subsessionIntervalInMilliseconds")) {
            testOptions.subsessionIntervalInMilliseconds = Long.parseLong(testOptionsMap.get("subsessionIntervalInMilliseconds").toString());
        }
        if (testOptionsMap.containsKey("deleteState")) {
            testOptions.context = applicationContext;
        }

        Adjust.setTestOptions(testOptions);
    }
}
