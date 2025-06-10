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
import com.adjust.sdk.AdjustPurchaseVerificationResult;
import com.adjust.sdk.AdjustStoreInfo;
import com.adjust.sdk.AdjustThirdPartySharing;
import com.adjust.sdk.AdjustTestOptions;
import com.adjust.sdk.LogLevel;
import com.adjust.sdk.OnAttributionChangedListener;
import com.adjust.sdk.OnDeferredDeeplinkResponseListener;
import com.adjust.sdk.OnGoogleAdIdReadListener;
import com.adjust.sdk.OnEventTrackingFailedListener;
import com.adjust.sdk.OnEventTrackingSucceededListener;
import com.adjust.sdk.OnSessionTrackingFailedListener;
import com.adjust.sdk.OnSessionTrackingSucceededListener;
import com.adjust.sdk.OnPurchaseVerificationFinishedListener;
import com.adjust.sdk.OnLastDeeplinkReadListener;
import com.adjust.sdk.OnDeeplinkResolvedListener;
import com.adjust.sdk.OnIsEnabledListener;
import com.adjust.sdk.OnAdidReadListener;
import com.adjust.sdk.OnAmazonAdIdReadListener;
import com.adjust.sdk.OnAttributionReadListener;
import com.adjust.sdk.OnSdkVersionReadListener;
import com.adjust.sdk.AdjustPlayStorePurchase;
import com.adjust.sdk.AdjustDeeplink;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

public class AdjustSdk implements FlutterPlugin, MethodCallHandler {
    private static String TAG = "AdjustBridge";
    private static boolean isDeferredDeeplinkOpeningEnabled = true;
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

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case "initSdk":
                initSdk(call, result);
                break;
            case "trackEvent":
                trackEvent(call, result);
                break;
            case "isEnabled":
                isEnabled(result);
                break;
            case "enable":
                enable(result);
                break;
            case "disable":
                disable(result);
                break;
            case "switchToOfflineMode":
                switchToOfflineMode(result);
                break;
            case "switchBackToOnlineMode":
                switchBackToOnlineMode(result);
                break;
            case "setPushToken":
                setPushToken(call, result);
                break;
            case "processDeeplink":
                processDeeplink(call, result);
                break;
            case "processAndResolveDeeplink":
                processAndResolveDeeplink(call, result);
                break;
            case "getAdid":
                getAdid(result);
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
            case "gdprForgetMe":
                gdprForgetMe(result);
                break;
            case "addGlobalCallbackParameter":
                addGlobalCallbackParameter(call, result);
                break;
            case "addGlobalPartnerParameter":
                addGlobalPartnerParameter(call, result);
                break;
            case "removeGlobalCallbackParameter":
                removeGlobalCallbackParameter(call, result);
                break;
            case "removeGlobalPartnerParameter":
                removeGlobalPartnerParameter(call, result);
                break;
            case "removeGlobalCallbackParameters":
                removeGlobalCallbackParameters(result);
                break;
            case "removeGlobalPartnerParameters":
                removeGlobalPartnerParameters(result);
                break;
            case "trackAdRevenue":
                trackAdRevenue(call, result);
                break;
            case "trackPlayStoreSubscription":
                trackPlayStoreSubscription(call, result);
                break;
            case "trackThirdPartySharing":
                trackThirdPartySharing(call, result);
                break;
            case "trackMeasurementConsent":
                trackMeasurementConsent(call, result);
                break;
            case "getLastDeeplink":
                getLastDeeplink(result);
                break;
            case "verifyPlayStorePurchase":
                verifyPlayStorePurchase(call, result);
                break;
            case "endFirstSessionDelay":
                endFirstSessionDelay(call, result);
                break;
            case "enableCoppaComplianceInDelay":
                enableCoppaComplianceInDelay(call, result);
                break;
            case "disableCoppaComplianceInDelay":
                disableCoppaComplianceInDelay(call, result);
                break;
            case "enablePlayStoreKidsComplianceInDelay":
                enablePlayStoreKidsComplianceInDelay(call, result);
                break;
            case "disablePlayStoreKidsComplianceInDelay":
                disablePlayStoreKidsComplianceInDelay(call, result);
                break;
            case "setExternalDeviceIdInDelay":
                setExternalDeviceIdInDelay(call, result);
                break;
            // ios only methods
            case "getIdfa":
                getIdfa(result);
                break;
            case "getIdfv":
                getIdfv(result);
                break;
            case "trackAppStoreSubscription":
                trackAppStoreSubscription(result);
                break;
            case "requestAppTrackingAuthorization":
                requestAppTrackingAuthorization(result);
                break;
            case "updateSkanConversionValue":
                updateSkanConversionValue(result);
                break;
            case "getAppTrackingAuthorizationStatus":
                getAppTrackingAuthorizationStatus(call, result);
                break;
            case "verifyAppStorePurchase":
                verifyAppStorePurchase(call, result);
                break;
            case "verifyAndTrackPlayStorePurchase":
                verifyAndTrackPlayStorePurchase(call, result);
                break;
            case "verifyAndTrackAppStorePurchase":
                verifyAndTrackAppStorePurchase(call, result);
                break;
            // used for testing only
            case "onPause":
                onPause(result);
                break;
            case "onResume":
                onResume(result);
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

    private void initSdk(final MethodCall call, final Result result) {
        Map configMap = (Map) call.arguments;
        if (configMap == null) {
            return;
        }

        String appToken = null;
        String environment = null;
        String logLevel = null;
        boolean isLogLevelSuppress = false;

        // app token
        if (configMap.containsKey("appToken")) {
            appToken = (String) configMap.get("appToken");
        }

        // environment
        if (configMap.containsKey("environment")) {
            environment = (String) configMap.get("environment");
        }

        // suppress log level
        if (configMap.containsKey("logLevel")) {
            logLevel = (String) configMap.get("logLevel");
            if (logLevel != null && logLevel.equals("suppress")) {
                isLogLevelSuppress = true;
            }
        }

        // create configuration object
        AdjustConfig adjustConfig = new AdjustConfig(applicationContext, appToken, environment, isLogLevelSuppress);

        // SDK prefix
        if (configMap.containsKey("sdkPrefix")) {
            String sdkPrefix = (String) configMap.get("sdkPrefix");
            adjustConfig.setSdkPrefix(sdkPrefix);
        }

        // log level
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
                        adjustConfig.setLogLevel(LogLevel.SUPPRESS);
                        break;
                    case "info":
                    default:
                        adjustConfig.setLogLevel(LogLevel.INFO);
                        break;
                }
            }
        }

        // first session delay
        if (configMap.containsKey("isFirstSessionDelayEnabled")) {
            String strIsFirstSessionDelayEnabled = (String) configMap.get("isFirstSessionDelayEnabled");
            boolean isFirstSessionDelayEnabled = Boolean.parseBoolean(strIsFirstSessionDelayEnabled);
            if (isFirstSessionDelayEnabled) {
                adjustConfig.enableFirstSessionDelay();
            }
        }

        // COPPA compliance
        if (configMap.containsKey("isCoppaComplianceEnabled")) {
            String strIsCoppaComplianceEnabled = (String) configMap.get("isCoppaComplianceEnabled");
            boolean isCoppaComplianceEnabled = Boolean.parseBoolean(strIsCoppaComplianceEnabled);
            if (isCoppaComplianceEnabled) {
                adjustConfig.enableCoppaCompliance();
            }
        }

        // Google Play Store kids compliance
        if (configMap.containsKey("isPlayStoreKidsComplianceEnabled")) {
            String strIsPlayStoreKidsComplianceEnabled = (String) configMap.get("isPlayStoreKidsComplianceEnabled");
            boolean isPlayStoreKidsComplianceEnabled = Boolean.parseBoolean(strIsPlayStoreKidsComplianceEnabled);
            if (isPlayStoreKidsComplianceEnabled) {
                adjustConfig.enablePlayStoreKidsCompliance();
            }
        }

        // read device info only once
        if (configMap.containsKey("isDeviceIdsReadingOnceEnabled")) {
            String strIsDeviceIdsReadingOnceEnabled = (String) configMap.get("isDeviceIdsReadingOnceEnabled");
            boolean isDeviceIdsReadingOnceEnabled = Boolean.parseBoolean(strIsDeviceIdsReadingOnceEnabled);
            if (isDeviceIdsReadingOnceEnabled) {
                adjustConfig.enableDeviceIdsReadingOnce();
            }
        }

        // event deduplication buffer size
        if (configMap.containsKey("eventDeduplicationIdsMaxSize")) {
            String strEventDeduplicationIdsMaxSize = (String) configMap.get("eventDeduplicationIdsMaxSize");
            try {
                int eventDeduplicationIdsMaxSize = Integer.valueOf(strEventDeduplicationIdsMaxSize);
                adjustConfig.setEventDeduplicationIdsMaxSize(eventDeduplicationIdsMaxSize);
            } catch (Exception e) {}
        }

        // set store info
        if (configMap.containsKey("storeInfo")) {
            try {
                String strStoreInfo = (String) configMap.get("storeInfo");
                JSONObject storeInfo = new JSONObject(strStoreInfo);

                if (storeInfo.has("storeName") && !storeInfo.isNull("storeName")) {
                    String storeName = storeInfo.getString("storeName");
                    AdjustStoreInfo adjustStoreInfo = new AdjustStoreInfo(storeName);
                    if (storeInfo.has("storeAppId") && !storeInfo.isNull("storeAppId")) {
                        String storeAppId = storeInfo.getString("storeAppId");
                        adjustStoreInfo.setStoreAppId(storeAppId);
                    }
                    adjustConfig.setStoreInfo(adjustStoreInfo);
                }
            } catch (JSONException ignored) {}
        }

        // URL strategy
        if (configMap.containsKey("urlStrategyDomains")
            && configMap.containsKey("useSubdomains") 
            && configMap.containsKey("isDataResidency")) {
            String strUrlStrategyDomains = (String) configMap.get("urlStrategyDomains");
            try {
                JSONArray jsonArray = new JSONArray(strUrlStrategyDomains);
                ArrayList<String> urlStrategyDomainsArray = new ArrayList<>();
                for (int i = 0; i < jsonArray.length(); i += 1) {
                    urlStrategyDomainsArray.add((String)jsonArray.get(i));
                }
                String strShouldUseSubdomains = (String) configMap.get("useSubdomains");
                boolean useSubdomains = Boolean.parseBoolean(strShouldUseSubdomains);

                String strIsDataResidency = (String) configMap.get("isDataResidency");
                boolean isDataResidency = Boolean.parseBoolean(strIsDataResidency);

                adjustConfig.setUrlStrategy(urlStrategyDomainsArray, useSubdomains, isDataResidency);
            } catch (JSONException ignored) {}
        }

        // main process name
        if (configMap.containsKey("processName")) {
            String processName = (String) configMap.get("processName");
            adjustConfig.setProcessName(processName);
        }

        // default tracker
        if (configMap.containsKey("defaultTracker")) {
            String defaultTracker = (String) configMap.get("defaultTracker");
            adjustConfig.setDefaultTracker(defaultTracker);
        }

        // external device ID
        if (configMap.containsKey("externalDeviceId")) {
            String externalDeviceId = (String) configMap.get("externalDeviceId");
            adjustConfig.setExternalDeviceId(externalDeviceId);
        }

        // custom preinstall file path
        if (configMap.containsKey("preinstallFilePath")) {
            String preinstallFilePath = (String) configMap.get("preinstallFilePath");
            adjustConfig.setPreinstallFilePath(preinstallFilePath);
        }

        // META install referrer
        if (configMap.containsKey("fbAppId")) {
            String fbAppId = (String) configMap.get("fbAppId");
            adjustConfig.setFbAppId(fbAppId);
        }

        // sending in background
        if (configMap.containsKey("isSendingInBackgroundEnabled")) {
            String strIsSendingInBackgroundEnabled = (String) configMap.get("isSendingInBackgroundEnabled");
            boolean isSendingInBackgroundEnabled = Boolean.parseBoolean(strIsSendingInBackgroundEnabled);
            if (isSendingInBackgroundEnabled) {
                adjustConfig.enableSendingInBackground();
            }
        }

        // cost data in attribution callback
        if (configMap.containsKey("isCostDataInAttributionEnabled")) {
            String strIsCostDataInAttributionEnabled = (String) configMap.get("isCostDataInAttributionEnabled");
            boolean isCostDataInAttributionEnabled = Boolean.parseBoolean(strIsCostDataInAttributionEnabled);
            if (isCostDataInAttributionEnabled) {
                adjustConfig.enableCostDataInAttribution();
            }
        }

        // preinstall tracking
        if (configMap.containsKey("isPreinstallTrackingEnabled")) {
            String strIsPreinstallTrackingEnabled = (String) configMap.get("isPreinstallTrackingEnabled");
            boolean isPreinstallTrackingEnabled = Boolean.parseBoolean(strIsPreinstallTrackingEnabled);
            if (isPreinstallTrackingEnabled) {
                adjustConfig.enablePreinstallTracking();
            }
        }

        // launch deferred deep link
        if (configMap.containsKey("isDeferredDeeplinkOpeningEnabled")) {
            String strIsDeferredDeeplinkOpeningEnabled = (String) configMap.get("isDeferredDeeplinkOpeningEnabled");
            isDeferredDeeplinkOpeningEnabled = strIsDeferredDeeplinkOpeningEnabled.equals("true");
        }

        // attribution callback
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
                        adjustAttributionMap.put("costType", adjustAttribution.costType);
                        adjustAttributionMap.put("costAmount", adjustAttribution.costAmount != null ?
                                adjustAttribution.costAmount.toString() : "");
                        adjustAttributionMap.put("costCurrency", adjustAttribution.costCurrency);
                        adjustAttributionMap.put("fbInstallReferrer", adjustAttribution.fbInstallReferrer);
                        if (adjustAttribution.jsonResponse != null) {
                            adjustAttributionMap.put("jsonResponse", adjustAttribution.jsonResponse);
                        }
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, adjustAttributionMap);
                        }
                    }
                });
            }
        }

        // session success callback
        if (configMap.containsKey("sessionSuccessCallback")) {
            final String dartMethodName = (String) configMap.get("sessionSuccessCallback");
            if (dartMethodName != null) {
                adjustConfig.setOnSessionTrackingSucceededListener(new OnSessionTrackingSucceededListener() {
                    @Override
                    public void onSessionTrackingSucceeded(AdjustSessionSuccess adjustSessionSuccess) {
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

        // session failure callback
        if (configMap.containsKey("sessionFailureCallback")) {
            final String dartMethodName = (String) configMap.get("sessionFailureCallback");
            if (dartMethodName != null) {
                adjustConfig.setOnSessionTrackingFailedListener(new OnSessionTrackingFailedListener() {
                    @Override
                    public void onSessionTrackingFailed(AdjustSessionFailure adjustSessionFailure) {
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

        // event success callback
        if (configMap.containsKey("eventSuccessCallback")) {
            final String dartMethodName = (String) configMap.get("eventSuccessCallback");
            if (dartMethodName != null) {
                adjustConfig.setOnEventTrackingSucceededListener(new OnEventTrackingSucceededListener() {
                    @Override
                    public void onEventTrackingSucceeded(AdjustEventSuccess adjustEventSuccess) {
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

        // event failure callback
        if (configMap.containsKey("eventFailureCallback")) {
            final String dartMethodName = (String) configMap.get("eventFailureCallback");
            if (dartMethodName != null) {
                adjustConfig.setOnEventTrackingFailedListener(new OnEventTrackingFailedListener() {
                    @Override
                    public void onEventTrackingFailed(AdjustEventFailure adjustEventFailure) {
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

        // deferred deep link callback
        if (configMap.containsKey("deferredDeeplinkCallback")) {
            final String dartMethodName = (String) configMap.get("deferredDeeplinkCallback");
            if (dartMethodName != null) {
                adjustConfig.setOnDeferredDeeplinkResponseListener(new OnDeferredDeeplinkResponseListener() {
                    @Override
                    public boolean launchReceivedDeeplink(Uri deeplink) {
                        HashMap<String, String> uriParamsMap = new HashMap<String, String>();
                        uriParamsMap.put("deeplink", deeplink.toString());
                        if (channel != null) {
                            channel.invokeMethod(dartMethodName, uriParamsMap);
                        }
                        return isDeferredDeeplinkOpeningEnabled;
                    }
                });
            }
        }

        // initialize SDK
        Adjust.initSdk(adjustConfig);
        result.success(null);
    }

    private void trackEvent(final MethodCall call, final Result result) {
        Map eventMap = (Map) call.arguments;
        if (eventMap == null) {
            return;
        }

        // event token
        String eventToken = null;
        if (eventMap.containsKey("eventToken")) {
            eventToken = (String) eventMap.get("eventToken");
        }

        // create event object
        AdjustEvent event = new AdjustEvent(eventToken);

        // revenue and currency
        if (eventMap.containsKey("revenue") || eventMap.containsKey("currency")) {
            double revenue = -1.0;
            String strRevenue = (String) eventMap.get("revenue");

            try {
                revenue = Double.parseDouble(strRevenue);
            } catch (NumberFormatException ignore) {}

            String currency = (String) eventMap.get("currency");
            event.setRevenue(revenue, currency);
        }

        // event deduplication
        if (eventMap.containsKey("deduplicationId")) {
            String deduplicationId = (String) eventMap.get("deduplicationId");
            event.setDeduplicationId(deduplicationId);
        }

        // product ID
        if (eventMap.containsKey("productId")) {
            String productId = (String) eventMap.get("productId");
            event.setProductId(productId);
        }

        // purchase token
        if (eventMap.containsKey("purchaseToken")) {
            String purchaseToken = (String) eventMap.get("purchaseToken");
            event.setPurchaseToken(purchaseToken);
        }

        // callback ID
        if (eventMap.containsKey("callbackId")) {
            String callbackId = (String) eventMap.get("callbackId");
            event.setCallbackId(callbackId);
        }

        // callback parameters
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

        // partner parameters
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

        // track event
        Adjust.trackEvent(event);
        result.success(null);
    }

    private void switchToOfflineMode(final Result result) {
        Adjust.switchToOfflineMode();
        result.success(null);
    }

    private void switchBackToOnlineMode(final Result result) {
        Adjust.switchBackToOnlineMode();
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

    private void enable(final Result result) {
        Adjust.enable();
        result.success(null);
    }
    private void disable( final Result result) {
        Adjust.disable();
        result.success(null);
    }

    private void processDeeplink(final MethodCall call, final Result result) {
        Map deeplinkMap = (Map) call.arguments;
        if (deeplinkMap == null) {
            return;
        }

        AdjustDeeplink adjustDeeplink = null;
        if (deeplinkMap.containsKey("deeplink")) {
            String deeplink = (String) deeplinkMap.get("deeplink");
            adjustDeeplink = new AdjustDeeplink(Uri.parse(deeplink));
            if (deeplinkMap.containsKey("referrer")) {
                String referrer = (String) deeplinkMap.get("referrer");
                adjustDeeplink.setReferrer(Uri.parse(referrer));
            }
        }

        Adjust.processDeeplink(adjustDeeplink, applicationContext);
        result.success(null);
    }

    private void isEnabled(final Result result) {
        Adjust.isEnabled(applicationContext, new OnIsEnabledListener() {
            @Override
            public void onIsEnabledRead(boolean isEnabled) {
                result.success(isEnabled);
            }
        });
    }

    private void getAdid(final Result result) {
        Adjust.getAdid(new OnAdidReadListener() {
            @Override
            public void onAdidRead(String adid) {
                result.success(adid);
            }
        });
    }

    private void getGoogleAdId(final Result result) {
        Adjust.getGoogleAdId(applicationContext, new OnGoogleAdIdReadListener() {
            @Override
            public void onGoogleAdIdRead(String googleAdId) {
                result.success(googleAdId);
            }
        });
    }

    private void getAmazonAdId(final Result result) {
        Adjust.getAmazonAdId(applicationContext, new OnAmazonAdIdReadListener() {
            @Override
            public void onAmazonAdIdRead(String amazonAdId) {
                result.success(amazonAdId);
            }
        });
    }

    private void gdprForgetMe(final Result result) {
        Adjust.gdprForgetMe(applicationContext);
        result.success(null);
    }

    private void getAttribution(final Result result) {
        Adjust.getAttribution(new OnAttributionReadListener() {
            @Override
            public void onAttributionRead(AdjustAttribution attribution) {
                HashMap<String, String> adjustAttributionMap = new HashMap<String, String>();
                adjustAttributionMap.put("trackerToken", attribution.trackerToken);
                adjustAttributionMap.put("trackerName", attribution.trackerName);
                adjustAttributionMap.put("network", attribution.network);
                adjustAttributionMap.put("campaign", attribution.campaign);
                adjustAttributionMap.put("adgroup", attribution.adgroup);
                adjustAttributionMap.put("creative", attribution.creative);
                adjustAttributionMap.put("clickLabel", attribution.clickLabel);
                adjustAttributionMap.put("costType", attribution.costType);
                adjustAttributionMap.put("costAmount", attribution.costAmount != null ?
                        attribution.costAmount.toString() : "");
                adjustAttributionMap.put("costCurrency", attribution.costCurrency);
                adjustAttributionMap.put("fbInstallReferrer", attribution.fbInstallReferrer);
                if (attribution.jsonResponse != null) {
                    adjustAttributionMap.put("jsonResponse", attribution.jsonResponse);
                }
                result.success(adjustAttributionMap);
            }
        });
    }

    private void getSdkVersion(final Result result) {
        Adjust.getSdkVersion(new OnSdkVersionReadListener (){
            @Override
            public void onSdkVersionRead(String sdkVersion) {
                result.success(sdkVersion);
            }
        });
    }

    private void setReferrer(final MethodCall call, final Result result) {
        String referrer = null;
        if (call.hasArgument("referrer")) {
            referrer = (String) call.argument("referrer");
        }
        Adjust.setReferrer(referrer, applicationContext);
        result.success(null);
    }

    private void addGlobalCallbackParameter(final MethodCall call, final Result result) {
        String key = null;
        String value = null;
        if (call.hasArgument("key") && call.hasArgument("value")) {
            key = (String) call.argument("key");
            value = (String) call.argument("value");
        }
        Adjust.addGlobalCallbackParameter(key, value);
        result.success(null);
    }

    private void addGlobalPartnerParameter(final MethodCall call, final Result result) {
        String key = null;
        String value = null;
        if (call.hasArgument("key") && call.hasArgument("value")) {
            key = (String) call.argument("key");
            value = (String) call.argument("value");
        }
        Adjust.addGlobalPartnerParameter(key, value);
        result.success(null);
    }

    private void removeGlobalCallbackParameter(final MethodCall call, final Result result) {
        String key = null;
        if (call.hasArgument("key")) {
            key = (String) call.argument("key");
        }
        Adjust.removeGlobalCallbackParameter(key);
        result.success(null);
    }

    private void removeGlobalPartnerParameter(final MethodCall call, final Result result) {
        String key = null;
        if (call.hasArgument("key")) {
            key = (String) call.argument("key");
        }
        Adjust.removeGlobalPartnerParameter(key);
        result.success(null);
    }

    private void removeGlobalCallbackParameters(final Result result) {
        Adjust.removeGlobalCallbackParameters();
        result.success(null);
    }

    private void removeGlobalPartnerParameters(final Result result) {
        Adjust.removeGlobalPartnerParameters();
        result.success(null);
    }

    private void trackAdRevenue(final MethodCall call, final Result result) {
        Map adRevenueMap = (Map) call.arguments;
        if (adRevenueMap == null) {
            return;
        }

        // ad revenue source
        String source = null;
        if (adRevenueMap.containsKey("source")) {
            source = (String) adRevenueMap.get("source");
        }

        // create ad revenue object
        AdjustAdRevenue adRevenue = new AdjustAdRevenue(source);

        // revenue and currency
        if (adRevenueMap.containsKey("revenue") || adRevenueMap.containsKey("currency")) {
            double revenue = -1.0;
            String strRevenue = (String) adRevenueMap.get("revenue");

            try {
                revenue = Double.parseDouble(strRevenue);
                String currency = (String) adRevenueMap.get("currency");
                adRevenue.setRevenue(revenue, currency);
            } catch (NumberFormatException ignore) {}
        }

        // ad impressions count
        if (adRevenueMap.containsKey("adImpressionsCount")) {
            String strAdImpressionsCount = (String) adRevenueMap.get("adImpressionsCount");
            int adImpressionsCount = Integer.parseInt(strAdImpressionsCount);
            adRevenue.setAdImpressionsCount(adImpressionsCount);
        }

        // ad revenue network
        if (adRevenueMap.containsKey("adRevenueNetwork")) {
            String adRevenueNetwork = (String) adRevenueMap.get("adRevenueNetwork");
            adRevenue.setAdRevenueNetwork(adRevenueNetwork);
        }

        // ad revenue unit
        if (adRevenueMap.containsKey("adRevenueUnit")) {
            String adRevenueUnit = (String) adRevenueMap.get("adRevenueUnit");
            adRevenue.setAdRevenueUnit(adRevenueUnit);
        }

        // ad revenue placement
        if (adRevenueMap.containsKey("adRevenuePlacement")) {
            String adRevenuePlacement = (String) adRevenueMap.get("adRevenuePlacement");
            adRevenue.setAdRevenuePlacement(adRevenuePlacement);
        }

        // callback parameters
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

        // partner parameters
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

        // track ad revenue
        Adjust.trackAdRevenue(adRevenue);
        result.success(null);
    }

    private void trackPlayStoreSubscription(final MethodCall call, final Result result) {
        Map subscriptionMap = (Map) call.arguments;
        if (subscriptionMap == null) {
            return;
        }

        // price
        long price = -1;
        if (subscriptionMap.containsKey("price")) {
            try {
                price = Long.parseLong(subscriptionMap.get("price").toString());
            } catch (NumberFormatException ignore) {}
        }

        // currency
        String currency = null;
        if (subscriptionMap.containsKey("currency")) {
            currency = (String) subscriptionMap.get("currency");
        }

        // SKU
        String sku = null;
        if (subscriptionMap.containsKey("sku")) {
            sku = (String) subscriptionMap.get("sku");
        }

        // order ID
        String orderId = null;
        if (subscriptionMap.containsKey("orderId")) {
            orderId = (String) subscriptionMap.get("orderId");
        }

        // Signature.
        String signature = null;
        if (subscriptionMap.containsKey("signature")) {
            signature = (String) subscriptionMap.get("signature");
        }

        // purchase token
        String purchaseToken = null;
        if (subscriptionMap.containsKey("purchaseToken")) {
            purchaseToken = (String) subscriptionMap.get("purchaseToken");
        }

        // create subscription object
        AdjustPlayStoreSubscription subscription = new AdjustPlayStoreSubscription(
                price,
                currency,
                sku,
                orderId,
                signature,
                purchaseToken);

        // purchase time
        if (subscriptionMap.containsKey("purchaseTime")) {
            try {
                long purchaseTime = Long.parseLong(subscriptionMap.get("purchaseTime").toString());
                subscription.setPurchaseTime(purchaseTime);
            } catch (NumberFormatException ignore) {}
        }

        // callback parameters
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

        // partner parameters
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

        // track subscription
        Adjust.trackPlayStoreSubscription(subscription);
        result.success(null);
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

        // create third party sharing object
        AdjustThirdPartySharing thirdPartySharing = new AdjustThirdPartySharing(isEnabled);

        // granular options
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

        // partner sharing settings
        if (thirdPartySharingMap.containsKey("partnerSharingSettings")) {
            String strPartnerSharingSettings = (String) thirdPartySharingMap.get("partnerSharingSettings");
            String[] arrayPartnerSharingSettings = strPartnerSharingSettings.split("__ADJ__", -1);
            for (int i = 0; i < arrayPartnerSharingSettings.length; i += 3) {
                thirdPartySharing.addPartnerSharingSetting(
                    arrayPartnerSharingSettings[i],
                    arrayPartnerSharingSettings[i+1],
                    Boolean.parseBoolean(arrayPartnerSharingSettings[i+2]));
            }
        }

        // track third party sharing
        Adjust.trackThirdPartySharing(thirdPartySharing);
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

    private void getLastDeeplink(final Result result) {
        Adjust.getLastDeeplink(applicationContext, new OnLastDeeplinkReadListener() {
            @Override
            public void onLastDeeplinkRead(Uri deeplink) {
                if (deeplink != null) {
                    result.success(deeplink.toString());
                } else {
                    result.success("");
                }
            }
        });
    }

    private void verifyPlayStorePurchase(final MethodCall call, final Result result) {
        Map purchaseMap = (Map) call.arguments;
        if (purchaseMap == null) {
            return;
        }

        // product ID
        String productId = null;
        if (purchaseMap.containsKey("productId")) {
            productId = (String) purchaseMap.get("productId");
        }

        // purchase token
        String purchaseToken = null;
        if (purchaseMap.containsKey("purchaseToken")) {
            purchaseToken = (String) purchaseMap.get("purchaseToken");
        }

        // create purchase instance
        AdjustPlayStorePurchase purchase = new AdjustPlayStorePurchase(productId, purchaseToken);

        // verify purchase
        Adjust.verifyPlayStorePurchase(purchase, new OnPurchaseVerificationFinishedListener() {
            @Override
            public void onVerificationFinished(AdjustPurchaseVerificationResult verificationResult) {
                HashMap<String, String> adjustPurchaseMap = new HashMap<String, String>();
                adjustPurchaseMap.put("code", String.valueOf(verificationResult.getCode()));
                adjustPurchaseMap.put("verificationStatus", verificationResult.getVerificationStatus());
                adjustPurchaseMap.put("message", verificationResult.getMessage());
                result.success(adjustPurchaseMap);
            }
        });
    }

    private void verifyAndTrackPlayStorePurchase(final MethodCall call, final Result result) {
        Map eventMap = (Map) call.arguments;
        if (eventMap == null) {
            return;
        }

        // event token
        String eventToken = null;
        if (eventMap.containsKey("eventToken")) {
            eventToken = (String) eventMap.get("eventToken");
        }

        // create event object
        AdjustEvent event = new AdjustEvent(eventToken);

        // revenue
        if (eventMap.containsKey("revenue") || eventMap.containsKey("currency")) {
            double revenue = -1.0;
            String strRevenue = (String) eventMap.get("revenue");

            try {
                revenue = Double.parseDouble(strRevenue);
            } catch (NumberFormatException ignore) {}

            String currency = (String) eventMap.get("currency");
            event.setRevenue(revenue, currency);
        }

        // event deduplication
        if (eventMap.containsKey("deduplicationId")) {
            String deduplicationId = (String) eventMap.get("deduplicationId");
            event.setDeduplicationId(deduplicationId);
        }

        // product ID
        if (eventMap.containsKey("productId")) {
            String productId = (String) eventMap.get("productId");
            event.setProductId(productId);
        }

        // purchase token
        if (eventMap.containsKey("purchaseToken")) {
            String purchaseToken = (String) eventMap.get("purchaseToken");
            event.setPurchaseToken(purchaseToken);
        }

        // callback ID
        if (eventMap.containsKey("callbackId")) {
            String callbackId = (String) eventMap.get("callbackId");
            event.setCallbackId(callbackId);
        }

        // callback parameters
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

        // partner parameters
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

        // verify and track purchase
        Adjust.verifyAndTrackPlayStorePurchase(event, new OnPurchaseVerificationFinishedListener() {
            @Override
            public void onVerificationFinished(AdjustPurchaseVerificationResult verificationResult) {
                HashMap<String, String> adjustPurchaseMap = new HashMap<String, String>();
                adjustPurchaseMap.put("code", String.valueOf(verificationResult.getCode()));
                adjustPurchaseMap.put("verificationStatus", verificationResult.getVerificationStatus());
                adjustPurchaseMap.put("message", verificationResult.getMessage());
                result.success(adjustPurchaseMap);
            }
        });
    }

    private void processAndResolveDeeplink(final MethodCall call, final Result result) {
        Map deeplinkMap = (Map) call.arguments;
        if (deeplinkMap == null) {
            return;
        }

        AdjustDeeplink adjustDeeplink = null;
        if (deeplinkMap.containsKey("deeplink")) {
            String deeplink = (String) deeplinkMap.get("deeplink");
            adjustDeeplink = new AdjustDeeplink(Uri.parse(deeplink));
            if (deeplinkMap.containsKey("referrer")) {
                String referrer = (String) deeplinkMap.get("referrer");
                adjustDeeplink.setReferrer(Uri.parse(referrer));
            }
        }

        Adjust.processAndResolveDeeplink(adjustDeeplink, applicationContext, new OnDeeplinkResolvedListener() {
            @Override
            public void onDeeplinkResolved(String resolvedLink) {
                result.success(resolvedLink);
            }
        });
    }

    // ios only methods
    private void getIdfa(final Result result) {
        result.success("Error. No getIdfa on Android platform!");
    }

    private void getIdfv(final Result result) {
        result.success("Error. No getIdfv on Android platform!");
    }

    private void requestAppTrackingAuthorization(final Result result) {
        result.success(-1);
    }

    private void updateSkanConversionValue(final Result result) {
        result.success("Error. No updateSkanConversionValue on Android platform!");
    }

    private void getAppTrackingAuthorizationStatus(final MethodCall call, final Result result) {
        result.success(-1);
    }

    private void trackAppStoreSubscription(final Result result) {
        result.success("Error. No trackAppStoreSubscription on Android platform!");
    }

    private void verifyAppStorePurchase(final MethodCall call, final Result result) {
        result.success("Error. No verifyAppStorePurchase on Android platform!");
    }

    private void verifyAndTrackAppStorePurchase(final MethodCall call, final Result result) {
        result.success("Error. No verifyAndTrackAppStorePurchase on Android platform!");
    }

    private void endFirstSessionDelay(final MethodCall call, final Result result){
        Adjust.endFirstSessionDelay();
    }

    private void enableCoppaComplianceInDelay(final MethodCall call, final Result result){
        Adjust.enableCoppaComplianceInDelay();
    }

    private void disableCoppaComplianceInDelay(final MethodCall call, final Result result){
        Adjust.disableCoppaComplianceInDelay();
    }

    private void enablePlayStoreKidsComplianceInDelay(final MethodCall call, final Result result){
        Adjust.enablePlayStoreKidsComplianceInDelay();
    }

    private void disablePlayStoreKidsComplianceInDelay(final MethodCall call, final Result result){
        Adjust.disablePlayStoreKidsComplianceInDelay();
    }

    private void setExternalDeviceIdInDelay(final MethodCall call, final Result result){
        Map externalDeviceMap = (Map) call.arguments;
        String externalDeviceId = null;
        if (externalDeviceMap.containsKey("externalDeviceId")) {
            externalDeviceId = externalDeviceMap.get("externalDeviceId").toString();
        }
        Adjust.setExternalDeviceIdInDelay(externalDeviceId);
        result.success(null);
    }

    // used for testing only
    private void onResume(final Result result) {
        Adjust.onResume();
        result.success(null);
    }

    private void onPause(final Result result) {
        Adjust.onPause();
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
        if (testOptionsMap.containsKey("purchaseVerificationUrl")) {
            testOptions.purchaseVerificationUrl = (String) testOptionsMap.get("purchaseVerificationUrl");
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
        if (testOptionsMap.containsKey("purchaseVerificationPath")) {
            testOptions.purchaseVerificationPath = (String) testOptionsMap.get("purchaseVerificationPath");
        }
        // kept for the record
        // not needed anymore with test options extraction
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
        if (testOptionsMap.containsKey("ignoreSystemLifecycleBootstrap")) {
            testOptions.ignoreSystemLifecycleBootstrap = testOptionsMap.get("ignoreSystemLifecycleBootstrap").toString().equals("true");
        }

        Adjust.setTestOptions(testOptions);
    }
}
