//
//  AdjustSdk.m
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 6th June 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import "AdjustSdk.h"
#import "AdjustSdkDelegate.h"
#import <AdjustSdk/AdjustSdk.h>

static NSString * const CHANNEL_API_NAME = @"com.adjust.sdk/api";

@interface AdjustSdk ()

@property (nonatomic, retain) FlutterMethodChannel *channel;

@end

@implementation AdjustSdk

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_API_NAME
                                                                binaryMessenger:[registrar messenger]];
    AdjustSdk *instance = [[AdjustSdk alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)dealloc {
    [self.channel setMethodCallHandler:nil];
    self.channel = nil;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"initSdk" isEqualToString:call.method]) {
        [self initSdk:call withResult:result];
    } else if ([@"trackEvent" isEqualToString:call.method]) {
        [self trackEvent:call withResult:result];
    } else if ([@"enable" isEqualToString:call.method]) {
        [Adjust enable];
    } else if ([@"disable" isEqualToString:call.method]) {
        [Adjust disable];
    } else if ([@"gdprForgetMe" isEqualToString:call.method]) {
        [self gdprForgetMe:call withResult:result];
    } else if ([@"getAttribution" isEqualToString:call.method]) {
        [self getAttribution:call withResult:result];
    } else if ([@"getIdfa" isEqualToString:call.method]) {
        [self getIdfa:call withResult:result];
    } else if ([@"getIdfv" isEqualToString:call.method]) {
        [self getIdfv:call withResult:result];
    } else if ([@"getSdkVersion" isEqualToString:call.method]) {
        [self getSdkVersion:call withResult:result];
    } else if ([@"switchToOfflineMode" isEqualToString:call.method]) {
        [Adjust switchToOfflineMode];
    } else if ([@"switchBackToOnlineMode" isEqualToString:call.method]) {
        [Adjust switchBackToOnlineMode];
    } else if ([@"setPushToken" isEqualToString:call.method]) {
        [self setPushToken:call withResult:result];
    } else if ([@"appWillOpenUrl" isEqualToString:call.method]) {
        [self processDeeplink:call withResult:result];
    } else if ([@"trackAdRevenue" isEqualToString:call.method]) {
        [self trackAdRevenue:call withResult:result];
    } else if ([@"trackAppStoreSubscription" isEqualToString:call.method]) {
        [self trackAppStoreSubscription:call withResult:result];
    } else if ([@"requestAppTrackingAuthorization" isEqualToString:call.method]) {
        [self requestAppTrackingAuthorization:call withResult:result];
    } else if ([@"getAppTrackingAuthorizationStatus" isEqualToString:call.method]) {
        [self getAppTrackingAuthorizationStatus:call withResult:result];
    } else if ([@"trackThirdPartySharing" isEqualToString:call.method]) {
        [self trackThirdPartySharing:call withResult:result];
    } else if ([@"trackMeasurementConsent" isEqualToString:call.method]) {
        [self trackMeasurementConsent:call withResult:result];
    } else if ([@"updateSkanConversionValue" isEqualToString:call.method ]){
        [self updateSkanConversionValue:call withResult:result];
    } else if ([@"addGlobalCallbackParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        NSString *value = call.arguments[@"value"];
        if (!([self isFieldValid:key]) || !([self isFieldValid:value])) {
            return;
        }
        [Adjust addGlobalCallbackParameter:value forKey:key];
    } else if ([@"removeGlobalCallbackParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        if (!([self isFieldValid:key])) {
            return;
        }
        [Adjust removeGlobalCallbackParameterForKey:key];
    } else if ([@"removeGlobalCallbackParameters" isEqualToString:call.method]) {
        [Adjust removeGlobalCallbackParameters];
    } else if ([@"addGlobalPartnerParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        NSString *value = call.arguments[@"value"];
        if (!([self isFieldValid:key]) || !([self isFieldValid:value])) {
            return;
        }
        [Adjust addGlobalPartnerParameter:value forKey:key];
    } else if ([@"removeGlobalPartnerParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        if (!([self isFieldValid:key])) {
            return;
        }
        [Adjust removeGlobalPartnerParameterForKey:key];
    } else if ([@"removeGlobalPartnerParameters" isEqualToString:call.method]) {
        [Adjust removeGlobalPartnerParameters];
    } else if ([@"isEnabled" isEqualToString:call.method]) {
        [Adjust isEnabledWithCompletionHandler:^(BOOL isEnabled) {
            result(@(isEnabled));
        }];
    } else if ([@"getAdid" isEqualToString:call.method]) {
        [Adjust adidWithCompletionHandler:^(NSString * _Nullable adid) {
            result(adid);
        }];
    } else if ([@"verifyAppStorePurchase" isEqualToString:call.method]) {
        [self verifyAppStorePurchase:call withResult:result];
    } else if ([@"verifyAndTrackAppStorePurchase" isEqualToString:call.method]) {
        [self verifyAndTrackAppStorePurchase:call withResult:result];
    } else if ([@"processDeeplink" isEqualToString:call.method]) {
        [self processDeeplink:call withResult:result];
    } else if ([@"processAndResolveDeeplink" isEqualToString:call.method]) {
        [self processAndResolveDeeplink:call withResult:result];
    } else if ([@"getLastDeeplink" isEqualToString:call.method]) {
        [self getLastDeeplink:call withResult:result];
    } else if ([@"getGoogleAdId" isEqualToString:call.method]) {
        [self getGoogleAdId:call withResult:result];
    } else if ([@"trackPlayStoreSubscription" isEqualToString:call.method]) {
        [self trackPlayStoreSubscription:call withResult:result];
    } else if ([@"verifyPlayStorePurchase" isEqualToString:call.method]) {
        [self verifyAppStorePurchase:call withResult:result];
    } else if ([@"verifyAndTrackPlayStorePurchase" isEqualToString:call.method]) {
        [self verifyAndTrackPlayStorePurchase:call withResult:result];
    } else if ([@"onResume" isEqualToString:call.method]) {
        [Adjust trackSubsessionStart];
    } else if ([@"onPause" isEqualToString:call.method]) {
        [Adjust trackSubsessionEnd];
    } else if ([@"setTestOptions" isEqualToString:call.method]) {
        [self setTestOptions:call withResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)initSdk:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *appToken = call.arguments[@"appToken"];
    NSString *environment = call.arguments[@"environment"];
    NSString *logLevel = call.arguments[@"logLevel"];
    NSString *sdkPrefix = call.arguments[@"sdkPrefix"];
    NSString *defaultTracker = call.arguments[@"defaultTracker"];
    NSString *externalDeviceId = call.arguments[@"externalDeviceId"];
    NSString *strUrlStrategyDomainsJson = call.arguments[@"urlStrategyDomains"];
    BOOL isDataResidency = [call.arguments[@"isDataResidency"] boolValue];
    BOOL useSubdomains = [call.arguments[@"useSubdomains"] boolValue];
    NSString *attConsentWaitingInterval = call.arguments[@"attConsentWaitingInterval"];
    NSString *isSendingInBackgroundEnabled = call.arguments[@"isSendingInBackgroundEnabled"];
    NSInteger eventDeduplicationIdsMaxSize = [call.arguments[@"eventDeduplicationIdsMaxSize"] integerValue];
    NSString *isCostDataInAttributionEnabled = call.arguments[@"isCostDataInAttributionEnabled"];
    NSString *isCoppaComplianceEnabled = call.arguments[@"isCoppaComplianceEnabled"];
    NSString *isLinkMeEnabled = call.arguments[@"isLinkMeEnabled"];
    NSString *isAdServicesEnabled = call.arguments[@"isAdServicesEnabled"];
    NSString *isIdfaReadingEnabled = call.arguments[@"isIdfaReadingEnabled"];
    NSString *isIdfvReadingEnabled = call.arguments[@"isIdfvReadingEnabled"];
    NSString *isSkanAttributionEnabled = call.arguments[@"isSkanAttributionEnabled"];
    NSString *isDeviceIdsReadingOnceEnabled = call.arguments[@"isDeviceIdsReadingOnceEnabled"];
    NSString *dartAttributionCallback = call.arguments[@"attributionCallback"];
    NSString *dartSessionSuccessCallback = call.arguments[@"sessionSuccessCallback"];
    NSString *dartSessionFailureCallback = call.arguments[@"sessionFailureCallback"];
    NSString *dartEventSuccessCallback = call.arguments[@"eventSuccessCallback"];
    NSString *dartEventFailureCallback = call.arguments[@"eventFailureCallback"];
    NSString *dartDeferredDeeplinkCallback = call.arguments[@"deferredDeeplinkCallback"];
    NSString *dartSkanUpdatedCallback = call.arguments[@"skanUpdatedCallback"];
    BOOL allowSuppressLogLevel = NO;
    BOOL launchDeferredDeeplink = [call.arguments[@"launchDeferredDeeplink"] boolValue];

    // suppress log level
    if ([self isFieldValid:logLevel]) {
        if ([ADJLogger logLevelFromString:[logLevel lowercaseString]] == ADJLogLevelSuppress) {
            allowSuppressLogLevel = YES;
        }
    }

    // create config object
    ADJConfig *adjustConfig = [[ADJConfig alloc] initWithAppToken:appToken
                                                      environment:environment
                                                 suppressLogLevel:allowSuppressLogLevel];
    // SDK prefix
    if ([self isFieldValid:sdkPrefix]) {
        [adjustConfig setSdkPrefix:sdkPrefix];
    }

    // log level
    if ([self isFieldValid:logLevel]) {
        [adjustConfig setLogLevel:[ADJLogger logLevelFromString:[logLevel lowercaseString]]];
    }

    // LinkMe
    if ([self isFieldValid:isLinkMeEnabled]) {
        if ([isLinkMeEnabled boolValue] == YES) {
            [adjustConfig enableLinkMe];
        }
    }

    // COPPA compliance
    if ([self isFieldValid:isCoppaComplianceEnabled]) {
        if ([isCoppaComplianceEnabled boolValue] == YES) {
            [adjustConfig enableCoppaCompliance];
        }
    }

    // default tracker
    if ([self isFieldValid:defaultTracker]) {
        [adjustConfig setDefaultTracker:defaultTracker];
    }

    // external device ID
    if ([self isFieldValid:externalDeviceId]) {
        [adjustConfig setExternalDeviceId:externalDeviceId];
    }

    // URL strategy
    if ([self isFieldValid:strUrlStrategyDomainsJson]) {
        NSData *data = [strUrlStrategyDomainsJson dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *urlStrategyDomainsArray = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:nil];
        [adjustConfig setUrlStrategy:urlStrategyDomainsArray
                       useSubdomains:useSubdomains
                     isDataResidency:isDataResidency];
    }

    // sending in background
    if ([self isFieldValid:isSendingInBackgroundEnabled]) {
        if ([isSendingInBackgroundEnabled boolValue] == YES) {
            [adjustConfig enableSendingInBackground];
        }
    }

    // event deduplication
    if (eventDeduplicationIdsMaxSize > 0) {
        [adjustConfig setEventDeduplicationIdsMaxSize:eventDeduplicationIdsMaxSize];
    }

    // cost data in attribution callback
    if ([self isFieldValid:isCostDataInAttributionEnabled]) {
        if ([isCostDataInAttributionEnabled boolValue] == YES) {
            [adjustConfig enableCostDataInAttribution];
        }
    }

    // AdServices.framework interaction
    if ([self isFieldValid:isAdServicesEnabled]) {
        if ([isAdServicesEnabled boolValue] == NO) {
            [adjustConfig disableAdServices];
        }
    }

    // IDFA reading
    if ([self isFieldValid:isIdfaReadingEnabled]) {
        if ([isIdfaReadingEnabled boolValue] == NO) {
            [adjustConfig disableIdfaReading];
        }
    }

    // IDFV reading
    if ([self isFieldValid:isIdfvReadingEnabled]) {
        if ([isIdfvReadingEnabled boolValue] == NO) {
            [adjustConfig disableIdfvReading];
        }
    }
    
    // SKAdNetwork attribution
    if ([self isFieldValid:isSkanAttributionEnabled]) {
        if ([isSkanAttributionEnabled boolValue] == NO) {
            [adjustConfig disableSkanAttribution];
        }
    }

    // read device info once
    if ([self isFieldValid:isDeviceIdsReadingOnceEnabled]) {
        if ([isDeviceIdsReadingOnceEnabled boolValue] == YES) {
            [adjustConfig enableDeviceIdsReadingOnce];
        }
    }

    // ATT consent delay
    if ([self isFieldValid:attConsentWaitingInterval]) {
        [adjustConfig setAttConsentWaitingInterval:[attConsentWaitingInterval intValue]];
    }

    // callbacks
    if (dartAttributionCallback != nil
        || dartSessionSuccessCallback != nil
        || dartSessionFailureCallback != nil
        || dartEventSuccessCallback != nil
        || dartEventFailureCallback != nil
        || dartDeferredDeeplinkCallback != nil
        || dartSkanUpdatedCallback != nil) {
        [adjustConfig setDelegate:
         [AdjustSdkDelegate getInstanceWithSwizzleOfAttributionCallback:dartAttributionCallback
                                                 sessionSuccessCallback:dartSessionSuccessCallback
                                                 sessionFailureCallback:dartSessionFailureCallback
                                                   eventSuccessCallback:dartEventSuccessCallback
                                                   eventFailureCallback:dartEventFailureCallback
                                               deferredDeeplinkCallback:dartDeferredDeeplinkCallback
                                                    skanUpdatedCallback:dartSkanUpdatedCallback
                                           shouldLaunchDeferredDeeplink:launchDeferredDeeplink
                                                          methodChannel:self.channel]];
    }

    // start SDK
    [Adjust initSdk:adjustConfig];
    result(nil);
}

- (void)trackEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventToken = call.arguments[@"eventToken"];
    NSString *revenue = call.arguments[@"revenue"];
    NSString *currency = call.arguments[@"currency"];
    NSString *callbackId = call.arguments[@"callbackId"];
    NSString *productId = call.arguments[@"productId"];
    NSString *transactionId = call.arguments[@"transactionId"];
    NSString *deduplicationId = call.arguments[@"deduplicationId"];
    NSString *strCallbackParametersJson = call.arguments[@"callbackParameters"];
    NSString *strPartnerParametersJson = call.arguments[@"partnerParameters"];

    // create event object
    ADJEvent *adjustEvent = [[ADJEvent alloc] initWithEventToken:eventToken];

    // revenue and currency
    if ([self isFieldValid:revenue]) {
        double revenueValue = [revenue doubleValue];
        [adjustEvent setRevenue:revenueValue currency:currency];
    }

    // rroduct ID
    if ([self isFieldValid:productId]) {
        [adjustEvent setProductId:productId];
    }

    // transaction ID
    if ([self isFieldValid:transactionId]) {
        [adjustEvent setTransactionId:transactionId];
    }

    // deduplication ID
    if ([self isFieldValid:deduplicationId]) {
        [adjustEvent setDeduplicationId:deduplicationId];
    }

    // callback ID
    if ([self isFieldValid:callbackId]) {
        [adjustEvent setCallbackId:callbackId];
    }

    // callback parameters
    if (strCallbackParametersJson != nil) {
        NSData *callbackParametersData = [strCallbackParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id callbackParametersJson = [NSJSONSerialization JSONObjectWithData:callbackParametersData
                                                                    options:0
                                                                      error:NULL];
        for (id key in callbackParametersJson) {
            NSString *value = [callbackParametersJson objectForKey:key];
            [adjustEvent addCallbackParameter:key value:value];
        }
    }

    // partner parameters
    if (strPartnerParametersJson != nil) {
        NSData *partnerParametersData = [strPartnerParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id partnerParametersJson = [NSJSONSerialization JSONObjectWithData:partnerParametersData
                                                                   options:0
                                                                     error:NULL];
        for (id key in partnerParametersJson) {
            NSString *value = [partnerParametersJson objectForKey:key];
            [adjustEvent addPartnerParameter:key value:value];
        }
    }

    // track event
    [Adjust trackEvent:adjustEvent];
    result(nil);
}

- (void)enable:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust enable];
    result(nil);
}

- (void)disable:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust disable];
    result(nil);
}

- (void)gdprForgetMe:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust gdprForgetMe];
    result(nil);
}

- (void)switchToOfflineMode:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust switchToOfflineMode];
    result(nil);
}

- (void)switchBackToOnlineMode:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust switchBackToOnlineMode];
    result(nil);
}

- (void)setPushToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *pushToken = call.arguments[@"pushToken"];
    if ([self isFieldValid:pushToken]) {
        [Adjust setPushTokenAsString:pushToken];
    }
    result(nil);
}

- (void)processDeeplink:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *urlString = call.arguments[@"deeplink"];
    if (urlString == nil) {
        return;
    }
    
    NSURL *url;
    if ([NSString instancesRespondToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
#pragma clang diagnostic pop

    ADJDeeplink *deeplink = [[ADJDeeplink alloc] initWithDeeplink:url];
    [Adjust processDeeplink:deeplink];
}


- (void)trackAdRevenue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *source = call.arguments[@"source"];
    NSString *revenue = call.arguments[@"revenue"];
    NSString *currency = call.arguments[@"currency"];
    NSString *adImpressionsCount = call.arguments[@"adImpressionsCount"];
    NSString *adRevenueNetwork = call.arguments[@"adRevenueNetwork"];
    NSString *adRevenueUnit = call.arguments[@"adRevenueUnit"];
    NSString *adRevenuePlacement = call.arguments[@"adRevenuePlacement"];
    NSString *strCallbackParametersJson = call.arguments[@"callbackParameters"];
    NSString *strPartnerParametersJson = call.arguments[@"partnerParameters"];

    // create ad revenue object
    ADJAdRevenue *adjustAdRevenue = [[ADJAdRevenue alloc] initWithSource:source];

    // revenue
    if ([self isFieldValid:revenue]) {
        double revenueValue = [revenue doubleValue];
        [adjustAdRevenue setRevenue:revenueValue currency:currency];
    }

    // ad impressions count
    if ([self isFieldValid:adImpressionsCount]) {
        int adImpressionsCountValue = [adImpressionsCount intValue];
        [adjustAdRevenue setAdImpressionsCount:adImpressionsCountValue];
    }

    // ad revenue network
    if ([self isFieldValid:adRevenueNetwork]) {
        [adjustAdRevenue setAdRevenueNetwork:adRevenueNetwork];
    }
    
    // ad revenue unit
    if ([self isFieldValid:adRevenueUnit]) {
        [adjustAdRevenue setAdRevenueUnit:adRevenueUnit];
    }
    
    // ad revenue placement
    if ([self isFieldValid:adRevenuePlacement]) {
        [adjustAdRevenue setAdRevenuePlacement:adRevenuePlacement];
    }

    // callback parameters
    if (strCallbackParametersJson != nil) {
        NSData *callbackParametersData = [strCallbackParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id callbackParametersJson = [NSJSONSerialization JSONObjectWithData:callbackParametersData
                                                                    options:0
                                                                      error:NULL];
        for (id key in callbackParametersJson) {
            NSString *value = [callbackParametersJson objectForKey:key];
            [adjustAdRevenue addCallbackParameter:key value:value];
        }
    }

    // partner parameters
    if (strPartnerParametersJson != nil) {
        NSData *partnerParametersData = [strPartnerParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id partnerParametersJson = [NSJSONSerialization JSONObjectWithData:partnerParametersData
                                                                   options:0
                                                                     error:NULL];
        for (id key in partnerParametersJson) {
            NSString *value = [partnerParametersJson objectForKey:key];
            [adjustAdRevenue addPartnerParameter:key value:value];
        }
    }

    // track ad revenue
    [Adjust trackAdRevenue:adjustAdRevenue];
    result(nil);
}

- (void)trackAppStoreSubscription:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *price = call.arguments[@"price"];
    NSString *currency = call.arguments[@"currency"];
    NSString *transactionId = call.arguments[@"transactionId"];
    NSString *transactionDate = call.arguments[@"transactionDate"];
    NSString *salesRegion = call.arguments[@"salesRegion"];
    // NSString *billingStore = call.arguments[@"billingStore"];
    NSString *strCallbackParametersJson = call.arguments[@"callbackParameters"];
    NSString *strPartnerParametersJson = call.arguments[@"partnerParameters"];

    // price
    NSDecimalNumber *priceValue;
    if ([self isFieldValid:price]) {
        priceValue = [NSDecimalNumber decimalNumberWithString:price];
    }

    // create subscription object
    ADJAppStoreSubscription *subscription =
    [[ADJAppStoreSubscription alloc] initWithPrice:priceValue
                                          currency:currency
                                     transactionId:transactionId];

    // transaction date
    if ([self isFieldValid:transactionDate]) {
        NSTimeInterval transactionDateInterval = [transactionDate doubleValue];
        NSDate *oTransactionDate = [NSDate dateWithTimeIntervalSince1970:transactionDateInterval];
        [subscription setTransactionDate:oTransactionDate];
    }

    // sales region
    if ([self isFieldValid:salesRegion]) {
        [subscription setSalesRegion:salesRegion];
    }

    // callback parameters
    if (strCallbackParametersJson != nil) {
        NSData *callbackParametersData = [strCallbackParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id callbackParametersJson = [NSJSONSerialization JSONObjectWithData:callbackParametersData
                                                                    options:0
                                                                      error:NULL];
        for (id key in callbackParametersJson) {
            NSString *value = [callbackParametersJson objectForKey:key];
            [subscription addCallbackParameter:key value:value];
        }
    }

    // partner parameters
    if (strPartnerParametersJson != nil) {
        NSData *partnerParametersData = [strPartnerParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id partnerParametersJson = [NSJSONSerialization JSONObjectWithData:partnerParametersData
                                                                   options:0
                                                                     error:NULL];
        for (id key in partnerParametersJson) {
            NSString *value = [partnerParametersJson objectForKey:key];
            [subscription addPartnerParameter:key value:value];
        }
    }

    // track subscription
    [Adjust trackAppStoreSubscription:subscription];
    result(nil);
}

- (void)getAttribution:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust attributionWithCompletionHandler:^(ADJAttribution * _Nullable attribution) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if (attribution == nil) {
            result(dictionary);
        }

        [self addValueOrEmpty:attribution.trackerToken withKey:@"trackerToken" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.trackerName withKey:@"trackerName" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.network withKey:@"network" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.campaign withKey:@"campaign" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.creative withKey:@"creative" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.adgroup withKey:@"adgroup" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.clickLabel withKey:@"clickLabel" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.costType withKey:@"costType" toDictionary:dictionary];
        [self addNumberOrEmpty:attribution.costAmount withKey:@"costAmount" toDictionary:dictionary];
        [self addValueOrEmpty:attribution.costCurrency withKey:@"costCurrency" toDictionary:dictionary];
        result(dictionary);
    }];
}

- (void)getIdfa:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust idfaWithCompletionHandler:^(NSString * _Nullable idfa) {
        result(idfa);
    }];
}

- (void)getIdfv:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust idfvWithCompletionHandler:^(NSString * _Nullable idfv) {
        result(idfv);
    }];
}

- (void)getSdkVersion:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust sdkVersionWithCompletionHandler:^(NSString * _Nullable sdkVersion) {
        result(sdkVersion);
    }];
}

- (void)requestAppTrackingAuthorization:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust requestAppTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
        result([NSNumber numberWithUnsignedLong:status]);
    }];
}

- (void)getAppTrackingAuthorizationStatus:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([NSNumber numberWithInt:[Adjust appTrackingAuthorizationStatus]]);
}

- (void)trackThirdPartySharing:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSNumber *isEnabled = call.arguments[@"isEnabled"];
    NSString *strGranularOptions = call.arguments[@"granularOptions"];
    NSString *strPartnerSharingSettings = call.arguments[@"partnerSharingSettings"];

    // create third party sharing object
    ADJThirdPartySharing *adjustThirdPartySharing = [[ADJThirdPartySharing alloc]
                                                     initWithIsEnabled:[self isFieldValid:isEnabled] ? isEnabled : nil];

    // granular options
    if (strGranularOptions != nil) {
        NSArray *arrayGranularOptions = [strGranularOptions componentsSeparatedByString:@"__ADJ__"];
        if (arrayGranularOptions != nil) {
            for (int i = 0; i < [arrayGranularOptions count]; i += 3) {
                [adjustThirdPartySharing addGranularOption:[arrayGranularOptions objectAtIndex:i]
                                                       key:[arrayGranularOptions objectAtIndex:i+1]
                                                     value:[arrayGranularOptions objectAtIndex:i+2]];
            }
        }
    }

    // partner sharing settings
    if (strPartnerSharingSettings != nil) {
        NSArray *arrayPartnerSharingSettings = [strPartnerSharingSettings componentsSeparatedByString:@"__ADJ__"];
        if (arrayPartnerSharingSettings != nil) {
            for (int i = 0; i < [arrayPartnerSharingSettings count]; i += 3) {
                [adjustThirdPartySharing addPartnerSharingSetting:[arrayPartnerSharingSettings objectAtIndex:i]
                                                              key:[arrayPartnerSharingSettings objectAtIndex:i+1]
                                                            value:[[arrayPartnerSharingSettings objectAtIndex:i+2] boolValue]];
            }
        }
    }

    // track third party sharing
    [Adjust trackThirdPartySharing:adjustThirdPartySharing];
    result(nil);
}

- (void)trackMeasurementConsent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *measurementConsent = call.arguments[@"measurementConsent"];
    if ([self isFieldValid:measurementConsent]) {
        [Adjust trackMeasurementConsent:[measurementConsent boolValue]];
    }
    result(nil);
}

- (void)updateSkanConversionValue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSInteger conversionValue = [call.arguments[@"conversionValue"] integerValue];
    NSString *coarseValue = call.arguments[@"coarseValue"];
    NSNumber *lockWindow = call.arguments[@"lockWindow"];
    [Adjust updateSkanConversionValue:conversionValue
                          coarseValue:coarseValue
                           lockWindow:lockWindow
                withCompletionHandler:^(NSError * _Nullable error) {
        result(error.description);
    }];
}

- (void)verifyAppStorePurchase:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *productId = call.arguments[@"productId"];
    NSString *transactionId = call.arguments[@"transactionId"];

    // create purchase instance
    ADJAppStorePurchase *purchase = [[ADJAppStorePurchase alloc] initWithTransactionId:transactionId
                                                             productId:productId];

    // verify purchase
    [Adjust verifyAppStorePurchase:purchase withCompletionHandler:^(ADJPurchaseVerificationResult * _Nonnull verificationResult) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if (verificationResult == nil) {
            result(dictionary);
        }
        
        [self addValueOrEmpty:verificationResult.verificationStatus
                      withKey:@"verificationStatus"
                 toDictionary:dictionary];
        [self addValueOrEmpty:[NSString stringWithFormat:@"%d", verificationResult.code]
                      withKey:@"code"
                 toDictionary:dictionary];
        [self addValueOrEmpty:verificationResult.message
                      withKey:@"message"
                 toDictionary:dictionary];
        result(dictionary);
    }];
}

- (void)processAndResolveDeeplink:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *deeplink = call.arguments[@"deeplink"];
    if ([self isFieldValid:deeplink]) {
        NSURL *nsUrl;
        if ([NSString instancesRespondToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
            nsUrl = [NSURL URLWithString:[deeplink stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            nsUrl = [NSURL URLWithString:[deeplink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
#pragma clang diagnostic pop

        ADJDeeplink *deeplink = [[ADJDeeplink alloc] initWithDeeplink:nsUrl];
        [Adjust processAndResolveDeeplink:deeplink
                    withCompletionHandler:^(NSString * _Nullable resolvedLink) {
            if (![self isFieldValid:resolvedLink]) {
                result(nil);
            } else {
                result(resolvedLink);
            }
        }];
    }
}

- (void)verifyAndTrackAppStorePurchase:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventToken = call.arguments[@"eventToken"];
    NSString *revenue = call.arguments[@"revenue"];
    NSString *currency = call.arguments[@"currency"];
    NSString *callbackId = call.arguments[@"callbackId"];
    NSString *productId = call.arguments[@"productId"];
    NSString *transactionId = call.arguments[@"transactionId"];
    NSString *deduplicationId = call.arguments[@"deduplicationId"];
    NSString *strCallbackParametersJson = call.arguments[@"callbackParameters"];
    NSString *strPartnerParametersJson = call.arguments[@"partnerParameters"];

    // create event object
    ADJEvent *adjustEvent = [[ADJEvent alloc] initWithEventToken:eventToken];

    // revenue
    if ([self isFieldValid:revenue]) {
        double revenueValue = [revenue doubleValue];
        [adjustEvent setRevenue:revenueValue currency:currency];
    }

    // product ID
    if ([self isFieldValid:productId]) {
        [adjustEvent setProductId:productId];
    }

    // transaction ID
    if ([self isFieldValid:transactionId]) {
        [adjustEvent setTransactionId:transactionId];
    }

    // deduplication ID
    if ([self isFieldValid:deduplicationId]) {
        [adjustEvent setDeduplicationId:deduplicationId];
    }

    // callback ID
    if ([self isFieldValid:callbackId]) {
        [adjustEvent setCallbackId:callbackId];
    }

    // callback parameters
    if (strCallbackParametersJson != nil) {
        NSData *callbackParametersData = [strCallbackParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id callbackParametersJson = [NSJSONSerialization JSONObjectWithData:callbackParametersData
                                                                    options:0
                                                                      error:NULL];
        for (id key in callbackParametersJson) {
            NSString *value = [callbackParametersJson objectForKey:key];
            [adjustEvent addCallbackParameter:key value:value];
        }
    }

    // partner parameters
    if (strPartnerParametersJson != nil) {
        NSData *partnerParametersData = [strPartnerParametersJson dataUsingEncoding:NSUTF8StringEncoding];
        id partnerParametersJson = [NSJSONSerialization JSONObjectWithData:partnerParametersData
                                                                   options:0
                                                                     error:NULL];
        for (id key in partnerParametersJson) {
            NSString *value = [partnerParametersJson objectForKey:key];
            [adjustEvent addPartnerParameter:key value:value];
        }
    }

    // verify and track app store purchase
    [Adjust verifyAndTrackAppStorePurchase:adjustEvent
                     withCompletionHandler:^(ADJPurchaseVerificationResult * _Nonnull verificationResult) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if (verificationResult == nil) {
            result(dictionary);
        }
        
        [self addValueOrEmpty:verificationResult.verificationStatus
                      withKey:@"verificationStatus"
                 toDictionary:dictionary];
        [self addValueOrEmpty:[NSString stringWithFormat:@"%d", verificationResult.code]
                      withKey:@"code"
                 toDictionary:dictionary];
        [self addValueOrEmpty:verificationResult.message
                      withKey:@"message"
                 toDictionary:dictionary];
        result(dictionary);
    }];
}

- (void)getLastDeeplink:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust lastDeeplinkWithCompletionHandler:^(NSURL * _Nullable lastDeeplink) {
        if (![self isFieldValid:lastDeeplink]) {
            result(nil);
        } else {
            result([lastDeeplink absoluteString]);
        }
    }];
}

#pragma mark - Testing only methods

- (void)setTestOptions:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableDictionary *testOptions = [[NSMutableDictionary alloc] init];

    if (call.arguments[@"urlOverwrite"] != nil) {
        [testOptions setObject:call.arguments[@"urlOverwrite"] forKey:@"testUrlOverwrite"];
    }
    if (call.arguments[@"extraPath"] != nil) {
        [testOptions setObject:call.arguments[@"extraPath"] forKey:@"extraPath"];
    }
    if (call.arguments[@"basePath"] != nil) {
        [testOptions setObject:call.arguments[@"basePath"] forKey:@"basePath"];
    }
    if (call.arguments[@"timerIntervalInMilliseconds"] != nil) {
        [testOptions setObject:call.arguments[@"timerIntervalInMilliseconds"] forKey:@"timerIntervalInMilliseconds"];
    }
    if (call.arguments[@"timerStartInMilliseconds"] != nil) {
        [testOptions setObject:call.arguments[@"timerStartInMilliseconds"] forKey:@"timerStartInMilliseconds"];
    }
    if (call.arguments[@"sessionIntervalInMilliseconds"] != nil) {
        [testOptions setObject:call.arguments[@"sessionIntervalInMilliseconds"] forKey:@"sessionIntervalInMilliseconds"];
    }
    if (call.arguments[@"subsessionIntervalInMilliseconds"] != nil) {
        [testOptions setObject:call.arguments[@"subsessionIntervalInMilliseconds"] forKey:@"subsessionIntervalInMilliseconds"];
    }
    if (call.arguments[@"teardown"] != nil) {
        [testOptions setObject:call.arguments[@"teardown"] forKey:@"teardown"];
        if ([testOptions[@"teardown"] isEqualToString:@"true"] == YES) {
            [AdjustSdkDelegate teardown];
        }
    }
    if (call.arguments[@"resetSdk"] != nil) {
        [testOptions setObject:call.arguments[@"resetSdk"] forKey:@"resetSdk"];
    }
    if (call.arguments[@"deleteState"] != nil) {
        [testOptions setObject:call.arguments[@"deleteState"] forKey:@"deleteState"];
    }
    if (call.arguments[@"resetTest"] != nil) {
        [testOptions setObject:call.arguments[@"resetTest"] forKey:@"resetTest"];
    }
    if (call.arguments[@"noBackoffWait"] != nil) {
        [testOptions setObject:call.arguments[@"noBackoffWait"] forKey:@"noBackoffWait"];
    }
    if (call.arguments[@"adServicesFrameworkEnabled"] != nil) {
        [testOptions setObject:call.arguments[@"adServicesFrameworkEnabled"] forKey:@"adServicesFrameworkEnabled"];
    }
    if (call.arguments[@"attStatus"] != nil) {
        [testOptions setObject:call.arguments[@"attStatus"] forKey:@"attStatusInt"];
    }
    if (call.arguments[@"idfa"] != nil) {
        [testOptions setObject:call.arguments[@"idfa"] forKey:@"idfa"];
    }

    [Adjust setTestOptions:testOptions];
}

#pragma mark - Android only methods

- (void)getGoogleAdId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"getGoogleAdId not available on iOS platform!"
                               details:nil]);
}

- (void)trackPlayStoreSubscription:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"trackPlayStoreSubscription not available on iOS platform!"
                               details:nil]);
}

- (void)verifyPlayStorePurchase:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"verifyPlayStorePurchase not available on iOS platform!"
                               details:nil]);
}

- (void)verifyAndTrackPlayStorePurchase:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"verifyAndTrackPlayStorePurchase not available on iOS platform!"
                               details:nil]);
}

#pragma mark - Utility & helper methods

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return NO;
    }

    // check if its an instance of the singleton NSNull
    if ([field isKindOfClass:[NSNull class]]) {
        return NO;
    }

    // if field can be converted to a string, check if it has any content
    NSString *str = [NSString stringWithFormat:@"%@", field];
    if (str != nil) {
        if ([str length] == 0) {
            return NO;
        }
    }

    return YES;
}

- (void)addValueOrEmpty:(NSObject *)value
                withKey:(NSString *)key
           toDictionary:(NSMutableDictionary *)dictionary {
    if (nil != value) {
        [dictionary setObject:[NSString stringWithFormat:@"%@", value] forKey:key];
    } else {
        [dictionary setObject:@"" forKey:key];
    }
}

- (void)addNumberOrEmpty:(NSNumber *)value
                 withKey:(NSString *)key
            toDictionary:(NSMutableDictionary *)dictionary {
    if (nil != value) {
        [dictionary setObject:[value stringValue] forKey:key];
    } else {
        [dictionary setObject:@"" forKey:key];
    }
}

@end
