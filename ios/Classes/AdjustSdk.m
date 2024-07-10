//
//  AdjustSdk.m
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 6th June 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import "AdjustSdk.h"
#import "AdjustSdkDelegate.h"
#import <AdjustSdk/Adjust.h>

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
    if ([@"start" isEqualToString:call.method]) {
        [self start:call withResult:result];
    } else if ([@"onResume" isEqualToString:call.method]) {
        [Adjust trackSubsessionStart];
    } else if ([@"onPause" isEqualToString:call.method]) {
        [Adjust trackSubsessionEnd];
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
    } else if ([@"getGoogleAdId" isEqualToString:call.method]) {
        [self getGoogleAdId:call withResult:result];
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
    } else if ([@"trackPlayStoreSubscription" isEqualToString:call.method]) {
        [self trackPlayStoreSubscription:call withResult:result];
    } else if ([@"requestTrackingAuthorizationWithCompletionHandler" isEqualToString:call.method]) {
        [self requestTrackingAuthorizationWithCompletionHandler:call withResult:result];
    } else if ([@"getAppTrackingAuthorizationStatus" isEqualToString:call.method]) {
        [self getAppTrackingAuthorizationStatus:call withResult:result];
    } else if ([@"trackThirdPartySharing" isEqualToString:call.method]) {
        [self trackThirdPartySharing:call withResult:result];
    } else if ([@"trackMeasurementConsent" isEqualToString:call.method]) {
        [self trackMeasurementConsent:call withResult:result];
    }else if ([@"updateSkanConversionValue" isEqualToString:call.method ]){
        [self updateSkanConversionValue:call withResult:result];
    }else if ([@"addGlobalCallbackParameter" isEqualToString:call.method]) {
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
    } else if ([@"verifyPlayStorePurchase" isEqualToString:call.method]) {
        [self verifyAppStorePurchase:call withResult:result];
    } else if ([@"processDeeplink" isEqualToString:call.method]) {
        [self processDeeplink:call withResult:result];
    } else if ([@"processAndResolveDeeplink" isEqualToString:call.method]) {
        [self processAndResolveDeeplink:call withResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)start:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *appToken = call.arguments[@"appToken"];
    NSString *environment = call.arguments[@"environment"];
    NSString *logLevel = call.arguments[@"logLevel"];
    NSString *sdkPrefix = call.arguments[@"sdkPrefix"];
    NSString *defaultTracker = call.arguments[@"defaultTracker"];
    NSString *externalDeviceId = call.arguments[@"externalDeviceId"];
    NSString *domains = call.arguments[@"domains"];
    BOOL isDataResidency = [call.arguments[@"isDataResidency"] boolValue];
    BOOL useSubdomains = [call.arguments[@"useSubdomains"] boolValue];
    NSString *attConsentWaitingInterval = call.arguments[@"attConsentWaitingInterval"];
    NSString *sendInBackground = call.arguments[@"sendInBackground"];
    NSInteger eventDeduplicationIdsMaxSize = [call.arguments[@"eventDeduplicationIdsMaxSize"] integerValue];
    NSString *needsCost = call.arguments[@"needsCost"];
    NSString *linkMeEnabled = call.arguments[@"linkMeEnabled"];
    NSString *allowAdServicesInfoReading = call.arguments[@"allowAdServicesInfoReading"];
    NSString *allowIdfaReading = call.arguments[@"allowIdfaReading"];
    NSString *skAdNetworkHandling = call.arguments[@"skAdNetworkHandling"];
    NSString *readDeviceInfoOnceEnabled = call.arguments[@"readDeviceInfoOnceEnabled"];
    NSString *dartAttributionCallback = call.arguments[@"attributionCallback"];
    NSString *dartSessionSuccessCallback = call.arguments[@"sessionSuccessCallback"];
    NSString *dartSessionFailureCallback = call.arguments[@"sessionFailureCallback"];
    NSString *dartEventSuccessCallback = call.arguments[@"eventSuccessCallback"];
    NSString *dartEventFailureCallback = call.arguments[@"eventFailureCallback"];
    NSString *dartDeferredDeeplinkCallback = call.arguments[@"deferredDeeplinkCallback"];
    BOOL allowSuppressLogLevel = NO;
    BOOL launchDeferredDeeplink = [call.arguments[@"launchDeferredDeeplink"] boolValue];

    // Suppress log level.
    if ([self isFieldValid:logLevel]) {
        if ([ADJLogger logLevelFromString:[logLevel lowercaseString]] == ADJLogLevelSuppress) {
            allowSuppressLogLevel = YES;
        }
    }

    // Create config object.
    ADJConfig *adjustConfig = [[ADJConfig alloc] initWithAppToken:appToken
                                                      environment:environment andSuppressLogLevel:allowSuppressLogLevel];
    // SDK prefix.
    if ([self isFieldValid:sdkPrefix]) {
        [adjustConfig setSdkPrefix:sdkPrefix];
    }

    // Log level.
    if ([self isFieldValid:logLevel]) {
        [adjustConfig setLogLevel:[ADJLogger logLevelFromString:[logLevel lowercaseString]]];
    }

    // LinkMe.
    if ([self isFieldValid:linkMeEnabled]) {
        [adjustConfig enableLinkMe];
    }

    // Default tracker.
    if ([self isFieldValid:defaultTracker]) {
        [adjustConfig setDefaultTracker:defaultTracker];
    }

    // External device ID.
    if ([self isFieldValid:externalDeviceId]) {
        [adjustConfig setExternalDeviceId:externalDeviceId];
    }

    // URL strategy.
    if ([self isFieldValid:domains] && domains.length>0) {
        domains = [domains stringByReplacingOccurrencesOfString:@"[" withString:@""];
        domains = [domains stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSArray *urlStrategyDomainsArray = [domains componentsSeparatedByString:@","];
        [adjustConfig setUrlStrategy:urlStrategyDomainsArray withSubdomains:useSubdomains andDataResidency:isDataResidency];
    }

    // Background tracking.
    if ([self isFieldValid:sendInBackground]) {
        if ([sendInBackground boolValue]== YES) {
            [adjustConfig enableSendingInBackground];
        }
    }

    // eventDeduplicationIdsMaxSize.
    if (eventDeduplicationIdsMaxSize > 0) {
        [adjustConfig setEventDeduplicationIdsMaxSize:eventDeduplicationIdsMaxSize];
    }

    // Cost data.
    if ([self isFieldValid:needsCost]) {
        if ([needsCost boolValue]) {
            [adjustConfig enableCostDataInAttribution];
        }
    }

    // Allow AdServices info reading.
    if ([self isFieldValid:allowAdServicesInfoReading]) {
        if ([allowAdServicesInfoReading boolValue] == NO) {
            [adjustConfig disableAdServices];
        }
    }

    // Allow IDFA reading.
    if ([self isFieldValid:allowIdfaReading]) {
        if ([allowIdfaReading boolValue] == NO) {
            [adjustConfig disableIdfaReading];
        }
    }
    
    // SKAdNetwork handling.
    if ([self isFieldValid:skAdNetworkHandling]) {
        if ([skAdNetworkHandling boolValue] == NO) {
            [adjustConfig disableSkanAttribution];
        }
    }

    // Read device info once.
    if ([self isFieldValid:readDeviceInfoOnceEnabled]) {
        if ([readDeviceInfoOnceEnabled boolValue] == YES) {
            [adjustConfig enableDeviceIdsReadingOnce];
        }
    }

    // ATT consent delay.
    if ([self isFieldValid:attConsentWaitingInterval]) {
        [adjustConfig setAttConsentWaitingInterval:[attConsentWaitingInterval intValue]];
    }
    

    // Callbacks.
    if (dartAttributionCallback != nil
        || dartSessionSuccessCallback != nil
        || dartSessionFailureCallback != nil
        || dartEventSuccessCallback != nil
        || dartEventFailureCallback != nil
        || dartDeferredDeeplinkCallback != nil) {
        [adjustConfig setDelegate:
         [AdjustSdkDelegate getInstanceWithSwizzleOfAttributionCallback:dartAttributionCallback
                                                 sessionSuccessCallback:dartSessionSuccessCallback
                                                 sessionFailureCallback:dartSessionFailureCallback
                                                   eventSuccessCallback:dartEventSuccessCallback
                                                   eventFailureCallback:dartEventFailureCallback
                                               deferredDeeplinkCallback:dartDeferredDeeplinkCallback
                                           shouldLaunchDeferredDeeplink:launchDeferredDeeplink
                                                       andMethodChannel:self.channel]];
    }

    // Start SDK.
    [Adjust initSdk:adjustConfig];
    [Adjust trackSubsessionStart];
    result(nil);
}

- (void)trackEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventToken = call.arguments[@"eventToken"];
    NSString *revenue = call.arguments[@"revenue"];
    NSString *currency = call.arguments[@"currency"];
    NSString *callbackId = call.arguments[@"callbackId"];
    NSString *receipt = call.arguments[@"receipt"];
    NSString *productId = call.arguments[@"productId"];
    NSString *transactionId = call.arguments[@"transactionId"];
    NSString *deduplicationId = call.arguments[@"deduplicationId"];
    NSString *strCallbackParametersJson = call.arguments[@"callbackParameters"];
    NSString *strPartnerParametersJson = call.arguments[@"partnerParameters"];

    // Create event object.
    ADJEvent *adjustEvent = [[ADJEvent alloc] initWithEventToken:eventToken];

    // Revenue.
    if ([self isFieldValid:revenue]) {
        double revenueValue = [revenue doubleValue];
        [adjustEvent setRevenue:revenueValue currency:currency];
    }

    // Receipt.
    if ([self isFieldValid:receipt]) {
        NSData *receiptValue;
        receiptValue = [receipt dataUsingEncoding:NSUTF8StringEncoding];
        [adjustEvent setReceipt:receiptValue];
    }

    // Product ID.
    if ([self isFieldValid:productId]) {
        [adjustEvent setProductId:productId];
    }

    // Transaction ID.
    if ([self isFieldValid:transactionId]) {
        [adjustEvent setTransactionId:transactionId];
    }

    // Deduplication ID.
    if ([self isFieldValid:deduplicationId]) {
        [adjustEvent setDeduplicationId:deduplicationId];
    }

    // Callback ID.
    if ([self isFieldValid:callbackId]) {
        [adjustEvent setCallbackId:callbackId];
    }

    // Callback parameters.
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

    // Partner parameters.
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

    // Track event.
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
        [Adjust setPushToken:pushToken];
    }
    result(nil);
}

- (void)processDeeplink:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *urlString = call.arguments[@"url"];
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
    [Adjust processDeeplink:url];
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

    // Create ad revenue object.
    ADJAdRevenue *adjustAdRevenue = [[ADJAdRevenue alloc] initWithSource:source];

    // Revenue.
    if ([self isFieldValid:revenue]) {
        double revenueValue = [revenue doubleValue];
        [adjustAdRevenue setRevenue:revenueValue currency:currency];
    }

    // Ad impressions count.
    if ([self isFieldValid:adImpressionsCount]) {
        int adImpressionsCountValue = [adImpressionsCount intValue];
        [adjustAdRevenue setAdImpressionsCount:adImpressionsCountValue];
    }

    // Ad revenue network.
    if ([self isFieldValid:adRevenueNetwork]) {
        [adjustAdRevenue setAdRevenueNetwork:adRevenueNetwork];
    }
    
    // Ad revenue unit.
    if ([self isFieldValid:adRevenueUnit]) {
        [adjustAdRevenue setAdRevenueUnit:adRevenueUnit];
    }
    
    // Ad revenue placement.
    if ([self isFieldValid:adRevenuePlacement]) {
        [adjustAdRevenue setAdRevenuePlacement:adRevenuePlacement];
    }

    // Callback parameters.
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

    // Partner parameters.
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

    // Track ad revenue.
    [Adjust trackAdRevenue:adjustAdRevenue];
    result(nil);
}

- (void)trackPlayStoreSubscription:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"trackPlayStoreSubscription not available for iOS platform"
                               details:nil]);
}

- (void)trackAppStoreSubscription:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *price = call.arguments[@"price"];
    NSString *currency = call.arguments[@"currency"];
    NSString *transactionId = call.arguments[@"transactionId"];
    NSString *receipt = call.arguments[@"receipt"];
    NSString *transactionDate = call.arguments[@"transactionDate"];
    NSString *salesRegion = call.arguments[@"salesRegion"];
    // NSString *billingStore = call.arguments[@"billingStore"];
    NSString *strCallbackParametersJson = call.arguments[@"callbackParameters"];
    NSString *strPartnerParametersJson = call.arguments[@"partnerParameters"];

    // Price.
    NSDecimalNumber *priceValue;
    if ([self isFieldValid:price]) {
        priceValue = [NSDecimalNumber decimalNumberWithString:price];
    }

    // Receipt.
    NSData *receiptValue;
    if ([self isFieldValid:receipt]) {
        receiptValue = [receipt dataUsingEncoding:NSUTF8StringEncoding];
    }

    // Create subscription object.
    ADJAppStoreSubscription *subscription = [[ADJAppStoreSubscription alloc]
                                                 initWithPrice:priceValue
                                                 currency:currency
                                                 transactionId:transactionId
                                                 andReceipt:receiptValue];

    // Transaction date.
    if ([self isFieldValid:transactionDate]) {
        NSTimeInterval transactionDateInterval = [transactionDate doubleValue];
        NSDate *oTransactionDate = [NSDate dateWithTimeIntervalSince1970:transactionDateInterval];
        [subscription setTransactionDate:oTransactionDate];
    }

    // Sales region.
    if ([self isFieldValid:salesRegion]) {
        [subscription setSalesRegion:salesRegion];
    }

    // Callback parameters.
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

    // Partner parameters.
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

    // Track subscription.
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

- (void)getGoogleAdId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"getGoogleAdId not available for iOS platform"
                               details:nil]);
}

- (void)getSdkVersion:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust sdkVersionWithCompletionHandler:^(NSString * _Nullable sdkVersion) {
        result(sdkVersion);
    }];
}

- (void)requestTrackingAuthorizationWithCompletionHandler:(FlutterMethodCall *)call withResult:(FlutterResult)result {
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

    // Create third party sharing object.
    ADJThirdPartySharing *adjustThirdPartySharing = [[ADJThirdPartySharing alloc]
                                                     initWithIsEnabled:[self isFieldValid:isEnabled] ? isEnabled : nil];

    // Granular options.
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

    // Partner sharing settings.
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

    // Track third party sharing.
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
    [Adjust updateSkanConversionValue:conversionValue coarseValue:coarseValue lockWindow:lockWindow withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
        result(error.description);
    }];
}

- (void)verifyPlayStorePurchase:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"verifyPlayStorePurchase not available for iOS platform"
                               details:nil]);
}

- (void)verifyAppStorePurchase:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *receipt = call.arguments[@"receipt"];
    NSString *productId = call.arguments[@"productId"];
    NSString *transactionId = call.arguments[@"transactionId"];

    // Receipt.
    NSData *receiptValue;
    if ([self isFieldValid:receipt]) {
        receiptValue = [receipt dataUsingEncoding:NSUTF8StringEncoding];
    }

    // Create purchase instance.
    ADJAppStorePurchase *purchase = [[ADJAppStorePurchase alloc] initWithTransactionId:transactionId
                                                             productId:productId
                                                            andReceipt:receiptValue];

    // Verify purchase.
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

        [Adjust processAndResolveDeeplink:nsUrl withCompletionHandler:^(NSString * _Nullable resolvedLink) {
            if (![self isFieldValid:resolvedLink]) {
                result(nil);
            } else {
                result(resolvedLink);
            }
        }];
    }
}

- (void)setTestOptions:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableDictionary *testOptions = [[NSMutableDictionary alloc] init];

    [testOptions setObject:call.arguments[@"urlOverwrite"] forKey:@"testUrlOverwrite"];
    [testOptions setObject:call.arguments[@"extraPath"] forKey:@"testExtraPath"];
    [testOptions setObject:call.arguments[@"timerIntervalInMilliseconds"] forKey:@"testTimerIntervalInMilliseconds"];
    [testOptions setObject:call.arguments[@"timerStartInMilliseconds"] forKey:@"testTimerStartInMilliseconds"];
    [testOptions setObject:call.arguments[@"sessionIntervalInMilliseconds"] forKey:@"testSessionIntervalInMilliseconds"];
    [testOptions setObject:call.arguments[@"subsessionIntervalInMilliseconds"] forKey:@"testSubsessionIntervalInMilliseconds"];
    [testOptions setObject:call.arguments[@"teardown"] forKey:@"testTeardown"];
    [testOptions setObject:call.arguments[@"deleteState"] forKey:@"testDeleteState"];
    [testOptions setObject:call.arguments[@"noBackoffWait"] forKey:@"testNoBackoffWait"];
    [testOptions setObject:call.arguments[@"adServicesFrameworkEnabled"] forKey:@"testAdServicesFrameworkEnabled"];
    [testOptions setObject:call.arguments[@"attStatus"] forKey:@"testAttStatus"];
    [testOptions setObject:call.arguments[@"idfa"] forKey:@"testIdfa"];

    [Adjust setTestOptions:testOptions];
}

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return NO;
    }

    // Check if its an instance of the singleton NSNull.
    if ([field isKindOfClass:[NSNull class]]) {
        return NO;
    }

    // If field can be converted to a string, check if it has any content.
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
