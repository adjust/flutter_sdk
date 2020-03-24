//
//  AdjustSdk.m
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 6th June 2018.
//  Copyright © 2018 Adjust GmbH. All rights reserved.
//

#import "AdjustSdk.h"
#import "ADJSdkDelegate.h"
#import <Adjust/Adjust.h>

static NSString * const CHANNEL_API_NAME = @"com.adjust.sdk/api";

@interface ADJAdjustSdk ()

@property (nonatomic, retain) FlutterMethodChannel *channel;

@end

@implementation ADJAdjustSdk

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_API_NAME
                                                                binaryMessenger:[registrar messenger]];
    ADJAdjustSdk *instance = [[ADJAdjustSdk alloc] init];
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
    } else if ([@"setEnabled" isEqualToString:call.method]) {
        [self setEnabled:call withResult:result];
    } else if ([@"sendFirstPackages" isEqualToString:call.method]) {
        [self sendFirstPackages:call withResult:result];
    } else if ([@"gdprForgetMe" isEqualToString:call.method]) {
        [self gdprForgetMe:call withResult:result];
    } else if ([@"disableThirdPartySharing" isEqualToString:call.method]) {
        [self disableThirdPartySharing:call withResult:result];
    } else if ([@"getAttribution" isEqualToString:call.method]) {
        [self getAttribution:call withResult:result];
    } else if ([@"getIdfa" isEqualToString:call.method]) {
        [self getIdfa:call withResult:result];
    } else if ([@"getGoogleAdId" isEqualToString:call.method]) {
        [self getGoogleAdId:call withResult:result];
    } else if ([@"getSdkVersion" isEqualToString:call.method]) {
        [self getSdkVersion:call withResult:result];
    } else if ([@"setOfflineMode" isEqualToString:call.method]) {
        [self setOfflineMode:call withResult:result];
    } else if ([@"setPushToken" isEqualToString:call.method]) {
        [self setPushToken:call withResult:result];
    } else if ([@"appWillOpenUrl" isEqualToString:call.method]) {
        [self appWillOpenUrl:call withResult:result];
    } else if ([@"trackAdRevenue" isEqualToString:call.method]) {
        [self trackAdRevenue:call withResult:result];
    } else if ([@"setTestOptions" isEqualToString:call.method]) {
        [self setTestOptions:call withResult:result];
    } else if ([@"addSessionCallbackParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        NSString *value = call.arguments[@"value"];
        if (!([self isFieldValid:key]) || !([self isFieldValid:value])) {
            return;
        }
        [Adjust addSessionCallbackParameter:key value:value];
    } else if ([@"removeSessionCallbackParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        if (!([self isFieldValid:key])) {
            return;
        }
        [Adjust removeSessionCallbackParameter:key];
    } else if ([@"resetSessionCallbackParameters" isEqualToString:call.method]) {
        [Adjust resetSessionCallbackParameters];
    } else if ([@"addSessionPartnerParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        NSString *value = call.arguments[@"value"];
        if (!([self isFieldValid:key]) || !([self isFieldValid:value])) {
            return;
        }
        [Adjust addSessionPartnerParameter:key value:value];
    } else if ([@"removeSessionPartnerParameter" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        if (!([self isFieldValid:key])) {
            return;
        }
        [Adjust removeSessionPartnerParameter:key];
    } else if ([@"resetSessionPartnerParameters" isEqualToString:call.method]) {
        [Adjust resetSessionPartnerParameters];
    } else if ([@"isEnabled" isEqualToString:call.method]) {
        BOOL isEnabled = [Adjust isEnabled];
        result(@(isEnabled));
    } else if ([@"getAdid" isEqualToString:call.method]) {
        result([Adjust adid]);
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
    NSString *userAgent = call.arguments[@"userAgent"];
    NSString *secretId = call.arguments[@"secretId"];
    NSString *info1 = call.arguments[@"info1"];
    NSString *info2 = call.arguments[@"info2"];
    NSString *info3 = call.arguments[@"info3"];
    NSString *info4 = call.arguments[@"info4"];
    NSString *delayStart = call.arguments[@"delayStart"];
    NSString *isDeviceKnown = call.arguments[@"isDeviceKnown"];
    NSString *eventBufferingEnabled = call.arguments[@"eventBufferingEnabled"];
    NSString *sendInBackground = call.arguments[@"sendInBackground"];
    NSString *allowiAdInfoReading = call.arguments[@"allowiAdInfoReading"];
    NSString *allowIdfaReading = call.arguments[@"allowIdfaReading"];
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
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:appToken
                                                environment:environment
                                      allowSuppressLogLevel:allowSuppressLogLevel];

    // SDK prefix.
    if ([self isFieldValid:sdkPrefix]) {
        [adjustConfig setSdkPrefix:sdkPrefix];
    }

    // Log level.
    if ([self isFieldValid:logLevel]) {
        [adjustConfig setLogLevel:[ADJLogger logLevelFromString:[logLevel lowercaseString]]];
    }

    // Event buffering.
    if ([self isFieldValid:eventBufferingEnabled]) {
        [adjustConfig setEventBufferingEnabled:[eventBufferingEnabled boolValue]];
    }
    
    // Default tracker.
    if ([self isFieldValid:defaultTracker]) {
        [adjustConfig setDefaultTracker:defaultTracker];
    }

    // External device ID.
    if ([self isFieldValid:externalDeviceId]) {
        [adjustConfig setExternalDeviceId:externalDeviceId];
    }

    // User agent.
    if ([self isFieldValid:userAgent]) {
        [adjustConfig setUserAgent:userAgent];
    }

    // Background tracking.
    if ([self isFieldValid:sendInBackground]) {
        [adjustConfig setSendInBackground:[sendInBackground boolValue]];
    }

    // Allow iAd info reading.
    if ([self isFieldValid:allowiAdInfoReading]) {
        [adjustConfig setAllowiAdInfoReading:[allowiAdInfoReading boolValue]];
    }

    // Allow IDFA reading.
    if ([self isFieldValid:allowIdfaReading]) {
        [adjustConfig setAllowIdfaReading:[allowIdfaReading boolValue]];
    }

    // Set device known.
    if ([self isFieldValid:isDeviceKnown]) {
        [adjustConfig setIsDeviceKnown:[isDeviceKnown boolValue]];
    }

    // Delayed start.
    if ([self isFieldValid:delayStart]) {
        [adjustConfig setDelayStart:[delayStart doubleValue]];
    }
    
    // App secret.
    if ([self isFieldValid:secretId]
        && [self isFieldValid:info1]
        && [self isFieldValid:info2]
        && [self isFieldValid:info3]
        && [self isFieldValid:info4]) {
        [adjustConfig setAppSecret:[[NSNumber numberWithLongLong:[secretId longLongValue]] unsignedIntegerValue]
                             info1:[[NSNumber numberWithLongLong:[info1 longLongValue]] unsignedIntegerValue]
                             info2:[[NSNumber numberWithLongLong:[info2 longLongValue]] unsignedIntegerValue]
                             info3:[[NSNumber numberWithLongLong:[info3 longLongValue]] unsignedIntegerValue]
                             info4:[[NSNumber numberWithLongLong:[info4 longLongValue]] unsignedIntegerValue]];
    }

    // Callbacks.
    if (dartAttributionCallback != nil
        || dartSessionSuccessCallback != nil
        || dartSessionFailureCallback != nil
        || dartEventSuccessCallback != nil
        || dartEventFailureCallback != nil
        || dartDeferredDeeplinkCallback != nil) {
        [adjustConfig setDelegate:
         [ADJSdkDelegate getInstanceWithSwizzleOfAttributionCallback:dartAttributionCallback
                                              sessionSuccessCallback:dartSessionSuccessCallback
                                              sessionFailureCallback:dartSessionFailureCallback
                                                eventSuccessCallback:dartEventSuccessCallback
                                                eventFailureCallback:dartEventFailureCallback
                                            deferredDeeplinkCallback:dartDeferredDeeplinkCallback
                                        shouldLaunchDeferredDeeplink:launchDeferredDeeplink
                                                    andMethodChannel:self.channel]];
    }

    // Start SDK.
    [Adjust appDidLaunch:adjustConfig];
    [Adjust trackSubsessionStart];
    result(nil);
}

- (void)trackEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventToken = call.arguments[@"eventToken"];
    NSString *revenue = call.arguments[@"revenue"];
    NSString *currency = call.arguments[@"currency"];
    NSString *callbackId = call.arguments[@"callbackId"];
    NSString *transactionId = call.arguments[@"transactionId"];
    NSString *strCallbackParametersJson = call.arguments[@"callbackParameters"];
    NSString *strPartnerParametersJson = call.arguments[@"partnerParameters"];

    // Create event object.
    ADJEvent *adjustEvent = [ADJEvent eventWithEventToken:eventToken];

    // Revenue.
    if ([self isFieldValid:revenue]) {
        double revenueValue = [revenue doubleValue];
        [adjustEvent setRevenue:revenueValue currency:currency];
    }

    // Transaction ID.
    if ([self isFieldValid:transactionId]) {
        [adjustEvent setTransactionId:transactionId];
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

- (void)setEnabled:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *isEnabled = call.arguments[@"isEnabled"];
    if ([self isFieldValid:isEnabled]) {
        [Adjust setEnabled:[isEnabled boolValue]];
    }
    result(nil);
}

- (void)sendFirstPackages:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust sendFirstPackages];
    result(nil);
}

- (void)gdprForgetMe:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust gdprForgetMe];
    result(nil);
}

- (void)disableThirdPartySharing:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [Adjust disableThirdPartySharing];
    result(nil);
}

- (void)setOfflineMode:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *isOffline = call.arguments[@"isOffline"];
    if ([self isFieldValid:isOffline]) {
        [Adjust setOfflineMode:[isOffline boolValue]];
    }
    result(nil);
}

- (void)setPushToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *pushToken = call.arguments[@"pushToken"];
    if ([self isFieldValid:pushToken]) {
        [Adjust setPushToken:pushToken];
    }
    result(nil);
}

- (void)appWillOpenUrl:(FlutterMethodCall *)call withResult:(FlutterResult)result {
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
    [Adjust appWillOpenUrl:url];
}

- (void)trackAdRevenue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *source = call.arguments[@"source"];
    NSString *payload = call.arguments[@"payload"];
    if (!([self isFieldValid:source]) || !([self isFieldValid:payload])) {
        return;
    }
    NSData *dataPayload = [payload dataUsingEncoding:NSUTF8StringEncoding];
    [Adjust trackAdRevenue:source payload:dataPayload];
}

- (void)getAttribution:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    ADJAttribution *attribution = [Adjust attribution];
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
    [self addValueOrEmpty:attribution.adid withKey:@"adid" toDictionary:dictionary];
    result(dictionary);
}

- (void)getIdfa:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *idfa = [Adjust idfa];
    result(idfa);
}

- (void)getGoogleAdId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([FlutterError errorWithCode:@"non_existing_method"
                               message:@"getGoogleAdId not available for iOS platform"
                               details:nil]);
}

- (void)getSdkVersion:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *sdkVersion = [Adjust sdkVersion];
    result(sdkVersion);
}

- (void)setTestOptions:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    AdjustTestOptions *testOptions = [[AdjustTestOptions alloc] init];
    NSString *baseUrl = call.arguments[@"baseUrl"];
    NSString *gdprUrl = call.arguments[@"gdprUrl"];
    NSString *basePath = call.arguments[@"basePath"];
    NSString *gdprPath = call.arguments[@"gdprPath"];
    NSString *timerIntervalInMilliseconds = call.arguments[@"timerIntervalInMilliseconds"];
    NSString *timerStartInMilliseconds = call.arguments[@"timerStartInMilliseconds"];
    NSString *sessionIntervalInMilliseconds = call.arguments[@"sessionIntervalInMilliseconds"];
    NSString *subsessionIntervalInMilliseconds = call.arguments[@"subsessionIntervalInMilliseconds"];
    NSString *teardown = call.arguments[@"teardown"];
    NSString *deleteState = call.arguments[@"deleteState"];
    NSString *noBackoffWait = call.arguments[@"noBackoffWait"];
    NSString *iAdFrameworkEnabled = call.arguments[@"iAdFrameworkEnabled"];
    
    if ([self isFieldValid:baseUrl]) {
        testOptions.baseUrl = baseUrl;
    }
    if ([self isFieldValid:gdprUrl]) {
        testOptions.gdprUrl = gdprUrl;
    }
    if ([self isFieldValid:basePath]) {
        testOptions.basePath = basePath;
    }
    if ([self isFieldValid:gdprPath]) {
        testOptions.gdprPath = gdprPath;
    }
    if ([self isFieldValid:timerIntervalInMilliseconds]) {
        testOptions.timerIntervalInMilliseconds = [NSNumber numberWithLongLong:[timerIntervalInMilliseconds longLongValue]];
    }
    if ([self isFieldValid:timerStartInMilliseconds]) {
        testOptions.timerStartInMilliseconds = [NSNumber numberWithLongLong:[timerStartInMilliseconds longLongValue]];
    }
    if ([self isFieldValid:sessionIntervalInMilliseconds]) {
        testOptions.sessionIntervalInMilliseconds = [NSNumber numberWithLongLong:[sessionIntervalInMilliseconds longLongValue]];
    }
    if ([self isFieldValid:subsessionIntervalInMilliseconds]) {
        testOptions.subsessionIntervalInMilliseconds = [NSNumber numberWithLongLong:[subsessionIntervalInMilliseconds longLongValue]];
    }
    if ([self isFieldValid:teardown]) {
        testOptions.teardown = [teardown boolValue];
        if (testOptions.teardown) {
            [ADJSdkDelegate teardown];
        }
    }
    if ([self isFieldValid:deleteState]) {
        testOptions.deleteState = [deleteState boolValue];
    }
    if ([self isFieldValid:noBackoffWait]) {
        testOptions.noBackoffWait = [noBackoffWait boolValue];
    }
    if ([self isFieldValid:iAdFrameworkEnabled]) {
        testOptions.iAdFrameworkEnabled = [iAdFrameworkEnabled boolValue];
    }
    
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

@end
