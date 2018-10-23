package com.adjust.sdk.adjustsdkplugin;

import android.content.Context;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustEvent;

import java.util.Map;

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

    public static void onCreate(Context context, Map adjustConfigMap) {
        getDefaultInstance().onCreate(context, adjustConfigMap);
    }

    public static void onResume() {
        getDefaultInstance().onResume();
    }

    public static void onPause() {
        getDefaultInstance().onPause();
    }

    public static void trackEvent(Map eventParamsMap) {
        getDefaultInstance().trackEvent(eventParamsMap);
    }

    public static boolean isEnabled() {
        return getDefaultInstance().isEnabled();
    }

    public static void setIsEnabled(Map isEnabledParamsMap) {
        getDefaultInstance().setEnabled(isEnabledParamsMap);
    }
}
