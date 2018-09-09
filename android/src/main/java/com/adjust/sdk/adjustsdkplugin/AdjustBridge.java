package com.adjust.sdk.adjustsdkplugin;

import android.content.Context;

import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;
import com.adjust.sdk.AdjustTestOptions;
import com.adjust.sdk.OnDeviceIdsRead;

import java.util.HashMap;

/**
 * com.adjust.sdk.adjustsdkplugin
 * Created by 2beens on 25.04.18.
 */
public class AdjustBridge {
    private static AdjustBridgeInstance defaultInstance;

    public static synchronized AdjustBridgeInstance getDefaultInstance() {
        if (defaultInstance == null) {
            defaultInstance = new AdjustBridgeInstance();
        }
        return defaultInstance;
    }

    public static void onCreate(AdjustConfig config) {
        getDefaultInstance().onCreate(config);
    }

    public static void onResume() {
        getDefaultInstance().onResume();
    }

    public static void onPause() {
        getDefaultInstance().onPause();
    }

    public static void trackEvent(AdjustEvent event) {
        getDefaultInstance().trackEvent(event);
    }

    public static boolean isEnabled() {
        return getDefaultInstance().isEnabled();
    }

    public static void setIsEnabled(boolean isEnabled) {
        getDefaultInstance().setEnabled(isEnabled);
    }

    public static void setPushToken(String token) {
        getDefaultInstance().setPushToken(token);
    }

    public static void setOfflineMode(boolean isOffline) {
        getDefaultInstance().setOfflineMode(isOffline);
    }

    public static void appWillOpenUrl(String url) {
        getDefaultInstance().appWillOpenUrl(url);
    }

    public static void sendFirstPackages() {
        getDefaultInstance().sendFirstPackages();
    }

    public static String getAdid() {
        return getDefaultInstance().getAdid();
    }

    public static String getAmazonAdId(Context context) {
        return getDefaultInstance().getAmazonAdId(context);
    }

    public static void getGoogleAdId(Context context, OnDeviceIdsRead callback) {
        getDefaultInstance().getGoogleAdId(context, callback);
    }

    public static void setReferrer(Context context, String referrer) {
        getDefaultInstance().setReferrer(context, referrer);
    }

    public static void gdprForgetMe(Context context) {
        getDefaultInstance().gdprForgetMe(context);
    }

    public static HashMap<String, String> getAttribution() {
        return getDefaultInstance().getAttribution();
    }

    public static void addSessionCallbackParameter(String key, String value) {
        getDefaultInstance().addSessionCallbackParameter(key, value);
    }

    public static void addSessionPartnerParameter(String key, String value) {
        getDefaultInstance().addSessionPartnerParameter(key, value);
    }

    public static void removeSessionCallbackParameter(String key) {
        getDefaultInstance().removeSessionCallbackParameter(key);
    }

    public static void removeSessionPartnerParameter(String key) {
        getDefaultInstance().removeSessionPartnerParameter(key);
    }

    public static void resetSessionCallbackParameters() {
        getDefaultInstance().resetSessionCallbackParameters();
    }

    public static void resetSessionPartnerParameters() {
        getDefaultInstance().resetSessionPartnerParameters();
    }

    public static void setTestOptions(AdjustTestOptions testOptions) {
        getDefaultInstance().setTestOptions(testOptions);
    }
}
