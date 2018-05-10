package com.adjust.sdk.adjustsdkplugin;

import android.content.Context;
import android.net.Uri;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustAttribution;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;
import com.adjust.sdk.OnDeviceIdsRead;

import java.util.HashMap;

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

    public void setOfflineMode(boolean isOffline) {
        Adjust.setOfflineMode(isOffline);
    }

    public void setPushToken(String token) {
        Adjust.setPushToken(token);
    }

    public void appWillOpenUrl(String url) {
        Adjust.appWillOpenUrl(Uri.parse(url));
    }

    public void onResume() {
        Adjust.onResume();
    }

    public void onPause() {
        Adjust.onPause();
    }
    public void sendFirstPackages() {
        Adjust.sendFirstPackages();
    }

    public void setEnabled(boolean isEnabled) {
        Adjust.setEnabled(isEnabled);
    }

    public String getAdid() {
        return Adjust.getAdid();
    }

    public String getAmazonAdId(Context context) {
        return Adjust.getAmazonAdId(context);
    }

    public void getGoogleAdId(Context context, OnDeviceIdsRead callback) {
        Adjust.getGoogleAdId(context, callback);
    }

    public void setReferrer(Context context, String referrer) {
        Adjust.setReferrer(referrer, context);
    }

    public void gdprForgetMe(Context context) {
        Adjust.gdprForgetMe(context);
    }

    public HashMap<String, String> getAttribution() {
        AdjustAttribution adjustAttribution = Adjust.getAttribution();
        if(adjustAttribution == null) {
            adjustAttribution = new AdjustAttribution();
        }

        HashMap<String, String> adjustAttributionMap = new HashMap();
        adjustAttributionMap.put("trackerToken", adjustAttribution.trackerToken);
        adjustAttributionMap.put("trackerName", adjustAttribution.trackerName);
        adjustAttributionMap.put("network", adjustAttribution.network);
        adjustAttributionMap.put("campaign", adjustAttribution.campaign);
        adjustAttributionMap.put("adgroup", adjustAttribution.adgroup);
        adjustAttributionMap.put("creative", adjustAttribution.creative);
        adjustAttributionMap.put("clickLabel", adjustAttribution.clickLabel);
        adjustAttributionMap.put("adid", adjustAttribution.adid);
        return adjustAttributionMap;
    }

    public static void addSessionCallbackParameter(String key, String value) {
        Adjust.addSessionCallbackParameter(key, value);
    }

    public static void addSessionPartnerParameter(String key, String value) {
        Adjust.addSessionPartnerParameter(key, value);
    }

    public static void removeSessionCallbackParameter(String key) {
        Adjust.removeSessionCallbackParameter(key);
    }

    public static void removeSessionPartnerParameter(String key) {
        Adjust.removeSessionPartnerParameter(key);
    }

    public static void resetSessionCallbackParameters() {
        Adjust.resetSessionCallbackParameters();
    }

    public static void resetSessionPartnerParameters() {
        Adjust.resetSessionPartnerParameters();
    }
}
