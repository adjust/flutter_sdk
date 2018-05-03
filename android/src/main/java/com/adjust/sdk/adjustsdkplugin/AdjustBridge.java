package com.adjust.sdk.adjustsdkplugin;

import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;

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

    public static void addSessionCallbackParameter(String key, String value) {
        getDefaultInstance().addSessionCallbackParameter(key, value);
    }

    public static void addSessionPartnerParameter(String key, String value) {
        getDefaultInstance().addSessionPartnerParameter(key, value);
    }
}
