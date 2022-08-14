//
//  AdjustSdk.java
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

package com.adjust.sdk.flutter;

import android.content.Context;
import android.net.Uri;
import android.util.Log;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustAdRevenue;
import com.adjust.sdk.AdjustAttribution;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;
import com.adjust.sdk.AdjustEventFailure;
import com.adjust.sdk.AdjustEventSuccess;
import com.adjust.sdk.AdjustSessionFailure;
import com.adjust.sdk.AdjustSessionSuccess;
import com.adjust.sdk.AdjustPlayStoreSubscription;
import com.adjust.sdk.AdjustThirdPartySharing;
import com.adjust.sdk.AdjustTestOptions;
import com.adjust.sdk.LogLevel;
import com.adjust.sdk.OnAttributionChangedListener;
import com.adjust.sdk.OnDeeplinkResponseListener;
import com.adjust.sdk.OnDeviceIdsRead;
import com.adjust.sdk.OnEventTrackingFailedListener;
import com.adjust.sdk.OnEventTrackingSucceededListener;
import com.adjust.sdk.OnSessionTrackingFailedListener;
import com.adjust.sdk.OnSessionTrackingSucceededListener;
import com.adjust.sdk.oaid.AdjustOaid;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

import static com.adjust.sdk.flutter.AdjustUtils.*;

public class AdjustSdk implements FlutterPlugin, ActivityAware, MethodCallHandler {
    private static String TAG = "AdjustBridge";
    private static boolean launchDeferredDeeplink = true;
    private MethodChannel channel;
    private Context applicationContext;

    // FlutterPlugin
    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        applicationContext = binding.getApplicationContext();
        channel = new MethodChannel(binding.getBinaryMessenger(), "com.adjust.sdk/api");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        applicationContext = null;
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
        channel = null;
    }

    // ActivityAware
    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        Adjust.onResume();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(
        ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
        Adjust.onPause();
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
            case "disableThirdPartySharing":
                disableThirdPartySharing(result);
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
            case "trackAdRevenue":
                trackAdRevenue(call, result);
                break;
            case "trackAdRevenueNew":
                trackAdRevenueNew(call, result);
                break;
            case "trackAppStoreSubscription":
                trackAppStoreSubscription(result);
                break;
            case "trackPlayStoreSubscription":
                trackPlayStoreSubscription(call, result);
                break;
            case "requestTrackingAuthorizationWithCompletionHandler":
                requestTrackingAuthorizationWithCompletionHandler(result);
                break;
            case "updateConversionValue":
                updateConversionValue(result);
                break;
            case "trackThirdPartySharing":
                trackThirdPartySharing(call, result);
                break;
            case "trackMeasurementConsent":
                trackMeasurementConsent(call, result);
                break;
            case "setTestOptions":
                setTestOptions(call, result);
                break;
            case "readOaid":
                readOaid(call,result);
                break;
            case "doNotReadOaid":
                doNotReadOaid(call,result);
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
            if (logLevel != null && logLevel.equals("suppress")) {
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
            if (logLevel != null) {
                switch (logLevel) {
                    case "verbose":
                        adjustConfig.setLogLevel(LogLevel.VERBOSE);
                        break;
                    case "debug":
                        adjustConfig.setLogLevel(LogLevel.DEBUG);
                        break;
                    case "warn":
                        adjustConfig.setLogLevel(LogLevel.WARN);
                        break;
                    case "error":
                        adjustConfig.setLogLevel(LogLevel.ERROR);
                        break;
                    case "assert":
                        adjustConfig.setLogLevel(LogLevel.ASSERT);
                        break;
                    case "suppress":
                        adjustConfig.setLogLevel(LogLevel.SUPRESS);
                        break;
                    case "info":
                    default:
                        adjustConfig.setLogLevel(LogLevel.INFO);
                        break;
                }
            }
        }

        // Event buffering.
        if (configMap.containsKey("eventBufferingEnabled")) {
            String eventBufferingEnabledString = (String) configMap.get("eventBufferingEnabled");
            boolean eventBufferingEnabled = Boolean.parseBoolean(eventBufferingEnabledString);
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

        // External device ID.
        if (configMap.containsKey("externalDeviceId")) {
            String externalDeviceId = (String) configMap.get("externalDeviceId");
            adjustConfig.setExternalDeviceId(externalDeviceId);
        }

        // Custom preinstall file path.
        if (configMap.containsKey("preinstallFilePath")) {
            String preinstallFilePath = (String) configMap.get("preinstallFilePath");
            adjustConfig.setPreinstallFilePath(preinstallFilePath);
        }

        // coppaCompliant
        if (configMap.containsKey("coppaCompliantEnabled")) {
            String strCoppaCompliantEnabled = (String) configMap.get("coppaCompliantEnabled");
            boolean coppaCompliantEnabled = Boolean.parseBoolean(strCoppaCompliantEnabled);
            adjustConfig.setCoppaCompliantEnabled(coppaCompliantEnabled);
        }

        // playStoreKidsApp
        if (configMap.containsKey("playStoreKidsAppEnabled")) {
            String strPlayStoreKidsAppEnabled = (String) configMap.get("playStoreKidsAppEnabled");
            boolean playStoreKidsAppEnabled = Boolean.parseBoolean(strPlayStoreKidsAppEnabled);
            adjustConfig.setPlayStoreKidsAppEnabled(playStoreKidsAppEnabled);
        }

        // URL strategy.
        if (configMap.containsKey("urlStrategy")) {
            String urlStrategy = (String) configMap.get("urlStrategy");
            if (urlStrategy.equalsIgnoreCase("china")) {
                adjustConfig.setUrlStrategy(AdjustConfig.URL_STRATEGY_CHINA);
            } else if (urlStrategy.equalsIgnoreCase("india")) {
                adjustConfig.setUrlStrategy(AdjustConfig.URL_STRATEGY_INDIA);
            } else if (urlStrategy.equalsIgnoreCase("data-residency-eu")) {
                adjustConfig.setUrlStrategy(AdjustConfig.DATA_RESIDENCY_EU);
            } else if (urlStrategy.equalsIgnoreCase("data-residency-tr")) {
                adjustConfig.setUrlStrategy(AdjustConfig.DATA_RESIDENCY_TR);
            } else if (urlStrategy.equalsIgnoreCase("data-residency-us")) {
                adjustConfig.setUrlStrategy(AdjustConfig.DATA_RESIDENCY_US);
            }
        }

        // User agent.
        if (configMap.containsKey("userAgent")) {
            String userAgent = (String) configMap.get("userAgent");
            adjustConfig.setUserAgent(userAgent);
        }

        // Background tracking.
        if (configMap.containsKey("sendInBackground")) {
            String strSendInBackground = (String) configMap.get("sendInBackground");
            boolean sendInBackground = Boolean.parseBoolean(strSendInBackground);
            adjustConfig.setSendInBackground(sendInBackground);
        }

        // Set device known.
        if (configMap.containsKey("isDeviceKnown")) {
            String strIsDeviceKnown = (String) configMap.get("isDeviceKnown");
            boolean isDeviceKnown = Boolean.parseBoolean(strIsDeviceKnown);
            adjustConfig.setDeviceKnown(isDeviceKnown);
        }

        // Cost data.
        if (configMap.containsKey("needsCost")) {
            String strNeedsCost = (String) configMap.get("needsCost");
            boolean needsCost = Boolean.parseBoolean(strNeedsCost);
            adjustConfig.setNeedsCost(needsCost);
        }

        // Preinstall tracking.
        if (configMap.containsKey("preinstallTrackingEnabled")) {
            String strPreinstallTrackingEnabled = (String) configMap.get("preinstallTrackingEnabled");
            boolean preinstallTrackingEnabled = Boolean.parseBoolean(strPreinstallTrackingEnabled);
            adjustConfig.setPreinstallTrackingEnabled(preinstallTrackingEnabled);
        }

        // Delayed start.
        if (configMap.containsKey("delayStart")) {
            String strDelayStart = (String) configMap.get("delayStart");
            if (isNumber(strDelayStart)) {
                double delayStart = Double.parseDouble(strDelayStart);
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
            launchDeferredDeeplink = strLaunchDeferredDeeplink.equals("true");
        }

        // Attribution callback.
        if (configMap.containsKey("attributionCallback")) {
            final String dartMethodName = (String) configMap.get("attributionCallback");
            if (dartMethodName != null) {
                adjustConfig.setOnAttributionChangedListener(new OnAttributionChangedListener() {
                    @Override
                    public void onAttributionChanged(AdjustAttribution adjustAttribution) {
                        HashMap<String, Object> adjustAttributionMap = new HashMap<String, Object>();
                        adjustAttributionMap.put("trackerToken", adjustAttribution.trackerToken);
                        adjustAttributionMap.put("trackerName", adjustAttribution.trackerName);
                        adjustAttributionMap.put("network", adjustAttribution.network);
                        adjustAttributionMap.put("campaign", adjustAttribution.campaign);
                        adjustAttributionMap.put("adgroup", adjustAttribution.adgroup);
                        adjustAttributionMap.put("creative", adjustAttribution.creative);
                        adjustAttributionMap.put("clickLabel", adjustAttribution.clickLabel);
                        adjustAttributionMap.put("adid", adjustAttribution.adid);
                        adjustAttributionMap.put("costType", adjustAttribution.costType);
                        adjustAttributionMap.put("costAmount", adjustAttribution.costAmount != null ?
                                adjustAttribution.costAmount.toString() : "");
                        adjustAttributionMap.put("costCurrency", adjustAttribution.costCurrency);
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, adjustAttributionMap);
                        }
                    }
                });
            }
        }

        // Session success callback.
        if (configMap.containsKey("sessionSuccessCallback")) {
            final String dartMethodName = (String) configMap.get("sessionSuccessCallback");
            if (dartMethodName != null) {
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
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, adjustSessionSuccessMap);
                        }
                    }
                });
            }
        }

        // Session failure callback.
        if (configMap.containsKey("sessionFailureCallback")) {
            final String dartMethodName = (String) configMap.get("sessionFailureCallback");
            if (dartMethodName != null) {
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
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, adjustSessionFailureMap);
                        }
                    }
                });
            }
        }

        // Event success callback.
        if (configMap.containsKey("eventSuccessCallback")) {
            final String dartMethodName = (String) configMap.get("eventSuccessCallback");
            if (dartMethodName != null) {
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
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, adjustEventSuccessMap);
                        }
                    }
                });
            }
        }

        // Event failure callback.
        if (configMap.containsKey("eventFailureCallback")) {
            final String dartMethodName = (String) configMap.get("eventFailureCallback");
            if (dartMethodName != null) {
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
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, adjustEventFailureMap);
                        }
                    }
                });
            }
        }

        // Deferred deep link callback.
        if (configMap.containsKey("deferredDeeplinkCallback")) {
            final String dartMethodName = (String) configMap.get("deferredDeeplinkCallback");
            if (dartMethodName != null) {
                adjustConfig.setOnDeeplinkResponseListener(new OnDeeplinkResponseListener() {
                    @Override
                    public boolean launchReceivedDeeplink(Uri uri) {
                        HashMap<String, String> uriParamsMap = new HashMap<String, String>();
                        uriParamsMap.put("uri", uri.toString());
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, uriParamsMap);
                        }
                        return launchDeferredDeeplink;
                    }
                });
            }
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
        result.notImplemented();
        // result.error("0", "Error. No IDFA for Android platform!", null);
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

    private void disableThirdPartySharing(final Result result) {
        Adjust.disableThirdPartySharing(applicationContext);
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
        adjustAttributionMap.put("costType", adjustAttribution.costType);
        adjustAttributionMap.put("costAmount", adjustAttribution.costAmount != null ?
                adjustAttribution.costAmount.toString() : "");
        adjustAttributionMap.put("costCurrency", adjustAttribution.costCurrency);
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

    private void trackAdRevenue(final MethodCall call, final Result result) {
        if (call.hasArgument("source") && call.hasArgument("payload")) {
            // Old (MoPub) API.
            String source = (String) call.argument("source");
            String payload = (String) call.argument("payload");

            try {
                JSONObject jsonPayload = new JSONObject(payload);
                Adjust.trackAdRevenue(source, jsonPayload);
            } catch (JSONException err) {
                Log.e(TAG, "Given ad revenue payload is not a valid JSON string");
            }
        } 
        result.success(null);
    }

    private void trackAdRevenueNew(final MethodCall call, final Result result) {
        // New API.
        Map adRevenueMap = (Map) call.arguments;
        if (adRevenueMap == null) {
            return;
        }

        // Source.
        String source = null;
        if (adRevenueMap.containsKey("source")) {
            source = (String) adRevenueMap.get("source");
        }

        // Create ad revenue object.
        AdjustAdRevenue adRevenue = new AdjustAdRevenue(source);

        // Revenue.
        if (adRevenueMap.containsKey("revenue") || adRevenueMap.containsKey("currency")) {
            double revenue = -1.0;
            String strRevenue = (String) adRevenueMap.get("revenue");

            try {
                revenue = Double.parseDouble(strRevenue);
            } catch (NumberFormatException ignore) {}

            String currency = (String) adRevenueMap.get("currency");
            adRevenue.setRevenue(revenue, currency);
        }

        // Ad impressions count.
        if (adRevenueMap.containsKey("adImpressionsCount")) {
            String strAdImpressionsCount = (String) adRevenueMap.get("adImpressionsCount");
            int adImpressionsCount = Integer.parseInt(strAdImpressionsCount);
            adRevenue.setAdImpressionsCount(adImpressionsCount);
        }

        // Ad revenue network.
        if (adRevenueMap.containsKey("adRevenueNetwork")) {
            String adRevenueNetwork = (String) adRevenueMap.get("adRevenueNetwork");
            adRevenue.setAdRevenueNetwork(adRevenueNetwork);
        }

        // Ad revenue unit.
        if (adRevenueMap.containsKey("adRevenueUnit")) {
            String adRevenueUnit = (String) adRevenueMap.get("adRevenueUnit");
            adRevenue.setAdRevenueUnit(adRevenueUnit);
        }

        // Ad revenue placement.
        if (adRevenueMap.containsKey("adRevenuePlacement")) {
            String adRevenuePlacement = (String) adRevenueMap.get("adRevenuePlacement");
            adRevenue.setAdRevenuePlacement(adRevenuePlacement);
        }

        // Callback parameters.
        if (adRevenueMap.containsKey("callbackParameters")) {
            String strCallbackParametersJson = (String) adRevenueMap.get("callbackParameters");
            try {
                JSONObject jsonCallbackParameters = new JSONObject(strCallbackParametersJson);
                JSONArray callbackParametersKeys = jsonCallbackParameters.names();
                for (int i = 0; i < callbackParametersKeys.length(); ++i) {
                    String key = callbackParametersKeys.getString(i);
                    String value = jsonCallbackParameters.getString(key);
                    adRevenue.addCallbackParameter(key, value);
                }
            } catch (JSONException e) {
                Log.e(TAG, "Failed to parse ad revenue callback parameter! Details: " + e);
            }
        }

        // Partner parameters.
        if (adRevenueMap.containsKey("partnerParameters")) {
            String strPartnerParametersJson = (String) adRevenueMap.get("partnerParameters");
            try {
                JSONObject jsonPartnerParameters = new JSONObject(strPartnerParametersJson);
                JSONArray partnerParametersKeys = jsonPartnerParameters.names();
                for (int i = 0; i < partnerParametersKeys.length(); ++i) {
                    String key = partnerParametersKeys.getString(i);
                    String value = jsonPartnerParameters.getString(key);
                    adRevenue.addPartnerParameter(key, value);
                }
            } catch (JSONException e) {
                Log.e(TAG, "Failed to parse ad revenue partner parameter! Details: " + e);
            }
        }

        // Track ad revenue.
        Adjust.trackAdRevenue(adRevenue);
        result.success(null);
    }

    private void trackAppStoreSubscription(final Result result) {
        result.notImplemented();
        // result.error("0", "Error. No App Store subscription tracking for Android platform!", null);
    }

    private void trackPlayStoreSubscription(final MethodCall call, final Result result) {
        Map subscriptionMap = (Map) call.arguments;
        if (subscriptionMap == null) {
            return;
        }

        // Price.
        long price = -1;
        if (subscriptionMap.containsKey("price")) {
            try {
                price = Long.parseLong(subscriptionMap.get("price").toString());
            } catch (NumberFormatException ignore) {}
        }

        // Currency.
        String currency = null;
        if (subscriptionMap.containsKey("currency")) {
            currency = (String) subscriptionMap.get("currency");
        }

        // SKU.
        String sku = null;
        if (subscriptionMap.containsKey("sku")) {
            sku = (String) subscriptionMap.get("sku");
        }

        // Order ID.
        String orderId = null;
        if (subscriptionMap.containsKey("orderId")) {
            orderId = (String) subscriptionMap.get("orderId");
        }

        // Signature.
        String signature = null;
        if (subscriptionMap.containsKey("signature")) {
            signature = (String) subscriptionMap.get("signature");
        }

        // Purchase token.
        String purchaseToken = null;
        if (subscriptionMap.containsKey("purchaseToken")) {
            purchaseToken = (String) subscriptionMap.get("purchaseToken");
        }

        // Create subscription object.
        AdjustPlayStoreSubscription subscription = new AdjustPlayStoreSubscription(
                price,
                currency,
                sku,
                orderId,
                signature,
                purchaseToken);

        // Purchase time.
        if (subscriptionMap.containsKey("purchaseTime")) {
            try {
                long purchaseTime = Long.parseLong(subscriptionMap.get("purchaseTime").toString());
                subscription.setPurchaseTime(purchaseTime);
            } catch (NumberFormatException ignore) {}
        }

        // Callback parameters.
        if (subscriptionMap.containsKey("callbackParameters")) {
            String strCallbackParametersJson = (String) subscriptionMap.get("callbackParameters");
            try {
                JSONObject jsonCallbackParameters = new JSONObject(strCallbackParametersJson);
                JSONArray callbackParametersKeys = jsonCallbackParameters.names();
                for (int i = 0; i < callbackParametersKeys.length(); ++i) {
                    String key = callbackParametersKeys.getString(i);
                    String value = jsonCallbackParameters.getString(key);
                    subscription.addCallbackParameter(key, value);
                }
            } catch (JSONException e) {
                Log.e(TAG, "Failed to parse subscription callback parameter! Details: " + e);
            }
        }

        // Partner parameters.
        if (subscriptionMap.containsKey("partnerParameters")) {
            String strPartnerParametersJson = (String) subscriptionMap.get("partnerParameters");
            try {
                JSONObject jsonPartnerParameters = new JSONObject(strPartnerParametersJson);
                JSONArray partnerParametersKeys = jsonPartnerParameters.names();
                for (int i = 0; i < partnerParametersKeys.length(); ++i) {
                    String key = partnerParametersKeys.getString(i);
                    String value = jsonPartnerParameters.getString(key);
                    subscription.addPartnerParameter(key, value);
                }
            } catch (JSONException e) {
                Log.e(TAG, "Failed to parse subscription partner parameter! Details: " + e);
            }
        }

        // Track subscription.
        Adjust.trackPlayStoreSubscription(subscription);
        result.success(null);
    }

    private void requestTrackingAuthorizationWithCompletionHandler(final Result result) {
        result.notImplemented();
        // result.error("0", "Error. No requestTrackingAuthorizationWithCompletionHandler for Android platform!", null);
    }

    private void updateConversionValue(final Result result) {
        result.notImplemented();
        // result.error("0", "Error. No updateConversionValue for Android platform!", null);
    }

    private void trackThirdPartySharing(final MethodCall call, final Result result) {
        Map thirdPartySharingMap = (Map) call.arguments;
        if (thirdPartySharingMap == null) {
            return;
        }

        Boolean isEnabled = null;
        if (thirdPartySharingMap.containsKey("isEnabled")) {
            isEnabled = (Boolean) thirdPartySharingMap.get("isEnabled");
        }

        // Create third party sharing object.
        AdjustThirdPartySharing thirdPartySharing = new AdjustThirdPartySharing(isEnabled);

        // Granular options.
        if (thirdPartySharingMap.containsKey("granularOptions")) {
            String strGranularOptions = (String) thirdPartySharingMap.get("granularOptions");
            String[] arrayGranularOptions = strGranularOptions.split("__ADJ__", -1);
            for (int i = 0; i < arrayGranularOptions.length; i += 3) {
                thirdPartySharing.addGranularOption(
                    arrayGranularOptions[i],
                    arrayGranularOptions[i+1],
                    arrayGranularOptions[i+2]);
            }
        }

        // Track third party sharing.
        Adjust.trackThirdPartySharing(thirdPartySharing);
        result.success(null);
    }

    // read oaid
    private void readOaid(final MethodCall call, final Result result){
        AdjustOaid.readOaid(applicationContext);
        result.success(null);
    }

    // do not read oaid
    private void doNotReadOaid(final MethodCall call, final Result result){
        AdjustOaid.doNotReadOaid();
        result.success(null);
    }

    private void trackMeasurementConsent(final MethodCall call, final Result result) {
        Map measurementConsentMap = (Map) call.arguments;
        if (!measurementConsentMap.containsKey("measurementConsent")) {
            result.error("0", "Arguments null or wrong (missing argument of 'trackMeasurementConsent' method.", null);
            return;
        }

        boolean measurementConsent = (boolean) measurementConsentMap.get("measurementConsent");
        Adjust.trackMeasurementConsent(measurementConsent);
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
        if (testOptionsMap.containsKey("subscriptionUrl")) {
            testOptions.subscriptionUrl = (String) testOptionsMap.get("subscriptionUrl");
        }
        if (testOptionsMap.containsKey("basePath")) {
            testOptions.basePath = (String) testOptionsMap.get("basePath");
        }
        if (testOptionsMap.containsKey("gdprPath")) {
            testOptions.gdprPath = (String) testOptionsMap.get("gdprPath");
        }
        if (testOptionsMap.containsKey("subscriptionPath")) {
            testOptions.subscriptionPath = (String) testOptionsMap.get("subscriptionPath");
        }
        // Kept for the record. Not needed anymore with test options extraction.
        // if (testOptionsMap.containsKey("useTestConnectionOptions")) {
        //     testOptions.useTestConnectionOptions = testOptionsMap.get("useTestConnectionOptions").toString().equals("true");
        // }
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
