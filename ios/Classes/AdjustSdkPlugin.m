#import "AdjustSdkPlugin.h"

@implementation AdjustSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"com.adjust/api"
                                     binaryMessenger:[registrar messenger]];
    AdjustSdkPlugin* instance = [[AdjustSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"onCreate" isEqualToString:call.method]) {
        NSString *appToken         = call.arguments[@"appToken"];
        NSString *environment      = call.arguments[@"environment"];
        NSString *logLevel         = call.arguments[@"logLevel"];
        NSString *sdkPrefix        = call.arguments[@"sdkPrefix"];
        NSString *defaultTracker   = call.arguments[@"defaultTracker"];
        
        BOOL allowSuppressLogLevel = NO;
        
        NSString *userAgent             = call.arguments[@"userAgent"];
        NSString *secretId              = call.arguments[@"secretId"];
        NSString *info1                 = call.arguments[@"info1"];
        NSString *info2                 = call.arguments[@"info2"];
        NSString *info3                 = call.arguments[@"info3"];
        NSString *info4                 = call.arguments[@"info4"];
        
        NSString *delayStart            = call.arguments[@"delayStart"];
        NSString *isDeviceKnown         = call.arguments[@"isDeviceKnown"];
        NSString *eventBufferingEnabled = call.arguments[@"eventBufferingEnabled"];
        NSString *sendInBackground      = call.arguments[@"sendInBackground"];
        
        if ([self isFieldValid:logLevel]) {
            if ([ADJLogger logLevelFromString:[logLevel lowercaseString]] == ADJLogLevelSuppress) {
                allowSuppressLogLevel = YES;
            }
        }
        
        ADJConfig *adjustConfig = [ADJConfig configWithAppToken:appToken
                                                    environment:environment
                                          allowSuppressLogLevel:allowSuppressLogLevel];
        
        if ([self isFieldValid:logLevel]) {
            [adjustConfig setLogLevel:[ADJLogger logLevelFromString:[logLevel lowercaseString]]];
        }
        
        if ([self isFieldValid:eventBufferingEnabled]) {
            [adjustConfig setEventBufferingEnabled:[eventBufferingEnabled boolValue]];
        }
        
        if ([self isFieldValid:sdkPrefix]) {
            [adjustConfig setSdkPrefix:sdkPrefix];
        }
        
        if ([self isFieldValid:defaultTracker]) {
            [adjustConfig setDefaultTracker:defaultTracker];
        }

        if ([self isFieldValid:sendInBackground]) {
            [adjustConfig setSendInBackground:[sendInBackground boolValue]];
        }
        
        if ([self isFieldValid:userAgent]) {
            [adjustConfig setUserAgent:userAgent];
        }
        
        if ([self isFieldValid:delayStart]) {
            [adjustConfig setDelayStart:[delayStart doubleValue]];
        }
        
        if ([self isFieldValid:isDeviceKnown]) {
            [adjustConfig setIsDeviceKnown:[isDeviceKnown boolValue]];
        }
        
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
        
        [Adjust appDidLaunch:adjustConfig];
    } else if ([@"onResume" isEqualToString:call.method]) {
        [Adjust trackSubsessionStart];
    } else if ([@"onPause" isEqualToString:call.method]) {
        [Adjust trackSubsessionEnd];
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
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return NO;
    }
    
    // Check if its an instance of the singleton NSNull
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

@end
