package com.adjust.sdk.adjustsdkplugin;

import android.content.Context;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;
import com.adjust.sdk.LogLevel;

import java.util.Map;

/**
 * com.adjust.sdk.adjustsdkplugin
 * Created by 2beens on 25.04.18.
 */
public class AdjustBridgeInstance {
    public void onCreate(Context context, Map adjustConfigMap) {
        String appToken = (String) adjustConfigMap.get("appToken");
        String logLevel = (String) adjustConfigMap.get("logLevel");
        String environment = (String) adjustConfigMap.get("environment");
        String defaultTracker = (String) adjustConfigMap.get("defaultTracker");
        String isDeviceKnownString = (String) adjustConfigMap.get("isDeviceKnown");
        boolean isDeviceKnown = Boolean.valueOf(isDeviceKnownString);

        AdjustConfig config = new AdjustConfig(context, appToken, environment);
        String userAgent = (String) adjustConfigMap.get("userAgent");
        config.setUserAgent(userAgent);
        config.setLogLevel(LogLevel.valueOf(logLevel));
        config.setDefaultTracker(defaultTracker);
        config.setDeviceKnown(isDeviceKnown);

        AdjustSdkPlugin.log("Calling onCreate with values:");
        AdjustSdkPlugin.log("\tappToken: " + appToken);
        AdjustSdkPlugin.log("\tenvironment: " + environment);
        AdjustSdkPlugin.log("\tuserAgent: " + userAgent);
        AdjustSdkPlugin.log("\tlogLevel: " + logLevel);

        Adjust.onCreate(config);
    }

    public void trackEvent(Map eventParamsMap) {
        String revenue = (String) eventParamsMap.get("revenue");
        String currency = (String) eventParamsMap.get("currency");
        String orderId = (String) eventParamsMap.get("orderId");
        String eventToken = (String) eventParamsMap.get("eventToken");

        AdjustEvent event = new AdjustEvent(eventToken);
        event.setRevenue(Double.valueOf(revenue), currency);
        event.setOrderId(orderId);

        Adjust.trackEvent(event);
    }

    public boolean isEnabled() {
        return Adjust.isEnabled();
    }

    public void onResume() {
        Adjust.onResume();
    }

    public void onPause() {
        Adjust.onPause();
    }

    public void setEnabled(Map isEnabledParamsMap) {
        boolean isEnabled = (boolean) isEnabledParamsMap.get("isEnabled");
        Adjust.setEnabled(isEnabled);
    }
}
