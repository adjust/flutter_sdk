package com.adjust.sdk.adjustsdkplugin;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;

/**
 * com.adjust.sdk.adjustsdkplugin
 * Created by 2beens on 25.04.18.
 */
public class AdjustBridgeInstance {
    public void onCreate(AdjustConfig config) {
        Adjust.onCreate(config);
    }

    public void trackEvent(AdjustEvent event) {
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

    public void setEnabled(boolean isEnabled) {
        Adjust.setEnabled(isEnabled);
    }

    public static void addSessionCallbackParameter(String key, String value) {
        Adjust.addSessionCallbackParameter(key, value);
    }

    public static void addSessionPartnerParameter(String key, String value) {
        Adjust.addSessionPartnerParameter(key, value);
    }
}
