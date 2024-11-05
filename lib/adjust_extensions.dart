import 'package:adjust_sdk/adjust_third_party_sharing.dart';

import 'adjust_config.dart';
import 'adjust_event.dart';

extension AdjustEventBuilder on AdjustEvent {
  static AdjustEvent create(String token) {
    return AdjustEvent(token);
  }

  AdjustEvent withRevenue(num revenue, String currency) {
    this.setRevenue(revenue, currency);
    return this;
  }

  AdjustEvent withCallbackParameter(String key, String value) {
    this.addCallbackParameter(key, value);
    return this;
  }

  AdjustEvent withPartnerParameter(String key, String value) {
    this.addPartnerParameter(key, value);
    return this;
  }

  AdjustEvent withCallbackId(String callbackId) {
    this.callbackId = callbackId;
    return this;
  }

  AdjustEvent withDeduplicationId(String deduplicationId) {
    this.deduplicationId = deduplicationId;
    return this;
  }

  AdjustEvent withProductId(String productId) {
    this.productId = productId;
    return this;
  }

  AdjustEvent withTransactionId(String transactionId) {
    this.transactionId = transactionId;
    return this;
  }

  AdjustEvent withPurchaseToken(String purchaseToken) {
    this.purchaseToken = purchaseToken;
    return this;
  }
}

extension AdjustConfigBuilder on AdjustConfig {
  static AdjustConfig create(String appToken, AdjustEnvironment environment) {
    return new AdjustConfig(appToken, environment);
  }

  AdjustConfig withUrlStrategy(List<String> urlStrategyDomains,
      bool useSubdomains, bool isDataResidency) {
    this.setUrlStrategy(urlStrategyDomains, useSubdomains, isDataResidency);
    return this;
  }

  AdjustConfig setSkanAttributionEnabled(bool isSkanAttributionEnabled) {
    this.isSkanAttributionEnabled = isSkanAttributionEnabled;
    return this;
  }

  AdjustConfig setSendingInBackgroundEnabled(
      bool isSendingInBackgroundEnabled) {
    this.isSendingInBackgroundEnabled = isSendingInBackgroundEnabled;
    return this;
  }

  AdjustConfig setAdServicesEnabled(bool isAdServicesEnabled) {
    this.isAdServicesEnabled = isAdServicesEnabled;
    return this;
  }

  AdjustConfig setIdfaReadingEnabled(bool isIdfaReadingEnabled) {
    this.isIdfaReadingEnabled = isIdfaReadingEnabled;
    return this;
  }

  AdjustConfig setIdfvReadingEnabled(bool isIdfvReadingEnabled) {
    this.isIdfvReadingEnabled = isIdfvReadingEnabled;
    return this;
  }

  AdjustConfig setCostDataInAttributionEnabled(
      bool isCostDataInAttributionEnabled) {
    this.isCostDataInAttributionEnabled = isCostDataInAttributionEnabled;
    return this;
  }

  AdjustConfig setPreinstallTrackingEnabled(bool isPreinstallTrackingEnabled) {
    this.isPreinstallTrackingEnabled = isPreinstallTrackingEnabled;
    return this;
  }

  AdjustConfig setLinkMeEnabled(bool isLinkMeEnabled) {
    this.isLinkMeEnabled = isLinkMeEnabled;
    return this;
  }

  AdjustConfig setDeviceIdsReadingOnceEnabled(
      bool isDeviceIdsReadingOnceEnabled) {
    this.isDeviceIdsReadingOnceEnabled = isDeviceIdsReadingOnceEnabled;
    return this;
  }

  AdjustConfig setCoppaComplianceEnabled(bool isCoppaComplianceEnabled) {
    this.isCoppaComplianceEnabled = isCoppaComplianceEnabled;
    return this;
  }

  AdjustConfig setPlayStoreKidsComplianceEnabled(
      bool isPlayStoreKidsComplianceEnabled) {
    this.isPlayStoreKidsComplianceEnabled = isPlayStoreKidsComplianceEnabled;
    return this;
  }

  AdjustConfig setDeferredDeeplinkOpeningEnabled(
      bool isDeferredDeeplinkOpeningEnabled) {
    this.isDeferredDeeplinkOpeningEnabled = isDeferredDeeplinkOpeningEnabled;
    return this;
  }

  AdjustConfig setAttConsentWaitingInterval(num attConsentWaitingInterval) {
    this.attConsentWaitingInterval = attConsentWaitingInterval;
    return this;
  }

  AdjustConfig setEventDeduplicationIdsMaxSize(
      num eventDeduplicationIdsMaxSize) {
    this.eventDeduplicationIdsMaxSize = eventDeduplicationIdsMaxSize;
    return this;
  }

  AdjustConfig setSdkPrefix(String sdkPrefix) {
    this.sdkPrefix = sdkPrefix;
    return this;
  }

  AdjustConfig setDefaultTracker(String defaultTracker) {
    this.defaultTracker = defaultTracker;
    return this;
  }

  AdjustConfig setExternalDeviceId(String externalDeviceId) {
    this.externalDeviceId = externalDeviceId;
    return this;
  }

  AdjustConfig setProcessName(String processName) {
    this.processName = processName;
    return this;
  }

  AdjustConfig setPreinstallFilePath(String preinstallFilePath) {
    this.preinstallFilePath = preinstallFilePath;
    return this;
  }

  AdjustConfig setFbAppId(String fbAppId) {
    this.fbAppId = fbAppId;
    return this;
  }

  AdjustConfig setLogLevel(AdjustLogLevel logLevel) {
    this.logLevel = logLevel;
    return this;
  }

  AdjustConfig setAttributionCallback(AttributionCallback attributionCallback) {
    this.attributionCallback = attributionCallback;
    return this;
  }

  AdjustConfig setSessionSuccessCallback(
      SessionSuccessCallback sessionSuccessCallback) {
    this.sessionSuccessCallback = sessionSuccessCallback;
    return this;
  }

  AdjustConfig setSessionFailureCallback(
      SessionFailureCallback sessionFailureCallback) {
    this.sessionFailureCallback = sessionFailureCallback;
    return this;
  }

  AdjustConfig setEventSuccessCallback(
      EventSuccessCallback eventSuccessCallback) {
    this.eventSuccessCallback = eventSuccessCallback;
    return this;
  }

  AdjustConfig setEventFailureCallback(
      EventFailureCallback eventFailureCallback) {
    this.eventFailureCallback = eventFailureCallback;
    return this;
  }

  AdjustConfig setDeferredDeeplinkCallback(
      DeferredDeeplinkCallback deferredDeeplinkCallback) {
    this.deferredDeeplinkCallback = deferredDeeplinkCallback;
    return this;
  }

  AdjustConfig setSkanUpdatedCallback(SkanUpdatedCallback skanUpdatedCallback) {
    this.skanUpdatedCallback = skanUpdatedCallback;
    return this;
  }
}

extension AdjustThirdPartySharingBuilder on AdjustThirdPartySharing {
  static AdjustThirdPartySharing create(bool isEnabled) {
    return new AdjustThirdPartySharing(isEnabled);
  }

  AdjustThirdPartySharing addGranularOption(
      String partnerName, String key, String value) {
    this.addGranularOption(partnerName, key, value);
    return this;
  }

  AdjustThirdPartySharing addPartnerSharingSetting(
      String partnerName, String key, bool value) {
    this.addPartnerSharingSetting(partnerName, key, value);
    return this;
  }
}
